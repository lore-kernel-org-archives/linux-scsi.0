From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH 2.5.59] sim710: cleanup/remove most cli()'s
Date: Tue, 4 Feb 2003 11:23:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200302041123.06204@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Richard Hirst <rhirst@linuxcare.com>

Hi,

the appended patch does the following:

-group all includes (except '#include "scsi_module.c"') together
-add KERN_* to all printk's
-add error checking for call of request_region
-remove most cli() and use spin_lock instead
-move help text to Documentation/scsi/sim710.txt
-add a new debug target for debugging spinlocks
-remove the magic numbers for request_region and release_region and use
 SIM710_IOREGION_SIZE instead
-same thing for the driver name
-remove assignement to driver_template.proc_name which is already done before
 in sim710.h

I have not broken this into peaces because for all changes (except the first
of course) the corresponding lines are grouped together so it should be clear
what I've done.

A kernel with this modification has booted yesterday and was tested under
heavy loads succesfully.

What has to be done is:
-remove the remaining two cli()
-port this to the new driver model

I'm already working on this but it does not boot until now, so I'll delay this
until it works.

Eike

diff -Naur linux-2.5.59-vanilla/Documentation/scsi/sim710.txt linux-2.5.59-lacon/Documentation/scsi/sim710.txt
--- linux-2.5.59-vanilla/Documentation/scsi/sim710.txt	Thu Jan  1 01:00:00 1970
+++ linux-2.5.59-lacon/Documentation/scsi/sim710.txt	Tue Feb  4 08:50:59 2003
@@ -0,0 +1,90 @@
+Documentation for "sim710"
+
+1. Contributions
+2. General information
+3. Parameters
+4. Limitations
+
+
+1. Contributions
+
+ * MCA card detection code by Trent McNair.
+ * Fixes to not explicitly nul bss data from Xavier Bestel.
+ * Some multiboard fixes from Rolf Eike Beer.
+ * Auto probing of EISA config space from Trevor Hemsley.
+
+
+2. General information
+
+Various bits of code in this driver have been copied from 53c7,8xx,c,
+which is coyright Drew Eckhardt.  The scripts for the SCSI chip are
+compiled with the script compiler written by Drew.
+
+This is a simple driver for the NCR53c710.  More complex drivers
+for this chip (e.g. 53c7xx.c) require that the scsi chip be able to
+do DMA block moves between memory and on-chip registers, which can
+be a problem if those registers are in the I/O address space.  There
+can also be problems on hardware where the registers are memory
+mapped, if the design is such that memory-to-memory transfers initiated
+by the scsi chip cannot access the chip registers.
+
+This driver is designed to avoid these problems and is intended to
+work with any Intel machines using 53c710 chips, including various
+Compaq and NCR machines.  It was initially written for the Tadpole
+TP34V VME board which is 68030 based.
+
+
+3. Parameters
+
+The driver supports boot-time parameters similar to
+    sim710=addr:0x9000,irq:15
+and insmod parameters similar to
+    sim710="addr:0x9000 irq:15"
+
+Multiple controllers can also be set up by command line, provided the
+addr: parameter is specified first for each controller.  e.g.
+      sim710="addr:0x9000 irq:15 addr:0x8000 irq:14"
+
+To seperate the different options, ' ', '+', and ',' can be used, except
+that ',' can not be used in module parameters.  ' ' can be a pain, because
+it needs to be quoted, which causes problems with some installers.
+The command line above is completely equivalent to
+      sim710="addr:0x9000+irq:15+addr:0x8000+irq:14"
+
+The complete list of options are:
+
+ addr:0x9000		Specifies the base I/O port (or address) of the 53c710.
+ irq:15			Specifies the IRQ number used by the 53c710.
+ debug:0xffff		Generates lots of debug output. These are the constants
+			used to specify which type of debugging you want:
+			0x0000	Nothing
+			0x0001	Detailed trace of chip halt funtion
+			0x0002	All chip register read/writes
+			0x0004	Sync/async negotiation
+			0x0008	Phase mis-match handling
+			0x0010	General interrupt trace
+			0x0020	Selection timeouts
+			0x0040	Resume addresses for the script
+			0x0080	Commands and status returned
+			0x0100	Fixup of scsi addresses
+			0x0200	Disconnect/reselect handling
+			0x0400	spin_lock/spin_unlock debugging
+			0xffff	Any and all debug options
+ ignore:0x0a		Makes the driver ignore SCSI IDs 0 and 2. This ist just
+			the sum over ( 1 << SCSI ID )
+ nodisc:0x70		Prevents disconnects from IDs 6, 5 and 4.
+ noneg:0x10		Prevents SDTR negotiation on ID 4.
+ disabled:1		Completely disables the driver. When present, overrides
+			all other options.
+
+The driver will auto-probe chip addresses and IRQs now, so typically no
+parameters are needed.  Auto-probing of addresses is disabled if any addr:
+parameters are specified. The only option you can use if you want auto-probing
+is debug.
+
+
+4. Limitations
+
+ * Async only
+ * Severely lacking in error recovery
+ * 'debug:' should be per host really.
diff -Naur linux-2.5.59-vanilla/drivers/scsi/Kconfig linux-2.5.59-lacon/drivers/scsi/Kconfig
--- linux-2.5.59-vanilla/drivers/scsi/Kconfig	Fri Jan 17 03:22:42 2003
+++ linux-2.5.59-lacon/drivers/scsi/Kconfig	Tue Feb  4 11:01:39 2003
@@ -1383,8 +1383,8 @@
 	  avoid these problems and is intended to work with any Intel machines
 	  using 53c710 chips, including various Compaq and NCR machines.
 
-	  Please read the comments at the top of the file
-	  <file:drivers/scsi/sim710.c> for more information.
+	  Please read the file <file:Documentation/scsi/sim710.txt> for more
+	  information.
 
 	  If you want to compile this driver as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
diff -Naur linux-2.5.59-vanilla/drivers/scsi/sim710.c linux-2.5.59-lacon/drivers/scsi/sim710.c
--- linux-2.5.59-vanilla/drivers/scsi/sim710.c	Fri Jan 17 03:22:29 2003
+++ linux-2.5.59-lacon/drivers/scsi/sim710.c	Mon Feb  3 20:22:19 2003
@@ -3,7 +3,7 @@
  *
  *----------------------------------------------------------------------------
  *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
