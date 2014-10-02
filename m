From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/5] NCR5380: Whitespace cleanup
Date: Thu,  2 Oct 2014 12:43:09 +0200
Message-ID: <1412246593-107001-2-git-send-email-hare@suse.de>
References: <1412246593-107001-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbaJBKnQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 06:43:16 -0400
In-Reply-To: <1412246593-107001-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Webb Scales <webbnh@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/NCR5380.c | 652 +++++++++++++++++++++++++------------------------
 1 file changed, 333 insertions(+), 319 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 45da3c8..c8aa935 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * NCR 5380 generic driver routines.  These should make it *trivial*
  *      to implement 5380 SCSI drivers under Linux with a non-trantor
  *      architecture.
@@ -6,14 +6,14 @@
  *      Note that these routines also work with NR53c400 family chips.
  *
  * Copyright 1993, Drew Eckhardt
- *      Visionary Computing 
+ *      Visionary Computing
  *      (Unix and Linux consulting and custom programming)
  *      drew@colorado.edu
  *      +1 (303) 666-5836
  *
- * DISTRIBUTION RELEASE 6. 
+ * DISTRIBUTION RELEASE 6.
  *
- * For more information, please consult 
+ * For more information, please consult
  *
  * NCR 5380 Family
  * SCSI Protocol Controller
@@ -29,10 +29,10 @@
 /*
  * Revision 1.10 1998/9/2	Alan Cox
  *				(alan@lxorguk.ukuu.org.uk)
- * Fixed up the timer lockups reported so far. Things still suck. Looking 
+ * Fixed up the timer lockups reported so far. Things still suck. Looking
  * forward to 2.3 and per device request queues. Then it'll be possible to
  * SMP thread this beast and improve life no end.
- 
+
  * Revision 1.9  1997/7/27	Ronald van Cuijlenborg
  *				(ronald.van.cuijlenborg@tip.nl or nutty@dds.nl)
  * (hopefully) fixed and enhanced USLEEP
@@ -69,27 +69,35 @@
  */
 
 /*
- * Further development / testing that should be done : 
+ * Further development / testing that should be done :
  * 1.  Cleanup the NCR5380_transfer_dma function and DMA operation complete
- *     code so that everything does the same thing that's done at the 
+ *     code so that everything does the same thing that's done at the
  *     end of a pseudo-DMA read operation.
  *
  * 2.  Fix REAL_DMA (interrupt driven, polled works fine) -
- *     basically, transfer size needs to be reduced by one 
+ *     basically, transfer size needs to be reduced by one
  *     and the last byte read as is done with PSEUDO_DMA.
- * 
- * 4.  Test SCSI-II tagged queueing (I have no devices which support 
+ *
+ * 4.  Test SCSI-II tagged queueing (I have no devices which support
  *      tagged queueing)
  *
- * 5.  Test linked command handling code after Eric is ready with 
+ * 5.  Test linked command handling code after Eric is ready with
  *      the high level code.
  */
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_transport_spi.h>
 
 #if (NDEBUG & NDEBUG_LISTS)
-#define LIST(x,y) {printk("LINE:%d   Adding %p to %p\n", __LINE__, (void*)(x), (void*)(y)); if ((x)==(y)) udelay(5); }
-#define REMOVE(w,x,y,z) {printk("LINE:%d   Removing: %p->%p  %p->%p \n", __LINE__, (void*)(w), (void*)(x), (void*)(y), (void*)(z)); if ((x)==(y)) udelay(5); }
+#define LIST(x,y) {							\
+		printk("LINE:%d   Adding %p to %p\n", __LINE__,		\
+		       (void*)(x), (void*)(y));				\
+		if ((x)==(y)) udelay(5);				\
+	}
+#define REMOVE(w,x,y,z) {						\
+		printk("LINE:%d   Removing: %p->%p  %p->%p \n", __LINE__, \
+		       (void*)(w), (void*)(x), (void*)(y), (void*)(z));	\
+		if ((x)==(y)) udelay(5);				\
+}
 #else
 #define LIST(x,y)
 #define REMOVE(w,x,y,z)
@@ -114,9 +122,9 @@
 /*
  * Design
  *
- * This is a generic 5380 driver.  To use it on a different platform, 
+ * This is a generic 5380 driver.  To use it on a different platform,
  * one simply writes appropriate system specific macros (ie, data
- * transfer - some PC's will use the I/O bus, 68K's must use 
+ * transfer - some PC's will use the I/O bus, 68K's must use
  * memory mapped) and drops this file in their 'C' wrapper.
  *
  * (Note from hch:  unfortunately it was not enough for the different
@@ -125,33 +133,33 @@
  * most updates to this driver.  Maybe someone will fix all these
  * drivers to use a common core one day..)
  *
- * As far as command queueing, two queues are maintained for 
+ * As far as command queueing, two queues are maintained for
  * each 5380 in the system - commands that haven't been issued yet,
- * and commands that are currently executing.  This means that an 
- * unlimited number of commands may be queued, letting 
- * more commands propagate from the higher driver levels giving higher 
- * throughput.  Note that both I_T_L and I_T_L_Q nexuses are supported, 
- * allowing multiple commands to propagate all the way to a SCSI-II device 
+ * and commands that are currently executing.  This means that an
+ * unlimited number of commands may be queued, letting
+ * more commands propagate from the higher driver levels giving higher
+ * throughput.  Note that both I_T_L and I_T_L_Q nexuses are supported,
+ * allowing multiple commands to propagate all the way to a SCSI-II device
  * while a command is already executing.
  *
  *
- * Issues specific to the NCR5380 : 
+ * Issues specific to the NCR5380 :
  *
- * When used in a PIO or pseudo-dma mode, the NCR5380 is a braindead 
- * piece of hardware that requires you to sit in a loop polling for 
- * the REQ signal as long as you are connected.  Some devices are 
- * brain dead (ie, many TEXEL CD ROM drives) and won't disconnect 
+ * When used in a PIO or pseudo-dma mode, the NCR5380 is a braindead
+ * piece of hardware that requires you to sit in a loop polling for
+ * the REQ signal as long as you are connected.  Some devices are
+ * brain dead (ie, many TEXEL CD ROM drives) and won't disconnect
  * while doing long seek operations.
- * 
+ *
  * The workaround for this is to keep track of devices that have
  * disconnected.  If the device hasn't disconnected, for commands that
- * should disconnect, we do something like 
+ * should disconnect, we do something like
  *
  * while (!REQ is asserted) { sleep for N usecs; poll for M usecs }
- * 
- * Some tweaking of N and M needs to be done.  An algorithm based 
+ *
+ * Some tweaking of N and M needs to be done.  An algorithm based
  * on "time to data" would give the best results as long as short time
- * to datas (ie, on the same track) were considered, however these 
+ * to datas (ie, on the same track) were considered, however these
  * broken devices are the exception rather than the rule and I'd rather
  * spend my time optimizing for the normal case.
  *
@@ -161,23 +169,23 @@
  * which is started from a workqueue for each NCR5380 host in the
  * system.  It attempts to establish I_T_L or I_T_L_Q nexuses by
  * removing the commands from the issue queue and calling
- * NCR5380_select() if a nexus is not established. 
+ * NCR5380_select() if a nexus is not established.
  *
  * Once a nexus is established, the NCR5380_information_transfer()
  * phase goes through the various phases as instructed by the target.
  * if the target goes into MSG IN and sends a DISCONNECT message,
  * the command structure is placed into the per instance disconnected
- * queue, and NCR5380_main tries to find more work.  If the target is 
+ * queue, and NCR5380_main tries to find more work.  If the target is
  * idle for too long, the system will try to sleep.
  *
  * If a command has disconnected, eventually an interrupt will trigger,
  * calling NCR5380_intr()  which will in turn call NCR5380_reselect
  * to reestablish a nexus.  This will run main if necessary.
  *
- * On command termination, the done function will be called as 
+ * On command termination, the done function will be called as
  * appropriate.
  *
- * SCSI pointers are maintained in the SCp field of SCSI command 
+ * SCSI pointers are maintained in the SCp field of SCSI command
  * structures, being initialized after the command is connected
  * in NCR5380_select, and set as appropriate in NCR5380_information_transfer.
  * Note that in violation of the standard, an implicit SAVE POINTERS operation
@@ -187,18 +195,18 @@
 /*
  * Using this file :
  * This file a skeleton Linux SCSI driver for the NCR 5380 series
- * of chips.  To use it, you write an architecture specific functions 
+ * of chips.  To use it, you write an architecture specific functions
  * and macros and include this file in your driver.
  *
- * These macros control options : 
- * AUTOPROBE_IRQ - if defined, the NCR5380_probe_irq() function will be 
+ * These macros control options :
+ * AUTOPROBE_IRQ - if defined, the NCR5380_probe_irq() function will be
  *      defined.
- * 
+ *
  * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
- *      for commands that return with a CHECK CONDITION status. 
+ *      for commands that return with a CHECK CONDITION status.
  *
  * DIFFERENTIAL - if defined, NCR53c81 chips will use external differential
- *      transceivers. 
+ *      transceivers.
  *
  * DONT_USE_INTR - if defined, never use interrupts, even if we probe or
  *      override-configure an IRQ.
@@ -215,7 +223,7 @@
  * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
  *
  * REAL_DMA_POLL - if defined, REAL DMA is used but the driver doesn't
- *      rely on phase mismatch and EOP interrupts to determine end 
+ *      rely on phase mismatch and EOP interrupts to determine end
  *      of phase.
  *
  * UNSAFE - leave interrupts enabled during pseudo-DMA transfers.  You
@@ -224,9 +232,9 @@
  *          then, you're going to be better off twiddling with transfersize
  *          in the high level code.
  *
- * Defaults for these will be provided although the user may want to adjust 
+ * Defaults for these will be provided although the user may want to adjust
  * these to allocate CPU resources to the SCSI driver or "real" code.
- * 
+ *
  * USLEEP_SLEEP - amount of time, in jiffies, to sleep
  *
  * USLEEP_POLL - amount of time, in jiffies, to poll
@@ -237,21 +245,21 @@
  *
  * NCR5380_setup(instance) - initialize any local variables needed from a given
  *      instance of the host adapter for NCR5380_{read,write,pread,pwrite}
- * 
+ *
  * NCR5380_read(register)  - read from the specified register
  *
- * NCR5380_write(register, value) - write to the specific register 
+ * NCR5380_write(register, value) - write to the specific register
  *
- * NCR5380_implementation_fields  - additional fields needed for this 
+ * NCR5380_implementation_fields  - additional fields needed for this
  *      specific implementation of the NCR5380
  *
  * Either real DMA *or* pseudo DMA may be implemented
- * REAL functions : 
+ * REAL functions :
  * NCR5380_REAL_DMA should be defined if real DMA is to be used.
- * Note that the DMA setup functions should return the number of bytes 
+ * Note that the DMA setup functions should return the number of bytes
  *      that they were able to program the controller for.
  *
- * Also note that generic i386/PC versions of these macros are 
+ * Also note that generic i386/PC versions of these macros are
  *      available as NCR5380_i386_dma_write_setup,
  *      NCR5380_i386_dma_read_setup, and NCR5380_i386_dma_residual.
  *
@@ -264,7 +272,7 @@
  * NCR5380_pread(instance, dst, count);
  *
  * The generic driver is initialized by calling NCR5380_init(instance),
- * after setting the appropriate host specific fields and ID.  If the 
+ * after setting the appropriate host specific fields and ID.  If the
  * driver wishes to autoprobe for an IRQ line, the NCR5380_probe_irq(instance,
  * possible) function may be used.
  */
