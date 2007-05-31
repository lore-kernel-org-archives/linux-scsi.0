From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: 2.6.22-rc3-mm1
Date: Thu, 31 May 2007 14:09:22 +0200
Message-ID: <20070531140922.2e55aefb@gondolin.boeblingen.de.ibm.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:7539 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459AbXEaMJX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 May 2007 08:09:23 -0400
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Dan Williams <dan.j.williams@intel.com>

On Wed, 30 May 2007 23:58:23 -0700,
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/

With 

> +dma-mapping-prevent-dma-dependent-code-from-linking-on.patch

scsi fails to build on !HAS_DMA architectures:

drivers/built-in.o(.text+0x20af6): In function `scsi_dma_map':
: undefined reference to `dma_map_sg'
drivers/built-in.o(.text+0x20b5c): In function `scsi_dma_unmap':
: undefined reference to `dma_unmap_sg'

I split those functions out into a new file. Builds on s390 and i386.



scsi: Don't build scsi_dma_{map,unmap} for !HAS_DMA

Move scsi_dma_{map,unmap} into scsi_lib_dma.c which is only build
if HAS_DMA is set.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/scsi/Kconfig        |    5 ++++
 drivers/scsi/Makefile       |    6 ++---
 drivers/scsi/scsi_lib.c     |   38 ---------------------------------
 drivers/scsi/scsi_lib_dma.c |   50 ++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h    |    2 +
 5 files changed, 60 insertions(+), 41 deletions(-)

--- linux-2.6.orig/drivers/scsi/Kconfig
+++ linux-2.6/drivers/scsi/Kconfig
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
--- linux-2.6.orig/drivers/scsi/Makefile
+++ linux-2.6/drivers/scsi/Makefile
@@ -145,9 +145,9 @@ obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
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
--- linux-2.6.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6/drivers/scsi/scsi_lib.c
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
--- linux-2.6.orig/include/scsi/scsi_cmnd.h
+++ linux-2.6/include/scsi/scsi_cmnd.h
@@ -135,8 +135,10 @@ extern void scsi_kunmap_atomic_sg(void *
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
 extern void scsi_free_sgtable(struct scatterlist *, int);
 
+#ifdef CONFIG_SCSI_DMA
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
+#endif
 
 #define scsi_sg_count(cmd) ((cmd)->use_sg)
 #define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
--- /dev/null
+++ linux-2.6/drivers/scsi/scsi_lib_dma.c
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
