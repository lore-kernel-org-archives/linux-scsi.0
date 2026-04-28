Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446A43FD140;
	Tue, 28 Apr 2026 10:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372932; cv=none; b=HNdL7jY7X5/f9YFzNv83F4fPW/vljjLGTfz/JuZ8UCuiMDsl1nCzsT7c8rVjZv98u4DYZjuW9lND7lA6HLonNOVtXe16z0HjaHk/YT1Ma2WmyL3Y2tln4vmzFimG1tqkljV+Hu8wemsPZK1ryyMJD77Zvup5ALdPYSnaLo+mjI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372932; c=relaxed/simple;
	bh=iCCgW4S8zxtaNC8rTtz8QyO5SNyyj2MfQZLDbDz9Y+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBImTlNI1t7H7soz+EDl4o3A2DOF5fQ/V80nd+5E02jM0u1DGpJkwDNr34e/YPDOzi4MQSUB/hQ5Kt7q4URqwaF9KxGCR8xfbpALFpcPhMQfcPMJg8Hj/A6w4Q7ovg3jZceaYisk554qINczaDGCrH3LD4RasrnJIC7NE4L/ZRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pvGs8ih7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pvGs8ih7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C658DC2BCF6;
	Tue, 28 Apr 2026 10:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372931;
	bh=iCCgW4S8zxtaNC8rTtz8QyO5SNyyj2MfQZLDbDz9Y+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvGs8ih7u9DZqtcuYSBFUdHAzvl0eySDbyxLEQvvlZ+L3KinxHm2ShvyoFykXI0YD
	 h8nPfKQsc1Pw+Rzr1yuvH2BVDGEp1gxO3YvqQeo4qClHHA68wWRlSWeUK0qGvVyrgb
	 jnSSonGjsbOwGgNTFoAsdQxUQ2++fEKV7HUqq4nKSsYHyQFh6Zl+H+CCdkZMZQmFyZ
	 0+ECYHCeXyzeOsHgSaGcHrXZkH5FLIpX/4q2Qa5L6lPy40jM3r1xEp9CgZWQaD5ybB
	 8nxd73ehDs1U4iHNLQ9jvjvjVYIXURZr6r+taaUn7dtjnPCs4TAyajkhMVuVxn7Jm3
	 lKATB9M6MBxNw==
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
Subject: [PATCH AUTOSEL 7.0-6.18] scsi: lpfc: Remove unnecessary ndlp kref get in lpfc_check_nlp_post_devloss
Date: Tue, 28 Apr 2026 06:40:38 -0400
Message-ID: <20260428104133.2858589-27-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit f6bfb8d149336661bb80e62980da9a45b920403c ]

When NLP_IN_RECOV_POST_DEV_LOSS is set, the initial node reference
remains held while recovery is in progress.  Taking a reference when
NLP_IN_RECOV_POST_DEV_LOSS is cleared results in an additional reference
being held.  This causes an extra reference when cleaning up lpfc_vport
instances.  Thus, remove the extraneous ndlp kref get in
lpfc_check_nlp_post_devloss.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://patch.msgid.link/20260212213008.149873-7-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my thorough investigation, I can now complete my analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Parse the Subject Line**
- Record: Subsystem `scsi: lpfc:`, action verb `Remove`, summary:
  removes an unnecessary `ndlp` kref get in
  `lpfc_check_nlp_post_devloss` that was leaving an extra reference
  after device-loss recovery.

**Step 1.2: Parse All Commit Message Tags**
- Record: `Signed-off-by: Justin Tee <justin.tee@broadcom.com>` (author
  is a Broadcom lpfc maintainer). `Link: https://patch.msgid.link/202602
  12213008.149873-7-justintee8345@gmail.com`. `Signed-off-by: Martin K.
  Petersen <martin.petersen@oracle.com>` (SCSI maintainer). NO `Fixes:`
  tag, NO `Reported-by:` tag, NO `Cc: stable`, NO `Reviewed-by`.

