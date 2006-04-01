From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [CMT 12/16] qla4xxx: driver review ql4_nvram.c
Date: Sat, 01 Apr 2006 15:26:20 -0600
Message-ID: <200604012126.k31LQK81024592@falcon30.maxeymade.com>
Reply-To: dwm@maxeymade.com
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:64136 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S932294AbWDAV0d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 16:26:33 -0500
In-reply-to: 200604010418.k314Iqam008288@falcon30.maxeymade.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Only a few missing printk levels.

++doug
--
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
new file mode 100644
index 0000000..e28678d
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -0,0 +1,220 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2006 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
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
+static int
+FM93C56A_Select(scsi_qla_host_t * ha)
+{
+	DEBUG5(printk(KERN_ERR "FM93C56A_Select:\n"));
+
+	ha->eeprom_cmd_data = AUBURN_EEPROM_CS_1 | 0x000f0000;
+	WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data);
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
+	WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1);
+	WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1 |
+	    AUBURN_EEPROM_CLK_RISE);
+	WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1 |
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
+			WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data | dataBit);
+			previousBit = dataBit;
+		}
+		WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data | dataBit |
+		    AUBURN_EEPROM_CLK_RISE);
+		WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data | dataBit |
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
+			WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data | dataBit);
+			previousBit = dataBit;
+		}
+		WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data | dataBit |
+		    AUBURN_EEPROM_CLK_RISE);
+		WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data | dataBit |
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
+	ha->eeprom_cmd_data = AUBURN_EEPROM_CS_0 | 0x000f0000;
+	WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data);
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
+		WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data |
+		    AUBURN_EEPROM_CLK_RISE);
+		WRT_REG_DWORD(ISP_NVRAM(ha), ha->eeprom_cmd_data |
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
+qla4xxx_is_nvram_configuration_valid(scsi_qla_host_t * ha)
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
+	unsigned long flags;
+
+	DEBUG2(printk("scsi%ld : Trying to get SEM lock - mask= 0x%x, code = "
+	    "0x%x\n", ha->host_no, sem_mask, sem_bits));

-EPRINTKMISSINGLEVEL

+	while (1) {
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		WRT_REG_DWORD(ISP_SEMAPHORE(ha), (sem_mask | sem_bits));
+		value = RD_REG_DWORD(ISP_SEMAPHORE(ha));
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		if ((value & (sem_mask >> 16)) == sem_bits) {
+			DEBUG2(printk("scsi%ld : Got SEM LOCK - mask= 0x%x, "
+			    "code = 0x%x\n", ha->host_no, sem_mask, sem_bits));

-EPRINTKMISSINGLEVEL

+			break;
+		}
+		msleep(100);
+	}
+	return 1;
+}
+
+void
+ql4xxx_sem_unlock(scsi_qla_host_t * ha, u32 sem_mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	WRT_REG_DWORD(ISP_SEMAPHORE(ha), sem_mask);
+	PCI_POSTING(ISP_SEMAPHORE(ha));
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	DEBUG2(printk("scsi%ld : UNLOCK SEM - mask= 0x%x\n", ha->host_no,
+	    sem_mask));

-EPRINTKMISSINGLEVEL

+}
+
+int
+ql4xxx_sem_lock(scsi_qla_host_t * ha, u32 sem_mask, u32 sem_bits)
+{
+	uint32_t value;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	WRT_REG_DWORD(ISP_SEMAPHORE(ha), (sem_mask | sem_bits));
+	value = RD_REG_DWORD(ISP_SEMAPHORE(ha));
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if ((value & (sem_mask >> 16)) == sem_bits) {
+		DEBUG2(printk("scsi%ld : Got SEM LOCK - mask= 0x%x, code = "
+		    "0x%x, sema code=0x%x\n", ha->host_no, sem_mask, sem_bits,
+		    value));

-EPRINTKMISSINGLEVEL

+		return 1;
+	}
+	return 0;
+}
