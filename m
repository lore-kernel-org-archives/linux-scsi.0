Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9F442189A;
	Tue, 28 Apr 2026 10:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372974; cv=none; b=HvFuWFlhLbPZ5iZJLmN12XMENvfwYw+bPLy/T3z8PTSTSKbcyYR/2cSE/iwiv0f1QybVolrKhD2COpEFWX6Tmw/8fAS7ds6fnzS1ptvj+B62N9eRUz/v7snNv5uJLCRhhij0vtToNHMeyayWttFkfpWmJbnCkciNbEzpKpsEXjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372974; c=relaxed/simple;
	bh=vNicz05PIwfMs/DzX4ATEA7r/SFhjcVyFiC7PaDXSG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KuUGLhPb24I4mP48PQ2KQBNYOH3DoMW7KkHvBW3MPIRmAvD/ynqpT2s7204ej1Z9huEyCN2WKFNW+Bva0zZdbNEdLGhp+ft3i9tCo5VD0m6AEiVLNi8egVK8sKbADPleYh6ZsVV2H1AYgc6IzgieAMnSPTbwtm56S87OGSY1Ekc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elcYA15j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elcYA15j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5C2C2BCFB;
	Tue, 28 Apr 2026 10:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372973;
	bh=vNicz05PIwfMs/DzX4ATEA7r/SFhjcVyFiC7PaDXSG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elcYA15ju5iF/a0yuLjnRvh0Di5jVXSMXFlELAVQMWwGo7z3IXlxfuA4aSKyIX5f2
	 R4rGw8Gbowcu+MC/DvnqEVPFGqAZ+mcuRHe0wDwOJLnrcsklnrucPAJH9hdO16Gdpt
	 KBs00LRgFkIFNopxpAm+LYPDYTSi0opEVIJAFfPH9J/pZhKyaXsp1wvr66dWUV0hQ0
	 iAomikr98jOCUk5UeZ5RpkF6RvTt+2dqDM3CB0yUDqrmU3BldQhUl5UgckWSvRTIM/
	 F8oLeYum8iX++LQ5DcjyWe0KtAJj0gK+H81KdH+dNt2OE3D0Cpq7ub2er9nc/RALUW
	 lFQrmkp2ZOCaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aaron Kling <webgeek1234@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jejb@linux.ibm.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] scsi: ufs: core: Disable timestamp for Kioxia THGJFJT0E25BAIP
Date: Tue, 28 Apr 2026 06:41:06 -0400
Message-ID: <20260428104133.2858589-55-sashal@kernel.org>
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

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit e423f1c7195645e18945fba0bd8f0a32e39286e7 ]

Kioxia has another product that does not support the qTimestamp
attribute.

Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260403-thgjfjt0e25baip-no-timestamp-v1-1-1ddb34225133@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my investigation, I'll now write up the complete analysis.

## Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line Parse**
- Record: Subsystem = `scsi: ufs: core`; action verb = "Disable"; intent
  = "Disable timestamp for Kioxia THGJFJT0E25BAIP" — adds a device quirk
  entry to disable qTimestamp handling for a specific Kioxia UFS device
  model.

**Step 1.2: Commit Message Tags**
- Record:
  - Author: Aaron Kling <webgeek1234@gmail.com>
  - Reviewed-by: Bart Van Assche <bvanassche@acm.org> (SCSI/UFS core
    reviewer who authored the original quirk infrastructure)
  - Link: https://patch.msgid.link/20260403-thgjfjt0e25baip-no-
    timestamp-v1-1-1ddb34225133@gmail.com
  - Signed-off-by: Martin K. Petersen (SCSI maintainer)
  - No Fixes:, no Reported-by, no Cc: stable. (Absence of stable tag is
    expected.)

**Step 1.3: Commit Body**
- Record: Very short body — "Kioxia has another product that does not
  support the qTimestamp attribute." The parent commit (fb1f4568346153)
  introduced `UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT` to avoid log-error
  spam when the device rejects the SET_TIMESTAMP query; this commit just
  adds another affected device model.

**Step 1.4: Hidden Bug Fix Detection**
- Record: This IS effectively a bug fix — on the THGJFJT0E25BAIP, the
  current kernel calls `ufshcd_set_timestamp_attr()` periodically and at
  init. The device returns an error, which produces `dev_err()` log spam
  ("failed to set timestamp %d" / "Failed to update rtc %d"). The quirk
  bypasses the query entirely. Hidden-fix category: hardware workaround
  / quirk.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Record: 1 file modified (`drivers/ufs/core/ufshcd.c`), +3/-0 lines.
  One function touched: the static `ufs_fixups[]` table (data-only
  change). Scope: trivial, surgical.

