From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 03/71] ncr5380: Eliminate PDEBUG*, TDEBUG* and DTCDEBUG* macros
Date: Wed, 18 Nov 2015 19:34:58 +1100
Message-ID: <20151118083456.101681148@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-TDEBUG-DTCDEBUG-PDEBUG
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replace {P,T,DTC}DEBUG_INIT with NDEBUG_INIT. Remove dead debugging
code, including code that's conditional upon *DEBUG_TRANSFER.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/dtc.c   |   18 ++++++------------
 drivers/scsi/dtc.h   |   27 ---------------------------
 drivers/scsi/pas16.c |   21 +++++++--------------
 drivers/scsi/pas16.h |   16 ----------------
 drivers/scsi/t128.c  |   18 ++++++------------
 drivers/scsi/t128.h  |   16 ----------------
 6 files changed, 19 insertions(+), 97 deletions(-)

Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2015-11-18 19:32:59.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2015-11-18 19:33:02.000000000 +1100
@@ -205,9 +205,8 @@ static int __init dtc_detect(struct scsi
 				addr = 0;
 		} else
 			for (; !addr && (current_base < NO_BASES); ++current_base) {
-#if (DTCDEBUG & DTCDEBUG_INIT)
-				printk(KERN_DEBUG "scsi-dtc : probing address %08x\n", bases[current_base].address);
-#endif
+				dprintk(NDEBUG_INIT, "dtc: probing address 0x%08x\n",
+				        (unsigned int)bases[current_base].address);
 				if (bases[current_base].noauto)
 					continue;
 				base = ioremap(bases[current_base].address, 0x2000);
@@ -216,18 +215,14 @@ static int __init dtc_detect(struct scsi
 				for (sig = 0; sig < NO_SIGNATURES; ++sig) {
 					if (check_signature(base + signatures[sig].offset, signatures[sig].string, strlen(signatures[sig].string))) {
 						addr = bases[current_base].address;
-#if (DTCDEBUG & DTCDEBUG_INIT)
-						printk(KERN_DEBUG "scsi-dtc : detected board.\n");
-#endif
+						dprintk(NDEBUG_INIT, "dtc: detected board\n");
 						goto found;
 					}
 				}
 				iounmap(base);
 			}
 
-#if defined(DTCDEBUG) && (DTCDEBUG & DTCDEBUG_INIT)
-		printk(KERN_DEBUG "scsi-dtc : base = %08x\n", addr);
-#endif
+		dprintk(NDEBUG_INIT, "dtc: addr = 0x%08x\n", addr);
 
 		if (!addr)
 			break;
@@ -271,9 +266,8 @@ found:
 			printk(KERN_WARNING "scsi%d : interrupts not used. Might as well not jumper it.\n", instance->host_no);
 		instance->irq = NO_IRQ;
 #endif
-#if defined(DTCDEBUG) && (DTCDEBUG & DTCDEBUG_INIT)
-		printk("scsi%d : irq = %d\n", instance->host_no, instance->irq);
-#endif
+		dprintk(NDEBUG_INIT, "scsi%d : irq = %d\n",
+		        instance->host_no, instance->irq);
 
 		++current_override;
 		++count;
Index: linux/drivers/scsi/dtc.h
===================================================================
--- linux.orig/drivers/scsi/dtc.h	2015-11-18 19:25:56.000000000 +1100
+++ linux/drivers/scsi/dtc.h	2015-11-18 19:33:02.000000000 +1100
@@ -10,10 +10,6 @@
 #ifndef DTC3280_H
 #define DTC3280_H
 
-#define DTCDEBUG 0
-#define DTCDEBUG_INIT	0x1
-#define DTCDEBUG_TRANSFER 0x2
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif
@@ -33,31 +29,8 @@
 
 #define DTC_address(reg) (base + DTC_5380_OFFSET + reg)
 
-#define dbNCR5380_read(reg)                                              \
-    (rval=readb(DTC_address(reg)), \
-     (((unsigned char) printk("DTC : read register %d at addr %p is: %02x\n"\
-    , (reg), DTC_address(reg), rval)), rval ) )
-
-#define dbNCR5380_write(reg, value) do {                                  \
-    printk("DTC : write %02x to register %d at address %p\n",         \
-            (value), (reg), DTC_address(reg));     \
-    writeb(value, DTC_address(reg));} while(0)
-
-
-#if !(DTCDEBUG & DTCDEBUG_TRANSFER) 
 #define NCR5380_read(reg) (readb(DTC_address(reg)))
 #define NCR5380_write(reg, value) (writeb(value, DTC_address(reg)))
