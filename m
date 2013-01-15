From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v13 2/9] libata: identify and init ZPODD devices
Date: Tue, 15 Jan 2013 17:20:58 +0800
Message-ID: <1358241665-2156-3-git-send-email-aaron.lu@intel.com>
References: <1358241665-2156-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1358241665-2156-1-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
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

A new config CONFIG_SATA_ZPODD is added to selectively build ZPODD code.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/Kconfig        |  13 ++++++
 drivers/ata/Makefile       |   1 +
 drivers/ata/libata-core.c  |   4 +-
 drivers/ata/libata-scsi.c  |   2 +
 drivers/ata/libata-zpodd.c | 100 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h       |  14 +++++++
 include/linux/libata.h     |   3 ++
 include/uapi/linux/cdrom.h |  34 +++++++++++++++
 8 files changed, 170 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ata/libata-zpodd.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index e08d322..996d16c 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -58,6 +58,19 @@ config ATA_ACPI
 	  You can disable this at kernel boot time by using the
 	  option libata.noacpi=1
 
+config SATA_ZPODD
+	bool "SATA Zero Power ODD Support"
+	depends on ATA_ACPI
+	default n
+	help
+	  This option adds support for SATA ZPODD. It requires both
+	  ODD and the platform support, and if enabled, will automatically
+	  power on/off the ODD when certain condition is satisfied. This
+	  does not impact user's experience of the ODD, only power is saved
+	  when ODD is not in use(i.e. no disc inside).
+
+	  If unsure, say N.
+
 config SATA_PMP
 	bool "SATA Port Multiplier support"
 	default y
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 9329daf..85e3de4 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -107,3 +107,4 @@ libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
 libata-$(CONFIG_ATA_SFF)	+= libata-sff.o
 libata-$(CONFIG_SATA_PMP)	+= libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
+libata-$(CONFIG_SATA_ZPODD)	+= libata-zpodd.o
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 275941b..c7ecd84 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2401,8 +2401,10 @@ int ata_dev_configure(struct ata_device *dev)
 			dma_dir_string = ", DMADIR";
 		}
 
-		if (ata_id_has_da(dev->id))
+		if (ata_id_has_da(dev->id)) {
 			dev->flags |= ATA_DFLAG_DA;
+			zpodd_init(dev);
+		}
 
 		/* print device info to dmesg */
 		if (ata_msg_drv(ap) && print_info)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7c337e7..1ff0185 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3755,6 +3755,8 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
 	mutex_lock(&ap->scsi_host->scan_mutex);
 	spin_lock_irqsave(ap->lock, flags);
 
+	if (zpodd_dev_enabled(dev))
+		zpodd_exit(dev);
 	ata_acpi_unbind(dev);
 
 	/* clearing dev->sdev is protected by host lock */
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
new file mode 100644
index 0000000..27eed2f
--- /dev/null
+++ b/drivers/ata/libata-zpodd.c
@@ -0,0 +1,100 @@
+#include <linux/libata.h>
+#include <linux/cdrom.h>
+
+#include "libata.h"
+
+enum odd_mech_type {
+	ODD_MECH_TYPE_SLOT,
+	ODD_MECH_TYPE_DRAWER,
+	ODD_MECH_TYPE_UNSUPPORTED,
+};
+
+struct zpodd {
+	enum odd_mech_type	mech_type; /* init during probe, RO afterwards */
+	struct ata_device	*dev;
+};
+
+/* Per the spec, only slot type and drawer type ODD can be supported */
+static enum odd_mech_type zpodd_get_mech_type(struct ata_device *dev)
+{
+	char buf[16];
+	unsigned int ret;
+	struct rm_feature_desc *desc = (void *)(buf + 8);
+	struct ata_taskfile tf = {};
+
+	char cdb[] = {  GPCMD_GET_CONFIGURATION,
+			2,      /* only 1 feature descriptor requested */
+			0, 3,   /* 3, removable medium feature */
+			0, 0, 0,/* reserved */
+			0, sizeof(buf),
+			0, 0, 0,
+	};
+
+	tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.command = ATA_CMD_PACKET;
+	tf.protocol = ATAPI_PROT_PIO;
+	tf.lbam = sizeof(buf);
+
+	ret = ata_exec_internal(dev, &tf, cdb, DMA_FROM_DEVICE,
+				buf, sizeof(buf), 0);
+	if (ret)
+		return ODD_MECH_TYPE_UNSUPPORTED;
+
+	if (be16_to_cpu(desc->feature_code) != 3)
+		return ODD_MECH_TYPE_UNSUPPORTED;
+
+	if (desc->mech_type == 0 && desc->load == 0 && desc->eject == 1)
+		return ODD_MECH_TYPE_SLOT;
+	else if (desc->mech_type == 1 && desc->load == 0 && desc->eject == 1)
+		return ODD_MECH_TYPE_DRAWER;
+	else
+		return ODD_MECH_TYPE_UNSUPPORTED;
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
+	enum odd_mech_type mech_type;
+	struct zpodd *zpodd;
+
+	if (dev->zpodd)
+		return;
+
+	if (!odd_can_poweroff(dev))
+		return;
+
+	mech_type = zpodd_get_mech_type(dev);
+	if (mech_type == ODD_MECH_TYPE_UNSUPPORTED)
+		return;
+
+	zpodd = kzalloc(sizeof(struct zpodd), GFP_KERNEL);
+	if (!zpodd)
+		return;
+
+	zpodd->mech_type = mech_type;
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
index 7148a58..a21740b 100644
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
+	return dev->zpodd != NULL;
+}
+#else /* CONFIG_SATA_ZPODD */
+static inline void zpodd_init(struct ata_device *dev) {}
+static inline void zpodd_exit(struct ata_device *dev) {}
+static inline bool zpodd_dev_enabled(struct ata_device *dev) { return false; }
+#endif /* CONFIG_SATA_ZPODD */
+
 #endif /* __LIBATA_H__ */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7ae207e..65ff67e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -621,6 +621,9 @@ struct ata_device {
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

