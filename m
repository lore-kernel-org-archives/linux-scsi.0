Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C617406276;
	Tue, 28 Apr 2026 10:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372953; cv=none; b=GFqaKU9ob378/hnA24lMKcf5iD/cHmRXepF67/3EcEprIePNpPEVYwVh1QKJhx8KoHsINDZ+SSgqdum0BYz/IUhLDvN1GxtFeG1jTWY0H29jdFa4d5FQJWnbPU7iywzC68lbywQ5oXHs6AhmUEUIsauUtvZf/UtnevauqRqYW9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372953; c=relaxed/simple;
	bh=LPxp90wygznh+iB9GfB3SnpuT09Adhdr/GIGa1RwE/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lor4eJyCXy+l98h2feEY6yViszlsQ5586z87TUt1CO6h+nVU754FhqYyd6VuH/uNIqfHZ5kukTm4TypPYwNxGJXAyPqlZbHQzFhfBLMxTRWd3jIPM82yAd8+gjdgqNlFwIwbqGp4voqEc6+eZx/IzFciqtjkPwa99RSCYU+EMu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dyy6/nQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dyy6/nQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8F8C2BCB7;
	Tue, 28 Apr 2026 10:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372953;
	bh=LPxp90wygznh+iB9GfB3SnpuT09Adhdr/GIGa1RwE/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyy6/nQIahHi3PrlkCaqo7VPNnPUd+x6Tf2Hnz3JXHGJv2YaQzpWxglZAdLLpQxyS
	 15M36NrwMYfliPNDbmAGTxmG/3CBdqiNOrtae1Wt2RxbnCv9Se9z8UkUfj5ZSBDDmX
	 CWRMxKMm/ISxJDWduu/QtDrReF73/swRIGMQ2ETr0MOHPG4nYg0Xqkk0dnbUg6aaA1
	 u8lgWfKE75VJvPb6rFG4Q2A1y0DJbKIQhMJqqYa0PHBjU+IvyAwEXvjxADjQjAU07B
	 afDxzSIIhljyZIIwg+xOMNlUN+GH/U/ZWIEk2rSufNZmLqrawpDLPtSQ6n94xtCY/t
	 QdmUlXQ68Phnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joshua Daley <jdaley@linux.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	mst@redhat.com,
	jasowang@redhat.com,
	jejb@linux.ibm.com,
	virtualization@lists.linux-foundation.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] scsi: virtio_scsi: Move INIT_WORK calls to virtscsi_probe()
Date: Tue, 28 Apr 2026 06:40:53 -0400
Message-ID: <20260428104133.2858589-42-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joshua Daley <jdaley@linux.ibm.com>

[ Upstream commit da3159a3b3fdc05c6bdba2fd4f4802a6718d879a ]

The last step of virtscsi_handle_event() is to call
virtscsi_kick_event(), which calls INIT_WORK on its own work
item. INIT_WORK resets the work item's data bits to 0.

If this occurs while the work item is being flushed by
cancel_work_sync(), then kernel/workqueue.c/work_offqd_enable triggers a
kernel warning, as it expects the "disable" bit to be 1:

[   21.450115] workqueue: work disable count underflowed
[   21.450117] WARNING: CPU: 1 PID: 56 at kernel/workqueue.c:4328 enable_work+0x10a/0x120
...
[   21.450171] Call Trace:
[   21.450173]  [<000003db2e5bdc3e>] enable_work+0x10e/0x120
[   21.450176] ([<000003db2e5bdc3a>] enable_work+0x10a/0x120)
[   21.450178]  [<000003db2e5bdd86>] cancel_work_sync+0x86/0xa0
[   21.450181]  [<000003daae97d9e4>] virtscsi_remove+0xb4/0xd0 [virtio_scsi]
[   21.450184]  [<000003db2ef3b5ca>] virtio_dev_remove+0x6a/0xd0
[   21.450186]  [<000003db2ef9106c>] device_release_driver_internal+0x1ac/0x260
[   21.450190]  [<000003db2ef8edc8>] bus_remove_device+0xf8/0x190
[   21.450192]  [<000003db2ef88d72>] device_del+0x142/0x340
[   21.450194]  [<000003db2ef88fa0>] device_unregister+0x30/0xa0
[   21.450196]  [<000003db2ef3b2fa>] unregister_virtio_device+0x2a/0x40

This warning may occur if a controller is detached immediately following
a disk detach.

