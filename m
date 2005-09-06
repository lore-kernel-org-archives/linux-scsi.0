From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/8]  qla4xxx: Support routines
Date: Tue,  6 Sep 2005 15:09:51 -0700 (PDT)
Message-ID: <20050906220951.11409.13010.sendpatchset@plap.qlogic.com>
References: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:47520 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751031AbVIFWJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 18:09:52 -0400
In-Reply-To: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ISP4xxx driver support routines.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla4xxx/ql4_dbg.c   |  268 ++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_dbg.h   |  119 +++++++++++++
 drivers/scsi/qla4xxx/ql4_nvram.c |  264 +++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_nvram.h |  341 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 992 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/qla4xxx/ql4_dbg.c
 create mode 100644 drivers/scsi/qla4xxx/ql4_dbg.h
 create mode 100644 drivers/scsi/qla4xxx/ql4_nvram.c
 create mode 100644 drivers/scsi/qla4xxx/ql4_nvram.h

d5ea85dc8fdf7b10bd1807f64f952c6a986b82e8
diff --git a/drivers/scsi/qla4xxx/ql4_dbg.c b/drivers/scsi/qla4xxx/ql4_dbg.c
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -0,0 +1,268 @@
+/*
+ * Copyright (c)  2003-2005 QLogic Corporation
+ * QLogic Linux iSCSI Driver
+ *
+ * This program includes a device driver for Linux 2.6 that may be
+ * distributed with QLogic hardware specific firmware binary file.
+ * You may modify and redistribute the device driver code under the
+ * GNU General Public License as published by the Free Software
+ * Foundation (version 2 or a later version) and/or under the
+ * following terms, as applicable:
+ *
+ * 	1. Redistribution of source code must retain the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission.
+ *
+ * You may redistribute the hardware specific firmware binary file
+ * under the following terms:
+ *
+ * 	1. Redistribution of source code (only if applicable),
+ * 	   must retain the above copyright notice, this list of
+ * 	   conditions and the following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission
+ *
+ * REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
+ * THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
+ * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+ * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
+ * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ *
+ * USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
+ * CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
+ * OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
+ * TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
+ * ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
+ * COMBINATION WITH THIS PROGRAM.
+ */
+
+#include "ql4_def.h"
+
+/*
+ * qla4xxx_print_srb_cmd
+ *	This routine displays the SRB command
+ */
+static void qla4xxx_print_srb_info(srb_t * srb)
+{
+	printk("%s: srb = 0x%p, flags=0x%02x\n", __func__, srb, srb->flags);
+	printk("%s: entry_count = 0x%02x, active_array_index=0x%04x\n",
+	       __func__, srb->iocb_cnt, srb->active_array_index);
+	printk("%s: cmd = 0x%p, saved_dma_handle = 0x%lx\n",
+	       __func__, srb->cmd, (unsigned long) srb->dma_handle);
+	printk("%s: fw_ddb_index = %d, lun = %d\n",
+	       __func__, srb->fw_ddb_index, srb->cmd->device->lun);
+	printk("%s: iocb_tov = %d\n",
+	       __func__, srb->iocb_tov);
+	printk("%s: cc_stat = 0x%x, r_start = 0x%lx, u_start = 0x%lx\n\n",
+	       __func__, srb->cc_stat, srb->r_start, srb->u_start);
+}
+
+/*
+ * qla4xxx_print_scsi_cmd
+ *	This routine displays the SCSI command
+ */
+void qla4xxx_print_scsi_cmd(struct scsi_cmnd *cmd)
+{
+	int i;
+	printk("SCSI Command = 0x%p, Handle=0x%p\n", cmd, cmd->host_scribble);
+	printk("  b=%d, t=%02xh, l=%02xh, cmd_len = %02xh\n",
+	       cmd->device->channel, cmd->device->id, cmd->device->lun,
+	       cmd->cmd_len);
+	printk("  CDB = ");
+	for (i = 0; i < cmd->cmd_len; i++)
+		printk("%02x ", cmd->cmnd[i]);
+	printk("  seg_cnt = %d\n", cmd->use_sg);
+	printk("  request buffer = 0x%p, request buffer len = 0x%x\n",
+	       cmd->request_buffer, cmd->request_bufflen);
+	if (cmd->use_sg) {
+		struct scatterlist *sg;
+		sg = (struct scatterlist *)cmd->request_buffer;
+		printk("  SG buffer: \n");
+		qla4xxx_dump_buffer((caddr_t) sg,
+				    (cmd->use_sg * sizeof(struct scatterlist)));
+	}
+	printk("  tag = %d, transfersize = 0x%x \n", cmd->tag,
+	       cmd->transfersize);
+	printk("  Pid = %d, SP = 0x%p\n", (int)cmd->pid, CMD_SP(cmd));
+	printk("  underflow size = 0x%x, direction=0x%x\n", cmd->underflow,
+	       cmd->sc_data_direction);
+	printk("  Current time (jiffies) = 0x%lx, "
+	       "timeout expires = 0x%lx\n", jiffies, cmd->eh_timeout.expires);
+	qla4xxx_print_srb_info((srb_t *) CMD_SP(cmd));
+}
+
+void __dump_registers(scsi_qla_host_t * ha)
+{
+	uint8_t i;
+	for (i = 0; i < MBOX_REG_COUNT; i++) {
+		printk(KERN_INFO "0x%02X mailbox[%d]      = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, mailbox[i]), i,
+		       RD_REG_DWORD(&ha->reg->mailbox[i]));
+	}
+	printk(KERN_INFO "0x%02X flash_address   = 0x%08X\n",
+	       (uint8_t) offsetof(isp_reg_t, flash_address),
+	       RD_REG_DWORD(&ha->reg->flash_address));
+	printk(KERN_INFO "0x%02X flash_data      = 0x%08X\n",
+	       (uint8_t) offsetof(isp_reg_t, flash_data),
+	       RD_REG_DWORD(&ha->reg->flash_data));
+	printk(KERN_INFO "0x%02X ctrl_status     = 0x%08X\n",
+	       (uint8_t) offsetof(isp_reg_t, ctrl_status),
+	       RD_REG_DWORD(&ha->reg->ctrl_status));
+	if (IS_QLA4010(ha)) {
+		printk(KERN_INFO "0x%02X nvram           = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, u1.isp4010.nvram),
+		       RD_REG_DWORD(&ha->reg->u1.isp4010.nvram));
+	}
+
+	else if (IS_QLA4022(ha)) {
+		printk(KERN_INFO "0x%02X intr_mask       = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, u1.isp4022.intr_mask),
+		       RD_REG_DWORD(&ha->reg->u1.isp4022.intr_mask));
+		printk(KERN_INFO "0x%02X nvram           = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, u1.isp4022.nvram),
+		       RD_REG_DWORD(&ha->reg->u1.isp4022.nvram));
+		printk(KERN_INFO "0x%02X semaphore       = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, u1.isp4022.semaphore),
+		       RD_REG_DWORD(&ha->reg->u1.isp4022.semaphore));
+	}
+	printk(KERN_INFO "0x%02X req_q_in        = 0x%08X\n",
+	       (uint8_t) offsetof(isp_reg_t, req_q_in),
+	       RD_REG_DWORD(&ha->reg->req_q_in));
+	printk(KERN_INFO "0x%02X rsp_q_out       = 0x%08X\n",
+	       (uint8_t) offsetof(isp_reg_t, rsp_q_out),
+	       RD_REG_DWORD(&ha->reg->rsp_q_out));
+	if (IS_QLA4010(ha)) {
+		printk(KERN_INFO "0x%02X ext_hw_conf     = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, u2.isp4010.ext_hw_conf),
+		       RD_REG_DWORD(&ha->reg->u2.isp4010.ext_hw_conf));
+		printk(KERN_INFO "0x%02X port_ctrl       = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, u2.isp4010.port_ctrl),
+		       RD_REG_DWORD(&ha->reg->u2.isp4010.port_ctrl));
+		printk(KERN_INFO "0x%02X port_status     = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, u2.isp4010.port_status),
+		       RD_REG_DWORD(&ha->reg->u2.isp4010.port_status));
+		printk(KERN_INFO "0x%02X req_q_out       = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, u2.isp4010.req_q_out),
+		       RD_REG_DWORD(&ha->reg->u2.isp4010.req_q_out));
+		printk(KERN_INFO "0x%02X gp_out          = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, u2.isp4010.gp_out),
+		       RD_REG_DWORD(&ha->reg->u2.isp4010.gp_out));
+		printk(KERN_INFO "0x%02X gp_in           = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, u2.isp4010.gp_in),
+		       RD_REG_DWORD(&ha->reg->u2.isp4010.gp_in));
+		printk(KERN_INFO "0x%02X port_err_status = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t,
+					  u2.isp4010.port_err_status),
+		       RD_REG_DWORD(&ha->reg->u2.isp4010.port_err_status));
+	}
+
+	else if (IS_QLA4022(ha)) {
+		printk(KERN_INFO "Page 0 Registers:\n");
+		printk(KERN_INFO "0x%02X ext_hw_conf     = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t,
+					  u2.isp4022.p0.ext_hw_conf),
+		       RD_REG_DWORD(&ha->reg->u2.isp4022.p0.ext_hw_conf));
+		printk(KERN_INFO "0x%02X port_ctrl       = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t,
+					  u2.isp4022.p0.port_ctrl),
+		       RD_REG_DWORD(&ha->reg->u2.isp4022.p0.port_ctrl));
+		printk(KERN_INFO "0x%02X port_status     = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t,
+					  u2.isp4022.p0.port_status),
+		       RD_REG_DWORD(&ha->reg->u2.isp4022.p0.port_status));
+		printk(KERN_INFO "0x%02X gp_out          = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, u2.isp4022.p0.gp_out),
+		       RD_REG_DWORD(&ha->reg->u2.isp4022.p0.gp_out));
+		printk(KERN_INFO "0x%02X gp_in           = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t, u2.isp4022.p0.gp_in),
+		       RD_REG_DWORD(&ha->reg->u2.isp4022.p0.gp_in));
+		printk(KERN_INFO "0x%02X port_err_status = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t,
+					  u2.isp4022.p0.port_err_status),
+		       RD_REG_DWORD(&ha->reg->u2.isp4022.p0.port_err_status));
+		printk(KERN_INFO "Page 1 Registers:\n");
+		WRT_REG_DWORD(&ha->reg->ctrl_status,
+			      HOST_MEM_CFG_PAGE &
+			      SET_RMASK(CSR_SCSI_PAGE_SELECT));
+		printk(KERN_INFO "0x%02X req_q_out       = 0x%08X\n",
+		       (uint8_t) offsetof(isp_reg_t,
+					  u2.isp4022.p1.req_q_out),
+		       RD_REG_DWORD(&ha->reg->u2.isp4022.p1.req_q_out));
+		WRT_REG_DWORD(&ha->reg->ctrl_status,
+			      PORT_CTRL_STAT_PAGE &
+			      SET_RMASK(CSR_SCSI_PAGE_SELECT));
+	}
+}
+
+/*
+ * qla4xxx_dump_registers
+ *	This routine displays ISP registers
+ *
+ * Input:
+ *	ha       - adapter structure pointer
+ *
+ */
+void qla4xxx_dump_mbox_registers(scsi_qla_host_t * ha)
+{
+	unsigned long flags = 0;
+	int i = 0;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (i = 1; i < MBOX_REG_COUNT; i++)
+		printk(KERN_INFO "  Mailbox[%d] = %08x\n", i,
+		       RD_REG_DWORD(&ha->reg->mailbox[i]));
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+void qla4xxx_dump_registers(scsi_qla_host_t * ha)
+{
+	unsigned long flags = 0;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	__dump_registers(ha);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+void qla4xxx_dump_buffer(uint8_t * b, uint32_t size)
+{
+	uint32_t cnt;
+	uint8_t c;
+	printk(" 0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  "
+	    "Fh\n");
+	printk("------------------------------------------------------------"
+	    "--\n");
+	for (cnt = 0; cnt < size;) {
+		c = *b++;
+		printk("%02x", (uint32_t) c);
+		cnt++;
+		if (!(cnt % 16))
+			printk("\n");
+
+		else
+			printk("  ");
+	}
+	if (cnt % 16)
+		printk("\n");
+}
diff --git a/drivers/scsi/qla4xxx/ql4_dbg.h b/drivers/scsi/qla4xxx/ql4_dbg.h
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_dbg.h
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c)  2003-2005 QLogic Corporation
+ * QLogic Linux iSCSI Driver
+ *
+ * This program includes a device driver for Linux 2.6 that may be
+ * distributed with QLogic hardware specific firmware binary file.
+ * You may modify and redistribute the device driver code under the
+ * GNU General Public License as published by the Free Software
+ * Foundation (version 2 or a later version) and/or under the
+ * following terms, as applicable:
+ *
+ * 	1. Redistribution of source code must retain the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission.
+ *
+ * You may redistribute the hardware specific firmware binary file
+ * under the following terms:
+ *
+ * 	1. Redistribution of source code (only if applicable),
+ * 	   must retain the above copyright notice, this list of
+ * 	   conditions and the following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission
+ *
+ * REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
+ * THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
+ * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+ * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
+ * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ *
+ * USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
+ * CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
+ * OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
+ * TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
+ * ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
+ * COMBINATION WITH THIS PROGRAM.
+ */
+
+/*
+ * Driver debug definitions.
+ */
+/* #define QL_DEBUG  */			/* DEBUG messages */
+/* #define QL_DEBUG_LEVEL_3  */		/* Output function tracing */
+/* #define QL_DEBUG_LEVEL_4  */
+/* #define QL_DEBUG_LEVEL_5  */
+/* #define QL_DEBUG_LEVEL_9  */
+
+#define QL_DEBUG_LEVEL_2	/* ALways enable error messagess */
+#if defined(QL_DEBUG)
+#define DEBUG(x)   do {x;} while (0);
+#else
+#define DEBUG(x)	do {} while (0);
+#endif
+
+#if defined(QL_DEBUG_LEVEL_2)
+#define DEBUG2(x)      do {if(extended_error_logging == 2) x;} while (0);
+#define DEBUG2_3(x)   do {x;} while (0);
+#else				/*  */
+#define DEBUG2(x)	do {} while (0);
+#endif				/*  */
+
+#if defined(QL_DEBUG_LEVEL_3)
+#define DEBUG3(x)      do {if(extended_error_logging == 3) x;} while (0);
+#else				/*  */
+#define DEBUG3(x)	do {} while (0);
+#if !defined(QL_DEBUG_LEVEL_2)
+#define DEBUG2_3(x)	do {} while (0);
+#endif				/*  */
+#endif				/*  */
+#if defined(QL_DEBUG_LEVEL_4)
+#define DEBUG4(x)	do {x;} while (0);
+#else				/*  */
+#define DEBUG4(x)	do {} while (0);
+#endif				/*  */
+
+#if defined(QL_DEBUG_LEVEL_5)
+#define DEBUG5(x)	do {x;} while (0);
+#else				/*  */
+#define DEBUG5(x)	do {} while (0);
+#endif				/*  */
+
+#if defined(QL_DEBUG_LEVEL_9)
+#define DEBUG9(x)	do {x;} while (0);
+#else				/*  */
+#define DEBUG9(x)	do {} while (0);
+#endif				/*  */
+
+/*
+ *  Debug Print Routines.
+ */
+void qla4xxx_print_scsi_cmd(struct scsi_cmnd *cmd);
+void __dump_registers(scsi_qla_host_t * ha);
+void qla4xxx_dump_mbox_registers(scsi_qla_host_t * ha);
+void qla4xxx_dump_registers(scsi_qla_host_t * ha);
+void qla4xxx_dump_buffer(uint8_t * b, uint32_t size);
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -0,0 +1,264 @@
+/*
+ * Copyright (c)  2003-2005 QLogic Corporation
+ * QLogic Linux iSCSI Driver
+ *
+ * This program includes a device driver for Linux 2.6 that may be
+ * distributed with QLogic hardware specific firmware binary file.
+ * You may modify and redistribute the device driver code under the
+ * GNU General Public License as published by the Free Software
+ * Foundation (version 2 or a later version) and/or under the
+ * following terms, as applicable:
+ *
+ * 	1. Redistribution of source code must retain the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission.
+ *
+ * You may redistribute the hardware specific firmware binary file
+ * under the following terms:
+ *
+ * 	1. Redistribution of source code (only if applicable),
+ * 	   must retain the above copyright notice, this list of
+ * 	   conditions and the following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission
+ *
+ * REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
+ * THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
+ * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+ * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
+ * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ *
+ * USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
+ * CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
+ * OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
+ * TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
+ * ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
+ * COMBINATION WITH THIS PROGRAM.
+ */
+
+#include "ql4_def.h"
+
+#define EEPROM_SIZE(ha) \
+    (IS_QLA4022(ha) ? FM93C86A_SIZE_16 : FM93C66A_SIZE_16)
+#define EEPROM_NO_ADDR_BITS(ha) \
+    (IS_QLA4022(ha) ? FM93C86A_NO_ADDR_BITS_16 : FM93C56A_NO_ADDR_BITS_16)
+#define EEPROM_NO_DATA_BITS(ha) FM93C56A_DATA_BITS_16
+
+int eepromCmdData = 0;
+
+static int
+FM93C56A_Select(scsi_qla_host_t * ha)
+{
+	DEBUG5(printk(KERN_ERR "FM93C56A_Select:\n"));
+
+	eepromCmdData = AUBURN_EEPROM_CS_1 | 0x000f0000;
+	WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData);
+	PCI_POSTING(ISP_NVRAM(ha));
+	return 1;
+}
+
+static int
+FM93C56A_Cmd(scsi_qla_host_t * ha, int cmd, int addr)
+{
+	int i;
+	int mask;
+	int dataBit;
+	int previousBit;
+
+	/* Clock in a zero, then do the start bit. */
+	WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData | AUBURN_EEPROM_DO_1);
+	WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData | AUBURN_EEPROM_DO_1 |
+	    AUBURN_EEPROM_CLK_RISE);
+	WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData | AUBURN_EEPROM_DO_1 |
+	    AUBURN_EEPROM_CLK_FALL);
+	PCI_POSTING(ISP_NVRAM(ha));
+	mask = 1 << (FM93C56A_CMD_BITS - 1);
+
+	/* Force the previous data bit to be different. */
+	previousBit = 0xffff;
+	for (i = 0; i < FM93C56A_CMD_BITS; i++) {
+		dataBit =
+		    (cmd & mask) ? AUBURN_EEPROM_DO_1 : AUBURN_EEPROM_DO_0;
+		if (previousBit != dataBit) {
+
+			/*
+			 * If the bit changed, then change the DO state to
+			 * match.
+			 */
+			WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData | dataBit);
+			previousBit = dataBit;
+		}
+		WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData | dataBit |
+		    AUBURN_EEPROM_CLK_RISE);
+		WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData | dataBit |
+		    AUBURN_EEPROM_CLK_FALL);
+		PCI_POSTING(ISP_NVRAM(ha));
+		cmd = cmd << 1;
+	}
+	mask = 1 << (EEPROM_NO_ADDR_BITS(ha) - 1);
+
+	/* Force the previous data bit to be different. */
+	previousBit = 0xffff;
+	for (i = 0; i < EEPROM_NO_ADDR_BITS(ha); i++) {
+		dataBit = addr & mask ? AUBURN_EEPROM_DO_1 : AUBURN_EEPROM_DO_0;
+		if (previousBit != dataBit) {
+			/*
+			 * If the bit changed, then change the DO state to
+			 * match.
+			 */
+			WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData | dataBit);
+			previousBit = dataBit;
+		}
+		WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData | dataBit |
+		    AUBURN_EEPROM_CLK_RISE);
+		WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData | dataBit |
+		    AUBURN_EEPROM_CLK_FALL);
+		PCI_POSTING(ISP_NVRAM(ha));
+		addr = addr << 1;
+	}
+	return 1;
+}
+
+static int
+FM93C56A_Deselect(scsi_qla_host_t * ha)
+{
+	eepromCmdData = AUBURN_EEPROM_CS_0 | 0x000f0000;
+	WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData);
+	PCI_POSTING(ISP_NVRAM(ha));
+	return 1;
+}
+
+static int
+FM93C56A_DataIn(scsi_qla_host_t * ha, unsigned short *value)
+{
+	int i;
+	int data = 0;
+	int dataBit;
+
+	/* Read the data bits
+	 * The first bit is a dummy.  Clock right over it. */
+	for (i = 0; i < EEPROM_NO_DATA_BITS(ha); i++) {
+		WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData |
+		    AUBURN_EEPROM_CLK_RISE);
+		WRT_REG_DWORD(ISP_NVRAM(ha), eepromCmdData |
+		    AUBURN_EEPROM_CLK_FALL);
+		dataBit =
+		    (RD_REG_DWORD(ISP_NVRAM(ha)) & AUBURN_EEPROM_DI_1) ? 1 : 0;
+		data = (data << 1) | dataBit;
+	}
+
+	*value = data;
+	return 1;
+}
+
+static int
+EEPROM_ReadWord(int eepromAddr, u16 * value, scsi_qla_host_t * ha)
+{
+	FM93C56A_Select(ha);
+	FM93C56A_Cmd(ha, FM93C56A_READ, eepromAddr);
+	FM93C56A_DataIn(ha, value);
+	FM93C56A_Deselect(ha);
+	return 1;
+}
+
+/* Hardware_lock must be set before calling */
+u16
+RD_NVRAM_WORD(scsi_qla_host_t * ha, int offset)
+{
+	u16 val;
+
+	/* NOTE: NVRAM uses half-word addresses */
+	EEPROM_ReadWord(offset, &val, ha);
+	return val;
+}
+
+int
+qla4xxx_is_NVRAM_configuration_valid(scsi_qla_host_t * ha)
+{
+	int status = QLA_ERROR;
+	uint16_t checksum = 0;
+	uint32_t index;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (index = 0; index < EEPROM_SIZE(ha); index++)
+		checksum += RD_NVRAM_WORD(ha, index);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	if (checksum == 0)
+		status = QLA_SUCCESS;
+
+	return status;
+}
+
+/*************************************************************************
+ *
+ *			Hardware Semaphore routines
+ *
+ *************************************************************************/
+int
+ql4xxx_sem_spinlock(scsi_qla_host_t * ha, u32 sem_mask, u32 sem_bits)
+{
+	uint32_t value;
+	DEBUG2(printk("scsi%ld : Trying to get SEM lock - mask= 0x%x, code = "
+	    "0x%x\n", ha->host_no, sem_mask, sem_bits));
+	while (1) {
+		WRT_REG_DWORD(ISP_SEMAPHORE(ha), (sem_mask | sem_bits));
+		value = RD_REG_DWORD(ISP_SEMAPHORE(ha));
+		if ((value & (sem_mask >> 16)) == sem_bits) {
+			DEBUG2(printk("scsi%ld : Got SEM LOCK - mask= 0x%x, "
+			    "code = 0x%x\n", ha->host_no, sem_mask, sem_bits));
+			break;
+		}
+	}
+	return 1;
+}
+
+void
+ql4xxx_sem_unlock(scsi_qla_host_t * ha, u32 sem_mask)
+{
+	WRT_REG_DWORD(ISP_SEMAPHORE(ha), sem_mask);
+	PCI_POSTING(ISP_SEMAPHORE(ha));
+	DEBUG2(printk("scsi%ld : UNLOCK SEM - mask= 0x%x\n", ha->host_no,
+	    sem_mask));
+}
+
+int
+ql4xxx_sem_lock(scsi_qla_host_t * ha, u32 sem_mask, u32 sem_bits)
+{
+	uint32_t value;
+
+	WRT_REG_DWORD(ISP_SEMAPHORE(ha), (sem_mask | sem_bits));
+	value = RD_REG_DWORD(ISP_SEMAPHORE(ha));
+	if ((value & (sem_mask >> 16)) == sem_bits) {
+		DEBUG2(printk("scsi%ld : Got SEM LOCK - mask= 0x%x, code = "
+		    "0x%x, sema code=0x%x\n", ha->host_no, sem_mask, sem_bits,
+		    value));
+		return 1;
+	}
+	return 0;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.h b/drivers/scsi/qla4xxx/ql4_nvram.h
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_nvram.h
@@ -0,0 +1,341 @@
+/*
+ * Copyright (c)  2003-2005 QLogic Corporation
+ * QLogic Linux iSCSI Driver
+ *
+ * This program includes a device driver for Linux 2.6 that may be
+ * distributed with QLogic hardware specific firmware binary file.
+ * You may modify and redistribute the device driver code under the
+ * GNU General Public License as published by the Free Software
+ * Foundation (version 2 or a later version) and/or under the
+ * following terms, as applicable:
+ *
+ * 	1. Redistribution of source code must retain the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission.
+ *
+ * You may redistribute the hardware specific firmware binary file
+ * under the following terms:
+ *
+ * 	1. Redistribution of source code (only if applicable),
+ * 	   must retain the above copyright notice, this list of
+ * 	   conditions and the following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission
+ *
+ * REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
+ * THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
+ * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+ * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
+ * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ *
+ * USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
+ * CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
+ * OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
+ * TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
+ * ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
+ * COMBINATION WITH THIS PROGRAM.
+ */
+
+#ifndef _QL2XNVRM_H_
+#define _QL2XNVRM_H_
+
+//
+// AM29LV Flash definitions
+//
+#define  FM93C56A_SIZE_8      0x100
+#define  FM93C56A_SIZE_16     0x80
+#define  FM93C66A_SIZE_8      0x200
+#define  FM93C66A_SIZE_16     0x100	/* 4010 */
+#define  FM93C86A_SIZE_16     0x400	/* 4022 */
+
+#define  FM93C56A_START       0x1
+
+// Commands
+#define  FM93C56A_READ        0x2
+#define  FM93C56A_WEN         0x0
+#define  FM93C56A_WRITE       0x1
+#define  FM93C56A_WRITE_ALL   0x0
+#define  FM93C56A_WDS         0x0
+#define  FM93C56A_ERASE       0x3
+#define  FM93C56A_ERASE_ALL   0x0
+
+// Command Extentions
+#define  FM93C56A_WEN_EXT        0x3
+#define  FM93C56A_WRITE_ALL_EXT  0x1
+#define  FM93C56A_WDS_EXT        0x0
+#define  FM93C56A_ERASE_ALL_EXT  0x2
+
+// Address Bits
+#define  FM93C56A_NO_ADDR_BITS_16   8	/* 4010 */
+#define  FM93C56A_NO_ADDR_BITS_8    9	/* 4010 */
+#define  FM93C86A_NO_ADDR_BITS_16   10	/* 4022 */
+
+// Data Bits
+#define  FM93C56A_DATA_BITS_16   16
+#define  FM93C56A_DATA_BITS_8    8
+
+// Special Bits
+#define  FM93C56A_READ_DUMMY_BITS   1
+#define  FM93C56A_READY             0
+#define  FM93C56A_BUSY              1
+#define  FM93C56A_CMD_BITS          2
+
+// Auburn Bits
+#define  AUBURN_EEPROM_DI           0x8
+#define  AUBURN_EEPROM_DI_0         0x0
+#define  AUBURN_EEPROM_DI_1         0x8
+#define  AUBURN_EEPROM_DO           0x4
+#define  AUBURN_EEPROM_DO_0         0x0
+#define  AUBURN_EEPROM_DO_1         0x4
+#define  AUBURN_EEPROM_CS           0x2
+#define  AUBURN_EEPROM_CS_0         0x0
+#define  AUBURN_EEPROM_CS_1         0x2
+#define  AUBURN_EEPROM_CLK_RISE     0x1
+#define  AUBURN_EEPROM_CLK_FALL     0x0
+
+//
+// EEPROM format
+//
+typedef struct _BIOS_PARAMS {
+	uint16_t SpinUpDelay:1;
+	uint16_t BIOSDisable:1;
+	uint16_t MMAPEnable:1;
+	uint16_t BootEnable:1;
+	uint16_t Reserved0:12;
+	uint8_t bootID0:7;
+	uint8_t bootID0Valid:1;
+	uint8_t bootLUN0[8];
+	uint8_t bootID1:7;
+	uint8_t bootID1Valid:1;
+	uint8_t bootLUN1[8];
+	uint16_t MaxLunsPerTarget;
+	uint8_t Reserved1[10];
+} BIOS_PARAMS, *PBIOS_PARAMS;
+typedef struct _EEPROM_PORT_CFG {
+
+	// MTU MAC 0
+	u16 etherMtu_mac;
+
+	// Flow Control MAC 0
+	u16 pauseThreshold_mac;
+	u16 resumeThreshold_mac;
+	u16 reserved[13];
+} EEPROM_PORT_CFG, *PEEPROM_PORT_CFG;
+typedef struct _EEPROM_FUNCTION_CFG {
+	u8 reserved[30];
+
+	// MAC ADDR
+	u8 macAddress[6];
+	u8 macAddressSecondary[6];
+	u16 subsysVendorId;
+	u16 subsysDeviceId;
+} EEPROM_FUNCTION_CFG;
+typedef struct {
+	union {
+		struct {	/* isp4010 */
+			u8 asic_id[4];	// x00
+			u8 version;	// x04
+			u8 reserved;	// x05
+			u16 board_id;	// x06
+#  define   EEPROM_BOARDID_ELDORADO    1
+#  define   EEPROM_BOARDID_PLACER      2
+
+#  define EEPROM_SERIAL_NUM_SIZE       16
+			u8 serial_number[EEPROM_SERIAL_NUM_SIZE];	// x08
+
+			// ExtHwConfig:
+			// Offset = 24bytes
+			//
+			// | SSRAM Size|     |ST|PD|SDRAM SZ| W| B| SP  |  |
+			// |15|14|13|12|11|10| 9| 8 | 7| 6| 5| 4| 3| 2| 1| 0|
+			// +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
+			u16 ext_hw_conf;	// x18
+			u8 mac0[6];	// x1A
+			u8 mac1[6];	// x20
+			u8 mac2[6];	// x26
+			u8 mac3[6];	// x2C
+			u16 etherMtu;	// x32
+			u16 macConfig;	// x34
+#define  MAC_CONFIG_ENABLE_ANEG     0x0001
+#define  MAC_CONFIG_ENABLE_PAUSE    0x0002
+			u16 phyConfig;	// x36
+#define  PHY_CONFIG_PHY_ADDR_MASK             0x1f
+#define  PHY_CONFIG_ENABLE_FW_MANAGEMENT_MASK 0x20
+			u16 topcat;	// x38
+#define TOPCAT_PRESENT		0x0100
+#define TOPCAT_MASK		0xFF00
+
+#  define EEPROM_UNUSED_1_SIZE   2
+			u8 unused_1[EEPROM_UNUSED_1_SIZE];	// x3A
+			u16 bufletSize;	// x3C
+			u16 bufletCount;	// x3E
+			u16 bufletPauseThreshold;	// x40
+			u16 tcpWindowThreshold50;	// x42
+			u16 tcpWindowThreshold25;	// x44
+			u16 tcpWindowThreshold0;	// x46
+			u16 ipHashTableBaseHi;	// x48
+			u16 ipHashTableBaseLo;	// x4A
+			u16 ipHashTableSize;	// x4C
+			u16 tcpHashTableBaseHi;	// x4E
+			u16 tcpHashTableBaseLo;	// x50
+			u16 tcpHashTableSize;	// x52
+			u16 ncbTableBaseHi;	// x54
+			u16 ncbTableBaseLo;	// x56
+			u16 ncbTableSize;	// x58
+			u16 drbTableBaseHi;	// x5A
+			u16 drbTableBaseLo;	// x5C
+			u16 drbTableSize;	// x5E
+
+#  define EEPROM_UNUSED_2_SIZE   4
+			u8 unused_2[EEPROM_UNUSED_2_SIZE];	// x60
+			u16 ipReassemblyTimeout;	// x64
+			u16 tcpMaxWindowSizeHi;	// x66
+			u16 tcpMaxWindowSizeLo;	// x68
+			u32 net_ip_addr0;	// x6A /* Added for TOE functionality. */
+			u32 net_ip_addr1;	// x6E
+			u32 scsi_ip_addr0;	// x72
+			u32 scsi_ip_addr1;	// x76
+#  define EEPROM_UNUSED_3_SIZE   128	/* changed from 144 to account for ip addresses */
+			u8 unused_3[EEPROM_UNUSED_3_SIZE];	// x7A
+			u16 subsysVendorId_f0;	// xFA
+			u16 subsysDeviceId_f0;	// xFC
+
+			// Address = 0x7F
+#  define FM93C56A_SIGNATURE  0x9356
+#  define FM93C66A_SIGNATURE  0x9366
+			u16 signature;	// xFE
+
+#  define EEPROM_UNUSED_4_SIZE   250
+			u8 unused_4[EEPROM_UNUSED_4_SIZE];	// x100
+			u16 subsysVendorId_f1;	// x1FA
+			u16 subsysDeviceId_f1;	// x1FC
+			u16 checksum;	// x1FE
+		} __attribute__ ((packed)) isp4010;
+		struct {	/* isp4022 */
+			u8 asicId[4];	// x00
+			u8 version;	// x04
+			u8 reserved_5;	// x05
+			u16 boardId;	// x06
+			u8 boardIdStr[16];	// x08
+			u8 serialNumber[16];	// x18
+
+			// External Hardware Configuration
+			u16 ext_hw_conf;	// x28
+
+			// MAC 0 CONFIGURATION
+			EEPROM_PORT_CFG macCfg_port0;	// x2A
+
+			// MAC 1 CONFIGURATION
+			EEPROM_PORT_CFG macCfg_port1;	// x4A
+
+			// DDR SDRAM Configuration
+			u16 bufletSize;	// x6A
+			u16 bufletCount;	// x6C
+			u16 tcpWindowThreshold50;	// x6E
+			u16 tcpWindowThreshold25;	// x70
+			u16 tcpWindowThreshold0;	// x72
+			u16 ipHashTableBaseHi;	// x74
+			u16 ipHashTableBaseLo;	// x76
+			u16 ipHashTableSize;	// x78
+			u16 tcpHashTableBaseHi;	// x7A
+			u16 tcpHashTableBaseLo;	// x7C
+			u16 tcpHashTableSize;	// x7E
+			u16 ncbTableBaseHi;	// x80
+			u16 ncbTableBaseLo;	// x82
+			u16 ncbTableSize;	// x84
+			u16 drbTableBaseHi;	// x86
+			u16 drbTableBaseLo;	// x88
+			u16 drbTableSize;	// x8A
+			u16 reserved_142[4];	// x8C
+
+			// TCP/IP Parameters
+			u16 ipReassemblyTimeout;	// x94
+			u16 tcpMaxWindowSize;	// x96
+			u16 ipSecurity;	// x98
+			u8 reserved_156[294];	// x9A
+			u16 qDebug[8];	// QLOGIC USE ONLY   x1C0
+			EEPROM_FUNCTION_CFG funcCfg_fn0;	// x1D0
+			u16 reserved_510;	// x1FE
+
+			// Address = 512
+			u8 oemSpace[432];	// x200
+			BIOS_PARAMS sBIOSParams_fn1;	// x3B0
+			EEPROM_FUNCTION_CFG funcCfg_fn1;	// x3D0
+			u16 reserved_1022;	// x3FE
+
+			// Address = 1024
+			u8 reserved_1024[464];	// x400
+			EEPROM_FUNCTION_CFG funcCfg_fn2;	// x5D0
+			u16 reserved_1534;	// x5FE
+
+			// Address = 1536
+			u8 reserved_1536[432];	// x600
+			BIOS_PARAMS sBIOSParams_fn3;	// x7B0
+			EEPROM_FUNCTION_CFG funcCfg_fn3;	// x7D0
+			u16 checksum;	// x7FE
+		} __attribute__ ((packed)) isp4022;
+	};
+} eeprom_data_t;
+
+#define EEPROM_EXT_HW_CONF_OFFSET() \
+    (IS_QLA4022(ha) ? \
+     offsetof(eeprom_data_t, isp4022.ext_hw_conf) / 2 : \
+     offsetof(eeprom_data_t, isp4010.ext_hw_conf) / 2)
+/*************************************************************************
+ *
+ *			Hardware Semaphore
+ *
+ *************************************************************************/
+#if 0
+//
+// Semaphore register definitions
+//
+#define SEM_AVAILABLE        	0x00
+#define SEM_OWNER_FIRMWARE   	0x01
+#define SEM_OWNER_STORAGE    	0x02
+#define SEM_OWNER_NETWORK    	0x03
+
+//
+// Private Semaphore definitions
+//
+typedef enum { SEM_HW_LOCK, SEM_GPO, SEM_SDRAM_INIT, SEM_PHY_GBIC, SEM_NVRAM, SEM_FLASH, SEM_COUNT	// Not a real semaphore, just indicates how many there are
+} ISP4XXX_SEMAPHORE;
+typedef struct {
+	uint32_t semId;
+	uint32_t semShift;
+} isp4xxxSemInfo_t;
+
+#define SEM_MASK  0x3
+
+/* Wait flag defines -- specifies type of wait to acquire semaphore */
+#define SEM_FLG_NO_WAIT		0
+#define SEM_FLG_WAIT_FOREVER	1
+#define SEM_FLG_TIMED_WAIT	2
+
+#endif				/*  */
+
+#endif				// _QL2XNVRM_H_

-- 
Andrew Vasquez