+ *  it under the terms of the GNU General Public License as published by
  *  the Free Software Foundation; either version 2 of the License, or
  *  (at your option) any later version.
  *
@@ -17,66 +17,12 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *----------------------------------------------------------------------------
  *
- * MCA card detection code by Trent McNair.
- * Fixes to not explicitly nul bss data from Xavier Bestel.
- * Some multiboard fixes from Rolf Eike Beer.
- * Auto probing of EISA config space from Trevor Hemsley.
- *
- * Various bits of code in this driver have been copied from 53c7,8xx,c,
- * which is coyright Drew Eckhardt.  The scripts for the SCSI chip are
- * compiled with the script compiler written by Drew.
- *
- * This is a simple driver for the NCR53c710.  More complex drivers
- * for this chip (e.g. 53c7xx.c) require that the scsi chip be able to
- * do DMA block moves between memory and on-chip registers, which can
- * be a problem if those registers are in the I/O address space.  There
- * can also be problems on hardware where the registers are memory
- * mapped, if the design is such that memory-to-memory transfers initiated
- * by the scsi chip cannot access the chip registers.
- *
- * This driver is designed to avoid these problems and is intended to
- * work with any Intel machines using 53c710 chips, including various
- * Compaq and NCR machines.  It was initially written for the Tadpole
- * TP34V VME board which is 68030 based.
- *
- * The driver supports boot-time parameters similar to
- *	sim710=addr:0x9000,irq:15
- * and insmod parameters similar to
- *	sim710="addr:0x9000 irq:15"
- *
- * Multiple controllers can also be set up by command line, provided the
- * addr: parameter is specified first for each controller.  e.g.
- *      sim710="addr:0x9000 irq:15 addr:0x8000 irq:14"
- *
- * To seperate the different options, ' ', '+', and ',' can be used, except
- * that ',' can not be used in module parameters.  ' ' can be a pain, because
- * it needs to be quoted, which causes problems with some installers.
- * The command line above is completely equivalent to
- *      sim710="addr:0x9000+irq:15+addr:0x8000+irq:14"
- *
- * The complete list of options are:
- *
- * addr:0x9000		Specifies the base I/O port (or address) of the 53C710.
- * irq:15		Specifies the IRQ number used by the 53c710.
- * debug:0xffff		Generates lots of debug output.
- * ignore:0x0a		Makes the driver ignore SCSI IDs 0 and 2.
- * nodisc:0x70		Prevents disconnects from IDs 6, 5 and 4.
- * noneg:0x10		Prevents SDTR negotiation on ID 4.
- * disabled:1		Completely disables the driver. When present, overrides
- *			all other options.
- *
- * The driver will auto-probe chip addresses and IRQs now, so typically no
- * parameters are needed.  Auto-probing of addresses is disabled if any addr:
- * parameters are specified.
- *
- * Current limitations:
- *
- * o  Async only
- * o  Severely lacking in error recovery
- * o  'debug:' should be per host really.
- *
+ * See Documentation/scsi/sim710.txt for more information.
  */
 
+#define DRV_NAME	"sim710"
+#define DRV_DESCR	"Simple NCR53c710"
+
 #include <linux/config.h>
 #include <linux/module.h>
 
@@ -99,6 +45,16 @@
 #include <asm/byteorder.h>
 #include <linux/blk.h>
 
+#include "scsi.h"
+#include "hosts.h"
+#include "sim710.h"
+
+#include <linux/stat.h>
+
+/* The SCSI Script!!! */
+
+#include "sim710_d.h"
+
 /* All targets are I/O mapped at the moment */
 #define IO_MAPPED
 
@@ -130,12 +86,6 @@
 
 #endif
 
-#include "scsi.h"
-#include "hosts.h"
-#include "sim710.h"
-
-#include<linux/stat.h>
-
 #define DEBUG
 #undef DEBUG_LIMIT_INTS		/* Define to 10 to hang driver after 10 ints */
 
@@ -152,6 +102,7 @@
 #define DEB_CMND	0x0080	/* Commands and status returned		*/
 #define DEB_FIXUP	0x0100	/* Fixup of scsi addresses		*/
 #define DEB_DISC	0x0200	/* Disconnect/reselect handling		*/
+#define DEB_SLOCK	0x0400	/* spin_lock/spin_unlock debugging	*/
 
 #define DEB_ANY		0xffff	/* Any and all debug options		*/
 
@@ -167,7 +118,7 @@
  */
 
 #define SCSI_DONE(cmd)	{ \
-	DEB(DEB_CMND, printk("scsi%d: Complete %08x\n", \
+	DEB(DEB_CMND, printk(KERN_DEBUG "scsi%d: Complete %08x\n", \
 		host->host_no, cmd->result)); \
 	if (cmd->result) \
 	    hostdata->negotiate |= (1 << cmd->target); \
@@ -178,6 +129,8 @@
 #define offsetof(t, m)      ((size_t) (&((t *)0)->m))
 #endif
 
+#define SIM710_IOREGION_SIZE	0x40
+
 #define STATE_INITIALISED	0
 #define STATE_HALTED		1
 #define STATE_IDLE		2
@@ -209,10 +162,6 @@
 static unsigned int bases[MAXBOARDS];	/* Base addresses of chips */
 static unsigned int irq_vectors[MAXBOARDS]; /* IRQ vectors used by chips */
 
-/* The SCSI Script!!! */
-
-#include "sim710_d.h"
-
 /* Now define offsets in the DSA, as (A_dsa_xxx/4) */
 
 #define DSA_SELECT	(A_dsa_select/4)
@@ -287,12 +236,14 @@
     struct sim710_hostdata *hostdata = (struct sim710_hostdata *)
        host->hostdata[0];
 
-    save_flags(flags);
-    cli();
-    printk("scsi%d: Chip register contents:\n", host->host_no);
-    printk(" (script at virt %p, bus %lx)\n",
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "ncr_dump: trying to get spinlock for board at 0x%x\n", host->unique_id));
+    spin_lock_irqsave(host->host_lock, flags);
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "ncr_dump: got spinlock\n"));
+
+    printk(KERN_DEBUG "scsi%d: Chip register contents:\n", host->host_no);
+    printk(KERN_DEBUG " (script at virt %p, bus %lx)\n",
            hostdata->script, virt_to_bus(hostdata->script));
