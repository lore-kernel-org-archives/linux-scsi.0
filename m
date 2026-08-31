Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6973956C64B;
	Mon, 31 Aug 2026 13:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184108; cv=none; b=jeDeTfIgzpYJjagvm1N31fL8SvrUDnJ6loGJsZ5tH7SPewj3s3DneHpekQKa4H18d4q/no/YI1/9i0k4KQQ3WgBAgX+EH2mW3sMMAMxdiDCKWiO5oN16Eg+PU+U8cm2PDNr7S3sCS49lxR03BnsJmVdzhshi/lEE2EvtHdSjrXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184108; c=relaxed/simple;
	bh=xkXO7Xn9rTOeoxTnAPikfIGYnyGBWrQvEYDXsA/8l80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aNYtpB/soSC6wxDBgRqOfoXU/NiGuahJtdr/sP+D+RYuqtFXdMp6u9VFYeg/OohHcAKrcXvvAdwRnA14acBSs4uRtDDxq9Ih7d9ylj1pSxhb3mYHa6aMZaeJi5vdi8r4dAjU9rLqT1HDUKykCW+m1z0C+YZfQYjD9inneecssaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ewRK8erH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ewRK8erH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99F51F00ACF;
	Mon, 31 Aug 2026 13:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184105;
	bh=mhUV1L2AUmXHJKZbxJWi4kIFg3U6/9Hyhje/cu/Ziks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewRK8erHtjknv9LfeisT86BqkypZ728eVwBcA7BCnKIX2X0y8eiFF33duczP43Nwt
	 GqPEByOpEumlD5X0+FZueRS61hWVQBrJSOtU2TcSil9PoPEwEQsQOdiIQhcc5blKBv
	 LVSAp/wG7b27y0dcCyhzLZZ2lEMu8vxxYqlXQorv3gNQFyKqpSPjkDfVtG0spHuHTh
	 q1IPWMP9VlPcvRj5dawBBAn72x4vL73Y+sYP8YFoFi5f+Vez6rtjzSiWQp6OVTU4ju
	 WbDhVTIE/8HneNlVMGM6hNMObuDVVKj+iZCXJV6LXC1F3P8BnfY5zjLWGtoFrZs7iW
	 OcU4/N4/IPUiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kumar Meiyappan <kumar.meiyappan@microchip.com>,
	Sagar Biradar <sagar.biradar@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jinpu.wang@cloud.ionos.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] scsi: pm8001: Reject non-fatal dump when controller is crashed
Date: Mon, 31 Aug 2026 09:28:41 -0400
Message-ID: <20260831133314.4125787-493-sashal@kernel.org>
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

From: Kumar Meiyappan <kumar.meiyappan@microchip.com>

[ Upstream commit aa3b8f56ef27ed72394a752820abdec4608b731c ]

pm80xx_get_non_fatal_dump() can be called even after the controller has
entered a fatal error state. In that case the forensic memory contents
are not safe to access for a non-fatal dump request, and attempting to
do so can trigger a call trace.

Check controller_fatal_error before reading the non-fatal dump buffer
and return -EINVAL when the controller is already in a crashed state.

This prevents non-fatal dump collection from running in an invalid
controller state.

Signed-off-by: Kumar Meiyappan <kumar.meiyappan@microchip.com>
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
Link: https://patch.msgid.link/20260416154650.415624-1-sagar.biradar@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
Record: **[scsi: pm8001]** **[Reject]** — Reject non-fatal forensic dump
collection when the PMC-Sierra PM8001 controller is already in a fatal
error state.

### Step 1.2: Commit Message Tags
Record:
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** https://patch.msgid.link/20260416154650.415624-1-
  sagar.biradar@microchip.com
- **Cc: stable@** — present in original patch submission (verified via
  `b4 dig -w`)
- **Signed-off-by:** Kumar Meiyappan, Sagar Biradar, Martin K. Petersen
  (SCSI maintainer)

Notable: authors explicitly CC'd `stable@vger.kernel.org`; no syzbot or
user bug reports.

### Step 1.3: Commit Body Analysis
Record:
- **Bug:** `pm80xx_get_non_fatal_dump()` can run after the controller
  has entered fatal error state.
- **Symptom:** Attempting to read forensic memory in that state can
  trigger a kernel call trace.
- **Root cause:** Missing guard on `controller_fatal_error` before
  initiating non-fatal dump hardware access.
- **Fix approach:** Check `controller_fatal_error` and return `-EINVAL`
  early.
