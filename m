From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI fixes for 2.6.29-rc5
Date: Fri, 20 Feb 2009 17:02:07 -0600
Message-ID: <1235170927.9025.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43529 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbZBTXCO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 18:02:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a bunch of assorted bug fixes (with several in the qlogic
drivers).

The patch is available at

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Andrew Vasquez (3):
      qla2xxx: Update version number to 8.03.00-k3.
      qla2xxx: Mask out 'reserved' bits while processing FLT regions.
      qla2xxx: Properly acknowledge IDC notification messages.

Anirban Chakraborty (2):
      qla2xxx: Correct slab-error overwrite during vport creation and deletion.
      qla2xxx: Remove interrupt request bit check in the response processing pat

Brian King (3):
      ibmvfc: Increase cancel timeout
      ibmvfc: Fix rport relogin
      ibmvfc: Fix command timeout errors

James Smart (1):
      scsi_scan: add missing interim SDEV_DEL state if slave_alloc fails

Julia Lawall (1):
      lpfc: introduce missing kfree

Martin Peschke (1):
      sg: fix device number in blktrace data

Mike Christie (1):
      libiscsi: Fix scsi command timeout oops in iscsi_eh_timed_out

Robert Jennings (1):
      ibmvscsi: Correct DMA mapping leak

Shyam_Iyer@Dell.com (1):
      qla2xxx: fix Kernel Panic with Qlogic 2472 Card.


And the diffstat

 drivers/scsi/ibmvscsi/ibmvfc.c     |   15 +++++++--
 drivers/scsi/ibmvscsi/ibmvfc.h     |    2 -
 drivers/scsi/ibmvscsi/ibmvscsi.c   |    1 
 drivers/scsi/libiscsi.c            |    3 +
 drivers/scsi/lpfc/lpfc_els.c       |    1 
 drivers/scsi/qla2xxx/qla_attr.c    |   13 +++-----
 drivers/scsi/qla2xxx/qla_def.h     |    5 +++
 drivers/scsi/qla2xxx/qla_devtbl.h  |    2 -
 drivers/scsi/qla2xxx/qla_fw.h      |    2 +
 drivers/scsi/qla2xxx/qla_gbl.h     |    9 +++--
 drivers/scsi/qla2xxx/qla_init.c    |    7 +---
 drivers/scsi/qla2xxx/qla_isr.c     |   58 ++++++++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_mbx.c     |   40 ++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_mid.c     |   12 +++----
 drivers/scsi/qla2xxx/qla_os.c      |   16 ++++++++++
 drivers/scsi/qla2xxx/qla_sup.c     |    2 -
 drivers/scsi/qla2xxx/qla_version.h |    2 -
 drivers/scsi/scsi_scan.c           |    1 
 drivers/scsi/sg.c                  |    2 -
 19 files changed, 131 insertions(+), 62 deletions(-)

The full diff is below.

James

---

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a1a511b..ed1e728 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1573,9 +1573,6 @@ static int ibmvfc_queuecommand(struct scsi_cmnd *cmnd,
 	vfc_cmd->resp_len = sizeof(vfc_cmd->rsp);
 	vfc_cmd->cancel_key = (unsigned long)cmnd->device->hostdata;
 	vfc_cmd->tgt_scsi_id = rport->port_id;
-	if ((rport->supported_classes & FC_COS_CLASS3) &&
-	    (fc_host_supported_classes(vhost->host) & FC_COS_CLASS3))
-		vfc_cmd->flags = IBMVFC_CLASS_3_ERR;
 	vfc_cmd->iu.xfer_len = scsi_bufflen(cmnd);
 	int_to_scsilun(cmnd->device->lun, &vfc_cmd->iu.lun);
 	memcpy(vfc_cmd->iu.cdb, cmnd->cmnd, cmnd->cmd_len);
@@ -3266,6 +3263,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost, u64 scsi_id)
 		return -ENOMEM;
 	}
 
+	memset(tgt, 0, sizeof(*tgt));
 	tgt->scsi_id = scsi_id;
 	tgt->new_scsi_id = scsi_id;
 	tgt->vhost = vhost;
