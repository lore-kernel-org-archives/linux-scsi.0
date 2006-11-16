From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: Re: [PATCH] [SCSI] qla4xxx: add support for qla4032
Date: Wed, 15 Nov 2006 17:38:40 -0800
Message-ID: <1163641120.3867.18.camel@dcslnxpc.site>
References: <1163209850.4485.14.camel@dcslnxpc.site>
	 <455A5E06.5000200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:54956 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S1031049AbWKPBij
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Nov 2006 20:38:39 -0500
In-Reply-To: <455A5E06.5000200@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, David Wagner <david.wagner@qlogic.com>

On Tue, 2006-11-14 at 18:23 -0600, Mike Christie wrote:
> David C Somayajulu wrote:
> > The following patch provides the following:
> > 
> > 1. adds support for the next version of Qlogic's iSCSI HBA, qla4032 (PCI Device ID 4032). 
> > 2. removes dead code related to topcat chip and renames qla4010_soft_reset to qla4xxx_soft_reset (minor changes).
> > 
> > 
> 
> This patch adds some trailing whitespaces.
> 
> Adds trailing whitespace.
> .dotest/patch:47:#endif
> Adds trailing whitespace.
> .dotest/patch:51:#endif
> 
> Could you clean that up?
> 
> Also this patch applied with fuzz. Was it made against the current
> upstream qla4xxx code or is this from another kernel?
Here it is with the fixes. 
The patch has been generated with reference to scsi-misc-2.6.git
It also depends on the inclusion of patch titled
[PATCH] [SCSI] qla4xxx: bug fix: driver hardware semaphore needs to be grabbed before soft reset
http://marc.theaimsgroup.com/?l=linux-scsi&m=116363770318846&w=2


Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>

---
 drivers/scsi/qla4xxx/ql4_dbg.c     |    4 +
 drivers/scsi/qla4xxx/ql4_def.h     |  105 ++++++++++++++++++++----------------
 drivers/scsi/qla4xxx/ql4_fw.h      |    7 ++
 drivers/scsi/qla4xxx/ql4_glbl.h    |    2 -
 drivers/scsi/qla4xxx/ql4_init.c    |   45 +++------------
 drivers/scsi/qla4xxx/ql4_inline.h  |    4 +
 drivers/scsi/qla4xxx/ql4_iocb.c    |    6 ++
 drivers/scsi/qla4xxx/ql4_isr.c     |    1 
 drivers/scsi/qla4xxx/ql4_nvram.c   |    6 +-
 drivers/scsi/qla4xxx/ql4_nvram.h   |    4 -
 drivers/scsi/qla4xxx/ql4_os.c      |   75 +++-----------------------
 drivers/scsi/qla4xxx/ql4_version.h |    2 -
 12 files changed, 98 insertions(+), 163 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_dbg.c b/drivers/scsi/qla4xxx/ql4_dbg.c
index 752031f..7b4e077 100644
--- a/drivers/scsi/qla4xxx/ql4_dbg.c
+++ b/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -71,7 +71,7 @@ void __dump_registers(struct scsi_qla_ho
 		       readw(&ha->reg->u1.isp4010.nvram));
 	}
 