**Step 2.2: Code Flow Change**
- Record: Before — only `THGLF2G9C8KBADG`, `THGLF2G9D8KBADG`
  (PA_TACTIVATE) and `THGJFJT1E45BATP` (NO_TIMESTAMP_SUPPORT) were
  matched for Toshiba-ID devices. After — `THGJFJT0E25BAIP` is also
  matched and gets `UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT` bit set via
  `ufshcd_fixup_dev_quirks()` at device probe. At runtime
  `ufshcd_set_timestamp_attr()` exits early (verified
  `ufshcd.c:8966-8968`).

**Step 2.3: Bug Mechanism**
- Record: Category (h) — Hardware workaround, device-ID/quirk-table
  addition. No logic changes, no synchronization change, no refcount
  change.

**Step 2.4: Fix Quality**
- Record: Obviously correct. Zero risk for any non-matching device
  (quirk table is a prefix-match on manufacturer+model, so only the
  Kioxia THGJFJT0E25BAIP is affected). Cannot regress any other device.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- Record: The table surrounding the addition was introduced over time;
  the specifically-referenced quirk
  `UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT` was introduced by commit
  `fb1f4568346153d2f80fdb4ffcfa0cf4fb257d3c` ("scsi: ufs: core: Disable
  timestamp functionality if not supported", Bart Van Assche,
  2025-09-09), which also added the first device entry
  `THGJFJT1E45BATP`.

**Step 3.2: Fixes: Tag**
- Record: No Fixes: tag. Not applicable. The conceptual "Fixes" target
  is fb1f4568346153, already backported to stable (see Step 6.3).

**Step 3.3: Related File Changes**
- Record: Recent ufshcd.c traffic is mostly core refactors/fixes. Only
  two prior NO_TIMESTAMP-related commits (fb1f4568346153 and
  cb7cc0cfb38cf). This addition is standalone — no series, no
  prerequisites beyond fb1f4568346153 which already exists in stable.

**Step 3.4: Author**
- Record: Aaron Kling is a known Tegra/ARM contributor (`git log
  --author="Aaron Kling"` shows cpufreq, PCI tegra, irqdomain,
  arm64/tegra DT work). He almost certainly hit this on a Tegra board
  shipping with the Kioxia THGJFJT0E25BAIP. Reviewed-by comes from the
  original quirk author (Bart Van Assche) — ideal reviewer.

**Step 3.5: Dependencies**
- Record: Depends on commit fb1f4568346153 (defines the quirk macro and
  the dispatch in `ufshcd_set_timestamp_attr()`). Confirmed present in
  stable — see Phase 6.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Submission**
- Record: `b4 dig -c e423f1c719564` found the series at
  https://lore.kernel.org/all/20260403-thgjfjt0e25baip-no-
  timestamp-v1-1-1ddb34225133@gmail.com/ . Single version (v1), no
  respins.

**Step 4.2: Reviewers**
- Record: Patch went to Alim Akhtar, Avri Altman, Bart Van Assche, James
  Bottomley, Martin K. Petersen, linux-scsi. Bart Van Assche explicitly
  replied with `Reviewed-by:` (he is the author of the quirk
  infrastructure, so he is the domain expert on this). No NAKs, no
  concerns raised, no requests for changes. No explicit stable
  nomination in thread.

**Step 4.3: Bug Report**
- Record: No Reported-by, no external bug report cited. User-facing
  symptom is log-error spam on boot/resume/periodic RTC update — the
  kind of thing an engineer notices when bringing up the board and files
  a patch directly.

**Step 4.4: Series Context**
- Record: Single standalone patch. Not part of a larger series.

**Step 4.5: Stable Discussion**
- Record: No stable-list discussion specific to this commit. The
  precedent is well-established from the prior patch.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions**
- Record: No function added/modified — only a data entry in the static
  `ufs_fixups[]` array.

**Step 5.2: Callers**
- Record: `ufs_fixups[]` is consumed by `ufshcd_fixup_dev_quirks(hba,
  ufs_fixups)` called from `ufs_fixup_device_setup()` at `ufshcd.c:8666`
  during normal device probe. Quirk bit
  (`UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT`) is consumed at
  `ufshcd.c:8966-8968` inside `ufshcd_set_timestamp_attr()`, which is
  called from `ufshcd_add_lus()` (init) and `ufshcd.c:10225` (resume
  path).

