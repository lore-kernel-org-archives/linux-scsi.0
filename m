From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH v2] block: move RAID transport class to BLOCK menu
Date: Sun, 04 Nov 2007 11:39:03 -0800
Message-ID: <472E1FD7.1010508@oracle.com>
References: <20071104104423.d595c0e7.randy.dunlap@oracle.com> <20071104185806.GV15111@parisc-linux.org> <472E16BA.4090708@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:39011 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbXKDTju (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Nov 2007 14:39:50 -0500
In-Reply-To: <472E16BA.4090708@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>, Jens Axboe <jens.axboe@oracle.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Move RAID class configuration to the BLOCK menu since it is not
SCSI-specific.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 block/Kconfig        |    5 +++++
 drivers/scsi/Kconfig |    7 -------
 2 files changed, 5 insertions(+), 7 deletions(-)

--- linux-2.6.24-rc1-git13.orig/block/Kconfig
+++ linux-2.6.24-rc1-git13/block/Kconfig
@@ -62,6 +62,11 @@ config BLK_DEV_BSG
 	protocols (e.g. Task Management Functions and SMP in Serial
 	Attached SCSI).
 
+config RAID_ATTRS
+	tristate "RAID Transport Class"
+	---help---
+	  Provides RAID class information in sysfs.
+
 endif # BLOCK
 
 config BLOCK_COMPAT
--- linux-2.6.24-rc1-git13.orig/drivers/scsi/Kconfig
+++ linux-2.6.24-rc1-git13/drivers/scsi/Kconfig
@@ -1,12 +1,5 @@
 menu "SCSI device support"
 
-config RAID_ATTRS
-	tristate "RAID Transport Class"
-	default n
-	depends on BLOCK
-	---help---
-	  Provides RAID
-
 config SCSI
 	tristate "SCSI device support"
 	depends on BLOCK
