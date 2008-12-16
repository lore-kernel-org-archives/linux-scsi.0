From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH RESEND] [SCSI] Fix compilation warning in sgiwd93.c
Date: Tue, 16 Dec 2008 15:04:44 +0200
Message-ID: <1229432684-20444-1-git-send-email-dmitri.vorobiev@movial.fi>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.movial.fi ([62.236.91.34]:35340 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbYLPNEr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 08:04:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-mips@linux-mips.org, Dmitri Vorobiev <dmitri.vorobiev@movial.fi>

The remove() callback in platform drivers should return int in
accordance to the definition of the platform_driver structure.
However, the SGI-specific WD93 SCSI controller driver defines
the callback as a void function, which causes the following
compilation warning:

drivers/scsi/sgiwd93.c:314: warning: initialization from
incompatible pointer type

This patch fixes the warning by changing the return type of
the remove() callback to what the core driver code requires.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/scsi/sgiwd93.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 31fe605..0807b26 100644
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
@@ -307,6 +307,7 @@ static void __exit sgiwd93_remove(struct platform_device *pdev)
 	free_irq(pd->irq, host);
 	dma_free_noncoherent(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma);
 	scsi_host_put(host);
+	return 0;
 }
 
 static struct platform_driver sgiwd93_driver = {
-- 
1.5.4.3

