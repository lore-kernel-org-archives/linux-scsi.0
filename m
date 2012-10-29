From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v8 06/11] ata: zpodd: check loading mechanism for ODD
Date: Mon, 29 Oct 2012 17:01:33 +0800
Message-ID: <1351501298-3716-7-git-send-email-aaron.lu@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45943 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758415Ab2J2JCA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2012 05:02:00 -0400
In-Reply-To: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

Per the Mount Fuji spec on SATA ZPODD, only slot type or drawer type
ODD can support ZPODD. So add a function to check this, and if fails,
skip setting of dev->private_data so that zpodd_dev_enabled will return
false.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/sata_zpodd.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cdrom.h    | 35 +++++++++++++++++++
 2 files changed, 122 insertions(+)

diff --git a/drivers/ata/sata_zpodd.c b/drivers/ata/sata_zpodd.c
index 009b1e4..c7c63a1 100644
--- a/drivers/ata/sata_zpodd.c
+++ b/drivers/ata/sata_zpodd.c
@@ -1,13 +1,89 @@
 #include <linux/libata.h>
 #include <linux/pm_runtime.h>
+#include <linux/cdrom.h>
 #include <scsi/scsi_device.h>
 
+#include "libata.h"
+
 struct zpodd {
+	bool slot:1;
+	bool drawer:1;
 	bool from_notify:1;	/* resumed as a result of acpi notification */
 
 	struct ata_device *dev;
 };
 
+static int zpodd_run_atapi_cmd(struct ata_device *dev, const char *cdb,
+		unsigned short cdb_len, char *buf, unsigned int buf_len)
+{
+	int ret = 0;
+	struct ata_taskfile tf = {0};
+
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.command = ATA_CMD_PACKET;
+
+	if (buf) {
+		tf.protocol = ATAPI_PROT_PIO;
+		tf.lbam = buf_len;
+	} else {
+		tf.protocol = ATAPI_PROT_NODATA;
+	}
+
+	ata_eh_acquire(dev->link->ap);
+	ret = ata_exec_internal(dev, &tf, cdb, buf ? DMA_FROM_DEVICE : DMA_NONE,
+				buf, buf_len, 0);
+	ata_eh_release(dev->link->ap);
+
+	return ret;
+}
+
+/*
+ * Per the spec, only slot type and drawer type ODD can be supported
+ *
+ * Return 0 for slot, 1 for drawer, and -ENODEV for others or on error.
+ */
+static int check_loading_mechanism(struct ata_device *dev)
+{
+	char buf[16];
+	unsigned int ret, i, retry = 10;
+	struct rm_feature_desc *desc = (void *)(buf + 8);
+
+	char cdb[] = {  GPCMD_GET_CONFIGURATION,
+			2,      /* only 1 feature descriptor requested */
+			0, 3,   /* 3, removable medium feature */
+			0, 0, 0,/* reserved */
+			0, sizeof(buf),
+			0, 0, 0,
+	};
+
+	/*
+	 * When we issue this command in ATA layer, SCSI layer may also
+	 * issue some commands to the ODD. To avoid this command failed
+	 * due to defer, retry for several times.
+	 */
+	for (i = 0; i < retry; i++) {
+		ret = zpodd_run_atapi_cmd(dev, cdb, sizeof(cdb),
+					  buf, sizeof(buf));
+		if (!ret || ret != -EBUSY)
+			break;
+		msleep(20);
+	}
+	if (ret)
+		return -ENODEV;
+
+	if (be16_to_cpu(desc->feature_code) != 3)
+		return -ENODEV;
+
+	if (desc->mech_type == 0 && desc->load == 0 && desc->eject == 1)
+		ret = 0; /* slot */
+	else if (desc->mech_type == 1 && desc->load == 0 && desc->eject == 1)
+		ret = 1; /* drawer */
+	else
+		ret = -ENODEV;
+
+	return ret;
+}
+
 static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
 {
 	struct ata_device *ata_dev = context;
@@ -38,10 +114,21 @@ static void zpodd_acpi_remove_pm_notifier(struct ata_device *dev)
 void zpodd_init(struct ata_device *dev)
 {
 	struct zpodd *zpodd;
+	int ret;
+
 	zpodd = kzalloc(sizeof(struct zpodd), GFP_KERNEL);
 	if (!zpodd)
 		return;
 
+	if ((ret = check_loading_mechanism(dev)) == -ENODEV) {
+		kfree(zpodd);
+		return;
+	}
+	if (ret == 0)
+		zpodd->slot = true;
+	else
+		zpodd->drawer = true;
+
 	zpodd_acpi_add_pm_notifier(dev);
 	zpodd->dev = dev;
 	dev->private_data = zpodd;
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index dfd7f18..755f2b4 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -806,6 +806,41 @@ struct rwrt_feature_desc {
 	__u8 reserved3;
 };
 
+/* removable medium feature descriptor */
+struct rm_feature_desc {
+	__be16 feature_code;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	__u8 reserved1:2;
+	__u8 feature_version:4;
+	__u8 persistent:1;
+	__u8 curr:1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 curr:1;
+	__u8 persistent:1;
+	__u8 feature_version:4;
+	__u8 reserved1:2;
+#endif
+	__u8 add_len;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	__u8 mech_type:3;
+	__u8 load:1;
+	__u8 eject:1;
+	__u8 pvnt_jmpr:1;
+	__u8 dbml:1;
+	__u8 lock:1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 lock:1;
+	__u8 dbml:1;
+	__u8 pvnt_jmpr:1;
+	__u8 eject:1;
+	__u8 load:1;
+	__u8 mech_type:3;
+#endif
+	__u8 reserved2;
+	__u8 reserved3;
+	__u8 reserved4;
+};
+
 typedef struct {
 	__be16 disc_information_length;
 #if defined(__BIG_ENDIAN_BITFIELD)
-- 
1.7.12.4