Move the INIT_WORK call to prevent this. Don't re-init event list work
items in virtscsi_kick_event(), init them only once in virtscsi_probe()
instead.

Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Link: https://patch.msgid.link/20260325180857.3675854-2-jdaley@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to complete the analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Record: `scsi: virtio_scsi` "Move INIT_WORK calls to virtscsi_probe()"
  — restructures INIT_WORK placement to avoid race with
  `cancel_work_sync()` during controller removal.

**Step 1.2: Tags**
- Record:
  - `Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>` (author)
  - `Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>` (subsystem
    expert)
  - `Link: https://patch.msgid.link/20260325180857.3675854-2-
    jdaley@linux.ibm.com` (mailing list)
  - `Signed-off-by: Martin K. Petersen` (SCSI maintainer, applied the
    patch)
  - No `Fixes:` tag, no `Cc: stable` (expected - this is why review is
    needed)
  - No `Reported-by:` but reproduction steps present in cover letter

**Step 1.3: Commit Body Analysis**
- Record: The commit describes a race where:
  - `virtscsi_handle_event()` (work function) calls
    `virtscsi_kick_event()` at the end
  - `virtscsi_kick_event()` calls `INIT_WORK` on the SAME work item that
    is currently executing
  - `INIT_WORK` resets work->data bits (including the workqueue disable
    count) to 0
  - If this happens while `cancel_work_sync()` is flushing the work,
    `work_offqd_enable` sees the disable count was cleared and triggers
    "work disable count underflowed" WARN
  - Includes a full stack trace on S390; trigger: "controller is
    detached immediately following a disk detach"

**Step 1.4: Hidden Bug Fix Detection**
- Record: Not hidden - clearly labeled as fixing a warning. Race
  condition fix disguised as "Move INIT_WORK".

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Record: 1 file (`drivers/scsi/virtio_scsi.c`), ~5 net lines added.
  Changed functions: `virtscsi_kick_event()` (INIT_WORK removed) and
  `virtscsi_probe()` (INIT_WORK loop added). Single-file surgical fix.

**Step 2.2: Code Flow**
- Record:
  - Before: `INIT_WORK(&event_node->work, virtscsi_handle_event)` called
    in `virtscsi_kick_event()`, which is invoked from both
    `virtscsi_kick_event_all()` (at probe/restore time) AND from
    `virtscsi_handle_event()` itself (re-queueing at end of event
    handling).
  - After: `INIT_WORK` called once in `virtscsi_probe()` inside a `for`
    loop over all 8 event_list entries (guarded by
    VIRTIO_SCSI_F_HOTPLUG). `virtscsi_kick_event()` no longer resets the
    work struct state.
  - Forward declaration of `virtscsi_handle_event` removed (probe is
    after the definition).

**Step 2.3: Bug Mechanism**
- Record: **Race condition fix** (category b from playbook). The issue
  is that `INIT_WORK` resets all state bits in `work->data` (including
  the disable count introduced in v6.10 by commit `86898fa6b8cd9`).
  Internally, `cancel_work_sync()` now calls `__cancel_work_sync(work,
  0)` → `__cancel_work(work, WORK_CANCEL_DISABLE)` which increments the
  disable count via `work_offqd_disable()`, then `__flush_work()` waits
  for the function to complete, then calls `enable_work()` to decrement.
  If the work function calls `INIT_WORK` during the flush, disable count
  goes 1→0; later `enable_work()` sees 0 and triggers `WARN_ONCE(true,
  "workqueue: work disable count underflowed\n")` at
  `kernel/workqueue.c:4422`.

**Step 2.4: Fix Quality**
- Record: Obviously correct. The INIT_WORK was redundant after the first
  call (work's function pointer doesn't change between kicks). Moving it
  to probe() eliminates the race. Low regression risk: the work struct
  state is preserved across kicks (no need to re-init), and it persists
  through freeze/resume cycles (virtscsi_freeze doesn't cancel work, so
  state remains intact).

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame of Buggy Code**
- Record: `INIT_WORK(&event_node->work, virtscsi_handle_event)` in
  `virtscsi_kick_event()` was introduced by commit `365a715009411`
  "[SCSI] virtio-scsi: hotplug support for virtio-scsi" (v3.6-rc1,
  2012). The pattern has existed unchanged for 13+ years in all stable
  trees.

