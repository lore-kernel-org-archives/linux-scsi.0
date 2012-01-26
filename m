From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/2] Staging: hv: storvsc: Move the storage driver out of the staging area
Date: Thu, 26 Jan 2012 09:38:35 -0800
Message-ID: <1327599515-12679-2-git-send-email-kys@microsoft.com>
References: <1327599460-12593-1-git-send-email-kys@microsoft.com>
 <1327599515-12679-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1327599515-12679-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

The storage driver (storvsc_drv.c) handles all block storage devices
assigned to Linux guests hosted on Hyper-V. This driver has been in the
staging tree for a while and this patch moves it out of the staging area.

This patch is based on the storvsc patches that are already on Greg's queue
for the staging tree that addressed Christoph's review comments.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/Kconfig                       |    7 +++++++
 drivers/scsi/Makefile                      |    3 +++
 drivers/{staging/hv => scsi}/storvsc_drv.c |    0
 drivers/staging/Kconfig                    |    2 --
 drivers/staging/hv/Kconfig                 |    5 -----
 drivers/staging/hv/Makefile                |    3 ---
 drivers/staging/hv/TODO                    |    5 -----
 7 files changed, 10 insertions(+), 15 deletions(-)
 rename drivers/{staging/hv => scsi}/storvsc_drv.c (100%)
 delete mode 100644 drivers/staging/hv/Kconfig
 delete mode 100644 drivers/staging/hv/Makefile
 delete mode 100644 drivers/staging/hv/TODO

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 16570aa..d3d18e8 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -662,6 +662,13 @@ config VMWARE_PVSCSI
 	  To compile this driver as a module, choose M here: the
 	  module will be called vmw_pvscsi.
 
+config HYPERV_STORAGE
+	tristate "Microsoft Hyper-V virtual storage driver"
+	depends on SCSI && HYPERV
+	default HYPERV
+	help
+	  Select this option to enable the Hyper-V virtual storage driver.
+
 config LIBFC
 	tristate "LibFC module"
 	select SCSI_FC_ATTRS
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 2b88749..e4c1a69 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -142,6 +142,7 @@ obj-$(CONFIG_SCSI_BNX2_ISCSI)	+= libiscsi.o bnx2i/
 obj-$(CONFIG_BE2ISCSI)		+= libiscsi.o be2iscsi/
 obj-$(CONFIG_SCSI_PMCRAID)	+= pmcraid.o
 obj-$(CONFIG_VMWARE_PVSCSI)	+= vmw_pvscsi.o
+obj-$(CONFIG_HYPERV_STORAGE)	+= hv_storvsc.o
 
 obj-$(CONFIG_ARM)		+= arm/
 
@@ -170,6 +171,8 @@ scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 scsi_mod-y			+= scsi_trace.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 
+hv_storvsc-y			:= storvsc_drv.o
+
 scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_if.o
 
 sd_mod-objs	:= sd.o
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
similarity index 100%
rename from drivers/staging/hv/storvsc_drv.c
rename to drivers/scsi/storvsc_drv.c
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 21e2f4b..87beded 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -78,8 +78,6 @@ source "drivers/staging/vt6655/Kconfig"
 
 source "drivers/staging/vt6656/Kconfig"
 
-source "drivers/staging/hv/Kconfig"
-
 source "drivers/staging/vme/Kconfig"
 
 source "drivers/staging/sep/Kconfig"
diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
deleted file mode 100644
index 60ac479..0000000
--- a/drivers/staging/hv/Kconfig
+++ /dev/null
@@ -1,5 +0,0 @@
-config HYPERV_STORAGE
-	tristate "Microsoft Hyper-V virtual storage driver"
-	depends on HYPERV && SCSI
-	help
-	 Select this option to enable the Hyper-V virtual storage driver.
diff --git a/drivers/staging/hv/Makefile b/drivers/staging/hv/Makefile
deleted file mode 100644
index af95a6b..0000000
--- a/drivers/staging/hv/Makefile
+++ /dev/null
@@ -1,3 +0,0 @@
-obj-$(CONFIG_HYPERV_STORAGE)	+= hv_storvsc.o
-
-hv_storvsc-y := storvsc_drv.o
diff --git a/drivers/staging/hv/TODO b/drivers/staging/hv/TODO
deleted file mode 100644
index dea7d92..0000000
--- a/drivers/staging/hv/TODO
+++ /dev/null
@@ -1,5 +0,0 @@
-TODO:
-	- audit the scsi driver
-
-Please send patches for this code to Greg Kroah-Hartman <gregkh@suse.de>,
-Haiyang Zhang <haiyangz@microsoft.com>, and K. Y. Srinivasan <kys@microsoft.com>
-- 
1.7.4.1
