From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 2/2] scsi: fix kconfig dependency warnings
Date: Tue, 17 Aug 2010 11:36:56 -0700
Message-ID: <20100817113656.c4191013.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:32969 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab0HQSio (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2010 14:38:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <james.bottomley@suse.de>, Ralf Baechle <ralf@linux-mips.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warnings in scsi/Kconfig:

warning: (SCSI_SAS_LIBSAS && SCSI || SCSI_MPT2SAS && SCSI_LOWLEVEL && PCI && SCSI || FUSION_SAS && FUSION && PCI && SCSI) selects SCSI_SAS_ATTRS which has unmet direct dependencies (SCSI && BLK_DEV_BSG)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Ralf Baechle <ralf@linux-mips.org>
---
 drivers/scsi/Kconfig        |    3 ++-
 drivers/scsi/libsas/Kconfig |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- linux-next-20100810.orig/drivers/scsi/libsas/Kconfig
+++ linux-next-20100810/drivers/scsi/libsas/Kconfig
@@ -26,6 +26,7 @@ config SCSI_SAS_LIBSAS
 	tristate "SAS Domain Transport Attributes"
 	depends on SCSI
 	select SCSI_SAS_ATTRS
+	select BLK_DEV_BSG
 	help
 	  This provides transport specific helpers for SAS drivers which
 	  use the domain device construct (like the aic94xxx).
--- linux-next-20100810.orig/drivers/scsi/Kconfig
+++ linux-next-20100810/drivers/scsi/Kconfig
@@ -316,7 +316,8 @@ config SCSI_ISCSI_ATTRS
 
 config SCSI_SAS_ATTRS
 	tristate "SAS Transport Attributes"
-	depends on SCSI && BLK_DEV_BSG
+	depends on SCSI
+	select BLK_DEV_BSG
 	help
 	  If you wish to export transport-specific information about
 	  each attached SAS device to sysfs, say Y.