@@ -281,8 +289,8 @@ static void do_reset(struct Scsi_Host *host);
 
 static __inline__ void initialize_SCp(Scsi_Cmnd * cmd)
 {
-	/* 
-	 * Initialize the Scsi Pointer field so that all of the commands in the 
+	/*
+	 * Initialize the Scsi Pointer field so that all of the commands in the
 	 * various queues are valid.
 	 */
 
@@ -312,14 +320,15 @@ static __inline__ void initialize_SCp(Scsi_Cmnd * cmd)
  *
  *	Returns the value of the register or a negative error code.
  */
- 
-static int NCR5380_poll_politely(struct Scsi_Host *instance, int reg, int bit, int val, int t)
+
+static int NCR5380_poll_politely(struct Scsi_Host *instance,
+				 int reg, int bit, int val, int t)
 {
 	NCR5380_local_declare();
 	int n = 500;		/* At about 8uS a cycle for the cpu access */
 	unsigned long end = jiffies + t;
 	int r;
-	
+
 	NCR5380_setup(instance);
 
 	while( n-- > 0)
@@ -329,7 +338,7 @@ static int NCR5380_poll_politely(struct Scsi_Host *instance, int reg, int bit, i
 			return 0;
 		cpu_relax();
 	}
-	
+
 	/* t time yet ? */
 	while(time_before(jiffies, end))
 	{
@@ -348,12 +357,12 @@ static struct {
 	unsigned char value;
 	const char *name;
 } phases[] __maybe_unused = {
-	{PHASE_DATAOUT, "DATAOUT"}, 
-	{PHASE_DATAIN, "DATAIN"}, 
-	{PHASE_CMDOUT, "CMDOUT"}, 
-	{PHASE_STATIN, "STATIN"}, 
-	{PHASE_MSGOUT, "MSGOUT"}, 
-	{PHASE_MSGIN, "MSGIN"}, 
+	{PHASE_DATAOUT, "DATAOUT"},
+	{PHASE_DATAIN, "DATAIN"},
+	{PHASE_CMDOUT, "CMDOUT"},
+	{PHASE_STATIN, "STATIN"},
+	{PHASE_MSGOUT, "MSGOUT"},
+	{PHASE_MSGIN, "MSGIN"},
 	{PHASE_UNKNOWN, "UNKNOWN"}
 };
 
@@ -361,39 +370,39 @@ static struct {
 static struct {
 	unsigned char mask;
 	const char *name;
-} signals[] = { 
-	{SR_DBP, "PARITY"}, 
-	{SR_RST, "RST"}, 
-	{SR_BSY, "BSY"}, 
-	{SR_REQ, "REQ"}, 
-	{SR_MSG, "MSG"}, 
-	{SR_CD, "CD"}, 
-	{SR_IO, "IO"}, 
-	{SR_SEL, "SEL"}, 
+} signals[] = {
+	{SR_DBP, "PARITY"},
+	{SR_RST, "RST"},
+	{SR_BSY, "BSY"},
+	{SR_REQ, "REQ"},
+	{SR_MSG, "MSG"},
+	{SR_CD, "CD"},
+	{SR_IO, "IO"},
+	{SR_SEL, "SEL"},
 	{0, NULL}
-}, 
+},
 basrs[] = {
-	{BASR_ATN, "ATN"}, 
-	{BASR_ACK, "ACK"}, 
+	{BASR_ATN, "ATN"},
+	{BASR_ACK, "ACK"},
 	{0, NULL}
-}, 
-icrs[] = { 
-	{ICR_ASSERT_RST, "ASSERT RST"}, 
-	{ICR_ASSERT_ACK, "ASSERT ACK"}, 
-	{ICR_ASSERT_BSY, "ASSERT BSY"}, 
-	{ICR_ASSERT_SEL, "ASSERT SEL"}, 
-	{ICR_ASSERT_ATN, "ASSERT ATN"}, 
-	{ICR_ASSERT_DATA, "ASSERT DATA"}, 
+},
+icrs[] = {
+	{ICR_ASSERT_RST, "ASSERT RST"},
+	{ICR_ASSERT_ACK, "ASSERT ACK"},
+	{ICR_ASSERT_BSY, "ASSERT BSY"},
+	{ICR_ASSERT_SEL, "ASSERT SEL"},
+	{ICR_ASSERT_ATN, "ASSERT ATN"},
+	{ICR_ASSERT_DATA, "ASSERT DATA"},
 	{0, NULL}
-}, 
-mrs[] = { 
-	{MR_BLOCK_DMA_MODE, "MODE BLOCK DMA"}, 
-	{MR_TARGET, "MODE TARGET"}, 
-	{MR_ENABLE_PAR_CHECK, "MODE PARITY CHECK"}, 
-	{MR_ENABLE_PAR_INTR, "MODE PARITY INTR"}, 
-	{MR_MONITOR_BSY, "MODE MONITOR BSY"}, 
-	{MR_DMA_MODE, "MODE DMA"}, 
-	{MR_ARBITRATE, "MODE ARBITRATION"}, 
+},
+mrs[] = {
+	{MR_BLOCK_DMA_MODE, "MODE BLOCK DMA"},
+	{MR_TARGET, "MODE TARGET"},
+	{MR_ENABLE_PAR_CHECK, "MODE PARITY CHECK"},
+	{MR_ENABLE_PAR_INTR, "MODE PARITY INTR"},
+	{MR_MONITOR_BSY, "MODE MONITOR BSY"},
+	{MR_DMA_MODE, "MODE DMA"},
+	{MR_ARBITRATE, "MODE ARBITRATION"},
 	{0, NULL}
 };
 
@@ -438,11 +447,11 @@ static void NCR5380_print(struct Scsi_Host *instance)
 }
 
 
-/* 
+/*
  *	NCR5380_print_phase	-	show SCSI phase
  *	@instance: adapter to dump
  *
- * 	Print the current SCSI phase for debugging purposes
+ *	Print the current SCSI phase for debugging purposes
  *
  *	Locks: none
  */
@@ -456,16 +465,19 @@ static void NCR5380_print_phase(struct Scsi_Host *instance)
 
 	status = NCR5380_read(STATUS_REG);
 	if (!(status & SR_REQ))
-		printk("scsi%d : REQ not asserted, phase unknown.\n", instance->host_no);
+		printk("scsi%d : REQ not asserted, phase unknown.\n",
+		       instance->host_no);
 	else {
-		for (i = 0; (phases[i].value != PHASE_UNKNOWN) && (phases[i].value != (status & PHASE_MASK)); ++i);
-		printk("scsi%d : phase %s\n", instance->host_no, phases[i].name);
+		for (i = 0; (phases[i].value != PHASE_UNKNOWN) &&
+			     (phases[i].value != (status & PHASE_MASK)); ++i);
+		printk("scsi%d : phase %s\n", instance->host_no,
+		       phases[i].name);
 	}
 }
 #endif
 
 /*
- * These need tweaking, and would probably work best as per-device 
+ * These need tweaking, and would probably work best as per-device
  * flags initialized differently for disk, tape, cd, etc devices.
  * People with broken devices are free to experiment as to what gives
  * the best results for them.
@@ -487,26 +499,26 @@ static void NCR5380_print_phase(struct Scsi_Host *instance)
 #define USLEEP_WAITLONG USLEEP_SLEEP
 #endif
 
-/* 
+/*
  * Function : int should_disconnect (unsigned char cmd)
  *
- * Purpose : decide whether a command would normally disconnect or 
+ * Purpose : decide whether a command would normally disconnect or
  *      not, since if it won't disconnect we should go to sleep.
  *
  * Input : cmd - opcode of SCSI command
  *
- * Returns : DISCONNECT_LONG if we should disconnect for a really long 
- *      time (ie always, sleep, look for REQ active, sleep), 
+ * Returns : DISCONNECT_LONG if we should disconnect for a really long
+ *      time (ie always, sleep, look for REQ active, sleep),
  *      DISCONNECT_TIME_TO_DATA if we would only disconnect for a normal
  *      time-to-data delay, DISCONNECT_NONE if this command would return
  *      immediately.
  *
- *      Future sleep algorithms based on time to data can exploit 
- *      something like this so they can differentiate between "normal" 
+ *      Future sleep algorithms based on time to data can exploit
+ *      something like this so they can differentiate between "normal"
  *      (ie, read, write, seek) and unusual commands (ie, * format).
  *
  * Note : We don't deal with commands that handle an immediate disconnect,
- *        
+ *
  */
 
 static int should_disconnect(unsigned char cmd)
@@ -529,7 +541,8 @@ static int should_disconnect(unsigned char cmd)
 	}
 }
 
