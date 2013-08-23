From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH v4 10/10] SCSI: esas2r: Add Makefile, Kconfig, and MAINTAINERS files
Date: Fri, 23 Aug 2013 10:35:54 -0400
Message-ID: <1377268554-25898-11-git-send-email-bgrove@attotech.com>
References: <1377268554-25898-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:40939 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754001Ab3HWOgO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Aug 2013 10:36:14 -0400
In-Reply-To: <1377268554-25898-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, Bradley Grove <bgrove@attotech.com>


Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 MAINTAINERS                  | 7 +++++++
 drivers/scsi/Kconfig         | 1 +
 drivers/scsi/Makefile        | 1 +
 drivers/scsi/esas2r/Kconfig  | 6 ++++++
 drivers/scsi/esas2r/Makefile | 5 +++++
 5 files changed, 20 insertions(+)
 create mode 100644 drivers/scsi/esas2r/Kconfig
 create mode 100644 drivers/scsi/esas2r/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 7cacc88..0a85613 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1547,6 +1547,13 @@ W:	http://atmelwlandriver.sourceforge.net/
 S:	Maintained
 F:	drivers/net/wireless/atmel*
 
+ATTO EXPRESSSAS SAS/SATA RAID SCSI DRIVER
+M:      Bradley Grove <linuxdrivers@attotech.com>
+L:      linux-scsi@vger.kernel.org
+W:      http://www.attotech.com
+S:      Supported
+F:      drivers/scsi/esas2r
+
 AUDIT SUBSYSTEM
 M:	Al Viro <viro@zeniv.linux.org.uk>
 M:	Eric Paris <eparis@redhat.com>
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 48b2918..c298b76 100644
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
index 0000000..c77160b
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

