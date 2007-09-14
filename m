From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] SCSI: update Kconfig help text to indicate SCSI core's
 widespread usage
Date: Fri, 14 Sep 2007 23:06:44 +0200 (CEST)
Message-ID: <tkrat.f4379d6e5f1ce499@s5r6.in-berlin.de>
References: <1189371621.3526.28.camel@localhost.localdomain>
 <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org>
 <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de>
 <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de>
 <tkrat.d922469e152fe0f3@s5r6.in-berlin.de>
 <20070914185434.GD5386@csclub.uwaterloo.ca>
 <tkrat.e1d898d6a272d681@s5r6.in-berlin.de>
 <20070914202102.GE5386@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759904AbXINVIP@vger.kernel.org>
In-Reply-To: <20070914202102.GE5386@csclub.uwaterloo.ca>
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 14 Sep, Lennart Sorensen wrote:
> On Fri, Sep 14, 2007 at 10:14:16PM +0200, Stefan Richter wrote:
>> -	  If you want to use a SCSI or FireWire CD-ROM under Linux,
>> +	  If you want to use a SCSI, SATA, USB or FireWire CD-ROM or DVD-ROM,
>>  	  say Y and read the SCSI-HOWTO and the CDROM-HOWTO at
>>  	  <http://www.tldp.org/docs.html#howto>. Also make sure to say
>>  	  Y or M to "ISO 9660 CD-ROM file system support" later.
> 
> How about that one for libata driven PATA CDROM drives?  Could replace
> SATA with libata, or something similar.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: SCSI: update Kconfig help text to indicate SCSI core's widespread usage

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/scsi/Kconfig |   67 ++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 32 deletions(-)

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
+	    protocols, most notably all Serial ATA drivers, and Parallel ATA
+	    via the ATA configuration option.
 
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
@@ -57,32 +65,27 @@ config SCSI_PROC_FS
 
 	  If unsure say Y.
 
-comment "SCSI support type (disk, tape, CD-ROM)"
+comment "SCSI command set drivers (disk, tape, CD-ROM)"
 	depends on SCSI
 
 config BLK_DEV_SD
-	tristate "SCSI disk support"
+	tristate "Harddisks and other Direct access devices"
 	depends on SCSI
 	---help---
-	  If you want to use SCSI hard disks, Fibre Channel disks,
-	  Serial ATA (SATA) or Parallel ATA (PATA) hard disks,
-	  USB storage or the SCSI or parallel port version of
-	  the IOMEGA ZIP drive, say Y and read the SCSI-HOWTO,
-	  the Disk-HOWTO and the Multi-Disk-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>. This is NOT for SCSI
-	  CD-ROMs.
+	  Say Y if you want to use harddisks and similar block-oriented devices
+	  via SCSI or via drivers which use SCSI command sets (e.g. the Serial
+	  and Parallel ATA kernel subsystem, USB, and more).
 
 	  To compile this driver as a module, choose M here and read
 	  <file:Documentation/scsi/scsi.txt>.
 	  The module will be called sd_mod.
 
-	  Do not compile this driver as a module if your root file system
-	  (the one containing the directory /) is located on a SCSI disk.
-	  In this case, do not compile the driver for your SCSI host adapter
-	  (below) as a module either.
+	  If your root file system (the one containing the directory /) is
+	  located on a disk which accessed via this driver, choose Y instead of
+	  M or set up a suitable initrd.
 
 config CHR_DEV_ST
-	tristate "SCSI tape support"
+	tristate "Tape drives"
 	depends on SCSI
 	---help---
 	  If you want to use a SCSI tape drive under Linux, say Y and read the
@@ -95,7 +98,7 @@ config CHR_DEV_ST
 	  <file:Documentation/scsi/scsi.txt>. The module will be called st.
 
 config CHR_DEV_OSST
-	tristate "SCSI OnStream SC-x0 tape support"
+	tristate "SCSI OnStream SC-x0 tape drives"
 	depends on SCSI
 	---help---
 	  The OnStream SC-x0 SCSI tape drives cannot be driven by the
@@ -117,13 +120,13 @@ config CHR_DEV_OSST
 	  <file:Documentation/scsi/scsi.txt>. The module will be called osst.
 
 config BLK_DEV_SR
-	tristate "SCSI CDROM support"
+	tristate "CD-ROMs, DVD-ROMs"
 	depends on SCSI
 	---help---
-	  If you want to use a SCSI or FireWire CD-ROM under Linux,
-	  say Y and read the SCSI-HOWTO and the CDROM-HOWTO at
-	  <http://www.tldp.org/docs.html#howto>. Also make sure to say
-	  Y or M to "ISO 9660 CD-ROM file system support" later.
+	  Say Y if you want to use CD-ROMs or DVD-ROMs via SCSI or via drivers
+	  which use SCSI command sets (e.g. the Serial and Parallel ATA kernel
+	  subsystem, USB, and more). Also make sure to say Y or M to "ISO 9660
+	  CD-ROM file system support" later.
 
 	  To compile this driver as a module, choose M here and read
 	  <file:Documentation/scsi/scsi.txt>.
@@ -164,7 +167,7 @@ config CHR_DEV_SG
 	  If unsure, say N.
 
 config CHR_DEV_SCH
-	tristate "SCSI media changer support"
+	tristate "SCSI media changers"
 	depends on SCSI
 	---help---
 	  This is a driver for SCSI media changers.  Most common devices are

-- 
Stefan Richter
-=====-=-=== =--= -===-
http://arcgraph.de/sr/
