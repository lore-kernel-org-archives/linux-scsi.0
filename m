From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/6] ipr: Remove unnecessary memory barriers
Date: Wed, 14 Mar 2012 21:20:09 -0500
Message-ID: <201203150220.q2F2K5pC002891@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:43646 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760071Ab2COCUL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 22:20:11 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 14 Mar 2012 20:20:10 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 508081FF0047
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:07 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2F2K7fh174418
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:07 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2F2K6l5002925
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:06 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


The ipr driver added some memory barriers in order to ensure
a PowerPC sync instruction was executed prior to sending a
command to the adapter to ensure the command block was
coherent with respect to the PCI bus's view of memory.
However, some time ago, the powerpc architecture writel
macros were changed to include the sync since most drivers
don't properly handle this. So remove these memory barriers
since they are not needed and result in executing twice
as many sync instructions, which has a significant performance
penalty.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_no_sync drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_no_sync	2012-03-10 07:32:35.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2012-03-10 07:32:35.000000000 -0600
@@ -850,8 +850,6 @@ static void ipr_do_req(struct ipr_cmnd *
 
 	ipr_trc_hook(ipr_cmd, IPR_TRACE_START, 0);
 
-	mb();
-
 	ipr_send_command(ipr_cmd);
 }
 
@@ -985,8 +983,6 @@ static void ipr_send_hcam(struct ipr_ioa
 
 		ipr_trc_hook(ipr_cmd, IPR_TRACE_START, IPR_IOA_RES_ADDR);
 
-		mb();
-
 		ipr_send_command(ipr_cmd);
 	} else {
 		list_add_tail(&hostrcb->queue, &ioa_cfg->hostrcb_free_q);
@@ -5863,14 +5859,12 @@ static int ipr_queuecommand_lck(struct s
 			rc = ipr_build_ioadl(ioa_cfg, ipr_cmd);
 	}
 
-	if (likely(rc == 0)) {
-		mb();
-		ipr_send_command(ipr_cmd);
-	} else {
-		 list_move_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
-		 return SCSI_MLQUEUE_HOST_BUSY;
+	if (unlikely(rc != 0)) {
+		list_move_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	ipr_send_command(ipr_cmd);
 	return 0;
 }
 
@@ -6248,8 +6242,6 @@ static unsigned int ipr_qc_issue(struct
 		return AC_ERR_INVALID;
 	}
 
-	mb();
-
 	ipr_send_command(ipr_cmd);
 
 	return 0;
_

