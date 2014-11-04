From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/11] scsi: remove abuses of scsi_populate_tag
Date: Tue,  4 Nov 2014 08:54:10 +0100
Message-ID: <1415087656-9491-6-git-send-email-hch@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34654 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaKDHyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 02:54:14 -0500
In-Reply-To: <1415087656-9491-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

Unless we want to build a SPI tag message we should just check SCMD_TAGGED
instead of reverse engineering a tag type through the use of
scsi_populate_tag_msg.

Also rename the function to spi_populate_tag_msg, make it behave like the
other spi message helpers, and move it to the spi transport class.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/s390/scsi/zfcp_fc.h        | 14 +-----
 drivers/scsi/53c700.c              |  2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c |  9 ----
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 10 +----
 drivers/scsi/bnx2fc/bnx2fc_io.c    | 18 ++------
 drivers/scsi/csiostor/csio_scsi.c  | 29 ++----------
 drivers/scsi/esp_scsi.c            |  2 +-
 drivers/scsi/fnic/fnic_scsi.c      | 11 +----
 drivers/scsi/ibmvscsi/ibmvfc.c     | 16 ++-----
 drivers/scsi/ipr.c                 | 34 ++------------
 drivers/scsi/lpfc/lpfc_scsi.c      | 16 +------
 drivers/scsi/pmcraid.c             | 34 ++------------
 drivers/scsi/qla2xxx/qla_iocb.c    | 92 ++------------------------------------
 drivers/scsi/qla2xxx/qla_mr.c      | 13 ------
 drivers/scsi/qla4xxx/ql4_iocb.c    | 10 -----
 drivers/scsi/scsi_transport_spi.c  | 23 ++++++++++
 drivers/scsi/tmscsim.c             | 12 +++--
 include/scsi/scsi_tcq.h            | 21 ---------
 include/scsi/scsi_transport_spi.h  |  1 +
 19 files changed, 56 insertions(+), 311 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
