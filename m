Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9613054E4;
	Sat, 25 Oct 2025 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408956; cv=none; b=EtQFSZk1jtdXhgoBMLxFfXIsvx1HqEduLzpwNOqCybQALTKK5GpwShS6oBUzk/UPQo1XB8LEuDaxjqk2iHsLW0Nx9B+tKLJmzr8Ho5ln+ADAU9BvSifWJz8gqdKCh9jQgOXwYS+pQeE1Ovb0iqgkX5r+XN2mcKZC2eNbozvwGjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408956; c=relaxed/simple;
	bh=sDveZVjGmF+hFWzrw2cClUD8xKZBCyZ7F/vmzkMigQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dOakJbLzX5QMtQ1djMT96R3gaqF/fJh3Nb4UjsNA8s+yo7djS66uqadUkB9lgOmG2IrjfyKH+wDF+GYhufdWiCwLXfE13yqHKwbsoj3tn4hs8f7FouMEA1jPaexCDBD8VEmptqK1DgHpC6n24crbqtEiP4a460yIfkOUdZZcJ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWAvGlPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWAvGlPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51377C4CEFB;
	Sat, 25 Oct 2025 16:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408956;
	bh=sDveZVjGmF+hFWzrw2cClUD8xKZBCyZ7F/vmzkMigQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWAvGlPwzPUXPm/DUT91D3C+te0LDlemo88W+BdX4pw6WHNnT9RL9/M++sDVzbHAX
	 U163x5pBH2GWKkpChGx9dhHc5/HsiPQnJcFihaQWiqgjiujRiWGGnX6IQqKxUdORhx
	 0tgOs+pGV/HMW4QrmDZ9RVIUO9PNhf4R8TPVK7iQWfryaD4qEzccle38oHYnlX9IiB
	 03CX2ZEgCveAmsQi2Hu34BN0UouRqALztBQiLcdl3vmHA0wRM56rOhdzXjv2m+D+rv
	 vQtsGg3Vhwrcw4OqUKIdlrRdcopFXOmW4LO6YuZzHGqEBbYyYhIPQw6fpf/j/3cmQC
	 9MRQ4HSeuGpCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.6] scsi: ufs: host: mediatek: Disable auto-hibern8 during power mode changes
Date: Sat, 25 Oct 2025 11:56:21 -0400
Message-ID: <20251025160905.3857885-150-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit f5ca8d0c7a6388abd5d8023cc682e1543728cc73 ]

Disable auto-hibern8 during power mode transitions to prevent unintended
entry into auto-hibern8. Restore the original auto-hibern8 timer value
after completing the power mode change to maintain system stability and
prevent potential issues during power state transitions.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Summary
- The change disables Auto-Hibern8 (AH8) around UFS power mode
  transitions and restores the prior timer afterward. This prevents
  unintended AH8 entry while the link is being reconfigured, which can
  cause timeouts or recovery events during transitions. The fix is
  small, self-contained, and limited to the Mediatek UFS host driver.

What the patch does
- Saves current AH8 timer and disables AH8 in PRE_CHANGE:
  - drivers/ufs/host/ufs-mediatek.c:1472–1476
    - Reads `REG_AUTO_HIBERNATE_IDLE_TIMER` into a static `reg` and
      calls `ufs_mtk_auto_hibern8_disable(hba)`.
- Disables AH8 in a helper and ensures the link is up before proceeding:
  - drivers/ufs/host/ufs-mediatek.c:1436–1461
    - Writes 0 to `REG_AUTO_HIBERNATE_IDLE_TIMER` (disables AH8), waits
      for the host idle state, then waits for `VS_LINK_UP`. On failure,
      warns and triggers `ufshcd_force_error_recovery(hba)` and returns
      `-EBUSY`.
- Restores the previous AH8 timer in POST_CHANGE:
  - drivers/ufs/host/ufs-mediatek.c:1480–1483

Why this fixes a bug
- Power mode transitions involve DME configuration and link parameter
  changes (see setup/adaptation in `ufs_mtk_pre_pwr_change()`:
  drivers/ufs/host/ufs-mediatek.c:1405–1434). If the link enters AH8
  mid-transition, the controller and device can deadlock or time out,
  requiring error recovery. Temporarily disabling AH8 ensures the link
  stays in the expected state while power mode changes occur and
  restores normal power-saving afterwards.
- The helper already used in suspend PRE_CHANGE (drivers/ufs/host/ufs-
  mediatek.c:1748–1751) shows the driver’s established pattern to
  disable AH8 before low-power transitions; extending this to power mode
  changes closes a similar race.

