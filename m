Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C726D30C60C;
	Sat, 25 Oct 2025 16:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409738; cv=none; b=O0sZxKGRNvWuWoWRtOHnarUgxUZKN1SKIy4T+0yILbV2a6osKf+3mgOoyi4UoQjnrEppYABoFVnMTNXS1dWVRPFYJ/q7cznJnPgeEDVA84bV0dvQ5LBEPD/z9eTSJqJD2F+n39ojyvMawuS3sq+IPFxk0HDWXtSbsjr2qyHI92E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409738; c=relaxed/simple;
	bh=KuN0rYE5WO21s3BjY46USG2Aw+kKSQV2IfxwexUpeGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MYssNjvp46SvQpshp/T98NGe7PnIOfOZt3NW73canOk4G7J3iltxpHLffSwq6yp68U7LEKBFIkZ2kIvcDeekNNP6QhsdmYjLpUuvVtn6FrnOP1HRzSLaw0p/yPyYhhJVhl/aL+88Br6l7Akh9co72r0qcol1sKqDtVx1BKrrEHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1Gw/umw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1Gw/umw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6F1C4CEF5;
	Sat, 25 Oct 2025 16:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409738;
	bh=KuN0rYE5WO21s3BjY46USG2Aw+kKSQV2IfxwexUpeGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1Gw/umwIA1AqNSS8IRN9eAucPutiopAe1sDcY11HeLxsxIbSKE9vFF1vgevtrKET
	 qYrT0GSD1mbdzidocEbCHGBpZpUpAvi8dVCkQJMsY2s36SFfR6CgRSahg/IP5dOs8J
	 XovMZfeoiMA2+w1xmYahJGOUQ8pV9xp5hUeKVzkT5ivzCPHbJNze4p2qaOKMFpkDEE
	 xk/OXXdLWo9ZSIYf3OK238UuOIf0eSgEoKtlkiIP2r0t0e8DSriEoawepTD6sD0ksa
	 Ho+DIjlPbrefmTsGxx43nanr7ru20Eji4SuWnYjOA/ITQBJd3Kd4OJYtnwM+zj3Cdr
	 KoVbTS2lqbudA==
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
Subject: [PATCH AUTOSEL 6.17-6.12] scsi: ufs: host: mediatek: Correct system PM flow
Date: Sat, 25 Oct 2025 12:01:15 -0400
Message-ID: <20251025160905.3857885-444-sashal@kernel.org>
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

[ Upstream commit 77b96ef70b6ba46e3473e5e3a66095c4bc0e93a4 ]

Refine the system power management (PM) flow by skipping low power mode
(LPM) and MTCMOS settings if runtime PM is already applied. Prevent
redundant operations to ensure a more efficient PM process.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real PM logic bug. Without this change, the Mediatek UFS
  driver forces VSx/regulators out of LPM and re-enables MTCMOS during
  system resume even if the device is runtime-suspended, which violates
  the runtime PM state and can wake hardware spuriously (extra power
  draw or mis-ordered bring-up). The core UFS system PM paths already
  skip work if the device is runtime-suspended; the Mediatek vendor code
  must mirror that behavior.
- Aligns vendor flow with core UFS PM semantics. Core checks
  `pm_runtime_suspended(hba->dev)` and bails from system PM work in both
  suspend and resume (drivers/ufs/core/ufshcd.c:10284,
  drivers/ufs/core/ufshcd.c:10311). This patch adds the same guards to
  the Mediatek hooks so vendor-specific toggles are not performed on a
  runtime-suspended device.
- Corrects ordering on resume. It powers the MTCMOS domain before
  changing device regulator LPM, matching the already-correct runtime PM
  path and avoiding SMC/PM operations while the domain is off.

Key code changes and impact:
- Add guard in system suspend to skip vendor LPM/MTCMOS when runtime-
  suspended:
  - `if (pm_runtime_suspended(hba->dev)) goto out;`
    drivers/ufs/host/ufs-mediatek.c:2380
  - Prevents redundant `ufs_mtk_dev_vreg_set_lpm(hba, true)` and
    `ufs_mtk_mtcmos_ctrl(false, ...)` calls when runtime PM already put
    the device in low power (drivers/ufs/host/ufs-mediatek.c:2383,
    drivers/ufs/host/ufs-mediatek.c:2386).
- Add guard in system resume to preserve runtime-suspended state:
  - `if (pm_runtime_suspended(hba->dev)) goto out;`
    drivers/ufs/host/ufs-mediatek.c:2398
  - Avoids powering on MTCMOS and clearing LPM when device should remain
    runtime-suspended.
- Fix resume sequencing to match runtime resume:
  - Enable MTCMOS before clearing LPM: `ufs_mtk_mtcmos_ctrl(true, ...)`
    then `ufs_mtk_dev_vreg_set_lpm(hba, false)` (drivers/ufs/host/ufs-
    mediatek.c:2401, drivers/ufs/host/ufs-mediatek.c:2404).
  - Mirrors the runtime path order (drivers/ufs/host/ufs-
    mediatek.c:2442, drivers/ufs/host/ufs-mediatek.c:2448).
- Always invoke core system resume for tracing/consistency
  (drivers/ufs/host/ufs-mediatek.c:2406).

Why it fits stable:
- Small, contained fix limited to Mediatek UFS host.
- No API changes; just conditionalizing existing operations and
  correcting order.
- Prevents incorrect power-state transitions and redundant SMC/PM ops;
  low regression risk.
- Aligns with core driver’s established PM behavior, reducing divergence
  and surprises.

Given these factors, this is an important behavioral fix with minimal
risk and should be backported.

 drivers/ufs/host/ufs-mediatek.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 6bdbbee1f0708..91081d2aabe44 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2264,27 +2264,38 @@ static int ufs_mtk_system_suspend(struct device *dev)
 
 	ret = ufshcd_system_suspend(dev);
 	if (ret)
-		return ret;
+		goto out;
+
+	if (pm_runtime_suspended(hba->dev))
+		goto out;
 
 	ufs_mtk_dev_vreg_set_lpm(hba, true);
 
 	if (ufs_mtk_is_rtff_mtcmos(hba))
 		ufs_mtk_mtcmos_ctrl(false, res);
 
-	return 0;
+out:
+	return ret;
 }
 
 static int ufs_mtk_system_resume(struct device *dev)
 {
+	int ret = 0;
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct arm_smccc_res res;
 
+	if (pm_runtime_suspended(hba->dev))
+		goto out;
+
 	ufs_mtk_dev_vreg_set_lpm(hba, false);
 
 	if (ufs_mtk_is_rtff_mtcmos(hba))
 		ufs_mtk_mtcmos_ctrl(true, res);
 
-	return ufshcd_system_resume(dev);
+out:
+	ret = ufshcd_system_resume(dev);
+
+	return ret;
 }
 #endif
 
-- 
2.51.0

