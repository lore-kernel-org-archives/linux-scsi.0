From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] SCSI: update Kconfig help text to indicate SCSI core's
 widespread usage
Date: Fri, 14 Sep 2007 18:01:53 +0200 (CEST)
Message-ID: <tkrat.d922469e152fe0f3@s5r6.in-berlin.de>
References: <20070907124800.GP16806@vanheusden.com>
 <p73fy1p9m57.fsf@bingen.suse.de>
 <1189371621.3526.28.camel@localhost.localdomain>
 <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org>
 <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de>
 <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41999 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbXINQCm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 12:02:42 -0400
In-Reply-To: <46EAAAC1.3050409@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org
Cc: Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Applicable to 2.6.23-rc6 and to scsi-misc.

 drivers/scsi/Kconfig |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

Index: linux-2.6.23-rc6/drivers/scsi/Kconfig
===================================================================
--- linux-2.6.23-rc6.orig/drivers/scsi/Kconfig
+++ linux-2.6.23-rc6/drivers/scsi/Kconfig
@@ -12,23 +12,31 @@ config SCSI
 	depends on BLOCK
 	select SCSI_DMA if HAS_DMA
 	---help---
-	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
-	  any other SCSI device under Linux, say Y and make sure that you know
-	  the name of your SCSI host adapter (the card inside your computer
-	  that "speaks" the SCSI protocol, also called SCSI controller),
-	  because you will be asked for it.
-
-	  You also need to say Y here if you have a device which speaks
-	  the SCSI protocol.  Examples of this include the parallel port
-	  version of the IOMEGA ZIP drive, USB storage devices, Fibre
-	  Channel, FireWire storage and the IDE-SCSI emulation driver.
+	  This option enables core support for SCSI protocols.
+	  You need it
+	  - for classic parallel SCSI hardware,
+	  - for newer SCSI transports such as Fibre Channel, FireWire storage,
+	    or iSCSI,
+	  - for non-SCSI hardware which speaks SCSI protocols, such as USB
+	    storage devices or the parallel port version of Iomega Zip drive,
+	  - for non-SCSI hardware whose drivers translate from and to SCSI
+	    protocols, like the IDE-SCSI emulation driver and most notably
+	    for all SATA drivers.
 
 	  To compile this driver as a module, choose M here and read
 	  <file:Documentation/scsi/scsi.txt>.
 	  The module will be called scsi_mod.
 
 	  However, do not compile this as a module if your root file system
-	  (the one containing the directory /) is located on a SCSI device.
+	  (the one containing the directory /) is located on a SCSI device
+	  or on a device whose driver represents it as SCSI device, as
+	  indicated above.  Choose Y in this case, or set up an initrd.
+
+	  Subsequent options in this menu enable specific SCSI command set
+	  support for harddisks, CD/DVD-ROM/R/W, tapes etc..  This menu also
+	  presents options for specific SCSI controllers, while options for
+	  some other SCSI transports and all non-SCSI controllers are located
+	  in other menus (SATA, USB, FireWire etc.).
 
 config SCSI_DMA
 	bool
@@ -120,7 +128,7 @@ config BLK_DEV_SR
 	tristate "SCSI CDROM support"
 	depends on SCSI
 	---help---
-	  If you want to use a SCSI or FireWire CD-ROM under Linux,
+	  If you want to use a SCSI, SATA, USB or FireWire CD-ROM or DVD-ROM,
 	  say Y and read the SCSI-HOWTO and the CDROM-HOWTO at
 	  <http://www.tldp.org/docs.html#howto>. Also make sure to say
 	  Y or M to "ISO 9660 CD-ROM file system support" later.

-- 
Stefan Richter
-=====-=-=== =--= -===-
http://arcgraph.de/sr/

