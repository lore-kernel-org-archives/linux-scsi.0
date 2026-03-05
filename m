Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE1039A7F7;
	Thu,  5 Mar 2026 15:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725027; cv=none; b=lv5Bx9G10yswLCMtFEbipSVtlLrF70+umk+23zh53k+Y4DpHQs0P05yDUlyGeWg9BEE7h0OuPp1FEgqWHToyYLnwWPNiw9ZRX1ogG/jJ+j6dz4tSGX0aYcrEVqo4NETHb0zO/pC4OgTeO3YCN4chanEvx8zGliMdIAiVp0LJetw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725027; c=relaxed/simple;
	bh=+nzeOiKNaQXmRUtyeHkCzpRH4sloOKMj+grbCcB6miI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=THqKpTZixfwOdmY3p6illqqVdvZYSwP9p3GX1dksR+w87kcW8eR7cJexK2Q6xT5nl9weJzdZCXx06JltDX5WdWbqJCn1QXCo4YO45XvXrsqkbWlajIzmRZ6BdICU0l4O1ls7v8FGOTvuBXPWrbdKscpqYp51D48zMtO+TLMsuZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHrCsgai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHrCsgai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A01AC116C6;
	Thu,  5 Mar 2026 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772725027;
	bh=+nzeOiKNaQXmRUtyeHkCzpRH4sloOKMj+grbCcB6miI=;
	h=From:To:Cc:Subject:Date:From;
	b=UHrCsgai809zYr+wGuS6MK4xYgKCiSvDtAleIDK9Zrpo9H06Is5yrIGQ02BoZlna3
	 53JA/fUZYXHFcggmm8SFRBQGSNx4JV90WlA1QIPQawxG+0pZ4Gcw4zeGiGuXBz7d1x
	 v8khR65TiuWOtMewrFzx+r2NpL8IFf84I7owMrX7T30jTB2fTpDpkcDCIVuruNFvt0
	 0VP4nF89/Ko6cLYWCFDh60rloTQ+EZt33QXpimPHUWvCaeRs3AAGWh5YBHoShI+nOs
	 drCSSBYXyfCZwsqrXLvEaATk3YnEeynR+DhM7Jlw0lxCIJqRWrx04vhU7VGocsrxj8
	 FXDJg0gP3ORyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Won Jung <wone.jung@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] scsi: ufs: core: Reset urgent_bkops_lvl to allow runtime PM power mode
Date: Thu,  5 Mar 2026 10:36:44 -0500
Message-ID: <20260305153704.106918-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Won Jung <wone.jung@samsung.com>

[ Upstream commit 5b313760059c9df7d60aba7832279bcb81b4aec0 ]

Ensures that UFS Runtime PM can achieve power saving after System PM
suspend by resetting hba->urgent_bkops_lvl. Also modify the
ufshcd_bkops_exception_event_handler to avoid setting urgent_bkops_lvl when
status is 0, which helps maintain optimal power management.

On UFS devices supporting UFSHCD_CAP_AUTO_BKOPS_SUSPEND, a BKOPS exception
event can lead to a situation where UFS Runtime PM can't enter low-power
mode states even after the BKOPS exception has been resolved.

BKOPS exception with bkops status 0 occurs, the driver logs:

 "ufshcd_bkops_exception_event_handler: device raised urgent BKOPS exception for bkops status 0"

When a BKOPS exception occurs, ufshcd_bkops_exception_event_handler() reads
the BKOPS status and sets hba->urgent_bkops_lvl to BKOPS_STATUS_NO_OP(0).
This allows the device to perform Runtime PM without changing the UFS power
mode.  (__ufshcd_wl_suspend(hba, UFS_RUNTIME_PM))

During system PM suspend, ufshcd_disable_auto_bkops() is called, disabling
auto bkops. After UFS System PM Resume, when runtime PM attempts to suspend
again, ufshcd_urgent_bkops() is invoked. Since hba->urgent_bkops_lvl
remains at BKOPS_STATUS_NO_OP(0), ufshcd_enable_auto_bkops() is triggered.

However, in ufshcd_bkops_ctrl(), the driver compares the current BKOPS
status with hba->urgent_bkops_lvl, and only enables auto bkops if
curr_status >= hba->urgent_bkops_lvl.  Since both values are 0, the
condition is met

As a result, __ufshcd_wl_suspend(hba, UFS_RUNTIME_PM) skips power mode
transitions and remains in an active state, preventing power saving even
though no urgent BKOPS condition exists.

Signed-off-by: Won Jung <wone.jung@samsung.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/1891546521.01770806581968.JavaMail.epsvc@epcpadp2new
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The bug exists in v5.15 and v6.1 — both LTS kernels. The vulnerable code
pattern (`if (curr_status < BKOPS_STATUS_PERF_IMPACT)` setting
`urgent_bkops_lvl = curr_status` where curr_status could be 0) has been
present since the exception handler was first written.

## Analysis

### What the commit fixes

This commit fixes a power management regression on UFS storage devices
that support `UFSHCD_CAP_AUTO_BKOPS_SUSPEND`. The bug scenario:

1. A device raises a spurious urgent BKOPS exception with status 0
   (`BKOPS_STATUS_NO_OP`)
2. `ufshcd_bkops_exception_event_handler()` sets `hba->urgent_bkops_lvl
   = 0`
3. During system suspend, `ufshcd_disable_auto_bkops()` resets
   `is_urgent_bkops_lvl_checked = false` but does NOT reset
   `urgent_bkops_lvl`
