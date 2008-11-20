From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH] SCSI: fix the return type of the remove() method in sgiwd93.c
Date: Thu, 20 Nov 2008 02:19:17 +0200
Message-ID: <1227140357-29921-1-git-send-email-dmitri.vorobiev@movial.fi>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.movial.fi ([62.236.91.34]:49849 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYKTATT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2008 19:19:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-mips@linux-mips.org, Dmitri Vorobiev <dmitri.vorobiev@movial.fi>

This patch fixes the following compilation warning:

  CC [M]  drivers/scsi/sgiwd93.o
drivers/scsi/sgiwd93.c:314: warning: initialization from incompatible
pointer type

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/scsi/sgiwd93.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 31fe605..672a521 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -297,7 +297,7 @@ out:
 	return err;
 }
 
-static void __exit sgiwd93_remove(struct platform_device *pdev)
+static int __exit sgiwd93_remove(struct platform_device *pdev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(pdev);
 	struct ip22_hostdata *hdata = (struct ip22_hostdata *) host->hostdata;
@@ -307,6 +307,8 @@ static void __exit sgiwd93_remove(struct platform_device *pdev)
 	free_irq(pd->irq, host);
 	dma_free_noncoherent(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma);
 	scsi_host_put(host);
+
+	return 0;
 }
 
 static struct platform_driver sgiwd93_driver = {
-- 
1.5.4.3

