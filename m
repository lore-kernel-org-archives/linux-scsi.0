Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325584014AB;
	Tue, 28 Apr 2026 10:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372945; cv=none; b=ihTv7cpbjq/BR5gAFo5OTxACdpyu5G4TSM627fhi55mZxfAzHDDs9Sso9QDPxCbrQsTiUSBJcvqZKGGmZlWa00PQr2mFUcY2PGcbj9uyB23VDcWUHt0XQTn5o9kcuCdPJgPBQtoc2eXb5pAbDCE7/iVfKDck3q0s/zccJgChG7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372945; c=relaxed/simple;
	bh=Shg8qwgvf8dpyvINFmXKwb4vpPxg4aSaIXQxsewIftA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nQKRMYcpOYbTkeH4oDBsGItiJM0ea/rjHAb0ANCDokaeeoA29SE1ebB4Tx+6QEyrVOYMpehclK5DYV5e6zmFH5GxikXy270a/5IxGR5SphFe81EPDkXUZBTt9N3Nhjx4nsy4jxLR24mqDutCtZxIlXbWazdd5V5+/jHU1B79XnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C3IkiiO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C3IkiiO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7782DC2BCAF;
	Tue, 28 Apr 2026 10:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372944;
	bh=Shg8qwgvf8dpyvINFmXKwb4vpPxg4aSaIXQxsewIftA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3IkiiO0f8MGYzh+3T1a4eqeDrxzoW2PoYAxouF9C37poO2UI7YVX/Vp+1o4wlYHq
	 uior7tQKzGQbuZq+e9+QlEECCcUR4qLBUAA7Rb5wEx/yefDqZXurZNfhWW5EciSBzx
	 XtN9IPr4mWo1NvvBJVquj/H3fiSWTLBf7IZScwp/V//RGZz1c3Ui8taIJK5OoBGYd9
	 EnbEyydpfSCoJcL+zFpTMeQ9DfdbbpnTEJkv4k4at9EeFz6BKZfVXrOLeCYkLTB1ZN
	 P5eWsKJLvUtXiXaVh9tdrpg+ZrSeMCw0SPt4FDgMcfbfG+L2TdPH/DKVoRpZzs9m0j
	 R7VV5noqQ12fw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	jejb@linux.ibm.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] scsi: lpfc: Fix incorrect txcmplq_cnt during cleanup in lpfc_sli_abort_ring()
Date: Tue, 28 Apr 2026 06:40:47 -0400
Message-ID: <20260428104133.2858589-36-sashal@kernel.org>
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

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 2da10bcaa58a389ca60f8e788180e0dca00739bc ]

When a port is offline in lpfc_sli_abort_ring, the phba->txcmplq is
cleared but the phba->txcmplq_cnt is not reset to zero.  This can
sometimes result in a phba->txcmplq_cnt that never reaches zero, which
hangs the cleanup process.

Update lpfc_sli_abort_ring so that txcmplq_cnt is reset to zero and also
ensure that the LPFC_IO_ON_TXCMPLQ flag is properly cleared.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://patch.msgid.link/20260212213008.149873-9-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to write a complete analysis.

# Analysis: scsi: lpfc: Fix incorrect txcmplq_cnt during cleanup in
lpfc_sli_abort_ring()

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse Subject Line
- Subsystem prefix: `scsi: lpfc:`
- Action verb: "Fix" (explicit bug fix)
- Record: SCSI/lpfc driver fix for incorrect `txcmplq_cnt` tracking
  during cleanup in `lpfc_sli_abort_ring()` (actual function is
  `lpfc_sli_abort_iocb_ring`)

### Step 1.2: Parse Commit Message Tags
- **Signed-off-by:** Justin Tee (author, Broadcom lpfc maintainer)
- **Link:** https://patch.msgid.link/20260212213008.149873-9-
  justintee8345@gmail.com (lore mailing list archive)
- **Signed-off-by:** Martin K. Petersen (SCSI maintainer)
- No Fixes: tag (expected for manual review candidates)
- No Cc: stable (expected for manual review candidates)
- No Reported-by tags
- Record: Standard upstream flow through SCSI maintainer; two SOB chain
  indicating proper review path.

