From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] ipr: Rate limit DMA mapping errors
Date: Mon, 9 May 2011 10:07:40 +1000
Message-ID: <20110509100740.5eb8f9b5@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:43573 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab1EIAHq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 May 2011 20:07:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wayneb@linux.vnet.ibm.com, brking@us.ibm.com
Cc: linux-scsi@vger.kernel.org


I noticed a stream of errors from the IPR driver while doing
IOMMU fault injection. Rate limit the errors so we don't clog
up the console and logfiles.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-powerpc/drivers/scsi/ipr.c
===================================================================
--- linux-powerpc.orig/drivers/scsi/ipr.c	2011-05-03 16:35:10.304480474 +1000
+++ linux-powerpc/drivers/scsi/ipr.c	2011-05-09 10:00:41.439578385 +1000
@@ -5143,7 +5143,8 @@ static int ipr_build_ioadl64(struct ipr_
 
 	nseg = scsi_dma_map(scsi_cmd);
 	if (nseg < 0) {
-		dev_err(&ioa_cfg->pdev->dev, "pci_map_sg failed!\n");
+		if (printk_ratelimit())
+			dev_err(&ioa_cfg->pdev->dev, "pci_map_sg failed!\n");
 		return -1;
 	}
 
