From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.5.59] sim710: cleanup/remove most cli()'s
Date: 07 Feb 2003 21:57:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044676664.3564.107.camel@mulgrave>
References: <200302041123.06204@bilbo.math.uni-mannheim.de>
	<200302051603.48510@bilbo.math.uni-mannheim.de>
	<200302070826.25941@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-c0O9jnerMMBAv+H49Aom"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id TAA02014
	for <linux-scsi@vger.kernel.org>; Fri, 7 Feb 2003 19:57:51 -0800
In-Reply-To: <200302070826.25941@bilbo.math.uni-mannheim.de>
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-c0O9jnerMMBAv+H49Aom
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2003-02-07 at 01:26, Rolf Eike Beer wrote:
> That would be fine, you know your code better than I ever will.

OK, the attached works for me for the 3430 MCA internal SCSI chip and an
HP EISA SCSI board.  Let me know how it works for the Compaq.

James


--=-c0O9jnerMMBAv+H49Aom
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher=
.
# This patch includes the following deltas:
#	           ChangeSet	1.956   -> 1.957 =20
#	drivers/scsi/Makefile	1.34    -> 1.35  =20
#	drivers/scsi/sim710.c	1.6     -> 1.7   =20
#	drivers/scsi/Kconfig	1.9     -> 1.10  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/02/07	jejb@raven.il.steeleye.com	1.957
# Fix sim710 driver
#=20
# Make it use the 53c700 chip driver.   This should give conversion
# to the DMA API, synchronous operation and tag command queueing
# --------------------------------------------
#
diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Fri Feb  7 21:52:42 2003
+++ b/drivers/scsi/Kconfig	Fri Feb  7 21:52:42 2003
@@ -1372,24 +1372,16 @@
 # definitely looks note 64bit safe:
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
-	depends on (ISA || MCA && !X86_64) && SCSI
+	depends on (EISA || MCA && !X86_64) && SCSI
 	---help---