### Step 1.3: Analyze Commit Body
- Bug: When port is offline (`pci_channel_offline`), `phba->txcmplq`
  list is cleared via `list_splice_init()` but `phba->txcmplq_cnt` is
  NOT reset to zero
- Symptom: "can sometimes result in a phba->txcmplq_cnt that never
  reaches zero, which hangs the cleanup process"
- Fix: Reset `txcmplq_cnt` to zero and clear `LPFC_IO_ON_TXCMPLQ` flag
  on iocbs
- Record: Bug causes cleanup hang during PCI channel offline (EEH error
  recovery); the author clearly understood the root cause

### Step 1.4: Hidden Bug Fix Detection
- This is an EXPLICIT bug fix ("Fix incorrect"), not disguised
- Record: Not a hidden fix; clearly labeled as bug fix

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory Changes
- 1 file: `drivers/scsi/lpfc/lpfc_sli.c`
- Net: -18 lines (24 insertions, 42 deletions)
- Only function modified: `lpfc_sli_abort_iocb_ring()`
- Record: Single-file surgical fix with refactoring consolidation

### Step 2.2: Code Flow Change
**BEFORE (offline path, both SLI_REV3 and SLI_REV4):**
- Held appropriate lock, splice `txcmplq` → local `txcmplq_completions`
- Did NOT reset `pring->txcmplq_cnt`
- Did NOT clear `LPFC_IO_ON_TXCMPLQ` flag on each iocb

**AFTER:**
- Single `plock` pointer (ring_lock or hbalock based on sli_rev)
- Consolidated SLI3/SLI4 duplicated blocks into one
- For offline: clears `LPFC_IO_ON_TXCMPLQ` flag on each iocb, splices to
  `tx_completions`, **resets `pring->txcmplq_cnt = 0`**

### Step 2.3: Bug Mechanism
Classification: **Logic/correctness fix + refactoring**
- Missing counter reset: `pring->txcmplq_cnt = 0` when list is cleared
- Missing flag clearing: `iocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ`
- Record: Offline splice path never decremented counter or cleared per-
  iocb flag, causing stuck counter

### Step 2.4: Fix Quality
- Follows identical pattern established in `lpfc_hba_down_post_s4()`
  lines 4705/4709 and `lpfc_hba_down_post_s3()` lines 4731/4735 which
  already do both (flag clear + count reset)
- Refactoring is mechanical - no change in lock semantics (still uses
  `pring->ring_lock` for SLI4, `phba->hbalock` for SLI3)
- Same `lpfc_sli_cancel_iocbs()` called on the iocbs as before
- Record: Fix quality high; pattern matches existing correct code

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame Analysis
```
a4691038b4071 (James Smart 2022-03-16) introduced the offline branch
```
- Buggy offline handling added in v5.18 (commit `a4691038b4071f` -
  "scsi: lpfc: Fix unload hang after back to back PCI EEH faults")
- Record: Bug present since v5.18; code in many stable trees (v5.18,
  v5.19, v6.0, v6.1.y, v6.6.y, v6.12.y)

### Step 3.2: Follow Fixes: Tag
- No Fixes: tag present
- Root cause commit identified via blame: `a4691038b4071f` is in v5.18
- Record: Original commit a4691038 went into v5.18 and IS present in
  stable trees

### Step 3.3: File History
- `lpfc_sli.c` actively developed; recent commits mostly lpfc version
  updates
- No intermediate fix attempts found for `txcmplq_cnt` issue
- Record: Standalone fix, not part of larger series

### Step 3.4: Author Context
- Justin Tee is the primary lpfc maintainer at Broadcom with many
  commits to this driver
- Record: Author is subsystem maintainer - strong credibility signal

### Step 3.5: Dependencies
- Self-contained change to one function
- Uses existing helpers (`list_splice_init`, `lpfc_sli_cancel_iocbs`,
  `lpfc_sli_issue_abort_iotag`) that exist in all stable trees
- Record: No dependencies; applies standalone

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Find Original Discussion
- `b4 dig` found: https://lore.kernel.org/all/20260212213008.149873-9-
  justintee8345@gmail.com/
