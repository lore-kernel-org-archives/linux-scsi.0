From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [PATCH] qla2xxx: fix to honor ignored parameters in sysfs attributes
Date: Thu, 26 Jul 2007 13:43:34 -0700
Message-ID: <46A90776.4030804@qlogic.com>
Mime-Version: 1.0
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:24836 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbXGZUoa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 16:44:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: rlary@us.ibm.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This is a patch to fix 'segmentation fault' issue which was initiated by Richard Lary <rlary@us.ibm.com>.
Thanks again Richard.
---
>From 6abcf236b5c7fea75d7059facf77a255f02e96af Mon Sep 17 00:00:00 2001
From: Seokmann Ju <seokmann.ju@qlogic.com>
Date: Thu, 26 Jul 2007 16:09:48 -0400
Subject: [PATCH] qla2xxx: fix to honor ignored parameters in sysfs attributes

- on following sysfs attritute function, changes have made so that both
  count and offset input parameters are honored by the functions.
    = qla2x00_sysfs_read_nvram()
    = qla2x00_sysfs_read_vpd()
- made changes so that NVRAM data to be cached to minimize H/W accesses
  during agent querying of the driver's.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   39 +++++++++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_def.h  |    4 ++++
 drivers/scsi/qla2xxx/qla_init.c |   19 +++++++++++--------
 3 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 1612f92..0f2a9f5 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -91,18 +91,20 @@ qla2x00_sysfs_read_nvram(struct kobject *kobj,
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	unsigned long	flags;
+	int		size = ha->nvram_size;
+	char		*nvram_cache = ha->nvram;
 
-	if (!capable(CAP_SYS_ADMIN) || off != 0)
+	if (!capable(CAP_SYS_ADMIN) || off > size || count == 0)
 		return 0;
+	if (off + count > size) {
+		size -= off;
+		count = size;
+	}
 
-	/* Read NVRAM. */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->isp_ops->read_nvram(ha, (uint8_t *)buf, ha->nvram_base,
-	    ha->nvram_size);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	/* Read NVRAM data from cache. */
+	memcpy(buf, &nvram_cache[off], count);
 
-	return ha->nvram_size;
+	return count;
 }
 
 static ssize_t
@@ -144,6 +146,8 @@ qla2x00_sysfs_write_nvram(struct kobject *kobj,
 	/* Write NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->isp_ops->write_nvram(ha, (uint8_t *)buf, ha->nvram_base, count);
+	ha->isp_ops->read_nvram(ha, (uint8_t *)&ha->nvram, ha->nvram_base,
+	    count);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
@@ -298,18 +302,20 @@ qla2x00_sysfs_read_vpd(struct kobject *kobj,
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
-	unsigned long flags;
+	int           size = ha->vpd_size;
+	char          *vpd_cache = ha->vpd;
 
-	if (!capable(CAP_SYS_ADMIN) || off != 0)
+	if (!capable(CAP_SYS_ADMIN) || off > size || count == 0)
 		return 0;
+	if (off + count > size) {
+		size -= off;
+		count = size;
+	}
 
-	/* Read NVRAM. */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->isp_ops->read_nvram(ha, (uint8_t *)buf, ha->vpd_base,
-	    ha->vpd_size);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	/* Read NVRAM data from cache. */
+	memcpy(buf, &vpd_cache[off], count);
 
-	return ha->vpd_size;
+	return count;
 }
 
 static ssize_t
@@ -327,6 +333,7 @@ qla2x00_sysfs_write_vpd(struct kobject *kobj,
 	/* Write NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->isp_ops->write_nvram(ha, (uint8_t *)buf, ha->vpd_base, count);
+	ha->isp_ops->read_nvram(ha, (uint8_t *)ha->vpd, ha->vpd_base, count);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return count;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0c9f36c..27ae3a5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2340,10 +2340,14 @@ typedef struct scsi_qla_host {
 	uint8_t		serial2;
 
 	/* NVRAM configuration data */
+#define MAX_NVRAM_SIZE	4096
+#define VPD_OFFSET	MAX_NVRAM_SIZE / 2
 	uint16_t	nvram_size;
 	uint16_t	nvram_base;
+	void		*nvram;
 	uint16_t	vpd_size;
 	uint16_t	vpd_base;
+	void		*vpd;
 
 	uint16_t	loop_reset_delay;
 	uint8_t		retry_count;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5ec798c..374abe1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1461,8 +1461,8 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 	uint16_t        cnt;
 	uint8_t         *dptr1, *dptr2;
 	init_cb_t       *icb = ha->init_cb;
-	nvram_t         *nv = (nvram_t *)ha->request_ring;
-	uint8_t         *ptr = (uint8_t *)ha->request_ring;
+	nvram_t         *nv = ha->nvram;
+	uint8_t         *ptr = ha->nvram;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	rval = QLA_SUCCESS;
@@ -1480,8 +1480,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 		chksum += *ptr++;
 
 	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", ha->host_no));
-	DEBUG5(qla2x00_dump_buffer((uint8_t *)ha->request_ring,
-	    ha->nvram_size));
+	DEBUG5(qla2x00_dump_buffer((uint8_t *)nv, ha->nvram_size));
 
 	/* Bad NVRAM data, set defaults parameters. */
 	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' ||
@@ -3500,7 +3499,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 
 	rval = QLA_SUCCESS;
 	icb = (struct init_cb_24xx *)ha->init_cb;
-	nv = (struct nvram_24xx *)ha->request_ring;
+	nv = ha->nvram;
 
 	/* Determine NVRAM starting address. */
 	ha->nvram_size = sizeof(struct nvram_24xx);
@@ -3512,7 +3511,12 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 		ha->vpd_base = FA_NVRAM_VPD1_ADDR;
 	}
 
-	/* Get NVRAM data and calculate checksum. */
+	/* Get VPD data into cache */
+	ha->vpd = ha->nvram + VPD_OFFSET;
+	ha->isp_ops->read_nvram(ha, (uint8_t *)ha->vpd,
+	    ha->nvram_base - FA_NVRAM_FUNC0_ADDR, FA_NVRAM_VPD_SIZE * 4);
+
+	/* Get NVRAM data into cache and calculate checksum. */
 	dptr = (uint32_t *)nv;
 	ha->isp_ops->read_nvram(ha, (uint8_t *)dptr, ha->nvram_base,
 	    ha->nvram_size);
@@ -3520,8 +3524,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 		chksum += le32_to_cpu(*dptr++);
 
 	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", ha->host_no));
-	DEBUG5(qla2x00_dump_buffer((uint8_t *)ha->request_ring,
-	    ha->nvram_size));
+	DEBUG5(qla2x00_dump_buffer((uint8_t *)nv, ha->nvram_size));
 
 	/* Bad NVRAM data, set defaults parameters. */
 	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' || nv->id[2] != 'P'
-- 
1.5.2
---
