From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/6] ipr: Fix possible error path oops during initialization
Date: Thu, 26 Mar 2015 11:23:55 -0500
Message-ID: <201503261623.t2QGNtSX003713@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:40910 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbbCZQYB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2015 12:24:01 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 26 Mar 2015 10:24:00 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 9B9931FF0021
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 10:15:08 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2QGNvDG53149900
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 09:23:57 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2QGNuHY003819
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 10:23:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, kreling@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, dan.carpenter@oracle.com


Fixes a possible oops during adapter initialization in some
memory allocation failure error paths scenarios.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_free_cmd_blks_oops drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_free_cmd_blks_oops	2015-03-26 11:14:41.465782868 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2015-03-26 11:14:41.471782829 -0500
@@ -9061,13 +9061,15 @@ static void ipr_free_cmd_blks(struct ipr
 {
 	int i;
 
-	for (i = 0; i < IPR_NUM_CMD_BLKS; i++) {
-		if (ioa_cfg->ipr_cmnd_list[i])
-			dma_pool_free(ioa_cfg->ipr_cmd_pool,
-				      ioa_cfg->ipr_cmnd_list[i],
-				      ioa_cfg->ipr_cmnd_list_dma[i]);
+	if (ioa_cfg->ipr_cmnd_list) {
+		for (i = 0; i < IPR_NUM_CMD_BLKS; i++) {
+			if (ioa_cfg->ipr_cmnd_list[i])
+				dma_pool_free(ioa_cfg->ipr_cmd_pool,
+					      ioa_cfg->ipr_cmnd_list[i],
+					      ioa_cfg->ipr_cmnd_list_dma[i]);
 
-		ioa_cfg->ipr_cmnd_list[i] = NULL;
+			ioa_cfg->ipr_cmnd_list[i] = NULL;
+		}
 	}
 
 	if (ioa_cfg->ipr_cmd_pool)
_

