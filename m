From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 2/2 v2] scsi: fix kconfig dependency warnings
Date: Wed, 18 Aug 2010 09:28:43 -0700
Message-ID: <20100818092843.e742cf3f.randy.dunlap@oracle.com>
References: <20100817113656.c4191013.randy.dunlap@oracle.com>
	<1282141726.3035.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:50108 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0HRQ3P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2010 12:29:15 -0400
In-Reply-To: <1282141726.3035.8.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: scsi <linux-scsi@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>

Thanks for your comments.


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warnings in scsi/Kconfig:

warning: (SCSI_SAS_LIBSAS && SCSI || SCSI_MPT2SAS && SCSI_LOWLEVEL && PCI && SCSI || FUSION_SAS && FUSION && PCI && SCSI) selects SCSI_SAS_ATTRS which has unmet direct dependencies (SCSI && BLK_DEV_BSG)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Ralf Baechle <ralf@linux-mips.org>
---
 drivers/scsi/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20100817.orig/drivers/scsi/Kconfig
+++ linux-next-20100817/drivers/scsi/Kconfig
@@ -316,7 +316,8 @@ config SCSI_ISCSI_ATTRS
 
 config SCSI_SAS_ATTRS
 	tristate "SAS Transport Attributes"
-	depends on SCSI && BLK_DEV_BSG
+	depends on SCSI
+	select BLK_DEV_BSG
 	help
 	  If you wish to export transport-specific information about
 	  each attached SAS device to sysfs, say Y.
