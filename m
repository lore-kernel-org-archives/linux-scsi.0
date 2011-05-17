From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [RESEND] [PATCH] ipr: Rate limit DMA mapping errors
Date: Tue, 17 May 2011 09:58:35 -0700
Message-ID: <4DD2A93B.3000006@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:34558 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab1EQQ7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2011 12:59:10 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4HGrKdn018987
	for <linux-scsi@vger.kernel.org>; Tue, 17 May 2011 10:53:20 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4HH045x055608
	for <linux-scsi@vger.kernel.org>; Tue, 17 May 2011 11:00:04 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4HAwaKP021900
	for <linux-scsi@vger.kernel.org>; Tue, 17 May 2011 04:58:36 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: brking@us.ibm.com, linux-scsi@vger.kernel.org, Anton Blanchard <anton@samba.org>

Resending this based on James' request that was sent to the
linux-scsi list on May 10.

---

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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
