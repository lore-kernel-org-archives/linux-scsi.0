From: akpm@linux-foundation.org
Subject: [patch 27/28] Use menuconfig objects II - SCSI
Date: Thu, 10 May 2007 23:01:11 -0700
Message-ID: <200705110601.l4B61BVm008199@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758574AbXEKGJS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 02:09:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jengelh@linux01.gwdg.de, jengelh@gmx.de

From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig        |    8 ++++++--
 drivers/scsi/pcmcia/Kconfig |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/Kconfig~use-menuconfig-objects-ii-scsi drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~use-menuconfig-objects-ii-scsi
+++ a/drivers/scsi/Kconfig
@@ -285,8 +285,12 @@ source "drivers/scsi/libsas/Kconfig"
 
 endmenu
 
-menu "SCSI low-level drivers"
+menuconfig SCSI_LOWLEVEL
+	bool "SCSI low-level drivers"
 	depends on SCSI!=n
+	default y
+
+if SCSI_LOWLEVEL
 
 config ISCSI_TCP
 	tristate "iSCSI Initiator over TCP/IP"
@@ -1795,7 +1799,7 @@ config SCSI_SRP
 	  To compile this driver as a module, choose M here: the
 	  module will be called libsrp.
 
-endmenu
+endif # SCSI_LOWLEVEL
 
 source "drivers/scsi/pcmcia/Kconfig"
 
diff -puN drivers/scsi/pcmcia/Kconfig~use-menuconfig-objects-ii-scsi drivers/scsi/pcmcia/Kconfig
--- a/drivers/scsi/pcmcia/Kconfig~use-menuconfig-objects-ii-scsi
+++ a/drivers/scsi/pcmcia/Kconfig
@@ -2,8 +2,12 @@
 # PCMCIA SCSI adapter configuration
 #
 
-menu "PCMCIA SCSI adapter support"
+menuconfig SCSI_LOWLEVEL_PCMCIA
+	bool "PCMCIA SCSI adapter support"
 	depends on SCSI!=n && PCMCIA!=n
+	default y
+
+if SCSI_LOWLEVEL_PCMCIA
 
 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
@@ -77,4 +81,4 @@ config PCMCIA_SYM53C500
 	  To compile this driver as a module, choose M here: the
 	  module will be called sym53c500_cs.
 
-endmenu
+endif # SCSI_LOWLEVEL_PCMCIA
_
