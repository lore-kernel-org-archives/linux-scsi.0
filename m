Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D62B1B21B4;
	Tue, 22 Apr 2025 02:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288160; cv=none; b=MvJaR39QaZqnxdf0Own0nl3knGe7CevchO+cg01APJq4estwNmm2WI7jnjExgOQUThj8NwfVPCdZdIMIgd13uUO1NLiS7jzbujGW2eiylXzNbuMtTZA/0+AqUBfmEK34pRZKKk9LrNnAxJOv7P9w6MSuB2Wxz93O6e4q3K5aKx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288160; c=relaxed/simple;
	bh=64S55Wp/QtDgHMVcIX6Kuwk3Q6J/rIvQxrvoN50VHqQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iJOYd1OZKyScHH285odBeF6c0fkXXzCW0N68j3xXIXT6b8b0mMuInFqhWQEKRo1h0eHMJzUJSJbarkKfEYCVtTHsTqaHEdt2qDlUQ7qaZiODGq97th9fiWmc8Oyff8XssFlzjQj1ehM9I8WjfByS3NzhtoPba6ReFYrTDrl7xWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YIh9ZD6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YIh9ZD6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543DBC4CEEC;
	Tue, 22 Apr 2025 02:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288159;
	bh=64S55Wp/QtDgHMVcIX6Kuwk3Q6J/rIvQxrvoN50VHqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIh9ZD6OHLeDPEtsnNNWa3EUE5cv0+G87xYcrPfXRhc9ks3IMnAWlqbh8NR6nWLA2
	 YwyC4cscuWQ3svVTRUXJxY1hqtyifepzNPof86iccwFEJbStJJ97qexvOk+qILNRXB
	 aaz6SqdNoXYXKjLUMPmT0ANJZgS2uiAQtDR1co6Fa87yu8EkNWlsU3nG0AaGzNi8lG
	 jz//HdZG7AoNJA8VGbojwhEV0K/Sdgyuw6QxaWAaWUlAzdXiLBl9mAQzb8CIBUD5Ux
	 adB/la8gW0yd/XLocPkui5Iav8kJNftnZF/lzE9PWnANrSgxgAGhTFbFv+t6sC1cXZ
	 ut4RfAPOowUvg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Peter Griffin <peter.griffin@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	alim.akhtar@samsung.com,
	James.Bottomley@HansenPartnership.com,
	krzk@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.14 05/30] scsi: ufs: exynos: gs101: Put UFS device in reset on .suspend()
Date: Mon, 21 Apr 2025 22:15:25 -0400
Message-Id: <20250422021550.1940809-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021550.1940809-1-sashal@kernel.org>
References: <20250422021550.1940809-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.3
Content-Transfer-Encoding: 8bit

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit cd4c0025069f16fc666c6ffc56c49c9b1154841f ]

GPIO_OUT[0] is connected to the reset pin of embedded UFS device.
Before powering off the phy assert the reset signal.

This is added as a gs101 specific suspend hook so as not to have any
unintended consequences for other SoCs supported by this driver.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250319-exynos-ufs-stability-fixes-v2-7-96722cc2ba1b@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-exynos.c | 10 ++++++++++
 drivers/ufs/host/ufs-exynos.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index e5c101480f09d..c593d6b73c4c7 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1679,6 +1679,12 @@ static void exynos_ufs_hibern8_notify(struct ufs_hba *hba,
 	}
 }
 
+static int gs101_ufs_suspend(struct exynos_ufs *ufs)
+{
+	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
+	return 0;
+}
+
 static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	enum ufs_notify_change_status status)
 {
@@ -1687,6 +1693,9 @@ static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	if (status == PRE_CHANGE)
 		return 0;
 
+	if (ufs->drv_data->suspend)
+		ufs->drv_data->suspend(ufs);
+
 	if (!ufshcd_is_link_active(hba))
 		phy_power_off(ufs->phy);
 
@@ -2147,6 +2156,7 @@ static const struct exynos_ufs_drv_data gs101_ufs_drvs = {
 	.pre_link		= gs101_ufs_pre_link,
 	.post_link		= gs101_ufs_post_link,
 	.pre_pwr_change		= gs101_ufs_pre_pwr_change,
+	.suspend		= gs101_ufs_suspend,
 };
 
 static const struct of_device_id exynos_ufs_of_match[] = {
diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
index 9670dc138d1e4..b981cfa08b596 100644
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -191,6 +191,7 @@ struct exynos_ufs_drv_data {
 				struct ufs_pa_layer_attr *pwr);
 	int (*pre_hce_enable)(struct exynos_ufs *ufs);
 	int (*post_hce_enable)(struct exynos_ufs *ufs);
+	int (*suspend)(struct exynos_ufs *ufs);
 };
 
 struct ufs_phy_time_cfg {
-- 
2.39.5