-#else
-#define NCR5380_read(reg) (readb(DTC_address(reg)))
-#define xNCR5380_read(reg)						\
-    (((unsigned char) printk("DTC : read register %d at address %p\n"\
-    , (reg), DTC_address(reg))), readb(DTC_address(reg)))
-
-#define NCR5380_write(reg, value) do {					\
-    printk("DTC : write %02x to register %d at address %p\n", 	\
-	    (value), (reg), DTC_address(reg));	\
-    writeb(value, DTC_address(reg));} while(0)
-#endif
 
 #define NCR5380_intr			dtc_intr
 #define NCR5380_queue_command		dtc_queue_command
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2015-11-18 19:32:59.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2015-11-18 19:33:02.000000000 +1100
@@ -1,6 +1,5 @@
 #define PSEUDO_DMA
 #define UNSAFE  /* Not unsafe for PAS16 -- use it */
-#define PDEBUG 0
 
 /*
  * This driver adapted from Drew Eckhardt's Trantor T128 driver
@@ -377,23 +376,18 @@ static int __init pas16_detect(struct sc
 	}
 	else
 	    for (; !io_port && (current_base < NO_BASES); ++current_base) {
-#if (PDEBUG & PDEBUG_INIT)
-    printk("scsi-pas16 : probing io_port %04x\n", (unsigned int) bases[current_base].io_port);
-#endif
+		dprintk(NDEBUG_INIT, "pas16: probing io_port 0x%04x\n",
+		        (unsigned int)bases[current_base].io_port);
 		if ( !bases[current_base].noauto &&
 		     pas16_hw_detect( current_base ) ){
 			io_port = bases[current_base].io_port;
 			init_board( io_port, default_irqs[ current_base ], 0 ); 
-#if (PDEBUG & PDEBUG_INIT)
-			printk("scsi-pas16 : detected board.\n");
-#endif
+			dprintk(NDEBUG_INIT, "pas16: detected board\n");
 		}
     }
 
-
-#if defined(PDEBUG) && (PDEBUG & PDEBUG_INIT)
-	printk("scsi-pas16 : io_port = %04x\n", (unsigned int) io_port);
-#endif
+	dprintk(NDEBUG_INIT, "pas16: io_port = 0x%04x\n",
+	        (unsigned int)io_port);
 
 	if (!io_port)
 	    break;
@@ -431,9 +425,8 @@ static int __init pas16_detect(struct sc
 	    outb( (inb(io_port + IO_CONFIG_3) & 0x0f), io_port + IO_CONFIG_3 );
 	}
 
-#if defined(PDEBUG) && (PDEBUG & PDEBUG_INIT)
-	printk("scsi%d : irq = %d\n", instance->host_no, instance->irq);
-#endif
+	dprintk(NDEBUG_INIT, "scsi%d : irq = %d\n",
+	        instance->host_no, instance->irq);
 
 	++current_override;
 	++count;
Index: linux/drivers/scsi/pas16.h
===================================================================
--- linux.orig/drivers/scsi/pas16.h	2015-11-18 19:25:56.000000000 +1100
+++ linux/drivers/scsi/pas16.h	2015-11-18 19:33:02.000000000 +1100
@@ -24,9 +24,6 @@
 #ifndef PAS16_H
 #define PAS16_H
 
-#define PDEBUG_INIT	0x1
-#define PDEBUG_TRANSFER 0x2
-
 #define PAS16_DEFAULT_BASE_1  0x388
 #define PAS16_DEFAULT_BASE_2  0x384
 #define PAS16_DEFAULT_BASE_3  0x38c
@@ -120,21 +117,8 @@
 
 #define PAS16_io_port(reg) ( io_port + pas16_offset[(reg)] )
 
-#if !(PDEBUG & PDEBUG_TRANSFER) 
 #define NCR5380_read(reg) ( inb(PAS16_io_port(reg)) )
 #define NCR5380_write(reg, value) ( outb((value),PAS16_io_port(reg)) )
-#else
-#define NCR5380_read(reg)						\
-    (((unsigned char) printk("scsi%d : read register %d at io_port %04x\n"\
-    , instance->hostno, (reg), PAS16_io_port(reg))), inb( PAS16_io_port(reg)) )
-
-#define NCR5380_write(reg, value) 					\
-    (printk("scsi%d : write %02x to register %d at io_port %04x\n", 	\
-	    instance->hostno, (value), (reg), PAS16_io_port(reg)),	\
-    outb( (value),PAS16_io_port(reg) ) )
-
-#endif
-
 
 #define NCR5380_intr pas16_intr
 #define do_NCR5380_intr do_pas16_intr
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2015-11-18 19:32:59.000000000 +1100
+++ linux/drivers/scsi/t128.c	2015-11-18 19:33:02.000000000 +1100
@@ -182,9 +182,8 @@ static int __init t128_detect(struct scs
 		base = 0;
 	} else 
 	    for (; !base && (current_base < NO_BASES); ++current_base) {
-#if (TDEBUG & TDEBUG_INIT)
-    printk("scsi-t128 : probing address %08x\n", bases[current_base].address);
-#endif
+		dprintk(NDEBUG_INIT, "t128: probing address 0x%08x\n",
+		        bases[current_base].address);
 		if (bases[current_base].noauto)
 			continue;
 		p = ioremap(bases[current_base].address, 0x2000);
@@ -195,17 +194,13 @@ static int __init t128_detect(struct scs
 					signatures[sig].string,
 					strlen(signatures[sig].string))) {
 			base = bases[current_base].address;
-#if (TDEBUG & TDEBUG_INIT)
-			printk("scsi-t128 : detected board.\n");
-#endif
+			dprintk(NDEBUG_INIT, "t128: detected board\n");
 			goto found;
 		    }
 		iounmap(p);
 	    }
 
-#if defined(TDEBUG) && (TDEBUG & TDEBUG_INIT)
-	printk("scsi-t128 : base = %08x\n", (unsigned int) base);
-#endif
+	dprintk(NDEBUG_INIT, "t128: base = 0x%08x\n", (unsigned int)base);
 
 	if (!base)
 	    break;
@@ -242,9 +237,8 @@ found:
 	    printk("scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
 	}
 
-#if defined(TDEBUG) && (TDEBUG & TDEBUG_INIT)
-	printk("scsi%d : irq = %d\n", instance->host_no, instance->irq);
-#endif
+	dprintk(NDEBUG_INIT, "scsi%d: irq = %d\n",
+	        instance->host_no, instance->irq);
 
 	++current_override;
 	++count;
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2015-11-18 19:25:56.000000000 +1100
+++ linux/drivers/scsi/t128.h	2015-11-18 19:33:02.000000000 +1100
@@ -23,10 +23,6 @@
 #ifndef T128_H
 #define T128_H
 
-#define TDEBUG		0
-#define TDEBUG_INIT	0x1
-#define TDEBUG_TRANSFER 0x2
-
 /*
  * The trantor boards are memory mapped. They use an NCR5380 or
  * equivalent (my sample board had part second sourced from ZILOG).
@@ -92,20 +88,8 @@
 
 #define T128_address(reg) (base + T_5380_OFFSET + ((reg) * 0x20))
 
-#if !(TDEBUG & TDEBUG_TRANSFER)
 #define NCR5380_read(reg) readb(T128_address(reg))
 #define NCR5380_write(reg, value) writeb((value),(T128_address(reg)))
-#else
-#define NCR5380_read(reg)						\
-    (((unsigned char) printk("scsi%d : read register %d at address %08x\n"\
-    , instance->hostno, (reg), T128_address(reg))), readb(T128_address(reg)))
-
-#define NCR5380_write(reg, value) {					\
-    printk("scsi%d : write %02x to register %d at address %08x\n",	\
-	    instance->hostno, (value), (reg), T128_address(reg));	\
-    writeb((value), (T128_address(reg)));				\
-}
-#endif
 
 #define NCR5380_intr t128_intr
 #define do_NCR5380_intr do_t128_intr