-	else if (is_qla4022(ha)) {
+	else if (is_qla4022(ha) | is_qla4032(ha)) {
 		printk(KERN_INFO "0x%02X intr_mask	 = 0x%08X\n",
 		       (uint8_t) offsetof(struct isp_reg,
 					  u1.isp4022.intr_mask),
@@ -119,7 +119,7 @@ void __dump_registers(struct scsi_qla_ho
 		       readw(&ha->reg->u2.isp4010.port_err_status));
 	}
 
-	else if (is_qla4022(ha)) {
+	else if (is_qla4022(ha) | is_qla4032(ha)) {
 		printk(KERN_INFO "Page 0 Registers:\n");
 		printk(KERN_INFO "0x%02X ext_hw_conf	 = 0x%08X\n",
 		       (uint8_t) offsetof(struct isp_reg,
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index a7f6c7b..4249e52 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -40,7 +40,11 @@ #endif
 
 #ifndef PCI_DEVICE_ID_QLOGIC_ISP4022
 #define PCI_DEVICE_ID_QLOGIC_ISP4022	0x4022
-#endif				/*  */
+#endif
+
+#ifndef PCI_DEVICE_ID_QLOGIC_ISP4032
+#define PCI_DEVICE_ID_QLOGIC_ISP4032	0x4032
+#endif
 
 #define QLA_SUCCESS			0
 #define QLA_ERROR			1
@@ -277,7 +281,6 @@ #define AF_MBOX_COMMAND_DONE	      3 /* 
 #define AF_INTERRUPTS_ON	      6 /* 0x00000040 Not Used */
 #define AF_GET_CRASH_RECORD	      7 /* 0x00000080 */
 #define AF_LINK_UP		      8 /* 0x00000100 */
-#define AF_TOPCAT_CHIP_PRESENT	      9 /* 0x00000200 */
 #define AF_IRQ_ATTACHED		     10 /* 0x00000400 */
 #define AF_ISNS_CMD_IN_PROCESS	     12 /* 0x00001000 */
 #define AF_ISNS_CMD_DONE	     13 /* 0x00002000 */
@@ -317,16 +320,17 @@ #define MIN_IOBASE_LEN		0x100
 	/* NVRAM registers */
 	struct eeprom_data *nvram;
 	spinlock_t hardware_lock ____cacheline_aligned;
-	spinlock_t list_lock;
 	uint32_t   eeprom_cmd_data;
 
 	/* Counters for general statistics */
+	uint64_t isr_count;
 	uint64_t adapter_error_count;
 	uint64_t device_error_count;
 	uint64_t total_io_count;
 	uint64_t total_mbytes_xferred;
 	uint64_t link_failure_count;
 	uint64_t invalid_crc_count;
+	uint32_t bytes_xfered;
 	uint32_t spurious_int_count;
 	uint32_t aborted_io_count;
 	uint32_t io_timeout_count;
@@ -438,6 +442,11 @@ static inline int is_qla4022(struct scsi
 	return ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP4022;
 }
 
+static inline int is_qla4032(struct scsi_qla_host *ha)
+{
+	return ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP4032;
+}
+
 static inline int adapter_up(struct scsi_qla_host *ha)
 {
 	return (test_bit(AF_ONLINE, &ha->flags) != 0) &&
@@ -451,58 +460,58 @@ static inline struct scsi_qla_host* to_q
 
 static inline void __iomem* isp_semaphore(struct scsi_qla_host *ha)
 {
-	return (is_qla4022(ha) ?
-		&ha->reg->u1.isp4022.semaphore :
-		&ha->reg->u1.isp4010.nvram);
+	return (is_qla4010(ha) ?
+		&ha->reg->u1.isp4010.nvram :
+		&ha->reg->u1.isp4022.semaphore);
 }
 
 static inline void __iomem* isp_nvram(struct scsi_qla_host *ha)
 {
-	return (is_qla4022(ha) ?
-		&ha->reg->u1.isp4022.nvram :
-		&ha->reg->u1.isp4010.nvram);
+	return (is_qla4010(ha) ?
+		&ha->reg->u1.isp4010.nvram :
+		&ha->reg->u1.isp4022.nvram);
 }
 
 static inline void __iomem* isp_ext_hw_conf(struct scsi_qla_host *ha)
 {
-	return (is_qla4022(ha) ?
-		&ha->reg->u2.isp4022.p0.ext_hw_conf :
-		&ha->reg->u2.isp4010.ext_hw_conf);
+	return (is_qla4010(ha) ?
+		&ha->reg->u2.isp4010.ext_hw_conf :
+		&ha->reg->u2.isp4022.p0.ext_hw_conf);
 }
 
 static inline void __iomem* isp_port_status(struct scsi_qla_host *ha)
 {
-	return (is_qla4022(ha) ?
-		&ha->reg->u2.isp4022.p0.port_status :
-		&ha->reg->u2.isp4010.port_status);
+	return (is_qla4010(ha) ?
+		&ha->reg->u2.isp4010.port_status :
+		&ha->reg->u2.isp4022.p0.port_status);
 }
 
 static inline void __iomem* isp_port_ctrl(struct scsi_qla_host *ha)
 {
-	return (is_qla4022(ha) ?
-		&ha->reg->u2.isp4022.p0.port_ctrl :
-		&ha->reg->u2.isp4010.port_ctrl);
+	return (is_qla4010(ha) ?
+		&ha->reg->u2.isp4010.port_ctrl :
+		&ha->reg->u2.isp4022.p0.port_ctrl);
 }
 
 static inline void __iomem* isp_port_error_status(struct scsi_qla_host *ha)
 {
-	return (is_qla4022(ha) ?
-		&ha->reg->u2.isp4022.p0.port_err_status :
-		&ha->reg->u2.isp4010.port_err_status);
+	return (is_qla4010(ha) ?
+		&ha->reg->u2.isp4010.port_err_status :
+		&ha->reg->u2.isp4022.p0.port_err_status);
 }
 
 static inline void __iomem * isp_gp_out(struct scsi_qla_host *ha)
 {
-	return (is_qla4022(ha) ?
-		&ha->reg->u2.isp4022.p0.gp_out :
-		&ha->reg->u2.isp4010.gp_out);
+	return (is_qla4010(ha) ?
+		&ha->reg->u2.isp4010.gp_out :
+		&ha->reg->u2.isp4022.p0.gp_out);
 }
 
 static inline int eeprom_ext_hw_conf_offset(struct scsi_qla_host *ha)
 {
-	return (is_qla4022(ha) ?
-		offsetof(struct eeprom_data, isp4022.ext_hw_conf) / 2 :
-		offsetof(struct eeprom_data, isp4010.ext_hw_conf) / 2);
+	return (is_qla4010(ha) ?
+		offsetof(struct eeprom_data, isp4010.ext_hw_conf) / 2 :
+		offsetof(struct eeprom_data, isp4022.ext_hw_conf) / 2);
 }
 
 int ql4xxx_sem_spinlock(struct scsi_qla_host * ha, u32 sem_mask, u32 sem_bits);
@@ -511,59 +520,59 @@ int ql4xxx_sem_lock(struct scsi_qla_host
 
 static inline int ql4xxx_lock_flash(struct scsi_qla_host *a)
 {
-	if (is_qla4022(a))
+	if (is_qla4010(a))
+		return ql4xxx_sem_spinlock(a, QL4010_FLASH_SEM_MASK,
+					   QL4010_FLASH_SEM_BITS);
+	else
 		return ql4xxx_sem_spinlock(a, QL4022_FLASH_SEM_MASK,
 					   (QL4022_RESOURCE_BITS_BASE_CODE |
 					    (a->mac_index)) << 13);
-	else
-		return ql4xxx_sem_spinlock(a, QL4010_FLASH_SEM_MASK,
-					   QL4010_FLASH_SEM_BITS);
 }
 
 static inline void ql4xxx_unlock_flash(struct scsi_qla_host *a)
 {
-	if (is_qla4022(a))
-		ql4xxx_sem_unlock(a, QL4022_FLASH_SEM_MASK);
-	else
+	if (is_qla4010(a))
 		ql4xxx_sem_unlock(a, QL4010_FLASH_SEM_MASK);
+	else
+		ql4xxx_sem_unlock(a, QL4022_FLASH_SEM_MASK);
 }
 
 static inline int ql4xxx_lock_nvram(struct scsi_qla_host *a)
 {
-	if (is_qla4022(a))
+	if (is_qla4010(a))
+		return ql4xxx_sem_spinlock(a, QL4010_NVRAM_SEM_MASK,
+					   QL4010_NVRAM_SEM_BITS);
+	else
 		return ql4xxx_sem_spinlock(a, QL4022_NVRAM_SEM_MASK,
 					   (QL4022_RESOURCE_BITS_BASE_CODE |
 					    (a->mac_index)) << 10);
-	else
-		return ql4xxx_sem_spinlock(a, QL4010_NVRAM_SEM_MASK,
-					   QL4010_NVRAM_SEM_BITS);
 }
 
 static inline void ql4xxx_unlock_nvram(struct scsi_qla_host *a)
 {
-	if (is_qla4022(a))
-		ql4xxx_sem_unlock(a, QL4022_NVRAM_SEM_MASK);
-	else
+	if (is_qla4010(a))
 		ql4xxx_sem_unlock(a, QL4010_NVRAM_SEM_MASK);
+	else
+		ql4xxx_sem_unlock(a, QL4022_NVRAM_SEM_MASK);
 }
 
 static inline int ql4xxx_lock_drvr(struct scsi_qla_host *a)
 {
-	if (is_qla4022(a))
+	if (is_qla4010(a))
+		return ql4xxx_sem_lock(a, QL4010_DRVR_SEM_MASK,
+				       QL4010_DRVR_SEM_BITS);
+	else
 		return ql4xxx_sem_lock(a, QL4022_DRVR_SEM_MASK,
 				       (QL4022_RESOURCE_BITS_BASE_CODE |
 					(a->mac_index)) << 1);
-	else
-		return ql4xxx_sem_lock(a, QL4010_DRVR_SEM_MASK,
-				       QL4010_DRVR_SEM_BITS);
 }
 
 static inline void ql4xxx_unlock_drvr(struct scsi_qla_host *a)
 {
-	if (is_qla4022(a))
-		ql4xxx_sem_unlock(a, QL4022_DRVR_SEM_MASK);
-	else
+	if (is_qla4010(a))
 		ql4xxx_sem_unlock(a, QL4010_DRVR_SEM_MASK);
+	else
+		ql4xxx_sem_unlock(a, QL4022_DRVR_SEM_MASK);
 }
 
 /*---------------------------------------------------------------------------*/
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 427489d..4eea8c5 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -296,7 +296,6 @@ #define NVR_WRITE_ENABLE			0x00000010	/*
 /*  ISP Semaphore definitions */
 
 /*  ISP General Purpose Output definitions */
-#define GPOR_TOPCAT_RESET			0x00000004
 
 /*  shadow registers (DMA'd from HA to system memory.  read only) */
 struct shadow_regs {
@@ -339,10 +338,13 @@ union external_hw_config_reg {
 /*  Mailbox command definitions */
 #define MBOX_CMD_ABOUT_FW			0x0009
 #define MBOX_CMD_LUN_RESET			0x0016
+#define MBOX_CMD_GET_MANAGEMENT_DATA		0x001E
 #define MBOX_CMD_GET_FW_STATUS			0x001F
 #define MBOX_CMD_SET_ISNS_SERVICE		0x0021
 #define ISNS_DISABLE				0
 #define ISNS_ENABLE				1
+#define MBOX_CMD_COPY_FLASH			0x0024
+#define MBOX_CMD_WRITE_FLASH			0x0025
 #define MBOX_CMD_READ_FLASH			0x0026
 #define MBOX_CMD_CLEAR_DATABASE_ENTRY		0x0031
 #define MBOX_CMD_CONN_CLOSE_SESS_LOGOUT		0x0056
@@ -360,10 +362,13 @@ #define DDB_DS_SESSION_ACTIVE			0x04
 #define DDB_DS_SESSION_FAILED			0x06
 #define DDB_DS_LOGIN_IN_PROCESS			0x07
 #define MBOX_CMD_GET_FW_STATE			0x0069
+#define MBOX_CMD_GET_INIT_FW_CTRL_BLOCK_DEFAULTS 0x006A
+#define MBOX_CMD_RESTORE_FACTORY_DEFAULTS	0x0087
 
 /* Mailbox 1 */
 #define FW_STATE_READY				0x0000
 #define FW_STATE_CONFIG_WAIT			0x0001
+#define FW_STATE_WAIT_LOGIN			0x0002
 #define FW_STATE_ERROR				0x0004
 #define FW_STATE_DHCP_IN_PROGRESS		0x0008
 
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 79661c1..6be6b41 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -76,4 +76,4 @@ int qla4xxx_process_ddb_changed(struct s
 extern int qla4_extended_error_logging;
 extern int ql4xdiscoverywait;
 extern int ql4xdontresethba;
-#endif				/* _QLA4x_GBL_H */
+#endif /* _QLA4x_GBL_H */
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 9e81b81..cc210f2 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -259,10 +259,16 @@ static int qla4xxx_fw_ready(struct scsi_
 			      "seconds expired= %d\n", ha->host_no, __func__,
 			      ha->firmware_state, ha->addl_fw_state,
 			      timeout_count));
+		if (is_qla4032(ha) &&
+			!(ha->addl_fw_state & FW_ADDSTATE_LINK_UP) &&
+			(timeout_count < ADAPTER_INIT_TOV - 5)) {
+			break;
+		}
+
 		msleep(1000);
 	}			/* end of for */
 
-	if (timeout_count <= 0)
+	if (timeout_count == 0)
 		DEBUG2(printk("scsi%ld: %s: FW Initialization timed out!\n",
 			      ha->host_no, __func__));
 
@@ -806,32 +812,6 @@ int qla4xxx_relogin_device(struct scsi_q
 	return QLA_SUCCESS;
 }
 
-/**
- * qla4010_get_topcat_presence - check if it is QLA4040 TopCat Chip
- * @ha: Pointer to host adapter structure.
- *
- **/
-static int qla4010_get_topcat_presence(struct scsi_qla_host *ha)
-{
-	unsigned long flags;
-	uint16_t topcat;
-
-	if (ql4xxx_lock_nvram(ha) != QLA_SUCCESS)
-		return QLA_ERROR;
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	topcat = rd_nvram_word(ha, offsetof(struct eeprom_data,
-					    isp4010.topcat));
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	if ((topcat & TOPCAT_MASK) == TOPCAT_PRESENT)
-		set_bit(AF_TOPCAT_CHIP_PRESENT, &ha->flags);
-	else
-		clear_bit(AF_TOPCAT_CHIP_PRESENT, &ha->flags);
-	ql4xxx_unlock_nvram(ha);
-	return QLA_SUCCESS;
-}
-
-
 static int qla4xxx_config_nvram(struct scsi_qla_host *ha)
 {
 	unsigned long flags;
@@ -866,7 +846,7 @@ static int qla4xxx_config_nvram(struct s
 		/* set defaults */
 		if (is_qla4010(ha))
 			extHwConfig.Asuint32_t = 0x1912;
-		else if (is_qla4022(ha))
+		else if (is_qla4022(ha) | is_qla4032(ha))
 			extHwConfig.Asuint32_t = 0x0023;
 	}
 	DEBUG(printk("scsi%ld: %s: Setting extHwConfig to 0xFFFF%04x\n",
@@ -927,7 +907,7 @@ static int qla4xxx_start_firmware_from_f
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	writel(jiffies, &ha->reg->mailbox[7]);
-	if (is_qla4022(ha))
+	if (is_qla4022(ha) | is_qla4032(ha))
 		writel(set_rmask(NVR_WRITE_ENABLE),
 		       &ha->reg->u1.isp4022.nvram);
 
@@ -1018,12 +998,7 @@ static int qla4xxx_start_firmware(struct
 	int soft_reset = 1;
 	int config_chip = 0;
 
-	if (is_qla4010(ha)){
-		if (qla4010_get_topcat_presence(ha) != QLA_SUCCESS)
-			return QLA_ERROR;
-	}
-
-	if (is_qla4022(ha))
+	if (is_qla4022(ha) | is_qla4032(ha))
 		ql4xxx_set_mac_number(ha);
 
 	if (ql4xxx_lock_drvr_wait(ha) != QLA_SUCCESS)
diff --git a/drivers/scsi/qla4xxx/ql4_inline.h b/drivers/scsi/qla4xxx/ql4_inline.h
index 0d61797..6375eb0 100644
--- a/drivers/scsi/qla4xxx/ql4_inline.h
+++ b/drivers/scsi/qla4xxx/ql4_inline.h
@@ -38,7 +38,7 @@ qla4xxx_lookup_ddb_by_fw_index(struct sc
 static inline void
 __qla4xxx_enable_intrs(struct scsi_qla_host *ha)
 {
-	if (is_qla4022(ha)) {
+	if (is_qla4022(ha) | is_qla4032(ha)) {
 		writel(set_rmask(IMR_SCSI_INTR_ENABLE),
 		       &ha->reg->u1.isp4022.intr_mask);
 		readl(&ha->reg->u1.isp4022.intr_mask);
@@ -52,7 +52,7 @@ __qla4xxx_enable_intrs(struct scsi_qla_h
 static inline void
 __qla4xxx_disable_intrs(struct scsi_qla_host *ha)
 {
-	if (is_qla4022(ha)) {
+	if (is_qla4022(ha) | is_qla4032(ha)) {
 		writel(clr_rmask(IMR_SCSI_INTR_ENABLE),
 		       &ha->reg->u1.isp4022.intr_mask);
 		readl(&ha->reg->u1.isp4022.intr_mask);
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index c0a254b..d41ce38 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -294,6 +294,12 @@ int qla4xxx_send_command_to_isp(struct s
 			cmd_entry->control_flags = CF_WRITE;
 		else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
 			cmd_entry->control_flags = CF_READ;
+
+		ha->bytes_xfered += cmd->request_bufflen;
+		if (ha->bytes_xfered & ~0xFFFFF){
+			ha->total_mbytes_xferred += ha->bytes_xfered >> 20;
+			ha->bytes_xfered &= 0xFFFFF;
+		}
 	}
 
 	/* Set tagged queueing control flags */
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 1e28332..ef975e0 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -627,6 +627,7 @@ irqreturn_t qla4xxx_intr_handler(int irq
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
+	ha->isr_count++;
 	/*
 	 * Repeatedly service interrupts up to a maximum of
 	 * MAX_REQS_SERVICED_PER_INTR
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
index e3957ca..fc50203 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.c
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -9,13 +9,13 @@ #include "ql4_def.h"
 
 static inline int eeprom_size(struct scsi_qla_host *ha)
 {
-	return is_qla4022(ha) ? FM93C86A_SIZE_16 : FM93C66A_SIZE_16;
+	return is_qla4010(ha) ? FM93C66A_SIZE_16 : FM93C86A_SIZE_16;
 }
 
 static inline int eeprom_no_addr_bits(struct scsi_qla_host *ha)
 {
-	return is_qla4022(ha) ? FM93C86A_NO_ADDR_BITS_16 :
-		FM93C56A_NO_ADDR_BITS_16;
+	return is_qla4010(ha) ? FM93C56A_NO_ADDR_BITS_16 :
+		FM93C86A_NO_ADDR_BITS_16 ;
 }
 
 static inline int eeprom_no_data_bits(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.h b/drivers/scsi/qla4xxx/ql4_nvram.h
index 08e2aed..b47b4fc 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.h
+++ b/drivers/scsi/qla4xxx/ql4_nvram.h
@@ -134,9 +134,7 @@ #define	 MAC_CONFIG_ENABLE_PAUSE    0x00
 			u16 phyConfig;	/* x36 */
 #define	 PHY_CONFIG_PHY_ADDR_MASK	      0x1f
 #define	 PHY_CONFIG_ENABLE_FW_MANAGEMENT_MASK 0x20
-			u16 topcat;	/* x38 */
-#define TOPCAT_PRESENT		0x0100
-#define TOPCAT_MASK		0xFF00
+			u16 reserved_56;	/* x38 */
 
 #define EEPROM_UNUSED_1_SIZE   2
 			u8 unused_1[EEPROM_UNUSED_1_SIZE]; /* x3A */
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 61f61d5..a1ba3a1 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -708,10 +708,10 @@ static int qla4xxx_cmd_wait(struct scsi_
 }
 
 /**
- * qla4010_soft_reset - performs soft reset.
+ * qla4xxx_soft_reset - performs soft reset.
  * @ha: Pointer to host adapter structure.
  **/
-static int qla4010_soft_reset(struct scsi_qla_host *ha)
+int qla4xxx_soft_reset(struct scsi_qla_host *ha)
 {
 	uint32_t max_wait_time;
 	unsigned long flags = 0;
@@ -817,29 +817,6 @@ static int qla4010_soft_reset(struct scs
 }
 
 /**
- * qla4xxx_topcat_reset - performs hard reset of TopCat Chip.
- * @ha: Pointer to host adapter structure.
- **/
-static int qla4xxx_topcat_reset(struct scsi_qla_host *ha)
-{
-	unsigned long flags;
-
-	ql4xxx_lock_nvram(ha);
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	writel(set_rmask(GPOR_TOPCAT_RESET), isp_gp_out(ha));
-	readl(isp_gp_out(ha));
-	mdelay(1);
-
-	writel(clr_rmask(GPOR_TOPCAT_RESET), isp_gp_out(ha));
-	readl(isp_gp_out(ha));
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	mdelay(2523);
-
-	ql4xxx_unlock_nvram(ha);
-	return QLA_SUCCESS;
-}
-
-/**
  * qla4xxx_flush_active_srbs - returns all outstanding i/o requests to O.S.
  * @ha: Pointer to host adapter structure.
  *
@@ -867,26 +844,6 @@ static void qla4xxx_flush_active_srbs(st
 }
 
 /**
- * qla4xxx_hard_reset - performs HBA Hard Reset
- * @ha: Pointer to host adapter structure.
- **/
-static int qla4xxx_hard_reset(struct scsi_qla_host *ha)
-{
-	/* The QLA4010 really doesn't have an equivalent to a hard reset */
-	qla4xxx_flush_active_srbs(ha);
-	if (test_bit(AF_TOPCAT_CHIP_PRESENT, &ha->flags)) {
-		int status = QLA_ERROR;
-
-		if ((qla4010_soft_reset(ha) == QLA_SUCCESS) &&
-		    (qla4xxx_topcat_reset(ha) == QLA_SUCCESS) &&
-		    (qla4010_soft_reset(ha) == QLA_SUCCESS))
-			status = QLA_SUCCESS;
-		return status;
-	} else
-		return qla4010_soft_reset(ha);
-}
-
-/**
  * qla4xxx_recover_adapter - recovers adapter after a fatal error
  * @ha: Pointer to host adapter structure.
  * @renew_ddb_list: Indicates what to do with the adapter's ddb list
@@ -1243,7 +1200,6 @@ static int __devinit qla4xxx_probe_adapt
 	init_waitqueue_head(&ha->mailbox_wait_queue);
 
 	spin_lock_init(&ha->hardware_lock);
-	spin_lock_init(&ha->list_lock);
 
 	/* Allocate dma buffers */
 	if (qla4xxx_mem_alloc(ha)) {
@@ -1450,27 +1406,6 @@ struct srb * qla4xxx_del_from_active_arr
 }
 
 /**
- * qla4xxx_soft_reset - performs a SOFT RESET of hba.
- * @ha: Pointer to host adapter structure.
- **/
-int qla4xxx_soft_reset(struct scsi_qla_host *ha)
-{
-
-	DEBUG2(printk(KERN_WARNING "scsi%ld: %s: chip reset!\n", ha->host_no,
-		      __func__));
-	if (test_bit(AF_TOPCAT_CHIP_PRESENT, &ha->flags)) {
-		int status = QLA_ERROR;
-
-		if ((qla4010_soft_reset(ha) == QLA_SUCCESS) &&
-		    (qla4xxx_topcat_reset(ha) == QLA_SUCCESS) &&
-		    (qla4010_soft_reset(ha) == QLA_SUCCESS) )
-			status = QLA_SUCCESS;
-		return status;
-	} else
-		return qla4010_soft_reset(ha);
-}
-
-/**
  * qla4xxx_eh_wait_on_command - waits for command to be returned by firmware
  * @ha: actual ha whose done queue will contain the comd returned by firmware.
  * @cmd: Scsi Command to wait on.
@@ -1668,6 +1603,12 @@ static struct pci_device_id qla4xxx_pci_
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP4032,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
 	{0, 0},
 };
 MODULE_DEVICE_TABLE(pci, qla4xxx_pci_tbl);
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index d05048b..454e19c 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.00.06-k"
+#define QLA4XXX_DRIVER_VERSION	"5.00.07-k"
-- 
1.4.2.3