-    printk(" 00  sien:  %02x  sdid:  %02x  scntl1:%02x  scntl0:%02x\n"
+    printk(KERN_DEBUG " 00  sien:  %02x  sdid:  %02x  scntl1:%02x  scntl0:%02x\n"
 	   " 04  socl:  %02x  sodl:  %02x  sxfer: %02x  scid:  %02x\n"
 	   " 08  sbcl:  %02x  sbdl:  %02x  sidl:  %02x  sfbr:  %02x\n"
 	   " 0C  sstat2:%02x  sstat1:%02x  sstat0:%02x  dstat: %02x\n"
@@ -320,7 +271,8 @@
 	  NCR_read8(DWT_REG), NCR_read8(DIEN_REG), NCR_read8(DMODE_REG),
 	  NCR_read32(ADDER_REG));
 
-    restore_flags(flags);
+    spin_unlock_irqrestore(host->host_lock, flags);
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "ncr_dump: released spinlock\n"));
 }
 
 
@@ -356,7 +308,7 @@
 	}
 #endif
 	else if (no_of_boards == 0) {
-	    printk("sim710: Invalid parameters, addr: must come first\n");
+	    printk(KERN_WARNING DRV_NAME ": Invalid parameters, addr: must come first\n");
 	    no_of_boards = -1;
 	    return 1;
 	}
@@ -368,12 +320,9 @@
 	    opt_nodisc[no_of_boards-1] = val;
 	else if	(!strncmp(cur, "noneg:", 6))
 	    opt_noneg[no_of_boards-1] = val;
-	else if	(!strncmp(cur, "disabled:", 9)) {
-	    no_of_boards = -1;
-	    return 1;
-	}
 	else {
-	    printk("sim710: unexpected boot option '%.*s'\n", (int)(pc-cur+1), cur);
+	    if (strncmp(cur, "disabled:", 9))
+		printk(KERN_WARNING DRV_NAME ": unexpected boot option '%.*s'\n", (int)(pc-cur+1), cur);
 	    no_of_boards = -1;
 	    return 1;
 	}
@@ -442,8 +391,10 @@
     int timeout;
     int res = 0;
 
-    save_flags(flags);
-    cli();
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "ncr_halt: trying to get spinlock for board at 0x%x\n", host->unique_id));
+    spin_lock_irqsave(host->host_lock, flags);
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "ncr_halt: got spinlock\n"));
+    
     /* Stage 0 : eat all interrupts
        Stage 1 : set ABORT
        Stage 2 : eat all but abort interrupts
@@ -453,29 +404,29 @@
      */
     for (stage = 0, timeout = 50000; timeout; timeout--) {
 	if (stage == 1) {
-	    DEB(DEB_HALT, printk("ncr_halt: writing ISTAT_ABRT\n"));
+	    DEB(DEB_HALT, printk(KERN_DEBUG "ncr_halt: writing ISTAT_ABRT\n"));
 	    NCR_write8(ISTAT_REG, ISTAT_ABRT);
 	    ++stage;
 	}
 	istat = NCR_read8 (ISTAT_REG);
 	if (istat & ISTAT_SIP) {
-	    DEB(DEB_HALT, printk("ncr_halt: got ISTAT_SIP, istat=%02x\n", istat));
+	    DEB(DEB_HALT, printk(KERN_DEBUG "ncr_halt: got ISTAT_SIP, istat=%02x\n", istat));
 	    tmp = NCR_read8(SSTAT0_REG);
-	    DEB(DEB_HALT, printk("ncr_halt: got SSTAT0_REG=%02x\n", tmp));
+	    DEB(DEB_HALT, printk(KERN_DEBUG "ncr_halt: got SSTAT0_REG=%02x\n", tmp));
 	} else if (istat & ISTAT_DIP) {
-	    DEB(DEB_HALT, printk("ncr_halt: got ISTAT_DIP, istat=%02x\n", istat));
+	    DEB(DEB_HALT, printk(KERN_DEBUG "ncr_halt: got ISTAT_DIP, istat=%02x\n", istat));
 	    tmp = NCR_read8(DSTAT_REG);
-	    DEB(DEB_HALT, printk("ncr_halt: got DSTAT_REG=%02x\n", tmp));
+	    DEB(DEB_HALT, printk(KERN_DEBUG "ncr_halt: got DSTAT_REG=%02x\n", tmp));
 	    if (stage == 2) {
 		if (tmp & DSTAT_ABRT) {
-	    	    DEB(DEB_HALT, printk("ncr_halt: got DSTAT_ABRT, clearing istat\n"));
+		    DEB(DEB_HALT, printk(KERN_DEBUG "ncr_halt: got DSTAT_ABRT, clearing istat\n"));
 		    NCR_write8(ISTAT_REG, 0);
 		    ++stage;
 		} else {
 		    res = 1;
 		    break;
-	    	}
-    	    }
+		}
+	    }
 	}
 	if (!(istat & (ISTAT_SIP|ISTAT_DIP))) {
 	    if (stage == 0)
@@ -485,7 +436,8 @@
 	}
 	udelay(10);
     }