-static void NCR5380_set_timer(struct NCR5380_hostdata *hostdata, unsigned long timeout)
+static void NCR5380_set_timer(struct NCR5380_hostdata *hostdata,
+			      unsigned long timeout)
 {
 	hostdata->time_expires = jiffies + timeout;
 	schedule_delayed_work(&hostdata->coroutine, timeout);
@@ -547,7 +560,7 @@ static int probe_irq __initdata = 0;
  *	Set a flag to indicate the IRQ in question was received. This is
  *	used by the IRQ probe code.
  */
- 
+
 static irqreturn_t __init probe_intr(int irq, void *dev_id)
 {
 	probe_irq = irq;
@@ -575,7 +588,8 @@ static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
 	NCR5380_setup(instance);
 
 	for (trying_irqs = i = 0, mask = 1; i < 16; ++i, mask <<= 1)
-		if ((mask & possible) && (request_irq(i, &probe_intr, 0, "NCR-probe", NULL) == 0))
+		if ((mask & possible) && (request_irq(i, &probe_intr, 0,
+						      "NCR-probe", NULL) == 0))
 			trying_irqs |= mask;
 
 	timeout = jiffies + (250 * HZ / 1000);
@@ -583,7 +597,7 @@ static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
 
 	/*
 	 * A interrupt is triggered whenever BSY = false, SEL = true
-	 * and a bit set in the SELECT_ENABLE_REG is asserted on the 
+	 * and a bit set in the SELECT_ENABLE_REG is asserted on the
 	 * SCSI bus.
 	 *
 	 * Note that the bus is only driven when the phase control signals
@@ -594,11 +608,12 @@ static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
 	NCR5380_write(TARGET_COMMAND_REG, 0);
 	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_SEL);
+	NCR5380_write(INITIATOR_COMMAND_REG,
+		      ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_SEL);
 
 	while (probe_irq == SCSI_IRQ_NONE && time_before(jiffies, timeout))
 		schedule_timeout_uninterruptible(1);
-	
+
 	NCR5380_write(SELECT_ENABLE_REG, 0);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
@@ -613,7 +628,7 @@ static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
  *	NCR58380_print_options	-	show options
  *	@instance: unused for now
  *
- *	Called by probe code indicating the NCR5380 driver options that 
+ *	Called by probe code indicating the NCR5380 driver options that
  *	were selected. At some point this will switch to runtime options
  *	read from the adapter in question
  *
@@ -649,7 +664,8 @@ NCR5380_print_options(struct Scsi_Host *instance)
 	       " UNSAFE "
 #endif
 	    );
-	printk(" USLEEP, USLEEP_POLL=%d USLEEP_SLEEP=%d", USLEEP_POLL, USLEEP_SLEEP);
+	printk(" USLEEP, USLEEP_POLL=%d USLEEP_SLEEP=%d",
+	       USLEEP_POLL, USLEEP_SLEEP);
 	printk(" generic release=%d", NCR5380_PUBLIC_RELEASE);
 	if (((struct NCR5380_hostdata *) instance->hostdata)->flags & FLAG_NCR53C400) {
 		printk(" ncr53c400 release=%d", NCR53C400_PUBLIC_RELEASE);
@@ -657,10 +673,10 @@ NCR5380_print_options(struct Scsi_Host *instance)
 }
 
 /**
- *	NCR5380_print_status 	-	dump controller info
+ *	NCR5380_print_status	-	dump controller info
  *	@instance: controller to dump
  *
- *	Print commands in the various queues, called from NCR5380_abort 
+ *	Print commands in the various queues, called from NCR5380_abort
  *	and NCR5380_debug to aid debugging.
  *
  *	Locks: called functions disable irqs
@@ -791,11 +807,11 @@ static void lprint_opcode(int opcode, struct seq_file *m)
  *      with flags OR'd into the initial flags value.
  *
  *	Notes : I assume that the host, hostno, and id bits have been
- *      set correctly.  I don't care about the irq and other fields. 
+ *      set correctly.  I don't care about the irq and other fields.
  *
  *	Returns 0 for success
  *
- *	Locks: interrupts must be enabled when we are called 
+ *	Locks: interrupts must be enabled when we are called
  */
 
 static int NCR5380_init(struct Scsi_Host *instance, int flags)
@@ -807,8 +823,8 @@ static int NCR5380_init(struct Scsi_Host *instance, int flags)
 
 	if(in_interrupt())
 		printk(KERN_ERR "NCR5380_init called with interrupts off!\n");
-	/* 
-	 * On NCR53C400 boards, NCR5380 registers are mapped 8 past 
+	/*
+	 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
 	 * the base address.
 	 */
 
@@ -833,9 +849,9 @@ static int NCR5380_init(struct Scsi_Host *instance, int flags)
 	hostdata->connected = NULL;
 	hostdata->issue_queue = NULL;
 	hostdata->disconnected_queue = NULL;
-	
+
 	INIT_DELAYED_WORK(&hostdata->coroutine, NCR5380_main);
-	
+
 #ifdef NCR5380_STATS
 	for (i = 0; i < 8; ++i) {
 		hostdata->time_read[i] = 0;
@@ -860,7 +876,7 @@ static int NCR5380_init(struct Scsi_Host *instance, int flags)
 #ifndef AUTOSENSE
 	if ((instance->cmd_per_lun > 1) || instance->can_queue > 1)
 		    printk(KERN_WARNING "scsi%d : WARNING : support for multiple outstanding commands enabled\n" "         without AUTOSENSE option, contingent allegiance conditions may\n"
-		    	   "         be incorrectly cleared.\n", instance->host_no);
+			   "         be incorrectly cleared.\n", instance->host_no);
 #endif				/* def AUTOSENSE */
 
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
@@ -874,16 +890,16 @@ static int NCR5380_init(struct Scsi_Host *instance, int flags)
 	}
 #endif
 
-	/* 
+	/*
 	 * Detect and correct bus wedge problems.
 	 *
-	 * If the system crashed, it may have crashed in a state 
-	 * where a SCSI command was still executing, and the 
+	 * If the system crashed, it may have crashed in a state
+	 * where a SCSI command was still executing, and the
 	 * SCSI bus is not in a BUS FREE STATE.
 	 *
 	 * If this is the case, we'll try to abort the currently
 	 * established nexus which we know nothing about, and that
-	 * failing, do a hard reset of the SCSI bus 
+	 * failing, do a hard reset of the SCSI bus
 	 */
 
 	for (pass = 1; (NCR5380_read(STATUS_REG) & SR_BSY) && pass <= 6; ++pass) {
@@ -924,12 +940,12 @@ static void NCR5380_exit(struct Scsi_Host *instance)
 }
 
 /**
- *	NCR5380_queue_command 		-	queue a command
+ *	NCR5380_queue_command		-	queue a command
  *	@cmd: SCSI command
  *	@done: completion handler
  *
- *      cmd is added to the per instance issue_queue, with minor 
- *      twiddling done to the host specific fields of cmd.  If the 
+ *      cmd is added to the per instance issue_queue, with minor
+ *      twiddling done to the host specific fields of cmd.  If the
  *      main coroutine is not running, it is restarted.
  *
  *	Locks: host lock taken by caller
@@ -971,19 +987,19 @@ static int NCR5380_queue_command_lck(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *)
 	}
 #endif
 
-	/* 
-	 * We use the host_scribble field as a pointer to the next command  
-	 * in a queue 
+	/*
+	 * We use the host_scribble field as a pointer to the next command
+	 * in a queue
 	 */
 
 	cmd->host_scribble = NULL;
 	cmd->scsi_done = done;
 	cmd->result = 0;
 
-	/* 
-	 * Insert the cmd into the issue queue. Note that REQUEST SENSE 
+	/*
+	 * Insert the cmd into the issue queue. Note that REQUEST SENSE
 	 * commands are added to the head of the queue since any command will
-	 * clear the contingent allegiance condition that exists and the 
+	 * clear the contingent allegiance condition that exists and the
 	 * sense data is only guaranteed to be valid while the condition exists.
 	 */
 
@@ -1009,11 +1025,11 @@ static DEF_SCSI_QCMD(NCR5380_queue_command)
 /**
  *	NCR5380_main	-	NCR state machines
  *
- *	NCR5380_main is a coroutine that runs as long as more work can 
- *      be done on the NCR5380 host adapters in a system.  Both 
- *      NCR5380_queue_command() and NCR5380_intr() will try to start it 
+ *	NCR5380_main is a coroutine that runs as long as more work can
+ *      be done on the NCR5380 host adapters in a system.  Both
+ *      NCR5380_queue_command() and NCR5380_intr() will try to start it
  *      in case it is not running.
- * 
+ *
  *	Locks: called as its own thread with no locks held. Takes the
  *	host lock and called routines may take the isa dma lock.
  */
@@ -1025,7 +1041,7 @@ static void NCR5380_main(struct work_struct *work)
 	struct Scsi_Host *instance = hostdata->host;
 	Scsi_Cmnd *tmp, *prev;
 	int done;
-	
+
 	spin_lock_irq(instance->host_lock);
 	do {
 		/* Lock held here */
@@ -1036,7 +1052,7 @@ static void NCR5380_main(struct work_struct *work)
 			 * Search through the issue_queue for a command destined
 			 * for a target that's not busy.
 			 */
-			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble) 
+			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble)
 			{
 				if (prev != tmp)
 				    dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%llu\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun);
