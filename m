From: akpm@linux-foundation.org
Subject: [patch 02/17] scsi: don't build scsi_dma_{map,unmap} for !HAS_DMA
Date: Mon, 09 Jul 2007 11:59:59 -0700
Message-ID: <200707091859.l69Ixxb1002485@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757108AbXGITBA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 15:01:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, cornelia.huck@de.ibm.com, James.Bottomley@steeleye.com, dan.j.williams@intel.com, hch@lst.de, heiko.carstens@de.ibm.com, jeff@garzik.org, schwidefsky@de.ibm.com

From: Cornelia Huck <cornelia.huck@de.ibm.com>

With

 dma-mapping-prevent-dma-dependent-code-from-linking-on.patch

scsi fails to build on !HAS_DMA architectures:

drivers/built-in.o(.text+0x20af6): In function `scsi_dma_map':
: undefined reference to `dma_map_sg'
drivers/built-in.o(.text+0x20b5c): In function `scsi_dma_unmap':
: undefined reference to `dma_unmap_sg'

I split those functions out into a new file. Builds on s390 and i386.

Move scsi_dma_{map,unmap} into scsi_lib_dma.c which is only build if
HAS_DMA is set.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig        |    5 +++
 drivers/scsi/Makefile       |    6 ++--
 drivers/scsi/scsi_lib.c     |   38 -------------------------
 drivers/scsi/scsi_lib_dma.c |   50 ++++++++++++++++++++++++++++++++++
 4 files changed, 58 insertions(+), 41 deletions(-)

diff -puN drivers/scsi/Kconfig~scsi-dont-build-scsi_dma_mapunmap-for-has_dma drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi-dont-build-scsi_dma_mapunmap-for-has_dma
+++ a/drivers/scsi/Kconfig
@@ -10,6 +10,7 @@ config RAID_ATTRS
 config SCSI
 	tristate "SCSI device support"
 	depends on BLOCK
+	select SCSI_DMA if HAS_DMA
 	---help---
 	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
 	  any other SCSI device under Linux, say Y and make sure that you know
@@ -29,6 +30,10 @@ config SCSI
 	  However, do not compile this as a module if your root file system
 	  (the one containing the directory /) is located on a SCSI device.
 
+config SCSI_DMA
+	bool
+	default n
+
 config SCSI_TGT
 	tristate "SCSI target support"
 	depends on SCSI && EXPERIMENTAL
diff -puN drivers/scsi/Makefile~scsi-dont-build-scsi_dma_mapunmap-for-has_dma drivers/scsi/Makefile
--- a/drivers/scsi/Makefile~scsi-dont-build-scsi_dma_mapunmap-for-has_dma
+++ a/drivers/scsi/Makefile
@@ -149,9 +149,9 @@ obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 obj-$(CONFIG_SCSI_WAIT_SCAN)	+= scsi_wait_scan.o
 
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
-				   scsicam.o scsi_error.o scsi_lib.o \
-				   scsi_scan.o scsi_sysfs.o \
-				   scsi_devinfo.o
+				   scsicam.o scsi_error.o scsi_lib.o
+scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
+scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
diff -puN drivers/scsi/scsi_lib.c~scsi-dont-build-scsi_dma_mapunmap-for-has_dma drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi-dont-build-scsi_dma_mapunmap-for-has_dma
+++ a/drivers/scsi/scsi_lib.c
@@ -2290,41 +2290,3 @@ void scsi_kunmap_atomic_sg(void *virt)
 	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
 }
 EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
-
-/**
- * scsi_dma_map - perform DMA mapping against command's sg lists
- * @cmd:	scsi command
- *
- * Returns the number of sg lists actually used, zero if the sg lists
- * is NULL, or -ENOMEM if the mapping failed.
- */
-int scsi_dma_map(struct scsi_cmnd *cmd)
-{
-	int nseg = 0;
-
-	if (scsi_sg_count(cmd)) {
-		struct device *dev = cmd->device->host->shost_gendev.parent;
-
-		nseg = dma_map_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
-				  cmd->sc_data_direction);
-		if (unlikely(!nseg))
-			return -ENOMEM;
-	}
-	return nseg;
-}
-EXPORT_SYMBOL(scsi_dma_map);
-
-/**
- * scsi_dma_unmap - unmap command's sg lists mapped by scsi_dma_map
- * @cmd:	scsi command
- */
-void scsi_dma_unmap(struct scsi_cmnd *cmd)
-{
-	if (scsi_sg_count(cmd)) {
-		struct device *dev = cmd->device->host->shost_gendev.parent;
-
-		dma_unmap_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
-			     cmd->sc_data_direction);
-	}
-}
-EXPORT_SYMBOL(scsi_dma_unmap);
diff -puN /dev/null drivers/scsi/scsi_lib_dma.c
--- /dev/null
+++ a/drivers/scsi/scsi_lib_dma.c
@@ -0,0 +1,50 @@
+/*
+ * SCSI library functions depending on DMA
+ */
+
+#include <linux/blkdev.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+/**
+ * scsi_dma_map - perform DMA mapping against command's sg lists
+ * @cmd:	scsi command
+ *
+ * Returns the number of sg lists actually used, zero if the sg lists
+ * is NULL, or -ENOMEM if the mapping failed.
+ */
+int scsi_dma_map(struct scsi_cmnd *cmd)
+{
+	int nseg = 0;
+
+	if (scsi_sg_count(cmd)) {
+		struct device *dev = cmd->device->host->shost_gendev.parent;
+
+		nseg = dma_map_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
+				  cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			return -ENOMEM;
+	}
+	return nseg;
+}
+EXPORT_SYMBOL(scsi_dma_map);
+
+/**
+ * scsi_dma_unmap - unmap command's sg lists mapped by scsi_dma_map
+ * @cmd:	scsi command
+ */
+void scsi_dma_unmap(struct scsi_cmnd *cmd)
+{
+	if (scsi_sg_count(cmd)) {
+		struct device *dev = cmd->device->host->shost_gendev.parent;
+
+		dma_unmap_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
+			     cmd->sc_data_direction);
+	}
+}
+EXPORT_SYMBOL(scsi_dma_unmap);
_