index b1d2024..df2b541 100644
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -212,8 +212,6 @@ static inline
 void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi,
 			 u8 tm_flags)
 {
-	char tag[2];
-
 	int_to_scsilun(scsi->device->lun, (struct scsi_lun *) &fcp->fc_lun);
 
 	if (unlikely(tm_flags)) {
@@ -221,17 +219,7 @@ void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi,
 		return;
 	}
 
-	if (scsi_populate_tag_msg(scsi, tag)) {
-		switch (tag[0]) {
-		case MSG_ORDERED_TAG:
-			fcp->fc_pri_ta |= FCP_PTA_ORDERED;
-			break;
-		case MSG_SIMPLE_TAG:
-			fcp->fc_pri_ta |= FCP_PTA_SIMPLE;
-			break;
-		};
-	} else
-		fcp->fc_pri_ta = FCP_PTA_SIMPLE;
+	fcp->fc_pri_ta = FCP_PTA_SIMPLE;
 
 	if (scsi->sc_data_direction == DMA_FROM_DEVICE)
 		fcp->fc_flags |= FCP_CFL_RDDATA;
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 5143d32..1b36fd3 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1427,7 +1427,7 @@ NCR_700_start_command(struct scsi_cmnd *SCp)
 	if((hostdata->tag_negotiated & (1<<scmd_id(SCp)))
 	   && (slot->tag != SCSI_NO_TAG && SCp->cmnd[0] != REQUEST_SENSE &&
 	       slot->flags != NCR_700_FLAG_AUTOSENSE)) {
-		count += scsi_populate_tag_msg(SCp, &hostdata->msgout[count]);
+		count += spi_populate_tag_msg(&hostdata->msgout[count], SCp);
 	}
 
 	if(hostdata->fast &&
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index ed333669..d3b6d68 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1619,15 +1619,6 @@ ahd_linux_run_command(struct ahd_softc *ahd, struct ahd_linux_device *dev,
 	}
 
 	if ((dev->flags & (AHD_DEV_Q_TAGGED|AHD_DEV_Q_BASIC)) != 0) {
-		int	msg_bytes;
-		uint8_t tag_msgs[2];
-
-		msg_bytes = scsi_populate_tag_msg(cmd, tag_msgs);
-		if (msg_bytes && tag_msgs[0] != MSG_SIMPLE_TASK) {
-			hscb->control |= tag_msgs[0];
-			if (tag_msgs[0] == MSG_ORDERED_TASK)
-				dev->commands_since_idle_or_otag = 0;
-		} else
 		if (dev->commands_since_idle_or_otag == AHD_OTAG_THRESH
 		 && (dev->flags & AHD_DEV_Q_TAGGED) != 0) {
 			hscb->control |= MSG_ORDERED_TASK;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 63bae7c..33a5f95 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1501,15 +1501,7 @@ ahc_linux_run_command(struct ahc_softc *ahc, struct ahc_linux_device *dev,
 	}
 
 	if ((dev->flags & (AHC_DEV_Q_TAGGED|AHC_DEV_Q_BASIC)) != 0) {
-		int	msg_bytes;
-		uint8_t tag_msgs[2];
-		
-		msg_bytes = scsi_populate_tag_msg(cmd, tag_msgs);
-		if (msg_bytes && tag_msgs[0] != MSG_SIMPLE_TASK) {
-			hscb->control |= tag_msgs[0];
-			if (tag_msgs[0] == MSG_ORDERED_TASK)
-				dev->commands_since_idle_or_otag = 0;
-		} else if (dev->commands_since_idle_or_otag == AHC_OTAG_THRESH
+		if (dev->commands_since_idle_or_otag == AHC_OTAG_THRESH
 				&& (dev->flags & AHC_DEV_Q_TAGGED) != 0) {
 			hscb->control |= MSG_ORDERED_TASK;
 			dev->commands_since_idle_or_otag = 0;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 0679782..3764978 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1725,7 +1725,6 @@ void bnx2fc_build_fcp_cmnd(struct bnx2fc_cmd *io_req,
 				  struct fcp_cmnd *fcp_cmnd)
 {
 	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
-	char tag[2];
 
 	memset(fcp_cmnd, 0, sizeof(struct fcp_cmnd));
 
@@ -1739,21 +1738,10 @@ void bnx2fc_build_fcp_cmnd(struct bnx2fc_cmd *io_req,
 	fcp_cmnd->fc_tm_flags = io_req->mp_req.tm_flags;
 	fcp_cmnd->fc_flags = io_req->io_req_flags;
 
-	if (scsi_populate_tag_msg(sc_cmd, tag)) {
-		switch (tag[0]) {
-		case HEAD_OF_QUEUE_TAG:
-			fcp_cmnd->fc_pri_ta = FCP_PTA_HEADQ;
-			break;
-		case ORDERED_QUEUE_TAG:
-			fcp_cmnd->fc_pri_ta = FCP_PTA_ORDERED;
-			break;
-		default:
-			fcp_cmnd->fc_pri_ta = FCP_PTA_SIMPLE;
-			break;
-		}
-	} else {
+	if (sc_cmd->flags & SCMD_TAGGED)
+		fcp_cmnd->fc_pri_ta = FCP_PTA_SIMPLE;
+	else
 		fcp_cmnd->fc_pri_ta = 0;
-	}
 }
 
 static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 86103c8..8231505 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -152,28 +152,6 @@ csio_scsi_itnexus_loss_error(uint16_t error)
 	return 0;
 }
 
-static inline void
-csio_scsi_tag(struct scsi_cmnd *scmnd, uint8_t *tag, uint8_t hq,
-	      uint8_t oq, uint8_t sq)
-{
-	char stag[2];
-
-	if (scsi_populate_tag_msg(scmnd, stag)) {
-		switch (stag[0]) {
-		case HEAD_OF_QUEUE_TAG:
-			*tag = hq;
-			break;
-		case ORDERED_QUEUE_TAG:
-			*tag = oq;
-			break;
-		default:
-			*tag = sq;
-			break;
-		}
-	} else
-		*tag = 0;
-}
-
 /*
  * csio_scsi_fcp_cmnd - Frame the SCSI FCP command paylod.
  * @req: IO req structure.
@@ -192,11 +170,12 @@ csio_scsi_fcp_cmnd(struct csio_ioreq *req, void *addr)
 		int_to_scsilun(scmnd->device->lun, &fcp_cmnd->fc_lun);
 		fcp_cmnd->fc_tm_flags = 0;
 		fcp_cmnd->fc_cmdref = 0;
-		fcp_cmnd->fc_pri_ta = 0;
 
 		memcpy(fcp_cmnd->fc_cdb, scmnd->cmnd, 16);
-		csio_scsi_tag(scmnd, &fcp_cmnd->fc_pri_ta,
-			      FCP_PTA_HEADQ, FCP_PTA_ORDERED, FCP_PTA_SIMPLE);
+		if (scmnd->flags & SCMD_TAGGED)
+			fcp_cmnd->fc_pri_ta = FCP_PTA_SIMPLE;
+		else
+			fcp_cmnd->fc_pri_ta = 0;
 		fcp_cmnd->fc_dl = cpu_to_be32(scsi_bufflen(scmnd));
 
 		if (req->nsge)
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 55548dc..b23101b 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -663,7 +663,7 @@ static struct esp_cmd_entry *find_and_prep_issuable_command(struct esp *esp)
 			return ent;
 		}
 
-		if (!scsi_populate_tag_msg(cmd, &ent->tag[0])) {
+		if (!spi_populate_tag_msg(&ent->tag[0], cmd)) {
 			ent->tag[0] = 0;
 			ent->tag[1] = 0;
 		}
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 961bdf5..10d5c6b 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -325,13 +325,11 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 	struct fc_rport_libfc_priv *rp = rport->dd_data;
 	struct host_sg_desc *desc;
 	struct misc_stats *misc_stats = &fnic->fnic_stats.misc_stats;
-	u8 pri_tag = 0;
 	unsigned int i;
 	unsigned long intr_flags;
 	int flags;
 	u8 exch_flags;
 	struct scsi_lun fc_lun;
-	char msg[2];
 
 	if (sg_count) {
 		/* For each SGE, create a device desc entry */
@@ -357,12 +355,6 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 
 	int_to_scsilun(sc->device->lun, &fc_lun);
 
-	pri_tag = FCPIO_ICMND_PTA_SIMPLE;
-	msg[0] = MSG_SIMPLE_TAG;
-	scsi_populate_tag_msg(sc, msg);
-	if (msg[0] == MSG_ORDERED_TAG)
-		pri_tag = FCPIO_ICMND_PTA_ORDERED;
-
 	/* Enqueue the descriptor in the Copy WQ */
 	spin_lock_irqsave(&fnic->wq_copy_lock[0], intr_flags);
 
@@ -394,7 +386,8 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 					 io_req->sgl_list_pa,
 					 io_req->sense_buf_pa,
 					 0, /* scsi cmd ref, always 0 */
-					 pri_tag, /* scsi pri and tag */
+					 FCPIO_ICMND_PTA_SIMPLE,
+					 	/* scsi pri and tag */
 					 flags,	/* command flags */
 					 sc->cmnd, sc->cmd_len,
 					 scsi_bufflen(sc),
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 48d19a3..a964f8c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1643,19 +1643,9 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 	int_to_scsilun(cmnd->device->lun, &vfc_cmd->iu.lun);
 	memcpy(vfc_cmd->iu.cdb, cmnd->cmnd, cmnd->cmd_len);
 
-	if (scsi_populate_tag_msg(cmnd, tag)) {
-		vfc_cmd->task_tag = cpu_to_be64(tag[1]);
-		switch (tag[0]) {
-		case MSG_SIMPLE_TAG:
-			vfc_cmd->iu.pri_task_attr = IBMVFC_SIMPLE_TASK;
-			break;
-		case MSG_HEAD_TAG:
-			vfc_cmd->iu.pri_task_attr = IBMVFC_HEAD_OF_QUEUE;
-			break;
-		case MSG_ORDERED_TAG:
-			vfc_cmd->iu.pri_task_attr = IBMVFC_ORDERED_TASK;
-			break;
-		};
+	if (cmnd->flags & SCMD_TAGGED) {
+		vfc_cmd->task_tag = cpu_to_be64(cmnd->tag);
+		vfc_cmd->iu.pri_task_attr = IBMVFC_SIMPLE_TASK;
 	}
 
 	if (likely(!(rc = ibmvfc_map_sg_data(cmnd, evt, vfc_cmd, vhost->dev))))
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 746a488..d6485a1 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5752,35 +5752,6 @@ static int ipr_build_ioadl(struct ipr_ioa_cfg *ioa_cfg,
 }
 
 /**
- * ipr_get_task_attributes - Translate SPI Q-Tag to task attributes
- * @scsi_cmd:	scsi command struct
- *
- * Return value:
- * 	task attributes
- **/
-static u8 ipr_get_task_attributes(struct scsi_cmnd *scsi_cmd)
-{
-	u8 tag[2];
-	u8 rc = IPR_FLAGS_LO_UNTAGGED_TASK;
-
-	if (scsi_populate_tag_msg(scsi_cmd, tag)) {
-		switch (tag[0]) {
-		case MSG_SIMPLE_TAG:
-			rc = IPR_FLAGS_LO_SIMPLE_TASK;
-			break;
-		case MSG_HEAD_TAG:
-			rc = IPR_FLAGS_LO_HEAD_OF_Q_TASK;
-			break;
-		case MSG_ORDERED_TAG:
-			rc = IPR_FLAGS_LO_ORDERED_TASK;
-			break;
-		};
-	}
-
-	return rc;
-}
-
-/**
  * ipr_erp_done - Process completion of ERP for a device
  * @ipr_cmd:		ipr command struct
  *
@@ -6315,7 +6286,10 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 			ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_DELAY_AFTER_RST;
 		}
 		ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_ALIGNED_BFR;
-		ioarcb->cmd_pkt.flags_lo |= ipr_get_task_attributes(scsi_cmd);
+		if (scsi_cmd->flags & SCMD_TAGGED)
+			ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_SIMPLE_TASK;
+		else
+			ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_UNTAGGED_TASK;
 	}
 
 	if (scsi_cmd->cmnd[0] >= 0xC0 &&
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 2896e52..4a15006 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4266,7 +4266,6 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
 	struct lpfc_iocbq *piocbq = &(lpfc_cmd->cur_iocbq);
 	int datadir = scsi_cmnd->sc_data_direction;
-	char tag[2];
 	uint8_t *ptr;
 	bool sli4;
 	uint32_t fcpdl;
@@ -4288,20 +4287,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		memset(ptr, 0, (LPFC_FCP_CDB_LEN - scsi_cmnd->cmd_len));
 	}
 
-	if (scsi_populate_tag_msg(scsi_cmnd, tag)) {
-		switch (tag[0]) {
-		case HEAD_OF_QUEUE_TAG:
-			fcp_cmnd->fcpCntl1 = HEAD_OF_Q;
-			break;
-		case ORDERED_QUEUE_TAG:
-			fcp_cmnd->fcpCntl1 = ORDERED_Q;
-			break;
-		default:
-			fcp_cmnd->fcpCntl1 = SIMPLE_Q;
-			break;
-		}
-	} else
-		fcp_cmnd->fcpCntl1 = SIMPLE_Q;
+	fcp_cmnd->fcpCntl1 = SIMPLE_Q;
 
 	sli4 = (phba->sli_rev == LPFC_SLI_REV4);
 	piocbq->iocb.un.fcpi.fcpi_XRdy = 0;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 2233ed6..d5fb31fa 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3169,36 +3169,6 @@ static int pmcraid_eh_host_reset_handler(struct scsi_cmnd *scmd)
 }
 
 /**
- * pmcraid_task_attributes - Translate SPI Q-Tags to task attributes
- * @scsi_cmd:   scsi command struct
- *
- * Return value
- *	  number of tags or 0 if the task is not tagged
- */
-static u8 pmcraid_task_attributes(struct scsi_cmnd *scsi_cmd)
-{
-	char tag[2];
-	u8 rc = 0;
-
-	if (scsi_populate_tag_msg(scsi_cmd, tag)) {
-		switch (tag[0]) {
-		case MSG_SIMPLE_TAG:
-			rc = TASK_TAG_SIMPLE;
-			break;
-		case MSG_HEAD_TAG:
-			rc = TASK_TAG_QUEUE_HEAD;
-			break;
-		case MSG_ORDERED_TAG:
-			rc = TASK_TAG_ORDERED;
-			break;
-		};
-	}
-
-	return rc;
-}
-
-
-/**
  * pmcraid_init_ioadls - initializes IOADL related fields in IOARCB
  * @cmd: pmcraid command struct
  * @sgcount: count of scatter-gather elements
@@ -3553,7 +3523,9 @@ static int pmcraid_queuecommand_lck(
 		}
 
 		ioarcb->request_flags0 |= NO_LINK_DESCS;
-		ioarcb->request_flags1 |= pmcraid_task_attributes(scsi_cmd);
+
+		if (scsi_cmd->flags & SCMD_TAGGED)
+			ioarcb->request_flags1 |= TASK_TAG_SIMPLE;
 
 		if (RES_IS_GSCSI(res->cfg_entry))
 			ioarcb->request_flags1 |= DELAY_AFTER_RESET;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index f0edb07..a1ab25f 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -325,7 +325,6 @@ qla2x00_start_scsi(srb_t *sp)
 	struct qla_hw_data *ha;
 	struct req_que *req;
 	struct rsp_que *rsp;
-	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
@@ -404,26 +403,7 @@ qla2x00_start_scsi(srb_t *sp)
 	/* Set target ID and LUN number*/
 	SET_TARGET_ID(ha, cmd_pkt->target, sp->fcport->loop_id);
 	cmd_pkt->lun = cpu_to_le16(cmd->device->lun);
-
-	/* Update tagged queuing modifier */
-	if (scsi_populate_tag_msg(cmd, tag)) {
-		switch (tag[0]) {
-		case HEAD_OF_QUEUE_TAG:
-			cmd_pkt->control_flags =
-			    __constant_cpu_to_le16(CF_HEAD_TAG);
-			break;
-		case ORDERED_QUEUE_TAG:
-			cmd_pkt->control_flags =
-			    __constant_cpu_to_le16(CF_ORDERED_TAG);
-			break;
-		default:
-			cmd_pkt->control_flags =
-			    __constant_cpu_to_le16(CF_SIMPLE_TAG);
-			break;
-		}
-	} else {
-		cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
-	}
+	cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
 
 	/* Load SCSI command packet. */
 	memcpy(cmd_pkt->scsi_cdb, cmd->cmnd, cmd->cmd_len);
@@ -1264,7 +1244,6 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	uint16_t		fcp_cmnd_len;
 	struct fcp_cmnd		*fcp_cmnd;
 	dma_addr_t		crc_ctx_dma;
-	char			tag[2];
 
 	cmd = GET_CMD_SP(sp);
 
@@ -1356,25 +1335,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	cmd_pkt->fcp_cmnd_dseg_address[1] = cpu_to_le32(
 	    MSD(crc_ctx_dma + CRC_CONTEXT_FCPCMND_OFF));
 	fcp_cmnd->task_management = 0;
-
-	/*
-	 * Update tagged queuing modifier if using command tag queuing
-	 */
-	if (scsi_populate_tag_msg(cmd, tag)) {
-		switch (tag[0]) {
-		case HEAD_OF_QUEUE_TAG:
-		    fcp_cmnd->task_attribute = TSK_HEAD_OF_QUEUE;
-		    break;
-		case ORDERED_QUEUE_TAG:
-		    fcp_cmnd->task_attribute = TSK_ORDERED;
-		    break;
-		default:
-		    fcp_cmnd->task_attribute = TSK_SIMPLE;
-		    break;
-		}
-	} else {
-		fcp_cmnd->task_attribute = TSK_SIMPLE;
-	}
+	fcp_cmnd->task_attribute = TSK_SIMPLE;
 
 	cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status iocb */
 
@@ -1495,7 +1456,6 @@ qla24xx_start_scsi(srb_t *sp)
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
-	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
@@ -1578,22 +1538,7 @@ qla24xx_start_scsi(srb_t *sp)
 	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
 	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
 
-	/* Update tagged queuing modifier -- default is TSK_SIMPLE (0). */
-	if (scsi_populate_tag_msg(cmd, tag)) {
-		switch (tag[0]) {
-		case HEAD_OF_QUEUE_TAG:
-			cmd_pkt->task = TSK_HEAD_OF_QUEUE;
-			break;
-		case ORDERED_QUEUE_TAG:
-			cmd_pkt->task = TSK_ORDERED;
-			break;
-		default:
-		    cmd_pkt->task = TSK_SIMPLE;
-		    break;
-		}
-	} else {
-		cmd_pkt->task = TSK_SIMPLE;
-	}
+	cmd_pkt->task = TSK_SIMPLE;
 
 	/* Load SCSI command packet. */
 	memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
@@ -2310,7 +2255,6 @@ qla82xx_start_scsi(srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
-	char tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
@@ -2489,22 +2433,6 @@ sufficient_dsds:
 		else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
 			ctx->fcp_cmnd->additional_cdb_len |= 2;
 
-		/*
-		 * Update tagged queuing modifier -- default is TSK_SIMPLE (0).
-		 */
-		if (scsi_populate_tag_msg(cmd, tag)) {
-			switch (tag[0]) {
-			case HEAD_OF_QUEUE_TAG:
-				ctx->fcp_cmnd->task_attribute =
-				    TSK_HEAD_OF_QUEUE;
-				break;
-			case ORDERED_QUEUE_TAG:
-				ctx->fcp_cmnd->task_attribute =
-				    TSK_ORDERED;
-				break;
-			}
-		}
-
 		/* Populate the FCP_PRIO. */
 		if (ha->flags.fcp_prio_enabled)
 			ctx->fcp_cmnd->task_attribute |=
@@ -2565,20 +2493,6 @@ sufficient_dsds:
 		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun,
 		    sizeof(cmd_pkt->lun));
 
-		/*
-		 * Update tagged queuing modifier -- default is TSK_SIMPLE (0).
-		 */
-		if (scsi_populate_tag_msg(cmd, tag)) {
-			switch (tag[0]) {
-			case HEAD_OF_QUEUE_TAG:
-				cmd_pkt->task = TSK_HEAD_OF_QUEUE;
-				break;
-			case ORDERED_QUEUE_TAG:
-				cmd_pkt->task = TSK_ORDERED;
-				break;
-			}
-		}
-
 		/* Populate the FCP_PRIO. */
 		if (ha->flags.fcp_prio_enabled)
 			cmd_pkt->task |= sp->fcport->fcp_prio << 3;
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 8086759..6d190b4 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -3086,7 +3086,6 @@ qlafx00_start_scsi(srb_t *sp)
 	struct cmd_type_7_fx00 *cmd_pkt;
 	struct cmd_type_7_fx00 lcmd_pkt;
 	struct scsi_lun llun;
-	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
@@ -3157,18 +3156,6 @@ qlafx00_start_scsi(srb_t *sp)
 	host_to_adap((uint8_t *)&llun, (uint8_t *)&lcmd_pkt.lun,
 	    sizeof(lcmd_pkt.lun));
 
-	/* Update tagged queuing modifier -- default is TSK_SIMPLE (0). */
-	if (scsi_populate_tag_msg(cmd, tag)) {
-		switch (tag[0]) {
-		case HEAD_OF_QUEUE_TAG:
-			lcmd_pkt.task = TSK_HEAD_OF_QUEUE;
-			break;
-		case ORDERED_QUEUE_TAG:
-			lcmd_pkt.task = TSK_ORDERED;
-			break;
-		}
-	}
-
 	/* Load SCSI command packet. */
 	host_to_adap(cmd->cmnd, lcmd_pkt.fcp_cdb, sizeof(lcmd_pkt.fcp_cdb));
 	lcmd_pkt.byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index 08ab6da..17222eb 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -280,7 +280,6 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 	uint16_t req_cnt;
 	unsigned long flags;
 	uint32_t index;
-	char tag[2];
 
 	/* Get real lun and adapter */
 	ddb_entry = srb->ddb;
@@ -352,15 +351,6 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 
 	/* Set tagged queueing control flags */
 	cmd_entry->control_flags |= CF_SIMPLE_TAG;
-	if (scsi_populate_tag_msg(cmd, tag))
-		switch (tag[0]) {
-		case MSG_HEAD_TAG:
-			cmd_entry->control_flags |= CF_HEAD_TAG;
-			break;
-		case MSG_ORDERED_TAG:
-			cmd_entry->control_flags |= CF_ORDERED_TAG;
-			break;
-		}
 
 	qla4xxx_advance_req_ring_ptr(ha);
 	qla4xxx_build_scsi_iocbs(srb, cmd_entry, tot_dsds);
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index cf08071..470afbc 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -32,6 +32,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_spi.h>
 
@@ -1207,6 +1208,28 @@ int spi_populate_ppr_msg(unsigned char *msg, int period, int offset,
 }
 EXPORT_SYMBOL_GPL(spi_populate_ppr_msg);
 
+/**
+ * scsi_populate_tag_msg - place a tag message in a buffer
+ * @msg:	pointer to the area to place the tag
+ * @cmd:	pointer to the scsi command for the tag
+ *
+ * Notes:
+ *	designed to create the correct type of tag message for the 
+ *	particular request.  Returns the size of the tag message.
+ *	May return 0 if TCQ is disabled for this device.
+ **/
+int spi_populate_tag_msg(unsigned char *msg, struct scsi_cmnd *cmd)
+{
+        if (cmd->flags & SCMD_TAGGED) {
+		*msg++ = MSG_SIMPLE_TAG;
+        	*msg++ = cmd->request->tag;
+        	return 2;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(spi_populate_tag_msg);
+
 #ifdef CONFIG_SCSI_CONSTANTS
 static const char * const one_byte_msgs[] = {
 /* 0x00 */ "Task Complete", NULL /* Extended Message */, "Save Pointers",
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 7645757..5478124 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -243,7 +243,6 @@
 #include <scsi/scsicam.h>
 #include <scsi/scsi_tcq.h>
 
-
 #define DC390_BANNER "Tekram DC390/AM53C974"
 #define DC390_VERSION "2.1d 2004-05-27"
 
@@ -508,7 +507,6 @@ dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_sr
     struct scsi_cmnd *scmd = pSRB->pcmd;
     struct scsi_device *sdev = scmd->device;
     u8 cmd, disc_allowed, try_sync_nego;
-    char tag[2];
 
     pSRB->ScsiPhase = SCSI_NOP0;
 
@@ -560,11 +558,11 @@ dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_sr
     cmd = SEL_W_ATN;
     DC390_write8 (ScsiFifo, IDENTIFY(disc_allowed, pDCB->TargetLUN));
     /* Change 99/05/31: Don't use tags when not disconnecting (BUSY) */
-    if ((pDCB->SyncMode & EN_TAG_QUEUEING) && disc_allowed && scsi_populate_tag_msg(scmd, tag)) {
-	DC390_write8(ScsiFifo, tag[0]);
-	pDCB->TagMask |= 1 << tag[1];
-	pSRB->TagNumber = tag[1];
-	DC390_write8(ScsiFifo, tag[1]);
+    if ((pDCB->SyncMode & EN_TAG_QUEUEING) && disc_allowed && (scmd->flags & SCMD_TAGGED)) {
+	DC390_write8(ScsiFifo, MSG_SIMPLE_TAG);
+	pDCB->TagMask |= 1 << scmd->request->tag;
+	pSRB->TagNumber = scmd->request->tag;
+	DC390_write8(ScsiFifo, scmd->request->tag);
 	DEBUG1(printk(KERN_INFO "DC390: Select w/DisCn for SRB %p, block tag %02x\n", pSRB, tag[1]));
 	cmd = SEL_W_ATN3;
     } else {
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index ccaafc8..6124127 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -80,27 +80,6 @@ static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
 	scsi_adjust_queue_depth(sdev, 0, depth);
 }
 
-/**
- * scsi_populate_tag_msg - place a tag message in a buffer
- * @SCpnt:	pointer to the Scsi_Cmnd for the tag
- * @msg:	pointer to the area to place the tag
- *
- * Notes:
- *	designed to create the correct type of tag message for the 
- *	particular request.  Returns the size of the tag message.
- *	May return 0 if TCQ is disabled for this device.
- **/
-static inline int scsi_populate_tag_msg(struct scsi_cmnd *cmd, char *msg)
-{
-        if (cmd->flags & SCMD_TAGGED) {
-		*msg++ = MSG_SIMPLE_TAG;
-        	*msg++ = cmd->request->tag;
-        	return 2;
-	}
-
-	return 0;
-}
-
 static inline struct scsi_cmnd *scsi_mq_find_tag(struct Scsi_Host *shost,
 		unsigned int hw_ctx, int tag)
 {
diff --git a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
index 7497a38..a4fa52b 100644
--- a/include/scsi/scsi_transport_spi.h
+++ b/include/scsi/scsi_transport_spi.h
@@ -157,5 +157,6 @@ int spi_populate_width_msg(unsigned char *msg, int width);
 int spi_populate_sync_msg(unsigned char *msg, int period, int offset);
 int spi_populate_ppr_msg(unsigned char *msg, int period, int offset, int width,
 		int options);
+int spi_populate_tag_msg(unsigned char *msg, struct scsi_cmnd *cmd);
 
 #endif /* SCSI_TRANSPORT_SPI_H */
-- 
1.9.1

