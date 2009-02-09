From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/6] qla2xxx: Properly acknowledge IDC notification messages.
Date: Sun,  8 Feb 2009 20:50:12 -0800
Message-ID: <1234155016-6215-3-git-send-email-andrew.vasquez@qlogic.com>
References: <1234155016-6215-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:7132 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbZBIEuX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2009 23:50:23 -0500
In-Reply-To: <1234155016-6215-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

To ensure smooth operations amongst the FCoE and NIC side
components of the ISP81xx chip, the FCoE driver (qla2xxx) must
ensure the 10gb NIC driver (qlge) does not timeout waiting for
IDC (Inter-Driver Communication) acknowledgments.  The
acknowledgment requirements are trivial -- a simple mirroring of
incoming mailbox registers during the AEN to a process-context
capable mailbox command.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    5 ++++
 drivers/scsi/qla2xxx/qla_fw.h  |    2 +
 drivers/scsi/qla2xxx/qla_gbl.h |    3 ++
 drivers/scsi/qla2xxx/qla_isr.c |   48 +++++++++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_mbx.c |   26 +++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c  |   16 +++++++++++++
 6 files changed, 87 insertions(+), 13 deletions(-)

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
index bce5b04..6de283f 100644
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
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b5554ea..f250e5b 100644
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
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 723cd37..4c7504c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3191,3 +3191,29 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
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
-- 
1.6.1.48.ge9b8