- Subject: [PATCH 08/13] lpfc: Fix incorrect txcmplq_cnt during cleanup
  in lpfc_sli_abort_ring
- Part of series: "Update lpfc to revision 14.4.0.14"
- Record: Only v1 submitted; no review feedback or revisions

### Step 4.2: Reviewers
- `b4 dig -w` shows: linux-scsi@vger.kernel.org, jsmart833426@gmail.com
  (James Smart - original lpfc author), justin.tee@broadcom.com
- Applied by Martin K. Petersen (SCSI maintainer)
- Record: Proper review through SCSI subsystem

### Step 4.3: Bug Report
- No Reported-by or bug reports linked; found via internal
  testing/analysis
- Record: No external bug report

### Step 4.4: Related Patches
- Series "Update lpfc to revision 14.4.0.14" contains mix of fixes and
  improvements
- This specific patch (08/13) is an independent bug fix
- Record: Standalone bug fix within larger maintenance series

### Step 4.5: Stable Mailing List
- No stable-specific discussion found
- Not explicitly Cc'd to stable
- Record: Standard flow, no stable discussion

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
- Modified: `lpfc_sli_abort_iocb_ring()`
- Record: Single function modified

### Step 5.2: Callers
- `lpfc_sli_abort_iocb_ring` called from:
  - `lpfc_sli_abort_fcp_rings` (line 4643) — called from EEH/PCI error
    recovery: `lpfc_sli_prep_dev_for_recover` (line 14285),
    `lpfc_sli4_prep_dev_for_recover` (line 15105),
    `lpfc_handle_eratt_s3` at lpfc_init.c:1715 and 1830
  - `lpfc_sli_hba_iocb_abort` (line 12605) — called from controller
    fatal error handlers
  - `lpfc_hba_down_post_s3` (lpfc_init.c:1028 and 1046) — called during
    HBA shutdown
- Record: Called from critical error recovery paths and shutdown paths

### Step 5.3: Callees
- `lpfc_fabric_abort_hba` - aborts fabric commands
- `list_splice_init` - moves list elements
- `lpfc_sli_issue_abort_iotag` - issues ABTS
- `lpfc_sli_cancel_iocbs` - cancels iocbs on list (calls cmd_cmpl or
  releases)
- `lpfc_issue_hb_tmo` - heartbeat timer
- Record: Standard SLI cleanup primitives

### Step 5.4: Call Chain & Reachability
- Triggered by PCI EEH (Enhanced Error Handling) errors → common on IBM
  POWER systems, enterprise PCIe AER environments
- Also reachable via module unload, HBA controller reset, firmware
  errors
- `pci_channel_offline=true` triggers the buggy branch (used in PCI
  error recovery callbacks)
- Record: Reachable from real hardware error recovery paths on
  enterprise systems

### Step 5.5: Similar Patterns
- `lpfc_hba_down_post_s4()` at line 4700-4709: correctly does flag clear
  + `txcmplq_cnt = 0`
- `lpfc_hba_down_post_s3()` at line 4726-4735: correctly does flag clear
  + `txcmplq_cnt = 0`
- `__lpfc_nvme_ls_abort_outstanding_reqs`-style code in
  lpfc_nvme.c:2873-2878: clears flag and decrements `txcmplq_cnt` per-
  iocb
- Record: Correct pattern exists elsewhere; this fix brings
  `lpfc_sli_abort_iocb_ring` into consistency with established codebase
  patterns

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
- Verified v6.6 has buggy code (same structure, missing txcmplq_cnt
  reset and flag clear)
- Verified v6.12 has buggy code
- Verified v6.1 has buggy code
- v5.15 did NOT yet have offline branch (introduced v5.18)
- Record: Bug present in v6.1.y, v6.6.y, v6.12.y, v6.18.y, v6.19.y and
  other active stable trees derived from v5.18+

### Step 6.2: Backport Complications
- Function signature and structure are nearly identical in v6.1 and v6.6
- The minimal bug fix (adding `txcmplq_cnt = 0` and flag clearing loop)
  would apply cleanly
- The full refactor (consolidating plock) may require small adjustments
  in older trees but is still straightforward
