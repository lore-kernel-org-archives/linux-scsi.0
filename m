From: Vincent Legoll <vincent.legoll@gmail.com>
Subject: [PATCH] Make "SCSI Transports" a menuconfig to ease disabling it all
Date: Sun,  2 Jul 2017 17:53:55 +0200
Message-ID: <1499010835-6858-1-git-send-email-vincent.legoll@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33462 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751682AbdGBPyI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jul 2017 11:54:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Vincent Legoll <vincent.legoll@gmail.com>

No need to get into the submenu to disable all SCSI Transports-related
config entries

Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
---
 drivers/scsi/Kconfig | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3c52867..53c97cc 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -251,9 +251,12 @@ config SCSI_SCAN_ASYNC
 	  Note that this setting also affects whether resuming from
 	  system suspend will be performed asynchronously.
 
-menu "SCSI Transports"
+menuconfig SCSI_TRANSPORTS
+	tristate "SCSI Transports"
 	depends on SCSI
 
+if SCSI_TRANSPORTS
+
 config SCSI_SPI_ATTRS
 	tristate "Parallel SCSI (SPI) Transport Attributes"
 	depends on SCSI
@@ -297,7 +300,7 @@ config SCSI_SRP_ATTRS
 	  If you wish to export transport-specific information about
 	  each attached SRP device to sysfs, say Y.
 
-endmenu
+endif # SCSI_TRANSPORTS
 
 menuconfig SCSI_LOWLEVEL
 	bool "SCSI low-level drivers"
-- 
2.7.4
