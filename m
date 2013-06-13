From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 10/10] [RFC] SCSI: esas2r: Add Makefile, Kconfig, and MAINTAINERS files
Date: Thu, 13 Jun 2013 10:31:08 -0400
Message-ID: <1371133868-13794-11-git-send-email-bgrove@attotech.com>
References: <1371133868-13794-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:14367 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758057Ab3FMOrE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jun 2013 10:47:04 -0400
In-Reply-To: <1371133868-13794-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jseba@attotech.com, jbottomley@parallels.com, Bradley Grove <bgrove@attotech.com>


Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 MAINTAINERS                  | 9 ++++++++-
 drivers/scsi/Kconfig         | 1 +
 drivers/scsi/Makefile        | 1 +
 drivers/scsi/esas2r/Kconfig  | 6 ++++++
 drivers/scsi/esas2r/Makefile | 6 ++++++
 5 files changed, 22 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/esas2r/Kconfig
 create mode 100644 drivers/scsi/esas2r/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 0c9dc71..e789b3f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1401,6 +1401,13 @@ W:	http://wireless.kernel.org/en/users/Drivers/ath9k
 S:	Supported
 F:	drivers/net/wireless/ath/ath9k/
 
+ATTO EXPRESSSAS SAS/SATA RAID SCSI DRIVER
+M:    Bradley Grove <linuxdrivers@attotech.com>
+L:    linux-scsi@vger.kernel.org
+W:    http://www.attotech.com
+S:    Supported
+F:    drivers/scsi/esas2r
+
 WILOCITY WIL6210 WIRELESS DRIVER
 M:	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
 L:	linux-wireless@vger.kernel.org
@@ -5766,7 +5773,7 @@ M:	Matthew Wilcox <willy@linux.intel.com>
 L:	linux-nvme@lists.infradead.org
 T:	git git://git.infradead.org/users/willy/linux-nvme.git
 S:	Supported
-F:	drivers/block/nvme*
+F:	drivers/block/nvme.c
 F:	include/linux/nvme.h
 
 OMAP SUPPORT
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 86af29f..846feea 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -601,6 +601,7 @@ config SCSI_ARCMSR
 	  To compile this driver as a module, choose M here: the
 	  module will be called arcmsr (modprobe arcmsr).
 
+source "drivers/scsi/esas2r/Kconfig"
 source "drivers/scsi/megaraid/Kconfig.megaraid"
 source "drivers/scsi/mpt2sas/Kconfig"
 source "drivers/scsi/mpt3sas/Kconfig"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index b607ba4..149bb6b 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -141,6 +141,7 @@ obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+= libiscsi.o libiscsi_tcp.o cxgbi/
 obj-$(CONFIG_SCSI_CXGB4_ISCSI)	+= libiscsi.o libiscsi_tcp.o cxgbi/
 obj-$(CONFIG_SCSI_BNX2_ISCSI)	+= libiscsi.o bnx2i/
 obj-$(CONFIG_BE2ISCSI)		+= libiscsi.o be2iscsi/
+obj-$(CONFIG_SCSI_ESAS2R)	+= esas2r/
 obj-$(CONFIG_SCSI_PMCRAID)	+= pmcraid.o
 obj-$(CONFIG_SCSI_VIRTIO)	+= virtio_scsi.o
 obj-$(CONFIG_VMWARE_PVSCSI)	+= vmw_pvscsi.o
diff --git a/drivers/scsi/esas2r/Kconfig b/drivers/scsi/esas2r/Kconfig
new file mode 100644
index 0000000..80824f0
--- /dev/null
+++ b/drivers/scsi/esas2r/Kconfig
@@ -0,0 +1,5 @@
+config SCSI_ESAS2R
+	tristate "ATTO Technology's ExpressSAS RAID adapter driver"
+	depends on PCI && SCSI
+	---help---
+	  This driver supports the ATTO ExpressSAS R6xx SAS/SATA RAID controllers.
diff --git a/drivers/scsi/esas2r/Makefile b/drivers/scsi/esas2r/Makefile
new file mode 100644
index 0000000..526d199
--- /dev/null
+++ b/drivers/scsi/esas2r/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_SCSI_ESAS2R)	+= esas2r.o
+
+esas2r-objs := esas2r_log.o esas2r_disc.o esas2r_flash.o esas2r_init.o \
+	 esas2r_int.o esas2r_io.o esas2r_ioctl.o esas2r_targdb.o   \
+	 esas2r_vda.o esas2r_main.o
-- 
1.8.1.4