- Record: Clean apply expected; minor adjustments possible for older
  trees

### Step 6.3: Related Fixes in Stable
- No prior fix for this specific issue found in stable
- Record: First fix for this bug

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
- `drivers/scsi/lpfc` - Emulex LightPulse Fibre Channel HBA driver
- Criticality: IMPORTANT - used widely in enterprise storage (SAN)
  deployments
- Common on enterprise servers; fibre channel storage is critical data
  path
- Record: IMPORTANT criticality for enterprise SCSI/SAN users

### Step 7.2: Activity Level
- Actively developed by Broadcom team, regular updates
- Record: Active, well-maintained driver with regular fixes

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Population
- Users of Emulex/Broadcom LightPulse FC HBAs running in
  enterprise/datacenter environments
- Especially affected: systems using PCI EEH error recovery (IBM POWER,
  modern x86 with AER)
- Record: Enterprise SCSI/FC users; driver-specific

### Step 8.2: Trigger Conditions
- Primary: PCI channel goes offline (EEH/AER error recovery)
- Secondary: HBA controller hardware error during operation
- Cannot be triggered by unprivileged users (kernel-internal error path)
- Record: Error recovery path; infrequent but occurs on real enterprise
  hardware faults

### Step 8.3: Failure Mode Severity
- When triggered, `pring->txcmplq_cnt` remains positive indefinitely
- `lpfc_nvme_lport_unreg_wait` (lpfc_nvme.c:2252, confirmed) waits for
  this counter to reach 0
- Loop indefinitely prints "wait timed out. Pending %d... Renewing"
  every 10 seconds
- Effectively **hangs cleanup** (module unload, lport unregistration,
  recovery completion)
- Severity: **HIGH** — system task hang during error recovery, affects
  ability to recover from hardware faults
- Record: HIGH severity — cleanup hang during EEH recovery

### Step 8.4: Risk-Benefit
- **Benefit**: Fixes real hang in error recovery path on enterprise
  systems; aligns with established correct pattern
- **Risk**: Refactoring increases scope beyond minimum (24+/42- lines)
  but is clean and functionally equivalent apart from fix; lock usage
  preserved; no behavior change outside the bug fix
- Ratio: Favorable — meaningful fix, low regression risk

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR Backporting:**
- Explicit bug fix with clear commit message explaining the hang
- Fix follows established correct pattern in sibling functions
  (`lpfc_hba_down_post_s3/s4`)
- Author is subsystem maintainer (Justin Tee at Broadcom)
- Applied through proper SCSI maintainer (Martin K. Petersen)
- Bug affects error recovery path → when triggered, causes system hang
- Reachable via common PCI EEH error recovery
- Contained to single file, single function
- Bug present in all active stable trees (v5.18+)
- No new APIs, no userspace-visible changes

**AGAINST Backporting:**
- Change is 66 lines in diff (larger than pure minimal fix would be)
- Refactoring consolidates SLI3/SLI4 paths beyond what's strictly needed
  for the fix
- No explicit stable nomination or Cc: stable
- No Fixes: tag (common for this reviewer workflow, not decisive)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct**: YES — follows existing pattern in same file
2. **Fixes real bug**: YES — cleanup hang described
3. **Important issue**: YES — system hang during error recovery (HIGH
   severity)
4. **Small and contained**: MOSTLY — 66 lines, single function, but more
   than strictly minimal
5. **No new features/APIs**: YES — pure fix + refactor
6. **Applies to stable**: YES — expected to apply cleanly to v6.1.y,
   v6.6.y, v6.12.y, v6.18.y