@@ -3576,9 +3574,18 @@ static void ibmvfc_log_ae(struct ibmvfc_host *vhost, int events)
 static void ibmvfc_tgt_add_rport(struct ibmvfc_target *tgt)
 {
 	struct ibmvfc_host *vhost = tgt->vhost;
-	struct fc_rport *rport;
+	struct fc_rport *rport = tgt->rport;
 	unsigned long flags;
 
+	if (rport) {
+		tgt_dbg(tgt, "Setting rport roles\n");
+		fc_remote_port_rolechg(rport, tgt->ids.roles);
+		spin_lock_irqsave(vhost->host->host_lock, flags);
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		return;
+	}
+
 	tgt_dbg(tgt, "Adding rport\n");
 	rport = fc_remote_port_add(vhost->host, 0, &tgt->ids);
 	spin_lock_irqsave(vhost->host->host_lock, flags);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 87dafd0..b21e071 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -32,7 +32,7 @@
 #define IBMVFC_DRIVER_VERSION		"1.0.4"
 #define IBMVFC_DRIVER_DATE		"(November 14, 2008)"
 
-#define IBMVFC_DEFAULT_TIMEOUT	15
+#define IBMVFC_DEFAULT_TIMEOUT	60
 #define IBMVFC_INIT_TIMEOUT		120
 #define IBMVFC_MAX_REQUESTS_DEFAULT	100
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 74d07d1..c9aa761 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -432,6 +432,7 @@ static int map_sg_data(struct scsi_cmnd *cmd,
 				sdev_printk(KERN_ERR, cmd->device,
 				            "Can't allocate memory "
 				            "for indirect table\n");
+			scsi_dma_unmap(cmd);
 			return 0;
 		}
 	}
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 257c241..809d32d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1998,6 +1998,8 @@ int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev)
 	if (!shost->can_queue)
 		shost->can_queue = ISCSI_DEF_XMIT_CMDS_MAX;
 
+	if (!shost->transportt->eh_timed_out)
+		shost->transportt->eh_timed_out = iscsi_eh_cmd_timed_out;
 	return scsi_add_host(shost, pdev);
 }
 EXPORT_SYMBOL_GPL(iscsi_host_add);
@@ -2020,7 +2022,6 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 	shost = scsi_host_alloc(sht, sizeof(struct iscsi_host) + dd_data_size);
 	if (!shost)
 		return NULL;
-	shost->transportt->eh_timed_out = iscsi_eh_cmd_timed_out;
 
 	if (qdepth > ISCSI_MAX_CMD_PER_LUN || qdepth < 1) {
 		if (qdepth != 0)
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a8f30bd..a730248 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5258,6 +5258,7 @@ lpfc_send_els_event(struct lpfc_vport *vport,
 			sizeof(struct lpfc_name));
 		break;
 	default:
+		kfree(els_data);
 		return;
 	}
 	memcpy(els_data->wwpn, &ndlp->nlp_portname, sizeof(struct lpfc_name));
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 33a3c13..f4c5722 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1265,13 +1265,6 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags))
 		msleep(1000);
 
-	if (ha->mqenable) {
-		if (qla25xx_delete_queues(vha, 0) != QLA_SUCCESS)
-			qla_printk(KERN_WARNING, ha,
-				"Queue delete failed.\n");
-		vha->req_ques[0] = ha->req_q_map[0]->id;
-	}
-
 	qla24xx_disable_vp(vha);
 
 	fc_remove_host(vha->host);
@@ -1293,6 +1286,12 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 		    vha->host_no, vha->vp_idx, vha));
         }
 
+	if (ha->mqenable) {
+		if (qla25xx_delete_queues(vha, 0) != QLA_SUCCESS)
+			qla_printk(KERN_WARNING, ha,
+				"Queue delete failed.\n");
+	}
+
 	scsi_host_put(vha->host);
 	qla_printk(KERN_INFO, ha, "vport %d deleted\n", id);
 	return 0;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 023ee77..e0c5bb5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2135,6 +2135,7 @@ struct qla_msix_entry {
 /* Work events.  */
 enum qla_work_type {
 	QLA_EVT_AEN,
+	QLA_EVT_IDC_ACK,
 };
 
 
@@ -2149,6 +2150,10 @@ struct qla_work_evt {
 			enum fc_host_event_code code;
 			u32 data;
 		} aen;
+		struct {
+#define QLA_IDC_ACK_REGS	7
+			uint16_t mb[QLA_IDC_ACK_REGS];
+		} idc_ack;
 	} u;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_devtbl.h b/drivers/scsi/qla2xxx/qla_devtbl.h
