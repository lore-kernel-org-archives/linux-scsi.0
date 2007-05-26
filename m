From: Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH] add help to WAIT_SCAN option
Date: Sat, 26 May 2007 13:11:27 -0600
Message-ID: <20070526191127.GB7080@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:43329 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbXEZTbh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 May 2007 15:31:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, Thibaut VARENE <T-Bone@parisc-linux.org>

Thibaut Varene's parisc box didn't find the root disk.
Problem is he had ASYNC_SCAN enabled and the required SYM2 driver builtin
but the root disk wasn't discovered before the kernel wanted to mount root.
Oh, and he (like many folks who build their own kernels) didn't use
an initrd or initramfs. So no chance to load scsi_wait_scan module.

This patch enables one to select "y" for WAIT_SCAN option and adds
help text on how/when to use "m" vs "y".

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>


diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d28c14e..a2eefb2 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -235,17 +235,31 @@ config SCSI_SCAN_ASYNC
 	  be a problem as the devices may not have been found by the
 	  time your system expects them to have been.  You can load the
 	  scsi_wait_scan module to ensure that all scans have completed.
+	  (Requires SCSI_WAIT_SCAN config option be enabled).
 	  If you build your SCSI drivers into the kernel, then everything
-	  will work fine if you say Y here.
+	  will work fine if you say Y here and Y to SCSI_WAIT_SCAN option.
 
 	  You can override this choice by specifying "scsi_mod.scan=sync"
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate
+	tristate "Wait until all async SCSI bus scans have completed?"
 	default m
 	depends on SCSI
 	depends on MODULES
+	help
+	  This module will not allow the boot to proceed until all
+	  the async SCSI bus scans are complete. This is needed
+	  if the root disk is not discovered before the kernel
+	  init sequence attempts to mount root.
+
+	  To use WITH an initrd/initramfs, say "m" (default) and set up
+	  the init scripts to "modprobe scsi_wait_scan" after all the
+	  SCSI HBA drivers have been loaded.
+
+	  To use WITHOUT an initrd/initramfs, say "y" and make sure
+	  all SCSI HBA drivers needed to auto-mount all file systems
+	  (including the root disk) are also "y".
 
 menu "SCSI Transports"
 	depends on SCSI