4. After resume, Runtime PM tries to suspend via `__ufshcd_wl_suspend()`
   → `ufshcd_bkops_ctrl()`
5. In `ufshcd_bkops_ctrl()`, `curr_status(0) >= urgent_bkops_lvl(0)`
   evaluates true, so auto BKOPS gets enabled
6. With auto BKOPS enabled, the runtime suspend path skips power mode
   transition, keeping the device in active state permanently

This causes **persistent excessive power consumption** on
mobile/embedded devices — a serious user-visible issue.

### Two-part fix

1. **`ufshcd_disable_auto_bkops()`**: Resets `urgent_bkops_lvl` to
   `BKOPS_STATUS_PERF_IMPACT` (the default/safe value) when auto BKOPS
   is disabled during system suspend. This mirrors what
   `ufshcd_force_reset_auto_bkops()` already does at line 5987.

2. **`ufshcd_bkops_exception_event_handler()`**: Adds `curr_status >
   BKOPS_STATUS_NO_OP` check to prevent setting `urgent_bkops_lvl` to 0
   when a device raises a spurious exception with status 0.

### Stable kernel criteria assessment

- **Fixes a real bug**: Yes — prevents UFS Runtime PM from entering low-
  power modes, causing power drain
- **Obviously correct**: Yes — both changes are small, logical, and
  align with existing patterns (the reset matches
  `ufshcd_force_reset_auto_bkops`, and the status 0 filter is clearly
  the right semantic)
- **Small and contained**: Yes — 2 lines changed in a single file, no
  API/ABI changes
- **No new features**: Correct — purely a bug fix
- **Reviewed**: Yes — `Reviewed-by: Peter Wang` (MediaTek UFS
  maintainer)
- **Tested**: From Samsung, who manufactured the UFS device exhibiting
  this bug
- **Historical precedent**: Commit `be32acff43800` fixed the same class
  of bug in 2020 and was stable material (had `Fixes:` tag)
- **Wide applicability**: Affects all stable trees from v5.15+ (the
  vulnerable code exists in all of them)
- **Low risk**: The changes are minimal and defensive — they only affect
  an edge case (status 0 exception) and reset to the safe default value

### Risk assessment

**Risk: Very Low**
- The fix adds a safe default reset and tightens a condition to exclude
  an invalid state
- The `BKOPS_STATUS_PERF_IMPACT` reset value is the same value used in
  initialization and in `ufshcd_force_reset_auto_bkops()`
- No functional change for the normal case where status > 0
- May need minor context adjustment for older stable trees (trace
  function signature change) but the actual fix applies cleanly

### Verification

- **Verified** `ufshcd_disable_auto_bkops()` current code at line 5933:
  does NOT reset `urgent_bkops_lvl` (confirmed via Read tool)
- **Verified** `ufshcd_bkops_exception_event_handler()` at line 6065:
  uses `if (curr_status < BKOPS_STATUS_PERF_IMPACT)` which accepts
  status 0 (confirmed via Read tool)
- **Verified** `ufshcd_bkops_ctrl()` at line 6030: `curr_status >=
  status` where status comes from `hba->urgent_bkops_lvl` — so status 0
  causes `0 >= 0` = true, enabling auto BKOPS (confirmed via Read tool)
- **Verified** `ufshcd_force_reset_auto_bkops()` at line 5987: already
  resets `urgent_bkops_lvl = BKOPS_STATUS_PERF_IMPACT`, confirming this
  is the expected default (confirmed via Read tool)
- **Verified** prior fix `be32acff43800` (2020): addressed same class of
  bug where `urgent_bkops_lvl` got set to 0 via `ufshcd_bkops_ctrl`, had
  `Fixes:` tag (confirmed via git show)
- **Verified** prerequisite `0a5167e21126c` (refactor removing
  `ufshcd_urgent_bkops()`): landed in v6.12. The fix itself does NOT
  depend on this refactor — the two functions being changed exist in all
  stable trees (confirmed by checking v6.11, v6.1, v5.15 code via git
  show)
- **Verified** `__ufshcd_wl_suspend()` calls
  `ufshcd_disable_auto_bkops()` during system PM (not runtime PM) at
  line 10059, confirming the suspend path described in the commit
  message (confirmed via Grep)
- **Verified** bug affects stable trees v5.15.y and v6.1.y by checking
  the exception handler code is identical (confirmed via git show)
- **Verified** BKOPS_STATUS_NO_OP = 0x0 and BKOPS_STATUS_PERF_IMPACT =
  0x2 in include/ufs/ufs.h (confirmed via agent research)

**YES**

 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 09f0d77d57f02..c71a449850573 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5959,6 +5959,7 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 
 	hba->auto_bkops_enabled = false;
 	trace_ufshcd_auto_bkops_state(hba, "Disabled");
+	hba->urgent_bkops_lvl = BKOPS_STATUS_PERF_IMPACT;
 	hba->is_urgent_bkops_lvl_checked = false;
 out:
 	return err;
@@ -6062,7 +6063,7 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 	 * impacted or critical. Handle these device by determining their urgent
 	 * bkops status at runtime.
 	 */
-	if (curr_status < BKOPS_STATUS_PERF_IMPACT) {
+	if ((curr_status > BKOPS_STATUS_NO_OP) && (curr_status < BKOPS_STATUS_PERF_IMPACT)) {
 		dev_err(hba->dev, "%s: device raised urgent BKOPS exception for bkops status %d\n",
 				__func__, curr_status);
 		/* update the current status as the urgent bkops level */
-- 
2.51.0