- **Version info:** none in commit message.

### Step 1.4: Hidden Bug Fix Detection
Record: **Yes, this is a straightforward bug fix** disguised as "reject"
rather than "fix", but it clearly prevents unsafe hardware access and
kernel call traces during error recovery.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
Record:
- **Files:** `drivers/scsi/pm8001/pm80xx_hwi.c` (+7 / -0)
- **Function modified:** `pm80xx_get_non_fatal_dump()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
Record:
- **Before:** After mapping host forensic buffer pointer, function
  immediately increments `non_fatal_count` and performs MMIO
  writes/reads to the crashed controller (`pm8001_mw32`, `pm8001_mr32`,
  `pm8001_cw32`).
- **After:** If `controller_fatal_error` is true, log debug message and
  return `-EINVAL` before any controller interaction.
- **Path affected:** Sysfs read of `non_fatal_log` via
  `non_fatal_log_show()` → `pm80xx_get_non_fatal_dump()`.

### Step 2.3: Bug Mechanism
Record:
- **Category:** Logic/correctness fix — unsafe hardware access in
  invalid controller state.
- **Mechanism:** After fatal firmware error (`controller_fatal_error =
  true` set in interrupt handler at line 4084), forensic DMA/MMIO
  operations are unsafe; the function lacked the same state check used
  elsewhere in the driver.

### Step 2.4: Fix Quality
Record:
- **Quality:** Obviously correct; mirrors existing driver pattern
  (`pm8001_sas.c` task path, `pm80xx_chip_soft_rst()`).
- **Regression risk:** Very low — only rejects an operation that should
  never succeed on a dead controller.
- **Red flags:** None.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame / Introduction
Record:
- Buggy function exists in local tree at
  `drivers/scsi/pm8001/pm80xx_hwi.c:387-503`.
- Non-fatal dump sysfs feature originally added in `dba2cc03b9db`
  (2020-03-16, "scsi: pm80xx: sysfs attribute for non fatal dump").
- `controller_fatal_error` exists at lines 1445, 1650, 4084 in current
  tree.
- Local autosel tree has squashed history; per-file `git blame` is not
  reliable for introduction dating.

### Step 3.2: Fixes Tag
Record: **N/A** — no `Fixes:` tag present.

### Step 3.3: Related File History
Record:
- Sibling upstream commit `2a8fbcfb04aa9` ("scsi: pm8001: Reject
  firmware update in fatal error state") from same author/date — same
  pattern, different sysfs path; also **not** in current HEAD.
- Standalone v1 patch; not part of a multi-patch series.

### Step 3.4: Author Context
Record: Kumar Meiyappan / Sagar Biradar are Microchip pm8001 driver
authors. Martin K. Petersen (SCSI maintainer) committed the fix upstream
as `aa3b8f56ef27`.

### Step 3.5: Dependencies
Record: **Standalone.** No prerequisite commits required.
`controller_fatal_error` field and `pm80xx_get_non_fatal_dump()` both
exist in this tree. Patch applies at line ~403 with clean context
(verified against upstream diff and local file).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
Record:
- **URL:** https://patch.msgid.link/20260416154650.415624-1-
  sagar.biradar@microchip.com
- **Series:** v1 only (no v2/v3)
- **Maintainer response:** Martin K. Petersen applied to 7.2/scsi-queue
  (May 22, 2026)
- **NAKs/concerns:** None found in thread
- **Stable nomination:** Authors CC'd `stable@vger.kernel.org` in
  original submission

### Step 4.2: Reviewers
Record: CC'd Martin K. Petersen, James Bottomley, Jack Wang, linux-scsi,
stable@, Brian King, Don Brace, and other Microchip engineers.

### Step 4.3: Bug Report
Record: No external bug report, syzbot, or stack trace in commit
message. Issue appears internally discovered by driver vendor during
fatal-error handling review.

### Step 4.4: Related Patches
Record: Related upstream fix `2a8fbcfb04aa9` for
`pm8001_store_update_fw()` — same failure class, separate commit. Not a
dependency for this fix.

### Step 4.5: Stable List History
Record: Patch was posted directly to stable@ (spinics stable archive).
No rejection or prior stable discussion found beyond the submission
itself.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
Record: `pm80xx_get_non_fatal_dump()` (modified), `non_fatal_log_show()`
(caller), fatal error ISR path setting `controller_fatal_error`.

### Step 5.2: Callers
Record:
- `non_fatal_log_show()` in `pm8001_ctl.c:588-591` directly returns
  result.
- Exposed as read-only sysfs host attribute `non_fatal_log` in
  `pm8001_host_attrs[]`.
- Called during diagnostic collection, typically by root/admin tooling
  after controller errors.

### Step 5.3: Callees
Record: `pm8001_mw32()`, `pm8001_mr32()`, `pm8001_cw32()` — MMIO
register access to potentially dead controller; forensic DMA buffer
reads from `FORENSIC_MEM`.

### Step 5.4: Reachability
Record:
- **Trigger chain:** Controller fatal firmware error → ISR sets
  `controller_fatal_error` → admin reads
  `/sys/class/scsi_host/hostN/non_fatal_log` → unsafe MMIO without
  guard.
- **Userspace reachable:** Yes, via sysfs read (requires appropriate
  permissions, typically root/CAP_SYS_ADMIN).

### Step 5.5: Similar Patterns
Record: Driver already guards fatal-error state in:
- `pm8001_sas.c:505` — task execution
- `pm80xx_hwi.c:1650` — soft reset MPI uninit
- `pm8001_sas.c:237-244` — phy control via `fatal_errors()`
- `pm8001_init.c:702-704` — NVMD read

This fix fills a gap in the same error-handling model.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
Record: **YES.** Local tree is **v6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`, `make kernelversion` → `6.18.43`).
`pm80xx_get_non_fatal_dump()` at lines 403-404 lacks
`controller_fatal_error` check. Upstream fix commit `aa3b8f56ef27` is
**NOT** an ancestor of HEAD.

