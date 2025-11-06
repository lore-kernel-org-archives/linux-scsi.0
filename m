Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C14345CB8
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 14:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762438929; cv=none; b=HaGLw1lnvZA0cgWriJfNt5bgk1Llc4k7wPpOtcbotqA3Fazr6V4gc+v21d7DBwxoyVibuKtmUqOWYhsESZoORl8/mklecqZJ98SWqIJzizFCJpzYbyQlDIhkcufrp84ztraiGnNpzAIfj2UURP+cfWXB24LRXnhxf/v4IqeeuyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762438929; c=relaxed/simple;
	bh=cmlE6QF7aLplx5fUXChubWl3y4MDMDOmw13Oo6p8fxI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=kiT1EfuXMgmhVZPwmD1GzrFgWq5lhvX31sJ56Ly7iNqkpbgj80o9N7vzkHuFNzS6FLzb/o/7/j1zZcDkyUO8R2gr2zElzzsF1/X7O92pGAMpiq8/kYYp5/BQJYHwWTupYCRiNNp6oySBqxgHECr6KtFZEazbvm5mDaPIAXq363A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=CK7PpxY6; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="CK7PpxY6"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 8D3CA4E41569;
	Thu,  6 Nov 2025 14:22:02 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 614C26068C;
	Thu,  6 Nov 2025 14:22:02 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id CE5A0118510E6;
	Thu,  6 Nov 2025 15:21:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1762438921; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=4wsKrzApjohL8OKsa9W0+EY3SDDuZv01Lvvq2Jxxjic=;
	b=CK7PpxY6/zl3rVKGY1bY9WwkHXmkLBrN7GUzaZw0AvoAsD0Hx5Ec6t0pjSenN+zKrx1E3N
	1WsIyb7ujNfl99jgeeguE3eYLeOmuw/H6S16UhxZr9hlD94DEDJAwEFEfzFSFP9wJ5oyDu
	1UUuXrLV2Vw+nFzFOE5kFeUuWCAtEhM5jYelGNhbHmJy/emSS0m/+AatyQ5ShdvqDNISmO
	lcQDhrnBEuEOAhFHm+RNp9nE0WEZxhdAdUTqAqgUItGWcLYPWF0YzmJlthUj9fvCtjbFvl
	mlkyRBKbvyymVMggk52ppPNPjerqoBNt8/k8ZPhiTaGzNXM+xHDvcPcp2kC2Ww==
From: "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>
Date: Thu, 06 Nov 2025 15:21:54 +0100
Subject: [PATCH] scsi: ufs: ti-j721e: Add suspend-resume support
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251106-scsi-ufs-ti-j721e-suspend-resume-support-v1-1-6f395f51219e@bootlin.com>
X-B4-Tracking: v=1; b=H4sIAAKvDGkC/x3NQQrCMBBG4auUWTuQBGvVq4iLmP7VEUzDTCNC6
 d2NLr/NeysZVGB07lZSvMVkzg1+11F6xHwHy9hMwYXee3dgSyZcJ+NF+DkED7ZqBXlkhdXXj6X
 MunC6ITp32h9jP1DLFcUkn//qct22L9QElkx6AAAA
X-Change-ID: 20251106-scsi-ufs-ti-j721e-suspend-resume-support-cbea00948a57
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Gregory CLEMENT <gregory.clement@bootlin.com>, Udit Kumar <u-kumar1@ti.com>, 
 Prasanth Mantena <p-mantena@ti.com>, Abhash Kumar <a-kumar2@ti.com>, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>
X-Mailer: b4 0.14.3
X-Last-TLS-Session-Version: TLSv1.3

Restore the ctrl register to resume the TI UFS wrapper.

Signed-off-by: Thomas Richard (TI.com) <thomas.richard@bootlin.com>
---
 drivers/ufs/host/ti-j721e-ufs.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/host/ti-j721e-ufs.c b/drivers/ufs/host/ti-j721e-ufs.c
index 21214e5d5896..43781593b5c1 100644
--- a/drivers/ufs/host/ti-j721e-ufs.c
+++ b/drivers/ufs/host/ti-j721e-ufs.c
@@ -15,18 +15,26 @@
 #define TI_UFS_SS_RST_N_PCS	BIT(0)
 #define TI_UFS_SS_CLK_26MHZ	BIT(4)
 
+struct ti_j721e_ufs {
+	void __iomem *regbase;
+	u32 reg;
+};
+
 static int ti_j721e_ufs_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	struct ti_j721e_ufs *ufs;
 	unsigned long clk_rate;
-	void __iomem *regbase;
 	struct clk *clk;
-	u32 reg = 0;
 	int ret;
 
-	regbase = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(regbase))
-		return PTR_ERR(regbase);
+	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
+	if (!ufs)
+		return -ENOMEM;
+
+	ufs->regbase = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(ufs->regbase))
+		return PTR_ERR(ufs->regbase);
 
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
@@ -42,12 +50,14 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
 	}
 	clk_rate = clk_get_rate(clk);
 	if (clk_rate == 26000000)
-		reg |= TI_UFS_SS_CLK_26MHZ;
+		ufs->reg |= TI_UFS_SS_CLK_26MHZ;
 	devm_clk_put(dev, clk);
 
 	/*  Take UFS slave device out of reset */
-	reg |= TI_UFS_SS_RST_N_PCS;
-	writel(reg, regbase + TI_UFS_SS_CTRL);
+	ufs->reg |= TI_UFS_SS_RST_N_PCS;
+	writel(ufs->reg, ufs->regbase + TI_UFS_SS_CTRL);
+
+	dev_set_drvdata(dev, ufs);
 
 	ret = of_platform_populate(pdev->dev.of_node, NULL, NULL,
 				   dev);
@@ -72,6 +82,16 @@ static void ti_j721e_ufs_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 }
 
+static int ti_j721e_ufs_resume(struct device *dev)
+{
+	struct ti_j721e_ufs *ufs = dev_get_drvdata(dev);
+
+	writel(ufs->reg, ufs->regbase + TI_UFS_SS_CTRL);
+	return 0;
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(ti_j721e_ufs_pm_ops, NULL, ti_j721e_ufs_resume);
+
 static const struct of_device_id ti_j721e_ufs_of_match[] = {
 	{
 		.compatible = "ti,j721e-ufs",
@@ -87,6 +107,7 @@ static struct platform_driver ti_j721e_ufs_driver = {
 	.driver	= {
 		.name   = "ti-j721e-ufs",
 		.of_match_table = ti_j721e_ufs_of_match,
+		.pm = pm_sleep_ptr(&ti_j721e_ufs_pm_ops),
 	},
 };
 module_platform_driver(ti_j721e_ufs_driver);

---
base-commit: 709f6117c3b05c87ef975725074062920d1bbfdc
change-id: 20251106-scsi-ufs-ti-j721e-suspend-resume-support-cbea00948a57

Best regards,
-- 
Thomas Richard (TI.com) <thomas.richard@bootlin.com>

