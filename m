From: Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] Allow SCSI_WAIT_SCAN to be deselected
Date: Thu, 13 Nov 2008 15:11:12 +0100
Message-ID: <1226585472-12559-1-git-send-email-bwalle@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYKMOLO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2008 09:11:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bernhard Walle <bwalle@suse.de>

This patch adds a proper help for SCSI_WAIT_SCAN and allows the module to be
deselected. I see no reason to force it being build. It also makes it
impossible to compile-in the module.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 drivers/scsi/Kconfig |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 403ecad..42b8355 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -257,10 +257,15 @@ config SCSI_SCAN_ASYNC
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate
+	tristate "Module to wait until all the async scans are complete"
 	default m
-	depends on SCSI
-	depends on MODULES
+	depends on SCSI && m
+    help
+      This is a simple module to wait until all the async scans are
+      complete.  The idea is to use it in initrd/initramfs scripts.  You
+      modprobe it after all the modprobes of the root SCSI drivers and it
+      will wait until they have all finished scanning their busses before
+      allowing the boot to proceed
 
 menu "SCSI Transports"
 	depends on SCSI
-- 
1.6.0.2

