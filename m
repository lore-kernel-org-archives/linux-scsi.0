From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/11]  qla2xxx: Add ISP24xx flash-manipulation routines.
Date: Mon, 13 Jun 2005 22:32:01 -0700 (PDT)
Message-ID: <20050614053201.12127.93448.sendpatchset@plap.qlogic.com>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:44950 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261202AbVFNFcC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 01:32:02 -0400
In-Reply-To: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add ISP24xx flash-manipulation routines.

Add read/write flash manipulation routines for the ISP24xx.
Update sysfs NVRAM objects to use generalized accessor
functions.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_attr.c |   59 ++--
 drivers/scsi/qla2xxx/qla_gbl.h  |    7 +
 drivers/scsi/qla2xxx/qla_sup.c  |  534 +++++++++++++++++++++++++++++++++++----
 3 files changed, 519 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -121,23 +121,15 @@ qla2x00_sysfs_read_nvram(struct kobject 
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	uint16_t	*witer;
 	unsigned long	flags;
-	uint16_t	cnt;
 
-	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != sizeof(nvram_t))
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size)
 		return 0;
 
 	/* Read NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	qla2x00_lock_nvram_access(ha);
- 	witer = (uint16_t *)buf;
- 	for (cnt = 0; cnt < count / 2; cnt++) {
-		*witer = cpu_to_le16(qla2x00_get_nvram_word(ha,
-		    cnt+ha->nvram_base));
-		witer++;
- 	}
-	qla2x00_unlock_nvram_access(ha);
+	qla2x00_read_nvram_data(ha, (uint8_t *)buf, ha->nvram_base,
+	    ha->nvram_size);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return (count);
@@ -149,34 +141,38 @@ qla2x00_sysfs_write_nvram(struct kobject
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	uint8_t		*iter;
-	uint16_t	*witer;
 	unsigned long	flags;
 	uint16_t	cnt;
-	uint8_t		chksum;
 
-	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != sizeof(nvram_t))
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size)
 		return 0;
 
 	/* Checksum NVRAM. */
