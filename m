From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC PATCH 74/71] ncr5380: Enable PDMA for NCR53C400A
Date: Sun, 6 Dec 2015 14:20:05 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512061319210.2536@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <1448789980-30094-2-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1511302255470.17483@nippy.intranet> <201511301440.04626.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <201511301440.04626.linux@rainbow-software.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 30 Nov 2015, Ondrej Zary wrote:

> On Monday 30 November 2015, Finn Thain wrote:
> > 
> > On Sun, 29 Nov 2015, Ondrej Zary wrote:
> > 
> > > Add I/O register mapping for NCR53C400A and enable PDMA mode to
> > > improve performance and fix non-working IRQ.
> > > 
> > 
> > Is CONFIG_SCSI_GENERIC_NCR53C400 is still needed? Can the driver be fully 
> > configured at runtime now?
> 
> Things depending on CONFIG_SCSI_GENERIC_NCR53C400:
> 
> #ifdef CONFIG_SCSI_GENERIC_NCR53C400
> #define PSEUDO_DMA
> #endif
> 
> Defining PSEUDO_DMA should not break anything, just makes code bigger a 
> bit. We can probably just define it always in g_NCR5380.c.

Based on your test results, I think so.

> 
> 
> This looks weird. I don't have any card with a BIOS to test.
> #ifdef CONFIG_SCSI_GENERIC_NCR53C400
> #define BIOSPARAM
> #define NCR5380_BIOSPARAM generic_NCR5380_biosparam
> #else
> #define NCR5380_BIOSPARAM NULL
> #endif
> 

I'm guessing that when you said "weird", you meant that it is weird to tie 
BIOSPARAM to CONFIG_SCSI_GENERIC_NCR53C400, because a 53C400-compatible 
device does not imply a card ROM, and generic_NCR5380_biosparam() does not 
require any particular device...

Regardless, the Kconfig help text doesn't say anything about bios_param, 
so I think that the weirdness you referred to should not prevent removal 
of CONFIG_SCSI_GENERIC_NCR53C400. I'm happy to let users manually #define 
BIOSPARAM if the default scsicam_bios_param() doesn't work. See patch 
below for example.

But if scsicam_bios_param() is adequate, or if generic_NCR5380_biosparam() 
is inadequate, then we should also remove generic_NCR5380_biosparam(), 
NCR5380_BIOSPARAM and BIOSPARAM. I'm not sufficiently familiar with this 
platform to say one way or the other.

> 
> This looks very wrong and should be done at runtime:
> #ifdef CONFIG_SCSI_GENERIC_NCR53C400
> #define NCR5380_region_size 16
> #else
> #define NCR5380_region_size 8
> #endif
> 

I'll have to leave that fix to you.

Thanks.


Index: linux/drivers/scsi/Kconfig
===================================================================
--- linux.orig/drivers/scsi/Kconfig	2015-12-06 12:29:36.000000000 +1100
+++ linux/drivers/scsi/Kconfig	2015-12-06 13:47:50.000000000 +1100
@@ -816,17 +816,6 @@ config SCSI_GENERIC_NCR5380_MMIO
 	  To compile this driver as a module, choose M here: the
 	  module will be called g_NCR5380_mmio.
 
-config SCSI_GENERIC_NCR53C400
-	bool "Enable NCR53c400 extensions"
-	depends on SCSI_GENERIC_NCR5380
-	help
-	  This enables certain optimizations for the NCR53c400 SCSI cards.
-	  You might as well try it out.  Note that this driver will only probe
-	  for the Trantor T130B in its default configuration; you might have
-	  to pass a command line option to the kernel at boot time if it does
-	  not detect your card.  See the file
-	  <file:Documentation/scsi/g_NCR5380.txt> for details.
-
 config SCSI_IPS
 	tristate "IBM ServeRAID support"
 	depends on PCI && SCSI
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-12-06 12:31:23.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-12-06 13:45:42.000000000 +1100
@@ -57,10 +57,7 @@
  */
 
 #define AUTOPROBE_IRQ
-
-#ifdef CONFIG_SCSI_GENERIC_NCR53C400
 #define PSEUDO_DMA
-#endif
 
 #include <asm/io.h>
 #include <linux/blkdev.h>
@@ -506,6 +503,9 @@ generic_NCR5380_biosparam(struct scsi_de
 	ip[2] = capacity >> 11;
 	return 0;
 }
+#define NCR5380_BIOSPARAM generic_NCR5380_biosparam
+#else
+#define NCR5380_BIOSPARAM NULL
 #endif
 
 #ifdef PSEUDO_DMA
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2015-12-06 12:30:42.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2015-12-06 13:47:12.000000000 +1100
@@ -14,13 +14,6 @@
 #ifndef GENERIC_NCR5380_H
 #define GENERIC_NCR5380_H
 
-#ifdef CONFIG_SCSI_GENERIC_NCR53C400
-#define BIOSPARAM
-#define NCR5380_BIOSPARAM generic_NCR5380_biosparam
-#else
-#define NCR5380_BIOSPARAM NULL
-#endif
-
 #define __STRVAL(x) #x
 #define STRVAL(x) __STRVAL(x)
 
@@ -31,11 +24,9 @@
 #define NCR5380_map_name port
 #define NCR53C400_register_offset 0
 
-#ifdef CONFIG_SCSI_GENERIC_NCR53C400
-#define NCR5380_region_size 16
-#else
-#define NCR5380_region_size 8
-#endif
+// FIXME
+// #define NCR5380_region_size 16
+// #define NCR5380_region_size 8
 
 #define NCR5380_read(reg) \
 	inb(instance->io_port + (reg))