Scope and risk
- Scope: One driver file; no UFS core changes; no architectural shifts.
  Uses existing helpers (`ufshcd_is_auto_hibern8_supported`,
  `ufshcd_readl/writel`, `ufs_mtk_wait_*`,
  `ufshcd_force_error_recovery`).
- Regression risk: Low. Behavior change is to temporarily disable AH8
  only during power mode changes and then restore the previous timer.
  - Note: `ufs_mtk_pwr_change_notify()` stores the old AH8 timer in a
    function-scope static (`reg`) (drivers/ufs/host/ufs-
    mediatek.c:1469). While typical Mediatek systems have a single UFS
    host and power mode changes are serialized, a static variable is
    theoretically shared if multiple controllers triggered this
    concurrently. In practice, impact is negligible on common
    configurations.
  - Note: The PRE_CHANGE path does not propagate the return of
    `ufs_mtk_auto_hibern8_disable()` (drivers/ufs/host/ufs-
    mediatek.c:1473–1478). The helper triggers error recovery internally
    and returns `-EBUSY`, so recovery still occurs, but the immediate
    PRE_CHANGE return value won’t reflect the failure. A tiny follow-up
    improvement would propagate this error directly (as done later in-
    tree).

Evidence of established pattern
- Other vendor drivers also manage AH8 around sensitive transitions,
  supporting this approach:
  - Hisilicon disables/adjusts AH8 during link setup:
    drivers/ufs/host/ufs-hisi.c:234–237
  - Spreadtrum disables AH8 during suspend PRE_CHANGE:
    drivers/ufs/host/ufs-sprd.c:185–190

Stable backport criteria
- Fixes a real operational bug (unintended AH8 mid-transition),
  observable as timeouts or recovery during power mode changes.
- Small, targeted change in a single vendor driver; minimal risk to
  other subsystems.
- No new features or architectural changes; follows established patterns
  in UFS vendor drivers.
- While the commit message lacks an explicit Fixes/Stable tag, the
  change aligns well with stable policy as a platform-specific
  reliability fix.

Recommendation
- Backport to stable: YES.
- Optional but advisable: include the small follow-up that returns an
  error immediately on idle wait timeout (to propagate the PRE_CHANGE
  failure) to match the improved error handling now seen in-tree.

 drivers/ufs/host/ufs-mediatek.c | 53 +++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 91081d2aabe44..3defb5f135e33 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1400,19 +1400,49 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 	return ret;
 }
 
+static int ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
+{
+	int ret;
+
+	/* disable auto-hibern8 */
+	ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
+
+	/* wait host return to idle state when auto-hibern8 off */
+	ufs_mtk_wait_idle_state(hba, 5);
+
+	ret = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
+	if (ret) {
+		dev_warn(hba->dev, "exit h8 state fail, ret=%d\n", ret);
+
+		ufshcd_force_error_recovery(hba);
+
+		/* trigger error handler and break suspend */
+		ret = -EBUSY;
+	}
+
+	return ret;
+}
+
 static int ufs_mtk_pwr_change_notify(struct ufs_hba *hba,
 				enum ufs_notify_change_status stage,
 				const struct ufs_pa_layer_attr *dev_max_params,
 				struct ufs_pa_layer_attr *dev_req_params)
 {
 	int ret = 0;
+	static u32 reg;
 
 	switch (stage) {
 	case PRE_CHANGE:
+		if (ufshcd_is_auto_hibern8_supported(hba)) {
+			reg = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
+			ufs_mtk_auto_hibern8_disable(hba);
+		}
 		ret = ufs_mtk_pre_pwr_change(hba, dev_max_params,
 					     dev_req_params);
 		break;
 	case POST_CHANGE:
+		if (ufshcd_is_auto_hibern8_supported(hba))
+			ufshcd_writel(hba, reg, REG_AUTO_HIBERNATE_IDLE_TIMER);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1646,29 +1676,6 @@ static void ufs_mtk_dev_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 	}
 }
 
-static int ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
-{
-	int ret;
-
-	/* disable auto-hibern8 */
-	ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
-
-	/* wait host return to idle state when auto-hibern8 off */
-	ufs_mtk_wait_idle_state(hba, 5);
-
-	ret = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
-	if (ret) {
-		dev_warn(hba->dev, "exit h8 state fail, ret=%d\n", ret);
-
-		ufshcd_force_error_recovery(hba);
-
-		/* trigger error handler and break suspend */
-		ret = -EBUSY;
-	}
-
-	return ret;
-}
-
 static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	enum ufs_notify_change_status status)
 {
-- 
2.51.0

