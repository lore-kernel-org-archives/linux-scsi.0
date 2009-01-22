From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvfc: Fix DMA mapping leak on memory allocation failure
Date: Thu, 22 Jan 2009 15:45:38 -0600
Message-ID: <200901222146.n0MLkoRL023400@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:44075 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbZAVVqw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 16:46:52 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n0MLiq5b022471
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2009 14:44:52 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0MLkpAR200504
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2009 14:46:51 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0MLko1a023484
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2009 14:46:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


There is currently a DMA mapping leak that can occur in the ibmvfc
driver if we fail to allocate a scatterlist. Fix this by unmapping
the scatterlist in the failure path. Additionally, only log an error
for a scatterlist allocation failure if the log level is greater
than the default, since this can occur when running Active Memory
Sharing and this is not considered an error.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_cmo_fixes drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_cmo_fixes	2009-01-22 08:51:51.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-01-22 08:52:30.000000000 -0600
@@ -1322,7 +1322,9 @@ static int ibmvfc_map_sg_data(struct scs
 					       &evt->ext_list_token);
 
 		if (!evt->ext_list) {
-			scmd_printk(KERN_ERR, scmd, "Can't allocate memory for scatterlist\n");
+			scsi_dma_unmap(scmd);
+			if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
+				scmd_printk(KERN_ERR, scmd, "Can't allocate memory for scatterlist\n");
 			return -ENOMEM;
 		}
 	}
_