@@ -1052,17 +1068,17 @@ static void NCR5380_main(struct work_struct *work)
 					}
 					tmp->host_scribble = NULL;
 
-					/* 
-					 * Attempt to establish an I_T_L nexus here. 
+					/*
+					 * Attempt to establish an I_T_L nexus here.
 					 * On success, instance->hostdata->connected is set.
 					 * On failure, we must add the command back to the
-					 *   issue queue so we can keep trying. 
+					 *   issue queue so we can keep trying.
 					 */
 					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main() : command for target %d lun %llu removed from issue_queue\n", instance->host_no, tmp->device->id, tmp->device->lun);
-	
+
 					/*
-					 * A successful selection is defined as one that 
-					 * leaves us with the command connected and 
+					 * A successful selection is defined as one that
+					 * leaves us with the command connected and
 					 * in hostdata->connected, OR has terminated the
 					 * command.
 					 *
@@ -1074,10 +1090,10 @@ static void NCR5380_main(struct work_struct *work)
 					/* RvC: have to preset this to indicate a new command is being performed */
 
 					if (!NCR5380_select(instance, tmp,
-							    /* 
+							    /*
 							     * REQUEST SENSE commands are issued without tagged
-							     * queueing, even on SCSI-II devices because the 
-							     * contingent allegiance condition exists for the 
+							     * queueing, even on SCSI-II devices because the
+							     * contingent allegiance condition exists for the
 							     * entire unit.
 							     */
 							    (tmp->cmnd[0] == REQUEST_SENSE) ? TAG_NONE : TAG_NEXT)) {
@@ -1124,19 +1140,19 @@ static void NCR5380_main(struct work_struct *work)
 		} else
 			break;
 	} while (!done);
-	
+
 	spin_unlock_irq(instance->host_lock);
 }
 
 #ifndef DONT_USE_INTR
 
 /**
- * 	NCR5380_intr	-	generic NCR5380 irq handler
+ *	NCR5380_intr	-	generic NCR5380 irq handler
  *	@irq: interrupt number
  *	@dev_id: device info
  *
  *	Handle interrupts, reestablishing I_T_L or I_T_L_Q nexuses
- *      from the disconnected queue, and restarting NCR5380_main() 
+ *      from the disconnected queue, and restarting NCR5380_main()
  *      as required.
  *
  *	Locks: takes the needed instance locks
@@ -1194,7 +1210,7 @@ static irqreturn_t NCR5380_intr(int dummy, void *dev_id)
 					hostdata->dmalen = 0;
 
 					(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-							
+
 					/* FIXME: we need to poll briefly then defer a workqueue task ! */
 					NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG, BASR_ACK, 0, 2*HZ);
 
