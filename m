From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/24][RFC] scsi-drivers: Move to new sense API. The Trevial case
Date: Mon,  4 Feb 2008 17:40:13 +0200
Message-ID: <1202139613-4554-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:46185 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYBDPqI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 10:46:08 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  All these drivers are trevialy converted from memcpy into command's
  sense_buffer from a driver private area, to the new scsi_eh_cpy_sense()
  API. Some also do amaturistic sense editing or printing.

  FIXME: weed out these drivers that this patch is a bugfix for.
	(copy more than what they have at private area)

  The list of converted drivers:
	   arch/ia64/hp/sim/simscsi.c
	   drivers/block/cciss_scsi.c
	   drivers/infiniband/ulp/srp/ib_srp.c
	   drivers/message/fusion/mptscsih.c
	   drivers/message/i2o/i2o_scsi.c
	   drivers/scsi/3w-9xxx.c
	   drivers/scsi/a100u2w.c
	   drivers/scsi/aha1542.c
	   drivers/scsi/aha1740.c
	   drivers/scsi/atp870u.c
	   drivers/scsi/hptiop.c
	   drivers/scsi/ibmvscsi/ibmvscsi.c
	   drivers/scsi/ibmvscsi/ibmvstgt.c
	   drivers/scsi/ide-scsi.c
	   drivers/scsi/libiscsi.c
	   drivers/scsi/libsas/sas_scsi_host.c
	   drivers/scsi/lpfc/lpfc_scsi.c
	   drivers/scsi/megaraid.c
	   drivers/scsi/megaraid/megaraid_sas.c
	   drivers/scsi/ncr53c8xx.c
	   drivers/scsi/qlogicpti.c
	   drivers/scsi/scsi_debug.c
	   drivers/scsi/sym53c8xx_2/sym_glue.c

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 arch/ia64/hp/sim/simscsi.c           |    8 ++++++--
 drivers/block/cciss_scsi.c           |    8 +++-----
 drivers/infiniband/ulp/srp/ib_srp.c  |    6 +++---
 drivers/message/fusion/mptscsih.c    |    9 +++++----
 drivers/message/i2o/i2o_scsi.c       |    4 ++--
 drivers/scsi/3w-9xxx.c               |    5 ++++-
 drivers/scsi/a100u2w.c               |    4 ++--
 drivers/scsi/aha1542.c               |    4 ++--
 drivers/scsi/aha1740.c               |    4 ++--
 drivers/scsi/atp870u.c               |    1 -
 drivers/scsi/hptiop.c                |    6 +++---
 drivers/scsi/ibmvscsi/ibmvscsi.c     |    4 +---
 drivers/scsi/ibmvscsi/ibmvstgt.c     |    2 +-
 drivers/scsi/ide-scsi.c              |    4 +++-
 drivers/scsi/libiscsi.c              |    6 ++----
 drivers/scsi/libsas/sas_scsi_host.c  |    3 +--
 drivers/scsi/lpfc/lpfc_scsi.c        |    9 ++++-----
 drivers/scsi/megaraid.c              |   14 +++++++++-----
 drivers/scsi/megaraid/megaraid_sas.c |    6 +++---
 drivers/scsi/ncr53c8xx.c             |    9 ++++-----
 drivers/scsi/qlogicpti.c             |    4 ++--
 drivers/scsi/scsi_debug.c            |    5 ++---
 drivers/scsi/sym53c8xx_2/sym_glue.c  |    5 ++---
 23 files changed, 66 insertions(+), 64 deletions(-)

diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index 7661bb0..c33c4b4 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -326,9 +326,13 @@ simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		}
 	}
 	if (sc->result == DID_BAD_TARGET) {
+		u8 sense_buffer[3];
 		sc->result |= DRIVER_SENSE << 24;
-		sc->sense_buffer[0] = 0x70;
-		sc->sense_buffer[2] = 0x00;
+
+		sense_buffer[0] = 0x70;
+		sense_buffer[1] = 0;
+		sense_buffer[2] = 0x00;
+		scsi_eh_cpy_sense(sc, sense_buffer, sizeof(sense_buffer));
 	}
 	if (atomic_read(&num_reqs) >= SIMSCSI_REQ_QUEUE_LEN) {
 		panic("Attempt to queue command while command is pending!!");
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 63ee6c0..1ccd225 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -37,7 +37,8 @@
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_host.h> 
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
 
 #include "cciss_scsi.h"
 
@@ -579,10 +580,7 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
 
 	/* copy the sense data whether we need to or not. */
 
-	memcpy(cmd->sense_buffer, ei->SenseInfo, 
-		ei->SenseLen > SCSI_SENSE_BUFFERSIZE ?
-			SCSI_SENSE_BUFFERSIZE : 
-			ei->SenseLen);
+	scsi_eh_cpy_sense(cmd, ei->SenseInfo, ei->SenseLen);
 	scsi_set_resid(cmd, ei->ResidualCnt);
 
 	if(ei->CommandStatus != 0) 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 195ce7c..0437585 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -48,6 +48,7 @@
 #include <scsi/scsi_dbg.h>
 #include <scsi/srp.h>
 #include <scsi/scsi_transport_srp.h>
+#include <scsi/scsi_eh.h>
 
 #include <rdma/ib_cache.h>
 
@@ -798,10 +799,9 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 		scmnd->result = rsp->status;
 
 		if (rsp->flags & SRP_RSP_FLAG_SNSVALID) {
-			memcpy(scmnd->sense_buffer, rsp->data +
+			scsi_eh_cpy_sense(scmnd, rsp->data +
 			       be32_to_cpu(rsp->resp_data_len),
-			       min_t(int, be32_to_cpu(rsp->sense_data_len),
-				     SCSI_SENSE_BUFFERSIZE));
+			       be32_to_cpu(rsp->sense_data_len));
 		}
 
 		if (rsp->flags & (SRP_RSP_FLAG_DOOVER | SRP_RSP_FLAG_DOUNDER))
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 5c614ec..8577fee 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -61,6 +61,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
 
 #include "mptbase.h"
 #include "mptscsih.h"
@@ -606,9 +607,9 @@ mptscsih_info_scsiio(MPT_ADAPTER *ioc, struct scsi_cmnd *sc, SCSIIOReply_t * pSc
 	    pScsiReply->SCSIState);
 
 	if (pScsiReply->SCSIState & MPI_SCSI_STATE_AUTOSENSE_VALID) {
-		skey = sc->sense_buffer[2] & 0x0F;
-		asc = sc->sense_buffer[12];
-		ascq = sc->sense_buffer[13];
+		skey = scsi_sense(sc)[2] & 0x0F;
+		asc = scsi_sense(sc)[12];
+		ascq = scsi_sense(sc)[13];
 
 		printk(MYIOC_s_DEBUG_FMT "\t[sense_key,asc,ascq]: "
 		    "[0x%02x,0x%02x,0x%02x]\n", ioc->name, skey, asc, ascq);
@@ -2501,7 +2502,7 @@ mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR
 		/* Copy the sense received into the scsi command block. */
 		req_index = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
 		sense_data = ((u8 *)ioc->sense_buf_pool + (req_index * MPT_SENSE_BUFFER_ALLOC));
-		memcpy(sc->sense_buffer, sense_data, SNS_LEN(sc));
+		scsi_eh_cpy_sense(sc, sense_data, MPT_SENSE_BUFFER_ALLOC);
 
 		/* Log SMART data (asc = 0x5D, non-IM case only) if required.
 		 */
diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index 1bcdbbb..0d089d9 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -65,6 +65,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/sg.h>
 
 #define OSM_NAME	"scsi-osm"
@@ -369,8 +370,7 @@ static int i2o_scsi_reply(struct i2o_controller *c, u32 m,
 	 * the SCSI layer handle the error
 	 */
 	if (cmd->result)
-		memcpy(cmd->sense_buffer, &msg->body[3],
-		       min(SCSI_SENSE_BUFFERSIZE, 40));
+		scsi_eh_cpy_sense(cmd, &msg->body[3], 40);
 
 	/* only output error code if AdapterStatus is not HBA_SUCCESS */
 	if ((error >> 8) & 0xff)
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index b4912d1..a8614a3 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -91,6 +91,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_eh.h>
 #include "3w-9xxx.h"
 
 /* Globals */
@@ -992,7 +993,9 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
 	}
 
 	if (copy_sense) {
-		memcpy(tw_dev->srb[request_id]->sense_buffer, full_command_packet->header.sense_data, TW_SENSE_DATA_LENGTH);
+		scsi_eh_cpy_sense(tw_dev->srb[request_id],
+			full_command_packet->header.sense_data,
+			TW_SENSE_DATA_LENGTH);
 		tw_dev->srb[request_id]->result = (full_command_packet->command.newcommand.status << 1);
 		retval = TW_ISR_DONT_RESULT;
 		goto out;
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 6335637..21b7079 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -79,6 +79,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
 
 #include "a100u2w.h"
 
@@ -1028,8 +1029,7 @@ static void inia100_scb_handler(struct orc_host *host, struct orc_scb *scb)
 	}
 
 	if (scb->tastat == 2) {	/* Check condition              */
-		memcpy((unsigned char *) &cmd->sense_buffer[0],
-		   (unsigned char *) &escb->sglist[0], SENSE_SIZE);
+		scsi_eh_cpy_sense(cmd, &escb->sglist[0], SENSE_SIZE);
 	}
 	cmd->result = scb->tastat | (scb->hastat << 16);
 	scsi_dma_unmap(cmd);
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 190568e..023d9c1 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -535,8 +535,8 @@ static void aha1542_intr_handle(struct Scsi_Host *shost, void *dev_id)
 		   Adaptec automatically fetches it, and there is no guarantee that
 		   we will still have it in the cdb when we come back */
 		if (ccb[mbo].tarstat == 2)
-			memcpy(SCtmp->sense_buffer, &ccb[mbo].cdb[ccb[mbo].cdblen],
-			       SCSI_SENSE_BUFFERSIZE);
+			scsi_eh_cpy_sense(SCtmp, &ccb[mbo].cdb[ccb[mbo].cdblen],
+			       ~0); /*FIXME: What is the card's max space here*/
 
 
 		/* is there mail :-) */
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 7c45d88..97f8fec 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -285,8 +285,8 @@ static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 			   guarantee that we will still have it in the
 			   cdb when we come back */
 			if ( (adapstat & G2INTST_MASK) == G2INTST_CCBERROR ) {
-				memcpy(SCtmp->sense_buffer, ecbptr->sense, 
-				       SCSI_SENSE_BUFFERSIZE);
+				scsi_eh_cpy_sense(SCtmp, ecbptr->sense,
+						sizeof(ecbptr->sense));
 				errstatus = aha1740_makecode(ecbptr->sense,ecbptr->status);
 			} else
 				errstatus = 0;
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index db6de5e..fb27f2c 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -613,7 +613,6 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 	struct Scsi_Host *host;
 
 	c = scmd_channel(req_p);
-	req_p->sense_buffer[0]=0;
 	scsi_set_resid(req_p, 0);
 	if (scmd_channel(req_p) > 1) {
 		req_p->result = 0x00040000;
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 514f05b..464978e 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -34,6 +34,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
 
 #include "hptiop.h"
 
@@ -573,9 +574,8 @@ static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
 		scsi_set_resid(scp,
 			scsi_bufflen(scp) - le32_to_cpu(req->dataxfer_length));
 		scp->result = SAM_STAT_CHECK_CONDITION;
-		memcpy(scp->sense_buffer, &req->sg_list,
-				min_t(size_t, SCSI_SENSE_BUFFERSIZE,
-					le32_to_cpu(req->dataxfer_length)));
+		scsi_eh_cpy_sense(scp, &req->sg_list,
+					le32_to_cpu(req->dataxfer_length));
 		break;
 
 	default:
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index df9b865..4527657 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -688,9 +688,7 @@ static void handle_cmd_rsp(struct srp_event_struct *evt_struct)
 	if (cmnd) {
 		cmnd->result = rsp->status;
 		if (((cmnd->result >> 1) & 0x1f) == CHECK_CONDITION)
-			memcpy(cmnd->sense_buffer,
-			       rsp->data,
-			       rsp->sense_data_len);
+			scsi_eh_cpy_sense(cmnd, rsp->data, rsp->sense_data_len);
 		unmap_cmd_data(&evt_struct->iu.srp.cmd, 
 			       evt_struct, 
 			       evt_struct->hostdata->dev);
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index d63f11e..67bc6a6 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -166,7 +166,7 @@ static int send_rsp(struct iu_entry *iue, struct scsi_cmnd *sc,
 		if (sc) {
 			iu->srp.rsp.flags |= SRP_RSP_FLAG_SNSVALID;
 			iu->srp.rsp.sense_data_len = SCSI_SENSE_BUFFERSIZE;
-			memcpy(sense, sc->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+			memcpy(sense, scsi_sense(sc), SCSI_SENSE_BUFFERSIZE);
 		} else {
 			iu->srp.rsp.status = SAM_STAT_CHECK_CONDITION;
 			iu->srp.rsp.flags |= SRP_RSP_FLAG_SNSVALID;
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 5ed0006..b40ff82 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -57,6 +57,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/sg.h>
+#include <scsi/scsi_eh.h>
 
 #define IDESCSI_DEBUG_LOG		0
 
@@ -333,7 +334,8 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 			printk ("ide-scsi: %s: wrap up check %lu, rst = ", drive->name, opc->scsi_cmd->serial_number);
 			ide_scsi_hex_dump(pc->buffer, 16);
 		}
-		memcpy((void *) opc->scsi_cmd->sense_buffer, pc->buffer, SCSI_SENSE_BUFFERSIZE);
+		scsi_eh_cpy_sense(opc->scsi_cmd, pc->buffer,
+				SCSI_SENSE_BUFFERSIZE);
 		kfree(pc->buffer);
 		kfree(pc);
 		kfree(rq);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1148793..c7f416e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -513,10 +513,8 @@ invalid_datalen:
 		if (datalen < senselen)
 			goto invalid_datalen;
 
-		memcpy(sc->sense_buffer, data + 2,
-		       min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
-		debug_scsi("copied %d bytes of sense\n",
-			   min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
+		scsi_eh_cpy_sense(sc, data + 2, senselen);
+		debug_scsi("copied %d bytes of sense\n", senselen);
 	}
 
 	if (scsi_bidi_cmnd(sc) &&
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f869fba..0be8ade 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -107,8 +107,7 @@ static void sas_scsi_task_done(struct sas_task *task)
 			hs = DID_ABORT;
 			break;
 		case SAM_CHECK_COND:
-			memcpy(sc->sense_buffer, ts->buf,
-			       min(SCSI_SENSE_BUFFERSIZE, ts->buf_valid_size));
+			scsi_eh_cpy_sense(sc, ts->buf, ts->buf_valid_size);
 			stat = SAM_CHECK_COND;
 			break;
 		default:
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index fc5c3a4..6eab521 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -28,6 +28,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_eh.h>
 
 #include "lpfc_version.h"
 #include "lpfc_hw.h"
@@ -424,14 +425,12 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 
 	if ((resp_info & SNS_LEN_VALID) && fcprsp->rspSnsLen) {
 		uint32_t snslen = be32_to_cpu(fcprsp->rspSnsLen);
-		if (snslen > SCSI_SENSE_BUFFERSIZE)
-			snslen = SCSI_SENSE_BUFFERSIZE;
 
 		if (resp_info & RSP_LEN_VALID)
 		  rsplen = be32_to_cpu(fcprsp->rspRspLen);
-		memcpy(cmnd->sense_buffer, &fcprsp->rspInfo0 + rsplen, snslen);
+		scsi_eh_cpy_sense(cmnd, &fcprsp->rspInfo0 + rsplen, snslen);
 	}
-	lp = (uint32_t *)cmnd->sense_buffer;
+	lp = (uint32_t *)scsi_sense(cmnd);
 
 	if (!scsi_status && (resp_info & RESID_UNDER))
 		logit = LOG_FCP;
@@ -593,7 +592,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	}
 
 	if (cmd->result || lpfc_cmd->fcp_rsp->rspSnsLen) {
-		uint32_t *lp = (uint32_t *)cmd->sense_buffer;
+		const uint32_t *lp = (const uint32_t *)scsi_sense(cmd);
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 				 "0710 Iodone <%d/%d> cmd %p, error "
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 4d59ae8..564bc4d 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1572,8 +1572,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 			if( mbox->m_out.cmd == MEGA_MBOXCMD_PASSTHRU ||
 				mbox->m_out.cmd == MEGA_MBOXCMD_PASSTHRU64 ) {
 
-				memcpy(cmd->sense_buffer, pthru->reqsensearea,
-						14);
+				scsi_eh_cpy_sense(cmd, pthru->reqsensearea, 14);
 
 				cmd->result = (DRIVER_SENSE << 24) |
 					(DID_OK << 16) |
@@ -1582,15 +1581,20 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 			else {
 				if (mbox->m_out.cmd == MEGA_MBOXCMD_EXTPTHRU) {
 
-					memcpy(cmd->sense_buffer,
+					scsi_eh_cpy_sense(cmd,
 						epthru->reqsensearea, 14);
 
 					cmd->result = (DRIVER_SENSE << 24) |
 						(DID_OK << 16) |
 						(CHECK_CONDITION << 1);
 				} else {
-					cmd->sense_buffer[0] = 0x70;
-					cmd->sense_buffer[2] = ABORTED_COMMAND;
+					u8 sense[4];
+
+					memset(sense, 0, sizeof(sense));
+					sense[0] = 0x70;
+					sense[2] = ABORTED_COMMAND;
+					scsi_eh_cpy_sense(cmd, sense,
+							  sizeof(sense));
 					cmd->result |= (CHECK_CONDITION << 1);
 				}
 			}
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 672c759..2caedef 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -45,6 +45,8 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
+
 #include "megaraid_sas.h"
 
 /*
@@ -1309,9 +1311,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			cmd->scmd->result = (DID_OK << 16) | hdr->scsi_status;
 
 			if (hdr->scsi_status == SAM_STAT_CHECK_CONDITION) {
-				memset(cmd->scmd->sense_buffer, 0,
-				       SCSI_SENSE_BUFFERSIZE);
-				memcpy(cmd->scmd->sense_buffer, cmd->sense,
+				scsi_eh_cpy_sense(cmd->scmd, cmd->sense,
 				       hdr->sense_len);
 
 				cmd->scmd->result |= DRIVER_SENSE << 24;
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index c5ebf01..89a38c2 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -123,6 +123,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_spi.h>
+#include <scsi/scsi_eh.h>
 
 #include "ncr53c8xx.h"
 
@@ -4962,12 +4963,10 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 		/*
 		**	Copy back sense data to caller's buffer.
 		*/
-		memcpy(cmd->sense_buffer, cp->sense_buf,
-		       min_t(size_t, SCSI_SENSE_BUFFERSIZE,
-			     sizeof(cp->sense_buf)));
+		scsi_eh_cpy_sense(cmd, cp->sense_buf, sizeof(cp->sense_buf));
 
 		if (DEBUG_FLAGS & (DEBUG_RESULT|DEBUG_TINY)) {
-			u_char *p = cmd->sense_buffer;
+			u_char *p = cp->sense_buf;
 			int i;
 			PRINT_ADDR(cmd, "sense data:");
 			for (i=0; i<14; i++) printk (" %x", *p++);
@@ -5040,7 +5039,7 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 				break;
 			case S_CHECK_COND:
 				printk ("  SENSE:");
-				p = (u_char*) &cmd->sense_buffer;
+				p = (u_char *)scsi_sense(cmd);
 				for (i=0; i<14; i++)
 					printk (" %x", *p++);
 				break;
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 65455ab..ed94c89 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1141,8 +1141,8 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
 			qpti->send_marker = 1;
 
 		if (sts->state_flags & SF_GOT_SENSE)
-			memcpy(Cmnd->sense_buffer, sts->req_sense_data,
-			       SCSI_SENSE_BUFFERSIZE);
+			scsi_eh_cpy_sense(Cmnd, sts->req_sense_data,
+			       sizeof(sts->req_sense_data));
 
 		if (sts->hdr.entry_type == ENTRY_STATUS)
 			Cmnd->result =
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1541c17..017989d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2379,9 +2379,8 @@ static int schedule_resp(struct scsi_cmnd * cmnd,
 	if (cmnd && devip) {
 		/* simulate autosense by this driver */
 		if (SAM_STAT_CHECK_CONDITION == (scsi_result & 0xff))
-			memcpy(cmnd->sense_buffer, devip->sense_buff,
-			       (SCSI_SENSE_BUFFERSIZE > SDEBUG_SENSE_LEN) ?
-			       SDEBUG_SENSE_LEN : SCSI_SENSE_BUFFERSIZE);
+			scsi_eh_cpy_sense(cmnd, devip->sense_buff,
+					  SDEBUG_SENSE_LEN);
 	}
 	if (delta_jiff <= 0) {
 		if (cmnd)
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d39107b..e8de740 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport.h>
+#include <scsi/scsi_eh.h>
 
 #include "sym_glue.h"
 #include "sym_nvram.h"
@@ -207,9 +208,7 @@ void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
 			/*
 			 *  Bounce back the sense data to user.
 			 */
-			memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-			memcpy(cmd->sense_buffer, cp->sns_bbuf,
-			       min(SCSI_SENSE_BUFFERSIZE, SYM_SNS_BBUF_LEN));
+			scsi_eh_cpy_sense(cmd, cp->sns_bbuf, SYM_SNS_BBUF_LEN);
 #if 0
 			/*
 			 *  If the device reports a UNIT ATTENTION condition 
-- 
1.5.3.3