### Step 6.2: Backport Complications
Record: **Clean apply expected.** Local file matches upstream pre-fix
context at the insertion point. No conflicting changes in that function
region.

### Step 6.3: Related Fixes Already Present?
Record: **No.** Neither `aa3b8f56ef27` (this fix) nor sibling
`2a8fbcfb04aa9` (firmware update guard) are in HEAD.
`non_fatal_log_show()` directly returns `ssize_t` from dump function, so
`-EINVAL` propagates correctly to sysfs (no need for separate error-code
fix `1b6f03b`).

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
Record: **drivers/scsi/pm8001** — PERIPHERAL driver (Microchip/PMC-
Sierra SAS HBA, `CONFIG_SCSI_PM8001`). Important for deployments using
this hardware, but not core kernel.

### Step 7.2: Subsystem Activity
Record: pm8001 driver is mature; forensic dump sysfs has existed since
2020. Recent upstream activity includes fatal-error handling hardening
from Microchip (April 2026).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
Record: **Driver-specific** — systems with PM8001/PM80xx SAS HBAs and
`CONFIG_SCSI_PM8001` enabled.

### Step 8.2: Trigger Conditions
Record:
- Controller must first enter fatal firmware error state (already a
  serious failure).
- Then sysfs read of `non_fatal_log` (diagnostic path during triage).
- **Likelihood:** Uncommon but realistic during failure investigation —
  exactly when admins collect dumps.
- **Privilege:** Typically root/admin.

### Step 8.3: Failure Mode Severity
Record:
- **Failure mode:** Kernel call trace from unsafe MMIO/DMA on dead
  controller.
- **Severity:** **MEDIUM-HIGH** — secondary kernel instability during
  already-critical failure recovery; not a normal-I/O-path crash, but
  can produce oops/warnings and complicate diagnostics.

### Step 8.4: Risk-Benefit
Record:
- **Benefit:** Prevents additional kernel call traces during HBA failure
  recovery; aligns driver error handling.
- **Risk:** Very low — 7-line guard, no API changes, no behavior change
  on healthy controllers.
- **Ratio:** Favorable for stable backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real bug with concrete trigger (fatal error + sysfs non_fatal dump
  read)
- Prevents kernel call trace / unsafe hardware access
- Small (7 lines), obviously correct, standalone
- Buggy code confirmed present in v6.18.43 tree
- Consistent with existing `controller_fatal_error` checks in same
  driver
- Authors CC'd stable@; SCSI maintainer merged upstream
- Clean apply expected

**AGAINST backport:**
- Narrow hardware scope (PM8001 SAS HBAs only)
- Only affects diagnostic sysfs path after controller already failed
- No syzbot report or public user bug report
- "Call trace" severity not fully documented with stack trace

