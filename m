From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH -next] scsi: RAID_ATTRS depends on SCSI
Date: Sun, 21 Feb 2010 19:46:36 -0800
Message-ID: <20100221194636.ef885e5a.rdunlap@xenotime.net>
References: <20100219174711.5e7cc7be.sfr@canb.auug.org.au>
	<4B7EC8AE.60200@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:45393 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754558Ab0BVDqi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Feb 2010 22:46:38 -0500
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sun, 21 Feb 2010 19:46:36 -0800
In-Reply-To: <4B7EC8AE.60200@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-next@vger.kernel.org, akpm <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>

From: Randy Dunlap <randy.dunlap@oracle.com>

raid_class uses scsi interfaces, so it should depend on SCSI.
Otherwise build errors occur when RAID_ATTRS=y and SCSI=m:

ERROR: "raid_class_release" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!
ERROR: "raid_class_attach" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-next-20100219.orig/drivers/scsi/Kconfig
+++ linux-next-20100219/drivers/scsi/Kconfig
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
@@ -34,6 +27,13 @@ config SCSI_DMA
 	bool
 	default n
 
+config RAID_ATTRS
+	tristate "RAID Transport Class"
+	default n
+	depends on BLOCK && SCSI
+	---help---
+	  Provides RAID
+
 config SCSI_TGT
 	tristate "SCSI target support"
 	depends on SCSI && EXPERIMENTAL
