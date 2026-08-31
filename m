Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B9B440A0B;
	Mon, 31 Aug 2026 13:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183231; cv=none; b=VoNUlyPrcrscex72COuBCWfj1TRU1Dzu0zd3qjCp99QSwjyicjGGLKWwdG0ISEdnpGVaB/0LhEQLvYSiGJSSyZZKSFSrD/q1hUCv4/f2EaVN4k089V5H+Jn1m8KC7OR1pJ1Rw+km7Raky4cSjmDeepfibR37FByjED0l8KShdu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183231; c=relaxed/simple;
	bh=tkpHD4DSeyuTAZYFKCHQdx8RPdkHr/iEr5XjPh7Q5q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZAUgFKj0Dc99Sy7l1gqGY09p6i/YSmvVnzP4UNmS7RUqCAi/tSbtslZX3D/Oe9FZFYNs79o3GgG/T5vXYPXXngURHE09d1Oae5Fdu1IDguOQtbRWZB3sl3H3hUs7lMlRqkSGqsfASsH/Kk5HRjcAqp4jyL/sHzt6H/HOZB+JgGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfpgBCww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfpgBCww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B3F1F000E9;
	Mon, 31 Aug 2026 13:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183229;
	bh=aDQ7Idb1BacoK/e+5mo9Tq1bAJsZONh8HmTGjZmF8bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfpgBCwwPBXFoyB6mF/aLL0snxTkADOw32ytUu5IxWaicl7yvO6R+9l1LMJ5H/SQ2
	 fJObvTMgmED2JQ5N/XwXFy1LRAWufR+WO9ufLLK75KhBYYpPCOpLd4buFQgzvkJw0G
	 qf15pxcOF+P3OooAiTE+ogCQnvYdSk7cE3ODeAT0Z9hH5vfV3DSoX2/wgroeS8Dl4v
	 X2rr9PbrzXC4v5xlruSlFz70WwlMMhSF4TeGnuICvraD/Rb3HsTIUHNVzvXofg+NKD
	 Y0oA4UbhePQa3zd1CiNqHbsSIynXYVdGrjnZ07SRqqyQ149ZYOwxduDezo+etyqYs/
	 6lCqeCKkHZ0Lg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zizhi Wo <wozizhi@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] scsi: core: Do not block on tag allocation in scsi_eh_lock_door()
Date: Mon, 31 Aug 2026 09:20:51 -0400
Message-ID: <20260831133314.4125787-23-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 732cb6bb37fd26863d5786522fb1997e7f5865b4 ]

scsi_eh_lock_door() is called from scsi_restart_operations() while the
host is still in the SHOST_RECOVERY state, i.e. before the host is
switched back to SHOST_RUNNING and scsi_run_host_queues() restarts the
queues. It allocates a request via scsi_alloc_request() with no flags,
so blk_mq_get_tag() may block waiting for a free sched tag when all tags
are already in use.

Those tags can be held by commands that were just requeued by
scsi_eh_flush_done_q() during error handling. Such commands cannot be
dispatched until the host leaves SHOST_RECOVERY and
scsi_run_host_queues() is called - which only happens *after*
scsi_eh_lock_door() returns.

This forms a circular dependency:

  - scsi_eh_lock_door(), running in the SCSI error handler thread, waits
    for a sched tag held by a requeued command;

  - the requeued command cannot complete and release its sched tag until
    the error handler thread leaves scsi_restart_operations() and restart
    the queues.

For devices with a single driver tag (e.g. USB storage) it is a
guaranteed deadlock and I/O that can never be submitted. This problem
has also been reproduced in our environment.