**Step 5.3: Callees**
- Record: N/A (data entry only).

**Step 5.4: Reachability**
- Record: Any boot or resume of a system with this Kioxia UFS storage
  triggers the code path. Fully reachable, real users.

**Step 5.5: Similar Patterns**
- Record: Entire `ufs_fixups[]` table is this pattern. The adjacent
  entry (THGJFJT1E45BATP) is the exact same fix for a sibling Kioxia
  product.

### PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code Exists in Stable?**
- Record: `ufshcd_set_timestamp_attr()` exists in all modern stable
  trees. The `UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT` macro exists in
  6.6.y, 6.12.y, 6.18.y (verified by inspecting
  `include/ufs/ufs_quirks.h` on each branch — macro is defined as `(1 <<
  13)`). Not present in 6.17.y (EOL) or 6.1.y (infrastructure commit not
  backported).

**Step 6.2: Backport Complications**
- Record: None. Trivial 3-line text addition to a stable table. Will
  apply cleanly to 6.6.y, 6.12.y, 6.18.y. Cannot apply to 6.1.y because
  the quirk macro and `ufshcd_set_timestamp_attr()` gating do not exist
  there — the patch would be a no-op there anyway.

**Step 6.3: Related Fixes in Stable**
- Record: Parent commit `fb1f4568346153` was backported (by the autosel
  pipeline) to:
  - 6.18.y as `fb1f456834615`
  - 6.12.y as `c6e1e2135d004`
  - 6.6.y as `88ac95b17a038`
  This establishes the precedent: the sibling "add Kioxia timestamp
quirk" patch is already deemed stable-worthy.

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem / Criticality**
- Record: drivers/ufs/core — UFS (Universal Flash Storage) subsystem —
  the primary storage on most modern Android/Tegra/Snapdragon/MediaTek
  devices. Criticality: IMPORTANT (affects a specific storage device,
  not universal, but affects real deployed hardware).

**Step 7.2: Activity**
- Record: Active subsystem with regular fixes landing.

### PHASE 8: IMPACT AND RISK

