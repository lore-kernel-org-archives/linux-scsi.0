Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091B8585961;
	Mon, 31 Aug 2026 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184209; cv=none; b=lorfEMVa6IfYdqp++C5TBgRTkolGJqLGpF3gNu1Gj0POjR5g7dBruWAfGX7efZz4fky/2Quy/lG+FUki9pMyBUYkz+MAmzkXFo+eObr62X1yBH8gPvEoKSpuWXJ2GAmGyF+mfQvxRdxPrsYcIm/N6ctOTfkEzpB+6YDZ9+vYeXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184209; c=relaxed/simple;
	bh=p+G+mFBQiYLclURcyD6LpKzavQFTBhS9EkmYNex4rqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rZn/E0UzpyHV8mulDXauTWE1TrDK3GsM4+f9LZhTU3imkyO73dUeJpljRiFdnufj5/jgBLvDSBTpP2/0Jsq0qMjxcbVHFXxSl30ssdOkfnokM9cjahsuVJ2tak2yeg1jUTaJra9dLn8J7LpcssMExFmEgkasCM+0QJrzXI/pFww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MA8xJEoY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MA8xJEoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A855E1F00ACA;
	Mon, 31 Aug 2026 13:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184206;
	bh=ftiRhfy/A5+WxpMAfOwW8pKkQAILec81shwmcKWLD4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MA8xJEoYXGwqUss5A28G5yfF0zPA6huLXq+m2SfFnVwJZMjpnyQ9DB5/BTU86NKWV
	 cx4P9brkTQi82zPHIvcG4OYDdET0Jre+wSrWNLK4mXRDkl37mm153o9IdUVUdfcSsX
	 s3IB5K7knSV+oNSemtt3jkGYFq/ifEuv89/I1gugdurPIl6jqkcg2WDd/8Llcu+0vK
	 ozoMlyP883V978t/E33n8ROPH5618e7qRi2S6b39nLCqFBR13DX5fCU9j/ACdY7FOg
	 vH3tW894PxFqBTGTIn0+LSs28+ym4AjdByD39/9hbRCSflV0FVTWwKPEY9CJMdb1RI
	 HM8fXVh6dBA+Q==
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
Subject: [PATCH AUTOSEL 6.18-5.10] scsi: pm8001: Reject firmware update in fatal error state
Date: Mon, 31 Aug 2026 09:29:43 -0400
Message-ID: <20260831133314.4125787-555-sashal@kernel.org>
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

[ Upstream commit 2a8fbcfb04aa9db189bfa3842d4f586aecd0e631 ]

pm8001_store_update_fw() allows a firmware update request even when the
controller has already entered a fatal error state.

Firmware update is not valid once the controller is in that state, and
attempting it can lead to a call trace. Reject the request early by
checking controller_fatal_error, set the firmware status to
FAIL_PARAMETERS, and return -EINVAL.

Signed-off-by: Kumar Meiyappan <kumar.meiyappan@microchip.com>
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
Link: https://patch.msgid.link/20260416153757.414896-1-sagar.biradar@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `scsi: pm8001: Reject firmware update in
fatal error state`

**Local tree:** Linux **6.18.43** (`stable/linux-6.18.y`, `HEAD`
detached at `c7f0dac02d232`)
**Upstream commit:** `2a8fbcfb04aa9` (candidate on `autosel`:
`dc825300273da`)
**Fix status in this tree:** **Not present** — patch applies cleanly.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[scsi: pm8001]` `[Reject]` — Reject firmware update when
the controller is already in a fatal error state.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Kumar Meiyappan, Sagar Biradar, Martin K. Petersen
  (subsystem maintainer)