-	iter = (uint8_t *)buf;
-	chksum = 0;
-	for (cnt = 0; cnt < count - 1; cnt++)
-		chksum += *iter++;
-	chksum = ~chksum + 1;
-	*iter = chksum;
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		uint32_t *iter;
+		uint32_t chksum;
+
+		iter = (uint32_t *)buf;
+		chksum = 0;
+		for (cnt = 0; cnt < ((count >> 2) - 1); cnt++)
+			chksum += le32_to_cpu(*iter++);
+		chksum = ~chksum + 1;
+		*iter = cpu_to_le32(chksum);
+	} else {
+		uint8_t *iter;
+		uint8_t chksum;
+
+		iter = (uint8_t *)buf;
+		chksum = 0;
+		for (cnt = 0; cnt < count - 1; cnt++)
+			chksum += *iter++;
+		chksum = ~chksum + 1;
+		*iter = chksum;
+	}
 
 	/* Write NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	qla2x00_lock_nvram_access(ha);
-	qla2x00_release_nvram_protection(ha);
- 	witer = (uint16_t *)buf;
-	for (cnt = 0; cnt < count / 2; cnt++) {
-		qla2x00_write_nvram_word(ha, cnt+ha->nvram_base,
-		    cpu_to_le16(*witer));
-		witer++;
-	}
-	qla2x00_unlock_nvram_access(ha);
+	qla2x00_write_nvram_data(ha, (uint8_t *)buf, ha->nvram_base, count);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return (count);
@@ -188,7 +184,7 @@ static struct bin_attribute sysfs_nvram_
 		.mode = S_IRUSR | S_IWUSR,
 		.owner = THIS_MODULE,
 	},
-	.size = sizeof(nvram_t),
+	.size = 0;
 	.read = qla2x00_sysfs_read_nvram,
 	.write = qla2x00_sysfs_write_nvram,
 };
@@ -199,6 +195,7 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t
 	struct Scsi_Host *host = ha->host;
 
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
+	sysfs_nvram_attr.size = ha->nvram_size;
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -202,6 +202,13 @@ extern void qla2x00_unlock_nvram_access(
 extern void qla2x00_release_nvram_protection(scsi_qla_host_t *);
 extern uint16_t qla2x00_get_nvram_word(scsi_qla_host_t *, uint32_t);
 extern void qla2x00_write_nvram_word(scsi_qla_host_t *, uint32_t, uint16_t);
+extern uint8_t *qla2x00_read_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
+    uint32_t);
+extern int qla2x00_write_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
+    uint32_t);
+extern uint32_t *qla24xx_read_flash_data(scsi_qla_host_t *, uint32_t *,
+    uint32_t, uint32_t);
+
 /*
  * Global Function Prototypes in qla_dbg.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -79,56 +79,6 @@ qla2x00_unlock_nvram_access(scsi_qla_hos
 }
 
 /**
- * qla2x00_release_nvram_protection() - 
- * @ha: HA context
- */
-void
-qla2x00_release_nvram_protection(scsi_qla_host_t *ha)
-{
-	device_reg_t __iomem *reg;
-	uint32_t word;
-
-	reg = ha->iobase;
-
-	/* Release NVRAM write protection. */
-	if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
-		/* Write enable. */
-		qla2x00_nv_write(ha, NVR_DATA_OUT);
-		qla2x00_nv_write(ha, 0);
-		qla2x00_nv_write(ha, 0);
-		for (word = 0; word < 8; word++)
-			qla2x00_nv_write(ha, NVR_DATA_OUT);
-
-		qla2x00_nv_deselect(ha);
-
-		/* Enable protection register. */
-		qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
-		qla2x00_nv_write(ha, NVR_PR_ENABLE);
-		qla2x00_nv_write(ha, NVR_PR_ENABLE);
-		for (word = 0; word < 8; word++)
-			qla2x00_nv_write(ha, NVR_DATA_OUT | NVR_PR_ENABLE);
-
-		qla2x00_nv_deselect(ha);
-
-		/* Clear protection register (ffff is cleared). */
-		qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
-		qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
-		qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
-		for (word = 0; word < 8; word++)
-			qla2x00_nv_write(ha, NVR_DATA_OUT | NVR_PR_ENABLE);
-
-		qla2x00_nv_deselect(ha);
-
-		/* Wait for NVRAM to become ready. */
-		WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-		do {
-			NVRAM_DELAY();
-			word = RD_REG_WORD(&reg->nvram);
-		} while ((word & NVR_DATA_IN) == 0);
-	}
-}
-
-/**
  * qla2x00_get_nvram_word() - Calculates word position in NVRAM and calls the
  *	request routine to get the word from NVRAM.
  * @ha: HA context
@@ -204,6 +154,64 @@ qla2x00_write_nvram_word(scsi_qla_host_t
 	qla2x00_nv_deselect(ha);
 }
 
+static int
+qla2x00_write_nvram_word_tmo(scsi_qla_host_t *ha, uint32_t addr, uint16_t data,
+    uint32_t tmo)
+{
+	int ret, count;
+	uint16_t word;
+	uint32_t nv_cmd;
+	device_reg_t __iomem *reg = ha->iobase;
+
+	ret = QLA_SUCCESS;
+
+	qla2x00_nv_write(ha, NVR_DATA_OUT);
+	qla2x00_nv_write(ha, 0);
+	qla2x00_nv_write(ha, 0);
+
+	for (word = 0; word < 8; word++)
+		qla2x00_nv_write(ha, NVR_DATA_OUT);
+
+	qla2x00_nv_deselect(ha);
+
+	/* Write data */
+	nv_cmd = (addr << 16) | NV_WRITE_OP;
+	nv_cmd |= data;
+	nv_cmd <<= 5;
+	for (count = 0; count < 27; count++) {
+		if (nv_cmd & BIT_31)
+			qla2x00_nv_write(ha, NVR_DATA_OUT);
+		else
+			qla2x00_nv_write(ha, 0);
+
+		nv_cmd <<= 1;
+	}
+
+	qla2x00_nv_deselect(ha);
+
+	/* Wait for NVRAM to become ready */
+	WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+	do {
+		NVRAM_DELAY();
+		word = RD_REG_WORD(&reg->nvram);
+		if (!--tmo) {
+			ret = QLA_FUNCTION_FAILED;
+			break;
+		}
+	} while ((word & NVR_DATA_IN) == 0);
+
+	qla2x00_nv_deselect(ha);
+
+	/* Disable writes */
+	qla2x00_nv_write(ha, NVR_DATA_OUT);
+	for (count = 0; count < 10; count++)
+		qla2x00_nv_write(ha, 0);
+
+	qla2x00_nv_deselect(ha);
+
+	return ret;
+}
+
 /**
  * qla2x00_nvram_request() - Sends read command to NVRAM and gets data from
  *	NVRAM.
@@ -294,3 +302,429 @@ qla2x00_nv_write(scsi_qla_host_t *ha, ui
 	NVRAM_DELAY();
 }
 
+/**
+ * qla2x00_clear_nvram_protection() -
+ * @ha: HA context
+ */
+static int
+qla2x00_clear_nvram_protection(scsi_qla_host_t *ha)
+{
+	int ret, stat;
+	device_reg_t *reg;
+	uint32_t word;
+	uint16_t wprot, wprot_old;
+
+	reg = ha->iobase;
+
+	/* Clear NVRAM write protection. */
+	ret = QLA_FUNCTION_FAILED;
+	wprot_old = cpu_to_le16(qla2x00_get_nvram_word(ha, 0));
+	stat = qla2x00_write_nvram_word_tmo(ha, 0,
+	    __constant_cpu_to_le16(0x1234), 100000);
+	wprot = cpu_to_le16(qla2x00_get_nvram_word(ha, 0));
+	if (stat != QLA_SUCCESS || wprot != __constant_cpu_to_le16(0x1234)) {
+		/* Write enable. */
+		qla2x00_nv_write(ha, NVR_DATA_OUT);
+		qla2x00_nv_write(ha, 0);
+		qla2x00_nv_write(ha, 0);
+		for (word = 0; word < 8; word++)
+			qla2x00_nv_write(ha, NVR_DATA_OUT);
+
+		qla2x00_nv_deselect(ha);
+
+		/* Enable protection register. */
+		qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
+		qla2x00_nv_write(ha, NVR_PR_ENABLE);
+		qla2x00_nv_write(ha, NVR_PR_ENABLE);
+		for (word = 0; word < 8; word++)
+			qla2x00_nv_write(ha, NVR_DATA_OUT | NVR_PR_ENABLE);
+
+		qla2x00_nv_deselect(ha);
+
+		/* Clear protection register (ffff is cleared). */
+		qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
+		qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
+		qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
+		for (word = 0; word < 8; word++)
+			qla2x00_nv_write(ha, NVR_DATA_OUT | NVR_PR_ENABLE);
+
+		qla2x00_nv_deselect(ha);
+
+		/* Wait for NVRAM to become ready. */
+		WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+		do {
+			NVRAM_DELAY();
+			word = RD_REG_WORD(&reg->nvram);
+		} while ((word & NVR_DATA_IN) == 0);
+
+		ret = QLA_SUCCESS;
+	} else
+		qla2x00_write_nvram_word(ha, 0, wprot_old);
+
+	return ret;
+}
+
+static void
+qla2x00_set_nvram_protection(scsi_qla_host_t *ha, int stat)
+{
+	device_reg_t *reg;
+	uint32_t word;
+	reg = ha->iobase;
+
+	if (stat != QLA_SUCCESS)
+		return;
+
+	/* Set NVRAM write protection. */
+	/* Write enable. */
+	qla2x00_nv_write(ha, NVR_DATA_OUT);
+	qla2x00_nv_write(ha, 0);
+	qla2x00_nv_write(ha, 0);
+	for (word = 0; word < 8; word++)
+		qla2x00_nv_write(ha, NVR_DATA_OUT);
+
+	qla2x00_nv_deselect(ha);
+
+	/* Enable protection register. */
+	qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
+	qla2x00_nv_write(ha, NVR_PR_ENABLE);
+	qla2x00_nv_write(ha, NVR_PR_ENABLE);
+	for (word = 0; word < 8; word++)
+		qla2x00_nv_write(ha, NVR_DATA_OUT | NVR_PR_ENABLE);
+
+	qla2x00_nv_deselect(ha);
+
+	/* Enable protection register. */
+	qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
+	qla2x00_nv_write(ha, NVR_PR_ENABLE);
+	qla2x00_nv_write(ha, NVR_PR_ENABLE | NVR_DATA_OUT);
+	for (word = 0; word < 8; word++)
+		qla2x00_nv_write(ha, NVR_PR_ENABLE);
+
+	qla2x00_nv_deselect(ha);
+
+	/* Wait for NVRAM to become ready. */
+	WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+	do {
+		NVRAM_DELAY();
+		word = RD_REG_WORD(&reg->nvram);
+	} while ((word & NVR_DATA_IN) == 0);
+}
+
+
+/*****************************************************************************/
+/* Flash Manipulation Routines                                               */
+/*****************************************************************************/
+
+static inline uint32_t
+flash_conf_to_access_addr(uint32_t faddr)
+{
+	return FARX_ACCESS_FLASH_CONF | faddr;
+}
+
+static inline uint32_t
+flash_data_to_access_addr(uint32_t faddr)
+{
+	return FARX_ACCESS_FLASH_DATA | faddr;
+}
+
+static inline uint32_t
+nvram_conf_to_access_addr(uint32_t naddr)
+{
+	return FARX_ACCESS_NVRAM_CONF | naddr;
+}
+
+static inline uint32_t
+nvram_data_to_access_addr(uint32_t naddr)
+{
+	return FARX_ACCESS_NVRAM_DATA | naddr;
+}
+
+uint32_t
+qla24xx_read_flash_dword(scsi_qla_host_t *ha, uint32_t addr)
+{
+	int rval;
+	uint32_t cnt, data;
+	struct device_reg_24xx *reg;
+
+	reg = (struct device_reg_24xx __iomem *)ha->iobase;
+	WRT_REG_DWORD(&reg->flash_addr, addr & ~FARX_DATA_FLAG);
+	/* Wait for READ cycle to complete. */
+	rval = QLA_SUCCESS;
+	for (cnt = 3000;
+	    (RD_REG_DWORD(&reg->flash_addr) & FARX_DATA_FLAG) == 0 &&
+	    rval == QLA_SUCCESS; cnt--) {
+		if (cnt)
+			udelay(10);
+		else
+			rval = QLA_FUNCTION_TIMEOUT;
+	}
+
+	/* TODO: What happens if we time out? */
+	data = 0xDEADDEAD;
+	if (rval == QLA_SUCCESS)
+		data = RD_REG_DWORD(&reg->flash_data);
+
+	return data;
+}
+
+uint32_t *
+qla24xx_read_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
+    uint32_t dwords)
+{
+	uint32_t i;
+	struct device_reg_24xx *reg =
+	    (struct device_reg_24xx __iomem *)ha->iobase;
+
+	/* Pause RISC. */
+	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
+	RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
+
+	/* Dword reads to flash. */
+	for (i = 0; i < dwords; i++, faddr++)
+		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
+		    flash_data_to_access_addr(faddr)));
+
+	/* Release RISC pause. */
+	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
+	RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
+
+	return dwptr;
+}
+
+uint8_t *
+qla2x00_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+    uint32_t bytes)
+{
+	uint32_t i;
+	uint16_t *wptr;
+	uint32_t *dwptr;
+
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		struct device_reg_24xx *reg =
+		    (struct device_reg_24xx __iomem *)ha->iobase;
+
+		/* Pause RISC. */
+		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
+		RD_REG_DWORD(&reg->hccr);	/* PCI Posting. */
+
+		/* Dword reads to flash. */
+		dwptr = (uint32_t *)buf;
+		for (i = 0; i < bytes >> 2; i++, naddr++)
+			dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
+			    nvram_data_to_access_addr(naddr)));
+
+		/* Release RISC pause. */
+		WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
+		RD_REG_DWORD(&reg->hccr);	/* PCI Posting. */
+	} else {
+		/* Word reads to NVRAM via registers. */
+		wptr = (uint16_t *)buf;
+		qla2x00_lock_nvram_access(ha);
+		for (i = 0; i < bytes >> 1; i++, naddr++)
+			wptr[i] = cpu_to_le16(qla2x00_get_nvram_word(ha,
+			    naddr));
+		qla2x00_unlock_nvram_access(ha);
+	}
+	return buf;
+}
+
+int
+qla24xx_write_flash_dword(scsi_qla_host_t *ha, uint32_t addr, uint32_t data)
+{
+	int rval;
+	uint32_t cnt;
+	struct device_reg_24xx *reg =
+	    (struct device_reg_24xx __iomem *)ha->iobase;
+
+	WRT_REG_DWORD(&reg->flash_data, data);
+	RD_REG_DWORD(&reg->flash_data);		/* PCI Posting. */
+	WRT_REG_DWORD(&reg->flash_addr, addr | FARX_DATA_FLAG);
+	/* Wait for Write cycle to complete. */
+	rval = QLA_SUCCESS;
+	for (cnt = 500000; (RD_REG_DWORD(&reg->flash_addr) & FARX_DATA_FLAG) &&
+	    rval == QLA_SUCCESS; cnt--) {
+		if (cnt)
+			udelay(10);
+		else
+			rval = QLA_FUNCTION_TIMEOUT;
+	}
+	return rval;
+}
+
+void
+qla24xx_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
+    uint8_t *flash_id)
+{
+	uint32_t ids;
+
+	ids = qla24xx_read_flash_dword(ha, flash_data_to_access_addr(0xd03ab));
+	*man_id = LSB(ids);
+	*flash_id = MSB(ids);
+}
+
+int
+qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
+    uint32_t dwords)
+{
+	int ret;
+	uint32_t liter;
+	uint32_t sec_mask, rest_addr, conf_addr;
+	uint32_t fdata;
+	uint8_t	man_id, flash_id;
+	struct device_reg_24xx *reg =
+	    (struct device_reg_24xx __iomem *)ha->iobase;
+
+	ret = QLA_SUCCESS;
+
+	/* Pause RISC. */
+	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
+	RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
+
+	qla24xx_get_flash_manufacturer(ha, &man_id, &flash_id);
+	DEBUG9(printk("%s(%ld): Flash man_id=%d flash_id=%d\n", __func__,
+	    ha->host_no, man_id, flash_id));
+
+	conf_addr = flash_conf_to_access_addr(0x03d8);
+	switch (man_id) {
+	case 0xbf: // STT flash
+		rest_addr = 0x1fff;
+		sec_mask = 0x3e000;
+		if (flash_id == 0x80)
+			conf_addr = flash_conf_to_access_addr(0x0352);
+		break;
+	case 0x13: // ST M25P80
+		rest_addr = 0x3fff;
+		sec_mask = 0x3c000;
+		break;
+	default:
+		// Default to 64 kb sector size
+		rest_addr = 0x3fff;
+		sec_mask = 0x3c000;
+		break;
+	}
+
+	/* Enable flash write. */
+	WRT_REG_DWORD(&reg->ctrl_status,
+	    RD_REG_DWORD(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
+	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
+
+	/* Disable flash write-protection. */
+	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0);
+
+	do {    /* Loop once to provide quick error exit. */
+		for (liter = 0; liter < dwords; liter++, faddr++, dwptr++) {
+			/* Are we at the beginning of a sector? */
+			if ((faddr & rest_addr) == 0) {
+				fdata = (faddr & sec_mask) << 2;
+				ret = qla24xx_write_flash_dword(ha, conf_addr,
+				    (fdata & 0xff00) |((fdata << 16) &
+				    0xff0000) | ((fdata >> 16) & 0xff));
+				if (ret != QLA_SUCCESS) {
+					DEBUG9(printk("%s(%ld) Unable to flash "
+					    "sector: address=%x.\n", __func__,
+					    ha->host_no, faddr));
+					break;
+				}
+			}
+			ret = qla24xx_write_flash_dword(ha,
+			    flash_data_to_access_addr(faddr),
+			    cpu_to_le32(*dwptr));
+			if (ret != QLA_SUCCESS) {
+				DEBUG9(printk("%s(%ld) Unable to program flash "
+				    "address=%x data=%x.\n", __func__,
+				    ha->host_no, faddr, *dwptr));
+				break;
+			}
+		}
+	} while (0);
+
+	/* Disable flash write. */
+	WRT_REG_DWORD(&reg->ctrl_status,
+	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
+	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
+
+	/* Release RISC pause. */
+	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
+	RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
+
+	return ret;
+}
+
+int
+qla2x00_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+    uint32_t bytes)
+{
+	int ret;
+	uint32_t i;
+	uint16_t *wptr;
+	uint32_t *dwptr;
+	struct device_reg_24xx *reg =
+	    (struct device_reg_24xx __iomem *)ha->iobase;
+
+	ret = QLA_SUCCESS;
+
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		/* Pause RISC. */
+		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
+		RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
+
+		/* Enable flash write. */
+		WRT_REG_DWORD(&reg->ctrl_status,
+		    RD_REG_DWORD(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
+		RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
+
+		/* Disable NVRAM write-protection. */
+		qla24xx_write_flash_dword(ha, nvram_conf_to_access_addr(0x101),
+		    0);
+		qla24xx_write_flash_dword(ha, nvram_conf_to_access_addr(0x101),
+		    0);
+
+		/* Dword writes to flash. */
+		dwptr = (uint32_t *)buf;
+		for (i = 0; i < bytes >> 2; i++, naddr++, dwptr++) {
+			ret = qla24xx_write_flash_dword(ha,
+			    nvram_data_to_access_addr(naddr),
+			    cpu_to_le32(*dwptr));
+			if (ret != QLA_SUCCESS) {
+				DEBUG9(printk("%s(%ld) Unable to program "
+				    "nvram address=%x data=%x.\n", __func__,
+				    ha->host_no, naddr, *dwptr));
+				break;
+			}
+		}
+
+		/* Enable NVRAM write-protection. */
+		qla24xx_write_flash_dword(ha, nvram_conf_to_access_addr(0x101),
+		    0x8c);
+
+		/* Disable flash write. */
+		WRT_REG_DWORD(&reg->ctrl_status,
+		    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
+		RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
+
+		/* Release RISC pause. */
+		WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
+		RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
+	} else {
+		int stat;
+
+		qla2x00_lock_nvram_access(ha);
+
+		/* Disable NVRAM write-protection. */
+		stat = qla2x00_clear_nvram_protection(ha);
+
+		wptr = (uint16_t *)buf;
+		for (i = 0; i < bytes >> 1; i++, naddr++) {
+			qla2x00_write_nvram_word(ha, naddr,
+			    cpu_to_le16(*wptr));
+			wptr++;
+		}
+
+		/* Enable NVRAM write-protection. */
+		qla2x00_set_nvram_protection(ha, stat);
+
+		qla2x00_unlock_nvram_access(ha);
+	}
+
+	return ret;
+}
------------

-- 
Andrew Vasquez
