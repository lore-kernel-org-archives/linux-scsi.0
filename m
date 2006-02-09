From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/1] ipr: Fix adapter initialization failure
Date: Wed, 08 Feb 2006 20:57:42 -0600
Message-ID: <200602090257.k192vviJ012951@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:28069 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1422783AbWBIC57
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 21:57:59 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k192vxlN029917
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 21:57:59 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1930QiN186642
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 20:00:26 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k192vwnt013000
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 19:57:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


James,
I'd really like to see this get into 2.6.16 if possible.
Without it is far too easy to crater a system with an
ipr adapter on it.

Since scsi core is always sending scatterlists now, remove
some code which was written with the bad assumption that
a small transfer would not be sent down in a scatterlist.
Without this fix, the ipr driver ends up sending garbage
data to the adapter following a reset, causing it to
fail the reset and take the adapter offline.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   49 +++--------------------------------
 linux-2.6-bjking1/drivers/scsi/ipr.h |    5 +--
 2 files changed, 7 insertions(+), 47 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_mode_sense_failure drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_mode_sense_failure	2006-02-08 17:37:14.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-02-08 17:38:43.000000000 -0600
@@ -4236,35 +4236,6 @@ static void ipr_scsi_done(struct ipr_cmn
 }
 
 /**
- * ipr_save_ioafp_mode_select - Save adapters mode select data
- * @ioa_cfg:	ioa config struct
- * @scsi_cmd:	scsi command struct
- *
- * This function saves mode select data for the adapter to
- * use following an adapter reset.
- *
- * Return value:
- *	0 on success / SCSI_MLQUEUE_HOST_BUSY on failure
- **/
-static int ipr_save_ioafp_mode_select(struct ipr_ioa_cfg *ioa_cfg,
-				       struct scsi_cmnd *scsi_cmd)
-{
-	if (!ioa_cfg->saved_mode_pages) {
-		ioa_cfg->saved_mode_pages  = kmalloc(sizeof(struct ipr_mode_pages),
-						     GFP_ATOMIC);
-		if (!ioa_cfg->saved_mode_pages) {
-			dev_err(&ioa_cfg->pdev->dev,
-				"IOA mode select buffer allocation failed\n");
-			return SCSI_MLQUEUE_HOST_BUSY;
-		}
-	}
-
-	memcpy(ioa_cfg->saved_mode_pages, scsi_cmd->buffer, scsi_cmd->cmnd[4]);
-	ioa_cfg->saved_mode_page_len = scsi_cmd->cmnd[4];
-	return 0;
-}
-
-/**
  * ipr_queuecommand - Queue a mid-layer request
  * @scsi_cmd:	scsi command struct
  * @done:		done function
@@ -4338,9 +4309,6 @@ static int ipr_queuecommand(struct scsi_
 	    (!ipr_is_gscsi(res) || scsi_cmd->cmnd[0] == IPR_QUERY_RSRC_STATE))
 		ioarcb->cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
 
-	if (ipr_is_ioa_resource(res) && scsi_cmd->cmnd[0] == MODE_SELECT)
-		rc = ipr_save_ioafp_mode_select(ioa_cfg, scsi_cmd);
-
 	if (likely(rc == 0))
 		rc = ipr_build_ioadl(ioa_cfg, ipr_cmd);
 
@@ -4829,17 +4797,11 @@ static int ipr_ioafp_mode_select_page28(
 	int length;
 
 	ENTER;
-	if (ioa_cfg->saved_mode_pages) {
-		memcpy(mode_pages, ioa_cfg->saved_mode_pages,
-		       ioa_cfg->saved_mode_page_len);
-		length = ioa_cfg->saved_mode_page_len;
-	} else {
-		ipr_scsi_bus_speed_limit(ioa_cfg);
-		ipr_check_term_power(ioa_cfg, mode_pages);
-		ipr_modify_ioafp_mode_page_28(ioa_cfg, mode_pages);
-		length = mode_pages->hdr.length + 1;
-		mode_pages->hdr.length = 0;
-	}
+	ipr_scsi_bus_speed_limit(ioa_cfg);
+	ipr_check_term_power(ioa_cfg, mode_pages);
+	ipr_modify_ioafp_mode_page_28(ioa_cfg, mode_pages);
+	length = mode_pages->hdr.length + 1;
+	mode_pages->hdr.length = 0;
 
 	ipr_build_mode_select(ipr_cmd, cpu_to_be32(IPR_IOA_RES_HANDLE), 0x11,
 			      ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, mode_pages),
@@ -5969,7 +5931,6 @@ static void ipr_free_mem(struct ipr_ioa_
 	}
 
 	ipr_free_dump(ioa_cfg);
-	kfree(ioa_cfg->saved_mode_pages);
 	kfree(ioa_cfg->trace);
 }
 
diff -puN drivers/scsi/ipr.h~ipr_mode_sense_failure drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_mode_sense_failure	2006-02-08 17:37:45.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2006-02-08 17:53:38.000000000 -0600
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.1.1"
-#define IPR_DRIVER_DATE "(November 15, 2005)"
+#define IPR_DRIVER_VERSION "2.1.2"
+#define IPR_DRIVER_DATE "(February 8, 2006)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
@@ -1000,7 +1000,6 @@ struct ipr_ioa_cfg {
 	struct Scsi_Host *host;
 	struct pci_dev *pdev;
 	struct ipr_sglist *ucode_sglist;
-	struct ipr_mode_pages *saved_mode_pages;
 	u8 saved_mode_page_len;
 
 	struct work_struct work_q;
_