**Step 8.1: Who Is Affected**
- Record: Users of devices with Kioxia THGJFJT0E25BAIP UFS storage (a
  specific hardware quirk — likely used in particular Tegra-based
  boards, given Aaron Kling's affiliation).

**Step 8.2: Trigger Conditions**
- Record: Every boot of an affected system triggers one "failed to set
  timestamp" dev_err. The periodic RTC update work (`ufshcd_rtc_work()`)
  also triggers "Failed to update rtc" repeatedly (every
  `rtc_update_period` ms). Also triggers on resume. No userspace trigger
  required.

**Step 8.3: Failure Mode Severity**
- Record: LOW severity — the UFS device rejects the query gracefully,
  nothing crashes, no data is lost. But dev_err output is continuous
  (RTC update work loop). Severity: LOW (log noise), no functional
  impact.

**Step 8.4: Risk-Benefit**
- Record:
  - Benefit: Silences dev_err spam on a specific Kioxia product; affects
    only matching devices.
  - Risk: Essentially zero. Literal 3-line data entry. Prefix matching
    in `ufshcd_fixup_dev_quirks()` (`STR_PRFX_EQUAL`) only triggers on
    Toshiba-manufactured devices whose model starts with
    "THGJFJT0E25BAIP"; no other device is touched.
  - Ratio: Favorable.

### PHASE 9: SYNTHESIS

**Step 9.1: Evidence**
- FOR: Textbook hardware quirk / device-ID-table addition; explicitly
  listed as an "IMPORTANT EXCEPTION" for stable; trivial 3-line change;
  reviewed by the subsystem expert who authored the underlying quirk;
  the precedent commit adding the same quirk for a different Kioxia
  model was auto-backported to 6.6.y, 6.12.y, 6.18.y; infrastructure is
  already present in those trees; zero regression risk to non-matching
  hardware.
- AGAINST: Low severity (log noise, not functional); no Reported-by from
  multiple users.
- UNRESOLVED: None relevant.

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested — YES (static data entry, reviewed by
   core expert)
2. Fixes a real bug affecting users — YES (produces repeated dev_err on
   affected hardware)
3. Important — borderline, but falls into explicitly-allowed
   quirk/hardware-workaround category
4. Small and contained — YES (3 lines, one file)
5. No new features or APIs — YES
6. Applies to stable — YES to 6.6.y/6.12.y/6.18.y; N/A to 6.1.y
   (infrastructure missing)

**Step 9.3: Exception Category**
- Falls under the "HARDWARE QUIRK / DEVICE-ID ADDITION TO EXISTING
  DRIVER" exception. This is exactly the pattern the stable rules call
  out as acceptable.

**Step 9.4: Decision**
- This is a tiny hardware-quirk addition that matches a clear precedent
  already in stable trees. Zero regression risk. Should be backported.

## Verification

- [Phase 1] Read `git show e423f1c7195645e18945fba0bd8f0a32e39286e7` —
  confirmed commit details, Reviewed-by: Bart Van Assche, Link tag,
  Martin K. Petersen SOB.
- [Phase 2] Read the diff and `ufs_fixups[]` in
  `drivers/ufs/core/ufshcd.c` (lines 292-322) — confirmed pure data-
  entry addition, 3 lines, 1 file.
- [Phase 2] Read `ufshcd_fixup_dev_quirks()` at `ufshcd.c:8430-8448` —
  confirmed strict manufacturer-ID + prefix model matching so only
  THGJFJT0E25BAIP-prefix Toshiba devices are affected.
- [Phase 2] Read `ufshcd_set_timestamp_attr()` at `ufshcd.c:8958-8988` —
  confirmed gate on `UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT`.
- [Phase 3] `git show fb1f4568346153` — confirmed this is the commit
  introducing the quirk macro and the first Kioxia THGJFJT1E45BATP
  entry.
- [Phase 3] `git log --author="Aaron Kling" --oneline -10` — confirmed
  author is a long-time Tegra contributor.
- [Phase 4] `b4 dig -c e423f1c719564` — found lore thread
  https://lore.kernel.org/all/20260403-thgjfjt0e25baip-no-
  timestamp-v1-1-1ddb34225133@gmail.com/ .
- [Phase 4] `b4 dig -c e423f1c719564 -a` — confirmed only a v1 exists,
  no respins.
- [Phase 4] `b4 dig -c e423f1c719564 -m /tmp/thread_timestamp.mbox` and
  read mbox — confirmed Bart Van Assche gave Reviewed-by, Martin K.
  Petersen applied it to 7.1/scsi-staging then 7.1/scsi-queue. No NAKs,
  no stable discussion, no requested changes.
- [Phase 5] `grep ufshcd_fixup_dev_quirks` — confirmed `ufs_fixups[]` is
  consumed during normal device probe at `ufshcd.c:8666`.
- [Phase 5] Re-read call sites of `ufshcd_set_timestamp_attr` —
  confirmed called from init (`ufshcd_add_lus`) and resume
  (`ufshcd.c:10225`).
- [Phase 6] `git show stable-push/linux-6.18.y:include/ufs/ufs_quirks.h`
  — confirmed `UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT (1<<13)` exists.
- [Phase 6] Same for `stable-push/linux-6.12.y` and `stable-
  push/linux-6.6.y` — both contain the macro.
- [Phase 6] Same for `stable-push/linux-6.17.y` and `stable-
  push/linux-6.1.y` — macro NOT present; either EOL or infrastructure
  not backported.
- [Phase 6] `git show stable-
  push/linux-6.18.y:drivers/ufs/core/ufshcd.c` | grep THGJFJT —
  confirmed existing `THGJFJT1E45BATP` entry in stable, so the new entry
  will apply cleanly.
- [Phase 6] `git log --grep="Disable timestamp functionality" stable-
  push/linux-6.6.y` — found `88ac95b17a038` (backported by Sasha Levin
  autosel pipeline, marked `[ Upstream commit fb1f45683461… ]`),
  confirming the parent/infrastructure commit was deemed stable-worthy.
- UNVERIFIED: Whether 6.17.y is still receiving updates (treated as EOL
  based on no matching commit); this does not affect the decision since
  6.18.y, 6.12.y, 6.6.y are the active targets.

This commit adds a hardware-specific device quirk entry — a textbook
stable-tree exception. The fix is three lines, cannot affect other
hardware, was reviewed by the subsystem expert who wrote the underlying
quirk, and directly mirrors a sibling commit that is already in
6.6.y/6.12.y/6.18.y.

**YES**

 drivers/ufs/core/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9ceb6d6d479d0..9b77639f04535 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -315,6 +315,9 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
 	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
 	  .model = "THGLF2G9D8KBADG",
 	  .quirk = UFS_DEVICE_QUIRK_PA_TACTIVATE },
+	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
+	  .model = "THGJFJT0E25BAIP",
+	  .quirk = UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT },
 	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
 	  .model = "THGJFJT1E45BATP",
 	  .quirk = UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT },
-- 
2.53.0