@@ -1214,17 +1230,16 @@ static irqreturn_t NCR5380_intr(int dummy, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-#endif 
+#endif
 
 /**
  *	collect_stats		-	collect stats on a scsi command
- *	@hostdata: adapter 
+ *	@hostdata: adapter
  *	@cmd: command being issued
  *
  *	Update the statistical data by parsing the command in question
  */
- 
-static void collect_stats(struct NCR5380_hostdata *hostdata, Scsi_Cmnd * cmd) 
+static void collect_stats(struct NCR5380_hostdata *hostdata, Scsi_Cmnd * cmd)
 {
 #ifdef NCR5380_STATS
 	switch (cmd->cmnd[0]) {
@@ -1245,40 +1260,39 @@ static void collect_stats(struct NCR5380_hostdata *hostdata, Scsi_Cmnd * cmd)
 }
 
 
-/* 
- * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd, 
+/*
+ * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd,
  *      int tag);
  *
  * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
- *      including ARBITRATION, SELECTION, and initial message out for 
- *      IDENTIFY and queue messages. 
+ *      including ARBITRATION, SELECTION, and initial message out for
+ *      IDENTIFY and queue messages.
  *
- * Inputs : instance - instantiation of the 5380 driver on which this 
- *      target lives, cmd - SCSI command to execute, tag - set to TAG_NEXT for 
- *      new tag, TAG_NONE for untagged queueing, otherwise set to the tag for 
+ * Inputs : instance - instantiation of the 5380 driver on which this
+ *      target lives, cmd - SCSI command to execute, tag - set to TAG_NEXT for
+ *      new tag, TAG_NONE for untagged queueing, otherwise set to the tag for
  *      the command that is presently connected.
- * 
+ *
  * Returns : -1 if selection could not execute for some reason,
- *      0 if selection succeeded or failed because the target 
+ *      0 if selection succeeded or failed because the target
  *      did not respond.
  *
- * Side effects : 
- *      If bus busy, arbitration failed, etc, NCR5380_select() will exit 
+ * Side effects :
+ *      If bus busy, arbitration failed, etc, NCR5380_select() will exit
  *              with registers as they should have been on entry - ie
  *              SELECT_ENABLE will be set appropriately, the NCR5380
  *              will cease to drive any SCSI bus signals.
  *
- *      If successful : I_T_L or I_T_L_Q nexus will be established, 
- *              instance->connected will be set to cmd.  
+ *      If successful : I_T_L or I_T_L_Q nexus will be established,
+ *              instance->connected will be set to cmd.
  *              SELECT interrupt will be disabled.
  *
- *      If failed (no target) : cmd->scsi_done() will be called, and the 
+ *      If failed (no target) : cmd->scsi_done() will be called, and the
  *              cmd->result host byte set to DID_BAD_TARGET.
  *
  *	Locks: caller holds hostdata lock in IRQ mode
  */
- 
-static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag) 
+static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag)
 {
 	NCR5380_local_declare();
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
@@ -1298,14 +1312,14 @@ static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag)
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dprintk(NDEBUG_ARBITRATION, "scsi%d : starting arbitration, id = %d\n", instance->host_no, instance->this_id);
 
-	/* 
-	 * Set the phase bits to 0, otherwise the NCR5380 won't drive the 
+	/*
+	 * Set the phase bits to 0, otherwise the NCR5380 won't drive the
 	 * data bus during SELECTION.
 	 */
 
 	NCR5380_write(TARGET_COMMAND_REG, 0);
 
-	/* 
+	/*
 	 * Start arbitration.
 	 */
 
@@ -1327,8 +1341,8 @@ static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag)
 
 	dprintk(NDEBUG_ARBITRATION, "scsi%d : arbitration complete\n", instance->host_no);
 
-	/* 
-	 * The arbitration delay is 2.2us, but this is a minimum and there is 
+	/*
+	 * The arbitration delay is 2.2us, but this is a minimum and there is
 	 * no maximum so we can safely sleep for ceil(2.2) usecs to accommodate
 	 * the integral nature of udelay().
 	 *
@@ -1355,8 +1369,8 @@ static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag)
 		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting ICR_ASSERT_SEL\n", instance->host_no);
 		goto failed;
 	}
-	/* 
-	 * Again, bus clear + bus settle time is 1.2us, however, this is 
+	/*
+	 * Again, bus clear + bus settle time is 1.2us, however, this is
 	 * a minimum so we'll udelay ceil(1.2)
 	 */
 
@@ -1364,14 +1378,14 @@ static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag)
 
 	dprintk(NDEBUG_ARBITRATION, "scsi%d : won arbitration\n", instance->host_no);
 
-	/* 
-	 * Now that we have won arbitration, start Selection process, asserting 
+	/*
+	 * Now that we have won arbitration, start Selection process, asserting
 	 * the host and target ID's on the SCSI bus.
 	 */
 
 	NCR5380_write(OUTPUT_DATA_REG, (hostdata->id_mask | (1 << scmd_id(cmd))));
 
-	/* 
+	/*
 	 * Raise ATN while SEL is true before BSY goes false from arbitration,
 	 * since this is the only way to guarantee that we'll get a MESSAGE OUT
 	 * phase immediately after selection.
@@ -1380,14 +1394,14 @@ static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag)
 	NCR5380_write(INITIATOR_COMMAND_REG, (ICR_BASE | ICR_ASSERT_BSY | ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_SEL));
 	NCR5380_write(MODE_REG, MR_BASE);
 
-	/* 
+	/*
 	 * Reselect interrupts must be turned off prior to the dropping of BSY,
 	 * otherwise we will trigger an interrupt.
 	 */
 	NCR5380_write(SELECT_ENABLE_REG, 0);
 
 	/*
-	 * The initiator shall then wait at least two deskew delays and release 
+	 * The initiator shall then wait at least two deskew delays and release
 	 * the BSY signal.
 	 */
 	udelay(1);		/* wingel -- wait two bus deskew delay >2*45ns */
@@ -1395,17 +1409,17 @@ static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag)
 	/* Reset BSY */
 	NCR5380_write(INITIATOR_COMMAND_REG, (ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_SEL));
 
-	/* 
+	/*
 	 * Something weird happens when we cease to drive BSY - looks
-	 * like the board/chip is letting us do another read before the 
+	 * like the board/chip is letting us do another read before the
 	 * appropriate propagation delay has expired, and we're confusing
 	 * a BSY signal from ourselves as the target's response to SELECTION.
 	 *
 	 * A small delay (the 'C++' frontend breaks the pipeline with an
 	 * unnecessary jump, making it work on my 386-33/Trantor T128, the
-	 * tighter 'C' code breaks and requires this) solves the problem - 
-	 * the 1 us delay is arbitrary, and only used because this delay will 
-	 * be the same on other platforms and since it works here, it should 
+	 * tighter 'C' code breaks and requires this) solves the problem -
+	 * the 1 us delay is arbitrary, and only used because this delay will
+	 * be the same on other platforms and since it works here, it should
 	 * work there.
 	 *
 	 * wingel suggests that this could be due to failing to wait
@@ -1416,15 +1430,15 @@ static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag)
 
 	dprintk(NDEBUG_SELECTION, "scsi%d : selecting target %d\n", instance->host_no, scmd_id(cmd));
 
-	/* 
-	 * The SCSI specification calls for a 250 ms timeout for the actual 
+	/*
+	 * The SCSI specification calls for a 250 ms timeout for the actual
 	 * selection.
 	 */
 
 	timeout = jiffies + (250 * HZ / 1000);
 
-	/* 
-	 * XXX very interesting - we're seeing a bounce where the BSY we 
+	/*
+	 * XXX very interesting - we're seeing a bounce where the BSY we
 	 * asserted is being reflected / still asserted (propagation delay?)
 	 * and it's detecting as true.  Sigh.
 	 */
@@ -1455,9 +1469,9 @@ part2:
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return -1;
 	}
-	/* 
-	 * No less than two deskew delays after the initiator detects the 
-	 * BSY signal is true, it shall release the SEL signal and may 
+	/*
+	 * No less than two deskew delays after the initiator detects the
+	 * BSY signal is true, it shall release the SEL signal and may
 	 * change the DATA BUS.                                     -wingel
 	 */
 