**Step 1.3: Analyze the Commit Body Text**
- Record: The commit describes a refcount leak - when
  `NLP_IN_RECOV_POST_DEV_LOSS` is set, the initial ndlp reference is
  *still held* (because current `lpfc_dev_loss_tmo_handler` does *not*
  put in the recovering path anymore). Taking another reference via
  `lpfc_nlp_get` in the "reverse" path therefore *adds* an extra
  reference. Symptom: "extra reference when cleaning up lpfc_vport
  instances". No crash/stack trace given.

**Step 1.4: Detect Hidden Bug Fixes**
- Record: Subject begins with "Remove unnecessary" (cleanup wording) but
  commit body explicitly says "extra reference when cleaning up
  lpfc_vport instances" - this IS a real bug fix for a ref leak (pattern
  7: reference counting bug).

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory the Changes**
- Record: One file changed: `drivers/scsi/lpfc/lpfc_hbadisc.c`. One line
  removed (`lpfc_nlp_get(ndlp);`). Scope: single-function surgical fix.

**Step 2.2: Understand the Code Flow Change**
- Record: Before - `lpfc_check_nlp_post_devloss` cleared the
  `NLP_IN_RECOV_POST_DEV_LOSS` flag, cleared `NLP_DROPPED`, then called
  `lpfc_nlp_get(ndlp)` to "restore" a put supposedly performed in
  `lpfc_dev_loss_tmo_handler`. After - the get is gone; the flag bits
  are still cleared; no refcount change is performed.

**Step 2.3: Identify the Bug Mechanism**
- Record: Category (c) reference counting fix - removing an extra
  `lpfc_nlp_get()`. The reason the get is wrong: commit `d1a2ef63fc8b3`
  ("scsi: lpfc: Fix kref imbalance on fabric ndlps from dev_loss_tmo
  handler", merged in v6.12) added an early `return fcf_inuse;` in the
  `recovering` branch, so `lpfc_nlp_put(ndlp)` is no longer executed
  when `NLP_IN_RECOV_POST_DEV_LOSS` is set. The matching `lpfc_nlp_get`
  in `lpfc_check_nlp_post_devloss` was left behind and now grabs an
  extra reference every time a fabric ndlp transiently hits dev_loss and
  recovers.

**Step 2.4: Assess the Fix Quality**
- Record: Minimal 1-line removal. Obvious correctness - just removes the
  stale counterpart of a no-longer-happening put. No new regression
  risk: removing an unbalanced get can only reduce references, it cannot
  cause a UAF (the ndlp reference held before dev_loss remains held
  because the put never happens in the recovering path).

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame the Changed Lines**
- Record: The `lpfc_nlp_get(ndlp);` being removed was originally
  introduced by `af984c87293b1` (Oct 2021, v5.17) as part of "scsi:
  lpfc: Allow fabric node recovery if recovery is in progress before
  devloss". At that time it was *correct* (paired with a put in the
  handler). The bug was introduced by `d1a2ef63fc8b3` (Sep 2024, v6.12)
  "scsi: lpfc: Fix kref imbalance on fabric ndlps from dev_loss_tmo
  handler", which added the early `return fcf_inuse;` that skips the
  `lpfc_nlp_put` in the recovering path but left the `lpfc_nlp_get` in
  `lpfc_check_nlp_post_devloss` dangling.

**Step 3.2: Follow the Fixes: Tag**
- Record: No `Fixes:` tag given. Based on code analysis, the actual
  Fixes: target is `d1a2ef63fc8b3`, present in v6.12 and forward.

**Step 3.3: Check File History for Related Changes**
- Record: Related recent commits: `07caedc6a3887` (Nov 2025) added the
  `clear_bit(NLP_DROPPED, ...);` to `lpfc_check_nlp_post_devloss`;
  `3f8f9f16f844a` converted save_flags to bitmask; `e07ac2d2aa5fc`
  removed unnecessary relocking. This is a standalone patch, part of a
  13-patch lpfc-14.4.0.14 update series (PATCH 6/13).

