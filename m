From: Nils Hammar <m4341@abc.se>
Subject: PATCH for g_NCR5380, DTC3151 support
Date: Thu, 2 Jan 2003 09:30:25 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301020830.h028UPV20703@atle.abc.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atle.abc.se (atle [195.17.72.10])
	by bele.abc.se (8.11.6+Sun/8.10.2) with ESMTP id h028UQB06132
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jan 2003 09:30:27 +0100 (MET)
Received: (from m4341@localhost)
	by atle.abc.se (8.11.6+Sun/8.11.6) id h028UPV20703
	for linux-scsi@vger.kernel.org; Thu, 2 Jan 2003 09:30:25 +0100 (MET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Patches for the g_NCR5380 driver.
The current driver depends on the ISAPNP functionality, but not all
computers have ISAPNP, like my old Compaq 386sx.

This patch shall resolve that problem.

Additional in this patch is that most printk statements now prints
"g_NCR5380 :" at the beginning of the line to correctly identify
that it was this driver that generated the printout.

/Nils Hammar, m4341@abc.se

Note: I couldn't find any maintainer for this driver in the MAINTAINERS file.

=============================================================================

--- drivers/scsi/g_NCR5380.h.orig	2003-01-01 12:04:33.000000000 +0100
+++ drivers/scsi/g_NCR5380.h	2003-01-02 08:36:21.000000000 +0100
@@ -10,6 +10,9 @@
  * NCR53C400 extensions (c) 1994,1995,1996, Kevin Lentin
  *    K.Lentin@cs.monash.edu.au
  *
+ * Added BOARD_NONE constant
+ * 2003-01-01 Nils Hammar, m4341@abc.se
+ *
  * ALPHA RELEASE 1. 
  *
  * For more information, please consult 
@@ -43,6 +46,10 @@
 #define NCR5380_BIOSPARAM NULL
 #endif
 
+/*	Local Prototypes */
+int	check_regs(int addr);
+int	find_dtc_pnp_card(void);
+int	try_port(int i, int *ports, int current_override);
 int generic_NCR5380_abort(Scsi_Cmnd *);
 int generic_NCR5380_detect(Scsi_Host_Template *);
 int generic_NCR5380_release_resources(struct Scsi_Host *);
@@ -144,6 +151,7 @@
 #define BOARD_NCR53C400	1
 #define BOARD_NCR53C400A 2
 #define BOARD_DTC3181E	3
+#define BOARD_NONE	255
 
 #endif				/* else def HOSTS_C */
 #endif				/* GENERIC_NCR5380_H */
--- drivers/scsi/g_NCR5380.c.orig	2003-01-01 12:04:18.000000000 +0100
+++ drivers/scsi/g_NCR5380.c	2003-01-02 09:10:16.000000000 +0100
@@ -19,6 +19,16 @@
  * Added ISAPNP support for DTC436 adapters,
  * Thomas Sailer, sailer@ife.ee.ethz.ch
  *
+ * Problems around the ISAPNP support corrected for
+ * the machines that doesn't have PNP support.
+ * I hope that this doesn't break working configurations.
+ * Only tested with a DTC3151 card (with the 53C400A chip)
+ * on a 386sx computer.
+ * Added some debug statements in the identification
+ * code and prefixed most 'printk' statements with 'g_NCR5380'
+ * for correct identification of this module.
+ * 2003-01-01, Nils Hammar, m4341@abc.se
+ *
  * ALPHA RELEASE 1. 
  *
  * For more information, please consult 
@@ -82,6 +92,10 @@
  * $Log: generic_NCR5380.c,v $
  */
 
+/* Show the card registers. Useful for debugging. */
+/* #define SHOW_REGS 1 */
+#undef SHOW_REGS
+
 /* settings for DTC3181E card with only Mustek scanner attached */
 #define USLEEP
 #define USLEEP_POLL	1
@@ -110,6 +124,7 @@
 #include <asm/system.h>
 #include <asm/io.h>
 #include <linux/signal.h>
+#include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/blk.h>
 #include "scsi.h"
@@ -132,6 +147,15 @@
 static int ncr_53c400a = NCR_NOT_SET;
 static int dtc_3181e = NCR_NOT_SET;
 
+/**
+ *	Assign default port PORT_AUTO here so that we will be able
+ *	to do autodetect of the port later.
+ *	This seems to be working for 53C400A and DTC3181E.
+ *	I hope that this don't break the 5380 and 53C400.
+ *	Also the IRQ, DMA and Board ID are assigned to default
+ *	values to avoid problems later.
+ */
+
 static struct override {
 	NCR5380_implementation_fields;
 	int irq;
@@ -141,7 +165,7 @@
 #ifdef GENERIC_NCR5380_OVERRIDE
 [] __initdata = GENERIC_NCR5380_OVERRIDE;
 #else
-[1] __initdata = { { 0,},};
+[] __initdata = { { PORT_AUTO,IRQ_AUTO,DMA_NONE,BOARD_NONE},};
 #endif
 
 #define NO_OVERRIDES (sizeof(overrides) / sizeof(struct override))
@@ -163,28 +187,36 @@
 	static int commandline_current = 0;
 	switch (board) {
 	case BOARD_NCR5380:
+		printk("generic_NCR5380_setup : ");
 		if (ints[0] != 2 && ints[0] != 3) {
-			printk(KERN_ERR "generic_NCR5380_setup : usage ncr5380=" STRVAL(NCR5380_map_name) ",irq,dma\n");
+			printk(KERN_ERR "usage ncr5380=" STRVAL(NCR5380_map_name) ",irq,dma\n");
 			return;
 		}
+		printk("OK!\n");
 		break;
 	case BOARD_NCR53C400:
+		printk("generic_NCR53C400_setup : ");
 		if (ints[0] != 2) {
-			printk(KERN_ERR "generic_NCR53C400_setup : usage ncr53c400=" STRVAL(NCR5380_map_name) ",irq\n");
+			printk(KERN_ERR "usage ncr53c400=" STRVAL(NCR5380_map_name) ",irq\n");
 			return;
 		}
+		printk("OK!\n");
 		break;
 	case BOARD_NCR53C400A:
+		printk("generic_NCR53C400A_setup : ");
 		if (ints[0] != 2) {
-			printk(KERN_ERR "generic_NCR53C400A_setup : usage ncr53c400a=" STRVAL(NCR5380_map_name) ",irq\n");
+			printk(KERN_ERR "usage ncr53c400a=" STRVAL(NCR5380_map_name) ",irq\n");
 			return;
 		}
+		printk("OK!\n");
 		break;
 	case BOARD_DTC3181E:
+		printk("generic_DTC3181E_setup : ");
 		if (ints[0] != 2) {
-			printk("generic_DTC3181E_setup : usage dtc3181e=" STRVAL(NCR5380_map_name) ",irq\n");
+			printk(KERN_ERR "usage dtc3181e=" STRVAL(NCR5380_map_name) ",irq\n");
 			return;
 		}
+		printk("OK!\n");
 		break;
 	}
 
@@ -272,12 +304,133 @@
 }
 
 /**
+ *	check_regs - Check the registers of the card to validate if it
+ *		     is the correct card.
+ *
+ *	A chip reset is sent to the assumed card and cleared after 0.1 secs.
+ *	An additional delay is added to allow the chip to be in
+ *	a 'friendly' state.
+ *
+ *	If ControlReg0 has MSB set (Masked 0x80) we assume that this is
+ *	our card. A better identification can be added here if any
+ *	identification conflict occurs.
+ *
+ *	A list of the registers of the card is performed here if
+ *	SHOW_REGS is defined.
+ */
+
+int	check_regs(int addr)
+{
+	int	i;
+
+	i=0; /* Hide warning for unused variable. */
+
+	/* Send a reset to the chip. */
+	outb(0x80, addr + 9);
+	mdelay(100);
+	outb(0x00, addr + 9);
+	mdelay(100);
+
+#ifdef SHOW_REGS
+	printk("Addr=0x%04x\n", addr);
+	printk(" CSD ICD MOD TCD CSC STA DAT RSI HST CL0 BLK SWT CL1 CL2 IAD IDT");
+	printk("\n");
+
+	for (i=0;i<16;i++) {
+		printk("  %02x", inb(addr+i));
+	}
+
+	printk("\n");
+#endif
+
+	if (inb(addr + 9) == 0x80) {
+		printk("g_NCR5380 : Card found!\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ *	find_dtc_pnp_card - Find a DTC PNP card.
+ *
+ *	Call the PNP routines to find a PNP card.
+ *	This code is extracted from the
+ *	generic_NCR5380_detect function since it
+ *	should be standalone for code readability.
+ */
+
+int	find_dtc_pnp_card()
+{
+	int		count = 0;
+	struct pci_dev	*dev  = NULL;
+
+	while ((dev = isapnp_find_dev(NULL, ISAPNP_VENDOR('D', 'T', 'C'), ISAPNP_FUNCTION(0x436e), dev))) {
+		if (count >= NO_OVERRIDES)
+			break;
+		if (!dev->active && dev->prepare(dev) < 0) {
+			printk(KERN_ERR "g_NCR5380 : dtc436e probe: prepare failed\n");
+			continue;
+		}
+		if (!(dev->resource[0].flags & IORESOURCE_IO))
+			continue;
+		if (!dev->active && dev->activate(dev) < 0) {
+			printk(KERN_ERR "g_NCR5380 : dtc436e probe: activate failed\n");
+			continue;
+		}
+		if (dev->irq_resource[0].flags & IORESOURCE_IRQ) {
+			overrides[count].irq = dev->irq_resource[0].start;
+		} else {
+			overrides[count].irq = IRQ_NONE;
+		}
+
+		if (dev->dma_resource[0].flags & IORESOURCE_DMA) {
+			overrides[count].dma = dev->dma_resource[0].start;
+		} else {
+			overrides[count].dma = DMA_NONE;
+		}
+
+		overrides[count].NCR5380_map_name = (NCR5380_map_type) dev->resource[0].start;
+		overrides[count].board = BOARD_DTC3181E;
+		count++;
+	}
+
+	return count;
+}
+
+/**
+ *	try_port - Try one port.
+ *
+ *	This routine calls check_regs to determine if it is
+ *	'our' card and assigns the port address if we found it
+ *	and if no address is assigned through user override.
+ *
+ */
+
+int	try_port(int i, int *ports, int current_override)
+{
+	if (overrides[current_override].NCR5380_map_name == PORT_AUTO) {
+		if (check_regs(ports[i]) == 1) {
+			overrides[current_override].NCR5380_map_name=ports[i];
+			return 1;
+		}
+	} else {
+		if (overrides[current_override].NCR5380_map_name == ports[i]) {
+			if (check_regs(ports[i]) == 1) return 1;
+		}
+	}
+
+	return 0;
+}
+
+/**
  * 	generic_NCR5380_detect	-	look for NCR5380 controllers
  *	@tpnt: the scsi template
  *
  *	Scan for the present of NCR5380, NCR53C400, NCR53C400A, DTC3181E
  *	and DTC436(ISAPnP) controllers. If overrides have been set we use
  *	them.
+ *	The DTC3151 has a SYM53C400A, which shall be the same as a NCR53C400A.
  *
  *	The caller supplied NCR5380_init function is invoked from here, before
  *	the interrupt line is taken.
@@ -288,7 +441,9 @@
 int __init generic_NCR5380_detect(Scsi_Host_Template * tpnt)
 {
 	static int current_override = 0;
-	int count, i;
+	int count=0;
+	int i;
+	int j;
 	unsigned int *ports;
 	static unsigned int __initdata ncr_53c400a_ports[] = {
 		0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
@@ -315,61 +470,40 @@
 		overrides[0].board = BOARD_DTC3181E;
 
 	if (!current_override && isapnp_present()) {
-		struct pci_dev *dev = NULL;
-		count = 0;
-		while ((dev = isapnp_find_dev(NULL, ISAPNP_VENDOR('D', 'T', 'C'), ISAPNP_FUNCTION(0x436e), dev))) {
-			if (count >= NO_OVERRIDES)
-				break;
-			if (!dev->active && dev->prepare(dev) < 0) {
-				printk(KERN_ERR "dtc436e probe: prepare failed\n");
-				continue;
-			}
-			if (!(dev->resource[0].flags & IORESOURCE_IO))
-				continue;
-			if (!dev->active && dev->activate(dev) < 0) {
-				printk(KERN_ERR "dtc436e probe: activate failed\n");
-				continue;
-			}
-			if (dev->irq_resource[0].flags & IORESOURCE_IRQ)
-				overrides[count].irq = dev->irq_resource[0].start;
-			else
-				overrides[count].irq = IRQ_NONE;
-			if (dev->dma_resource[0].flags & IORESOURCE_DMA)
-				overrides[count].dma = dev->dma_resource[0].start;
-			else
-				overrides[count].dma = DMA_NONE;
-			overrides[count].NCR5380_map_name = (NCR5380_map_type) dev->resource[0].start;
-			overrides[count].board = BOARD_DTC3181E;
-			count++;
-		}
+		count=find_dtc_pnp_card();
 	}
 
 	tpnt->proc_name = "g_NCR5380";
 
 	for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
-		if (!(overrides[current_override].NCR5380_map_name))
+		if (overrides[current_override].board == BOARD_NONE) {
 			continue;
+		}
 
-		ports = 0;
+		ports = NULL;
 		switch (overrides[current_override].board) {
-		case BOARD_NCR5380:
-			flags = FLAG_NO_PSEUDO_DMA;
-			break;
-		case BOARD_NCR53C400:
-			flags = FLAG_NCR53C400;
-			break;
-		case BOARD_NCR53C400A:
-			flags = FLAG_NO_PSEUDO_DMA;
-			ports = ncr_53c400a_ports;
-			break;
-		case BOARD_DTC3181E:
-			flags = FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E;
-			ports = dtc_3181e_ports;
-			break;
+			case BOARD_NCR5380:
+				printk("g_NCR5380 : BOARD_NCR5380\n");
+				flags = FLAG_NO_PSEUDO_DMA;
+				break;
+			case BOARD_NCR53C400:
+				printk("g_NCR5380 : BOARD_NCR53C400\n");
+				flags = FLAG_NCR53C400;
+				break;
+			case BOARD_NCR53C400A:
+				printk("g_NCR5380 : BOARD_NCR53C400A\n");
+				flags = FLAG_NO_PSEUDO_DMA;
+				ports = ncr_53c400a_ports;
+				break;
+			case BOARD_DTC3181E:
+				printk("g_NCR5380 : BOARD_DTC3181E\n");
+				flags = FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E;
+				ports = dtc_3181e_ports;
+				break;
 		}
 
 #ifdef CONFIG_SCSI_G_NCR5380_PORT
-		if (ports) {
+		if (ports != NULL) {
 			/* wakeup sequence for the NCR53C400A and DTC3181E */
 
 			/* Disable the adapter and look for a free io port */
@@ -380,39 +514,58 @@
 			outb(0xa6, 0x379);
 			outb(0x00, 0x379);
 
-			if (overrides[current_override].NCR5380_map_name != PORT_AUTO)
-				for (i = 0; ports[i]; i++) {
-					if (overrides[current_override].NCR5380_map_name == ports[i])
-						break;
-			} else
-				for (i = 0; ports[i]; i++) {
-					if ((!check_region(ports[i], 16)) && (inb(ports[i]) == 0xff))
+			/* Loop through the possible ports for the adapter */
+
+			for (i = 0; ports[i]; i++) {
+				/* Try to select port if the port area
+				   isn't allocated yet. */
+				if (!check_region(ports[i], 16)) {
+					/* set io port to be used */
+					outb(0x59, 0x779);
+					outb(0xb9, 0x379);
+					outb(0xc5, 0x379);
+					outb(0xae, 0x379);
+					outb(0xa6, 0x379);
+					outb(0x80 | i, 0x379);
+
+					/* If we find a port we can
+					   break the loop */
+					if (try_port(i, ports, current_override) != 0) {
 						break;
+					}
+				}
+			}
+
+			/* Give some help if no card was found! */
+
+			if (!ports[i]) {
+				printk("g_NCR5380 : No ports... :-( \n");
+				printk("g_NCR5380 : Valid ports:");
+				for(j=0;ports[j] != 0;j++) {
+					printk(" 0x%x,", ports[j]);
 				}
-			if (ports[i]) {
-				outb(0x59, 0x779);
-				outb(0xb9, 0x379);
-				outb(0xc5, 0x379);
-				outb(0xae, 0x379);
-				outb(0xa6, 0x379);
-				outb(0x80 | i, 0x379);	/* set io port to be used */
-				outb(0xc0, ports[i] + 9);
-				if (inb(ports[i] + 9) != 0x80)
-					continue;
-				else
-					overrides[current_override].NCR5380_map_name = ports[i];
-			} else
+				printk("\n");
+				printk("g_NCR5380 : Hint: Try to select a different card type!\n");
+				printk("g_NCR5380 : E.g. try both ncr_53c400a=1 and dtc_3181e=1 as options\n");
+				printk("before giving up\n");
 				continue;
+			}
 		}
 
 		request_region(overrides[current_override].NCR5380_map_name, NCR5380_region_size, "ncr5380");
+
 #else
-		if (check_mem_region(overrides[current_override].NCR5380_map_name, NCR5380_region_size))
+		if (check_mem_region(overrides[current_override].NCR5380_map_name, NCR5380_region_size)) {
 			continue;
+		}
+
 		request_mem_region(overrides[current_override].NCR5380_map_name, NCR5380_region_size, "ncr5380");
 #endif
+
 		instance = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
+
 		if (instance == NULL) {
+			printk("g_NCR5380 : instance is NULL!\n");
 #ifdef CONFIG_SCSI_G_NCR5380_PORT
 			release_region(overrides[current_override].NCR5380_map_name, NCR5380_region_size);
 #else
@@ -425,34 +578,44 @@
 
 		NCR5380_init(instance, flags);
 
-		if (overrides[current_override].irq != IRQ_AUTO)
+		if (overrides[current_override].irq != IRQ_AUTO) {
 			instance->irq = overrides[current_override].irq;
-		else
+		} else {
 			instance->irq = NCR5380_probe_irq(instance, 0xffff);
+		}
 
-		if (instance->irq != IRQ_NONE)
+		if (instance->irq != IRQ_NONE) {
 			if (request_irq(instance->irq, do_generic_NCR5380_intr, SA_INTERRUPT, "NCR5380", NULL)) {
-				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
+				printk(KERN_WARNING "g_NCR5380 : scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = IRQ_NONE;
 			}
+		}
 
 		if (instance->irq == IRQ_NONE) {
-			printk(KERN_INFO "scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
-			printk(KERN_INFO "scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
+			printk(KERN_INFO "g_NCR5380 : scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
+			printk(KERN_INFO "g_NCR5380 : scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
+		} else {
+			printk(KERN_INFO "g_NCR5380 : scsi%d : interrupts enabled.\n", instance->host_no);
 		}
 
-		printk(KERN_INFO "scsi%d : at " STRVAL(NCR5380_map_name) " 0x%x", instance->host_no, (unsigned int) instance->NCR5380_instance_name);
-		if (instance->irq == IRQ_NONE)
-			printk(" interrupts disabled");
-		else
-			printk(" irq %d", instance->irq);
-		printk(" options CAN_QUEUE=%d  CMD_PER_LUN=%d release=%d", CAN_QUEUE, CMD_PER_LUN, GENERIC_NCR5380_PUBLIC_RELEASE);
+		printk(KERN_INFO "g_NCR5380 : scsi%d : at " STRVAL(NCR5380_map_name) " 0x%x\n", instance->host_no, (unsigned int) instance->NCR5380_instance_name);
+		if (instance->irq == IRQ_NONE) {
+			printk("g_NCR5380 :  interrupts disabled\n");
+		} else {
+			printk("g_NCR5380 :  irq %d\n", instance->irq);
+		}
+
+		printk("g_NCR5380 :  options \n");
+		printk("g_NCR5380 :       CAN_QUEUE=%d\n", CAN_QUEUE);
+		printk("g_NCR5380 :       CMD_PER_LUN=%d\n", CMD_PER_LUN);
+		printk("g_NCR5380 :       release=%d\n", GENERIC_NCR5380_PUBLIC_RELEASE);
 		NCR5380_print_options(instance);
 		printk("\n");
 
 		++current_override;
 		++count;
 	}
+
 	return count;
 }
 
@@ -551,9 +714,10 @@
 			break;
 		}
 		if (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_GATED_53C80_IRQ) {
-			printk(KERN_ERR "53C400r: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
+			printk(KERN_ERR "g_NCR5380 : 53C400r: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
 			return -1;
 		}
+
 		while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY);
 
 #ifdef CONFIG_SCSI_G_NCR5380_PORT
@@ -591,18 +755,18 @@
 	}
 
 	if (!(NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_GATED_53C80_IRQ))
-		printk("53C400r: no 53C80 gated irq after transfer");
+		printk("g_NCR5380 : 53C400r: no 53C80 gated irq after transfer");
 
 #if 0
 	/*
 	 *	DON'T DO THIS - THEY NEVER ARRIVE!
 	 */
-	printk("53C400r: Waiting for 53C80 registers\n");
+	printk("g_NCR5380 : 53C400r: Waiting for 53C80 registers\n");
 	while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_53C80_REG)
 		;
 #endif
 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
-		printk(KERN_ERR "53C400r: no end dma signal\n");
+		printk(KERN_ERR "g_NCR5380 : 53C400r: no end dma signal\n");
 		
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
@@ -633,7 +797,7 @@
 	NCR5380_write(C400_BLOCK_COUNTER_REG, blocks);
 	while (1) {
 		if (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_GATED_53C80_IRQ) {
-			printk(KERN_ERR "53C400w: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
+			printk(KERN_ERR "g_NCR5380 : 53C400w: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
 			return -1;
 		}
 
@@ -672,9 +836,9 @@
 	}
 
 #if 0
-	printk("53C400w: waiting for registers to be available\n");
+	printk("g_NCR5380 : 53C400w: waiting for registers to be available\n");
 	THEY NEVER DO ! while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_53C80_REG);
-	printk("53C400w: Got em\n");
+	printk("g_NCR5380 : 53C400w: Got em\n");
 #endif
 
 	/* Let's wait for this instead - could be ugly */
@@ -690,13 +854,13 @@
 	 */
 	if (i) {
 		if (!((i = NCR5380_read(BUS_AND_STATUS_REG)) & BASR_END_DMA_TRANSFER))
-			printk(KERN_ERR "53C400w: No END OF DMA bit - WHOOPS! BASR=%0x\n", i);
+			printk(KERN_ERR "g_NCR5380 : 53C400w: No END OF DMA bit - WHOOPS! BASR=%0x\n", i);
 	} else
-		printk(KERN_ERR "53C400w: no 53C80 gated irq after transfer (last block)\n");
+		printk(KERN_ERR "g_NCR5380 : 53C400w: no 53C80 gated irq after transfer (last block)\n");
 
 #if 0
 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER)) {
-		printk(KERN_ERR "53C400w: no end dma signal\n");
+		printk(KERN_ERR "g_NCR5380 : 53C400w: no end dma signal\n");
 	}
 #endif
 	while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT))
