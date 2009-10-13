From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/9] qla2xxx: Display additional mailbox registers during AEN handling.
Date: Tue, 13 Oct 2009 15:16:46 -0700
Message-ID: <1255472213-472-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:49690 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755305AbZJMWYQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 18:24:16 -0400
In-Reply-To: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The mailbox register values may assist in debugging efforts.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b20a716..4d758d2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -313,10 +313,11 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 	static char	*link_speeds[] = { "1", "2", "?", "4", "8", "10" };
 	char		*link_speed;
 	uint16_t	handle_cnt;
-	uint16_t	cnt;
+	uint16_t	cnt, mbx;
 	uint32_t	handles[5];
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+	struct device_reg_24xx __iomem *reg24 = &ha->iobase->isp24;
 	uint32_t	rscn_entry, host_pid;
 	uint8_t		rscn_queue_index;
 	unsigned long	flags;
@@ -395,9 +396,10 @@ skip_rio:
 		break;
 
 	case MBA_SYSTEM_ERR:		/* System Error */
+		mbx = IS_QLA81XX(ha) ? RD_REG_WORD(&reg24->mailbox7) : 0;
 		qla_printk(KERN_INFO, ha,
-		    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n",
-		    mb[1], mb[2], mb[3]);
+		    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh "
+		    "mbx7=%xh.\n", mb[1], mb[2], mb[3], mbx);
 
 		ha->isp_ops->fw_dump(vha, 1);
 
@@ -419,9 +421,10 @@ skip_rio:
 		break;
 
 	case MBA_REQ_TRANSFER_ERR:	/* Request Transfer Error */
-		DEBUG2(printk("scsi(%ld): ISP Request Transfer Error.\n",
-		    vha->host_no));
-		qla_printk(KERN_WARNING, ha, "ISP Request Transfer Error.\n");
+		DEBUG2(printk("scsi(%ld): ISP Request Transfer Error (%x).\n",
+		    vha->host_no, mb[1]));
+		qla_printk(KERN_WARNING, ha,
+		    "ISP Request Transfer Error (%x).\n", mb[1]);
 
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		break;
@@ -485,10 +488,13 @@ skip_rio:
 		break;
 
 	case MBA_LOOP_DOWN:		/* Loop Down Event */
+		mbx = IS_QLA81XX(ha) ? RD_REG_WORD(&reg24->mailbox4) : 0;
 		DEBUG2(printk("scsi(%ld): Asynchronous LOOP DOWN "
-		    "(%x %x %x).\n", vha->host_no, mb[1], mb[2], mb[3]));
-		qla_printk(KERN_INFO, ha, "LOOP DOWN detected (%x %x %x).\n",
-		    mb[1], mb[2], mb[3]);
+		    "(%x %x %x %x).\n", vha->host_no, mb[1], mb[2], mb[3],
+		    mbx));
+		qla_printk(KERN_INFO, ha,
+		    "LOOP DOWN detected (%x %x %x %x).\n", mb[1], mb[2], mb[3],
+		    mbx);
 
 		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 			atomic_set(&vha->loop_state, LOOP_DOWN);
-- 
1.6.2.rc1.30.gd43c

