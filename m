From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH] [SCSI] Create menu entry for the SCSI_WAIT_SCAN config variable
Date: Thu, 30 Oct 2008 17:59:51 +0200
Message-ID: <1225382391-8145-1-git-send-email-dmitri.vorobiev@movial.fi>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.movial.fi ([62.236.91.34]:50216 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbYJ3QXQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 12:23:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>

The scsi_wait_scan module lacks a menu entry and help text. The
patch adds those, and also makes the module disabled by default,
so that it is compiled only for those targets, which consciously
need it.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/scsi/Kconfig |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 403ecad..1adb52c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -257,10 +257,18 @@ config SCSI_SCAN_ASYNC
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate
-	default m
+	tristate "Waiter module for asyncronous SCSI scanning"
+	default n
 	depends on SCSI
 	depends on MODULES
+	help
+	  This is a simple module to wait until all the async scans are
+	  complete.  The idea is to use it in initrd/initramfs scripts.
+	  You modprobe it after all the modprobes of the root SCSI drivers
+	  and it will wait until they have all finished scanning their
+	  busses before allowing the boot to proceed.
+
+	  If unsure, say N.
 
 menu "SCSI Transports"
 	depends on SCSI
-- 
1.5.6.5

