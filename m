From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 27/36] Use menuconfig objects II - SCSI
Date: Mon, 30 Apr 2007 13:50:44 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704301349310.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailer.gwdg.de ([134.76.10.26]:56427 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030929AbXD3LwR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2007 07:52:17 -0400
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org


Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/scsi/Kconfig        |    8 ++++++--
 drivers/scsi/pcmcia/Kconfig |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/scsi/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/scsi/Kconfig
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
 
--- linux-2.6.21-mm_20070428.orig/drivers/scsi/pcmcia/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/scsi/pcmcia/Kconfig
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