**Step 3.4: Check the Author's Other Commits**
- Record: Justin Tee (Broadcom) is the primary lpfc
  maintainer/contributor. Wrote `d1a2ef63fc8b3` (which introduced this
  bug) and has 30+ lpfc commits recently. Subject-matter expert.

**Step 3.5: Check for Dependent/Prerequisite Commits**
- Record: This fix is completely standalone for trees that contain
  `d1a2ef63fc8b3` (v6.12+). The only dependency is that the buggy commit
  is present. Can apply standalone.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Find the Original Patch Discussion**
- Record: `b4 am` located the patch series at lore.kernel.org. Patch is
  "PATCH 6/13 lpfc: Remove unnecessary ndlp kref get in
  lpfc_check_nlp_post_devloss" from series "Update lpfc to revision
  14.4.0.14" posted 2026-02-12 against Martin's 6.20/scsi-queue tree. No
  review discussion found on this specific patch (no `Reviewed-by`, no
  NAKs, no stable suggestions).

**Step 4.2: Check Who Reviewed the Patch**
- Record: Series is a typical Broadcom/lpfc driver update going through
  SCSI maintainer Martin K. Petersen. No explicit per-patch review
  comments retrieved.

**Step 4.3: Search for the Bug Report**
- Record: No `Reported-by:` tag. The bug was author-discovered via code
  analysis, not a user report.

**Step 4.4: Check for Related Patches and Series**
- Record: This is patch 6 of a 13-patch series. Other patches include
  logging improvements, typecast changes, cleanup of `lpfc_fdmi_cmd`
  error paths, `txcmplq_cnt` fixes, NVMe abort cleanup on PCI reset, and
  version bump. This specific patch is self-contained.

**Step 4.5: Check Stable Mailing List History**
- Record: No prior discussion found.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Identify Key Functions in the Diff**
- Record: `lpfc_check_nlp_post_devloss()` only.

**Step 5.2: Trace Callers**
- Record: Callers verified via grep - 5 total call sites:
  `lpfc_mbx_cmpl_fc_reg_login`, `lpfc_nlp_reg_node` (in
  `lpfc_hbadisc.c`), and 3 sites in `lpfc_els.c` around FLOGI handling.
  These are mainline FC discovery/login completion paths - called
  routinely during normal operation, particularly after link events.

**Step 5.3: Trace Callees**
- Record: The function calls `test_and_clear_bit`, `clear_bit`,
  `lpfc_nlp_get` (being removed), and `lpfc_printf_vlog` (logging). No
  I/O, no complex state changes.

**Step 5.4: Follow the Call Chain**
- Record: Reachable from any FC link-bounce/devloss path. Real-world
  triggered every time a fabric ndlp (Fabric_DID, FDMI_DID,
  NameServer_DID, Fabric_Cntl_DID) dev_loss_tmo-fires while recovery is
  still in progress - a common event on FC fabrics.

**Step 5.5: Search for Similar Patterns**
- Record: N/A - this is a specific function.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Does the Buggy Code Exist in Stable Trees?**
- Record: Verified via `git show
  <branch>:drivers/scsi/lpfc/lpfc_hbadisc.c`:
  - stable/linux-6.12.y: HAS BUG - `recovering` path has `return
    fcf_inuse;` (no put); `lpfc_check_nlp_post_devloss` has
    `lpfc_nlp_get(ndlp)` (extra ref).
  - stable/linux-6.17.y, 6.18.y, 6.19.y: HAS BUG - same pattern.
  - stable/linux-6.6.y: NO BUG - the `recovering` path in 6.6.y does NOT
    have the early return; the `lpfc_nlp_put(ndlp)` still executes at
    the end of fabric-node handling, so the `lpfc_nlp_get` correctly
    balances it. Fix must NOT be backported to 6.6.y.

