From: Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 16/27] drivers/scsi/ufs: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:49 +0200
Message-ID: <1374602524-3398-17-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 drivers/scsi/ufs/ufshcd-pltfrm.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index c42db40..8367c39 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -102,12 +102,6 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem_res) {
-		dev_err(dev, "Memory resource not available\n");
-		err = -ENODEV;
-		goto out;
-	}
-
 	mmio_base = devm_ioremap_resource(dev, mem_res);
 	if (IS_ERR(mmio_base)) {
 		dev_err(dev, "memory map failed\n");
-- 
1.7.10.4
