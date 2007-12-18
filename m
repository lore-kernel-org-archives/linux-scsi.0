From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/3] Let scsi_cmnd->cmnd use request->cmd buffer
Date: Tue, 18 Dec 2007 15:38:15 +0200
Message-ID: <4767CD47.4060504@panasas.com>
References: <4767CC3E.8000309@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:22634 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753998AbXLRNjK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Dec 2007 08:39:10 -0500
In-Reply-To: <4767CC3E.8000309@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Benny Halevy <bhalevy@panasas.com>, Matthew Wilcox <matthew@wil.cx>


  - struct scsi_cmnd had a 16 bytes command buffer of its own.
    This is an unnecessary duplication and copy of request's
    cmd. It is probably leftovers from the time that scsi_cmnd
    could function without a request attached. So clean that up.

  - Once above is done, few places, apart from scsi-ml, needed
    adjustments due to changing the data type of scsi_cmnd->cmnd.

  - Lots of drivers still use MAX_COMMAND_SIZE. So I have left
    that #define but equate it to BLK_MAX_CDB. The way I see it
    and is reflected in the patch below is.
    MAX_COMMAND_SIZE - means: The longest fixed-length (*) SCSI CDB
                       as per the SCSI standard and is not related
                       to the implementation.
    BLK_MAX_CDB.     - The allocated space at the request level

(*)fixed-length here means commands that their size can be determined
   by their opcode and the CDB does not carry a length specifier, like
   the VARIABLE_LENGTH_CMD(0x7f) command. This is actually not exactly
   true and the SCSI standard also defines extended commands and
   vendor specific commands that can be bigger than 16 bytes. The kernel
   will support these using the same infrastructure used for VARLEN CDB's.
   So in effect MAX_COMMAND_SIZE means the maximum size command
   scsi-ml supports without specifying a cmd_len by ULD's

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/firewire/fw-sbp2.c       |    2 +-
 drivers/s390/scsi/zfcp_dbf.c     |    2 +-
 drivers/s390/scsi/zfcp_fsf.c     |    2 +-
 drivers/scsi/53c700.c            |    6 +++---
 drivers/scsi/a100u2w.c           |    2 +-
 drivers/scsi/hptiop.c            |    6 +++---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    2 +-
 drivers/scsi/initio.c            |    2 +-
 drivers/scsi/scsi_error.c        |   14 ++++++++------
 drivers/scsi/scsi_lib.c          |    5 +++--
 drivers/scsi/scsi_tgt_lib.c      |    2 ++
 drivers/usb/storage/isd200.c     |    2 ++
 include/scsi/scsi_cmnd.h         |    9 +++++++--
 include/scsi/scsi_eh.h           |    4 ++--
 14 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 624ff3e..06b4306 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1215,7 +1215,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 
 	memset(orb->request.command_block,
 	       0, sizeof(orb->request.command_block));
-	memcpy(orb->request.command_block, cmd->cmnd, COMMAND_SIZE(*cmd->cmnd));
+	memcpy(orb->request.command_block, cmd->cmnd, cmd->cmd_len);
 
 	orb->base.callback = complete_command_orb;
 	orb->base.request_bus =
diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 701046c..7a7f619 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -724,7 +724,7 @@ _zfcp_scsi_dbf_event_common(const char *tag, const char *tag2, int level,
 				rec->scsi_result = scsi_cmnd->result;
 				rec->scsi_cmnd = (unsigned long)scsi_cmnd;
 				rec->scsi_serial = scsi_cmnd->serial_number;
-				memcpy(rec->scsi_opcode, &scsi_cmnd->cmnd,
+				memcpy(rec->scsi_opcode, scsi_cmnd->cmnd,
 					min((int)scsi_cmnd->cmd_len,
 						ZFCP_DBF_SCSI_OPCODE));
 				rec->scsi_retries = scsi_cmnd->retries;
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index ff866eb..e9ead12 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -4220,7 +4220,7 @@ zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *fsf_req)
 		ZFCP_LOG_TRACE("scpnt->result =0x%x, command was:\n",
 			       scpnt->result);
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE,
-			      (void *) &scpnt->cmnd, scpnt->cmd_len);
+			      scpnt->cmnd, scpnt->cmd_len);
 
 		ZFCP_LOG_TRACE("%i bytes sense data provided by FCP\n",
 			       fcp_rsp_iu->fcp_sns_len);
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 71ff3fb..85460f8 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -599,7 +599,7 @@ NCR_700_scsi_done(struct NCR_700_Host_Parameters *hostdata,
 			(struct NCR_700_command_slot *)SCp->host_scribble;
 		
 		dma_unmap_single(hostdata->dev, slot->pCmd,
-				 sizeof(SCp->cmnd), DMA_TO_DEVICE);
+				 MAX_COMMAND_SIZE, DMA_TO_DEVICE);
 		if (slot->flags == NCR_700_FLAG_AUTOSENSE) {
 			char *cmnd = NCR_700_get_sense_cmnd(SCp->device);
 #ifdef NCR_700_DEBUG
@@ -1003,7 +1003,7 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 				 * here */
 				NCR_700_unmap(hostdata, SCp, slot);
 				dma_unmap_single(hostdata->dev, slot->pCmd,
-						 sizeof(SCp->cmnd),
+						 MAX_COMMAND_SIZE,
 						 DMA_TO_DEVICE);
 
 				cmnd[0] = REQUEST_SENSE;
@@ -1900,7 +1900,7 @@ NCR_700_queuecommand(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
 	}
 	slot->resume_offset = 0;
 	slot->pCmd = dma_map_single(hostdata->dev, SCp->cmnd,
-				    sizeof(SCp->cmnd), DMA_TO_DEVICE);
+				    MAX_COMMAND_SIZE, DMA_TO_DEVICE);
 	NCR_700_start_command(SCp);
 	return 0;
 }
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index d3a6d15..b38a9e7 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -894,7 +894,7 @@ static void inia100_build_scb(struct orc_host * host, struct orc_scb * scb, stru
 	} else {
 		scb->tag_msg = 0;	/* No tag support               */
 	}