-    restore_flags(flags);
+    spin_unlock_irqrestore(host->host_lock, flags);
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "ncr_halt: released spinlock\n"));
 
     if (timeout == 0 || res) {
 	printk(KERN_ALERT "scsi%d: could not halt NCR chip\n", host->host_no);
@@ -514,8 +466,10 @@
 {
     unsigned long flags;
 
-    save_flags(flags);
-    cli();
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "sim710_soft_reset: trying to get spinlock for board at 0x%x\n", host->unique_id));
+    spin_lock_irqsave(host->host_lock, flags);
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "sim710_soft_reset: got spinlock\n"));
+
     /*
      * Do a soft reset of the chip so that everything is
      * reinitialized to the power-on state.
@@ -557,7 +511,8 @@
     NCR_write8(SIEN_REG_700,
 	    SIEN_PAR | SIEN_700_STO | SIEN_RST | SIEN_UDC | SIEN_SGE | SIEN_MA);
 
-    restore_flags(flags);
+    spin_unlock_irqrestore(host->host_lock, flags);
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "sim710_soft_reset: released spinlock\n"));
 }
 
 
@@ -581,9 +536,9 @@
     memcpy (hostdata->script, SCRIPT, sizeof(SCRIPT));
     for (i = 0; i < PATCHES; i++)
 	hostdata->script[LABELPATCHES[i]] += isa_virt_to_bus(hostdata->script);
-    patch_abs_32 (hostdata->script, 0, reselected_identify, 
+    patch_abs_32 (hostdata->script, 0, reselected_identify,
     	isa_virt_to_bus((void *)&(hostdata->reselected_identify)));
-    patch_abs_32 (hostdata->script, 0, msgin_buf, 
+    patch_abs_32 (hostdata->script, 0, msgin_buf,
     	isa_virt_to_bus((void *)&(hostdata->msgin_buf[0])));
     patch_abs_32 (hostdata->script, 0, msg_reject,
 	isa_virt_to_bus((void *)&(hostdata->msg_reject)));
@@ -617,7 +572,7 @@
     u32 resume_offset;
 
     if (resa && hostdata->negotiate & (1 << cmd->target)) {
-	DEB(DEB_SYNC, printk("scsi%d: Response to host SDTR = %02x %02x\n",
+	DEB(DEB_SYNC, printk(KERN_DEBUG "scsi%d: Response to host SDTR = %02x %02x\n",
 		host->host_no, hostdata->msgin_buf[3], hostdata->msgin_buf[4]));
 	/* We always issue an SDTR with the identify, so we must issue
 	 * the CDB next.
@@ -626,7 +581,7 @@
 	hostdata->negotiate &= ~(1 << cmd->target);
     }
     else {
-	DEB(DEB_SYNC, printk("scsi%d: Target initiated SDTR = %02x %02x\n",
+	DEB(DEB_SYNC, printk(KERN_DEBUG "scsi%d: Target initiated SDTR = %02x %02x\n",
 		host->host_no, hostdata->msgin_buf[3], hostdata->msgin_buf[4]));
 	memcpy(targdata->dsa_msgout, async_message, sizeof(async_message));
 	targdata->dsa[DSA_MSGOUT] = sizeof(async_message);
@@ -659,7 +614,7 @@
 
     if (ddir) {
     /* Receive */
-	if (synchronous) 
+	if (synchronous)
 	    count += (NCR_read8 (SSTAT2_REG) & SSTAT2_FF_MASK) >> SSTAT2_FF_SHIFT;
 	else
 	    if (NCR_read8 (SSTAT1_REG) & SSTAT1_ILF)
@@ -709,7 +664,7 @@
 	resume_offset = Ent_reselect;
 	break;
     default:
