From: Jeff Garzik <jeff@garzik.org>
Subject: [git patches] libata updates
Date: Wed, 2 Jun 2010 14:08:49 -0400
Message-ID: <20100602180849.GA31980@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


1) Last half of a block layer update to support the host-protected area
   (HPA) on ATA disks, an ATA feature which controls whether the disk
   reports full capacity (normal + host area) or reduced capacity
   (normal area only).

2) various fixes


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig       |    6 +++---
 drivers/ata/libata-core.c |    6 +++---
 drivers/ata/libata-scsi.c |   29 +++++++++++++++++++++++++++++
 drivers/ata/sata_nv.c     |    2 --
 drivers/ata/sata_via.c    |   13 +++++++++++++
 drivers/scsi/sd.c         |   22 ++++++++++++++++++++++
 include/linux/libata.h    |    2 ++
 include/scsi/scsi_host.h  |    8 ++++++++
 8 files changed, 80 insertions(+), 8 deletions(-)

Stefan Richter (1):
      libata-sff: trivial corrections to Kconfig help text

Tejun Heo (5):
      sata_via: magic vt6421 fix for transmission problems w/ WD drives
      sata_nv: don't diddle with nIEN on mcp55
      SCSI: implement sd_unlock_native_capacity()
      libata: use the enlarged capacity after late HPA unlock
      libata: implement on-demand HPA unlocking

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 73f8833..aa85a98 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -168,10 +168,10 @@ config ATA_BMDMA
 	default y
 	help
 	  This option adds support for SFF ATA controllers with BMDMA
-	  capability.  BMDMA stands for bus-master DMA and the
-	  de-facto DMA interface for SFF controllers.
+	  capability.  BMDMA stands for bus-master DMA and is the
+	  de facto DMA interface for SFF controllers.
 
-	  If unuser, say Y.
+	  If unsure, say Y.
 
 if ATA_BMDMA
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 06b7e49..ddf8e48 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4119,9 +4119,8 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	    dev->n_sectors > n_sectors && dev->n_sectors == n_native_sectors) {
 		ata_dev_printk(dev, KERN_WARNING,
 			       "new n_sectors matches native, probably "
-			       "late HPA unlock, continuing\n");
-		/* keep using the old n_sectors */
-		dev->n_sectors = n_sectors;
+			       "late HPA unlock, n_sectors updated\n");
+		/* use the larger n_sectors */
 		return 0;
 	}
 
@@ -6669,6 +6668,7 @@ EXPORT_SYMBOL_GPL(ata_dummy_port_info);
 EXPORT_SYMBOL_GPL(ata_link_next);
 EXPORT_SYMBOL_GPL(ata_dev_next);
 EXPORT_SYMBOL_GPL(ata_std_bios_param);
+EXPORT_SYMBOL_GPL(ata_scsi_unlock_native_capacity);
 EXPORT_SYMBOL_GPL(ata_host_init);
 EXPORT_SYMBOL_GPL(ata_host_alloc);
 EXPORT_SYMBOL_GPL(ata_host_alloc_pinfo);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index cfa9dd3..a54273d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -415,6 +415,35 @@ int ata_std_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 }
 
 /**
+ *	ata_scsi_unlock_native_capacity - unlock native capacity
+ *	@sdev: SCSI device to adjust device capacity for
+ *
+ *	This function is called if a partition on @sdev extends beyond
+ *	the end of the device.  It requests EH to unlock HPA.
+ *
+ *	LOCKING:
+ *	Defined by the SCSI layer.  Might sleep.
+ */
+void ata_scsi_unlock_native_capacity(struct scsi_device *sdev)
+{
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (dev && dev->n_sectors < dev->n_native_sectors) {
+		dev->flags |= ATA_DFLAG_UNLOCK_HPA;
+		dev->link->eh_info.action |= ATA_EH_RESET;
+		ata_port_schedule_eh(ap);
+	}
+
+	spin_unlock_irqrestore(ap->lock, flags);
+	ata_port_wait_eh(ap);
+}
+
+/**
  *	ata_get_identity - Handler for HDIO_GET_IDENTITY ioctl
  *	@ap: target port
  *	@sdev: SCSI device to get identify data for
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 6fd1147..2116113 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1669,7 +1669,6 @@ static void nv_mcp55_freeze(struct ata_port *ap)
 	mask = readl(mmio_base + NV_INT_ENABLE_MCP55);
 	mask &= ~(NV_INT_ALL_MCP55 << shift);
 	writel(mask, mmio_base + NV_INT_ENABLE_MCP55);
-	ata_sff_freeze(ap);
 }
 
 static void nv_mcp55_thaw(struct ata_port *ap)
@@ -1683,7 +1682,6 @@ static void nv_mcp55_thaw(struct ata_port *ap)
 	mask = readl(mmio_base + NV_INT_ENABLE_MCP55);
 	mask |= (NV_INT_MASK_MCP55 << shift);
 	writel(mask, mmio_base + NV_INT_ENABLE_MCP55);
-	ata_sff_thaw(ap);
 }
 
 static void nv_adma_error_handler(struct ata_port *ap)
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 101d8c2..0ecd0f6 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -575,6 +575,19 @@ static void svia_configure(struct pci_dev *pdev)
 		tmp8 |= NATIVE_MODE_ALL;
 		pci_write_config_byte(pdev, SATA_NATIVE_MODE, tmp8);
 	}
+
+	/*
+	 * vt6421 has problems talking to some drives.  The following
+	 * is the magic fix from Joseph Chan <JosephChan@via.com.tw>.
+	 * Please add proper documentation if possible.
+	 *
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=15173
+	 */
+	if (pdev->device == 0x3249) {
+		pci_read_config_byte(pdev, 0x52, &tmp8);
+		tmp8 |= 1 << 2;
+		pci_write_config_byte(pdev, 0x52, tmp8);
+	}
 }
 
 static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 829cc37..8802e48 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -97,6 +97,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 #endif
 
 static int  sd_revalidate_disk(struct gendisk *);