@@ -1486,11 +1500,11 @@ part2:
 	hostdata->targets_present |= (1 << scmd_id(cmd));
 
 	/*
-	 * Since we followed the SCSI spec, and raised ATN while SEL 
+	 * Since we followed the SCSI spec, and raised ATN while SEL
 	 * was true but before BSY was false during selection, the information
 	 * transfer phase should be a MESSAGE OUT phase so that we can send the
 	 * IDENTIFY message.
-	 * 
+	 *
 	 * If SCSI-II tagged queuing is enabled, we also send a SIMPLE_QUEUE_TAG
 	 * message (2 bytes) with a tag ID that we increment with every command
 	 * until it wraps back to 0.
@@ -1505,7 +1519,7 @@ part2:
 	spin_unlock_irq(instance->host_lock);
 	err = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
 	spin_lock_irq(instance->host_lock);
-	
+
 	if(err) {
 		printk(KERN_ERR "scsi%d: timeout at NCR5380.c:%d\n", instance->host_no, __LINE__);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
@@ -1537,16 +1551,16 @@ failed:
 
 }
 
-/* 
- * Function : int NCR5380_transfer_pio (struct Scsi_Host *instance, 
+/*
+ * Function : int NCR5380_transfer_pio (struct Scsi_Host *instance,
  *      unsigned char *phase, int *count, unsigned char **data)
  *
  * Purpose : transfers data in given phase using polled I/O
  *
- * Inputs : instance - instance of driver, *phase - pointer to 
- *      what phase is expected, *count - pointer to number of 
+ * Inputs : instance - instance of driver, *phase - pointer to
+ *      what phase is expected, *count - pointer to number of
  *      bytes to transfer, **data - pointer to data pointer.
- * 
+ *
  * Returns : -1 when different phase is entered without transferring
  *      maximum number of bytes, 0 if all bytes or transferred or exit
  *      is in same phase.
@@ -1557,7 +1571,7 @@ failed:
  */
 
 /*
- * Note : this code is not as quick as it could be, however it 
+ * Note : this code is not as quick as it could be, however it
  * IS 100% reliable, and for the actual data transfer where speed
  * counts, we will always do a pseudo DMA or DMA transfer.
  */
@@ -1579,8 +1593,8 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase
 	else
 		dprintk(NDEBUG_PIO, "scsi%d : pio read %d bytes\n", instance->host_no, c);
 
-	/* 
-	 * The NCR5380 chip will only drive the SCSI bus when the 
+	/*
+	 * The NCR5380 chip will only drive the SCSI bus when the
 	 * phase specified in the appropriate bits of the TARGET COMMAND
 	 * REGISTER match the STATUS REGISTER
 	 */
