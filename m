From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/4] Let scsi_cmnd->cmnd use request->cmd buffer
Date: Sun, 13 Apr 2008 19:37:32 +0300
Message-ID: <480236CC.402@panasas.com>
References: <47E92672.1040208@panasas.com> <48023526.5050709@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:37411 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbYDMQiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Apr 2008 12:38:16 -0400
In-Reply-To: <48023526.5050709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mike


 - struct scsi_cmnd had a 16 bytes command buffer of its own.
   This is an unnecessary duplication and copy of request's
   cmd. It is probably left overs from the time that scsi_cmnd
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

 - I have audit all ISA drivers and made sure none use ->cmnd in a DMA
   Operation. Same audit was done by Andi Kleen.

(*)fixed-length here means commands that their size can be determined
   by their opcode and the CDB does not carry a length specifier, (unlike
   the VARIABLE_LENGTH_CMD(0x7f) command). This is actually not exactly
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
 drivers/scsi/gdth.c              |    2 +-
 drivers/scsi/hptiop.c            |    6 +++---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    2 +-
 drivers/scsi/initio.c            |    2 +-
 drivers/scsi/qla1280.c           |    4 ++--
 drivers/scsi/scsi_error.c        |   14 ++++++++------
 drivers/scsi/scsi_lib.c          |    5 +++--
 drivers/scsi/scsi_tgt_lib.c      |    2 ++
 drivers/usb/storage/isd200.c     |    2 ++
 include/scsi/scsi_cmnd.h         |   21 +++++++++++++++++++--
 include/scsi/scsi_eh.h           |    4 ++--
 16 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 62b4e47..2260e56 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1492,7 +1492,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 
 	memset(orb->request.command_block,
 	       0, sizeof(orb->request.command_block));
-	memcpy(orb->request.command_block, cmd->cmnd, COMMAND_SIZE(*cmd->cmnd));
+	memcpy(orb->request.command_block, cmd->cmnd, cmd->cmd_len);
 
 	orb->base.callback = complete_command_orb;
 	orb->base.request_bus =
diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 85ba4cc..1bec0b2 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -1057,7 +1057,7 @@ static void zfcp_scsi_dbf_event(const char *tag, const char *tag2, int level,
 				rec->scsi_result = scsi_cmnd->result;
 				rec->scsi_cmnd = (unsigned long)scsi_cmnd;
 				rec->scsi_serial = scsi_cmnd->serial_number;
-				memcpy(rec->scsi_opcode, &scsi_cmnd->cmnd,
+				memcpy(rec->scsi_opcode, scsi_cmnd->cmnd,
 					min((int)scsi_cmnd->cmd_len,
 						ZFCP_DBF_SCSI_OPCODE));
 				rec->scsi_retries = scsi_cmnd->retries;
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index b7aa969..ea46881 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -4024,7 +4024,7 @@ zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *fsf_req)
 		ZFCP_LOG_TRACE("scpnt->result =0x%x, command was:\n",
 			       scpnt->result);
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE,
-			      (void *) &scpnt->cmnd, scpnt->cmd_len);
+			      scpnt->cmnd, scpnt->cmd_len);
 
 		ZFCP_LOG_TRACE("%i bytes sense data provided by FCP\n",
 			       fcp_rsp_iu->fcp_sns_len);
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index f4c4fe9..f5a9add 100644
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
@@ -1004,7 +1004,7 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 				 * here */
 				NCR_700_unmap(hostdata, SCp, slot);
 				dma_unmap_single(hostdata->dev, slot->pCmd,
-						 sizeof(SCp->cmnd),
+						 MAX_COMMAND_SIZE,
 						 DMA_TO_DEVICE);
 
 				cmnd[0] = REQUEST_SENSE;
@@ -1901,7 +1901,7 @@ NCR_700_queuecommand(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
 	}
 	slot->resume_offset = 0;
 	slot->pCmd = dma_map_single(hostdata->dev, SCp->cmnd,
-				    sizeof(SCp->cmnd), DMA_TO_DEVICE);
+				    MAX_COMMAND_SIZE, DMA_TO_DEVICE);
 	NCR_700_start_command(SCp);
 	return 0;
 }
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 792b2e8..ced3eeb 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -895,7 +895,7 @@ static void inia100_build_scb(struct orc_host * host, struct orc_scb * scb, stru
 	} else {
 		scb->tag_msg = 0;	/* No tag support               */
 	}
-	memcpy(&scb->cdb[0], &cmd->cmnd, scb->cdb_len);
+	memcpy(scb->cdb, cmd->cmnd, scb->cdb_len);
 }
 
 /**
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index c6d6e7c..8e2e964 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -465,7 +465,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     scp->request = (struct request *)&wait;
     scp->timeout_per_command = timeout*HZ;
     scp->cmd_len = 12;
-    memcpy(scp->cmnd, cmnd, 12);
+    scp->cmnd = cmnd;
     cmndinfo.priority = IOCTL_PRI;
     cmndinfo.internal_cmd_str = gdtcmd;
     cmndinfo.internal_command = 1;
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index beecda9..a24c5e3 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -763,9 +763,9 @@ static int hptiop_queuecommand(struct scsi_cmnd *scp,
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
index 78d46a9..df9b865 100644
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
index dbae3fd..e3f7397 100644
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
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 68c0d09..b53420b 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2863,7 +2863,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 
 	/* Load SCSI command packet. */
 	pkt->cdb_len = cpu_to_le16(CMD_CDBLEN(cmd));