Locking the door is a best-effort operation, and scsi_eh_lock_door()
already returns silently when the request allocation fails. Pass
BLK_MQ_REQ_NOWAIT to scsi_alloc_request() so the allocation fails
instead of blocking when no tag is available. This breaks the circular
dependency and allows the error handler to finish restarting the queues,
after which the pending commands are dispatched normally.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260723041238.1584632-1-wozizhi@huaweicloud.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[scsi: core]` `[prevent/block]` — Do not block on tag
  allocation in `scsi_eh_lock_door()`.

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by`: Zizhi Wo `<wozizhi@huawei.com>` (author)
  - `Reviewed-by`: Bart Van Assche `<bvanassche@acm.org>` (SCSI
    maintainer)
  - `Link`: https://patch.msgid.link/20260723041238.1584632-1-
    wozizhi@huaweicloud.com
  - `Signed-off-by`: Martin K. Petersen (Oracle) `<mkp@kernel.org>`
    (committer)
  - No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or
    `Tested-by:` tags.
  - Notable: maintainer review present; author reports reproduction in
    their environment.

**Step 1.3 — Body analysis**
- Record:
  - **Bug**: Circular dependency during SCSI error recovery —
    `scsi_eh_lock_door()` blocks in `blk_mq_get_tag()` while host is
    still in `SHOST_RECOVERY`, but tags are held by commands requeued by
    `scsi_eh_flush_done_q()` that cannot dispatch until
    `scsi_run_host_queues()` runs *after* `scsi_eh_lock_door()` returns.
  - **Symptom**: Guaranteed deadlock on single-tag devices (e.g. USB
    storage); I/O permanently stuck.
  - **Root cause**: Blocking tag allocation during recovery restart.
  - **Fix**: Pass `BLK_MQ_REQ_NOWAIT` so allocation fails fast; door-
    lock is already best-effort (silent return on failure).

**Step 1.4 — Hidden bug fix?**
- Record: No — this is an explicit deadlock fix, not disguised cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Record: 1 file (`drivers/scsi/scsi_error.c`), 1 line changed (+1/-1).
  Function: `scsi_eh_lock_door()`. Scope: single-file surgical fix.

**Step 2.2 — Code flow change**
- Record:
  - **Before**: `scsi_alloc_request(..., 0)` → `blk_mq_get_tag()` may
    block indefinitely waiting for a sched tag.
  - **After**: `scsi_alloc_request(..., BLK_MQ_REQ_NOWAIT)` → returns
    `ERR_PTR(-EWOULDBLOCK)` immediately when no tag is available;
    existing `IS_ERR(req) return;` path handles it.

**Step 2.3 — Bug mechanism**
- Record: **Deadlock / lock ordering** — error-handler thread blocks on
  tag allocation while holding recovery state that prevents requeued
  commands from releasing tags. Category: synchronization deadlock in EH
  restart path.