-	printk("scsi%d: Unexpected Illegal Instruction, script[%04x]\n",
+	printk(KERN_WARNING "scsi%d: Unexpected Illegal Instruction, script[%04x]\n",
 		host->host_no, index);
 	sim710_errors++;
 	/* resume_offset is zero, which will cause host reset */
@@ -733,7 +688,7 @@
     sbcl = NCR_read8(SBCL_REG) & SBCL_PHASE_MASK;
     index = (u32)((u32 *)(isa_bus_to_virt(NCR_read32(DSP_REG))) - hostdata->script);
 
-    DEB(DEB_PMM, printk("scsi%d: Phase mismatch, phase %s (%x) at script[0x%x]\n",
+    DEB(DEB_PMM, printk(KERN_DEBUG "scsi%d: Phase mismatch, phase %s (%x) at script[0x%x]\n",
 	host->host_no, sbcl_to_phase(sbcl), sbcl, index));
     DEB(DEB_PMM, print_command(cmd->cmnd));
 
@@ -749,18 +704,18 @@
 	     * byte of an identify message, regardless of whether we
 	     * have more bytes to send!
 	     */
-	    printk("scsi%d: Unexpected switch to CMDOUT during IDENTIFY\n",
+	    printk(KERN_WARNING "scsi%d: Unexpected switch to CMDOUT during IDENTIFY\n",
 		host->host_no);
 	    resume_offset = Ent_resume_cmd;
 	}
 	else if (sbcl == SBCL_PHASE_STATIN) {
 	    /* Some devices do this on parity error, at least */
-	    printk("scsi%d: Unexpected switch to STATUSIN on initial message out\n",
+	    printk(KERN_WARNING "scsi%d: Unexpected switch to STATUSIN on initial message out\n",
 		host->host_no);
 	    resume_offset = Ent_end_data_trans;
 	}
 	else {
-	    printk("scsi%d: Unexpected phase change to %s on initial msgout\n",
+	    printk(KERN_WARNING "scsi%d: Unexpected phase change to %s on initial msgout\n",
 		host->host_no, sbcl_to_phase(sbcl));
 	    /* resume_offset is zero, which will cause a host reset */
 	}
@@ -779,14 +734,14 @@
 	oaddr = targdata->dsa[DSA_DATAIN + sg_id * 2 + 1];
 	residual = datapath_residual (host);
 	if (residual)
-	    printk("scsi%d: Residual count %d on DataIn - NOT expected!!!",
+	    printk(KERN_WARNING "scsi%d: Residual count %d on DataIn - NOT expected!!!",
 		host->host_no, residual);
 	naddr = NCR_read32(DNAD_REG) - residual;
 	nlen  = (NCR_read32(DBC_REG) & 0x00ffffff) + residual;
-	DEB(DEB_PMM, printk("scsi%d: DIN sg %d, old %08x/%08x, new %08x/%08x (%d)\n",
+	DEB(DEB_PMM, printk(KERN_DEBUG "scsi%d: DIN sg %d, old %08x/%08x, new %08x/%08x (%d)\n",
 		host->host_no, sg_id, oaddr, olen, naddr, nlen, residual));
 	if (oaddr+olen != naddr+nlen) {
-	    printk("scsi%d: PMM DIN counts error: 0x%x + 0x%x != 0x%x + 0x%x",
+	    printk(KERN_WARNING "scsi%d: PMM DIN counts error: 0x%x + 0x%x != 0x%x + 0x%x",
 		host->host_no, oaddr, olen, naddr, nlen);
 	}
 	else {
@@ -809,10 +764,10 @@
 	residual = datapath_residual (host);
 	naddr = NCR_read32(DNAD_REG) - residual;
 	nlen  = (NCR_read32(DBC_REG) & 0x00ffffff) + residual;
-	DEB(DEB_PMM, printk("scsi%d: DOUT sg %d, old %08x/%08x, new %08x/%08x (%d)\n",
+	DEB(DEB_PMM, printk(KERN_DEBUG "scsi%d: DOUT sg %d, old %08x/%08x, new %08x/%08x (%d)\n",
 		host->host_no, sg_id, oaddr, olen, naddr, nlen, residual));
 	if (oaddr+olen != naddr+nlen) {
-	    printk("scsi%d: PMM DOUT counts error: 0x%x + 0x%x != 0x%x + 0x%x",
+	    printk(KERN_WARNING "scsi%d: PMM DOUT counts error: 0x%x + 0x%x != 0x%x + 0x%x",
 		host->host_no, oaddr, olen, naddr, nlen);
 	}
 	else {
@@ -825,12 +780,12 @@
 	/* Change to Status In at some random point; probably wants to report a
 	 * parity error or similar.
 	 */
-	printk("scsi%d: Unexpected phase change to STATUSIN at index 0x%x\n",
+	printk(KERN_WARNING "scsi%d: Unexpected phase change to STATUSIN at index 0x%x\n",
 		host->host_no, index);
 	resume_offset = Ent_end_data_trans;
     }
     else {
-	printk("scsi%d: Unexpected phase change to %s at index 0x%x\n",
+	printk(KERN_WARNING "scsi%d: Unexpected phase change to %s at index 0x%x\n",
 		host->host_no, sbcl_to_phase(sbcl), index);
 	/* resume_offset is zero, which will cause a host reset */
     }
@@ -893,7 +848,7 @@
 	break;
     case A_int_data_bad_phase:
 	sbcl = NCR_read8(SBCL_REG) & SBCL_PHASE_MASK;
-	printk("scsi%d: int_data_bad_phase, phase %s (%x)\n",
+	printk(KERN_WARNING "scsi%d: int_data_bad_phase, phase %s (%x)\n",
 		host->host_no, sbcl_to_phase(sbcl), sbcl);
 	break;
     case A_int_bad_msg1:
@@ -912,7 +867,7 @@
     case A_int_not_rej:
     default:
 	sbcl = NCR_read8(SBCL_REG) & SBCL_PHASE_MASK;
-	printk("scsi%d: Unimplemented script interrupt: %08x, phase %s\n",
+	printk(KERN_WARNING "scsi%d: Unimplemented script interrupt: %08x, phase %s\n",
 		host->host_no, dsps, sbcl_to_phase(sbcl));
 	sim710_errors++;
 	/* resume_offset is zero, which will cause a host reset */
@@ -929,9 +884,12 @@
     struct Scsi_Host *host = dev_id;
     unsigned long flags;
 
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "do_sim710_intr_handle: trying to get spinlock for board at 0x%x\n", host->unique_id));
     spin_lock_irqsave(host->host_lock, flags);
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "do_sim710_intr_handle: got spinlock\n"));
     sim710_intr_handle(irq, host, regs);
     spin_unlock_irqrestore(host->host_lock, flags);
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "do_sim710_intr_handle: released spinlock\n"));
 }
 
 
@@ -964,15 +922,15 @@
 				 * between accesses to sstat0 and dstat ??? */
 	    dstat = NCR_read8(DSTAT_REG);
 	}
-	DEB(DEB_INTS, printk("scsi%d: Int %d, istat %02x, sstat0 %02x "
+	DEB(DEB_INTS, printk(KERN_DEBUG "scsi%d: Int %d, istat %02x, sstat0 %02x "
 		"dstat %02x, dsp [%04x], scratch %02x\n",
 	    host->host_no, sim710_intrs, istat, sstat0, dstat,
 	    (u32 *)(isa_bus_to_virt(NCR_read32(DSP_REG))) - hostdata->script,
 	    scratch));
 	if (scratch & 0x100) {
 	    u8 *p = hostdata->msgin_buf;
-	    
-	    DEB(DEB_INTS, printk("  msgin_buf: %02x %02x %02x %02x\n",
+
+	    DEB(DEB_INTS, printk(KERN_DEBUG "  msgin_buf: %02x %02x %02x %02x\n",
 			p[0], p[1], p[2], p[3]));
 	}
 	if ((dstat & DSTAT_SIR) && dsps == A_int_reselected) {
@@ -985,7 +943,7 @@
 	    int id = 0;
 
 	    if (!(lcrc & 0x7f)) {
-		printk("scsi%d: Reselected with LCRC = %02x\n",
+		printk(KERN_INFO "scsi%d: Reselected with LCRC = %02x\n",
 			host->host_no, lcrc);
 		cmd = NULL;
 	    }
@@ -994,13 +952,13 @@
 		    id++;
 		    lcrc >>= 1;
 		}
-		DEB(DEB_DISC, printk("scsi%d: Reselected by ID %d\n",
+		DEB(DEB_DISC, printk(KERN_DEBUG "scsi%d: Reselected by ID %d\n",
 			host->host_no, id));
 		if (hostdata->running) {
 		    /* Clear SIGP */
 		    (void)NCR_read8(CTEST2_REG_700);
 
-		    DEB(DEB_DISC, printk("scsi%d: Select of %d interrupted "
+		    DEB(DEB_DISC, printk(KERN_DEBUG "scsi%d: Select of %d interrupted "
 				"by reselect from %d (%p)\n",
 				host->host_no, hostdata->running->target,
 				id, hostdata->target[id].cur_cmd));
@@ -1016,8 +974,8 @@
 	    cmd = hostdata->running;
 
 	if (!cmd) {
-	    printk("scsi%d: No active command!\n", host->host_no);
-	    printk("scsi%d: Int %d, istat %02x, sstat0 %02x "
+	    printk(KERN_INFO "scsi%d: No active command!\n", host->host_no);
+	    printk(KERN_INFO "scsi%d: Int %d, istat %02x, sstat0 %02x "
 		"dstat %02x, dsp [%04x], scratch %02x, dsps %08x\n",
 		host->host_no, sim710_intrs, istat, sstat0, dstat,
 		(u32 *)(isa_bus_to_virt(NCR_read32(DSP_REG))) - hostdata->script,
@@ -1025,20 +983,20 @@
 	    /* resume_offset is zero, which will cause a host reset */
 	}
 	else if (sstat0 & SSTAT0_700_STO) {
-	    DEB(DEB_TOUT, printk("scsi%d: Selection timeout\n", host->host_no));
+	    DEB(DEB_TOUT, printk(KERN_DEBUG "scsi%d: Selection timeout\n", host->host_no));
 	    cmd->result = DID_NO_CONNECT << 16;
 	    SCSI_DONE(cmd);
 	    hostdata->target[cmd->target].cur_cmd = NULL;
 	    resume_offset = Ent_reselect;
 	}
 	else if (sstat0 & (SSTAT0_SGE|SSTAT0_UDC|SSTAT0_RST|SSTAT0_PAR)) {
-	    printk("scsi%d: Serious error, sstat0 = %02x\n", host->host_no,
+	    printk(KERN_ERR "scsi%d: Serious error, sstat0 = %02x\n", host->host_no,
 			    sstat0);
 	    sim710_errors++;
 	    /* resume_offset is zero, which will cause a host reset */
 	}
 	else if (dstat & (DSTAT_BF|DSTAT_ABRT|DSTAT_SSI|DSTAT_WTD)) {
-	    printk("scsi%d: Serious error, dstat = %02x\n", host->host_no,
+	    printk(KERN_ERR "scsi%d: Serious error, dstat = %02x\n", host->host_no,
 			    dstat);
 	    sim710_errors++;
 	    /* resume_offset is zero, which will cause a host reset */
@@ -1055,7 +1013,7 @@
 	}
 	else {
 	    sim710_errors++;
-	    printk("scsi%d: Spurious interrupt!\n", host->host_no);
+	    printk(KERN_WARNING "scsi%d: Spurious interrupt!\n", host->host_no);
 	    /* resume_offset is zero, which will cause a host reset */
 	}
     }
@@ -1067,7 +1025,7 @@
 	}
 	else
 	    hostdata->state = STATE_BUSY;
-	DEB(DEB_RESUME, printk("scsi%d: Resuming at script[0x%x]\n",
+	DEB(DEB_RESUME, printk(KERN_DEBUG "scsi%d: Resuming at script[0x%x]\n",
 		host->host_no, resume_offset/4));
 #ifdef DEBUG_LIMIT_INTS
 	if (sim710_intrs < DEBUG_LIMIT_INTS)
@@ -1081,7 +1039,7 @@
 	    run_process_issue_queue(hostdata);
     }
     else {
-	printk("scsi%d: Failed to handle interrupt.  Failing commands "
+	printk(KERN_ERR "scsi%d: Failed to handle interrupt.  Failing commands "
 		"and resetting SCSI bus and chip\n", host->host_no);
 	mdelay(1000);		/* Give chance to read screen!! */
 	full_reset(host);
@@ -1098,7 +1056,7 @@
     int i, datain, dataout, sg_start;
     u32 *dip, *dop, dsa;
 
-    DEB(DEB_CMND, printk("scsi%d: id%d starting ", host->host_no,
+    DEB(DEB_CMND, printk(KERN_DEBUG "scsi%d: id%d starting ", host->host_no,
 		cmd->target));
     DEB(DEB_CMND, print_command(cmd->cmnd));
 
@@ -1139,7 +1097,7 @@
 	    targdata->dsa[DSA_MSGOUT] = 1;
 	}
 	else {
-	    DEB(DEB_SYNC, printk("scsi%d: Negotiating async transfers "
+	    DEB(DEB_SYNC, printk(KERN_DEBUG "scsi%d: Negotiating async transfers "
 		"for ID %d\n",
 		host->host_no, cmd->target));
 	    memcpy(targdata->dsa_msgout+1, async_message, sizeof(async_message));
@@ -1301,7 +1259,7 @@
 	return 0;
     }
 
-    DEB(DEB_CMND, printk("scsi%d: id%d queuing ", host->host_no,
+    DEB(DEB_CMND, printk(KERN_DEBUG "scsi%d: id%d queuing ", host->host_no,
 		cmd->target));
     DEB(DEB_CMND, print_command(cmd->cmnd));
 
@@ -1310,11 +1268,12 @@
     cmd->SCp.ptr = NULL;
     cmd->SCp.buffer = NULL;
 
-    save_flags(flags);
-    cli();
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "sim710_queuecommand: trying to get spinlock for board at 0x%x\n", host->unique_id));
+    spin_lock_irqsave(host->host_lock, flags);
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "sim710_queuecommand: got spinlock\n"));
 
     if (ignore_ids[hostdata->chip] & (1 << cmd->target)) {
-	printk("scsi%d: ignoring target %d\n", host->host_no, cmd->target);
+	printk(KERN_INFO "scsi%d: ignoring target %d\n", host->host_no, cmd->target);
 	cmd->result = (DID_BAD_TARGET << 16);
 	done(cmd);
 	restore_flags (flags);
@@ -1339,7 +1298,8 @@
                 tmp = (Scsi_Cmnd *) tmp->SCp.ptr);
         tmp->SCp.ptr = (unsigned char *) cmd;
     }
-    restore_flags (flags);
+    spin_unlock_irqrestore(host->host_lock, flags);
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "sim710_queuecommand: released spinlock\n"));
     run_process_issue_queue(hostdata);
     return 0;
 }
@@ -1371,7 +1331,7 @@
 #endif
 
     if (no_of_boards < 0) {
-	printk("sim710: NCR53C710 driver disabled\n");
+	printk(KERN_INFO DRV_NAME ": NCR53C710 driver disabled\n");
 	return 0;
     }
 
@@ -1436,7 +1396,7 @@
 		    irq_vectors[no_of_boards] =
 				irq_01bb_by_pos[((pos[0] & 0xC0) >> 6)];
 		    if (bases[no_of_boards] == 0x0000)
-			printk("sim710: NCR53C710 Adapter ID 0x01bb is disabled.\n");
+			printk(KERN_INFO DRV_NAME ": NCR53C710 Adapter ID 0x01bb is disabled.\n");
 		    else {
 			no_of_boards++;
 			if ( *id_to_check == 0x01bb )
@@ -1452,7 +1412,7 @@
 		    irq_vectors[no_of_boards] =
 				irq_004f_by_pos[((pos[0] & 0x70) >> 4) - 4];
 		    if (bases[no_of_boards] == 0x0000)
-			printk("sim710: NCR53C710 Adapter ID 0x004f is disabled.\n");
+			printk(KERN_INFO DRV_NAME ": NCR53C710 Adapter ID 0x004f is disabled.\n");
 		    else {
 			no_of_boards++;
 			mca_set_adapter_name(slot,
@@ -1470,8 +1430,8 @@
     if (no_of_boards == 0) {
 	int io_addr;
 	/* reverse probe, so my on-board controller at 0x9000 is always scsi0 */
-	for (io_addr = 0x9000; no_of_boards < MAXBOARDS && io_addr >= 0x1000; io_addr -= 0x1000) {
-	    if (request_region(io_addr, 0x40, "sim710") != NULL) {
+	for (io_addr = 0x9000; no_of_boards < MAXBOARDS && io_addr > 0x0000; io_addr -= 0x1000) {
+	    if (request_region(io_addr, SIM710_IOREGION_SIZE, DRV_NAME) != NULL) {
 		int id0 = inw(io_addr + 0xc80);
 		int id1 = inw(io_addr + 0xc82);
 		/* The on-board controller on my Proliant 2000 is 0x1044,
@@ -1501,19 +1461,19 @@
 			    irq_vectors[no_of_boards] = 9;
 			    break;
 			default:
-			    printk("sim710.c: irq nasty\n");
+			    printk(KERN_WARNING DRV_NAME ": irq nasty\n");
 		    }
 #endif
 		    no_of_boards++;
 		}
-		release_region(io_addr, 64);
+		release_region(io_addr, SIM710_IOREGION_SIZE);
 	    }
 	}
     }
 #endif
-      
+
     if (!no_of_boards) {
-	printk("sim710: No NCR53C710 adapter found.\n");
+	printk(KERN_INFO DRV_NAME ": No NCR53C710 adapter found.\n");
 	return 0;
     }
 
@@ -1523,17 +1483,17 @@
 	hostdata_order++;
     size = PAGE_SIZE << hostdata_order;
 
-    DEB(DEB_ANY, printk("sim710: hostdata %d bytes, size %d, order %d\n",
+    DEB(DEB_ANY, printk(KERN_DEBUG DRV_NAME ": hostdata %d bytes, size %d, order %d\n",
 	sizeof(struct sim710_hostdata), size, hostdata_order));
 
-    tpnt->proc_name = "sim710";
+    tpnt->proc_name = DRV_NAME;
 
     memset(our_hosts, 0, sizeof(our_hosts));
     for (indx = 0; indx < no_of_boards; indx++) {
         unsigned long page = __get_free_pages(GFP_ATOMIC, hostdata_order);
         if(page == 0UL)
         {
-		printk(KERN_WARNING "sim710: out of memory registering board %d.\n", indx);
+		printk(KERN_WARNING DRV_NAME ": out of memory registering board %d.\n", indx);
 		break;
         }
 	host = scsi_register(tpnt, 4);
@@ -1548,9 +1508,9 @@
 	scsi_id = 7;
 	base_addr = bases[indx];
 	requested_irq = irq_vectors[indx];
-	printk("scsi%d: Configuring Sim710 (SCSI-ID %d) at %x, IRQ %d\n",
+	printk(KERN_INFO "scsi%d: Configuring Sim710 (SCSI-ID %d) at 0x%x, IRQ %d\n",
 			host->host_no, scsi_id, base_addr, requested_irq);
-	DEB(DEB_ANY, printk("sim710: hostdata = %p (%d bytes), dsa0 = %p\n",
+	DEB(DEB_ANY, printk(KERN_DEBUG DRV_NAME ": hostdata = %p (%d bytes), dsa0 = %p\n",
 			hostdata, sizeof(struct sim710_hostdata),
 			 hostdata->target[0].dsa));
 	hostdata->chip = indx;
@@ -1563,18 +1523,24 @@
 	if (ncr_halt(host)) {
 	    free_pages(host->hostdata[0], hostdata_order);
 	    scsi_unregister (host);
-	    printk("scsi%d: Failed to initialise 53c710 at address %x\n",
+	    printk(KERN_WARNING "scsi%d: Failed to initialise 53c710 at address 0x%x\n",
 			host->host_no, base_addr);
 	    continue;
 	}
 	DEB(DEB_ANY,ncr_dump(host));
 	revision = (NCR_read8(CTEST8_REG) & 0xF0) >> 4;
-	printk("scsi%d: Revision 0x%x\n",host->host_no,revision);
+	printk(KERN_INFO "scsi%d: Revision 0x%x\n",host->host_no,revision);
 	sim710_soft_reset(host);
 
 	sim710_driver_init(host);
 
-	request_region((u32)host->base, 64, "sim710");
+	if ( ! request_region((u32)host->base, SIM710_IOREGION_SIZE, DRV_NAME) ) {
+	    free_pages(host->hostdata[0], hostdata_order);
+	    scsi_unregister (host);
+	    printk(KERN_WARNING "scsi%d: Failed to request region for NCR53c710 at address 0x%x\n",
+			host->host_no, base_addr);
+	    continue;
+	}
 	/* Now run test1 */
 	hostdata->test1_src = 0x53c710aa;
 	hostdata->test1_dst = 0x76543210;
@@ -1591,43 +1557,43 @@
 	probed_irq = probe_irq_off(irq_mask);
 	if (requested_irq == 0) {
 	    if (probed_irq > 0) {
-		printk("scsi%d: Chip is using IRQ %d\n", host->host_no,
+		printk(KERN_INFO "scsi%d: Chip is using IRQ %d\n", host->host_no,
 			probed_irq);
 		requested_irq = host->irq = probed_irq;
 	    }
 	    else {
-		printk("scsi%d: Failed to probe for IRQ (returned %d)\n",
+		printk(KERN_WARNING "scsi%d: Failed to probe for IRQ (returned %d)\n",
 			host->host_no, probed_irq);
 		ncr_halt(host);
 		free_pages(host->hostdata[0], hostdata_order);
 		scsi_unregister (host);
-		release_region((u32)host->base, 64);
+		release_region((u32)host->base, SIM710_IOREGION_SIZE);
 		continue;
 	    }
 	}
 	else if (probed_irq > 0 && probed_irq != requested_irq)
-	    printk("scsi%d: WARNING requested IRQ %d, but probed as %d\n",
+	    printk(KERN_WARNING "scsi%d: WARNING requested IRQ %d, but probed as %d\n",
 			host->host_no, requested_irq, probed_irq);
 	else if (probed_irq <= 0)
-	    printk("scsi%d: WARNING IRQ probe failed, (returned %d)\n",
+	    printk(KERN_WARNING "scsi%d: WARNING IRQ probe failed, (returned %d)\n",
 			host->host_no, probed_irq);
-	
+
 	dsps = NCR_read32(DSPS_REG);
 	if (hostdata->test1_dst != 0x53c710aa || dsps != A_int_test1) {
 	    if (hostdata->test1_dst != 0x53c710aa)
-		printk("scsi%d: test 1 FAILED: data: exp 0x53c710aa, got 0x%08x\n",
+		printk(KERN_WARNING "scsi%d: test 1 FAILED: data: exp 0x53c710aa, got 0x%08x\n",
 			host->host_no, hostdata->test1_dst);
 	    if (dsps != A_int_test1)
-		printk("scsi%d: test 1 FAILED: dsps: exp 0x%08x, got 0x%08x\n",
+		printk(KERN_WARNING "scsi%d: test 1 FAILED: dsps: exp 0x%08x, got 0x%08x\n",
 			host->host_no, A_int_test1, dsps);
 	    ncr_dump(host);
 	    ncr_halt(host);
 	    free_pages(host->hostdata[0], hostdata_order);
 	    scsi_unregister (host);
-	    release_region((u32)host->base, 64);
+	    release_region((u32)host->base, SIM710_IOREGION_SIZE);
 	    continue;
 	}
-	printk("scsi%d: test 1 completed ok.\n", host->host_no);
+	printk(KERN_INFO "scsi%d: test 1 completed ok.\n", host->host_no);
 
 	NCR_write32(DSP_REG, virt_to_bus(hostdata->script+Ent_reselect/4));
 	hostdata->state = STATE_IDLE;
@@ -1641,7 +1607,7 @@
 	if (request_irq(host->irq, do_sim710_intr_handle,
                        SA_INTERRUPT | SA_SHIRQ, "sim710", host))
 	{
-	    printk("scsi%d : IRQ%d not free, detaching\n",
+	    printk(KERN_WARNING "scsi%d : IRQ%d not free, detaching\n",
 			host->host_no, host->irq);
 	    ncr_halt(host);
 	    free_pages(host->hostdata[0], hostdata_order);
@@ -1658,7 +1624,7 @@
 {
     struct Scsi_Host * host = cmd->host;
 
-    printk("scsi%d: Unable to abort command for target %d\n",
+    printk(KERN_ERR "scsi%d: Unable to abort command for target %d\n",
 	   host->host_no, cmd->target);
     return FAILED;
 }
@@ -1672,7 +1638,7 @@
 {
     struct Scsi_Host * host = SCpnt->host;
 
-    printk("scsi%d: Unable to send Bus Device Reset for target %d\n",
+    printk(KERN_ERR "scsi%d: Unable to send Bus Device Reset for target %d\n",
 	   host->host_no, SCpnt->target);
     return FAILED;
 }
@@ -1686,7 +1652,7 @@
 {
     struct Scsi_Host * host = SCpnt->host;
 
-    printk("scsi%d: Unable to do SCSI bus reset\n", host->host_no);
+    printk(KERN_ERR "scsi%d: Unable to do SCSI bus reset\n", host->host_no);
     return FAILED;
 }
 
@@ -1701,8 +1667,9 @@
     u32 istat, dstat = 0, sstat0 = 0, sstat1 = 0, dsp, dsps, scratch;
     unsigned long flags;
 
-    save_flags(flags);
-    cli();
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "full_reset: trying to get spinlock for board at 0x%x\n", host->unique_id));
+    spin_lock_irqsave(host->host_lock, flags);
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "full_reset: got spinlock\n"));
 
     istat = NCR_read8(ISTAT_REG);
     if (istat & ISTAT_SIP) {
@@ -1717,19 +1684,20 @@
 	restore_flags(flags);
 	return FAILED;
     }
-    restore_flags(flags);
+    spin_unlock_irqrestore(host->host_lock, flags);
+    DEB(DEB_SLOCK, printk(KERN_DEBUG "full_reset: released spinlock\n"));
     dsp = NCR_read32(DSP_REG);
     dsps = NCR_read32(DSPS_REG);
     scratch = NCR_read32(SCRATCH_REG);
-    printk("scsi%d: istat = %02x, sstat0 = %02x, sstat1 = %02x, dstat = %02x\n",
+    printk(KERN_INFO "scsi%d: istat = %02x, sstat0 = %02x, sstat1 = %02x, dstat = %02x\n",
 		host->host_no, istat, sstat0, sstat1, dstat);
-    printk("scsi%d: dsp = %08x (script[0x%04x]), dsps = %08x, scratch = %08x\n",
+    printk(KERN_INFO "scsi%d: dsp = %08x (script[0x%04x]), dsps = %08x, scratch = %08x\n",
 		host->host_no, dsp,
 		((u32)bus_to_virt(dsp) - (u32)hostdata->script)/4, dsps, scratch);
 
     for (target = 0; target < 7; target++) {
 	if ((cmd = hostdata->target[target].cur_cmd)) {
-	    printk("scsi%d: Failing command for ID%d\n",
+	    printk(KERN_WARNING "scsi%d: Failing command for ID%d\n",
 			host->host_no, target);
 	    cmd->result = DID_RESET << 16;
 	    cmd->scsi_done(cmd);
@@ -1757,7 +1725,7 @@
 {
     struct Scsi_Host * host = SCpnt->host;
 
-    printk("scsi%d: >>>>>>>>>>>> Host reset <<<<<<<<<<<<\n", host->host_no);
+    printk(KERN_INFO "scsi%d: >>>>>>>>>>>> Host reset <<<<<<<<<<<<\n", host->host_no);
 
     return full_reset(host);
 }
@@ -1770,7 +1738,7 @@
     ncr_halt(host);
     free_pages(host->hostdata[0], hostdata_order);
     free_irq(host->irq, host);
-    release_region((u32)host->base, 64);
+    release_region((u32)host->base, SIM710_IOREGION_SIZE);
     return 1;
 }