**Step 3.2: No Fixes: Tag to Follow**
- Record: No Fixes: tag present. The WARN symptom was enabled by commit
  `86898fa6b8cd9` "workqueue: Implement disable/enable for (delayed)
  work items" which landed in **v6.10-rc1**. Before v6.10 the same race
  existed but did not trigger this specific WARN (cancel_work_sync
  didn't use the disable count).

**Step 3.3: File History**
- Record: Recent virtio_scsi.c history shows a related commit
  `2678369e8efe0` "virtio_scsi: fix DMA cacheline issues for events" (by
  Michael Tsirkin, Dec 2025) which restructured the event buffers. The
  currently analyzed patch applies cleanly on top of that. No patch
  dependencies required beyond the usual.

**Step 3.4: Author Context**
- Record: Joshua Daley (IBM); this is their first virtio_scsi fix.
  However, the patch was Reviewed-by Stefan Hajnoczi (original virtio-
  scsi author at IBM/RedHat and primary reviewer for virtio_scsi), and
  applied by Martin K. Petersen (SCSI maintainer).

**Step 3.5: Dependencies**
- Record: Standalone fix. A second patch in the series (2/2 "kick
  event_list unconditionally") is independent and addresses a different
  cleanup - not required for this one to work. This patch doesn't depend
  on the other.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Patch Discussion**
- Record: Retrieved full thread via `b4 mbox
  20260325180857.3675854-2-jdaley@linux.ibm.com`. Series is at v4.
  Previous versions (v1-v3) had different approaches (INIT_WORK moved to
  `virtscsi_init()` initially). Changelog notes v4 addresses bisection
  concerns (by placing this patch first in the series) and
  suspend/resume concerns (by choosing `virtscsi_probe()` rather than
  `virtscsi_init()`). **No stable nomination in the thread**, but the
  patch is clearly framed as a bug fix.

**Step 4.2: Reviewers**
- Record: Cc'd: linux-scsi, linux-kernel, virtualization list, MST,
  jasowang, pbonzini (QEMU/virtio maintainers), stefanha (virtio-scsi
  expert), eperezma, Martin Petersen (SCSI maintainer), and multiple IBM
  S390 engineers (mjrosato, farman, frankja). Stefan Hajnoczi's
  Reviewed-by tag confirms subsystem expert review.

**Step 4.3: Bug Report**
- Record: No syzbot report. The reporter is the author himself running
  tests on IBM S390 (evidenced by addresses in stack trace
  `000003db2e5...`). The cover letter documents that the warning is
  reliably reproducible by adding `msleep(1000)` before INIT_WORK and
  running `virsh detach-device disk; virsh detach-device controller`.

**Step 4.4: Related Patches**
- Record: The series "scsi: virtio_scsi: move INIT_WORK calls to
  virtscsi_probe" contains 2 patches, both applied by Martin K. Petersen
  to `7.1/scsi-queue` (`[1/2] da3159a3b3fd` and `[2/2] 0019a3a5756b`).

**Step 4.5: Stable-specific Discussion**
- Record: No explicit stable discussion in the thread. The v4 changelog
  does not mention stable.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions**
- Record: `virtscsi_kick_event` (INIT_WORK removed), `virtscsi_probe`
  (INIT_WORK loop added), `virtscsi_handle_event` (forward declaration
  removed since probe is below it).

**Step 5.2: Callers of `virtscsi_kick_event`**
- Record: `virtscsi_kick_event_all()` (called at probe and restore) and
  `virtscsi_handle_event()` (the work function itself, for re-queueing).
  `virtscsi_kick_event_all` is called from `virtscsi_probe()` and
  `virtscsi_restore()`.

**Step 5.3: Callees**
- Record: `virtscsi_kick_event` calls `sg_init_one`,
  `virtqueue_add_inbuf_cache_clean`, `virtqueue_kick`. None of these
  interact with work struct state.

**Step 5.4: Reachability**
- Record: The race path is reachable from userspace via standard device
  hotplug operations (virsh detach-device or equivalent QEMU API calls).
  Very common in cloud/virt environments.

**Step 5.5: Similar Patterns**
- Record: The anti-pattern of "calling INIT_WORK from within the work
  function on its own work_struct" is known to be racy with
  cancel_work_sync. This is why v6.10+ workqueue added the WARN to
  detect it.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code in Stable Trees**
- Record: Verified by reading
  `remotes/stable/linux-6.6.y:drivers/scsi/virtio_scsi.c` and
  `linux-6.12.y` — both have the exact same
  `INIT_WORK(&event_node->work, virtscsi_handle_event)` pattern in
  `virtscsi_kick_event()` and the same
  `virtscsi_probe()`/`virtscsi_remove()` structure. Code exists
  unchanged in all maintained stable trees (back to at least 5.15).

**Step 6.2: Backport Difficulty**
- Record: The patch should apply cleanly or with trivial adjustments.
  The surrounding code in `virtscsi_probe()` is similar across stable
  trees, though there was a recent reorganization (`2678369e8efe0`
  "virtio_scsi: fix DMA cacheline issues for events" in mainline, not in
  stable). In 6.12.y, `event_node->event` is still an inline struct (not
  a pointer); the patch's INIT_WORK change is independent of that.

**Step 6.3: Related Fixes in Stable**
- Record: No prior fix for this race in stable. The WARN_ONCE at
  kernel/workqueue.c:4422 was introduced in v6.10 (commit
  `86898fa6b8cd9`).

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- Record: `drivers/scsi/virtio_scsi.c` — virtio-scsi driver.
  Criticality: **IMPORTANT**. Used by essentially every KVM/QEMU-based
  virtualization stack (including cloud providers using KVM, libvirt,
  AWS EC2, GCP GCE, OpenStack).

**Step 7.2: Subsystem Activity**
- Record: Moderately active (~20 commits in recent history, many
  cleanup/refactoring). Core logic unchanged since v3.6.

## PHASE 8: IMPACT AND RISK

**Step 8.1: Affected Users**
- Record: All users of virtio-scsi on v6.10+ kernels who perform hotplug
  operations (disk/controller detach). This is a massive user base in
  virtualization.

**Step 8.2: Trigger Conditions**
- Record: Normal administrative workflow: detach a disk, then detach the
  controller immediately. Reproducible with standard virsh commands. Not
  privileged-user-triggerable from guest, but a host-side operation.

**Step 8.3: Failure Mode**
- Record: Kernel `WARN_ONCE` with stack trace in dmesg. **Severity:
  MEDIUM**. Not a crash, not data corruption, not security-relevant.
  But: user-visible warning that could trigger monitoring alerts, CI
  failures (many CI systems treat kernel WARN as failure), and user
  concern. The pre-v6.10 race still exists but without the visible WARN
  — potentially other subtle effects but not documented.

**Step 8.4: Risk vs Benefit**
- Record:
  - BENEFIT: Eliminates a user-visible kernel warning in a very common
    virtualization path. Moderate benefit.
  - RISK: Very low — 5 net lines, moves a single INIT_WORK call,
    reviewed by subsystem expert, applied by maintainer. The work struct
    state is correctly preserved across freeze/resume cycles.
  - Ratio: Favorable for backporting.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Real race condition with reproducible user-visible WARN
- Small, surgical fix (5 net lines)
- Reviewed by subsystem expert (Stefan Hajnoczi)
- Applied by SCSI maintainer (Martin K. Petersen)
- Code pattern identical in all stable trees v6.10+ where the WARN is
  triggered
- Common workflow (VM hotplug) triggers this bug
- Low regression risk

AGAINST backporting:
- Symptom is WARN, not crash/corruption
- No explicit Cc: stable nomination
- No Fixes: tag
- Race has existed since v3.6 without major user impact reports

**Step 9.2: Stable Rules**
1. Obviously correct: YES — trivially correct (just relocates INIT_WORK
   to run once)
2. Fixes real bug: YES — triggers WARN in v6.10+
3. Important issue: MEDIUM (WARN, not crash)
4. Small and contained: YES (5 lines, one file)
5. No new features: YES
6. Applies cleanly: YES for recent stable trees

**Step 9.3: Exception Categories**
- Record: Not an exception category (not device ID, quirk, DT, build, or
  doc fix). Regular bug fix.

**Step 9.4: Decision**
The fix addresses a reproducible race condition with a clear user-
visible symptom on v6.10+ kernels (6.12, 6.17, 6.18, 6.19 stable trees).
It has been reviewed by the virtio-scsi expert, applied by the SCSI
maintainer, and affects a widely-deployed driver (used in virtually all
KVM/QEMU VMs). The patch is minimal, correct, and low-risk. The symptom
is only a WARN (not a crash), but it occurs in common hotplug workflows
and the fix is safe.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Stefan Hajnoczi, Link to lore,
  Signed-off-by Martin K. Petersen; no Fixes/Cc stable tags
- [Phase 2] Diff analysis: 5 net lines changed in
  `drivers/scsi/virtio_scsi.c`; INIT_WORK moved from
  `virtscsi_kick_event` to a loop in `virtscsi_probe` guarded by
  VIRTIO_SCSI_F_HOTPLUG
- [Phase 3] `git log -S"INIT_WORK(&event_node->work"`: pattern
  introduced by `365a715009411` in v3.6-rc1 (2012)
- [Phase 3] `git describe --contains 365a715009411`: v3.6-rc1, confirmed
  pattern has been stable for 13+ years
- [Phase 3] `git log -S"work disable count underflowed"`: WARN
  introduced by `86898fa6b8cd9` in v6.10-rc1 — this is why the visible
  symptom only exists v6.10+
- [Phase 3] Read kernel/workqueue.c lines 4407-4499 to verify
  `enable_work()`/`__cancel_work_sync()` logic and confirm the race
  mechanism
- [Phase 3] Read include/linux/workqueue.h: confirmed `INIT_WORK` →
  `__INIT_WORK_KEY` → resets `work->data = WORK_DATA_INIT()` (all bits
  zeroed, clobbering disable count)
- [Phase 4] `b4 mbox 20260325180857.3675854-2-jdaley@linux.ibm.com`:
  retrieved full thread (7 messages, 2 reviewers, 1 apply confirmation)
- [Phase 4] Thread content confirmed: v4 is latest, Reviewed-by tag
  added, Martin K. Petersen applied to 7.1/scsi-queue
  (git.kernel.org/mkp/scsi/c/da3159a3b3fd)
- [Phase 4] No explicit stable nomination in the mailing list discussion
- [Phase 5] `grep "virtscsi_kick_event\b"`: 3 hits — function
  definition, call from `virtscsi_kick_event_all()` (probe/restore),
  call from `virtscsi_handle_event()` (re-queue after event processing)
- [Phase 6] Read `remotes/stable/linux-6.6.y:drivers/scsi/virtio_scsi.c`
  and `linux-6.12.y`: confirmed identical `INIT_WORK(&event_node->work,
  ...)` pattern in `virtscsi_kick_event()`, so fix applies conceptually
  cleanly
- [Phase 6] Confirmed via search that recent commit `2678369e8efe0`
  "virtio_scsi: fix DMA cacheline issues for events" changed the event
  buffer layout in mainline but doesn't affect the INIT_WORK move
- [Phase 7] Subsystem: virtio-scsi — widely used in all KVM/QEMU
  virtualization
- [Phase 8] Failure mode: `WARN_ONCE` at kernel/workqueue.c:4422, stack
  trace visible in dmesg; severity MEDIUM (not a
  crash/corruption/security)
- UNVERIFIED: Whether the pre-v6.10 race has any user-visible effect
  beyond the post-v6.10 WARN. The fix is still logically correct for
  pre-v6.10 but the symptom documentation only covers v6.10+.
- UNVERIFIED: Whether the fix requires any adjustment for stable trees
  (the diff in the thread differs slightly from the presented diff —
  presented diff has a few whitespace/context differences from the v4
  mailed patch, but the functional change is identical)

The commit is a small, well-reviewed bug fix for a reproducible race
condition that triggers a kernel WARN in a widely-deployed driver
(virtio-scsi used in essentially all KVM/QEMU VMs) on v6.10+ kernels.
The fix is minimal (5 net lines, one file), obviously correct (the work
struct doesn't need to be re-initialized on every kick), reviewed by the
subsystem expert (Stefan Hajnoczi), and applied by the SCSI maintainer.
Regression risk is very low.

**YES**

 drivers/scsi/virtio_scsi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0ed8558dad724..64b6c942f5720 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -233,7 +233,6 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
 };
 
-static void virtscsi_handle_event(struct work_struct *work);
 
 static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 			       struct virtio_scsi_event_node *event_node)
@@ -242,7 +241,6 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 	struct scatterlist sg;
 	unsigned long flags;
 
-	INIT_WORK(&event_node->work, virtscsi_handle_event);
 	sg_init_one(&sg, event_node->event, sizeof(struct virtio_scsi_event));
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
@@ -984,8 +982,11 @@ static int virtscsi_probe(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
-	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
+	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
+		for (int i = 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
+			INIT_WORK(&vscsi->event_list[i].work, virtscsi_handle_event);
 		virtscsi_kick_event_all(vscsi);
+	}
 
 	scsi_scan_host(shost);
 	return 0;
-- 
2.53.0