-	memcpy(&scb->cdb[0], &cmd->cmnd, scb->cdb_len);
+	memcpy(scb->cdb, cmd->cmnd, scb->cdb_len);
 }
 
 /**
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index df1a764..604640d 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -761,9 +761,9 @@ static int hptiop_queuecommand(struct scsi_cmnd *scp,
 			scp,
 			host->host_no, scp->device->channel,
 			scp->device->id, scp->device->lun,
-			*((u32 *)&scp->cmnd),
-			*((u32 *)&scp->cmnd + 1),
-			*((u32 *)&scp->cmnd + 2),
+			((u32 *)scp->cmnd)[0],
+			((u32 *)scp->cmnd)[1],
+			((u32 *)scp->cmnd)[2],
 			_req->index, _req->req_virt);
 
 	scp->result = 0;
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 3081901..4323f96 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -738,7 +738,7 @@ static int ibmvscsi_queuecommand(struct scsi_cmnd *cmnd,
 	srp_cmd = &evt_struct->iu.srp.cmd;
 	memset(srp_cmd, 0x00, SRP_MAX_IU_LEN);
 	srp_cmd->opcode = SRP_CMD;
-	memcpy(srp_cmd->cdb, cmnd->cmnd, sizeof(cmnd->cmnd));
+	memcpy(srp_cmd->cdb, cmnd->cmnd, sizeof(srp_cmd->cdb));
 	srp_cmd->lun = ((u64) lun) << 48;
 
 	if (!map_data_for_srp_cmd(cmnd, evt_struct, srp_cmd, hostdata->dev)) {
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 769a7a8..d61abf4 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2590,7 +2590,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 	cblk->hastat = 0;
 	cblk->tastat = 0;
 	/* Command the command */
