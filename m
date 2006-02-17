From: Brian King <brking@us.ibm.com>
Subject: [PATCH 10/16] ipr: Fix adapter initialization failure
Date: Fri, 17 Feb 2006 16:20:46 -0600
Message-ID: <200602172220.k1HMKkVm011917@d03av01.boulder.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Since scsi core is always sending scatterlists now, remove
some code which was written with the bad assumption that
a small transfer would not be sent down in a scatterlist.
Without this fix, the ipr driver ends up sending garbage
data to the adapter following a reset, causing it to
fail the reset and take the adapter offline.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/ipr.c |   49 +++-------------------------------
 libata-dev-bjking1/drivers/scsi/ipr.h |    5 +--
 2 files changed, 7 insertions(+), 47 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_mode_sense_failure drivers/scsi/ipr.c
--- libata-dev/drivers/scsi/ipr.c~ipr_mode_sense_failure	2006-02-17 15:44:17.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ipr.c	2006-02-17 15:47:05.000000000 -0600
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
--- libata-dev/drivers/scsi/ipr.h~ipr_mode_sense_failure	2006-02-17 15:44:17.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ipr.h	2006-02-17 15:47:05.000000000 -0600
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
