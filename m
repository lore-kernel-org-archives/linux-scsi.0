From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 09/15] qla4xxx: dump mailbox registers on System Error
Date: Wed, 6 Oct 2010 22:50:21 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8712940678C@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:37578 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab0JGFuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:50:24 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Karen Higgins <karen.higgins@qlogic.com>

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_dbg.c  |  101 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_glbl.h |    1 +
 drivers/scsi/qla4xxx/ql4_isr.c  |    2 +
 3 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_dbg.c b/drivers/scsi/qla4xxx/ql4_dbg.c
index cbceb0e..edcf048 100644
--- a/drivers/scsi/qla4xxx/ql4_dbg.c
+++ b/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -30,3 +30,104 @@ void qla4xxx_dump_buffer(void *b, uint32_t size)
 	printk(KERN_INFO "\n");
 }
 
+void qla4xxx_dump_registers(struct scsi_qla_host *ha)
+{
+	uint8_t i;
+
+	if (is_qla8022(ha)) {
+		for (i = 1; i < MBOX_REG_COUNT; i++)
+			printk(KERN_INFO "mailbox[%d]     = 0x%08X\n",
+			    i, readl(&ha->qla4_8xxx_reg->mailbox_in[i]));
+		return;
+	}
+
+	for (i = 0; i < MBOX_REG_COUNT; i++) {
+		printk(KERN_INFO "0x%02X mailbox[%d]      = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, mailbox[i]), i,
+		    readw(&ha->reg->mailbox[i]));
+	}
+
+	printk(KERN_INFO "0x%02X flash_address            = 0x%08X\n",
+	    (uint8_t) offsetof(struct isp_reg, flash_address),
+	    readw(&ha->reg->flash_address));
+	printk(KERN_INFO "0x%02X flash_data               = 0x%08X\n",
+	    (uint8_t) offsetof(struct isp_reg, flash_data),
+	    readw(&ha->reg->flash_data));
+	printk(KERN_INFO "0x%02X ctrl_status              = 0x%08X\n",
+	    (uint8_t) offsetof(struct isp_reg, ctrl_status),
+	    readw(&ha->reg->ctrl_status));
+
+	if (is_qla4010(ha)) {
+		printk(KERN_INFO "0x%02X nvram            = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u1.isp4010.nvram),
+		    readw(&ha->reg->u1.isp4010.nvram));
+	} else if (is_qla4022(ha) | is_qla4032(ha)) {
+		printk(KERN_INFO "0x%02X intr_mask        = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u1.isp4022.intr_mask),
+		    readw(&ha->reg->u1.isp4022.intr_mask));
+		printk(KERN_INFO "0x%02X nvram            = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u1.isp4022.nvram),
+		    readw(&ha->reg->u1.isp4022.nvram));
+		printk(KERN_INFO "0x%02X semaphore	  = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u1.isp4022.semaphore),
+		    readw(&ha->reg->u1.isp4022.semaphore));
+	}
+	printk(KERN_INFO "0x%02X req_q_in                 = 0x%08X\n",
+	    (uint8_t) offsetof(struct isp_reg, req_q_in),
+	    readw(&ha->reg->req_q_in));
+	printk(KERN_INFO "0x%02X rsp_q_out                = 0x%08X\n",
+	    (uint8_t) offsetof(struct isp_reg, rsp_q_out),
+	    readw(&ha->reg->rsp_q_out));
+
+	if (is_qla4010(ha)) {
+		printk(KERN_INFO "0x%02X ext_hw_conf      = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u2.isp4010.ext_hw_conf),
+		    readw(&ha->reg->u2.isp4010.ext_hw_conf));
+		printk(KERN_INFO "0x%02X port_ctrl        = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u2.isp4010.port_ctrl),
+		    readw(&ha->reg->u2.isp4010.port_ctrl));
+		printk(KERN_INFO "0x%02X port_status      = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u2.isp4010.port_status),
+		    readw(&ha->reg->u2.isp4010.port_status));
+		printk(KERN_INFO "0x%02X req_q_out        = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u2.isp4010.req_q_out),
+		    readw(&ha->reg->u2.isp4010.req_q_out));
+		printk(KERN_INFO "0x%02X gp_out           = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u2.isp4010.gp_out),
+		    readw(&ha->reg->u2.isp4010.gp_out));
+		printk(KERN_INFO "0x%02X gp_in	          = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u2.isp4010.gp_in),
+		    readw(&ha->reg->u2.isp4010.gp_in));
+		printk(KERN_INFO "0x%02X port_err_status  = 0x%08X\n", (uint8_t)
+		    offsetof(struct isp_reg, u2.isp4010.port_err_status),
+		    readw(&ha->reg->u2.isp4010.port_err_status));
+	} else if (is_qla4022(ha) | is_qla4032(ha)) {
+		printk(KERN_INFO "Page 0 Registers:\n");
+		printk(KERN_INFO "0x%02X ext_hw_conf      = 0x%08X\n", (uint8_t)
+		    offsetof(struct isp_reg, u2.isp4022.p0.ext_hw_conf),
+		    readw(&ha->reg->u2.isp4022.p0.ext_hw_conf));
+		printk(KERN_INFO "0x%02X port_ctrl        = 0x%08X\n", (uint8_t)
+		    offsetof(struct isp_reg, u2.isp4022.p0.port_ctrl),
+		    readw(&ha->reg->u2.isp4022.p0.port_ctrl));
+		printk(KERN_INFO "0x%02X port_status      = 0x%08X\n", (uint8_t)
+		    offsetof(struct isp_reg, u2.isp4022.p0.port_status),
+		    readw(&ha->reg->u2.isp4022.p0.port_status));
+		printk(KERN_INFO "0x%02X gp_out           = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u2.isp4022.p0.gp_out),
+		    readw(&ha->reg->u2.isp4022.p0.gp_out));
+		printk(KERN_INFO "0x%02X gp_in            = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u2.isp4022.p0.gp_in),
+		    readw(&ha->reg->u2.isp4022.p0.gp_in));
+		printk(KERN_INFO "0x%02X port_err_status  = 0x%08X\n", (uint8_t)
+		    offsetof(struct isp_reg, u2.isp4022.p0.port_err_status),
+		    readw(&ha->reg->u2.isp4022.p0.port_err_status));
+		printk(KERN_INFO "Page 1 Registers:\n");
+		writel(HOST_MEM_CFG_PAGE & set_rmask(CSR_SCSI_PAGE_SELECT),
+		    &ha->reg->ctrl_status);
+		printk(KERN_INFO "0x%02X req_q_out        = 0x%08X\n",
+		    (uint8_t) offsetof(struct isp_reg, u2.isp4022.p1.req_q_out),
+		    readw(&ha->reg->u2.isp4022.p1.req_q_out));
+		writel(PORT_CTRL_STAT_PAGE & set_rmask(CSR_SCSI_PAGE_SELECT),
+		    &ha->reg->ctrl_status);
+	}
+}
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 95a26fb..6575a47 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -94,6 +94,7 @@ void qla4xxx_process_response_queue(struct scsi_qla_host *ha);
 void qla4xxx_wake_dpc(struct scsi_qla_host *ha);
 void qla4xxx_get_conn_event_log(struct scsi_qla_host *ha);
 void qla4xxx_mailbox_premature_completion(struct scsi_qla_host *ha);
+void qla4xxx_dump_registers(struct scsi_qla_host *ha);
 
 void qla4_8xxx_pci_config(struct scsi_qla_host *);
 int qla4_8xxx_iospace_config(struct scsi_qla_host *ha);
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index a5fa655..7c33fd5 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -487,6 +487,8 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 		case MBOX_ASTS_SYSTEM_ERROR:
 			/* Log Mailbox registers */
 			ql4_printk(KERN_INFO, ha, "%s: System Err\n", __func__);
+			qla4xxx_dump_registers(ha);
+
 			if (ql4xdontresethba) {
 				DEBUG2(printk("scsi%ld: %s:Don't Reset HBA\n",
 				    ha->host_no, __func__));
-- 
1.6.6