**Step 6.2: Check for Backport Complications**
- Record: For 6.18.y and 6.19.y: patch applies cleanly (same surrounding
  context with `clear_bit(NLP_DROPPED, ...)`). For 6.17.y: needs minor
  context adjustment (no `clear_bit(NLP_DROPPED, ...)` line above). For
  6.12.y: function still uses the older `spin_lock_irqsave`/`save_flags
  &=` form; a manual adjustment (simply removing the
  `lpfc_nlp_get(ndlp);` line amidst different surrounding context) is
  needed but trivial.

**Step 6.3: Check If Related Fixes Are Already in Stable**
- Record: None. Buggy commit `d1a2ef63fc8b3` went into v6.12 directly
  (not backported). No alternate fix present.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Identify the Subsystem and Its Criticality**
- Record: `drivers/scsi/lpfc/` - Broadcom/Emulex Fibre Channel HBA
  driver. Criticality: IMPORTANT - used in enterprise storage/SAN
  setups. Reference leaks in a driver of this size matter to enterprise
  users running long-lived systems.

**Step 7.2: Assess Subsystem Activity**
- Record: Actively maintained (regular version bumps, multiple patches
  per quarter). Justin Tee / Broadcom are responsive maintainers.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Determine Who Is Affected**
- Record: Affected population - users of lpfc-driven FC HBAs running
  v6.12+ stable kernels who experience fabric link bounces,
  zoning/fabric reconfiguration, or transient device-loss events on
  Fabric_DID/FDMI/NameServer/Fabric_Cntl ndlps.

**Step 8.2: Determine the Trigger Conditions**
- Record: Triggered every time a fabric ndlp enters dev_loss_tmo while
  still in a recovering discovery state. On busy fabrics with many
  vports, this can happen repeatedly; each occurrence leaks one ndlp
  reference.

**Step 8.3: Determine the Failure Mode Severity**
- Record: Failure mode - ndlp kref leak; ndlp objects cannot be freed
  during `lpfc_vport` cleanup; potential memory accumulation over time;
  can cause WARN messages or stuck/hang behavior on vport
  teardown/module unload. Severity: MEDIUM-HIGH - not an immediate crash
  or security issue but a persistent resource leak in a commonly-
  triggered code path in enterprise storage workloads.

**Step 8.4: Calculate Risk-Benefit Ratio**
- Record: Benefit - fixes a real ref leak introduced by a previous "fix"
  commit, benefit is MEDIUM-HIGH for lpfc users. Risk - 1-line removal,
  obvious correctness, no possibility of new UAF since we're only
  reducing (not adding) puts; risk VERY LOW. Ratio: clearly favorable
  for backport.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Compile Evidence**
- FOR: Real kref leak bug in common code path; trivially small/obvious
  fix; author is subsystem maintainer who introduced the original bug;
  bug confirmed to exist in 6.12.y, 6.17.y, 6.18.y, 6.19.y via direct
  inspection; code analysis is unambiguous.
