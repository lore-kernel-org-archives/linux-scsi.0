From: akpm@linux-foundation.org
Subject: [patch 08/30] Use menuconfig objects: Fusion
Date: Fri, 10 Aug 2007 14:50:37 -0700
Message-ID: <200708102150.l7ALobVP011338@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752025AbXHJVvd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:51:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jengelh@computergmbh.de, Eric.Moore@lsil.com, jengelh@gmx.de

From: Jan Engelhardt <jengelh@computergmbh.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/Kconfig |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/message/fusion/Kconfig~use-menuconfig-objects-fusion drivers/message/fusion/Kconfig
--- a/drivers/message/fusion/Kconfig~use-menuconfig-objects-fusion
+++ a/drivers/message/fusion/Kconfig
@@ -1,15 +1,19 @@
 
-menu "Fusion MPT device support"
+menuconfig FUSION
+	bool "Fusion MPT device support"
 	depends on PCI
+	---help---
+	Say Y here to get to see options for Fusion Message
+	Passing Technology (MPT) drivers.
+	This option alone does not add any kernel code.
+
+	If you say N, all options in this submenu will be skipped and disabled.
 
-config FUSION
-	bool
-	default n
+if FUSION
 
 config FUSION_SPI
 	tristate "Fusion MPT ScsiHost drivers for SPI"
 	depends on PCI && SCSI
-	select FUSION
 	select SCSI_SPI_ATTRS
 	---help---
 	  SCSI HOST support for a parallel SCSI host adapters.
@@ -24,7 +28,6 @@ config FUSION_SPI
 config FUSION_FC
 	tristate "Fusion MPT ScsiHost drivers for FC"
 	depends on PCI && SCSI
-	select FUSION
 	select SCSI_FC_ATTRS
 	---help---
 	  SCSI HOST support for a Fiber Channel host adapters.
@@ -42,7 +45,6 @@ config FUSION_FC
 config FUSION_SAS
 	tristate "Fusion MPT ScsiHost drivers for SAS"
 	depends on PCI && SCSI
- 	select FUSION
 	select SCSI_SAS_ATTRS
 	---help---
 	  SCSI HOST support for a SAS host adapters.
@@ -56,7 +58,6 @@ config FUSION_SAS
 
 config FUSION_MAX_SGE
 	int "Maximum number of scatter gather entries (16 - 128)"
-	depends on FUSION
 	default "128"
 	range 16 128
 	help
@@ -116,4 +117,4 @@ config FUSION_LOGGING
 	  There are various debug levels that an be found in the source:
 	  file:drivers/message/fusion/mptdebug.h
 
-endmenu
+endif # FUSION
_