-	  This is a simple driver for NCR53c710 based SCSI host adapters.
+	  This driver for NCR53c710 based SCSI host adapters.
=20
-	  More complex drivers for this chip are available ("NCR53c7,8xx SCSI
-	  support", above), but they require that the scsi chip be able to do
-	  DMA block moves between memory and on-chip registers, which can
-	  cause problems under certain conditions.  This driver is designed to
-	  avoid these problems and is intended to work with any Intel machines
-	  using 53c710 chips, including various Compaq and NCR machines.
+	  It currently supports Compaq EISA cards and NCR MCA cards
=20
-	  Please read the comments at the top of the file
-	  <file:drivers/scsi/sim710.c> for more information.
-
-	  If you want to compile this driver as a module ( =3D code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called sim710.o.
+config 53C700_IO_MAPPED
+	bool
+	depends on SCSI_SIM710
+	default y
=20
 config SCSI_SYM53C416
 	tristate "Symbios 53c416 SCSI support"
diff -Nru a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	Fri Feb  7 21:52:42 2003
+++ b/drivers/scsi/Makefile	Fri Feb  7 21:52:42 2003
@@ -45,7 +45,7 @@
 obj-$(CONFIG_SUN3_SCSI)		+=3D sun3_scsi.o  sun3_scsi_vme.o
 obj-$(CONFIG_MVME16x_SCSI)	+=3D mvme16x.o	53c7xx.o
 obj-$(CONFIG_BVME6000_SCSI)	+=3D bvme6000.o	53c7xx.o
-obj-$(CONFIG_SCSI_SIM710)	+=3D sim710.o
+obj-$(CONFIG_SCSI_SIM710)	+=3D sim710.o	53c700.o
 obj-$(CONFIG_SCSI_ADVANSYS)	+=3D advansys.o
 obj-$(CONFIG_SCSI_PCI2000)	+=3D pci2000.o
 obj-$(CONFIG_SCSI_PCI2220I)	+=3D pci2220i.o
diff -Nru a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
--- a/drivers/scsi/sim710.c	Fri Feb  7 21:52:42 2003
+++ b/drivers/scsi/sim710.c	Fri Feb  7 21:52:42 2003
@@ -22,96 +22,41 @@
  * Some multiboard fixes from Rolf Eike Beer.
  * Auto probing of EISA config space from Trevor Hemsley.
  *
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
- *	sim710=3Daddr:0x9000,irq:15
- * and insmod parameters similar to
- *	sim710=3D"addr:0x9000 irq:15"
- *
- * Multiple controllers can also be set up by command line, provided the
- * addr: parameter is specified first for each controller.  e.g.
- *      sim710=3D"addr:0x9000 irq:15 addr:0x8000 irq:14"
- *
- * To seperate the different options, ' ', '+', and ',' can be used, excep=
t
- * that ',' can not be used in module parameters.  ' ' can be a pain, beca=
use
- * it needs to be quoted, which causes problems with some installers.
- * The command line above is completely equivalent to
- *      sim710=3D"addr:0x9000+irq:15+addr:0x8000+irq:14"
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
- * parameters are needed.  Auto-probing of addresses is disabled if any ad=
dr:
- * parameters are specified.
- *
- * Current limitations:
- *
- * o  Async only
- * o  Severely lacking in error recovery
- * o  'debug:' should be per host really.
+ * Rewritten to use 53c700.c by James.Bottomley@SteelEye.com
  *
  */
=20
 #include <linux/config.h>
 #include <linux/module.h>
=20
-#include <linux/version.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/string.h>
-#include <linux/ioport.h>
-#include <linux/delay.h>
-#include <linux/sched.h>
-#include <linux/proc_fs.h>
+#include <linux/blk.h>
+#include <linux/device.h>
 #include <linux/init.h>
+#ifdef CONFIG_MCA
 #include <linux/mca.h>
-#include <linux/interrupt.h>
-#include <asm/dma.h>
-#include <asm/system.h>
-#include <linux/spinlock.h>
-#include <asm/io.h>
-#include <asm/pgtable.h>
-#include <asm/byteorder.h>
-#include <linux/blk.h>
+#endif
+#ifdef CONFIG_EISA
+#include <linux/eisa.h>
+#endif
=20
-/* All targets are I/O mapped at the moment */
-#define IO_MAPPED
+#include "scsi.h"
+#include "hosts.h"
+#include "53c700.h"
=20
-#if defined(CONFIG_MCA)
+/* Must be enough for both EISA and MCA */
+#define MAX_SLOTS 8
+static __u8 __initdata id_array[MAX_SLOTS] =3D { [0 ... MAX_SLOTS-1] =3D 7=
 };
+
+/* info is used to communicate global data across the driver register
+ * because the struct device_driver doesn't have any info fields.  Sigh */
+struct sim710_info {
+	Scsi_Host_Template *tpnt;
+	int found;
+};
=20
-/*
- * For each known microchannel card using the 53c710 we need a list
- * of possible IRQ and IO settings, as well as their corresponding
- * bit assignment in pos[].  This might get cumbersome if there
- * are more than a few cards (I only know of 2 at this point).
- */
+static __initdata struct sim710_info sim710_global_info;
=20
-#define MCA_53C710_IDS { 0x01bb, 0x01ba, 0x004f }
+#if defined(CONFIG_MCA)
=20
 /* CARD ID 01BB and 01BA use the same pos values */
=20
@@ -130,63 +75,6 @@
=20
 #endif
=20
-#include "scsi.h"
-#include "hosts.h"
-#include "sim710.h"
-
-#include<linux/stat.h>
-
-#define DEBUG
-#undef DEBUG_LIMIT_INTS		/* Define to 10 to hang driver after 10 ints */
-
-/* Debug options available via the "debug:0x1234" parameter		*/
-
-#define DEB_NONE	0x0000	/* Nothing				*/
-#define DEB_HALT	0x0001	/* Detailed trace of chip halt funtion	*/
-#define DEB_REGS	0x0002	/* All chip register read/writes	*/
-#define DEB_SYNC	0x0004	/* Sync/async negotiation		*/
-#define DEB_PMM		0x0008	/* Phase mis-match handling		*/
-#define DEB_INTS	0x0010	/* General interrupt trace		*/
-#define DEB_TOUT	0x0020	/* Selection timeouts			*/
-#define DEB_RESUME	0x0040	/* Resume addresses for the script	*/
-#define DEB_CMND	0x0080	/* Commands and status returned		*/
-#define DEB_FIXUP	0x0100	/* Fixup of scsi addresses		*/
-#define DEB_DISC	0x0200	/* Disconnect/reselect handling		*/
-
-#define DEB_ANY		0xffff	/* Any and all debug options		*/
-
-#ifdef DEBUG
-#define DEB(m,x) if (sim710_debug & m) x
-int sim710_debug;
-#else
-#define DEB(m,x)
-#endif
-
-/* Redefine scsi_done to force renegotiation of (a)sync transfers
- * following any failed command.
- */
-
-#define SCSI_DONE(cmd)	{ \
-	DEB(DEB_CMND, printk("scsi%d: Complete %08x\n", \
-		host->host_no, cmd->result)); \
-	if (cmd->result) \
-	    hostdata->negotiate |=3D (1 << cmd->target); \
-	cmd->scsi_done(cmd); \
-    }
-
-#ifndef offsetof
-#define offsetof(t, m)      ((size_t) (&((t *)0)->m))
-#endif
-
-#define STATE_INITIALISED	0
-#define STATE_HALTED		1
-#define STATE_IDLE		2
-#define STATE_BUSY		3
-#define STATE_DISABLED		4
-
-#define MAXBOARDS 4	/* Increase this and the sizes of the
-			   arrays below, if you need more.. */
-
 #ifdef MODULE
=20
 char *sim710;		/* command line passed by insmod */
@@ -199,1583 +87,295 @@
=20
 #endif
=20
-static int sim710_errors;		/* Count of error interrupts */
-static int sim710_intrs;		/* Count of all interrupts */
-static int ignore_ids[MAXBOARDS];	/* Accept all SCSI IDs */
-static int opt_nodisc[MAXBOARDS];	/* Allow disconnect on all IDs */
-static int opt_noneg[MAXBOARDS];	/* Allow SDTR negotiation on all IDs */
-static int hostdata_order;		/* Encoded size of hostdata for free_pages() *=
/
-static int no_of_boards;		/* Actual number of boards/chips */
-static unsigned int bases[MAXBOARDS];	/* Base addresses of chips */
-static unsigned int irq_vectors[MAXBOARDS]; /* IRQ vectors used by chips *=
/
-
-/* The SCSI Script!!! */
-
-#include "sim710_d.h"
-
-/* Now define offsets in the DSA, as (A_dsa_xxx/4) */
-
-#define DSA_SELECT	(A_dsa_select/4)
-#define DSA_MSGOUT	(A_dsa_msgout/4)
-#define DSA_CMND	(A_dsa_cmnd/4)
-#define DSA_STATUS	(A_dsa_status/4)
-#define DSA_MSGIN	(A_dsa_msgin/4)
-#define DSA_DATAIN	(A_dsa_datain/4)
-#define DSA_DATAOUT	(A_dsa_dataout/4)
-#define DSA_SIZE	(A_dsa_size/4)
-
-#define MAX_SG		128	/* Scatter/Gather elements */
-
-#define MAX_MSGOUT	8
-#define MAX_MSGIN	8
-#define MAX_CMND	12
-#define MAX_STATUS	1
-
-struct sim710_hostdata{
-    int state;
-    Scsi_Cmnd * issue_queue;
-    Scsi_Cmnd * running;
-    int chip;
-    u8 negotiate;
-    u8 reselected_identify;
-    u8 msgin_buf[MAX_MSGIN];
-    u8 msg_reject;
-    u32 test1_src __attribute__ ((aligned (4)));
-    u32 test1_dst;
-
-    struct sim710_target {
-	Scsi_Cmnd *cur_cmd;
-	u32 resume_offset;
-	u32 data_in_jump;
-	u32 data_out_jump;
-	u32 dsa[DSA_SIZE];		/* SCSI Script DSA area */
-	u8  dsa_msgout[MAX_MSGOUT];
-	u8  dsa_msgin[MAX_MSGIN];
-	u8  dsa_cdb[MAX_CMND];
-	u8  dsa_status[MAX_STATUS];
-    } target[8];
-
-    u32 script[sizeof(SCRIPT)/4] __attribute__ ((aligned (4)));
-};
-
-
-/* Template to request asynchronous transfers */
-
-static const unsigned char async_message[] =3D {
-    EXTENDED_MESSAGE, 3 /* length */, EXTENDED_SDTR, 0, 0 /* asynchronous =
*/};
-
-
-static void sim710_intr_handle(int irq, void *dev_id, struct pt_regs *regs=
);
-static void do_sim710_intr_handle(int irq, void *dev_id, struct pt_regs *r=
egs);
-static __inline__ void run_process_issue_queue(struct sim710_hostdata *);
-static void process_issue_queue (struct sim710_hostdata *, unsigned long f=
lags);
-static int full_reset(struct Scsi_Host * host);
-
-
-/*
- * Function : static void ncr_dump (struct Scsi_Host *host)
- *
- * Purpose :  Dump (possibly) useful info
- *
- * Inputs : host - pointer to this host adapter's structure
- */
-
-static void
-ncr_dump (struct Scsi_Host *host)
-{
-    unsigned long flags;
-    struct sim710_hostdata *hostdata =3D (struct sim710_hostdata *)
-       host->hostdata[0];
-
-    save_flags(flags);
-    cli();
-    printk("scsi%d: Chip register contents:\n", host->host_no);
-    printk(" (script at virt %p, bus %lx)\n",
-           hostdata->script, virt_to_bus(hostdata->script));
-    printk(" 00  sien:  %02x  sdid:  %02x  scntl1:%02x  scntl0:%02x\n"
-	   " 04  socl:  %02x  sodl:  %02x  sxfer: %02x  scid:  %02x\n"
-	   " 08  sbcl:  %02x  sbdl:  %02x  sidl:  %02x  sfbr:  %02x\n"
-	   " 0C  sstat2:%02x  sstat1:%02x  sstat0:%02x  dstat: %02x\n"
-	   " 10  dsa:   %08x\n"
-	   " 14  ctest3:%02x  ctest2:%02x  ctest1:%02x  ctest0:%02x\n"
-	   " 18  ctest7:%02x  ctest6:%02x  ctest5:%02x  ctest4:%02x\n"
-	   " 1C  temp:  %08x\n"
-	   " 20  lcrc:  %02x  ctest8:%02x  istat: %02x  dfifo: %02x\n"
-	   " 24  dbc:   %08x  dnad:  %08x  dsp:   %08x\n"
-	   " 30  dsps:  %08x  scratch:%08x\n"
-	   " 38  dcntl: %02x  dwt:   %02x  dien:  %02x  dmode: %02x\n"
-	   " 3C  adder: %08x\n",
-	  NCR_read8(SIEN_REG), NCR_read8(SDID_REG), NCR_read8(SCNTL1_REG),
-	  NCR_read8(SCNTL0_REG), NCR_read8(SOCL_REG), NCR_read8(SODL_REG),
-	  NCR_read8(SXFER_REG), NCR_read8(SCID_REG), NCR_read8(SBCL_REG),
-	  NCR_read8(SBDL_REG), NCR_read8(SIDL_REG), NCR_read8(SFBR_REG),
-	  NCR_read8(SSTAT2_REG), NCR_read8(SSTAT1_REG), NCR_read8(SSTAT0_REG),
-	  NCR_read8(DSTAT_REG), NCR_read32(DSA_REG), NCR_read8(CTEST3_REG),
-	  NCR_read8(CTEST2_REG), NCR_read8(CTEST1_REG), NCR_read8(CTEST0_REG),
-	  NCR_read8(CTEST7_REG), NCR_read8(CTEST6_REG), NCR_read8(CTEST5_REG),
-	  NCR_read8(CTEST4_REG), NCR_read8(TEMP_REG), NCR_read8(LCRC_REG),
-	  NCR_read8(CTEST8_REG), NCR_read8(ISTAT_REG), NCR_read8(DFIFO_REG),
-	  NCR_read32(DBC_REG), NCR_read32(DNAD_REG), NCR_read32(DSP_REG),
-	  NCR_read32(DSPS_REG), NCR_read32(SCRATCH_REG), NCR_read8(DCNTL_REG),
-	  NCR_read8(DWT_REG), NCR_read8(DIEN_REG), NCR_read8(DMODE_REG),
-	  NCR_read32(ADDER_REG));
-
-    restore_flags(flags);
-}
-
-
-/*
- * Function: int param_setup(char *str)
- */
+#ifdef MODULE
+#define ARG_SEP ' '
+#else
+#define ARG_SEP ','
+#endif
=20
 __init int
 param_setup(char *str)
 {
-    char *cur =3D str;
-    char *p, *pc, *pv;
-    int val;
-    int c;
-
-    no_of_boards =3D 0;
-    while (no_of_boards < MAXBOARDS && cur !=3D NULL &&
-		(pc =3D strchr(cur, ':')) !=3D NULL) {
-	char *pe;
-
-	val =3D 0;
-	pv =3D pc;
-	c =3D *++pv;
+	char *pos =3D str, *next;
+	int slot =3D -1;
=20
-	val =3D (int) simple_strtoul(pv, &pe, 0);
+	while(pos !=3D NULL && (next =3D strchr(pos, ':')) !=3D NULL) {
+		int val =3D (int)simple_strtoul(++next, NULL, 0);
=20
-	if (!strncmp(cur, "addr:", 5)) {
-	    bases[no_of_boards++] =3D val;
-	}
-#ifdef DEBUG
-	else if (!strncmp(cur, "debug:", 6)) {
-	    sim710_debug =3D val;
-	}
-#endif
-	else if (no_of_boards =3D=3D 0) {
-	    printk("sim710: Invalid parameters, addr: must come first\n");
-	    no_of_boards =3D -1;
-	    return 1;
-	}
-	else if	(!strncmp(cur, "irq:", 4))
-	    irq_vectors[no_of_boards-1] =3D val;
-	else if	(!strncmp(cur, "ignore:", 7))
-	    ignore_ids[no_of_boards-1] =3D val;
-	else if	(!strncmp(cur, "nodisc:", 7))
-	    opt_nodisc[no_of_boards-1] =3D val;
-	else if	(!strncmp(cur, "noneg:", 6))
-	    opt_noneg[no_of_boards-1] =3D val;
-	else if	(!strncmp(cur, "disabled:", 9)) {
-	    no_of_boards =3D -1;
-	    return 1;
-	}
-	else {
-	    printk("sim710: unexpected boot option '%.*s'\n", (int)(pc-cur+1), cu=
r);
-	    no_of_boards =3D -1;
-	    return 1;
+		if(!strncmp(pos, "slot:", 5))
+			slot =3D val;
+		else if(!strncmp(pos, "id:", 3)) {
+			if(slot =3D=3D -1) {
+				printk(KERN_WARNING "sim710: Must specify slot for id parameter\n");
+			} else if(slot > MAX_SLOTS) {
+				printk(KERN_WARNING "sim710: Illegal slot %d for id %d\n", slot, val);
+			} else {
+				id_array[slot] =3D val;
+			}
+		}
+		if((pos =3D strchr(pos, ARG_SEP)) !=3D NULL)
+			pos++;
 	}
-
-	/* Allow ',', ' ', or '+' seperators.  Used to be ',' at boot and
-	 * ' ' for module load, some installers crap out on the space and
-	 * insmod doesn't like the comma.
-	 */
-       if ((p =3D strchr(cur, ',')) || (p =3D strchr(cur, ' ')) ||
-               (p =3D strchr(cur, '+')))
-           cur =3D p + 1;
-        else
-           break;
-    }
-    return 1;
+	return 1;
 }
=20
 #ifndef MODULE
 __setup("sim710=3D", param_setup);
 #endif
=20
-
-/*
- * Function: static const char *sbcl_to_phase (int sbcl)
- */
-
-static const char *
-sbcl_to_phase (int sbcl) {
-    switch (sbcl & SBCL_PHASE_MASK) {
-    case SBCL_PHASE_DATAIN:
-	return "DATAIN";
-    case SBCL_PHASE_DATAOUT:
-	return "DATAOUT";
-    case SBCL_PHASE_MSGIN:
-	return "MSGIN";
-    case SBCL_PHASE_MSGOUT:
-	return "MSGOUT";
-    case SBCL_PHASE_CMDOUT:
-	return "CMDOUT";
-    case SBCL_PHASE_STATIN:
-	return "STATUSIN";
-    default:
-	return "unknown";
-    }
-}
-
-
-/*
- * Function : static int ncr_halt (struct Scsi_Host *host)
- *
- * Purpose : halts the SCSI SCRIPTS(tm) processor on the NCR chip
- *
- * Inputs : host - SCSI chip to halt
- *
- * Returns : 0 on success
- */
-
-static int
-ncr_halt (struct Scsi_Host *host)
-{
-    unsigned long flags;
-    unsigned char istat, tmp;
-    struct sim710_hostdata *hostdata =3D (struct sim710_hostdata *)
-	host->hostdata[0];
-    int stage;
-    int timeout;
-    int res =3D 0;
-
-    save_flags(flags);
-    cli();
-    /* Stage 0 : eat all interrupts
-       Stage 1 : set ABORT
-       Stage 2 : eat all but abort interrupts
-       Stage 3 : eat all interrupts
-       We loop for 50000 times with a delay of 10us which should give us
-       about half a second.
-     */
-    for (stage =3D 0, timeout =3D 50000; timeout; timeout--) {
-	if (stage =3D=3D 1) {
-	    DEB(DEB_HALT, printk("ncr_halt: writing ISTAT_ABRT\n"));
-	    NCR_write8(ISTAT_REG, ISTAT_ABRT);
-	    ++stage;
-	}
-	istat =3D NCR_read8 (ISTAT_REG);
-	if (istat & ISTAT_SIP) {
-	    DEB(DEB_HALT, printk("ncr_halt: got ISTAT_SIP, istat=3D%02x\n", istat=
));
-	    tmp =3D NCR_read8(SSTAT0_REG);
-	    DEB(DEB_HALT, printk("ncr_halt: got SSTAT0_REG=3D%02x\n", tmp));
-	} else if (istat & ISTAT_DIP) {
-	    DEB(DEB_HALT, printk("ncr_halt: got ISTAT_DIP, istat=3D%02x\n", istat=
));
-	    tmp =3D NCR_read8(DSTAT_REG);
-	    DEB(DEB_HALT, printk("ncr_halt: got DSTAT_REG=3D%02x\n", tmp));
-	    if (stage =3D=3D 2) {
-		if (tmp & DSTAT_ABRT) {
-	    	    DEB(DEB_HALT, printk("ncr_halt: got DSTAT_ABRT, clearing istat\n=
"));
-		    NCR_write8(ISTAT_REG, 0);
-		    ++stage;
-		} else {
-		    res =3D 1;
-		    break;
-	    	}
-    	    }
-	}
-	if (!(istat & (ISTAT_SIP|ISTAT_DIP))) {
-	    if (stage =3D=3D 0)
-	    	++stage;
-	    else if (stage =3D=3D 3)
-		break;
-	}
-	udelay(10);
-    }
-    restore_flags(flags);
-
-    if (timeout =3D=3D 0 || res) {
-	printk(KERN_ALERT "scsi%d: could not halt NCR chip\n", host->host_no);
-	return 1;
-    }
-    else {
-	hostdata->state =3D STATE_HALTED;
-	return 0;
-    }
-}
-
-/*
- * Function : static void sim710_soft_reset (struct Scsi_Host *host)
- *
- * Purpose :  perform a soft reset of the NCR53c7xx chip
- *
- * Inputs : host - pointer to this host adapter's structure
- *
- * Preconditions : sim710_init must have been called for this
- *      host.
- *
- */
-
-static void
-sim710_soft_reset (struct Scsi_Host *host)
-{
-    unsigned long flags;
-
-    save_flags(flags);
-    cli();
-    /*
-     * Do a soft reset of the chip so that everything is
-     * reinitialized to the power-on state.
-     *
-     * Basically follow the procedure outlined in the NCR53c700
-     * data manual under Chapter Six, How to Use, Steps Necessary to
-     * Start SCRIPTS, with the exception of actually starting the
-     * script and setting up the synchronous transfer gunk.
-     */
-
-    /* XXX Should we reset the scsi bus here? */
-
-    NCR_write8(SCNTL1_REG, SCNTL1_RST);		/* Reset the bus */
-    udelay(50);
-    NCR_write8(SCNTL1_REG, 0);
-
-    udelay(500);
-
-    NCR_write8(ISTAT_REG, ISTAT_10_SRST);	/* Reset the chip */
-    udelay(50);
-    NCR_write8(ISTAT_REG, 0);
-
-    mdelay(1000);				/* Let devices recover */
-
-    NCR_write32(SCRATCH_REG, 0);
-    NCR_write8(DCNTL_REG, DCNTL_10_COM | DCNTL_700_CF_3);
-    NCR_write8(CTEST7_REG, CTEST7_10_CDIS|CTEST7_STD);
-    NCR_write8(DMODE_REG, DMODE_10_BL_8 | DMODE_10_FC2);
-    NCR_write8(SCID_REG, 1 << host->this_id);
-    NCR_write8(SBCL_REG, 0);
-    NCR_write8(SXFER_REG, 0);
-    NCR_write8(SCNTL1_REG, SCNTL1_ESR_700);
-    NCR_write8(SCNTL0_REG, SCNTL0_EPC | SCNTL0_EPG_700 | SCNTL0_ARB1 |
-		SCNTL0_ARB2);
-
-    NCR_write8(DIEN_REG, DIEN_700_BF |
-		DIEN_ABRT | DIEN_SSI | DIEN_SIR | DIEN_700_OPC);
-
-    NCR_write8(SIEN_REG_700,
-	    SIEN_PAR | SIEN_700_STO | SIEN_RST | SIEN_UDC | SIEN_SGE | SIEN_MA);
-
-    restore_flags(flags);
-}
-
-
-/*
- * Function : static void sim710_driver_init (struct Scsi_Host *host)
- *
- * Purpose : Initialize internal structures, as required on startup, or
- *	after a SCSI bus reset.
- *
- * Inputs : host - pointer to this host adapter's structure
- */
-
-static void
-sim710_driver_init (struct Scsi_Host *host)
-{
-    struct sim710_hostdata *hostdata =3D (struct sim710_hostdata *)
-	host->hostdata[0];
-    int i;
-
-    hostdata->running =3D NULL;
-    memcpy (hostdata->script, SCRIPT, sizeof(SCRIPT));
-    for (i =3D 0; i < PATCHES; i++)
-	hostdata->script[LABELPATCHES[i]] +=3D isa_virt_to_bus(hostdata->script);
-    patch_abs_32 (hostdata->script, 0, reselected_identify,=20
-    	isa_virt_to_bus((void *)&(hostdata->reselected_identify)));
-    patch_abs_32 (hostdata->script, 0, msgin_buf,=20
-    	isa_virt_to_bus((void *)&(hostdata->msgin_buf[0])));
-    patch_abs_32 (hostdata->script, 0, msg_reject,
-	isa_virt_to_bus((void *)&(hostdata->msg_reject)));
-    patch_abs_32 (hostdata->script, 0, test1_src,
-	isa_virt_to_bus((void *)&(hostdata->test1_src)));
-    patch_abs_32 (hostdata->script, 0, test1_dst,
-	isa_virt_to_bus((void *)&(hostdata->test1_dst)));
-    hostdata->state =3D STATE_INITIALISED;
-    hostdata->negotiate =3D 0xff;
-}
-
-
-/* Handle incoming Synchronous data transfer request.  If our negotiate
- * flag is set then this is a response to our request, otherwise it is
- * spurious request from the target.  Don't really expect target initiated
- * SDTRs, because we always negotiate on the first command.  Could still
- * get them though..
- * The chip is currently paused with ACK asserted on the last byte of the
- * SDTR.
- * resa is the resume address if the message is in response to our outgoin=
g
- * SDTR.  Only possible on initial identify.
- * resb is the resume address if the message exchange is initiated by the
- * target.
- */
-
-static u32
-handle_sdtr (struct Scsi_Host * host, Scsi_Cmnd * cmd, u32 resa, u32 resb)
-{
-    struct sim710_hostdata *hostdata =3D (struct sim710_hostdata *)host->h=
ostdata[0];
-    struct sim710_target *targdata =3D hostdata->target + cmd->target;
-    u32 resume_offset;
-
-    if (resa && hostdata->negotiate & (1 << cmd->target)) {
-	DEB(DEB_SYNC, printk("scsi%d: Response to host SDTR =3D %02x %02x\n",
-		host->host_no, hostdata->msgin_buf[3], hostdata->msgin_buf[4]));
-	/* We always issue an SDTR with the identify, so we must issue
-	 * the CDB next.
-	 */
-	resume_offset =3D resa;
-	hostdata->negotiate &=3D ~(1 << cmd->target);
-    }
-    else {
-	DEB(DEB_SYNC, printk("scsi%d: Target initiated SDTR =3D %02x %02x\n",
-		host->host_no, hostdata->msgin_buf[3], hostdata->msgin_buf[4]));
-	memcpy(targdata->dsa_msgout, async_message, sizeof(async_message));
-	targdata->dsa[DSA_MSGOUT] =3D sizeof(async_message);
-	/* I guess the target could do this anytime; we have to send our
-	 * response, and then continue (sending the CDB if not already done).
-	 */
-	resume_offset =3D resb;
-    }
-    return resume_offset;
-}
-
-
-/*
- * Function : static int datapath_residual (Scsi_Host *host)
- *
- * Purpose : return residual data count of what's in the chip.
- *
- * Inputs : host - SCSI host
- */
-
-static int
-datapath_residual (struct Scsi_Host *host) {
-    int count, synchronous, sstat;
-    unsigned int ddir;
-
-    count =3D ((NCR_read8 (DFIFO_REG) & DFIFO_10_BO_MASK) -
-	(NCR_read32 (DBC_REG) & DFIFO_10_BO_MASK)) & DFIFO_10_BO_MASK;
-    synchronous =3D NCR_read8 (SXFER_REG) & SXFER_MO_MASK;
-    ddir =3D NCR_read8 (CTEST0_REG_700) & CTEST0_700_DDIR;
-
-    if (ddir) {
-    /* Receive */
-	if (synchronous)=20
-	    count +=3D (NCR_read8 (SSTAT2_REG) & SSTAT2_FF_MASK) >> SSTAT2_FF_SHI=
FT;
-	else
-	    if (NCR_read8 (SSTAT1_REG) & SSTAT1_ILF)
-		++count;
-    } else {
-    /* Send */
-	sstat =3D NCR_read8 (SSTAT1_REG);
-	if (sstat & SSTAT1_OLF)
-	    ++count;
-	if (synchronous && (sstat & SSTAT1_ORF))
-	    ++count;
-    }
-    return count;
-}
-
-
-static u32
-handle_idd (struct Scsi_Host * host, Scsi_Cmnd * cmd)
+__init int
+sim710_probe_common(struct device *dev, unsigned long base_addr,
+		    int irq, int clock, int differential, int scsi_id)
 {
-    struct sim710_hostdata *hostdata =3D
-		(struct sim710_hostdata *)host->hostdata[0];
-    struct sim710_target *targdata =3D hostdata->target + cmd->target;
-    u32 resume_offset =3D 0, index;
-
-    index =3D (u32)((u32 *)(isa_bus_to_virt(NCR_read32(DSP_REG))) - hostda=
ta->script);
-
-    switch (index) {
-    case Ent_wait_disc_complete/4 + 2:
-	cmd->result =3D targdata->dsa_status[0];
-        SCSI_DONE(cmd);
-	targdata->cur_cmd =3D NULL;
-	resume_offset =3D Ent_reselect;
-	break;
-    case Ent_wait_disc2/4 + 2:
-	/* Disconnect after command - just wait for a reselect */
-	targdata->resume_offset =3D Ent_resume_msgin2a;
-	resume_offset =3D Ent_reselect;
-	break;
-    case Ent_wait_disc3/4 + 2:
-	/* Disconnect after the data phase */
-	targdata->resume_offset =3D Ent_resume_msgin3a;
-	resume_offset =3D Ent_reselect;
-	break;
-    case Ent_wait_disc1/4 + 2:
-	/* Disconnect before command - not expected */
-	targdata->resume_offset =3D Ent_resume_msgin1a;
-	resume_offset =3D Ent_reselect;
-	break;
-    default:
-	printk("scsi%d: Unexpected Illegal Instruction, script[%04x]\n",
-		host->host_no, index);
-	sim710_errors++;
-	/* resume_offset is zero, which will cause host reset */
-    }
-    return resume_offset;
-}
+	struct Scsi_Host * host =3D NULL;
+	struct NCR_700_Host_Parameters *hostdata =3D
+		kmalloc(sizeof(struct NCR_700_Host_Parameters),	GFP_KERNEL);
=20
+	printk(KERN_NOTICE "sim710: %s\n", dev->name);
+	printk(KERN_NOTICE "sim710: irq =3D %d, clock =3D %d, base =3D 0x%lx, scs=
i_id =3D %d\n",
+	       irq, clock, base_addr, scsi_id);
=20
-/* Handle a phase mismatch.
- */
-
-static u32
-handle_phase_mismatch (struct Scsi_Host * host, Scsi_Cmnd * cmd)
-{
-    struct sim710_hostdata *hostdata =3D
-		(struct sim710_hostdata *)host->hostdata[0];
-    struct sim710_target *targdata =3D hostdata->target + cmd->target;
-    u32 resume_offset =3D 0, index;
-    unsigned char sbcl;
-
-    sbcl =3D NCR_read8(SBCL_REG) & SBCL_PHASE_MASK;
-    index =3D (u32)((u32 *)(isa_bus_to_virt(NCR_read32(DSP_REG))) - hostda=
ta->script);
-
-    DEB(DEB_PMM, printk("scsi%d: Phase mismatch, phase %s (%x) at script[0=
x%x]\n",
-	host->host_no, sbcl_to_phase(sbcl), sbcl, index));
-    DEB(DEB_PMM, print_command(cmd->cmnd));
-
-    if (index =3D=3D Ent_done_ident/4) {
-	/* Sending initial message out - probably rejecting our sync
-	 * negotiation request.
-	 */
-	NCR_write8(SOCL_REG, 0);	/* Negate ATN */
-	if (sbcl =3D=3D SBCL_PHASE_MSGIN)
-	    resume_offset =3D Ent_resume_rej_ident;
-	else if (sbcl =3D=3D SBCL_PHASE_CMDOUT) {
-	    /* Some old devices (SQ555) switch to cmdout after the first
-	     * byte of an identify message, regardless of whether we
-	     * have more bytes to send!
-	     */
-	    printk("scsi%d: Unexpected switch to CMDOUT during IDENTIFY\n",
-		host->host_no);
-	    resume_offset =3D Ent_resume_cmd;
+	if(hostdata =3D=3D NULL) {
+		printk(KERN_ERR "sim710: Failed to allocate host data\n");
+		goto out;
 	}
-	else if (sbcl =3D=3D SBCL_PHASE_STATIN) {
-	    /* Some devices do this on parity error, at least */
-	    printk("scsi%d: Unexpected switch to STATUSIN on initial message out\=
n",
-		host->host_no);
-	    resume_offset =3D Ent_end_data_trans;
-	}
-	else {
-	    printk("scsi%d: Unexpected phase change to %s on initial msgout\n",
-		host->host_no, sbcl_to_phase(sbcl));
-	    /* resume_offset is zero, which will cause a host reset */
-	}
-	hostdata->negotiate &=3D ~(1 << cmd->target);
-    }
-    else if (index > Ent_patch_input_data/4 &&
-		index < Ent_patch_output_data/4) {
-	/* DataIn transfer phase */
-	u32 sg_id, oaddr, olen, naddr, nlen;
-	int residual;
-
-	sg_id =3D (index - Ent_patch_input_data/4 - 4) / 2;
-	targdata->data_in_jump =3D hostdata->script[Ent_patch_input_data/4+1] =3D
-		isa_virt_to_bus(hostdata->script + Ent_patch_input_data/4 + sg_id * 2 + =
2);
-	olen  =3D targdata->dsa[DSA_DATAIN + sg_id * 2];
-	oaddr =3D targdata->dsa[DSA_DATAIN + sg_id * 2 + 1];
-	residual =3D datapath_residual (host);
-	if (residual)
-	    printk("scsi%d: Residual count %d on DataIn - NOT expected!!!",
-		host->host_no, residual);
-	naddr =3D NCR_read32(DNAD_REG) - residual;
-	nlen  =3D (NCR_read32(DBC_REG) & 0x00ffffff) + residual;
-	DEB(DEB_PMM, printk("scsi%d: DIN sg %d, old %08x/%08x, new %08x/%08x (%d)=
\n",
-		host->host_no, sg_id, oaddr, olen, naddr, nlen, residual));
-	if (oaddr+olen !=3D naddr+nlen) {
-	    printk("scsi%d: PMM DIN counts error: 0x%x + 0x%x !=3D 0x%x + 0x%x",
-		host->host_no, oaddr, olen, naddr, nlen);
-	}
-	else {
-	    targdata->dsa[DSA_DATAIN + sg_id * 2]     =3D nlen;
-	    targdata->dsa[DSA_DATAIN + sg_id * 2 + 1] =3D naddr;
-	    resume_offset =3D Ent_resume_pmm;
-	}
-    }
-    else if (index > Ent_patch_output_data/4 &&
-		index <=3D Ent_end_data_trans/4) {
-	/* Dataout transfer phase */
-	u32 sg_id, oaddr, olen, naddr, nlen;
-	int residual;
-
-	sg_id =3D (index - Ent_patch_output_data/4 - 4) / 2;
-	targdata->data_out_jump =3D hostdata->script[Ent_patch_output_data/4+1] =
=3D
-		isa_virt_to_bus(hostdata->script + Ent_patch_output_data/4 + sg_id * 2 +=
 2);
-	olen  =3D targdata->dsa[DSA_DATAOUT + sg_id * 2];
-	oaddr =3D targdata->dsa[DSA_DATAOUT + sg_id * 2 + 1];
-	residual =3D datapath_residual (host);
-	naddr =3D NCR_read32(DNAD_REG) - residual;
-	nlen  =3D (NCR_read32(DBC_REG) & 0x00ffffff) + residual;
-	DEB(DEB_PMM, printk("scsi%d: DOUT sg %d, old %08x/%08x, new %08x/%08x (%d=
)\n",
-		host->host_no, sg_id, oaddr, olen, naddr, nlen, residual));
-	if (oaddr+olen !=3D naddr+nlen) {
-	    printk("scsi%d: PMM DOUT counts error: 0x%x + 0x%x !=3D 0x%x + 0x%x",
-		host->host_no, oaddr, olen, naddr, nlen);
-	}
-	else {
-	    targdata->dsa[DSA_DATAOUT + sg_id * 2]     =3D nlen;
-	    targdata->dsa[DSA_DATAOUT + sg_id * 2 + 1] =3D naddr;
-	    resume_offset =3D Ent_resume_pmm;
-	}
-    }
-    else if (sbcl =3D=3D SBCL_PHASE_STATIN) {
-	/* Change to Status In at some random point; probably wants to report a
-	 * parity error or similar.
-	 */
-	printk("scsi%d: Unexpected phase change to STATUSIN at index 0x%x\n",
-		host->host_no, index);
-	resume_offset =3D Ent_end_data_trans;
-    }
-    else {
-	printk("scsi%d: Unexpected phase change to %s at index 0x%x\n",
-		host->host_no, sbcl_to_phase(sbcl), index);
-	/* resume_offset is zero, which will cause a host reset */
-    }
-    /* Flush DMA FIFO */
-    NCR_write8 (CTEST8_REG, CTEST8_10_CLF);
-    while (NCR_read8 (CTEST8_REG) & CTEST8_10_CLF);
-
-    return resume_offset;
-}
-
-
-static u32
-handle_script_int(struct Scsi_Host * host, Scsi_Cmnd * cmd)
-{
-    struct sim710_hostdata *hostdata =3D
-		(struct sim710_hostdata *)host->hostdata[0];
-    struct sim710_target *targdata =3D hostdata->target + cmd->target;
-    u32 dsps, resume_offset =3D 0;
-    unsigned char sbcl;
-
-    dsps =3D NCR_read32(DSPS_REG);
-
-    switch (dsps) {
-    case A_int_cmd_complete:
-	cmd->result =3D targdata->dsa_status[0];
-        SCSI_DONE(cmd);
-	targdata->cur_cmd =3D NULL;
-	resume_offset =3D Ent_reselect;
-	break;
-    case A_int_msg_sdtr1:
-	resume_offset =3D handle_sdtr(host, cmd,
-		Ent_resume_msgin1a, Ent_resume_msgin1b);
-	break;
-    case A_int_msg_sdtr2:
-	resume_offset =3D handle_sdtr(host, cmd, 0, Ent_resume_msgin2b);
-	break;
-    case A_int_msg_sdtr3:
-	resume_offset =3D handle_sdtr(host, cmd, 0, Ent_resume_msgin3b);
-	break;
-    case A_int_disc1:
-	/* Disconnect before command - not expected */
-	targdata->resume_offset =3D Ent_resume_msgin1a;
-	resume_offset =3D Ent_reselect;
-	break;
-    case A_int_disc2:
-	/* Disconnect after command - just wait for a reselect */
-	targdata->resume_offset =3D Ent_resume_msgin2a;
-	resume_offset =3D Ent_reselect;
-	break;
-    case A_int_disc3:
-	/* Disconnect after the data phase */
-	targdata->resume_offset =3D Ent_resume_msgin3a;
-	resume_offset =3D Ent_reselect;
-	break;
-    case A_int_reselected:
-	hostdata->script[Ent_patch_output_data/4+1] =3D targdata->data_out_jump;
-	hostdata->script[Ent_patch_input_data/4+1] =3D targdata->data_in_jump;
-	NCR_write32(DSA_REG, isa_virt_to_bus(targdata->dsa));
-	resume_offset =3D targdata->resume_offset;
-	break;
-    case A_int_data_bad_phase:
-	sbcl =3D NCR_read8(SBCL_REG) & SBCL_PHASE_MASK;
-	printk("scsi%d: int_data_bad_phase, phase %s (%x)\n",
-		host->host_no, sbcl_to_phase(sbcl), sbcl);
-	break;
-    case A_int_bad_msg1:
-    case A_int_bad_msg2:
-    case A_int_bad_msg3:
-    case A_int_cmd_bad_phase:
-    case A_int_no_msgout1:
-    case A_int_no_msgout2:
-    case A_int_no_msgout3:
-    case A_int_not_cmd_complete:
-    case A_int_sel_no_ident:
-    case A_int_sel_not_cmd:
-    case A_int_status_not_msgin:
-    case A_int_resel_not_msgin:
-    case A_int_selected:
-    case A_int_not_rej:
-    default:
-	sbcl =3D NCR_read8(SBCL_REG) & SBCL_PHASE_MASK;
-	printk("scsi%d: Unimplemented script interrupt: %08x, phase %s\n",
-		host->host_no, dsps, sbcl_to_phase(sbcl));
-	sim710_errors++;
-	/* resume_offset is zero, which will cause a host reset */
-    }
-    return resume_offset;
-}
-
-
-/* A quick wrapper for sim710_intr_handle to grab the spin lock */
-
-static void
-do_sim710_intr_handle(int irq, void *dev_id, struct pt_regs *regs)
-{
-    struct Scsi_Host *host =3D dev_id;
-    unsigned long flags;
+	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
=20
-    spin_lock_irqsave(host->host_lock, flags);
-    sim710_intr_handle(irq, host, regs);
-    spin_unlock_irqrestore(host->host_lock, flags);
-}
-
-
-/* A "high" level interrupt handler */
-
-static void
-sim710_intr_handle(int irq, void *dev_id, struct pt_regs *regs)
-{
-    struct Scsi_Host * host =3D (struct Scsi_Host *)dev_id;
-    struct sim710_hostdata *hostdata =3D (struct sim710_hostdata *)host->h=
ostdata[0];
-    Scsi_Cmnd * cmd;
-    unsigned char istat, dstat;
-    unsigned char sstat0;
-    u32 scratch, dsps, resume_offset =3D 0;
-
-    istat =3D NCR_read8(ISTAT_REG);
-    if (!(istat & (ISTAT_SIP|ISTAT_DIP)))
-	return;
-    else {
-	sim710_intrs++;
-	dsps =3D NCR_read32(DSPS_REG);
-	hostdata->state =3D STATE_HALTED;
-	sstat0 =3D dstat =3D 0;
-	scratch =3D NCR_read32(SCRATCH_REG);
-	if (istat & ISTAT_SIP) {
-	    sstat0 =3D NCR_read8(SSTAT0_REG);
-	}
-	if (istat & ISTAT_DIP) {
-	    udelay(10);		/* Some comment somewhere about 10cycles
-				 * between accesses to sstat0 and dstat ??? */
-	    dstat =3D NCR_read8(DSTAT_REG);
-	}
-	DEB(DEB_INTS, printk("scsi%d: Int %d, istat %02x, sstat0 %02x "
-		"dstat %02x, dsp [%04x], scratch %02x\n",
-	    host->host_no, sim710_intrs, istat, sstat0, dstat,
-	    (u32 *)(isa_bus_to_virt(NCR_read32(DSP_REG))) - hostdata->script,
-	    scratch));
-	if (scratch & 0x100) {
-	    u8 *p =3D hostdata->msgin_buf;
-	   =20
-	    DEB(DEB_INTS, printk("  msgin_buf: %02x %02x %02x %02x\n",
-			p[0], p[1], p[2], p[3]));
-	}
-	if ((dstat & DSTAT_SIR) && dsps =3D=3D A_int_reselected) {
-	    /* Reselected.  Identify the target from LCRC_REG, and
-	     * update current command.  If we were trying to select
-	     * a device, then that command needs to go back on the
-	     * issue_queue for later.
-	     */
-	    unsigned char lcrc =3D NCR_read8(LCRC_REG_10);
-	    int id =3D 0;
-
-	    if (!(lcrc & 0x7f)) {
-		printk("scsi%d: Reselected with LCRC =3D %02x\n",
-			host->host_no, lcrc);
-		cmd =3D NULL;
-	    }
-	    else {
-		while (!(lcrc & 1)) {
-		    id++;
-		    lcrc >>=3D 1;
-		}
-		DEB(DEB_DISC, printk("scsi%d: Reselected by ID %d\n",
-			host->host_no, id));
-		if (hostdata->running) {
-		    /* Clear SIGP */
-		    (void)NCR_read8(CTEST2_REG_700);
-
-		    DEB(DEB_DISC, printk("scsi%d: Select of %d interrupted "
-				"by reselect from %d (%p)\n",
-				host->host_no, hostdata->running->target,
-				id, hostdata->target[id].cur_cmd));
-		    cmd =3D hostdata->running;
-		    hostdata->target[cmd->target].cur_cmd =3D NULL;
-		    cmd->SCp.ptr =3D (unsigned char *) hostdata->issue_queue;
-		    hostdata->issue_queue =3D cmd;
-		}
-		cmd =3D hostdata->running =3D hostdata->target[id].cur_cmd;
-	    }
+	if(request_region(base_addr, 64, "sim710") =3D=3D NULL) {
+		printk(KERN_ERR "sim710: Failed to reserve IO region 0x%lx\n",
+		       base_addr);
+		goto out_free;
 	}
-	else
-	    cmd =3D hostdata->running;
=20
-	if (!cmd) {
-	    printk("scsi%d: No active command!\n", host->host_no);
-	    printk("scsi%d: Int %d, istat %02x, sstat0 %02x "
-		"dstat %02x, dsp [%04x], scratch %02x, dsps %08x\n",
-		host->host_no, sim710_intrs, istat, sstat0, dstat,
-		(u32 *)(isa_bus_to_virt(NCR_read32(DSP_REG))) - hostdata->script,
-		NCR_read32(SCRATCH_REG), dsps);
-	    /* resume_offset is zero, which will cause a host reset */
-	}
-	else if (sstat0 & SSTAT0_700_STO) {
-	    DEB(DEB_TOUT, printk("scsi%d: Selection timeout\n", host->host_no));
-	    cmd->result =3D DID_NO_CONNECT << 16;
-	    SCSI_DONE(cmd);
-	    hostdata->target[cmd->target].cur_cmd =3D NULL;
-	    resume_offset =3D Ent_reselect;
-	}
-	else if (sstat0 & (SSTAT0_SGE|SSTAT0_UDC|SSTAT0_RST|SSTAT0_PAR)) {
-	    printk("scsi%d: Serious error, sstat0 =3D %02x\n", host->host_no,
-			    sstat0);
-	    sim710_errors++;
-	    /* resume_offset is zero, which will cause a host reset */
-	}
-	else if (dstat & (DSTAT_BF|DSTAT_ABRT|DSTAT_SSI|DSTAT_WTD)) {
-	    printk("scsi%d: Serious error, dstat =3D %02x\n", host->host_no,
-			    dstat);
-	    sim710_errors++;
-	    /* resume_offset is zero, which will cause a host reset */
-	}
-	else if (dstat & DSTAT_SIR)
-	    resume_offset =3D handle_script_int(host, cmd);
-	else if (sstat0 & SSTAT0_MA)
-	    resume_offset =3D handle_phase_mismatch(host, cmd);
-	else if (dstat & DSTAT_IID) {
-	    /* This can be due to a quick reselect while doing a WAIT
-	     * DISCONNECT.
-	     */
-	    resume_offset =3D handle_idd(host, cmd);
-	}
-	else {
-	    sim710_errors++;
-	    printk("scsi%d: Spurious interrupt!\n", host->host_no);
-	    /* resume_offset is zero, which will cause a host reset */
-	}
-    }
+	/* Fill in the three required pieces of hostdata */
+	hostdata->base =3D base_addr;
+	hostdata->differential =3D differential;
+	hostdata->clock =3D clock;
+	hostdata->chip710 =3D 1;
=20
-    if (resume_offset) {
-	if (resume_offset =3D=3D Ent_reselect) {
-	    hostdata->running =3D NULL;
-	    hostdata->state =3D STATE_IDLE;
+	/* and register the chip */
+	if((host =3D NCR_700_detect(sim710_global_info.tpnt, hostdata)) =3D=3D NU=
LL) {
+		printk(KERN_ERR "sim710: No host detected; card configuration problem?\n=
");
+		goto out_release;
 	}
-	else
-	    hostdata->state =3D STATE_BUSY;
-	DEB(DEB_RESUME, printk("scsi%d: Resuming at script[0x%x]\n",
-		host->host_no, resume_offset/4));
-#ifdef DEBUG_LIMIT_INTS
-	if (sim710_intrs < DEBUG_LIMIT_INTS)
-#endif
-	{
-	    NCR_write32(SCRATCH_REG, 0);
-	    NCR_write32(DSP_REG,
-		    isa_virt_to_bus(hostdata->script+resume_offset/4));
-	}
-	if (resume_offset =3D=3D Ent_reselect)
-	    run_process_issue_queue(hostdata);
-    }
-    else {
-	printk("scsi%d: Failed to handle interrupt.  Failing commands "
-		"and resetting SCSI bus and chip\n", host->host_no);
-	mdelay(1000);		/* Give chance to read screen!! */
-	full_reset(host);
-    }
-
-}
=20
+	host->irq =3D irq;
+	host->this_id =3D scsi_id;
=20
-static void
-run_command (struct sim710_hostdata *hostdata, Scsi_Cmnd *cmd)
-{
-    struct Scsi_Host *host =3D cmd->host;
-    struct sim710_target *targdata =3D hostdata->target + cmd->target;
-    int i, datain, dataout, sg_start;
-    u32 *dip, *dop, dsa;
-
-    DEB(DEB_CMND, printk("scsi%d: id%d starting ", host->host_no,
-		cmd->target));
-    DEB(DEB_CMND, print_command(cmd->cmnd));
-
-    switch (cmd->cmnd[0]) {
-    case INQUIRY:
-    case MODE_SENSE:
-    case READ_6:
-    case READ_10:
-    case READ_CAPACITY:
-    case REQUEST_SENSE:
-    case READ_BLOCK_LIMITS:
-    case READ_TOC:
-        datain =3D 1;
-	dataout =3D 0;
-        break;
-    case MODE_SELECT:
-    case WRITE_6:
-    case WRITE_10:
-        datain =3D 0;
-        dataout =3D 1;
-        break;
-    case TEST_UNIT_READY:
-    case ALLOW_MEDIUM_REMOVAL:
-    case START_STOP:
-        datain =3D dataout =3D 0;
-        break;
-    default:
-        datain =3D dataout =3D 1;
-    }
-
-    memcpy(targdata->dsa_cdb, cmd->cmnd, MAX_CMND);
-
-    targdata->dsa_msgout[0] =3D
-		IDENTIFY((opt_nodisc[hostdata->chip] & (1<<cmd->target)) ? 0 : 1 ,0);
-    if (hostdata->negotiate & (1 << cmd->target)) {
-	if (opt_noneg[hostdata->chip] & (1 << cmd->target)) {
-	    hostdata->negotiate ^=3D (1 << cmd->target);
-	    targdata->dsa[DSA_MSGOUT] =3D 1;
-	}
-	else {
-	    DEB(DEB_SYNC, printk("scsi%d: Negotiating async transfers "
-		"for ID %d\n",
-		host->host_no, cmd->target));
-	    memcpy(targdata->dsa_msgout+1, async_message, sizeof(async_message));
-	    targdata->dsa[DSA_MSGOUT] =3D sizeof(async_message) + 1;
-	}
-    }
-    else
-	targdata->dsa[DSA_MSGOUT] =3D 1;
-
-    targdata->dsa_msgin[0] =3D 0xff;
-    targdata->dsa_status[0] =3D 0xff;
-
-    targdata->dsa[DSA_SELECT]		=3D (1 << cmd->target) << 16;
-    targdata->dsa[DSA_MSGOUT+1]		=3D isa_virt_to_bus(targdata->dsa_msgout)=
;
-    targdata->dsa[DSA_CMND]		=3D cmd->cmd_len;
-    targdata->dsa[DSA_CMND+1]		=3D isa_virt_to_bus(targdata->dsa_cdb);
-    targdata->dsa[DSA_STATUS]		=3D 1;
-    targdata->dsa[DSA_STATUS+1]		=3D isa_virt_to_bus(targdata->dsa_status)=
;
-    targdata->dsa[DSA_MSGIN]		=3D 1;
-    targdata->dsa[DSA_MSGIN+1]		=3D isa_virt_to_bus(targdata->dsa_msgin);
-
-    sg_start =3D (MAX_SG - (cmd->use_sg ? cmd->use_sg : 1)) * 2;
-    dip =3D targdata->dsa + DSA_DATAIN + sg_start;
-    dop =3D targdata->dsa + DSA_DATAOUT + sg_start;
-
-    for (i =3D 0; cmd->use_sg ? (i < cmd->use_sg) : !i; i++) {
-	struct scatterlist *sgl =3D &((struct scatterlist *)cmd->buffer)[i];
-	void *vbuf =3D cmd->use_sg ?
-		(page_address(sgl->page) + sgl->offset) :
-		(cmd->request_buffer);
-	u32 bbuf =3D isa_virt_to_bus(vbuf);
-	u32 cnt =3D cmd->use_sg ? sgl->length : cmd->request_bufflen;
-
-	if (datain) {
-	    *dip++	=3D cnt;
-	    *dip++	=3D bbuf;
-	}
-	if (dataout) {
-	    *dop++	=3D cnt;
-	    *dop++	=3D bbuf;
+	if(request_irq(irq, NCR_700_intr, SA_SHIRQ, "sim710", host)) {
+		printk(KERN_ERR "sim710: irq problem with %d, detaching\n",
+		       irq);
+		goto out_unregister;
 	}
-    }
-    targdata->data_out_jump =3D hostdata->script[Ent_patch_output_data/4+1=
] =3D
-	isa_virt_to_bus(hostdata->script + Ent_patch_output_data/4 + sg_start + 2=
);
-    targdata->data_in_jump =3D hostdata->script[Ent_patch_input_data/4+1] =
=3D
-	isa_virt_to_bus(hostdata->script + Ent_patch_input_data/4 + sg_start + 2)=
;
-
-    for (i =3D 0, dsa =3D isa_virt_to_bus(targdata->dsa); i < 4; i++) {
-	u32 v =3D hostdata->script[Ent_patch_new_dsa/4 + i * 2];
-
-	v &=3D ~0x0000ff00;
-	v |=3D (dsa & 0xff) << 8;
-	hostdata->script[Ent_patch_new_dsa/4 + i * 2] =3D v;
-	dsa >>=3D 8;
-    }
-    hostdata->running =3D targdata->cur_cmd =3D cmd;
-    hostdata->state =3D STATE_BUSY;
=20
-    NCR_write8(ISTAT_REG, ISTAT_10_SIGP);
-}
-
-
-static volatile int process_issue_queue_running =3D 0;
-=20
-static __inline__ void=20
-run_process_issue_queue(struct sim710_hostdata *hostdata)
-{
-    unsigned long flags;
-    save_flags (flags);
-    cli();
-    if (!process_issue_queue_running) {
-	process_issue_queue_running =3D 1;
-	process_issue_queue(hostdata, flags);
-	/*
-	 * process_issue_queue_running is cleared in process_issue_queue
-	 * once it can't do more work, and process_issue_queue exits with
-	 * interrupts disabled.
-	 */
-    }
-    restore_flags (flags);
-}
+	scsi_set_device(host, dev);
+	hostdata->dev =3D dev;
=20
+	sim710_global_info.found++;
=20
-/*
- * Function : process_issue_queue (hostdata, flags)
- *
- * Purpose : Start next command for any idle target.
- *=20
- * NOTE : process_issue_queue exits with interrupts *disabled*, so the=20
- *	caller must reenable them if it desires.
- *=20
- * NOTE : process_issue_queue should be called from both=20
- *	sim710_queue_command() and from the interrupt handler=20
- *	after command completion.
- */
-
-static void=20
-process_issue_queue (struct sim710_hostdata *hostdata, unsigned long flags=
)
-{
-    Scsi_Cmnd *tmp, *prev;
-    int done;
-
-    /*
-     * We run (with interrupts disabled) until we're sure that none of=20
-     * the host adapters have anything that can be done, at which point=20
-     * we set process_issue_queue_running to 0 and exit.
-     *
-     * Interrupts are enabled before doing various other internal=20
-     * instructions, after we've decided that we need to run through
-     * the loop again.
-     *
-     */
-
-    do {
-	cli(); /* Freeze request queues */
-	done =3D 1;
-	if (hostdata->issue_queue) {
-	    if (hostdata->state =3D=3D STATE_DISABLED) {
-		tmp =3D (Scsi_Cmnd *) hostdata->issue_queue;
-		hostdata->issue_queue =3D (Scsi_Cmnd *) tmp->SCp.ptr;
-		tmp->result =3D (DID_BAD_TARGET << 16);
-		tmp->scsi_done (tmp);
-		done =3D 0;
-	    }
-	    else if (hostdata->state =3D=3D STATE_IDLE) {
-		for (tmp =3D hostdata->issue_queue, prev =3D NULL; tmp;
-				prev =3D tmp, tmp =3D (Scsi_Cmnd *) tmp->SCp.ptr) {
-		    if (hostdata->target[tmp->target].cur_cmd =3D=3D NULL) {
-			if (prev)
-			    prev->SCp.ptr =3D tmp->SCp.ptr;
-			else
-			    hostdata->issue_queue =3D (Scsi_Cmnd *) tmp->SCp.ptr;
-			tmp->SCp.ptr =3D NULL;
-			run_command (hostdata, tmp);
-			done =3D 0;
-		    } /* if target/lun is not busy */
-		} /* scan issue queue for work */
-	    } /* host is idle */
-	} /* if hostdata->issue_queue */
-	if (!done)
-	    restore_flags (flags);
-    } while (!done);
-    process_issue_queue_running =3D 0;
-}
-
-
-int
-sim710_queuecommand(Scsi_Cmnd * cmd, void (*done)(Scsi_Cmnd *))
-{
-    struct Scsi_Host *host =3D cmd->host;
-    struct sim710_hostdata *hostdata =3D (struct sim710_hostdata *)host->h=
ostdata[0];
-    Scsi_Cmnd *tmp;
-    unsigned long flags;
-
-    if (cmd->lun) {
-	/* Silently ignore luns other than zero! */
-	cmd->result =3D (DID_BAD_TARGET << 16);
-	done(cmd);
-	return 0;
-    }
-
-    DEB(DEB_CMND, printk("scsi%d: id%d queuing ", host->host_no,
-		cmd->target));
-    DEB(DEB_CMND, print_command(cmd->cmnd));
-
-    cmd->scsi_done =3D done;
-    cmd->host_scribble =3D NULL;
-    cmd->SCp.ptr =3D NULL;
-    cmd->SCp.buffer =3D NULL;
-
-    save_flags(flags);
-    cli();
-
-    if (ignore_ids[hostdata->chip] & (1 << cmd->target)) {
-	printk("scsi%d: ignoring target %d\n", host->host_no, cmd->target);
-	cmd->result =3D (DID_BAD_TARGET << 16);
-	done(cmd);
-	restore_flags (flags);
-	return 0;
-    }
-#ifdef DEBUG_LIMIT_INTS
-    if (sim710_intrs > DEBUG_LIMIT_INTS) {
-	cmd->result =3D (DID_BAD_TARGET << 16);
-	done(cmd);
-	restore_flags (flags);
 	return 0;
-    }
-#endif
-    if (cmd->use_sg > MAX_SG)
-	panic ("cmd->use_sg =3D %d\n", cmd->use_sg);
=20
-    if (!(hostdata->issue_queue) || (cmd->cmnd[0] =3D=3D REQUEST_SENSE)) {
-        cmd->SCp.ptr =3D (unsigned char *) hostdata->issue_queue;
-        hostdata->issue_queue =3D cmd;
-    } else {
-        for (tmp =3D hostdata->issue_queue; tmp->SCp.ptr;
-                tmp =3D (Scsi_Cmnd *) tmp->SCp.ptr);
-        tmp->SCp.ptr =3D (unsigned char *) cmd;
-    }
-    restore_flags (flags);
-    run_process_issue_queue(hostdata);
-    return 0;
+ out_unregister:
+	scsi_unregister(host);
+ out_release:
+	release_region(host->base, 64);
+ out_free:
+	kfree(hostdata);
+ out:
+	return -ENODEV;
 }
=20
+#ifdef CONFIG_MCA
+static short sim710_mca_id_table[] =3D { 0x01bb, 0x01ba, 0x004f, 0};
=20
 __init int
-sim710_detect(Scsi_Host_Template * tpnt)
+sim710_mca_probe(struct device *dev)
 {
-    unsigned char scsi_id;
-    unsigned int base_addr;
-    struct Scsi_Host * host =3D NULL;
-    struct sim710_hostdata *hostdata;
-    unsigned long timeout;
-    unsigned long irq_mask;
-    int requested_irq;
-    int probed_irq;
-    u32 dsps;
-    int chips =3D 0;
-    int limit;
-    int indx;
-    int revision;
-    int size;
-    volatile u8 tmp;
-    struct Scsi_Host *our_hosts[MAXBOARDS+1];
-
-#ifdef MODULE
-    if (sim710)
-	param_setup(sim710);
-#endif
-
-    if (no_of_boards < 0) {
-	printk("sim710: NCR53C710 driver disabled\n");
-	return 0;
-    }
-
-#ifdef CONFIG_MCA
-    /* If board details have been specified via boot/module parameters,
-     * then don't bother probing.
-     */
-    if (no_of_boards =3D=3D 0) {
-	int slot;
+	struct mca_device *mca_dev =3D to_mca_device(dev);
+	int slot =3D mca_dev->slot;
 	int pos[3];
-	int mca_53c710_ids[] =3D MCA_53C710_IDS;
-	int *id_to_check =3D mca_53c710_ids;
+	unsigned int base;
+	int irq_vector;
+	short id =3D sim710_mca_id_table[mca_dev->index];
 	static int io_004f_by_pos[] =3D MCA_004F_IO_PORTS;
 	static int irq_004f_by_pos[] =3D MCA_004F_IRQS;
 	static int io_01bb_by_pos[] =3D MCA_01BB_IO_PORTS;
 	static int irq_01bb_by_pos[] =3D MCA_01BB_IRQS;
+	char *name;
+	int clock;
=20
-	while ( *id_to_check && no_of_boards < MAXBOARDS) {
-	    if (!MCA_bus)
-		return 0;
-
-	    if ((slot =3D mca_find_adapter(*id_to_check, 0)) !=3D MCA_NOTFOUND) {
-
-		pos[0] =3D mca_read_stored_pos(slot, 2);
-		pos[1] =3D mca_read_stored_pos(slot, 3);
-		pos[2] =3D mca_read_stored_pos(slot, 4);
-
-		/*
-		 * 01BB & 01BA port base by bits 7,6,5,4,3,2 in pos[2]
-		 *
-		 *    000000  <disabled>   001010  0x2800
-		 *    000001  <invalid>    001011  0x2C00
-		 *    000010  0x0800       001100  0x3000
-		 *    000011  0x0C00       001101  0x3400
-		 *    000100  0x1000       001110  0x3800
-		 *    000101  0x1400       001111  0x3C00
-		 *    000110  0x1800       010000  0x4000
-		 *    000111  0x1C00       010001  0x4400
-		 *    001000  0x2000       010010  0x4800
-		 *    001001  0x2400       010011  0x4C00
-		 *                         010100  0x5000
-		 *
-		 * 00F4 port base by bits 3,2,1 in pos[0]
-		 *
-		 *    000  <disabled>      001    0x200
-		 *    010  0x300           011    0x400
-		 *    100  0x500           101    0x600
-		 *
-		 * 01BB & 01BA IRQ is specified in pos[0] bits 7 and 6:
-		 *
-		 *    00   3               10   11
-		 *    01   5               11   14
-		 *
-		 * 00F4 IRQ specified by bits 6,5,4 in pos[0]
-		 *
-		 *    100   5              101    9
-		 *    110   14
-		 */
-
-		if ( *id_to_check =3D=3D 0x01bb || *id_to_check =3D=3D 0x01ba ) {
-		    bases[no_of_boards] =3D io_01bb_by_pos[(pos[2] & 0xFC) >> 2];
-		    irq_vectors[no_of_boards] =3D
-				irq_01bb_by_pos[((pos[0] & 0xC0) >> 6)];
-		    if (bases[no_of_boards] =3D=3D 0x0000)
-			printk("sim710: NCR53C710 Adapter ID 0x01bb is disabled.\n");
-		    else {
-			no_of_boards++;
-			if ( *id_to_check =3D=3D 0x01bb )
-			    mca_set_adapter_name( slot,
-				    "NCR 3360/3430 SCSI SubSystem" );
-			else
-			    mca_set_adapter_name(slot,
-				    "NCR Dual SIOP SCSI Host Adapter Board");
-		    }
-		}
-		else if ( *id_to_check =3D=3D 0x004f ) {
-		    bases[no_of_boards] =3D io_004f_by_pos[((pos[0] & 0x0E) >> 1)];
-		    irq_vectors[no_of_boards] =3D
-				irq_004f_by_pos[((pos[0] & 0x70) >> 4) - 4];
-		    if (bases[no_of_boards] =3D=3D 0x0000)
-			printk("sim710: NCR53C710 Adapter ID 0x004f is disabled.\n");
-		    else {
-			no_of_boards++;
-			mca_set_adapter_name(slot,
-				"NCR 53c710 SCSI Host Adapter Board");
-		    }
-		}
-	    }
-	    id_to_check++;
-	}
-    }
-#endif
+	pos[0] =3D mca_device_read_stored_pos(mca_dev, 2);
+	pos[1] =3D mca_device_read_stored_pos(mca_dev, 3);
+	pos[2] =3D mca_device_read_stored_pos(mca_dev, 4);
=20
-#ifdef CONFIG_EISA
-    /* Auto probe, if no boards specified in boot parameters */
-    if (no_of_boards =3D=3D 0) {
-	int io_addr;
-	/* reverse probe, so my on-board controller at 0x9000 is always scsi0 */
-	for (io_addr =3D 0x9000; no_of_boards < MAXBOARDS && io_addr >=3D 0x1000;=
 io_addr -=3D 0x1000) {
-	    if (request_region(io_addr, 0x40, "sim710") !=3D NULL) {
-		int id0 =3D inw(io_addr + 0xc80);
-		int id1 =3D inw(io_addr + 0xc82);
-		/* The on-board controller on my Proliant 2000 is 0x1044,
-		 * my EISA card is 0x1144.
-		 */
-		if (id0 =3D=3D 0x110e && (id1 =3D=3D 0x1044 || id1 =3D=3D 0x1144)) {
-		    bases[no_of_boards] =3D io_addr;
-#if 0
-		    /* This should detect the IRQ, but I havn't proved it for
-		     * myself.  Leave the old probe code active for now, as
-		     * no-one has reported problems with it.
-		     */
-		    switch (inb(io_addr + 0xc88)) {
-			case (0x00):
-			    irq_vectors[no_of_boards] =3D 11;
-			    break;
-			case (0x01):
-			    irq_vectors[no_of_boards] =3D 14;
-			    break;
-			case (0x02):
-			    irq_vectors[no_of_boards] =3D 15;
-			    break;
-			case (0x03):
-			    irq_vectors[no_of_boards] =3D 10;
-			    break;
-			case (0x04):
-			    irq_vectors[no_of_boards] =3D 9;
-			    break;
-			default:
-			    printk("sim710.c: irq nasty\n");
-		    }
-#endif
-		    no_of_boards++;
-		}
-		release_region(io_addr, 64);
-	    }
-	}
-    }
-#endif
-     =20
-    if (!no_of_boards) {
-	printk("sim710: No NCR53C710 adapter found.\n");
-	return 0;
-    }
-
-    size =3D sizeof(struct sim710_hostdata);
-    hostdata_order =3D 0;
-    while (size > (PAGE_SIZE << hostdata_order))
-	hostdata_order++;
-    size =3D PAGE_SIZE << hostdata_order;
-
-    DEB(DEB_ANY, printk("sim710: hostdata %d bytes, size %d, order %d\n",
-	sizeof(struct sim710_hostdata), size, hostdata_order));
-
-    tpnt->proc_name =3D "sim710";
-
-    memset(our_hosts, 0, sizeof(our_hosts));
-    for (indx =3D 0; indx < no_of_boards; indx++) {
-        unsigned long page =3D __get_free_pages(GFP_ATOMIC, hostdata_order=
);
-        if(page =3D=3D 0UL)
-        {
-		printk(KERN_WARNING "sim710: out of memory registering board %d.\n", ind=
x);
-		break;
-        }
-	host =3D scsi_register(tpnt, 4);
-	if(host =3D=3D NULL) {
-	    free_pages(host->hostdata[0], hostdata_order);
-	    break;
-	}
-	our_hosts[chips] =3D host;
-	host->hostdata[0] =3D page;
-	hostdata =3D (struct sim710_hostdata *)host->hostdata[0];
-	memset(hostdata, 0, size);
-	scsi_id =3D 7;
-	base_addr =3D bases[indx];
-	requested_irq =3D irq_vectors[indx];
-	printk("scsi%d: Configuring Sim710 (SCSI-ID %d) at %x, IRQ %d\n",
-			host->host_no, scsi_id, base_addr, requested_irq);
-	DEB(DEB_ANY, printk("sim710: hostdata =3D %p (%d bytes), dsa0 =3D %p\n",
-			hostdata, sizeof(struct sim710_hostdata),
-			 hostdata->target[0].dsa));
-	hostdata->chip =3D indx;
-	host->irq =3D requested_irq;
-	host->this_id =3D scsi_id;
-	host->unique_id =3D base_addr;
-	host->base =3D base_addr;
-	hostdata->msg_reject =3D MESSAGE_REJECT;
-
-	if (ncr_halt(host)) {
-	    free_pages(host->hostdata[0], hostdata_order);
-	    scsi_unregister (host);
-	    printk("scsi%d: Failed to initialise 53c710 at address %x\n",
-			host->host_no, base_addr);
-	    continue;
-	}
-	DEB(DEB_ANY,ncr_dump(host));
-	revision =3D (NCR_read8(CTEST8_REG) & 0xF0) >> 4;
-	printk("scsi%d: Revision 0x%x\n",host->host_no,revision);
-	sim710_soft_reset(host);
-
-	sim710_driver_init(host);
-
-	request_region((u32)host->base, 64, "sim710");
-	/* Now run test1 */
-	hostdata->test1_src =3D 0x53c710aa;
-	hostdata->test1_dst =3D 0x76543210;
-	NCR_write32(DSPS_REG, 0x89abcdef);
-	irq_mask =3D probe_irq_on();
-	NCR_write32(DSP_REG, virt_to_bus(hostdata->script+Ent_test1/4));
-	timeout =3D 5;
-	while (hostdata->test1_dst !=3D hostdata->test1_src && timeout--)
-	    mdelay(100);
-	tmp =3D NCR_read8(ISTAT_REG);
-	tmp =3D NCR_read8(SSTAT0_REG);
-	udelay(10);
-	tmp =3D NCR_read8(DSTAT_REG);
-	probed_irq =3D probe_irq_off(irq_mask);
-	if (requested_irq =3D=3D 0) {
-	    if (probed_irq > 0) {
-		printk("scsi%d: Chip is using IRQ %d\n", host->host_no,
-			probed_irq);
-		requested_irq =3D host->irq =3D probed_irq;
-	    }
-	    else {
-		printk("scsi%d: Failed to probe for IRQ (returned %d)\n",
-			host->host_no, probed_irq);
-		ncr_halt(host);
-		free_pages(host->hostdata[0], hostdata_order);
-		scsi_unregister (host);
-		release_region((u32)host->base, 64);
-		continue;
-	    }
-	}
-	else if (probed_irq > 0 && probed_irq !=3D requested_irq)
-	    printk("scsi%d: WARNING requested IRQ %d, but probed as %d\n",
-			host->host_no, requested_irq, probed_irq);
-	else if (probed_irq <=3D 0)
-	    printk("scsi%d: WARNING IRQ probe failed, (returned %d)\n",
-			host->host_no, probed_irq);
-=09
-	dsps =3D NCR_read32(DSPS_REG);
-	if (hostdata->test1_dst !=3D 0x53c710aa || dsps !=3D A_int_test1) {
-	    if (hostdata->test1_dst !=3D 0x53c710aa)
-		printk("scsi%d: test 1 FAILED: data: exp 0x53c710aa, got 0x%08x\n",
-			host->host_no, hostdata->test1_dst);
-	    if (dsps !=3D A_int_test1)
-		printk("scsi%d: test 1 FAILED: dsps: exp 0x%08x, got 0x%08x\n",
-			host->host_no, A_int_test1, dsps);
-	    ncr_dump(host);
-	    ncr_halt(host);
-	    free_pages(host->hostdata[0], hostdata_order);
-	    scsi_unregister (host);
-	    release_region((u32)host->base, 64);
-	    continue;
-	}
-	printk("scsi%d: test 1 completed ok.\n", host->host_no);
-
-	NCR_write32(DSP_REG, virt_to_bus(hostdata->script+Ent_reselect/4));
-	hostdata->state =3D STATE_IDLE;
-	chips++;
-    }
-    /* OK, now run down our_hosts[] calling request_irq(... SA_SHIRQ ...).
-     * Couldn't call request_irq earlier, as probing would have failed.
-     */
-    for (indx =3D 0, limit =3D chips; indx < limit; indx++) {
-	host =3D our_hosts[indx];
-	if (request_irq(host->irq, do_sim710_intr_handle,
-                       SA_INTERRUPT | SA_SHIRQ, "sim710", host))
-	{
-	    printk("scsi%d : IRQ%d not free, detaching\n",
-			host->host_no, host->irq);
-	    ncr_halt(host);
-	    free_pages(host->hostdata[0], hostdata_order);
-	    scsi_unregister (host);
-	    chips--;
-	}
-    }
-
-    return chips;
-}
+	/*
+	 * 01BB & 01BA port base by bits 7,6,5,4,3,2 in pos[2]
+	 *
+	 *    000000  <disabled>   001010  0x2800
+	 *    000001  <invalid>    001011  0x2C00
+	 *    000010  0x0800       001100  0x3000
+	 *    000011  0x0C00       001101  0x3400
+	 *    000100  0x1000       001110  0x3800
+	 *    000101  0x1400       001111  0x3C00
+	 *    000110  0x1800       010000  0x4000
+	 *    000111  0x1C00       010001  0x4400
+	 *    001000  0x2000       010010  0x4800
+	 *    001001  0x2400       010011  0x4C00
+	 *                         010100  0x5000
+	 *
+	 * 00F4 port base by bits 3,2,1 in pos[0]
+	 *
+	 *    000  <disabled>      001    0x200
+	 *    010  0x300           011    0x400
+	 *    100  0x500           101    0x600
+	 *
+	 * 01BB & 01BA IRQ is specified in pos[0] bits 7 and 6:
+	 *
+	 *    00   3               10   11
+	 *    01   5               11   14
+	 *
+	 * 00F4 IRQ specified by bits 6,5,4 in pos[0]
+	 *
+	 *    100   5              101    9
+	 *    110   14
+	 */
=20
-int
-sim710_abort(Scsi_Cmnd * cmd)
-{
-    struct Scsi_Host * host =3D cmd->host;
+	if (id =3D=3D 0x01bb || id =3D=3D 0x01ba) {
+		base =3D io_01bb_by_pos[(pos[2] & 0xFC) >> 2];
+		irq_vector =3D
+			irq_01bb_by_pos[((pos[0] & 0xC0) >> 6)];
+
+		clock =3D 50;
+		if (id =3D=3D 0x01bb)
+			name =3D "NCR 3360/3430 SCSI SubSystem";
+		else
+			name =3D "NCR Dual SIOP SCSI Host Adapter Board";
+	} else if ( id =3D=3D 0x004f ) {
+		base =3D io_004f_by_pos[((pos[0] & 0x0E) >> 1)];
+		irq_vector =3D
+			irq_004f_by_pos[((pos[0] & 0x70) >> 4) - 4];
+		clock =3D 50;
+		name =3D "NCR 53c710 SCSI Host Adapter Board";
+	} else {
+		return -ENODEV;
+	}
+	strncpy(dev->name, name, sizeof(dev->name));
+	mca_device_set_claim(mca_dev, 1);
+	base =3D mca_device_transform_ioport(mca_dev, base);
+	irq_vector =3D mca_device_transform_irq(mca_dev, irq_vector);
+
+	return sim710_probe_common(dev, base, irq_vector, clock,
+				   0, id_array[slot]);
+}
+
+struct mca_driver sim710_mca_driver =3D {
+	.id_table =3D sim710_mca_id_table,
+	.driver =3D {
+		.name =3D "sim710",
+		.bus =3D &mca_bus_type,
+		.probe =3D sim710_mca_probe,
+	},
+};
=20
-    printk("scsi%d: Unable to abort command for target %d\n",
-	   host->host_no, cmd->target);
-    return FAILED;
-}
+#endif /* CONFIG_MCA */
=20
-/*
- * This is a device reset.  Need to select and send a Bus Device Reset msg=
.
- */
+#ifdef CONFIG_EISA
+struct eisa_device_id sim710_eisa_ids[] =3D {
+	{ "CPQ4410" },
+	{ "CPQ4411" },
+	{ "HWP0C80" },
+	{ "" }
+};
=20
-int
-sim710_dev_reset(Scsi_Cmnd * SCpnt)
+__init int
+sim710_eisa_probe(struct device *dev)
 {
-    struct Scsi_Host * host =3D SCpnt->host;
+	struct eisa_device *edev =3D to_eisa_device(dev);
+	unsigned long io_addr =3D edev->base_addr;
+	char eisa_cpq_irqs[] =3D { 11, 14, 15, 10, 9, 0 };
+	char eisa_hwp_irqs[] =3D { 3, 4, 5, 7, 12, 10, 11, 0};
+	char *eisa_irqs;
+	unsigned char irq_index;
+	unsigned char irq, differential =3D 0, scsi_id =3D 7;
+
+	if(strcmp(edev->id.sig, "HWP0C80") =3D=3D 0) {
+		printk(KERN_NOTICE "sim710: FOUND HP CARD!\n");
+		eisa_irqs =3D  eisa_hwp_irqs;
+		irq_index =3D (inb(io_addr + 0xc85) & 0x7) - 1;
+		scsi_id =3D ffs(inb(io_addr + 0x4));
+	} else {
+		eisa_irqs =3D eisa_cpq_irqs;
+		irq_index =3D inb(io_addr + 0xc88);
+	}
+
+	printk(KERN_NOTICE "IRQ_INDEX %d, %d\n", irq_index,
+	       strlen(eisa_irqs));
+	=09
+	if(irq_index >=3D strlen(eisa_irqs)) {
+		printk("sim710.c: irq nasty\n");
+		return -ENODEV;
+	}
+
+	irq =3D eisa_irqs[irq_index];
+	=09
+	return sim710_probe_common(dev, io_addr, irq, 50,
+				   differential, scsi_id);
+}
+
+struct eisa_driver sim710_eisa_driver =3D {
+	.id_table =3D sim710_eisa_ids,
+	.driver =3D {
+		.name =3D		"sim710",
+		.probe =3D	sim710_eisa_probe,
+		.remove =3D	__devexit_p(sim710_device_remove),
+	},
+};
=20
-    printk("scsi%d: Unable to send Bus Device Reset for target %d\n",
-	   host->host_no, SCpnt->target);
-    return FAILED;
-}
+#endif /* CONFIG_EISA */
=20
-/*
- * This is bus reset.  We need to reset the bus and fail any active comman=
ds.
- */
=20
 int
-sim710_bus_reset(Scsi_Cmnd * SCpnt)
-{
-    struct Scsi_Host * host =3D SCpnt->host;
-
-    printk("scsi%d: Unable to do SCSI bus reset\n", host->host_no);
-    return FAILED;
-}
-
-static int
-full_reset(struct Scsi_Host * host)
+sim710_release(struct Scsi_Host *host)
 {
-    struct sim710_hostdata *hostdata =3D (struct sim710_hostdata *)
-	    host->hostdata[0];
-    int target;
-    Scsi_Cmnd *cmd;
-
-    u32 istat, dstat =3D 0, sstat0 =3D 0, sstat1 =3D 0, dsp, dsps, scratch=
;
-    unsigned long flags;
-
-    save_flags(flags);
-    cli();
-
-    istat =3D NCR_read8(ISTAT_REG);
-    if (istat & ISTAT_SIP) {
-	sstat0 =3D NCR_read8(SSTAT0_REG);
-	sstat1 =3D NCR_read8(SSTAT1_REG);
-	udelay(10);
-    }
-    if (istat & ISTAT_DIP)
-	dstat =3D NCR_read8(DSTAT_REG);
-
-    if (ncr_halt(host)) {
-	restore_flags(flags);
-	return FAILED;
-    }
-    restore_flags(flags);
-    dsp =3D NCR_read32(DSP_REG);
-    dsps =3D NCR_read32(DSPS_REG);
-    scratch =3D NCR_read32(SCRATCH_REG);
-    printk("scsi%d: istat =3D %02x, sstat0 =3D %02x, sstat1 =3D %02x, dsta=
t =3D %02x\n",
-		host->host_no, istat, sstat0, sstat1, dstat);
-    printk("scsi%d: dsp =3D %08x (script[0x%04x]), dsps =3D %08x, scratch =
=3D %08x\n",
-		host->host_no, dsp,
-		((u32)bus_to_virt(dsp) - (u32)hostdata->script)/4, dsps, scratch);
-
-    for (target =3D 0; target < 7; target++) {
-	if ((cmd =3D hostdata->target[target].cur_cmd)) {
-	    printk("scsi%d: Failing command for ID%d\n",
-			host->host_no, target);
-	    cmd->result =3D DID_RESET << 16;
-	    cmd->scsi_done(cmd);
-	    hostdata->target[target].cur_cmd =3D NULL;
-	}
-    }
+	struct D700_Host_Parameters *hostdata =3D=20
+		(struct D700_Host_Parameters *)host->hostdata[0];
=20
-    sim710_soft_reset(host);
-    sim710_driver_init(host);
-
-    NCR_write32(DSP_REG, isa_virt_to_bus(hostdata->script+Ent_reselect/4))=
;
-    hostdata->state =3D STATE_IDLE;
-
-    run_process_issue_queue(hostdata);
-
-    return SUCCESS;
+	NCR_700_release(host);
+	kfree(hostdata);
+	free_irq(host->irq, host);
+	/* should do a refcount here and unregister the drivers when
+	 * it reaches zero */
+	return 1;
 }
=20
-/*
- * This is host reset.  We need to reset the chip and the bus.
- */
-
-int
-sim710_host_reset(Scsi_Cmnd * SCpnt)
+int __init
+sim710_detect(Scsi_Host_Template *tpnt)
 {
-    struct Scsi_Host * host =3D SCpnt->host;
-
-    printk("scsi%d: >>>>>>>>>>>> Host reset <<<<<<<<<<<<\n", host->host_no=
);
-
-    return full_reset(host);
-}
+	sim710_global_info.tpnt =3D tpnt;
+	sim710_global_info.found =3D 0;
=20
 #ifdef MODULE
+	if (sim710)
+		param_setup(sim710);
+#endif
=20
-int
-sim710_release(struct Scsi_Host *host)
-{
-    ncr_halt(host);
-    free_pages(host->hostdata[0], hostdata_order);
-    free_irq(host->irq, host);
-    release_region((u32)host->base, 64);
-    return 1;
-}
+#ifdef CONFIG_MCA
+	if(MCA_bus)
+		mca_register_driver(&sim710_mca_driver);
+#endif
=20
+#ifdef CONFIG_EISA
+	eisa_driver_register(&sim710_eisa_driver);
 #endif
+	return sim710_global_info.found;
+}
=20
-static Scsi_Host_Template driver_template =3D SIM710_SCSI;
+static Scsi_Host_Template driver_template =3D {
+	.name =3D			"LSI (Symbios) 710 MCA/EISA",
+	.proc_name =3D		"sim710",
+	.detect =3D		sim710_detect,
+	.release =3D		sim710_release,
+	.this_id =3D		7,
+};
=20
 #include "scsi_module.c"

--=-c0O9jnerMMBAv+H49Aom--