@@ -1594,9 +1608,9 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase
 		break_allowed = 1;
 	}
 	do {
-		/* 
-		 * Wait for assertion of REQ, after which the phase bits will be 
-		 * valid 
+		/*
+		 * Wait for assertion of REQ, after which the phase bits will be
+		 * valid
 		 */
 
 		/* RvC: we simply poll once, after that we stop temporarily
@@ -1628,7 +1642,7 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase
 
 		++d;
 
-		/* 
+		/*
 		 * The SCSI standard suggests that in MSGOUT phase, the initiator
 		 * should drop ATN on the last byte of the message phase
 		 * after REQ has been asserted for the handshake but before
@@ -1655,11 +1669,11 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase
 		dprintk(NDEBUG_HANDSHAKE, "scsi%d : req false, handshake complete\n", instance->host_no);
 
 /*
- * We have several special cases to consider during REQ/ACK handshaking : 
- * 1.  We were in MSGOUT phase, and we are on the last byte of the 
+ * We have several special cases to consider during REQ/ACK handshaking :
+ * 1.  We were in MSGOUT phase, and we are on the last byte of the
  *      message.  ATN must be dropped as ACK is dropped.
  *
- * 2.  We are in a MSGIN phase, and we are on the last byte of the  
+ * 2.  We are in a MSGIN phase, and we are on the last byte of the
  *      message.  We must exit with ACK asserted, so that the calling
  *      code may raise ATN before dropping ACK to reject the message.
  *
@@ -1698,7 +1712,7 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase
  *
  *	Locks: caller holds queue lock
  */
- 
+
 static void do_reset(struct Scsi_Host *host) {
 	NCR5380_local_declare();
 	NCR5380_setup(host);
@@ -1711,10 +1725,10 @@ static void do_reset(struct Scsi_Host *host) {
 
 /*
  * Function : do_abort (Scsi_Host *host)
- * 
- * Purpose : abort the currently established nexus.  Should only be 
- *      called from a routine which can drop into a 
- * 
+ *
+ * Purpose : abort the currently established nexus.  Should only be
+ *      called from a routine which can drop into a
+ *
  * Returns : 0 on success, -1 on failure.
  *
  * Locks: queue lock held by caller
@@ -1732,23 +1746,23 @@ static int do_abort(struct Scsi_Host *host) {
 	/* Request message out phase */
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 
-	/* 
-	 * Wait for the target to indicate a valid phase by asserting 
-	 * REQ.  Once this happens, we'll have either a MSGOUT phase 
-	 * and can immediately send the ABORT message, or we'll have some 
+	/*
+	 * Wait for the target to indicate a valid phase by asserting
+	 * REQ.  Once this happens, we'll have either a MSGOUT phase
+	 * and can immediately send the ABORT message, or we'll have some
 	 * other phase and will have to source/sink data.
-	 * 
+	 *
 	 * We really don't care what value was on the bus or what value
 	 * the target sees, so we just handshake.
 	 */
 
 	rc = NCR5380_poll_politely(host, STATUS_REG, SR_REQ, SR_REQ, 60 * HZ);
-	
+
 	if(rc < 0)
 		return -1;
 
 	tmp = (unsigned char)rc;
-	
+
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
 
 	if ((tmp & PHASE_MASK) != PHASE_MSGOUT) {
@@ -1773,17 +1787,17 @@ static int do_abort(struct Scsi_Host *host) {
 }
 
 #if defined(REAL_DMA) || defined(PSEUDO_DMA) || defined (REAL_DMA_POLL)
-/* 
- * Function : int NCR5380_transfer_dma (struct Scsi_Host *instance, 
+/*
+ * Function : int NCR5380_transfer_dma (struct Scsi_Host *instance,
  *      unsigned char *phase, int *count, unsigned char **data)
  *
  * Purpose : transfers data in given phase using either real
  *      or pseudo DMA.
  *
- * Inputs : instance - instance of driver, *phase - pointer to 
- *      what phase is expected, *count - pointer to number of 
+ * Inputs : instance - instance of driver, *phase - pointer to
+ *      what phase is expected, *count - pointer to number of
  *      bytes to transfer, **data - pointer to data pointer.
- * 
+ *
  * Returns : -1 when different phase is entered without transferring
  *      maximum number of bytes, 0 if all bytes or transferred or exit
  *      is in same phase.
@@ -1833,7 +1847,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase
 #else
 	/*
 	 * Note : on my sample board, watch-dog timeouts occurred when interrupts
-	 * were not disabled for the duration of a single DMA transfer, from 
+	 * were not disabled for the duration of a single DMA transfer, from
 	 * before the setting of DMA mode to after transfer of the last byte.
 	 */
 
@@ -1851,7 +1865,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase
 
 	dprintk(NDEBUG_DMA, "scsi%d : mode reg = 0x%X\n", instance->host_no, NCR5380_read(MODE_REG));
 
-	/* 
+	/*
 	 *	On the PAS16 at least I/O recovery delays are not needed here.
 	 *	Everyone else seems to want them.
 	 */
@@ -1971,24 +1985,24 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase
 		}
 		if (!(foo = NCR5380_pread(instance, d, c - diff))) {
 			/*
-			 * We can't disable DMA mode after successfully transferring 
+			 * We can't disable DMA mode after successfully transferring
 			 * what we plan to be the last byte, since that would open up
-			 * a race condition where if the target asserted REQ before 
+			 * a race condition where if the target asserted REQ before
 			 * we got the DMA mode reset, the NCR5380 would have latched
 			 * an additional byte into the INPUT DATA register and we'd
 			 * have dropped it.
-			 * 
-			 * The workaround was to transfer one fewer bytes than we 
-			 * intended to with the pseudo-DMA read function, wait for 
+			 *
+			 * The workaround was to transfer one fewer bytes than we
+			 * intended to with the pseudo-DMA read function, wait for
 			 * the chip to latch the last byte, read it, and then disable
 			 * pseudo-DMA mode.
-			 * 
+			 *
 			 * After REQ is asserted, the NCR5380 asserts DRQ and ACK.
 			 * REQ is deasserted when ACK is asserted, and not reasserted
 			 * until ACK goes false.  Since the NCR5380 won't lower ACK
 			 * until DACK is asserted, which won't happen unless we twiddle
-			 * the DMA port or we take the NCR5380 out of DMA mode, we 
-			 * can guarantee that we won't handshake another extra 
+			 * the DMA port or we take the NCR5380 out of DMA mode, we
+			 * can guarantee that we won't handshake another extra
 			 * byte.
 			 */
 
@@ -2008,8 +2022,8 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase
 		dprintk(NDEBUG_C400_PWRITE, "About to pwrite %d bytes\n", c);
 		if (!(foo = NCR5380_pwrite(instance, d, c))) {
 			/*
-			 * Wait for the last byte to be sent.  If REQ is being asserted for 
-			 * the byte we're interested, we'll ACK it and it will go false.  
+			 * Wait for the last byte to be sent.  If REQ is being asserted for
+			 * the byte we're interested, we'll ACK it and it will go false.
 			 */
 			if (!(hostdata->flags & FLAG_HAS_LAST_BYTE_SENT)) {
 				timeout = 20000;
@@ -2059,17 +2073,17 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase
 /*
  * Function : NCR5380_information_transfer (struct Scsi_Host *instance)
  *
- * Purpose : run through the various SCSI phases and do as the target 
- *      directs us to.  Operates on the currently connected command, 
+ * Purpose : run through the various SCSI phases and do as the target
+ *      directs us to.  Operates on the currently connected command,
  *      instance->connected.
  *
  * Inputs : instance, instance for which we are doing commands
  *
- * Side effects : SCSI things happen, the disconnected queue will be 
+ * Side effects : SCSI things happen, the disconnected queue will be
  *      modified if a command disconnects, *instance->connected will
  *      change.
  *
- * XXX Note : we need to watch for bus free or a reset condition here 
+ * XXX Note : we need to watch for bus free or a reset condition here
  *      to recover from an unexpected bus free condition.
  *
  * Locks: io_request_lock held by caller in IRQ mode
@@ -2121,7 +2135,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 				cmd->scsi_done(cmd);
 				return;
 #endif
-				/* 
+				/*
 				 * If there is no room left in the current buffer in the
 				 * scatter-gather list, move onto the next one.
 				 */
@@ -2134,7 +2148,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					dprintk(NDEBUG_INFORMATION, "scsi%d : %d bytes and %d buffers left\n", instance->host_no, cmd->SCp.this_residual, cmd->SCp.buffers_residual);
 				}
 				/*
-				 * The preferred transfer method is going to be 
+				 * The preferred transfer method is going to be
 				 * PSEUDO-DMA for systems that are strictly PIO,
 				 * since we can let the hardware do the handshaking.
 				 *
@@ -2197,13 +2211,13 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 
 				switch (tmp) {
 					/*
-					 * Linking lets us reduce the time required to get the 
+					 * Linking lets us reduce the time required to get the
 					 * next command out to the device, hopefully this will
 					 * mean we don't waste another revolution due to the delays
 					 * required by ARBITRATION and another SELECTION.
 					 *
 					 * In the current implementation proposal, low level drivers
-					 * merely have to start the next command, pointed to by 
+					 * merely have to start the next command, pointed to by
 					 * next_link, done() is called as with unlinked commands.
 					 */
 #ifdef LINKED
@@ -2212,7 +2226,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %llu linked command complete.\n", instance->host_no, cmd->device->id, cmd->device->lun);
-					/* 
+					/*
 					 * Sanity check : A linked command should only terminate with
 					 * one of these messages if there are more linked commands
 					 * available.
@@ -2242,20 +2256,20 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d, lun %llu completed\n", instance->host_no, cmd->device->id, cmd->device->lun);
 					hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xFF));
 
-					/* 
-					 * I'm not sure what the correct thing to do here is : 
-					 * 
-					 * If the command that just executed is NOT a request 
+					/*
+					 * I'm not sure what the correct thing to do here is :
+					 *
+					 * If the command that just executed is NOT a request
 					 * sense, the obvious thing to do is to set the result
 					 * code to the values of the stored parameters.
-					 * 
-					 * If it was a REQUEST SENSE command, we need some way 
+					 *
+					 * If it was a REQUEST SENSE command, we need some way
 					 * to differentiate between the failure code of the original
 					 * and the failure code of the REQUEST sense - the obvious
 					 * case is success, where we fall through and leave the result
 					 * code unchanged.
-					 * 
-					 * The non-obvious place is where the REQUEST SENSE failed 
+					 *
+					 * The non-obvious place is where the REQUEST SENSE failed
 					 */
 
 					if (cmd->cmnd[0] != REQUEST_SENSE)
@@ -2288,8 +2302,8 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					}
 
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-					/* 
-					 * Restore phase bits to 0 so an interrupted selection, 
+					/*
+					 * Restore phase bits to 0 so an interrupted selection,
 					 * arbitration can resume.
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
@@ -2320,8 +2334,8 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 						hostdata->connected = NULL;
 						hostdata->disconnected_queue = cmd;
 						dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d lun %llu was moved from connected to" "  the disconnected_queue\n", instance->host_no, cmd->device->id, cmd->device->lun);
-						/* 
-						 * Restore phase bits to 0 so an interrupted selection, 
+						/*
+						 * Restore phase bits to 0 so an interrupted selection,
 						 * arbitration can resume.
 						 */
 						NCR5380_write(TARGET_COMMAND_REG, 0);
@@ -2334,14 +2348,14 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 							barrier();
 						return;
 					}
-					/* 
+					/*
 					 * The SCSI data pointer is *IMPLICITLY* saved on a disconnect
-					 * operation, in violation of the SCSI spec so we can safely 
+					 * operation, in violation of the SCSI spec so we can safely
 					 * ignore SAVE/RESTORE pointers calls.
 					 *
-					 * Unfortunately, some disks violate the SCSI spec and 
+					 * Unfortunately, some disks violate the SCSI spec and
 					 * don't issue the required SAVE_POINTERS message before
-					 * disconnecting, and we have to break spec to remain 
+					 * disconnecting, and we have to break spec to remain
 					 * compatible.
 					 */
 				case SAVE_POINTERS:
@@ -2350,17 +2364,17 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 					break;
 				case EXTENDED_MESSAGE:
-/* 
+/*
  * Extended messages are sent in the following format :
- * Byte         
+ * Byte
  * 0            EXTENDED_MESSAGE == 1
- * 1            length (includes one byte for code, doesn't 
+ * 1            length (includes one byte for code, doesn't
  *              include first two bytes)
  * 2            code
  * 3..length+1  arguments
  *
  * Start the extended message buffer with the EXTENDED_MESSAGE
- * byte, since spi_print_msg() wants the whole thing.  
+ * byte, since spi_print_msg() wants the whole thing.
  */
 					extended_msg[0] = EXTENDED_MESSAGE;
 					/* Accept first byte by clearing ACK */
@@ -2400,8 +2414,8 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					}
 					/* Fall through to reject message */
 
-					/* 
-					 * If we get something weird that we aren't expecting, 
+					/*
+					 * If we get something weird that we aren't expecting,
 					 * reject it.
 					 */
 				default:
@@ -2440,10 +2454,10 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 			case PHASE_CMDOUT:
 				len = cmd->cmd_len;
 				data = cmd->cmnd;
-				/* 
-				 * XXX for performance reasons, on machines with a 
-				 * PSEUDO-DMA architecture we should probably 
-				 * use the dma transfer function.  
+				/*
+				 * XXX for performance reasons, on machines with a
+				 * PSEUDO-DMA architecture we should probably
+				 * use the dma transfer function.
 				 */
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (!cmd->device->disconnect && should_disconnect(cmd->cmnd[0])) {
@@ -2478,10 +2492,10 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 /*
  * Function : void NCR5380_reselect (struct Scsi_Host *instance)
  *
- * Purpose : does reselection, initializing the instance->connected 
- *      field to point to the Scsi_Cmnd for which the I_T_L or I_T_L_Q 
+ * Purpose : does reselection, initializing the instance->connected
+ *      field to point to the Scsi_Cmnd for which the I_T_L or I_T_L_Q
  *      nexus has been reestablished,
- *      
+ *
  * Inputs : instance - this instance of the NCR5380.
  *
  * Locks: io_request_lock held by caller if IRQ driven
@@ -2511,7 +2525,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
 	target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
 	dprintk(NDEBUG_SELECTION, "scsi%d : reselect\n", instance->host_no);
 
-	/* 
+	/*
 	 * At this point, we have detected that our SCSI ID is on the bus,
 	 * SEL is true and BSY was false for at least one bus settle delay
 	 * (400 ns).
@@ -2522,10 +2536,10 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
 
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY);
 
-	/* FIXME: timeout too long, must fail to workqueue */	
+	/* FIXME: timeout too long, must fail to workqueue */
 	if(NCR5380_poll_politely(instance, STATUS_REG, SR_SEL, 0, 2*HZ)<0)
 		abort = 1;
-		
+
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
 	/*
@@ -2550,14 +2564,14 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		lun = (msg[0] & 0x07);
 
-		/* 
+		/*
 		 * We need to add code for SCSI-II to track which devices have
 		 * I_T_L_Q nexuses established, and which have simple I_T_L
 		 * nexuses so we can chose to do additional data transfer.
 		 */
 
-		/* 
-		 * Find the command corresponding to the I_T_L or I_T_L_Q  nexus we 
+		/*
+		 * Find the command corresponding to the I_T_L or I_T_L_Q  nexus we
 		 * just reestablished, and remove it from the disconnected queue.
 		 */
 
@@ -2577,9 +2591,9 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
 			}
 		if (!tmp) {
 			printk(KERN_ERR "scsi%d : warning : target bitmask %02x lun %d not in disconnect_queue.\n", instance->host_no, target_mask, lun);
-			/* 
+			/*
 			 * Since we have an established nexus that we can't do anything with,
-			 * we must abort it.  
+			 * we must abort it.
 			 */
 			abort = 1;
 		}
@@ -2597,7 +2611,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
  * Function : void NCR5380_dma_complete (struct Scsi_Host *instance)
  *
  * Purpose : called by interrupt handler when DMA finishes or a phase
- *      mismatch occurs (which would finish the DMA transfer).  
+ *      mismatch occurs (which would finish the DMA transfer).
  *
  * Inputs : instance - this instance of the NCR5380.
  *
@@ -2617,7 +2631,7 @@ static void NCR5380_dma_complete(NCR5380_instance * instance) {
 	 *
 	 * Wait for final byte to transfer, ie wait for ACK to go false.
 	 *
-	 * We should use the Last Byte Sent bit, unfortunately this is 
+	 * We should use the Last Byte Sent bit, unfortunately this is
 	 * not available on the 5380/5381 (only the various CMOS chips)
 	 *
 	 * FIXME: timeout, and need to handle long timeout/irq case
@@ -2647,14 +2661,14 @@ static void NCR5380_dma_complete(NCR5380_instance * instance) {
  *
  * Purpose : abort a command
  *
- * Inputs : cmd - the Scsi_Cmnd to abort, code - code to set the 
- *      host byte of the result field to, if zero DID_ABORTED is 
+ * Inputs : cmd - the Scsi_Cmnd to abort, code - code to set the
+ *      host byte of the result field to, if zero DID_ABORTED is
  *      used.
  *
  * Returns : 0 - success, -1 on failure.
  *
- *	XXX - there is no way to abort the command that is currently 
- *	connected, you have to wait for it to complete.  If this is 
+ *	XXX - there is no way to abort the command that is currently
+ *	connected, you have to wait for it to complete.  If this is
  *	a problem, we could implement longjmp() / setjmp(), setjmp()
  *	called where the loop started in NCR5380_main().
  *
@@ -2666,7 +2680,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	Scsi_Cmnd *tmp, **prev;
-	
+
 	printk(KERN_WARNING "scsi%d : aborting command\n", instance->host_no);
 	scsi_print_command(cmd);
 
@@ -2679,8 +2693,8 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 
 #if 0
 /*
- * Case 1 : If the command is the currently executing command, 
- * we'll set the aborted flag and return control so that 
+ * Case 1 : If the command is the currently executing command,
+ * we'll set the aborted flag and return control so that
  * information transfer routine can exit cleanly.
  */
 
@@ -2693,13 +2707,13 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
  */
 
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_ASSERT_ATN);
-/* 
- * Since we can't change phases until we've completed the current 
+/*
+ * Since we can't change phases until we've completed the current
  * handshake, we have to source or sink a byte of data if the current
  * phase is not MSGOUT.
  */
 
-/* 
+/*
  * Return control to the executing NCR drive so we can clear the
  * aborted flag and get back into our main loop.
  */
@@ -2708,11 +2722,11 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 	}
 #endif
 
-/* 
- * Case 2 : If the command hasn't been issued yet, we simply remove it 
+/*
+ * Case 2 : If the command hasn't been issued yet, we simply remove it
  *          from the issue queue.
  */
- 
+
 	dprintk(NDEBUG_ABORT, "scsi%d : abort going into loop.\n", instance->host_no);
 	for (prev = (Scsi_Cmnd **) & (hostdata->issue_queue), tmp = (Scsi_Cmnd *) hostdata->issue_queue; tmp; prev = (Scsi_Cmnd **) & (tmp->host_scribble), tmp = (Scsi_Cmnd *) tmp->host_scribble)
 		if (cmd == tmp) {
@@ -2730,9 +2744,9 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 			printk(KERN_ERR "scsi%d : LOOP\n", instance->host_no);
 #endif
 
-/* 
+/*
  * Case 3 : If any commands are connected, we're going to fail the abort
- *          and let the high level SCSI driver retry at a later time or 
+ *          and let the high level SCSI driver retry at a later time or
  *          issue a reset.
  *
  *          Timeouts, and therefore aborted commands, will be highly unlikely
@@ -2746,22 +2760,22 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 		return FAILED;
 	}
 /*
- * Case 4: If the command is currently disconnected from the bus, and 
- *      there are no connected commands, we reconnect the I_T_L or 
- *      I_T_L_Q nexus associated with it, go into message out, and send 
+ * Case 4: If the command is currently disconnected from the bus, and
+ *      there are no connected commands, we reconnect the I_T_L or
+ *      I_T_L_Q nexus associated with it, go into message out, and send
  *      an abort message.
  *
  * This case is especially ugly. In order to reestablish the nexus, we
- * need to call NCR5380_select().  The easiest way to implement this 
+ * need to call NCR5380_select().  The easiest way to implement this
  * function was to abort if the bus was busy, and let the interrupt
  * handler triggered on the SEL for reselect take care of lost arbitrations
  * where necessary, meaning interrupts need to be enabled.
  *
- * When interrupts are enabled, the queues may change - so we 
+ * When interrupts are enabled, the queues may change - so we
  * can't remove it from the disconnected queue before selecting it
- * because that could cause a failure in hashing the nexus if that 
+ * because that could cause a failure in hashing the nexus if that
  * device reselected.
- * 
+ *
  * Since the queues may change, we can't use the pointers from when we
  * first locate it.
  *
@@ -2791,7 +2805,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 				}
 		}
 /*
- * Case 5 : If we reached this point, the command was not found in any of 
+ * Case 5 : If we reached this point, the command was not found in any of
  *          the queues.
  *
  * We probably reached this point because of an unlikely race condition
@@ -2805,9 +2819,9 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 }
 
 
-/* 
+/*
  * Function : int NCR5380_bus_reset (Scsi_Cmnd *cmd)
- * 
+ *
  * Purpose : reset the SCSI bus.
  *
  * Returns : SUCCESS
-- 
1.8.5.2

