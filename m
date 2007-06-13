From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/5] ibmvscsi: Remove unnecessary map_sg check
Date: Wed, 13 Jun 2007 17:12:11 -0500
Message-ID: <5884.8507040695$1181772746@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:45920 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbXFMWMQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2007 18:12:16 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5DMCETb031518
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 18:12:14 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5DMCE41209602
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 16:12:14 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5DMCDK6019731
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 16:12:13 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santil@linux.vnet.ibm.com
Cc: rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Since sg_tablesize is set appropriately in the scsi host template,
remove the unnecessary check to make sure it is not exceeded
following the dma_map_sg call.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_remove_map_sg_check drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_remove_map_sg_check	2007-06-11 11:15:52.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-06-11 11:16:12.000000000 -0500
@@ -408,13 +408,6 @@ static int map_sg_data(struct scsi_cmnd 
 		return 1;
 	}
 
-	if (sg_mapped > SG_ALL) {
-		printk(KERN_ERR
-		       "ibmvscsi: More than %d mapped sg entries, got %d\n",
-		       SG_ALL, sg_mapped);
-		return 0;
-	}
-
 	indirect->table_desc.va = 0;
 	indirect->table_desc.len = sg_mapped * sizeof(struct srp_direct_buf);
 	indirect->table_desc.key = 0;
_