index d78d35e..d6ea69d 100644
--- a/drivers/scsi/qla2xxx/qla_devtbl.h
+++ b/drivers/scsi/qla2xxx/qla_devtbl.h
@@ -72,7 +72,7 @@ static char *qla2x00_model_name[QLA_MODEL_NAMES*2] = {
 	"QLA2462",	"Sun PCI-X 2.0 to 4Gb FC, Dual Channel",	/* 0x141 */
 	"QLE2460",	"Sun PCI-Express to 2Gb FC, Single Channel",	/* 0x142 */
 	"QLE2462",	"Sun PCI-Express to 4Gb FC, Single Channel",	/* 0x143 */
-	"QEM2462"	"Server I/O Module 4Gb FC, Dual Channel",	/* 0x144 */
+	"QEM2462",	"Server I/O Module 4Gb FC, Dual Channel",	/* 0x144 */
 	"QLE2440",	"PCI-Express to 4Gb FC, Single Channel",	/* 0x145 */
 	"QLE2464",	"PCI-Express to 4Gb FC, Quad Channel",		/* 0x146 */
 	"QLA2440",	"PCI-X 2.0 to 4Gb FC, Single Channel",		/* 0x147 */
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 7abb045..ffff425 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1402,6 +1402,8 @@ struct access_chip_rsp_84xx {
 #define MBA_IDC_NOTIFY		0x8101
 #define MBA_IDC_TIME_EXT	0x8102
 
+#define MBC_IDC_ACK		0x101
+
 struct nvram_81xx {
 	/* NVRAM header. */
 	uint8_t id[4];
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index a336b4b..6de283f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -72,6 +72,7 @@ extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
 extern int qla2x00_post_aen_work(struct scsi_qla_host *, enum
     fc_host_event_code, u32);
+extern int qla2x00_post_idc_ack_work(struct scsi_qla_host *, uint16_t *);
 
 extern void qla2x00_abort_fcport_cmds(fc_port_t *);
 extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
@@ -266,6 +267,8 @@ qla2x00_set_idma_speed(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t *);
 
 extern int qla84xx_verify_chip(struct scsi_qla_host *, uint16_t *);
 
+extern int qla81xx_idc_ack(scsi_qla_host_t *, uint16_t *);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
@@ -376,10 +379,8 @@ extern int qla2x00_dfs_remove(scsi_qla_host_t *);
 
 /* Globa function prototypes for multi-q */
 extern int qla25xx_request_irq(struct rsp_que *);
-extern int qla25xx_init_req_que(struct scsi_qla_host *, struct req_que *,
-	uint8_t);
-extern int qla25xx_init_rsp_que(struct scsi_qla_host *, struct rsp_que *,
-	uint8_t);
+extern int qla25xx_init_req_que(struct scsi_qla_host *, struct req_que *);
+extern int qla25xx_init_rsp_que(struct scsi_qla_host *, struct rsp_que *);
 extern int qla25xx_create_req_que(struct qla_hw_data *, uint16_t, uint8_t,
 	uint16_t, uint8_t, uint8_t);
 extern int qla25xx_create_rsp_que(struct qla_hw_data *, uint16_t, uint8_t,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f6368a1..9865017 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1226,9 +1226,8 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 			icb->firmware_options_2 |=
 				__constant_cpu_to_le32(BIT_18);
 
-		icb->firmware_options_2 |= __constant_cpu_to_le32(BIT_22);
+		icb->firmware_options_2 &= __constant_cpu_to_le32(~BIT_22);
 		icb->firmware_options_2 |= __constant_cpu_to_le32(BIT_23);
-		ha->rsp_q_map[0]->options = icb->firmware_options_2;
 
 		WRT_REG_DWORD(&reg->isp25mq.req_q_in, 0);
 		WRT_REG_DWORD(&reg->isp25mq.req_q_out, 0);
@@ -3493,7 +3492,7 @@ qla25xx_init_queues(struct qla_hw_data *ha)
 		rsp = ha->rsp_q_map[i];
 		if (rsp) {
 			rsp->options &= ~BIT_0;
-			ret = qla25xx_init_rsp_que(base_vha, rsp, rsp->options);
+			ret = qla25xx_init_rsp_que(base_vha, rsp);
 			if (ret != QLA_SUCCESS)
 				DEBUG2_17(printk(KERN_WARNING
 					"%s Rsp que:%d init failed\n", __func__,
@@ -3507,7 +3506,7 @@ qla25xx_init_queues(struct qla_hw_data *ha)
 		if (req) {
 		/* Clear outstanding commands array. */
 			req->options &= ~BIT_0;
-			ret = qla25xx_init_req_que(base_vha, req, req->options);
+			ret = qla25xx_init_req_que(base_vha, req);
 			if (ret != QLA_SUCCESS)
 				DEBUG2_17(printk(KERN_WARNING
 					"%s Req que:%d init failed\n", __func__,
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e28ad81..f250e5b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -266,6 +266,40 @@ qla2x00_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	}
 }
 
+static void
+qla81xx_idc_event(scsi_qla_host_t *vha, uint16_t aen, uint16_t descr)
+{
+	static char *event[] =
+		{ "Complete", "Request Notification", "Time Extension" };
+	int rval;
+	struct device_reg_24xx __iomem *reg24 = &vha->hw->iobase->isp24;
+	uint16_t __iomem *wptr;
+	uint16_t cnt, timeout, mb[QLA_IDC_ACK_REGS];
+
+	/* Seed data -- mailbox1 -> mailbox7. */
+	wptr = (uint16_t __iomem *)&reg24->mailbox1;
+	for (cnt = 0; cnt < QLA_IDC_ACK_REGS; cnt++, wptr++)
+		mb[cnt] = RD_REG_WORD(wptr);
+
+	DEBUG2(printk("scsi(%ld): Inter-Driver Commucation %s -- "
+	    "%04x %04x %04x %04x %04x %04x %04x.\n", vha->host_no,
+	    event[aen & 0xff],
+	    mb[0], mb[1], mb[2], mb[3], mb[4], mb[5], mb[6]));
+
+	/* Acknowledgement needed? [Notify && non-zero timeout]. */
+	timeout = (descr >> 8) & 0xf;
+	if (aen != MBA_IDC_NOTIFY || !timeout)
+		return;
+
+	DEBUG2(printk("scsi(%ld): Inter-Driver Commucation %s -- "
+	    "ACK timeout=%d.\n", vha->host_no, event[aen & 0xff], timeout));
+
+	rval = qla2x00_post_idc_ack_work(vha, mb);
+	if (rval != QLA_SUCCESS)
+		qla_printk(KERN_WARNING, vha->hw,
+		    "IDC failed to post ACK.\n");
+}
+
 /**
  * qla2x00_async_event() - Process aynchronous events.
  * @ha: SCSI driver HA context
@@ -714,21 +748,9 @@ skip_rio:
 		    "%04x %04x %04x\n", vha->host_no, mb[1], mb[2], mb[3]));
 		break;
 	case MBA_IDC_COMPLETE:
-		DEBUG2(printk("scsi(%ld): Inter-Driver Commucation "
-		    "Complete -- %04x %04x %04x\n", vha->host_no, mb[1], mb[2],
-		    mb[3]));
-		break;
 	case MBA_IDC_NOTIFY:
-		DEBUG2(printk("scsi(%ld): Inter-Driver Commucation "
-		    "Request Notification -- %04x %04x %04x\n", vha->host_no,
-		    mb[1], mb[2], mb[3]));
-		/**** Mailbox registers 4 - 7 valid!!! */
-		break;
 	case MBA_IDC_TIME_EXT:
-		DEBUG2(printk("scsi(%ld): Inter-Driver Commucation "
-		    "Time Extension -- %04x %04x %04x\n", vha->host_no, mb[1],
-		    mb[2], mb[3]));
-		/**** Mailbox registers 4 - 7 valid!!! */
+		qla81xx_idc_event(vha, mb[0], mb[1]);
 		break;
 	}
 
@@ -1707,7 +1729,6 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
-	uint16_t msix_disabled_hccr = 0;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1720,17 +1741,8 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 
 	spin_lock_irq(&ha->hardware_lock);
 
-	msix_disabled_hccr = rsp->options;
-	if (!rsp->id)
-		msix_disabled_hccr &= __constant_cpu_to_le32(BIT_22);
-	else
-		msix_disabled_hccr &= __constant_cpu_to_le32(BIT_6);
-
 	qla24xx_process_response_queue(rsp);
 
-	if (!msix_disabled_hccr)
-		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-
 	spin_unlock_irq(&ha->hardware_lock);
 
 	return IRQ_HANDLED;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f94ffbb..4c7504c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3090,8 +3090,7 @@ verify_done:
 }
 
 int
-qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req,
-	uint8_t options)
+qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 {
 	int rval;
 	unsigned long flags;
@@ -3101,7 +3100,7 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req,
 	struct qla_hw_data *ha = vha->hw;
 
 	mcp->mb[0] = MBC_INITIALIZE_MULTIQ;
-	mcp->mb[1] = options;
+	mcp->mb[1] = req->options;
 	mcp->mb[2] = MSW(LSD(req->dma));
 	mcp->mb[3] = LSW(LSD(req->dma));
 	mcp->mb[6] = MSW(MSD(req->dma));
@@ -3128,7 +3127,7 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req,
 	mcp->tov = 60;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	if (!(options & BIT_0)) {
+	if (!(req->options & BIT_0)) {
 		WRT_REG_DWORD(&reg->req_q_in, 0);
 		WRT_REG_DWORD(&reg->req_q_out, 0);
 	}
@@ -3142,8 +3141,7 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req,
 }
 
 int
-qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp,
-	uint8_t options)
+qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
 	int rval;
 	unsigned long flags;
@@ -3153,7 +3151,7 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp,
 	struct qla_hw_data *ha = vha->hw;
 
 	mcp->mb[0] = MBC_INITIALIZE_MULTIQ;
-	mcp->mb[1] = options;
+	mcp->mb[1] = rsp->options;
 	mcp->mb[2] = MSW(LSD(rsp->dma));
 	mcp->mb[3] = LSW(LSD(rsp->dma));
 	mcp->mb[6] = MSW(MSD(rsp->dma));
@@ -3178,7 +3176,7 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp,
 	mcp->tov = 60;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	if (!(options & BIT_0)) {
+	if (!(rsp->options & BIT_0)) {
 		WRT_REG_DWORD(&reg->rsp_q_out, 0);
 		WRT_REG_DWORD(&reg->rsp_q_in, 0);
 	}
@@ -3193,3 +3191,29 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp,
 	return rval;
 }
 
+int
+qla81xx_idc_ack(scsi_qla_host_t *vha, uint16_t *mb)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+
+	mcp->mb[0] = MBC_IDC_ACK;
+	memcpy(&mcp->mb[1], mb, QLA_IDC_ACK_REGS * sizeof(uint16_t));
+	mcp->out_mb = MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
+		    vha->host_no, rval, mcp->mb[0]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index f53179c..3f23932 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -396,7 +396,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	qla2x00_start_timer(vha, qla2x00_timer, WATCH_INTERVAL);
 
-	memset(vha->req_ques, 0, sizeof(vha->req_ques) * QLA_MAX_HOST_QUES);
+	memset(vha->req_ques, 0, sizeof(vha->req_ques));
 	vha->req_ques[0] = ha->req_q_map[0]->id;
 	host->can_queue = ha->req_q_map[0]->length + 128;
 	host->this_id = 255;
@@ -471,7 +471,7 @@ qla25xx_delete_req_que(struct scsi_qla_host *vha, struct req_que *req)
 
 	if (req) {
 		req->options |= BIT_0;
-		ret = qla25xx_init_req_que(vha, req, req->options);
+		ret = qla25xx_init_req_que(vha, req);
 	}
 	if (ret == QLA_SUCCESS)
 		qla25xx_free_req_que(vha, req);
@@ -486,7 +486,7 @@ qla25xx_delete_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 
 	if (rsp) {
 		rsp->options |= BIT_0;
-		ret = qla25xx_init_rsp_que(vha, rsp, rsp->options);
+		ret = qla25xx_init_rsp_que(vha, rsp);
 	}
 	if (ret == QLA_SUCCESS)
 		qla25xx_free_rsp_que(vha, rsp);
@@ -502,7 +502,7 @@ int qla25xx_update_req_que(struct scsi_qla_host *vha, uint8_t que, uint8_t qos)
 
 	req->options |= BIT_3;
 	req->qos = qos;
-	ret = qla25xx_init_req_que(vha, req, req->options);
+	ret = qla25xx_init_req_que(vha, req);
 	if (ret != QLA_SUCCESS)
 		DEBUG2_17(printk(KERN_WARNING "%s failed\n", __func__));
 	/* restore options bit */
@@ -632,7 +632,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	req->max_q_depth = ha->req_q_map[0]->max_q_depth;
 	mutex_unlock(&ha->vport_lock);
 
-	ret = qla25xx_init_req_que(base_vha, req, options);
+	ret = qla25xx_init_req_que(base_vha, req);
 	if (ret != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha, "%s failed\n", __func__);
 		mutex_lock(&ha->vport_lock);
@@ -710,7 +710,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	if (ret)
 		goto que_failed;
 
-	ret = qla25xx_init_rsp_que(base_vha, rsp, options);
+	ret = qla25xx_init_rsp_que(base_vha, rsp);
 	if (ret != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha, "%s failed\n", __func__);
 		mutex_lock(&ha->vport_lock);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c11f872..2f5f725 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2522,6 +2522,19 @@ qla2x00_post_aen_work(struct scsi_qla_host *vha, enum fc_host_event_code code,
 	return qla2x00_post_work(vha, e, 1);
 }
 
+int
+qla2x00_post_idc_ack_work(struct scsi_qla_host *vha, uint16_t *mb)
+{
+	struct qla_work_evt *e;
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_IDC_ACK, 1);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	memcpy(e->u.idc_ack.mb, mb, QLA_IDC_ACK_REGS * sizeof(uint16_t));
+	return qla2x00_post_work(vha, e, 1);
+}
+
 static void
 qla2x00_do_work(struct scsi_qla_host *vha)
 {
@@ -2539,6 +2552,9 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 			fc_host_post_event(vha->host, fc_get_event_number(),
 			    e->u.aen.code, e->u.aen.data);
 			break;
+		case QLA_EVT_IDC_ACK:
+			qla81xx_idc_ack(vha, e->u.idc_ack.mb);
+			break;
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 9c3b694..2848279 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -684,7 +684,7 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 		    "end=0x%x size=0x%x.\n", le32_to_cpu(region->code), start,
 		    le32_to_cpu(region->end) >> 2, le32_to_cpu(region->size)));
 
-		switch (le32_to_cpu(region->code)) {
+		switch (le32_to_cpu(region->code) & 0xff) {
 		case FLT_REG_FW:
 			ha->flt_region_fw = start;
 			break;
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index cfa4c11..79f7053 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.00-k2"
+#define QLA2XXX_VERSION      "8.03.00-k3"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 66505bb..8f4de20 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -317,6 +317,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	return sdev;
 
 out_device_destroy:
+	scsi_device_set_state(sdev, SDEV_DEL);
 	transport_destroy_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
 out:
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 8f0bd3f..516925d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1078,7 +1078,7 @@ sg_ioctl(struct inode *inode, struct file *filp,
 	case BLKTRACESETUP:
 		return blk_trace_setup(sdp->device->request_queue,
 				       sdp->disk->disk_name,
-				       sdp->device->sdev_gendev.devt,
+				       MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
 				       (char *)arg);
 	case BLKTRACESTART:
 		return blk_trace_startstop(sdp->device->request_queue, 1);