+static void sd_unlock_native_capacity(struct gendisk *disk);
 static int  sd_probe(struct device *);
 static int  sd_remove(struct device *);
 static void sd_shutdown(struct device *);
@@ -1101,6 +1102,7 @@ static const struct block_device_operations sd_fops = {
 #endif
 	.media_changed		= sd_media_changed,
 	.revalidate_disk	= sd_revalidate_disk,
+	.unlock_native_capacity	= sd_unlock_native_capacity,
 };
 
 static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
@@ -2121,6 +2123,26 @@ static int sd_revalidate_disk(struct gendisk *disk)
 }
 
 /**
+ *	sd_unlock_native_capacity - unlock native capacity
+ *	@disk: struct gendisk to set capacity for
+ *
+ *	Block layer calls this function if it detects that partitions
+ *	on @disk reach beyond the end of the device.  If the SCSI host
+ *	implements ->unlock_native_capacity() method, it's invoked to
+ *	give it a chance to adjust the device capacity.
+ *
+ *	CONTEXT:
+ *	Defined by block layer.  Might sleep.
+ */
+static void sd_unlock_native_capacity(struct gendisk *disk)
+{
+	struct scsi_device *sdev = scsi_disk(disk)->device;
+
+	if (sdev->host->hostt->unlock_native_capacity)
+		sdev->host->hostt->unlock_native_capacity(sdev);
+}
+
+/**
  *	sd_format_disk_name - format disk name
  *	@prefix: name prefix - ie. "sd" for SCSI disks
  *	@index: index of the disk to format name for
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3bad270..b85f3ff 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1023,6 +1023,7 @@ extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 extern int ata_std_bios_param(struct scsi_device *sdev,
 			      struct block_device *bdev,
 			      sector_t capacity, int geom[]);
+extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
 extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
@@ -1174,6 +1175,7 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.slave_configure	= ata_scsi_slave_config,	\
 	.slave_destroy		= ata_scsi_slave_destroy,	\
 	.bios_param		= ata_std_bios_param,		\
+	.unlock_native_capacity	= ata_scsi_unlock_native_capacity, \
 	.sdev_attrs		= ata_common_sdev_attrs
 
 #define ATA_NCQ_SHT(drv_name)					\
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index c50a97f..b7bdecb 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -327,6 +327,14 @@ struct scsi_host_template {
 			sector_t, int []);
 
 	/*
+	 * This function is called when one or more partitions on the
+	 * device reach beyond the end of the device.
+	 *
+	 * Status: OPTIONAL
+	 */
+	void (*unlock_native_capacity)(struct scsi_device *);
+
+	/*
 	 * Can be used to export driver statistics and other infos to the
 	 * world outside the kernel ie. userspace and it also provides an
 	 * interface to feed the driver with information.
