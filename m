From: andrew.vasquez@qlogic.com
Subject: [PATCH 06/10] qla2xxx: Add VPD sysfs attribute.
Date: Thu, 9 Mar 2006 14:27:34 -0800
Message-ID: <11419432492902-git-send-email-andrew.vasquez@qlogic.com>
References: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:60997 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751959AbWCIW1e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 17:27:34 -0500
In-Reply-To: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_attr.c |   57 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    2 +
 drivers/scsi/qla2xxx/qla_fw.h   |    2 +
 drivers/scsi/qla2xxx/qla_init.c |    6 +++-
 4 files changed, 65 insertions(+), 2 deletions(-)

ba053245d0d9b69ca0c2d8952377d267dc701b2a
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2b9e329..488b3d1 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -308,6 +308,61 @@ static struct bin_attribute sysfs_optrom
 	.write = qla2x00_sysfs_write_optrom_ctl,
 };
 
+static ssize_t
+qla2x00_sysfs_read_vpd(struct kobject *kobj, char *buf, loff_t off,
+    size_t count)
+{
+	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	unsigned long flags;
+
+	if (!capable(CAP_SYS_ADMIN) || off != 0)
+		return 0;
+
+	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+		return -ENOTSUPP;
+
+	/* Read NVRAM. */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->isp_ops.read_nvram(ha, (uint8_t *)buf, ha->vpd_base, ha->vpd_size);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return ha->vpd_size;
+}
+
+static ssize_t
+qla2x00_sysfs_write_vpd(struct kobject *kobj, char *buf, loff_t off,
+    size_t count)
+{
+	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	unsigned long flags;
+
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->vpd_size)
+		return 0;
+
+	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+		return -ENOTSUPP;
+
+	/* Write NVRAM. */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->isp_ops.write_nvram(ha, (uint8_t *)buf, ha->vpd_base, count);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return count;
+}
+
+static struct bin_attribute sysfs_vpd_attr = {
+	.attr = {
+		.name = "vpd",
+		.mode = S_IRUSR | S_IWUSR,
+		.owner = THIS_MODULE,
+	},
+	.size = 0,
+	.read = qla2x00_sysfs_read_vpd,
+	.write = qla2x00_sysfs_write_vpd,
+};
+
 void
 qla2x00_alloc_sysfs_attr(scsi_qla_host_t *ha)
 {
@@ -318,6 +373,7 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_optrom_attr);
 	sysfs_create_bin_file(&host->shost_gendev.kobj,
 	    &sysfs_optrom_ctl_attr);
+	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_vpd_attr);
 }
 
 void
@@ -330,6 +386,7 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t 
 	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_optrom_attr);
 	sysfs_remove_bin_file(&host->shost_gendev.kobj,
 	    &sysfs_optrom_ctl_attr);
+	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_vpd_attr);
 
 	if (ha->beacon_blink_led == 1)
 		ha->isp_ops.beacon_off(ha);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e1a7769..20798f9 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2344,6 +2344,8 @@ typedef struct scsi_qla_host {
 	/* NVRAM configuration data */
 	uint16_t	nvram_size;
 	uint16_t	nvram_base;
+	uint16_t	vpd_size;
+	uint16_t	vpd_base;
 
 	uint16_t	loop_reset_delay;
 	uint8_t		retry_count;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 9fb562a..1ee58ad 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -759,7 +759,7 @@ struct device_reg_24xx {
 #define FA_NVRAM_FUNC0_ADDR	0x80
 #define FA_NVRAM_FUNC1_ADDR	0x180
 
-#define FA_NVRAM_VPD_SIZE	0x80
+#define FA_NVRAM_VPD_SIZE	0x200
 #define FA_NVRAM_VPD0_ADDR	0x00
 #define FA_NVRAM_VPD1_ADDR	0x100
 					/*
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3bc3e17..71b6bcc 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3263,8 +3263,12 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 	/* Determine NVRAM starting address. */
 	ha->nvram_size = sizeof(struct nvram_24xx);
 	ha->nvram_base = FA_NVRAM_FUNC0_ADDR;
-	if (PCI_FUNC(ha->pdev->devfn))
+	ha->vpd_size = FA_NVRAM_VPD_SIZE;
+	ha->vpd_base = FA_NVRAM_VPD0_ADDR;
+	if (PCI_FUNC(ha->pdev->devfn)) {
 		ha->nvram_base = FA_NVRAM_FUNC1_ADDR;
+		ha->vpd_base = FA_NVRAM_VPD1_ADDR;
+	}
 
 	/* Get NVRAM data and calculate checksum. */
 	dptr = (uint32_t *)nv;
-- 
1.2.4.gf067