- **Link:** https://patch.msgid.link/20260416153757.414896-1-
  sagar.biradar@microchip.com
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc: stable (in
  commit message; stable was CC'd on the mailing list submission)
- Notable: Martin K. Petersen (SCSI maintainer) signed off and applied
  upstream.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `pm8001_store_update_fw()` accepts firmware-update sysfs
  writes even when `controller_fatal_error` is already true.
- **Symptom:** Attempting a firmware update in that state can produce a
  **kernel call trace**.
- **Fix:** Early check of `controller_fatal_error`, set `fw_status =
  FAIL_PARAMETERS`, return `-EINVAL`.
- **Root cause:** Missing guard in the firmware-update sysfs path; other
  paths already check this flag.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit bug fix, not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/scsi/pm8001/pm8001_ctl.c` (+8 lines)
- **Function:** `pm8001_store_update_fw()`
- **Scope:** Single-file, surgical fix.

### Step 2.2: Code flow change
**Record:**
- **Before:** After parsing `buf` into command and filename, code
  proceeds to flash-command lookup and `request_firmware()` /
  `pm8001_update_flash()` even if the controller is in fatal error.
- **After:** After parameter parsing, if `controller_fatal_error` is
  true, log, set status, return `-EINVAL` via existing `out:` cleanup.
- **Path affected:** Sysfs write to `update_fw` (admin-only,
  error/recovery path after hardware failure).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness — missing state guard on an admin
  sysfs operation.
- **Mechanism:** Firmware flash IOCTLs
  (`PM8001_CHIP_DISP->fw_flash_update_req()`) assume a live controller.
  After fatal firmware error, hardware/firmware is not in a valid state;
  proceeding causes a kernel call trace. The fix mirrors the existing
  I/O rejection in `pm8001_task_exec()`.

### Step 2.4: Fix quality
**Record:**
- Obviously correct: uses existing `controller_fatal_error` flag and
  established error-handling pattern (`goto out`).
- Minimal, no API changes.
- **Regression risk:** Very low — only rejects an operation that is
  invalid by definition when the controller is crashed.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `controller_fatal_error` field and
`pm8001_store_update_fw()` exist in v6.18; the field is present back to
at least **v6.0**. The omission in the firmware-update path is long-
standing, not a regression from a recent commit.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:**
- Sibling fix: `scsi: pm8001: Reject non-fatal dump when controller is
  crashed` (`aa3b8f56ef27e` / autosel `3b6992159c00d`) — same pattern,
  different sysfs path; also **not** in this tree.
- `4851c39aae3a9` ("scsi: pm80xx: Add fatal error checks", May 2023)
  added fatal-error checks to I/O paths in `pm8001_sas.c`, but not to
  sysfs firmware update.
- Standalone 1/1 patch; no series dependency.

### Step 3.4: Author context
**Record:** Kumar Meiyappan and Sagar Biradar are Microchip driver
authors; Martin K. Petersen is the SCSI maintainer who applied the patch
upstream.

### Step 3.5: Dependencies
**Record:** No prerequisites. `controller_fatal_error` field, sysfs
attribute, and fatal-error setting in `pm80xx_hwi.c` all exist in this
tree. Patch applies cleanly (`git apply --check` passed).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/20260416153757.414896-1-
  sagar.biradar@microchip.com
- **Series:** v1 only (no further revisions).
- **Reviewer feedback:** Martin K. Petersen applied to scsi-
  staging/scsi-queue ("Applied... thanks!").
- **No NAKs** in thread.
- **Stable nomination:** `stable@vger.kernel.org` was CC'd on the
  original submission.

### Step 4.2: Reviewers
**Record:** CC'd: Martin K. Petersen, James Bottomley, Jack Wang, linux-
scsi, stable@vger.kernel.org, Microchip team. Appropriate maintainers
included.

### Step 4.3: Bug report
**Record:** No external bug tracker or syzbot report. Bug identified
internally by driver authors based on invalid-operation behavior after
controller crash.

### Step 4.4: Related patches
**Record:** Companion fix for `pm80xx_get_non_fatal_dump()` is separate
and addresses the same class of bug; not required for this patch to
function.

### Step 4.5: Stable list history
**Record:** Patch was submitted with stable CC; no separate stable-list
discussion found beyond that.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `pm8001_store_update_fw()` (modified); related:
`pm8001_update_flash()`, `pm8001_set_nvmd()`,
`controller_fatal_error_show()`.

### Step 5.2: Callers
**Record:** `pm8001_store_update_fw` is the sysfs store handler for
`DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP, ...)`. Invoked when
root (CAP_SYS_ADMIN) writes to `/sys/class/sas_host/hostN/update_fw`.

### Step 5.3: Callees
**Record:** Without the guard, calls `request_firmware()`, then
`pm8001_update_flash()` → `PM8001_CHIP_DISP->fw_flash_update_req()` →
hardware interaction with a crashed controller.

### Step 5.4: Reachability
**Record:**
- Requires `CONFIG_SCSI_PM8001` and Microchip pm8001/pm80xx hardware.
- Requires `CAP_SYS_ADMIN` (checked at line 803).
- Trigger: controller fatal firmware error **then** admin attempts
  firmware update via sysfs.
- Realistic in production recovery scenarios after a controller crash.

### Step 5.5: Similar patterns
**Record:** Existing guard in `pm8001_sas.c`:

```505:508:drivers/scsi/pm8001/pm8001_sas.c
        if (pm8001_ha->controller_fatal_error) {
                ts->resp = SAS_TASK_UNDELIVERED;
                task->task_done(task);
                return 0;
```

The fix brings the firmware-update sysfs path in line with I/O rejection
behavior.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **Yes.** In 6.18.43, `pm8001_store_update_fw()` at lines
819–837 proceeds without checking `controller_fatal_error`. The flag
infrastructure is fully present (field, sysfs readout, set on fatal
error in `pm80xx_hwi.c`).

### Step 6.2: Backport complications
**Record:** **Clean apply** — verified with `git format-patch` + `git
apply --check`. No conflicts expected.

### Step 6.3: Related fixes already present?
**Record:** **No.** Neither this fix (`2a8fbcfb04aa9`) nor the sibling
non-fatal-dump fix is in `HEAD` or `v6.18`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/scsi/pm8001** — IMPORTANT but hardware-specific
(Microchip/PMC SAS HBAs). Not core kernel, but affects production
storage servers using these controllers.

### Step 7.2: Subsystem activity
**Record:** pm8001 driver is mature; recent fixes target fatal-error
edge cases in sysfs/admin paths.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of `CONFIG_SCSI_PM8001` hardware who experience a
controller fatal error and then attempt firmware update via sysfs.

### Step 8.2: Trigger conditions
**Record:**
- Controller must enter fatal error state (firmware/hardware failure).
- Admin must write to `update_fw` sysfs attribute.
- **Unprivileged users cannot trigger** (CAP_SYS_ADMIN required).
- Not an every-boot path, but a realistic post-failure recovery attempt.

### Step 8.3: Failure mode severity
**Record:** Kernel **call trace** when invalid firmware flash is
attempted on a dead controller. Severity: **HIGH** (kernel instability
on admin operation); not a security issue from unprivileged users, but
prevents further kernel problems during disaster recovery.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents kernel call trace during admin recovery on
  crashed controllers; aligns sysfs behavior with I/O path and exposed
  `controller_fatal_error` attribute.
- **Risk:** Very low — 8-line guard on an invalid code path.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes a real bug with kernel call trace on a reachable admin path.
- Small, obviously correct, applies cleanly to 6.18.43.
- Uses existing infrastructure; no new APIs or features.
- SCSI maintainer reviewed and applied upstream.
- Stable was CC'd on submission.
- Long-standing omission (field present since at least v6.0); affects
  this stable tree.
- Consistent with existing `controller_fatal_error` checks in I/O path.

**AGAINST backport:**
- Narrow audience (pm8001 hardware only).
- Requires admin + prior controller crash.
- No syzbot or user bug report with stack trace in commit message.

**Unresolved:** Exact call-trace stack not provided in commit message
(author states it "can lead to a call trace" without paste). Mechanism
is plausible from code analysis.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — simple guard; maintainer
   applied upstream.
2. Fixes a real bug? **PASS** — invalid operation on crashed controller.
3. Important issue? **PASS** — kernel call trace / instability (HIGH,
   admin recovery path).
4. Small and contained? **PASS** — 8 lines, 1 file.
5. No new features or APIs? **PASS**.
6. Can apply to local tree? **PASS** — verified clean apply; all
   prerequisites present.

### Step 9.3: Exception categories
**Record:** None (not a device ID, quirk, DT, build fix, or docs fix) —
standard bug fix.

### Step 9.4: Decision rationale

For Linux **6.18.y**, this fix addresses a real gap: after a controller
fatal error, the driver already rejects I/O and exposes the error state
via sysfs, but still allows firmware update attempts that can provoke a
kernel call trace. The patch is minimal, self-contained, maintainer-
reviewed, and applies cleanly. The trigger is narrow (admin + hardware
failure), but the consequence (kernel call trace during disaster
recovery) meets stable backport criteria.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from `dc825300273da` /
  user-provided diff.
- **[Phase 2]** Read `pm8001_ctl.c` lines 791–865; analyzed diff (+8
  lines in `pm8001_store_update_fw`).
- **[Phase 3]** `git log all-next --grep="pm8001"` found upstream
  `2a8fbcfb04aa9`; `git merge-base --is-ancestor` confirmed fix NOT in
  `HEAD` or `v6.18`.
- **[Phase 3]** Verified `controller_fatal_error` present in v6.0–v6.18
  via `git show $tag:...pm8001_sas.h`.
- **[Phase 3]** Found sibling fix `3b6992159c00d` / `aa3b8f56ef27e`
  (same pattern, not in tree).
- **[Phase 4]** `b4 dig -c dc825300273da`: lore URL found; `-a`: v1
  only; `-w`: stable@vger.kernel.org CC'd.
- **[Phase 4]** Downloaded mbox; confirmed Martin Petersen applied
  patch, no NAKs.
- **[Phase 5]** `grep` for `update_fw`, `controller_fatal_error`,
  `fw_flash_update_req` call chain.
- **[Phase 5]** Read `pm8001_sas.c:505-508` existing fatal-error guard.
- **[Phase 6]** `git describe HEAD`: v6.18.43; confirmed buggy code at
  lines 819–837 without guard.
- **[Phase 6]** `git format-patch -1 dc825300273da | git apply --check`:
  **clean apply**.
- **[Phase 6]** `git merge-base --is-ancestor dc825300273da HEAD`: fix
  NOT in HEAD.
- **[Phase 8]** Confirmed `CAP_SYS_ADMIN` check at line 803;
  `CONFIG_SCSI_PM8001` in `drivers/scsi/Kconfig`.
- **UNVERIFIED:** Exact kernel stack trace from the failure (not in
  commit message or mbox).

**YES**

 drivers/scsi/pm8001/pm8001_ctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index c10854ec44c7b..a27f3287748ee 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -823,6 +823,14 @@ static ssize_t pm8001_store_update_fw(struct device *cdev,
 		goto out;
 	}
 
+	if (pm8001_ha->controller_fatal_error) {
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "controller in fatal error state, firmware update rejected\n");
+		pm8001_ha->fw_status = FAIL_PARAMETERS;
+		ret = -EINVAL;
+		goto out;
+	}
+
 	for (i = 0; flash_command_table[i].code != FLASH_CMD_NONE; i++) {
 		if (!memcmp(flash_command_table[i].command,
 				 cmd_ptr, strlen(cmd_ptr))) {
-- 
2.53.0

