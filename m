Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D796258CF9;
	Tue, 22 Apr 2025 02:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288231; cv=none; b=GeGZHvgDB5ZSEpDC268aG/L81irJfzgudGJGzHp+95ZV4c6IJpT/7garbthXt+ugofA0pAbAAfGx99d1Nk6PShUmAG10Uys3xND6cPWVfcn4pTkt32FHWhQA6ZNkAsIrtROVe+ETTMXzH9VgQTtx+dOFfE30pNbTo16+2YoTTKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288231; c=relaxed/simple;
	bh=dwWKusiLvE5Ncu3OJcntHFiHfiZeZqGwomle4v1Vg7w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UnIQuM+fi02U/zow8mKoiG8+VMTqHCUUoOMacW9J1FjqaFlx2yiWlw9/dpm3licd9HkA8UCxgyMq96OvHNA1R5JRk28MZMJ8iLvA8LS3yA5hl8BCiiKIxNFyXtzGq9oVqie3m1cR0EG7fa1WcxUwprJpDEcjQ5z+cxmETmJQMtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GEljB0Y2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GEljB0Y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EFFC4CEE4;
	Tue, 22 Apr 2025 02:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288230;
	bh=dwWKusiLvE5Ncu3OJcntHFiHfiZeZqGwomle4v1Vg7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEljB0Y2k0BPls9jL+oF+S0zK3d6kMmjjwQs9zbIHLF4vw2xRqawqo/P24TZSWxq9
	 g2oXB8oHbVFHFDYOYdjAk1NZMdrTl2+/9haB0aoU3YS0Omligop/KlWkzkaEWSMkph
	 wVLGjSgmuucgJ2cvhK34hHUS+YetqRCMB/mjA3wJHUL2pwDNWFfiyRkW5H6J4lgwKX
	 06ieOWC9O6XFNPqebbLUJx8A4tgi2bUAwWHjUcy2k3/95Xyqyn+4tkfLIRryo1pKk8
	 MqzJi+nt0rffpPJ13UV43eoMwDiJsZWIq/Ejj6/Ae5wN1GahwfbUWfmrTy/YM6A65b
	 BnDZ7G6drY//A==
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
Subject: [PATCH AUTOSEL 6.12 04/23] scsi: ufs: exynos: Move phy calls to .exit() callback
Date: Mon, 21 Apr 2025 22:16:44 -0400
Message-Id: <20250422021703.1941244-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021703.1941244-1-sashal@kernel.org>
References: <20250422021703.1941244-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.24
Content-Transfer-Encoding: 8bit

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit 67e4085015c33bf2fb552af1f171c58b81ef0616 ]

ufshcd_pltfrm_remove() calls ufshcd_remove(hba) which in turn calls
ufshcd_hba_exit().

By moving the phy_power_off() and phy_exit() calls to the newly created
.exit callback they get called by ufshcd_variant_hba_exit() before
ufshcd_hba_exit() turns off the regulators. This is also similar flow to
the ufs-qcom driver.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250319-exynos-ufs-stability-fixes-v2-6-96722cc2ba1b@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-exynos.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 477a9f2920765..344bcc8152244 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1459,6 +1459,14 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	return ret;
 }
 
+static void exynos_ufs_exit(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+
+	phy_power_off(ufs->phy);
+	phy_exit(ufs->phy);
+}
+
 static int exynos_ufs_host_reset(struct ufs_hba *hba)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
@@ -1927,6 +1935,7 @@ static int gs101_ufs_pre_pwr_change(struct exynos_ufs *ufs,
 static const struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
+	.exit				= exynos_ufs_exit,
 	.hce_enable_notify		= exynos_ufs_hce_enable_notify,
 	.link_startup_notify		= exynos_ufs_link_startup_notify,
 	.pwr_change_notify		= exynos_ufs_pwr_change_notify,
@@ -1965,13 +1974,7 @@ static int exynos_ufs_probe(struct platform_device *pdev)
 
 static void exynos_ufs_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
-
 	ufshcd_pltfrm_remove(pdev);
-
-	phy_power_off(ufs->phy);
-	phy_exit(ufs->phy);
 }
 
 static struct exynos_ufs_uic_attr exynos7_uic_attr = {
-- 
2.39.5