**Unresolved:**
- Exact call trace type (WARN vs oops) not documented in commit message
- Introduction date of `controller_fatal_error` not determinable from
  squashed local git history (but field is present in tree)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is clear; maintainer-
   applied; no Tested-by but low complexity.
2. Fixes a real bug? **PASS** — unsafe operation on crashed controller.
3. Important issue? **PASS** — kernel call trace during failure recovery
   (medium-high severity).
4. Small and contained? **PASS** — 7 lines, 1 file, 1 function.
5. No new features/APIs? **PASS** — guard only.
6. Can apply to local tree? **PASS** — code exists, patch applies
   cleanly.

### Step 9.3: Exception Categories
Record: **None** — standard driver bug fix.

### Step 9.4: Decision Rationale
This is a small, vendor-submitted fix for a real gap in fatal-error
handling. The buggy code is present in the local **6.18.43** tree, the
fix is minimal and follows established driver patterns, and it prevents
additional kernel instability during exactly the scenario where
administrators are collecting diagnostic data from a failed HBA. The
risk is negligible and the authors explicitly nominated it for stable.

---

## Verification

- [Phase 1] Parsed subject, tags; confirmed stable@ CC in original
  submission via `b4 dig -w`
- [Phase 1] No Fixes:/Reported-by/syzbot tags
- [Phase 2] Read full `pm80xx_get_non_fatal_dump()` (lines 387-503);
  confirmed MMIO access after missing guard
- [Phase 2] Diff is +7 lines adding `controller_fatal_error` check
  returning `-EINVAL`
- [Phase 3] `git describe HEAD` → v6.18.43; `make kernelversion` →
  6.18.43
- [Phase 3] `git merge-base --is-ancestor aa3b8f56ef27 HEAD` →
  NOT_IN_HEAD (fix not yet applied)
- [Phase 3] `git show aa3b8f56ef27^` at lines 400-415 confirms buggy
  pre-fix code
- [Phase 3] `dba2cc03b9db` identified as 2020 introduction of non_fatal
  dump sysfs
- [Phase 3] Sibling commit `2a8fbcfb04aa9` found (fw update guard); also
  NOT_IN_HEAD
- [Phase 4] `b4 dig -c aa3b8f56ef27` → lore URL found
- [Phase 4] `b4 dig -a` → v1 only, no later revisions
- [Phase 4] `b4 dig -w` → stable@, Martin Petersen, James Bottomley CC'd
- [Phase 4] `b4 dig -m /tmp/pm8001_thread.mbox` → Martin Petersen
  "Applied to 7.2/scsi-queue"
- [Phase 5] `grep pm80xx_get_non_fatal_dump` → caller
  `non_fatal_log_show()` in pm8001_ctl.c:591
- [Phase 5] `grep controller_fatal_error` → used in pm80xx_hwi.c,
  pm8001_ctl.c, pm8001_sas.c, pm8001_sas.h
- [Phase 5] Fatal error set at pm80xx_hwi.c:4084 in interrupt handler
- [Phase 6] Buggy code confirmed at pm80xx_hwi.c:403-404 without guard
- [Phase 6] `non_fatal_log_show()` directly returns ssize_t — `-EINVAL`
  propagation works
- [Phase 8] CONFIG_SCSI_PM8001 confirmed in drivers/scsi/Kconfig:1494
- [UNVERIFIED] Exact kernel version when `controller_fatal_error` was
  introduced (squashed local history)
- [UNVERIFIED] Full stack trace / oops type from original bug report
  (not in commit message)

**YES**The background check finished: `aa3b8f56ef27` is **not** in this
tree (`v6.18.43`), and the buggy code is still present in
`pm80xx_get_non_fatal_dump()`.

The backport analysis stands: **YES** — this is a small, low-risk guard
that prevents kernel call traces when reading `non_fatal_log` on a
controller already in fatal error state.

 drivers/scsi/pm8001/pm80xx_hwi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 31960b72c1e92..1ce8226fcd292 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -401,6 +401,13 @@ ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
 	char *buf_copy = buf;
 
 	temp = (u32 *)pm8001_ha->memoryMap.region[FORENSIC_MEM].virt_ptr;
+
+	if (pm8001_ha->controller_fatal_error) {
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "non-fatal dump not available in fatal error state\n");
+		return -EINVAL;
+	}
+
 	if (++pm8001_ha->non_fatal_count == 1) {
 		if (pm8001_ha->chip_id == chip_8001) {
 			snprintf(pm8001_ha->forensic_info.data_buf.direct_data,
-- 
2.53.0

