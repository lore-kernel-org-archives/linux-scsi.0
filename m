From: David Somayajulu <david.somayajulu@qlogic.com>
Subject: [RFC] [PATCH 6/7] qla4xxx: driver support routines
Date: Mon, 10 Jul 2006 17:01:00 -0400
Message-ID: <1152565261.17882.61.camel@davlnxhost.QLOGIC>
References: <1152564679.17882.49.camel@davlnxhost.QLOGIC>
	 <1152564896.17882.53.camel@davlnxhost.QLOGIC>
	 <1152565021.17882.55.camel@davlnxhost.QLOGIC>
	 <1152565134.17882.58.camel@davlnxhost.QLOGIC>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:11168 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S965336AbWGKABB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 20:01:01 -0400
In-Reply-To: <1152565134.17882.58.camel@davlnxhost.QLOGIC>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com, David Wagner <david.wagner@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>

qla4xxx driver support routines.

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
Signed-off-by: Doug Maxey <dwm@bubba.enoyolf.org>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
diff --git a/drivers/scsi/qla4xxx/ql4_dbg.c b/drivers/scsi/qla4xxx/ql4_dbg.c
new file mode 100644
index 0000000..6e2902a
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -0,0 +1,215 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2006 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
+ */
+
+#include "ql4_def.h"
+
+/*
+ * qla4xxx_print_srb_cmd
+ *	This routine displays the SRB command
+ */
+static void qla4xxx_print_srb_info(struct srb * srb)
+{
+	printk("%s: srb = 0x%p, flags=0x%02x\n", __func__, srb, srb->flags);
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
+				    (cmd->use_sg * sizeof(*sg)));
+	}
+	printk("  tag = %d, transfersize = 0x%x \n", cmd->tag,
+	       cmd->transfersize);
+	printk("  Pid = %d, SP = 0x%p\n", (int)cmd->pid, cmd->SCp.ptr);
+	printk("  underflow size = 0x%x, direction=0x%x\n", cmd->underflow,
+	       cmd->sc_data_direction);
+	printk("  Current time (jiffies) = 0x%lx, "
+	       "timeout expires = 0x%lx\n", jiffies, cmd->eh_timeout.expires);
+	qla4xxx_print_srb_info((struct srb *) cmd->SCp.ptr);
+}
+
+void __dump_registers(struct scsi_qla_host *ha)
+{
+	uint8_t i;
+	for (i = 0; i < MBOX_REG_COUNT; i++) {
+		printk(KERN_INFO "0x%02X mailbox[%d]	  = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg, mailbox[i]), i,
+		       readw(&ha->reg->mailbox[i]));
+	}
+	printk(KERN_INFO "0x%02X flash_address	 = 0x%08X\n",
+	       (uint8_t) offsetof(struct isp_reg, flash_address),
+	       readw(&ha->reg->flash_address));
+	printk(KERN_INFO "0x%02X flash_data	 = 0x%08X\n",
+	       (uint8_t) offsetof(struct isp_reg, flash_data),
+	       readw(&ha->reg->flash_data));
+	printk(KERN_INFO "0x%02X ctrl_status	 = 0x%08X\n",
+	       (uint8_t) offsetof(struct isp_reg, ctrl_status),
+	       readw(&ha->reg->ctrl_status));
+	if (is_qla4010(ha)) {
+		printk(KERN_INFO "0x%02X nvram		 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg, u1.isp4010.nvram),
+		       readw(&ha->reg->u1.isp4010.nvram));
+	}
+
+	else if (is_qla4022(ha)) {
+		printk(KERN_INFO "0x%02X intr_mask	 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u1.isp4022.intr_mask),
+		       readw(&ha->reg->u1.isp4022.intr_mask));
+		printk(KERN_INFO "0x%02X nvram		 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg, u1.isp4022.nvram),
+		       readw(&ha->reg->u1.isp4022.nvram));
+		printk(KERN_INFO "0x%02X semaphore	 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u1.isp4022.semaphore),
+		       readw(&ha->reg->u1.isp4022.semaphore));
+	}
+	printk(KERN_INFO "0x%02X req_q_in	 = 0x%08X\n",
+	       (uint8_t) offsetof(struct isp_reg, req_q_in),
+	       readw(&ha->reg->req_q_in));
+	printk(KERN_INFO "0x%02X rsp_q_out	 = 0x%08X\n",
+	       (uint8_t) offsetof(struct isp_reg, rsp_q_out),
+	       readw(&ha->reg->rsp_q_out));
+	if (is_qla4010(ha)) {
+		printk(KERN_INFO "0x%02X ext_hw_conf	 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u2.isp4010.ext_hw_conf),
+		       readw(&ha->reg->u2.isp4010.ext_hw_conf));
+		printk(KERN_INFO "0x%02X port_ctrl	 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u2.isp4010.port_ctrl),
+		       readw(&ha->reg->u2.isp4010.port_ctrl));
+		printk(KERN_INFO "0x%02X port_status	 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u2.isp4010.port_status),
+		       readw(&ha->reg->u2.isp4010.port_status));
+		printk(KERN_INFO "0x%02X req_q_out	 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u2.isp4010.req_q_out),
+		       readw(&ha->reg->u2.isp4010.req_q_out));
+		printk(KERN_INFO "0x%02X gp_out		 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg, u2.isp4010.gp_out),
+		       readw(&ha->reg->u2.isp4010.gp_out));
+		printk(KERN_INFO "0x%02X gp_in		 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg, u2.isp4010.gp_in),
+		       readw(&ha->reg->u2.isp4010.gp_in));
+		printk(KERN_INFO "0x%02X port_err_status = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u2.isp4010.port_err_status),
+		       readw(&ha->reg->u2.isp4010.port_err_status));
+	}
+
+	else if (is_qla4022(ha)) {
+		printk(KERN_INFO "Page 0 Registers:\n");
+		printk(KERN_INFO "0x%02X ext_hw_conf	 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u2.isp4022.p0.ext_hw_conf),
+		       readw(&ha->reg->u2.isp4022.p0.ext_hw_conf));
+		printk(KERN_INFO "0x%02X port_ctrl	 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u2.isp4022.p0.port_ctrl),
+		       readw(&ha->reg->u2.isp4022.p0.port_ctrl));
+		printk(KERN_INFO "0x%02X port_status	 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u2.isp4022.p0.port_status),
+		       readw(&ha->reg->u2.isp4022.p0.port_status));
+		printk(KERN_INFO "0x%02X gp_out		 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u2.isp4022.p0.gp_out),
+		       readw(&ha->reg->u2.isp4022.p0.gp_out));
+		printk(KERN_INFO "0x%02X gp_in		 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg, u2.isp4022.p0.gp_in),
+		       readw(&ha->reg->u2.isp4022.p0.gp_in));
+		printk(KERN_INFO "0x%02X port_err_status = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u2.isp4022.p0.port_err_status),
+		       readw(&ha->reg->u2.isp4022.p0.port_err_status));
+		printk(KERN_INFO "Page 1 Registers:\n");
+		writel(HOST_MEM_CFG_PAGE & set_rmask(CSR_SCSI_PAGE_SELECT),
+		       &ha->reg->ctrl_status);
+		printk(KERN_INFO "0x%02X req_q_out	 = 0x%08X\n",
+		       (uint8_t) offsetof(struct isp_reg,
+					  u2.isp4022.p1.req_q_out),
+		       readw(&ha->reg->u2.isp4022.p1.req_q_out));
+		writel(PORT_CTRL_STAT_PAGE & set_rmask(CSR_SCSI_PAGE_SELECT),
+		       &ha->reg->ctrl_status);
+	}
+}
+
+/*
+ * qla4xxx_dump_registers
+ *	This routine displays ISP registers
+ *
+ * Input:
+ *	ha	 - adapter structure pointer
+ *
+ */
+void qla4xxx_dump_mbox_registers(struct scsi_qla_host *ha)
+{
+	unsigned long flags = 0;
+	int i = 0;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (i = 1; i < MBOX_REG_COUNT; i++)
+		printk(KERN_INFO "  Mailbox[%d] = %08x\n", i,
+		       readw(&ha->reg->mailbox[i]));
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+void qla4xxx_dump_registers(struct scsi_qla_host *ha)
+{
+	unsigned long flags = 0;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	__dump_registers(ha);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+void qla4xxx_dump_buffer(void *b, uint32_t size)
+{
+	uint32_t cnt;
+	uint8_t *c = b;
+
+	printk(" 0   1	 2   3	 4   5	 6   7	 8   9	Ah  Bh	Ch  Dh	Eh  "
+	       "Fh\n");
+	printk("------------------------------------------------------------"
+	       "--\n");
+	for (cnt = 0; cnt < size; cnt++, c++) {
+		printk(KERN_DEBUG "%02x", *c);
+		if (!(cnt % 16))
+			printk(KERN_DEBUG "\n");
+
+		else
+			printk(KERN_DEBUG "  ");
+	}
+	if (cnt % 16)
+		printk(KERN_DEBUG "\n");
+}
diff --git a/drivers/scsi/qla4xxx/ql4_dbg.h b/drivers/scsi/qla4xxx/ql4_dbg.h
new file mode 100644
index 0000000..56ddc22
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_dbg.h
@@ -0,0 +1,55 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2006 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
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
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
new file mode 100644
index 0000000..1f497e2
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -0,0 +1,223 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2006 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
+ */
+
+#include "ql4_def.h"
+
+static inline int eeprom_size(struct scsi_qla_host *ha)
+{
+	return is_qla4022(ha) ? FM93C86A_SIZE_16 : FM93C66A_SIZE_16;
+}
+
+static inline int eeprom_no_addr_bits(struct scsi_qla_host *ha)
+{
+	return is_qla4022(ha) ? FM93C86A_NO_ADDR_BITS_16 :
+		FM93C56A_NO_ADDR_BITS_16;
+}
+
+static inline int eeprom_no_data_bits(struct scsi_qla_host *ha)
+{
+	return FM93C56A_DATA_BITS_16;
+}
+
+static int fm93c56a_select(struct scsi_qla_host * ha)
+{
+	DEBUG5(printk(KERN_ERR "fm93c56a_select:\n"));
+
+	ha->eeprom_cmd_data = AUBURN_EEPROM_CS_1 | 0x000f0000;
+	writel(ha->eeprom_cmd_data, isp_nvram(ha));
+	readl(isp_nvram(ha));
+	return 1;
+}
+
+static int fm93c56a_cmd(struct scsi_qla_host * ha, int cmd, int addr)
+{
+	int i;
+	int mask;
+	int dataBit;
+	int previousBit;
+
+	/* Clock in a zero, then do the start bit. */
+	writel(ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1, isp_nvram(ha));
+	writel(ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1 |
+	       AUBURN_EEPROM_CLK_RISE, isp_nvram(ha));
+	writel(ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1 |
+	       AUBURN_EEPROM_CLK_FALL, isp_nvram(ha));
+	readl(isp_nvram(ha));
+	mask = 1 << (FM93C56A_CMD_BITS - 1);
+
+	/* Force the previous data bit to be different. */
+	previousBit = 0xffff;
+	for (i = 0; i < FM93C56A_CMD_BITS; i++) {
+		dataBit =
+			(cmd & mask) ? AUBURN_EEPROM_DO_1 : AUBURN_EEPROM_DO_0;
+		if (previousBit != dataBit) {
+
+			/*
+			 * If the bit changed, then change the DO state to
+			 * match.
+			 */
+			writel(ha->eeprom_cmd_data | dataBit, isp_nvram(ha));
+			previousBit = dataBit;
+		}
+		writel(ha->eeprom_cmd_data | dataBit |
+		       AUBURN_EEPROM_CLK_RISE, isp_nvram(ha));
+		writel(ha->eeprom_cmd_data | dataBit |
+		       AUBURN_EEPROM_CLK_FALL, isp_nvram(ha));
+		readl(isp_nvram(ha));
+		cmd = cmd << 1;
+	}
+	mask = 1 << (eeprom_no_addr_bits(ha) - 1);
+
+	/* Force the previous data bit to be different. */
+	previousBit = 0xffff;
+	for (i = 0; i < eeprom_no_addr_bits(ha); i++) {
+		dataBit = addr & mask ? AUBURN_EEPROM_DO_1 :
+			AUBURN_EEPROM_DO_0;
+		if (previousBit != dataBit) {
+			/*
+			 * If the bit changed, then change the DO state to
+			 * match.
+			 */
+			writel(ha->eeprom_cmd_data | dataBit, isp_nvram(ha));
+			previousBit = dataBit;
+		}
+		writel(ha->eeprom_cmd_data | dataBit |
+		       AUBURN_EEPROM_CLK_RISE, isp_nvram(ha));
+		writel(ha->eeprom_cmd_data | dataBit |
+		       AUBURN_EEPROM_CLK_FALL, isp_nvram(ha));
+		readl(isp_nvram(ha));
+		addr = addr << 1;
+	}
+	return 1;
+}
+
+static int fm93c56a_deselect(struct scsi_qla_host * ha)
+{
+	ha->eeprom_cmd_data = AUBURN_EEPROM_CS_0 | 0x000f0000;
+	writel(ha->eeprom_cmd_data, isp_nvram(ha));
+	readl(isp_nvram(ha));
+	return 1;
+}
+
+static int fm93c56a_datain(struct scsi_qla_host * ha, unsigned short *value)
+{
+	int i;
+	int data = 0;
+	int dataBit;
+
+	/* Read the data bits
+	 * The first bit is a dummy.  Clock right over it. */
+	for (i = 0; i < eeprom_no_data_bits(ha); i++) {
+		writel(ha->eeprom_cmd_data |
+		       AUBURN_EEPROM_CLK_RISE, isp_nvram(ha));
+		writel(ha->eeprom_cmd_data |
+		       AUBURN_EEPROM_CLK_FALL, isp_nvram(ha));
+		dataBit =
+			(readw(isp_nvram(ha)) & AUBURN_EEPROM_DI_1) ? 1 : 0;
+		data = (data << 1) | dataBit;
+	}
+
+	*value = data;
+	return 1;
+}
+
+static int eeprom_readword(int eepromAddr, u16 * value,
+			   struct scsi_qla_host * ha)
+{
+	fm93c56a_select(ha);
+	fm93c56a_cmd(ha, FM93C56A_READ, eepromAddr);
+	fm93c56a_datain(ha, value);
+	fm93c56a_deselect(ha);
+	return 1;
+}
+
+/* Hardware_lock must be set before calling */
+u16 rd_nvram_word(struct scsi_qla_host * ha, int offset)
+{
+	u16 val;
+
+	/* NOTE: NVRAM uses half-word addresses */
+	eeprom_readword(offset, &val, ha);
+	return val;
+}
+
+int qla4xxx_is_nvram_configuration_valid(struct scsi_qla_host * ha)
+{
+	int status = QLA_ERROR;
+	uint16_t checksum = 0;
+	uint32_t index;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (index = 0; index < eeprom_size(ha); index++)
+		checksum += rd_nvram_word(ha, index);
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
+int ql4xxx_sem_spinlock(struct scsi_qla_host * ha, u32 sem_mask, u32 sem_bits)
+{
+	uint32_t value;
+	unsigned long flags;
+
+	DEBUG2(printk("scsi%ld : Trying to get SEM lock - mask= 0x%x, code = "
+		      "0x%x\n", ha->host_no, sem_mask, sem_bits));
+	while (1) {
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		writel((sem_mask | sem_bits), isp_semaphore(ha));
+		value = readw(isp_semaphore(ha));
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		if ((value & (sem_mask >> 16)) == sem_bits) {
+			DEBUG2(printk("scsi%ld : Got SEM LOCK - mask= 0x%x, "
+				      "code = 0x%x\n", ha->host_no,
+				      sem_mask, sem_bits));
+			break;
+		}
+		msleep(100);
+	}
+	return 1;
+}
+
+void ql4xxx_sem_unlock(struct scsi_qla_host * ha, u32 sem_mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	writel(sem_mask, isp_semaphore(ha));
+	readl(isp_semaphore(ha));
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	DEBUG2(printk("scsi%ld : UNLOCK SEM - mask= 0x%x\n", ha->host_no,
+		      sem_mask));
+}
+
+int ql4xxx_sem_lock(struct scsi_qla_host * ha, u32 sem_mask, u32 sem_bits)
+{
+	uint32_t value;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	writel((sem_mask | sem_bits), isp_semaphore(ha));
+	value = readw(isp_semaphore(ha));
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if ((value & (sem_mask >> 16)) == sem_bits) {
+		DEBUG2(printk("scsi%ld : Got SEM LOCK - mask= 0x%x, code = "
+			      "0x%x, sema code=0x%x\n", ha->host_no,
+			      sem_mask, sem_bits, value));
+		return 1;
+	}
+	return 0;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.h b/drivers/scsi/qla4xxx/ql4_nvram.h
new file mode 100644
index 0000000..08e2aed
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_nvram.h
@@ -0,0 +1,256 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2006 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
+ */
+
+#ifndef _QL4XNVRM_H_
+#define _QL4XNVRM_H_
+
+/*
+ * AM29LV Flash definitions
+ */
+#define FM93C56A_SIZE_8	 0x100
+#define FM93C56A_SIZE_16 0x80
+#define FM93C66A_SIZE_8	 0x200
+#define FM93C66A_SIZE_16 0x100/* 4010 */
+#define FM93C86A_SIZE_16 0x400/* 4022 */
+
+#define	 FM93C56A_START	      0x1
+
+// Commands
+#define	 FM93C56A_READ	      0x2
+#define	 FM93C56A_WEN	      0x0
+#define	 FM93C56A_WRITE	      0x1
+#define	 FM93C56A_WRITE_ALL   0x0
+#define	 FM93C56A_WDS	      0x0
+#define	 FM93C56A_ERASE	      0x3
+#define	 FM93C56A_ERASE_ALL   0x0
+
+/* Command Extentions */
+#define	 FM93C56A_WEN_EXT	 0x3
+#define	 FM93C56A_WRITE_ALL_EXT	 0x1
+#define	 FM93C56A_WDS_EXT	 0x0
+#define	 FM93C56A_ERASE_ALL_EXT	 0x2
+
+/* Address Bits */
+#define	 FM93C56A_NO_ADDR_BITS_16   8	/* 4010 */
+#define	 FM93C56A_NO_ADDR_BITS_8    9	/* 4010 */
+#define	 FM93C86A_NO_ADDR_BITS_16   10	/* 4022 */
+
+/* Data Bits */
+#define	 FM93C56A_DATA_BITS_16	 16
+#define	 FM93C56A_DATA_BITS_8	 8
+
+/* Special Bits */
+#define	 FM93C56A_READ_DUMMY_BITS   1
+#define	 FM93C56A_READY		    0
+#define	 FM93C56A_BUSY		    1
+#define	 FM93C56A_CMD_BITS	    2
+
+/* Auburn Bits */
+#define	 AUBURN_EEPROM_DI	    0x8
+#define	 AUBURN_EEPROM_DI_0	    0x0
+#define	 AUBURN_EEPROM_DI_1	    0x8
+#define	 AUBURN_EEPROM_DO	    0x4
+#define	 AUBURN_EEPROM_DO_0	    0x0
+#define	 AUBURN_EEPROM_DO_1	    0x4
+#define	 AUBURN_EEPROM_CS	    0x2
+#define	 AUBURN_EEPROM_CS_0	    0x0
+#define	 AUBURN_EEPROM_CS_1	    0x2
+#define	 AUBURN_EEPROM_CLK_RISE	    0x1
+#define	 AUBURN_EEPROM_CLK_FALL	    0x0
+
+/* */
+/* EEPROM format */
+/* */
+struct bios_params {
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
+};
+
+struct eeprom_port_cfg {
+
+	/* MTU MAC 0 */
+	u16 etherMtu_mac;
+
+	/* Flow Control MAC 0 */
+	u16 pauseThreshold_mac;
+	u16 resumeThreshold_mac;
+	u16 reserved[13];
+};
+
+struct eeprom_function_cfg {
+	u8 reserved[30];
+
+	/* MAC ADDR */
+	u8 macAddress[6];
+	u8 macAddressSecondary[6];
+	u16 subsysVendorId;
+	u16 subsysDeviceId;
+};
+
+struct eeprom_data {
+	union {
+		struct {	/* isp4010 */
+			u8 asic_id[4]; /* x00 */
+			u8 version;	/* x04 */
+			u8 reserved;	/* x05 */
+			u16 board_id;	/* x06 */
+#define	  EEPROM_BOARDID_ELDORADO    1
+#define	  EEPROM_BOARDID_PLACER	     2
+
+#define EEPROM_SERIAL_NUM_SIZE	     16
+			u8 serial_number[EEPROM_SERIAL_NUM_SIZE]; /* x08 */
+
+			/* ExtHwConfig: */
+			/* Offset = 24bytes
+			 *
+			 * | SSRAM Size|     |ST|PD|SDRAM SZ| W| B| SP	|  |
+			 * |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
+			 * +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
+			 */
+			u16 ext_hw_conf; /* x18 */
+			u8 mac0[6];	/* x1A */
+			u8 mac1[6];	/* x20 */
+			u8 mac2[6];	/* x26 */
+			u8 mac3[6];	/* x2C */
+			u16 etherMtu;	/* x32 */
+			u16 macConfig;	/* x34 */
+#define	 MAC_CONFIG_ENABLE_ANEG	    0x0001
+#define	 MAC_CONFIG_ENABLE_PAUSE    0x0002
+			u16 phyConfig;	/* x36 */
+#define	 PHY_CONFIG_PHY_ADDR_MASK	      0x1f
+#define	 PHY_CONFIG_ENABLE_FW_MANAGEMENT_MASK 0x20
+			u16 topcat;	/* x38 */
+#define TOPCAT_PRESENT		0x0100
+#define TOPCAT_MASK		0xFF00
+
+#define EEPROM_UNUSED_1_SIZE   2
+			u8 unused_1[EEPROM_UNUSED_1_SIZE]; /* x3A */
+			u16 bufletSize;	/* x3C */
+			u16 bufletCount;	/* x3E */
+			u16 bufletPauseThreshold; /* x40 */
+			u16 tcpWindowThreshold50; /* x42 */
+			u16 tcpWindowThreshold25; /* x44 */
+			u16 tcpWindowThreshold0; /* x46 */
+			u16 ipHashTableBaseHi;	/* x48 */
+			u16 ipHashTableBaseLo;	/* x4A */
+			u16 ipHashTableSize;	/* x4C */
+			u16 tcpHashTableBaseHi;	/* x4E */
+			u16 tcpHashTableBaseLo;	/* x50 */
+			u16 tcpHashTableSize;	/* x52 */
+			u16 ncbTableBaseHi;	/* x54 */
+			u16 ncbTableBaseLo;	/* x56 */
+			u16 ncbTableSize;	/* x58 */
+			u16 drbTableBaseHi;	/* x5A */
+			u16 drbTableBaseLo;	/* x5C */
+			u16 drbTableSize;	/* x5E */
+
+#define EEPROM_UNUSED_2_SIZE   4
+			u8 unused_2[EEPROM_UNUSED_2_SIZE]; /* x60 */
+			u16 ipReassemblyTimeout; /* x64 */
+			u16 tcpMaxWindowSizeHi;	/* x66 */
+			u16 tcpMaxWindowSizeLo;	/* x68 */
+			u32 net_ip_addr0;	/* x6A Added for TOE
+						 * functionality. */
+			u32 net_ip_addr1;	/* x6E */
+			u32 scsi_ip_addr0;	/* x72 */
+			u32 scsi_ip_addr1;	/* x76 */
+#define EEPROM_UNUSED_3_SIZE   128	/* changed from 144 to account
+					 * for ip addresses */
+			u8 unused_3[EEPROM_UNUSED_3_SIZE]; /* x7A */
+			u16 subsysVendorId_f0;	/* xFA */
+			u16 subsysDeviceId_f0;	/* xFC */
+
+			/* Address = 0x7F */
+#define FM93C56A_SIGNATURE  0x9356
+#define FM93C66A_SIGNATURE  0x9366
+			u16 signature;	/* xFE */
+
+#define EEPROM_UNUSED_4_SIZE   250
+			u8 unused_4[EEPROM_UNUSED_4_SIZE]; /* x100 */
+			u16 subsysVendorId_f1;	/* x1FA */
+			u16 subsysDeviceId_f1;	/* x1FC */
+			u16 checksum;	/* x1FE */
+		} __attribute__ ((packed)) isp4010;
+		struct {	/* isp4022 */
+			u8 asicId[4];	/* x00 */
+			u8 version;	/* x04 */
+			u8 reserved_5;	/* x05 */
+			u16 boardId;	/* x06 */
+			u8 boardIdStr[16];	/* x08 */
+			u8 serialNumber[16];	/* x18 */
+
+			/* External Hardware Configuration */
+			u16 ext_hw_conf;	/* x28 */
+
+			/* MAC 0 CONFIGURATION */
+			struct eeprom_port_cfg macCfg_port0; /* x2A */
+
+			/* MAC 1 CONFIGURATION */
+			struct eeprom_port_cfg macCfg_port1; /* x4A */
+
+			/* DDR SDRAM Configuration */
+			u16 bufletSize;	/* x6A */
+			u16 bufletCount;	/* x6C */
+			u16 tcpWindowThreshold50; /* x6E */
+			u16 tcpWindowThreshold25; /* x70 */
+			u16 tcpWindowThreshold0; /* x72 */
+			u16 ipHashTableBaseHi;	/* x74 */
+			u16 ipHashTableBaseLo;	/* x76 */
+			u16 ipHashTableSize;	/* x78 */
+			u16 tcpHashTableBaseHi;	/* x7A */
+			u16 tcpHashTableBaseLo;	/* x7C */
+			u16 tcpHashTableSize;	/* x7E */
+			u16 ncbTableBaseHi;	/* x80 */
+			u16 ncbTableBaseLo;	/* x82 */
+			u16 ncbTableSize;	/* x84 */
+			u16 drbTableBaseHi;	/* x86 */
+			u16 drbTableBaseLo;	/* x88 */
+			u16 drbTableSize;	/* x8A */
+			u16 reserved_142[4];	/* x8C */
+
+			/* TCP/IP Parameters */
+			u16 ipReassemblyTimeout; /* x94 */
+			u16 tcpMaxWindowSize;	/* x96 */
+			u16 ipSecurity;	/* x98 */
+			u8 reserved_156[294]; /* x9A */
+			u16 qDebug[8];	/* QLOGIC USE ONLY   x1C0 */
+			struct eeprom_function_cfg funcCfg_fn0;	/* x1D0 */
+			u16 reserved_510; /* x1FE */
+
+			/* Address = 512 */
+			u8 oemSpace[432]; /* x200 */
+			struct bios_params sBIOSParams_fn1; /* x3B0 */
+			struct eeprom_function_cfg funcCfg_fn1;	/* x3D0 */
+			u16 reserved_1022; /* x3FE */
+
+			/* Address = 1024 */
+			u8 reserved_1024[464];	/* x400 */
+			struct eeprom_function_cfg funcCfg_fn2;	/* x5D0 */
+			u16 reserved_1534; /* x5FE */
+
+			/* Address = 1536 */
+			u8 reserved_1536[432];	/* x600 */
+			struct bios_params sBIOSParams_fn3; /* x7B0 */
+			struct eeprom_function_cfg funcCfg_fn3;	/* x7D0 */
+			u16 checksum;	/* x7FE */
+		} __attribute__ ((packed)) isp4022;
+	};
+};
+
+
+#endif	/* _QL4XNVRM_H_ */

