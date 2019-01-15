From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v9 01/22] scsi/atari_scsi: Don't select CONFIG_NVRAM
Date: Tue, 15 Jan 2019 15:18:56 +1100
Message-ID: <c7e8b28ed106455ee3d5cfc8c2e6a2dffef01cfb.1547525936.git.fthain@telegraphics.com.au>
References: <cover.1547525936.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1547525936.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On powerpc, setting CONFIG_NVRAM=n builds a kernel with no NVRAM support.
Setting CONFIG_NVRAM=m enables the /dev/nvram misc device module without
enabling NVRAM support in drivers. Setting CONFIG_NVRAM=y enables the
misc device (built-in) and also enables NVRAM support in drivers.

m68k shares the valkyriefb driver with powerpc, and since that driver uses
NVRAM, it is affected by CONFIG_ATARI_SCSI, because of the use of
"select NVRAM". We can avoid the "select" here, but drivers still have
to interpret the CONFIG_NVRAM symbol consistently regardless of platform.

In this patch and the subsequent fbdev driver patch, the convention is
adopted across all relevant platforms whereby NVRAM functionality gets
enabled in a given device driver when the nvram misc device is built-in
or when both drivers are modules.

Acked-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
This patch temporarily disables CONFIG_NVRAM on Atari, to prevent build
failures when bisecting the rest of this patch series. It gets enabled
again with the introduction of CONFIG_HAVE_ARCH_NVRAM_OPS, once the
nvram_* global functions have been moved to an ops struct.

Changed since v8:
 - Replaced defined(CONFIG_NVRAM) with IS_REACHABLE(CONFIG_NVRAM) as
suggested by James Bottomley.
 - Changed #ifdef to if as suggested by Christophe Leroy.
---
 drivers/char/Kconfig      | 5 +----
 drivers/scsi/Kconfig      | 6 +++---
 drivers/scsi/atari_scsi.c | 2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 2e2ffe7010aa..a8cac68de177 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -244,7 +244,7 @@ source "drivers/char/hw_random/Kconfig"
 
 config NVRAM
 	tristate "/dev/nvram support"
-	depends on ATARI || X86 || GENERIC_NVRAM
+	depends on X86 || GENERIC_NVRAM
 	---help---
 	  If you say Y here and create a character special file /dev/nvram
 	  with major number 10 and minor number 144 using mknod ("man mknod"),
@@ -262,9 +262,6 @@ config NVRAM
 	  should NEVER idly tamper with it. See Ralf Brown's interrupt list
 	  for a guide to the use of CMOS bytes by your BIOS.
 
-	  On Atari machines, /dev/nvram is always configured and does not need
-	  to be selected.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called nvram.
 
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index f38882f6f37d..8f9d9e9fa695 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1369,14 +1369,14 @@ config ATARI_SCSI
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
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index a503dc50c4f8..78b43200c99e 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -757,7 +757,7 @@ static int __init atari_scsi_probe(struct platform_device *pdev)
 
 	if (setup_hostid >= 0) {
 		atari_scsi_template.this_id = setup_hostid & 7;
-	} else {
+	} else if (IS_REACHABLE(CONFIG_NVRAM)) {
 		/* Test if a host id is set in the NVRam */
 		if (ATARIHW_PRESENT(TT_CLK) && nvram_check_checksum()) {
 			unsigned char b = nvram_read_byte(16);
-- 
2.19.2