### Step 9.3: Exception Categories
- Not a device ID addition
- Not a pure quirk (though it's a driver fix)
- Normal bug fix category

### Step 9.4: Decision
Benefits clearly outweigh risks. The bug is a legitimate system hang on
a real error recovery path, the fix is well-understood and pattern-
consistent with existing correct code. The refactoring is clean and
preserves lock semantics. Enterprise storage users affected by PCI error
recovery scenarios (IBM POWER, AER-enabled x86) will benefit.

## Verification

- **[Phase 1]** Parsed commit message tags: Signed-off-by chain (Justin
  Tee → Martin K. Petersen), Link: to patch.msgid.link/lore, no Fixes:
  or Cc: stable (expected)
- **[Phase 1]** Confirmed author is subsystem maintainer via `git log
  --author="Justin Tee"` showing many lpfc commits
- **[Phase 2]** Diff analysis: `git show 2da10bcaa58a3` confirmed 66
  lines changed in lpfc_sli_abort_iocb_ring, single function
- **[Phase 2]** Read current buggy code at
  `drivers/scsi/lpfc/lpfc_sli.c:4571-4631` — confirmed
  `pring->txcmplq_cnt` never reset in offline path
- **[Phase 3]** `git blame -L 4577,4630 drivers/scsi/lpfc/lpfc_sli.c` —
  buggy offline code introduced by `a4691038b4071f` (James Smart,
  2022-03-16)
- **[Phase 3]** `git describe --contains a4691038b4071f` →
  v5.18-rc2~14^2~11^2~20 (buggy code in v5.18+)
- **[Phase 3]** `git show --stat a4691038b4071f` confirmed original
  commit was "Fix unload hang after back to back PCI EEH faults"
- **[Phase 4]** `b4 dig -c 2da10bcaa58a3` found original submission
  lore.kernel.org/all/20260212213008.149873-9-justintee8345@gmail.com
- **[Phase 4]** `b4 dig -c 2da10bcaa58a3 -a` showed only v1 version, no
  revisions
- **[Phase 4]** `b4 dig -c 2da10bcaa58a3 -w` confirmed linux-
  scsi@vger.kernel.org and jsmart833426@gmail.com (James Smart) included
- **[Phase 4]** Read mbox thread /tmp/lpfc_thread.mbox — no reviewer
  replies on PATCH 08/13; no stable-related discussion (`grep -E
  "stable|backport" /tmp/lpfc_thread.mbox` returned nothing)
- **[Phase 5]** `grep txcmplq_cnt` confirmed counter used in
  lpfc_nvme.c:2252 for wait loop in lpfc_nvme_lport_unreg_wait; also
  used for watermarks (21704) and busy stats (21634)
- **[Phase 5]** Read `lpfc_nvme_lport_unreg_wait` at
  lpfc_nvme.c:2219-2280 — confirmed it loops forever printing "Renewing"
  if pending (txcmplq_cnt) never hits zero
- **[Phase 5]** Read lines 4690-4744 of lpfc_sli.c — confirmed identical
  pattern (flag clear + txcmplq_cnt=0) already exists in
  `lpfc_hba_down_post_s4` and `lpfc_hba_down_post_s3`
- **[Phase 5]** Read lpfc_nvme.c:2870-2880 confirmed similar pattern
  (flag clear + counter decrement) for NVMe LS abort
- **[Phase 5]** Confirmed callers via `grep lpfc_sli_abort_iocb_ring`
  and `grep lpfc_sli_abort_fcp_rings|lpfc_sli_hba_iocb_abort` — called
  from EEH recovery (`lpfc_sli_prep_dev_for_recover`,
  `lpfc_sli4_prep_dev_for_recover`), error handlers
  (`lpfc_handle_eratt_s3`), HBA abort
- **[Phase 5]** Verified `pci_channel_offline(phba->pcidev)` used in
  line 4582 triggers the buggy branch; it's true during PCI EEH error
  recovery
- **[Phase 6]** `git show v6.6:drivers/scsi/lpfc/lpfc_sli.c` confirmed
  buggy code present in v6.6
- **[Phase 6]** `git show v6.12:drivers/scsi/lpfc/lpfc_sli.c` confirmed
  buggy code present in v6.12
- **[Phase 6]** `git show v6.1:drivers/scsi/lpfc/lpfc_sli.c` confirmed
  buggy code present in v6.1
- **[Phase 6]** `git show v5.15:drivers/scsi/lpfc/lpfc_sli.c` confirmed
  offline branch NOT in v5.15 (bug introduced later in v5.18)
- **[Phase 7]** Subsystem identified as `drivers/scsi/lpfc` — enterprise
  FC HBA driver
- **[Phase 8]** Failure mode confirmed: cleanup path
  (`lpfc_nvme_lport_unreg_wait`) hangs indefinitely when `txcmplq_cnt`
  doesn't reach 0
- **UNVERIFIED**: Could not build the stable trees or execute runtime
  tests; relied on code structure analysis
- **UNVERIFIED**: Did not check every stable tree for the exact line-
  level conflict state (e.g., v5.18.y EOL); only checked v6.1, v6.6,
  v6.12 tags

The bug is a real hang in cleanup paths during PCI EEH error recovery on
enterprise systems using Broadcom Emulex FC HBAs. The fix follows the
established correct pattern already present in sibling functions in the
same file. While the change includes refactoring that goes slightly
beyond the minimal fix, the refactoring is clean and preserves lock
semantics. The fix has clear technical merit and real user impact on
enterprise storage environments.

**YES**

 drivers/scsi/lpfc/lpfc_sli.c | 66 +++++++++++++-----------------------
 1 file changed, 24 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 303523f754b86..ad5b0e60acc5a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4572,59 +4572,41 @@ void
 lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
 	LIST_HEAD(tx_completions);
-	LIST_HEAD(txcmplq_completions);
+	spinlock_t *plock;		/* for transmit queue access */
 	struct lpfc_iocbq *iocb, *next_iocb;
 	int offline;
 
-	if (pring->ringno == LPFC_ELS_RING) {
+	if (phba->sli_rev >= LPFC_SLI_REV4)
+		plock = &pring->ring_lock;
+	else
+		plock = &phba->hbalock;
+
+	if (pring->ringno == LPFC_ELS_RING)
 		lpfc_fabric_abort_hba(phba);
-	}
+
 	offline = pci_channel_offline(phba->pcidev);
 
-	/* Error everything on txq and txcmplq
-	 * First do the txq.
-	 */
-	if (phba->sli_rev >= LPFC_SLI_REV4) {
-		spin_lock_irq(&pring->ring_lock);
-		list_splice_init(&pring->txq, &tx_completions);
-		pring->txq_cnt = 0;
+	/* Cancel everything on txq */
+	spin_lock_irq(plock);
+	list_splice_init(&pring->txq, &tx_completions);
+	pring->txq_cnt = 0;
 
-		if (offline) {
-			list_splice_init(&pring->txcmplq,
-					 &txcmplq_completions);
-		} else {
-			/* Next issue ABTS for everything on the txcmplq */
-			list_for_each_entry_safe(iocb, next_iocb,
-						 &pring->txcmplq, list)
-				lpfc_sli_issue_abort_iotag(phba, pring,
-							   iocb, NULL);
-		}
-		spin_unlock_irq(&pring->ring_lock);
+	if (offline) {
+		/* Cancel everything on txcmplq */
+		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
+			iocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+		list_splice_init(&pring->txcmplq, &tx_completions);
+		pring->txcmplq_cnt = 0;
 	} else {
-		spin_lock_irq(&phba->hbalock);
-		list_splice_init(&pring->txq, &tx_completions);
-		pring->txq_cnt = 0;
-
-		if (offline) {
-			list_splice_init(&pring->txcmplq, &txcmplq_completions);
-		} else {
-			/* Next issue ABTS for everything on the txcmplq */
-			list_for_each_entry_safe(iocb, next_iocb,
-						 &pring->txcmplq, list)
-				lpfc_sli_issue_abort_iotag(phba, pring,
-							   iocb, NULL);
-		}
-		spin_unlock_irq(&phba->hbalock);
+		/* Issue ABTS for everything on the txcmplq */
+		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
 	}
+	spin_unlock_irq(plock);
 
-	if (offline) {
-		/* Cancel all the IOCBs from the completions list */
-		lpfc_sli_cancel_iocbs(phba, &txcmplq_completions,
-				      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
-	} else {
-		/* Make sure HBA is alive */
+	if (!offline)
 		lpfc_issue_hb_tmo(phba);
-	}
+
 	/* Cancel all the IOCBs from the completions list */
 	lpfc_sli_cancel_iocbs(phba, &tx_completions, IOSTAT_LOCAL_REJECT,
 			      IOERR_SLI_ABORTED);
-- 
2.53.0

