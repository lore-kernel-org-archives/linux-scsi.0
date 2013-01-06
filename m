From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v11 3/9] libata: identify and init ZPODD devices
Date: Sun,  6 Jan 2013 10:48:23 +0800
Message-ID: <1357440509-28108-4-git-send-email-aaron.lu@intel.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

The ODD can be enabled for ZPODD if the following three conditions are
satisfied:
1 The ODD supports device attention;
2 The platform can runtime power off the ODD through ACPI;
3 The ODD is either slot type or drawer type.
For such ODDs, zpodd_init is called and a new structure is allocated for
it to store ZPODD related stuffs.

And the zpodd_dev_enabled function is used to test if ZPODD is currently
enabled for this ODD.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c  |   2 +
 drivers/ata/libata-core.c  |   4 +-
 drivers/ata/libata-zpodd.c | 114 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h       |  14 ++++++
 include/linux/libata.h     |   3 ++
 include/uapi/linux/cdrom.h |  34 ++++++++++++++
 6 files changed, 170 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ata/libata-zpodd.c

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index ef01ac0..5aa7322 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1063,6 +1063,8 @@ void ata_acpi_bind(struct ata_device *dev)
 
 void ata_acpi_unbind(struct ata_device *dev)
 {
+	if (zpodd_dev_enabled(dev))
+		zpodd_exit(dev);
 	ata_acpi_remove_pm_notifier(dev);
 	ata_acpi_unregister_power_resource(dev);
 }
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9e8b99a..65a362e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2396,8 +2396,10 @@ int ata_dev_configure(struct ata_device *dev)
 			dma_dir_string = ", DMADIR";
 		}
 
-		if (ata_id_has_da(dev->id))
+		if (ata_id_has_da(dev->id)) {
 			dev->flags |= ATA_DFLAG_DA;
+			zpodd_init(dev);
+		}
 
 		/* print device info to dmesg */
 		if (ata_msg_drv(ap) && print_info)
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
new file mode 100644
index 0000000..58bf891
--- /dev/null
+++ b/drivers/ata/libata-zpodd.c
@@ -0,0 +1,114 @@
+#include <linux/libata.h>
+#include <linux/cdrom.h>
+
+#include "libata.h"
+
+struct zpodd {
+	bool slot:1;
+	bool drawer:1;
+
+	struct ata_device *dev;
+};
+
+static int run_atapi_cmd(struct ata_device *dev, const char *cdb,
+		unsigned short cdb_len, char *buf, unsigned int buf_len)
+{
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
+	return ata_exec_internal(dev, &tf, cdb,
+			buf ? DMA_FROM_DEVICE : DMA_NONE, buf, buf_len, 0);
+}
+
+/*
+ * Per the spec, only slot type and drawer type ODD can be supported
+ *
+ * Return 0 for slot type, 1 for drawer, -ENODEV for other types or on error.
+ */
+static int check_loading_mechanism(struct ata_device *dev)
+{
+	char buf[16];
+	unsigned int ret;
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
+	ret = run_atapi_cmd(dev, cdb, sizeof(cdb), buf, sizeof(buf));
+	if (ret)
+		return -ENODEV;
+
+	if (be16_to_cpu(desc->feature_code) != 3)
+		return -ENODEV;
+
+	if (desc->mech_type == 0 && desc->load == 0 && desc->eject == 1)
+		return 0; /* slot */
+	else if (desc->mech_type == 1 && desc->load == 0 && desc->eject == 1)
+		return 1; /* drawer */
+	else
+		return -ENODEV;
+}
+
+static bool odd_can_poweroff(struct ata_device *ata_dev)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_device *acpi_dev;
+
+	handle = ata_dev_acpi_handle(ata_dev);
+	if (!handle)
+		return false;
+
+	status = acpi_bus_get_device(handle, &acpi_dev);
+	if (ACPI_FAILURE(status))
+		return false;
+
+	return acpi_device_can_poweroff(acpi_dev);
+}
+
+void zpodd_init(struct ata_device *dev)
+{
+	int ret;
+	struct zpodd *zpodd;
+
+	if (dev->zpodd)
+		return;
+
+	if (!odd_can_poweroff(dev))
+		return;
+
+	if ((ret = check_loading_mechanism(dev)) == -ENODEV)
+		return;
+
+	zpodd = kzalloc(sizeof(struct zpodd), GFP_KERNEL);
+	if (!zpodd)
+		return;
+
+	if (ret)
+		zpodd->drawer = true;
+	else
+		zpodd->slot = true;
+
+	zpodd->dev = dev;
+	dev->zpodd = zpodd;
+}
+
+void zpodd_exit(struct ata_device *dev)
+{
+	kfree(dev->zpodd);
+	dev->zpodd = NULL;
+}
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 7148a58..8cb4372 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -230,4 +230,18 @@ static inline void ata_sff_exit(void)
 { }
 #endif /* CONFIG_ATA_SFF */
 
+/* libata-zpodd.c */
+#ifdef CONFIG_SATA_ZPODD
+void zpodd_init(struct ata_device *dev);
+void zpodd_exit(struct ata_device *dev);
+static inline bool zpodd_dev_enabled(struct ata_device *dev)
+{
+	return dev->zpodd ? true : false;
+}
+#else /* CONFIG_SATA_ZPODD */
+static inline void zpodd_init(struct ata_device *dev) {}
+static inline void zpodd_exit(struct ata_device *dev) {}
+static inline bool zpodd_dev_enabled(struct ata_device *dev) { return false; }
+#endif /* CONFIG_SATA_ZPODD */
+
 #endif /* __LIBATA_H__ */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 83ba0ab..f88f909 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -620,6 +620,9 @@ struct ata_device {
 	union acpi_object	*gtf_cache;
 	unsigned int		gtf_filter;
 #endif
+#ifdef CONFIG_SATA_ZPODD
+	void			*zpodd;
+#endif
 	struct device		tdev;
 	/* n_sector is CLEAR_BEGIN, read comment above CLEAR_BEGIN */
 	u64			n_sectors;	/* size of device, if ATA */
diff --git a/include/uapi/linux/cdrom.h b/include/uapi/linux/cdrom.h
index 898b866..bd17ad5 100644
--- a/include/uapi/linux/cdrom.h
+++ b/include/uapi/linux/cdrom.h
@@ -908,5 +908,39 @@ struct mode_page_header {
 	__be16 desc_length;
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
 
 #endif /* _UAPI_LINUX_CDROM_H */
-- 
1.7.11.7