-	memcpy(pkt->scsi_cdb, &(CMD_CDBP(cmd)), CMD_CDBLEN(cmd));
+	memcpy(pkt->scsi_cdb, CMD_CDBP(cmd), CMD_CDBLEN(cmd));
 	/* dprintk(1, "Build packet for command[0]=0x%x\n",pkt->scsi_cdb[0]); */
 
 	/* Set transfer direction. */
@@ -3132,7 +3132,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 
 	/* Load SCSI command packet. */
 	pkt->cdb_len = cpu_to_le16(CMD_CDBLEN(cmd));
-	memcpy(pkt->scsi_cdb, &(CMD_CDBP(cmd)), CMD_CDBLEN(cmd));
+	memcpy(pkt->scsi_cdb, CMD_CDBP(cmd), CMD_CDBLEN(cmd));
 
 	/*dprintk(1, "Build packet for command[0]=0x%x\n",pkt->scsi_cdb[0]); */
 	/* Set transfer direction. */
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 221f31e..8b5748a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -626,7 +626,7 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
  * @scmd:       SCSI command structure to hijack
  * @ses:        structure to save restore information
  * @cmnd:       CDB to send. Can be NULL if no new cmnd is needed
- * @cmnd_size:  size in bytes of @cmnd
+ * @cmnd_size:  size in bytes of @cmnd (must be <= BLK_MAX_CDB)
  * @sense_bytes: size of sense data to copy. or 0 (if != 0 @cmnd is ignored)
  *
  * This function is used to save a scsi command information before re-execution
@@ -648,12 +648,14 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
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
 
@@ -665,14 +667,13 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 		scmd->sdb.table.sgl = &ses->sense_sgl;
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
 		scmd->sdb.table.nents = 1;
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
@@ -705,7 +706,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	 * Restore original data
 	 */
 	scmd->cmd_len = ses->cmd_len;
-	memcpy(scmd->cmnd, ses->cmnd, sizeof(scmd->cmnd));
+	scmd->cmnd = ses->cmnd;
 	scmd->sc_data_direction = ses->data_direction;
 	scmd->sdb = ses->sdb;
 	scmd->request->next_rq = ses->next_rq;
@@ -1774,7 +1775,8 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	scmd->request = &req;
 	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
 
-	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
+	scmd->cmnd = req.cmd;
+	memset(scmd->cmnd, 0, BLK_MAX_CDB);
     
 	scmd->scsi_done		= scsi_reset_provider_done_command;
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 67f412b..325270b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1090,6 +1090,8 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 	cmd->tag = req->tag;
 	cmd->request = req;
 
+	cmd->cmnd = req->cmd;
+
 	return cmd;
 }
 
@@ -1127,8 +1129,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		req->buffer = NULL;
 	}
 
-	BUILD_BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
-	memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
 	cmd->cmd_len = req->cmd_len;
 	if (!req->data_len)
 		cmd->sc_data_direction = DMA_NONE;
@@ -1165,6 +1165,7 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 	if (unlikely(!cmd))
 		return BLKPREP_DEFER;
 
+	memset(cmd->cmnd, 0, BLK_MAX_CDB);
 	return scsi_init_io(cmd, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(scsi_setup_fs_cmnd);
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index a0f308b..8c92ef3 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -107,6 +107,8 @@ struct scsi_cmnd *scsi_host_get_command(struct Scsi_Host *shost,
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->request = rq;
 
+	cmd->cmnd = rq->cmd;
+
 	rq->special = cmd;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_flags |= REQ_TYPE_BLOCK_PC;
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 971d13d..3addcd8 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -292,6 +292,7 @@ struct isd200_info {
 
 	/* maximum number of LUNs supported */
 	unsigned char MaxLUNs;
+	unsigned char cmnd[BLK_MAX_CDB];
 	struct scsi_cmnd srb;
 	struct scatterlist sg;
 };
@@ -450,6 +451,7 @@ static int isd200_action( struct us_data *us, int action,
 
 	memset(&ata, 0, sizeof(ata));
 	memset(&srb_dev, 0, sizeof(srb_dev));
+	srb->cmnd = info->cmnd;
 	srb->device = &srb_dev;
 	++srb->serial_number;
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8d20e60..dea73e5 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -7,10 +7,28 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
+#include <linux/blkdev.h>
 
 struct Scsi_Host;
 struct scsi_device;
 
+/*
+ * MAX_COMMAND_SIZE is:
+ * The longest fixed-length SCSI CDB as per the SCSI standard.
+ * fixed-length means: commands that their size can be determined
+ * by their opcode and the CDB does not carry a length specifier, (unlike
+ * the VARIABLE_LENGTH_CMD(0x7f) command). This is actually not exactly
+ * true and the SCSI standard also defines extended commands and
+ * vendor specific commands that can be bigger than 16 bytes. The kernel
+ * will support these using the same infrastructure used for VARLEN CDB's.
+ * So in effect MAX_COMMAND_SIZE means the maximum size command scsi-ml
+ * supports without specifying a cmd_len by ULD's
+ */
+#define MAX_COMMAND_SIZE 16
+#if (MAX_COMMAND_SIZE > BLK_MAX_CDB)
+# error MAX_COMMAND_SIZE can not be smaller than BLK_MAX_CDB
+#endif
+
 struct scsi_data_buffer {
 	struct sg_table table;
 	unsigned length;
@@ -64,8 +82,7 @@ struct scsi_cmnd {
 	enum dma_data_direction sc_data_direction;
 
 	/* These elements define the operation we are about to perform */
-#define MAX_COMMAND_SIZE	16
-	unsigned char cmnd[MAX_COMMAND_SIZE];
+	unsigned char *cmnd;
 
 	struct timer_list eh_timeout;	/* Used to time out the command. */
 
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index d3a133b..2a9add2 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -75,11 +75,11 @@ struct scsi_eh_save {
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


