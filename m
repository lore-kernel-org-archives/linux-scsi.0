From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] scsi: make scsi_devinfo infrastructure optional
Date: Wed, 9 Feb 2011 15:15:15 +0100
Message-ID: <201102091515.16202.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49014 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab1BIOR7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 09:17:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Add SCSI_QUIRKS config option (default y and dependent on EMBEDDED
config option) to allow disabling of scsi_devinfo infrastructure.

The output code size savings are ~14k for CONFIG_SCSI_QUIRKS=n
(as measured on x86-32):

CONFIG_SCSI_QUIRKS=y:
   text    data     bss     dec     hex filename
  47342    4368     628   52338    cc72 drivers/scsi/scsi_mod.o
   3897    2776     260    6933    1b15 drivers/scsi/scsi_devinfo.o

CONFIG_SCSI_QUIRKS=n:
   text    data     bss     dec     hex filename
  42968    1592     368   44928    af80 drivers/scsi/scsi_mod.o

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Using CONFIG_SCSI_QUIRKS=n it was possible to shrink the binary
code size of the minimal SCSI core configuration by 14% (as measured
on x86-32 few kernel versions ago)..

 drivers/scsi/Kconfig     |    9 +++++++++
 drivers/scsi/Makefile    |    3 ++-
 drivers/scsi/scsi_priv.h |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 1 deletion(-)

Index: b/drivers/scsi/Kconfig
===================================================================
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -47,6 +47,15 @@ config SCSI_TGT
 	  If you want to use SCSI target mode drivers enable this option.
 	  If you choose M, the module will be called scsi_tgt.
 
+config SCSI_QUIRKS
+	bool "SCSI quirks support" if EMBEDDED
+	default y
+	help
+	  This option enables support for devices that require settings
+	  that differ from the default.
+
+	  If unsure say Y.
+
 config SCSI_NETLINK
 	bool
 	default	n
Index: b/drivers/scsi/Makefile
===================================================================
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -160,7 +160,8 @@ obj-$(CONFIG_SCSI_WAIT_SCAN)	+= scsi_wai
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
 				   scsicam.o scsi_error.o scsi_lib.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
-scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
+scsi_mod-y			+= scsi_scan.o scsi_sysfs.o
+scsi_mod-$(CONFIG_SCSI_QUIRKS)	+= scsi_devinfo.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
Index: b/drivers/scsi/scsi_priv.h
===================================================================
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -47,6 +47,7 @@ enum {
 	SCSI_DEVINFO_SPI,
 };
 
+#ifdef CONFIG_SCSI_QUIRKS
 extern int scsi_get_device_flags(struct scsi_device *sdev,
 				 const unsigned char *vendor,
 				 const unsigned char *model);
@@ -61,6 +62,38 @@ extern int scsi_dev_info_remove_list(int
 
 extern int __init scsi_init_devinfo(void);
 extern void scsi_exit_devinfo(void);
+#else
+static inline int scsi_get_device_flags(struct scsi_device *sdev,
+					const unsigned char *vendor,
+					const unsigned char *model)
+{
+	return 0;
+}
+static inline int scsi_get_device_flags_keyed(struct scsi_device *sdev,
+					      const unsigned char *vendor,
+					      const unsigned char *model,
+					      int key)
+{
+	return 0;
+}
+static inline int scsi_dev_info_list_add_keyed(int compatible, char *vendor,
+					       char *model, char *strflags,
+					       int flags, int key)
+{
+	return 0;
+}
+static inline int scsi_dev_info_add_list(int key, const char *name)
+{
+	return 0;
+}
+static inline int scsi_dev_info_remove_list(int key)
+{
+	return 0;
+}
+
+static inline int scsi_init_devinfo(void) { return 0; }
+static inline void scsi_exit_devinfo(void) { }
+#endif
 
 /* scsi_error.c */
 extern enum blk_eh_timer_return scsi_times_out(struct request *req);
