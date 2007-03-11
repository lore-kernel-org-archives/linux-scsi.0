From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] make scsi_wait_scan always modular
Date: Sun, 11 Mar 2007 14:16:43 -0500
Message-ID: <1173640604.3420.21.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55696 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964806AbXCKTQp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Mar 2007 15:16:45 -0400
Received: from [172.17.6.40] (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id l2BJGix14187
	for <linux-scsi@vger.kernel.org>; Sun, 11 Mar 2007 14:16:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Currently scsi_wait_scan is only built modular if SCSI is modular.
However, it's perfectly possible for a built in SCSI still to have
modular drivers and thus need scsi_wait_scan as a module.  Therefore,
scsi_wait_scan should always be built as a module (unless the kernel
doesn't support modules).

James

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4cd280e..f3bc0f4 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -241,6 +241,12 @@ config SCSI_SCAN_ASYNC
 	  You can override this choice by specifying "scsi_mod.scan=sync"
 	  or async on the kernel's command line.
 
+config SCSI_WAIT_SCAN
+	tristate
+	default m
+	depends on SCSI
+	depends on MODULES
+
 menu "SCSI Transports"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 79ecf4e..41c7883 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -145,7 +145,7 @@ obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 
-obj-$(CONFIG_SCSI)		+= scsi_wait_scan.o
+obj-$(CONFIG_SCSI_WAIT_SCAN)	+= scsi_wait_scan.o
 
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
 				   scsicam.o scsi_error.o scsi_lib.o \