-	memcpy(&cblk->cdb[0], &cmnd->cmnd, cmnd->cmd_len);
+	memcpy(cblk->cdb, cmnd->cmnd, cmnd->cmd_len);
 
 	/* Set up tags */
 	if (cmnd->device->tagged_supported) {	/* Tag Support                  */
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5c8ba6a..2a285ef 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -593,7 +593,7 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
  * @scmd:       SCSI command structure to hijack
  * @ses:        structure to save restore information
  * @cmnd:       CDB to send. Can be NULL if no new cmnd is needed
- * @cmnd_size:  size in bytes of @cmnd
+ * @cmnd_size:  size in bytes of @cmnd (must be <= BLK_MAX_CDB)
  * @sense_bytes: size of sense data to copy. or 0 (if != 0 @cmnd is ignored)
  *
  * This function is used to save a scsi command information before re-execution
@@ -615,12 +615,14 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	 * command.
 	 */
 	ses->cmd_len = scmd->cmd_len;
-	memcpy(ses->cmnd, scmd->cmnd, sizeof(scmd->cmnd));
+	ses->cmnd = scmd->cmnd;
 	ses->data_direction = scmd->sc_data_direction;
 	ses->sdb = scmd->sdb;
 	ses->next_rq = scmd->request->next_rq;
 	ses->result = scmd->result;
 
+	scmd->cmnd = ses->eh_cmnd;
+	memset(scmd->cmnd, 0, BLK_MAX_CDB);
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 	scmd->request->next_rq = NULL;
 
@@ -632,14 +634,13 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 		scmd->sdb.sglist = &ses->sense_sgl;
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
 		scmd->sdb.sg_count = 1;
-		memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
 		scmd->cmnd[0] = REQUEST_SENSE;
 		scmd->cmnd[4] = scmd->sdb.length;
 		scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 	} else {
 		scmd->sc_data_direction = DMA_NONE;
 		if (cmnd) {
-			memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
+			BUG_ON(cmnd_size > BLK_MAX_CDB);
 			memcpy(scmd->cmnd, cmnd, cmnd_size);
 			scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 		}
@@ -672,7 +673,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	 * Restore original data
 	 */
 	scmd->cmd_len = ses->cmd_len;
-	memcpy(scmd->cmnd, ses->cmnd, sizeof(scmd->cmnd));
+	scmd->cmnd = ses->cmnd;
 	scmd->sc_data_direction = ses->data_direction;
 	scmd->sdb = ses->sdb;
 	scmd->request->next_rq = ses->next_rq;
@@ -1693,7 +1694,8 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	scmd->request = &req;
 	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
 
-	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
+	scmd->cmnd = req.cmd;
+	memset(scmd->cmnd, 0, BLK_MAX_CDB);
     
 	scmd->scsi_done		= scsi_reset_provider_done_command;
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a6aae56..51168f0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1220,6 +1220,8 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 	cmd->tag = req->tag;
 	cmd->request = req;
 
+	cmd->cmnd = req->cmd;
+
 	return cmd;
 }
 
@@ -1257,8 +1259,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		req->buffer = NULL;
 	}
 
-	BUILD_BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
-	memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
 	cmd->cmd_len = req->cmd_len;
 	if (!req->data_len)
 		cmd->sc_data_direction = DMA_NONE;
@@ -1295,6 +1295,7 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 	if (unlikely(!cmd))
 		return BLKPREP_DEFER;
 
+	memset(cmd->cmnd, 0, BLK_MAX_CDB);
 	return scsi_init_io(cmd, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(scsi_setup_fs_cmnd);
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 91630ba..e01a985 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -108,6 +108,8 @@ struct scsi_cmnd *scsi_host_get_command(struct Scsi_Host *shost,
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->request = rq;
 
+	cmd->cmnd = rq->cmd;
+
 	rq->special = cmd;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_flags |= REQ_TYPE_BLOCK_PC;
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 2d9a32b..50db42a 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -287,6 +287,7 @@ struct isd200_info {
 
 	/* maximum number of LUNs supported */
 	unsigned char MaxLUNs;
+	unsigned char cmnd[BLK_MAX_CDB];
 	struct scsi_cmnd srb;
 	struct scatterlist sg;
 };
@@ -445,6 +446,7 @@ static int isd200_action( struct us_data *us, int action,
 
 	memset(&ata, 0, sizeof(ata));
 	memset(&srb_dev, 0, sizeof(srb_dev));
+	srb->cmnd = info->cmnd;
 	srb->device = &srb_dev;
 	++srb->serial_number;
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index cd2851a..f09c02d 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -7,11 +7,17 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
+#include <linux/blkdev.h>
 
 struct scatterlist;
 struct Scsi_Host;
 struct scsi_device;
 
+#define MAX_COMMAND_SIZE 16
+#if (MAX_COMMAND_SIZE > BLK_MAX_CDB)
+#	error MAX_COMMAND_SIZE can not be smaller than BLK_MAX_CDB
+#endif
+
 struct scsi_data_buffer {
 	struct scatterlist *sglist;
 	unsigned length;
@@ -67,8 +73,7 @@ struct scsi_cmnd {
 	enum dma_data_direction sc_data_direction;
 
 	/* These elements define the operation we are about to perform */
-#define MAX_COMMAND_SIZE	16
-	unsigned char cmnd[MAX_COMMAND_SIZE];
+	unsigned char *cmnd;
 
 	struct timer_list eh_timeout;	/* Used to time out the command. */
 
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 25071d5..9438ea1 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -72,11 +72,11 @@ struct scsi_eh_save {
 	int result;
 	enum dma_data_direction data_direction;
 	unsigned char cmd_len;
-	unsigned char cmnd[MAX_COMMAND_SIZE];
+	unsigned char *cmnd;
 	struct scsi_data_buffer sdb;
 	struct request *next_rq;
-
 	/* new command support */
+	unsigned char eh_cmnd[BLK_MAX_CDB];
 	struct scatterlist sense_sgl;
 };
 
-- 
1.5.3.3


