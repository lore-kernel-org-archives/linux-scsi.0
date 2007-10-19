From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/8] qla2xxx: Handle unaligned sector writes during NVRAM/VPD updates.
Date: Fri, 19 Oct 2007 15:59:15 -0700
Message-ID: <1192834760-573-3-git-send-email-andrew.vasquez@qlogic.com>
References: <20071019225824.GG24197@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29152 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966599AbXJSW7h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 18:59:37 -0400
In-Reply-To: <20071019225824.GG24197@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Since both NVRAM and VPD regions of the flash reside on unaligned
sector boundaries, during update, the driver must perform a
read-modify-write operation to the composite NVRAM/VPD region.
This affects ISP25xx type boards only.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 ------
 drivers/scsi/qla2xxx/qla_sup.c  |   23 +++++++++++++++++++++--
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 05fa779..2f0bd5a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -114,7 +114,6 @@ qla2x00_sysfs_write_nvram(struct kobject *kobj,
 {
 	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	unsigned long	flags;
 	uint16_t	cnt;
 
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size)
@@ -144,11 +143,9 @@ qla2x00_sysfs_write_nvram(struct kobject *kobj,
 	}
 
 	/* Write NVRAM. */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->isp_ops->write_nvram(ha, (uint8_t *)buf, ha->nvram_base, count);
 	ha->isp_ops->read_nvram(ha, (uint8_t *)ha->nvram, ha->nvram_base,
 	    count);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 
@@ -397,16 +394,13 @@ qla2x00_sysfs_write_vpd(struct kobject *kobj,
 {
 	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	unsigned long flags;
 
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->vpd_size)
 		return 0;
 
 	/* Write NVRAM. */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->isp_ops->write_nvram(ha, (uint8_t *)buf, ha->vpd_base, count);
 	ha->isp_ops->read_nvram(ha, (uint8_t *)ha->vpd, ha->vpd_base, count);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return count;
 }
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 40b059f..b3faff0 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -7,6 +7,7 @@
 #include "qla_def.h"
 
 #include <linux/delay.h>
+#include <linux/vmalloc.h>
 #include <asm/uaccess.h>
 
 static uint16_t qla2x00_nvram_request(scsi_qla_host_t *, uint32_t);
@@ -745,9 +746,11 @@ qla2x00_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 	int ret, stat;
 	uint32_t i;
 	uint16_t *wptr;
+	unsigned long flags;
 
 	ret = QLA_SUCCESS;
 
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qla2x00_lock_nvram_access(ha);
 
 	/* Disable NVRAM write-protection. */
@@ -764,6 +767,7 @@ qla2x00_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 	qla2x00_set_nvram_protection(ha, stat);
 
 	qla2x00_unlock_nvram_access(ha);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return ret;
 }
@@ -776,9 +780,11 @@ qla24xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 	uint32_t i;
 	uint32_t *dwptr;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	unsigned long flags;
 
 	ret = QLA_SUCCESS;
 
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	/* Enable flash write. */
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    RD_REG_DWORD(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
@@ -812,6 +818,7 @@ qla24xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
 	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return ret;
 }
@@ -836,8 +843,20 @@ int
 qla25xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
-	return qla24xx_write_flash_data(ha, (uint32_t *)buf,
-	    FA_VPD_NVRAM_ADDR | naddr, bytes >> 2);
+#define RMW_BUFFER_SIZE	(64 * 1024)
+	uint8_t *dbuf;
+
+	dbuf = vmalloc(RMW_BUFFER_SIZE);
+	if (!dbuf)
+		return QLA_MEMORY_ALLOC_FAILED;
+	ha->isp_ops->read_optrom(ha, dbuf, FA_VPD_NVRAM_ADDR << 2,
+	    RMW_BUFFER_SIZE);
+	memcpy(dbuf + (naddr << 2), buf, bytes);
+	ha->isp_ops->write_optrom(ha, dbuf, FA_VPD_NVRAM_ADDR << 2,
+	    RMW_BUFFER_SIZE);
+	vfree(dbuf);
+
+	return QLA_SUCCESS;
 }
 
 static inline void
-- 
1.5.3.4.206.g58ba4