**Step 2.4 — Fix quality**
- Record: Obviously correct. Minimal one-line change. Low regression
  risk — door locking is documented as best-effort; failure path already
  existed. Reviewed by SCSI maintainer.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record: `scsi_eh_lock_door()` exists since kernel 2.6 (commit
  `1da177e`). Blocking allocation introduced in `68ec3b819a5d6` ("scsi:
  add a scsi_alloc_request helper", 2021-10-22, first in v5.16). Present
  in this tree.

**Step 3.2 — Fixes: tag**
- Record: N/A — no `Fixes:` tag. Buggy behavior introduced by
  `68ec3b819a5d6`, which is an ancestor of HEAD.

**Step 3.3 — Related file history**
- Record: Recent `scsi_error.c` changes in 6.18.y include EH wake
  reliability fixes (`c7a1509123720`, `219f009ebfd1e`) but nothing
  addressing this deadlock. Standalone fix, not part of a series.

**Step 3.4 — Author context**
- Record: Zizhi Wo is not a regular SCSI maintainer (other work in blk-
  throttle, xfs, tty). This is a targeted bug report/fix.

**Step 3.5 — Dependencies**
- Record: None. `BLK_MQ_REQ_NOWAIT`, `scsi_alloc_request()` flags
  parameter, and `IS_ERR` handling all exist in this tree. `git apply
  --check` on the patch succeeds cleanly.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
- Record: `b4 dig -c 732cb6bb37fd2` found v1 only at https://patch.msgid
  .link/20260723041238.1584632-1-wozizhi@huaweicloud.com. Bart Van
  Assche replied with `Reviewed-by`. No NAKs or objections in thread.

**Step 4.2 — Reviewers**
- Record: `b4 dig -w` shows CC to James Bottomley, Martin Petersen, Bart
  Van Assche, linux-scsi, linux-kernel. Appropriate maintainers
  included.

**Step 4.3 — Bug report**
- Record: Author states "reproduced in our environment." No
  syzbot/bugzilla link. Real-world reproduction claimed.

**Step 4.4 — Series context**
- Record: `b4 dig -a` shows single v1 patch — standalone, no series
  dependencies.

**Step 4.5 — Stable list discussion**
- Record: No stable-specific discussion found in mbox thread (no "Cc:
  stable" mentions). Absence is neutral per instructions.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
- Record: `scsi_eh_lock_door()`, called from
  `scsi_restart_operations()`, which is called from
  `scsi_error_handler()`.

**Step 5.2 — Callers**
- Record: `scsi_restart_operations()` ← `scsi_error_handler()` (EH
  kernel thread, process context). Triggered on SCSI I/O
  failures/timeouts — common path for all SCSI block devices.

**Step 5.3 — Callees**
- Record: `scsi_alloc_request()` → `blk_mq_alloc_request()` →
  `blk_mq_get_tag()`. On failure with NOWAIT: `ERR_PTR(-EWOULDBLOCK)`.
  On success: `blk_execute_rq_nowait()`.

**Step 5.4 — Reachability**
- Record: Trigger requires SCSI EH after device reset with door locked
  (`sdev->was_reset && sdev->locked`). Verified in
  `scsi_restart_operations()` at line 2200. Host stays in
  `SHOST_RECOVERY` until line 2215
  (`scsi_host_set_state(SHOST_RUNNING)`), which is *after*
  `scsi_eh_lock_door()`. Requeued commands from `scsi_eh_flush_done_q()`
  use `blk_mq_requeue_request(..., !scsi_host_in_recovery(...))` —
  during recovery, `kick_requeue_list` is false, so they cannot
  dispatch. Reachable from normal block I/O error paths.

**Step 5.5 — Similar patterns**
- Record: Historical USB SCSI EH deadlocks fixed in `7daf480483e60` and
  `c69e6f812bab0` (same file, same subsystem concern).
  `BLK_MQ_REQ_NOWAIT` already used elsewhere in SCSI (`sg.c` documents
  why it avoids NOWAIT for userspace). This is the correct use case for
  NOWAIT.

---

## Phase 6: Cross-Referencing Against Local Tree

**Step 6.1 — Buggy code exists?**
- Record: **YES.** Local tree is `v6.18.44` (`linux-6.18.y`). Current
  code at line 2160 still has `scsi_alloc_request(sdev->request_queue,
  REQ_OP_DRV_IN, 0)`. Fix commit `732cb6bb37fd2` is on mainline but
  **not** in this tree.

**Step 6.2 — Backport complications**
- Record: Clean apply confirmed via `git apply --check`. No conflicts
  expected.

**Step 6.3 — Related fixes already present?**
- Record: No — `git log -S"BLK_MQ_REQ_NOWAIT" --
  drivers/scsi/scsi_error.c` returns nothing. Fix not yet backported.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
- Record: `drivers/scsi/scsi_error.c` — SCSI core error handling.
  **CORE/IMPORTANT** — affects all SCSI block storage (disks, USB
  storage, optical drives).

**Step 7.2 — Subsystem activity**
- Record: Actively maintained in 6.18.y with recent EH fixes
  (`c7a1509123720`, etc.).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
- Record: Users of SCSI block devices undergoing error recovery,
  especially USB storage (single tag) and optical media with door-lock
  after reset. Universal for SCSI-enabled kernels.

**Step 8.2 — Trigger conditions**
- Record: SCSI EH after reset on a device with locked door, with
  requeued commands occupying all queue tags. Reproducible per author;
  guaranteed on single-tag devices. Unprivileged users can trigger via
  normal I/O to removable media.

**Step 8.3 — Failure mode severity**
- Record: **CRITICAL** — permanent deadlock of EH thread; all I/O to
  affected device/host stuck indefinitely.

**Step 8.4 — Risk-benefit**
- Record: Benefit **very high** (prevents unrecoverable I/O hang). Risk
  **very low** (1-line change, existing failure path, best-effort
  operation). Strong positive ratio.

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Real, reproducible deadlock in SCSI EH restart path
- CRITICAL severity (permanent I/O hang)
- One-line, obviously correct fix
- Reviewed by SCSI maintainer (Bart Van Assche)
- Applies cleanly to 6.18.44
- Bug present since v5.16 (`scsi_alloc_request` migration)
- No dependencies or new APIs
- Historical precedent for USB/EH deadlock fixes in stable

**Evidence AGAINST backport:**
- None significant. Door-lock skip on tag exhaustion is acceptable
  (best-effort by design).

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — maintainer reviewed; author
   reproduced bug.
2. Fixes real bug? **PASS** — deadlock with concrete trigger.
3. Important issue? **PASS** — CRITICAL deadlock.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — clean apply verified.

**Exception category:** N/A (not a quirk/DT/build fix — standard bug
fix).

---

## Verification

- [Phase 1] `git show 732cb6bb37fd2`: parsed full commit message and
  tags
- [Phase 2] Diff: confirmed single-line `BLK_MQ_REQ_NOWAIT` change in
  `scsi_eh_lock_door()`
- [Phase 3] `git describe HEAD`: v6.18.44; `git blame` line 2160:
  blocking call from `68ec3b819a5d6` (v5.16)
- [Phase 3] `git merge-base --is-ancestor 68ec3b819a5d6 HEAD`: confirmed
  buggy code ancestor present
- [Phase 3] `git merge-base --is-ancestor 732cb6bb37fd2 HEAD`: fix NOT
  in tree
- [Phase 3] `git apply --check`: patch applies cleanly
- [Phase 4] `b4 dig -c 732cb6bb37fd2`: found lore thread
- [Phase 4] `b4 dig -w`: maintainers CC'd (Bottomley, Petersen, Van
  Assche)
- [Phase 4] `b4 dig -a`: single v1 patch, no series
- [Phase 4] mbox: Bart Van Assche `Reviewed-by`; no NAKs, no stable
  nomination
- [Phase 5] Read `scsi_restart_operations()`, `scsi_unjam_host()`,
  `scsi_eh_flush_done_q()`, `__scsi_queue_insert()`: confirmed recovery-
  state ordering and requeue behavior
- [Phase 5] Read `scsi_host_in_recovery()` in
  `include/scsi/scsi_host.h`: checks `SHOST_RECOVERY` etc.
- [Phase 5] Read `blk_mq_alloc_request()` / `blk_mq_get_tag()`: NOWAIT
  returns `ERR_PTR(-EWOULDBLOCK)` on no tag
- [Phase 6] Grep current tree line 2160: still uses flags `0` (buggy)
- [Phase 8] Confirmed `sdev->was_reset` set in
  `__scsi_report_device_reset()` during EH reset path

This commit fixes a real SCSI error-handler deadlock that can
permanently hang I/O — especially on single-tag USB storage — and the
fix is a minimal, reviewed, cleanly-applicable one-liner appropriate for
the 6.18.y stable tree.

**YES**

 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 13d46b6e0359e..857c2acc99645 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2157,7 +2157,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	struct scsi_cmnd *scmd;
 	struct request *req;
 
-	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, 0);
+	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(req))
 		return;
 	scmd = blk_mq_rq_to_pdu(req);
-- 
2.53.0