- AGAINST: No `Fixes:`, `Reported-by:`, `Cc: stable`; no user report of
  symptoms; a similar comment language ("put the initial ref count
  back") now stale but not updated.
- UNRESOLVED: Whether this is already in linux-next / scsi-queue for
  v6.21 (not verified directly, but the cover letter says it targets
  6.20/scsi-queue so likely on its way to mainline imminently).

**Step 9.2: Apply Stable Rules Checklist**
1. Obviously correct and tested? YES - trivial to verify by reading the
   two functions together; author has build/test history.
2. Fixes real bug affecting users? YES - refcount leak on every fabric-
   ndlp recovery event.
3. Important issue? MEDIUM-HIGH (resource leak in enterprise storage
   driver).
4. Small and contained? YES - one line removal.
5. No new features or APIs? YES - pure bug fix.
6. Applies to stable? YES for 6.12.y (with trivial manual adjustment)
   and 6.17.y+; must NOT go to 6.6.y and earlier.

**Step 9.3: Check for Exception Categories**
- N/A - normal bug fix, not a quirk/device ID/DT update/build fix.

**Step 9.4: Decision**
- This is a genuine reference-counting bug fix for a regression
  introduced by `d1a2ef63fc8b3` in v6.12. The fix is minimal, obviously
  correct, and affects a common code path in the lpfc FC driver used by
  enterprise storage. Risk is essentially zero; benefit prevents a real
  ref leak. Should be backported to 6.12+ stable trees (NOT to 6.6.y and
  earlier where the bug does not exist).

## Verification

- [Phase 1] Parsed tags on the supplied commit message: Signed-off-by
  Justin Tee / Martin K. Petersen, Link to patch.msgid.link. No
  Fixes/Reported-by/Cc-stable/Reviewed-by.
- [Phase 2] Read the diff: single 1-line removal of
  `lpfc_nlp_get(ndlp);` in `lpfc_check_nlp_post_devloss` within
  `drivers/scsi/lpfc/lpfc_hbadisc.c`.
- [Phase 3] `git log -L:lpfc_check_nlp_post_devloss` confirmed the get
  was introduced in `af984c87293b1` (v5.17) where it was correct (paired
  with a put).
- [Phase 3] `git show d1a2ef63fc8b3` - confirmed this commit added the
  early `return fcf_inuse;` in the recovering branch, breaking the
  get/put pairing.
- [Phase 3] `git log --author="Justin Tee"` - confirmed author is active
  lpfc maintainer.
- [Phase 3] `git tag --contains d1a2ef63fc8b3` - buggy commit is in
  v6.12 and beyond.
- [Phase 4] `b4 am 20260212213008.149873-7-justintee8345@gmail.com` -
  downloaded the series, confirmed it is patch 6/13 in "Update lpfc to
  revision 14.4.0.14" against 6.20/scsi-queue. No per-patch review
  discussion.
- [Phase 5] `grep lpfc_check_nlp_post_devloss` - 5 callers:
  `lpfc_mbx_cmpl_fc_reg_login`, `lpfc_nlp_reg_node`, 3 in `lpfc_els.c`
  FLOGI paths - all routine discovery paths.
- [Phase 6] `git show stable/linux-6.12.y:...lpfc_hbadisc.c` - confirmed
  bug exists (function has lpfc_nlp_get, recovering path has `return
  fcf_inuse;`).
- [Phase 6] `git show
  stable/linux-6.17.y/6.18.y/6.19.y:...lpfc_hbadisc.c` - same bug
  pattern confirmed in each.
- [Phase 6] `git show stable/linux-6.6.y:...lpfc_hbadisc.c` - confirmed
  bug does NOT exist (recovering path has no early return; put still
  fires).
- [Phase 8] Failure mode: ndlp kref leak on every fabric-ndlp dev_loss
  recovery event, MEDIUM-HIGH severity.
- UNVERIFIED: Whether any user has reported hangs/OOM from this specific
  leak - no such report exists, but the mechanism is clear from code
  analysis.
- UNVERIFIED: Exact mainline SHA of the commit (not yet in my local
  `master`), but the patch content matches what is on lore/in the
  14.4.0.14 series.

The fix is small, surgical, and addresses a real regression that exists
in multiple active stable trees (6.12+). Meets all stable kernel rules.
The adaptation for 6.12.y requires a trivial manual edit (different
surrounding context) but the change itself is a single-line removal.

**YES**

 drivers/scsi/lpfc/lpfc_hbadisc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 8aaf05d7bb0af..d42b911a0aee1 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -425,7 +425,6 @@ lpfc_check_nlp_post_devloss(struct lpfc_vport *vport,
 {
 	if (test_and_clear_bit(NLP_IN_RECOV_POST_DEV_LOSS, &ndlp->save_flags)) {
 		clear_bit(NLP_DROPPED, &ndlp->nlp_flag);
-		lpfc_nlp_get(ndlp);
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY | LOG_NODE,
 				 "8438 Devloss timeout reversed on DID x%x "
 				 "refcnt %d ndlp %p flag x%lx "
-- 
2.53.0

