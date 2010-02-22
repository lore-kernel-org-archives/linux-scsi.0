From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
Subject: [Patch]: Enable SCSI Wait Scan only if BLK_DEV_INITRD is set.
Date: Mon, 22 Feb 2010 23:53:31 +0100
Message-ID: <4B830AEB.3010905@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:52839 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab0BVWxp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2010 17:53:45 -0500
Received: by fxm19 with SMTP id 19so3096956fxm.21
        for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2010 14:53:43 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi,

The scsi_wait_scan module should only be enabled if BLKD_DEV_INITRD is 
set. And i think it's better then the user can enable/disable the module 
of their own risk.

Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>

========================================================================

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9191d1e..b785703 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -258,21 +258,22 @@ config SCSI_SCAN_ASYNC
  	  or async on the kernel's command line.

  config SCSI_WAIT_SCAN
-	tristate  # No prompt here, this is an invisible symbol.
+	tristate "SCSI Wait Scan"
  	default m
  	depends on SCSI
+	depends on SCSI_SCAN_ASYNC
  	depends on MODULES
-# scsi_wait_scan is a loadable module which waits until all the async 
scans are
-# complete.  The idea is to use it in initrd/ initramfs scripts.  You 
modprobe
-# it after all the modprobes of the root SCSI drivers and it will wait 
until
-# they have all finished scanning their buses before allowing the boot to
-# proceed.  (This method is not applicable if targets boot independently in
-# parallel with the initiator, or with transports with 
non-deterministic target
-# discovery schemes, or if a transport driver does not support 
scsi_wait_scan.)
-#
-# This symbol is not exposed as a prompt because little is to be gained by
-# disabling it, whereas people who accidentally switch it off may 
wonder why
-# their mkinitrd gets into trouble.
+	depends on BLK_DEV_INITRD
+	help
+	  scsi_wait_scan is a loadable module which waits until all the async 
scans are
+	  complete.  The idea is to use it in initrd/ initramfs scripts.  You 
modprobe
+	  it after all the modprobes of the root SCSI drivers and it will wait 
until
+	  they have all finished scanning their buses before allowing the boot to
+	  proceed.  (This method is not applicable if targets boot 
independently in
+	  parallel with the initiator, or with transports with 
non-deterministic target
+	  discovery schemes, or if a transport driver does not support 
scsi_wait_scan.)
+
+	  People that use a initramfs should say Y or M.

  menu "SCSI Transports"
  	depends on SCSI
