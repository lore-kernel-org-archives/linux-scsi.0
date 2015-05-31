From: Finn Thain <fthain@telegraphics.com.au>
Subject: [RFC 02/24] scsi/atari_scsi: Dont select CONFIG_NVRAM
Date: Sun, 31 May 2015 11:01:34 +1000
Message-ID: <20150531010132.799505414@telegraphics.com.au>
References: <20150531010132.289674310@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari-nvram-disable
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On powerpc, setting CONFIG_NVRAM=n builds a kernel with no NVRAM support.
Setting CONFIG_NVRAM=m enables the /dev/nvram misc device module without
enabling NVRAM support in drivers. Setting CONFIG_NVRAM=y enables the
misc device (built-in) and also enables NVRAM support in drivers.

m68k shares the valkyriefb driver with powerpc, and since that driver uses
NVRAM, it is affected by CONFIG_ATARI_SCSI, because of the use of
"select NVRAM".

Adopt the powerpc convention on m68k to avoid surprises.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

This patch temporarily disables CONFIG_NVRAM on Atari, to prevent build
failures when bisecting the rest of this patch series. It gets enabled
again with the introduction of CONFIG_HAVE_ARCH_NVRAM_OPS, once the
nvram_* global functions have been moved to an ops struct.

The removal of "select NVRAM" may mean that some kernel configs (such
as Debian/m68k) may need tweaking.

---
 drivers/char/Kconfig      |    5 +----
 drivers/scsi/Kconfig      |    6 +++---
 drivers/scsi/atari_scsi.c |    8 ++++----
 3 files changed, 8 insertions(+), 11 deletions(-)

Index: linux/drivers/char/Kconfig
===================================================================
--- linux.orig/drivers/char/Kconfig	2015-05-31 11:00:59.000000000 +1000
+++ linux/drivers/char/Kconfig	2015-05-31 11:01:00.000000000 +1000
@@ -247,7 +247,7 @@ source "drivers/char/hw_random/Kconfig"
 
 config NVRAM
 	tristate "/dev/nvram support"
-	depends on ATARI || X86 || (ARM && RTC_DRV_CMOS) || GENERIC_NVRAM
+	depends on X86 || (ARM && RTC_DRV_CMOS) || GENERIC_NVRAM
 	---help---
 	  If you say Y here and create a character special file /dev/nvram
 	  with major number 10 and minor number 144 using mknod ("man mknod"),
@@ -265,9 +265,6 @@ config NVRAM
 	  should NEVER idly tamper with it. See Ralf Brown's interrupt list
 	  for a guide to the use of CMOS bytes by your BIOS.
 
-	  On Atari machines, /dev/nvram is always configured and does not need
-	  to be selected.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called nvram.
 
Index: linux/drivers/scsi/Kconfig
===================================================================
--- linux.orig/drivers/scsi/Kconfig	2015-05-31 11:00:59.000000000 +1000
+++ linux/drivers/scsi/Kconfig	2015-05-31 11:01:00.000000000 +1000
@@ -1592,14 +1592,14 @@ config ATARI_SCSI
 	tristate "Atari native SCSI support"
 	depends on ATARI && SCSI
 	select SCSI_SPI_ATTRS
-	select NVRAM
 	---help---
 	  If you have an Atari with built-in NCR5380 SCSI controller (TT,
 	  Falcon, ...) say Y to get it supported. Of course also, if you have
 	  a compatible SCSI controller (e.g. for Medusa).
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called atari_scsi.
+	  To compile this driver as a module, choose M here: the module will
+	  be called atari_scsi. If you also enable NVRAM support, the SCSI
+	  host's ID is taken from the setting in TT RTC NVRAM.
 
 	  This driver supports both styles of NCR integration into the
 	  system: the TT style (separate DMA), and the Falcon style (via
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2015-05-31 11:00:59.000000000 +1000
+++ linux/drivers/scsi/atari_scsi.c	2015-05-31 11:01:00.000000000 +1000
@@ -875,9 +875,10 @@ static int __init atari_scsi_probe(struc
 	if (ATARIHW_PRESENT(TT_SCSI) && setup_sg_tablesize >= 0)
 		atari_scsi_template.sg_tablesize = setup_sg_tablesize;
 
-	if (setup_hostid >= 0) {
+	if (setup_hostid >= 0)
 		atari_scsi_template.this_id = setup_hostid & 7;
-	} else {
+#ifdef CONFIG_NVRAM
+	else
 		/* Test if a host id is set in the NVRam */
 		if (ATARIHW_PRESENT(TT_CLK) && nvram_check_checksum()) {
 			unsigned char b = nvram_read_byte(14);
@@ -888,8 +889,7 @@ static int __init atari_scsi_probe(struc
 			if (b & 0x80)
 				atari_scsi_template.this_id = b & 7;
 		}
-	}
-
+#endif
 
 #ifdef REAL_DMA
 	/* If running on a Falcon and if there's TT-Ram (i.e., more than one
