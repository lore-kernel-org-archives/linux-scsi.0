From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 25/71] ncr5380: Rework disconnect versus poll logic
Date: Wed, 18 Nov 2015 19:35:20 +1100
Message-ID: <20151118083502.471575952@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-disconnection-reconnection
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The atari_NCR5380.c and NCR5380.c core drivers differ in their handling of
target disconnection. This is partly because atari_NCR5380.c had all of
the polling and sleeping removed to become entirely interrupt-driven, and
it is partly because of damage done to NCR5380.c after atari_NCR5380.c was
forked. See commit 37cd23b44929 ("Linux 2.1.105") in history/history.git.

The polling changes that were made in v2.1.105 are questionable at best:
if REQ is not already asserted when NCR5380_transfer_pio() is invoked, and
if the expected phase is DATA IN or DATA OUT, the function will schedule
main() to execute after USLEEP_SLEEP jiffies and then return. The problems
here are the expected REQ timing and the sleep interval*. Avoid this issue
by using NCR5380_poll_politely() instead of scheduling main().

The atari_NCR5380.c core driver requires the use of the chip interrupt and
always permits target disconnection. It sets the cmd->device->disconnect
flag when a device disconnects, but never tests this flag.

The NCR5380.c core driver permits disconnection only when
instance->irq != NO_IRQ. It sets the cmd->device->disconnect flag when
a device disconnects and it tests this flag in a couple of places:

1. During NCR5380_information_transfer(), following COMMAND OUT phase,
   if !cmd->device->disconnect, the initiator will take a guess as to
   whether or not the target will then choose to go to MESSAGE IN phase
   and disconnect. If the driver guesses "yes", it will schedule main()
   to execute after USLEEP_SLEEP jiffies and then return there.

   Unfortunately the driver may guess "yes" even after it has denied
   the target the disconnection privilege. When the target does not
   disconnect, the sleep can be beneficial, assuming the sleep interval
   is appropriate (mostly it is not*).

   And even if the driver guesses "yes" correctly, and the target would
   then disconnect, the driver still has to go through the MESSAGE IN
   phase in order to get to BUS FREE phase. The main loop can do nothing
   useful until BUS FREE, and sleeping just delays the phase transition.

2. If !cmd->device->disconnect and REQ is not already asserted when
   NCR5380_information_transfer() is invoked, the function polls for REQ
   for USLEEP_POLL jiffies. If REQ is not asserted, it then schedules
   main() to execute after USLEEP_SLEEP jiffies and returns.

   The idea is apparently to yeild the CPU while waiting for REQ.
   This is conditional upon !cmd->device->disconnect, but there seems
   to be no rhyme or reason for that. For example, the flag may be
   unset because disconnection privilege was denied because the driver
   has no IRQ. Or the flag may be unset because the device has never
   needed to disconnect before. Or if the flag is set, disconnection
   may have no relevance to the present bus phase.

Another deficiency of the existing algorithm is as follows. When the
driver has no IRQ, it prevents disconnection, and generally polls and
sleeps more than it would normally. Now, if the driver is going to poll
anyway, why not allow the target to disconnect? That way the driver can do
something useful with the bus instead of polling unproductively!

Avoid this pointless latency, complexity and guesswork by using
NCR5380_poll_politely() instead of scheduling main().

* For g_NCR5380, the time intervals for USLEEP_SLEEP and USLEEP_POLL are
  200 ms and 10 ms, respectively. They are 20 ms and 200 ms respectively
  for the other NCR5380 drivers. There doesn't seem to be any reason for
  this discrepancy. The timing seems to have no relation to the type of
  adapter. Bizarrely, the timing in g_NCR5380 seems to relate only to one
  particular type of target device. This patch attempts to solve the
  problem for all NCR5380 drivers and all target devices.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |  137 ++-----------------------------------------
 drivers/scsi/NCR5380.h       |   11 ---
 drivers/scsi/atari_NCR5380.c |   24 ++-----
 drivers/scsi/g_NCR5380.c     |    4 -
 4 files changed, 15 insertions(+), 161 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:33:35.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:33:38.000000000 +1100
@@ -139,17 +139,7 @@
  * piece of hardware that requires you to sit in a loop polling for 
  * the REQ signal as long as you are connected.  Some devices are 
  * brain dead (ie, many TEXEL CD ROM drives) and won't disconnect 
- * while doing long seek operations.
- * 
- * The workaround for this is to keep track of devices that have
- * disconnected.  If the device hasn't disconnected, for commands that
- * should disconnect, we do something like 
- *
- * while (!REQ is asserted) { sleep for N usecs; poll for M usecs }
- * 
- * Some tweaking of N and M needs to be done.  An algorithm based 
- * on "time to data" would give the best results as long as short time
- * to datas (ie, on the same track) were considered, however these 
+ * while doing long seek operations. [...] These
  * broken devices are the exception rather than the rule and I'd rather
  * spend my time optimizing for the normal case.
  *
@@ -220,10 +210,6 @@
  * Defaults for these will be provided although the user may want to adjust 
  * these to allocate CPU resources to the SCSI driver or "real" code.
  * 
- * USLEEP_SLEEP - amount of time, in jiffies, to sleep
- *
- * USLEEP_POLL - amount of time, in jiffies, to poll
- *
  * These macros MUST be defined :
  * 
  * NCR5380_read(register)  - read from the specified register
@@ -458,73 +444,6 @@ static void NCR5380_print_phase(struct S
 }
 #endif
 
-/*
- * These need tweaking, and would probably work best as per-device 
- * flags initialized differently for disk, tape, cd, etc devices.
- * People with broken devices are free to experiment as to what gives
- * the best results for them.
- *
- * USLEEP_SLEEP should be a minimum seek time.
- *
- * USLEEP_POLL should be a maximum rotational latency.
- */
-#ifndef USLEEP_SLEEP
-/* 20 ms (reasonable hard disk speed) */
-#define USLEEP_SLEEP msecs_to_jiffies(20)
-#endif
-/* 300 RPM (floppy speed) */
-#ifndef USLEEP_POLL
-#define USLEEP_POLL msecs_to_jiffies(200)
-#endif
-
-/* 
- * Function : int should_disconnect (unsigned char cmd)
- *
- * Purpose : decide whether a command would normally disconnect or 
- *      not, since if it won't disconnect we should go to sleep.
- *
- * Input : cmd - opcode of SCSI command
- *
- * Returns : DISCONNECT_LONG if we should disconnect for a really long 
- *      time (ie always, sleep, look for REQ active, sleep), 
- *      DISCONNECT_TIME_TO_DATA if we would only disconnect for a normal
- *      time-to-data delay, DISCONNECT_NONE if this command would return
- *      immediately.
- *
- *      Future sleep algorithms based on time to data can exploit 
- *      something like this so they can differentiate between "normal" 
- *      (ie, read, write, seek) and unusual commands (ie, * format).
- *
- * Note : We don't deal with commands that handle an immediate disconnect,
- *        
- */
-
-static int should_disconnect(unsigned char cmd)
-{
-	switch (cmd) {
-	case READ_6:
-	case WRITE_6:
-	case SEEK_6:
-	case READ_10:
-	case WRITE_10:
-	case SEEK_10:
-		return DISCONNECT_TIME_TO_DATA;
-	case FORMAT_UNIT:
-	case SEARCH_HIGH:
-	case SEARCH_LOW:
-	case SEARCH_EQUAL:
-		return DISCONNECT_LONG;
-	default:
-		return DISCONNECT_NONE;
-	}
-}
-
-static void NCR5380_set_timer(struct NCR5380_hostdata *hostdata, unsigned long timeout)
-{
-	hostdata->time_expires = jiffies + timeout;
-	queue_delayed_work(hostdata->work_q, &hostdata->coroutine, timeout);
-}
-
 
 static int probe_irq __initdata;
 
@@ -623,9 +542,6 @@ static void prepare_info(struct Scsi_Hos
 	         "can_queue %d, cmd_per_lun %d, "
 	         "sg_tablesize %d, this_id %d, "
 	         "flags { %s%s%s%s}, "
-#if defined(USLEEP_POLL) && defined(USLEEP_SLEEP)
-		 "USLEEP_POLL %lu, USLEEP_SLEEP %lu, "
-#endif
 	         "options { %s} ",
 	         instance->hostt->name, instance->io_port, instance->n_io_port,
 	         instance->base, instance->irq,
@@ -635,9 +551,6 @@ static void prepare_info(struct Scsi_Hos
 	         hostdata->flags & FLAG_DTC3181E      ? "DTC3181E "      : "",
 	         hostdata->flags & FLAG_NO_PSEUDO_DMA ? "NO_PSEUDO_DMA " : "",
 	         hostdata->flags & FLAG_TOSHIBA_DELAY ? "TOSHIBA_DELAY "  : "",
-#if defined(USLEEP_POLL) && defined(USLEEP_SLEEP)
-	         USLEEP_POLL, USLEEP_SLEEP,
-#endif
 #ifdef AUTOPROBE_IRQ
 	         "AUTOPROBE_IRQ "
 #endif
@@ -812,7 +725,6 @@ static int NCR5380_init(struct Scsi_Host
 		hostdata->flags = FLAG_CHECK_LAST_BYTE_SENT | flags;
 
 	hostdata->host = instance;
-	hostdata->time_expires = 0;
 
 	prepare_info(instance);
 
@@ -1034,7 +946,6 @@ static void NCR5380_main(struct work_str
 #ifdef REAL_DMA
 		    && !hostdata->dmalen
 #endif
-		    && (!hostdata->time_expires || time_before_eq(hostdata->time_expires, jiffies))
 		    ) {
 			dprintk(NDEBUG_MAIN, "scsi%d : main() : performing information transfer\n", instance->host_no);
 			NCR5380_information_transfer(instance);
@@ -1414,11 +1325,6 @@ static int NCR5380_transfer_pio(struct S
 	unsigned char p = *phase, tmp;
 	int c = *count;
 	unsigned char *d = *data;
-	/*
-	 *      RvC: some administrative data to process polling time
-	 */
-	int break_allowed = 0;
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
 	if (!(p & SR_IO))
 		dprintk(NDEBUG_PIO, "scsi%d : pio write %d bytes\n", instance->host_no, c);
@@ -1433,35 +1339,19 @@ static int NCR5380_transfer_pio(struct S
 
 	 NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
 
-	/* RvC: don't know if this is necessary, but other SCSI I/O is short
-	 *      so breaks are not necessary there
-	 */
-	if ((p == PHASE_DATAIN) || (p == PHASE_DATAOUT)) {
-		break_allowed = 1;
-	}
 	do {
 		/* 
 		 * Wait for assertion of REQ, after which the phase bits will be 
 		 * valid 
 		 */
 
-		/* RvC: we simply poll once, after that we stop temporarily
-		 *      and let the device buffer fill up
-		 *      if breaking is not allowed, we keep polling as long as needed
-		 */
-
-		/* FIXME */
-		while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ) && !break_allowed);
-		if (!(tmp & SR_REQ)) {
-			/* timeout condition */
-			NCR5380_set_timer(hostdata, USLEEP_SLEEP);
+		if (NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ) < 0)
 			break;
-		}
 
 		dprintk(NDEBUG_HANDSHAKE, "scsi%d : REQ detected\n", instance->host_no);
 
 		/* Check for phase mismatch */
-		if ((tmp & PHASE_MASK) != p) {
+		if ((NCR5380_read(STATUS_REG) & PHASE_MASK) != p) {
 			dprintk(NDEBUG_HANDSHAKE, "scsi%d : phase mismatch\n", instance->host_no);
 			NCR5380_dprint_phase(NDEBUG_HANDSHAKE, instance);
 			break;
@@ -1933,8 +1823,6 @@ static void NCR5380_information_transfer
 	unsigned char *data;
 	unsigned char phase, tmp, extended_msg[10], old_phase = 0xff;
 	struct scsi_cmnd *cmd = (struct scsi_cmnd *) hostdata->connected;
-	/* RvC: we need to set the end of the polling time */
-	unsigned long poll_time = jiffies + USLEEP_POLL;
 
 	while (1) {
 		tmp = NCR5380_read(STATUS_REG);
@@ -2134,7 +2022,6 @@ static void NCR5380_information_transfer
 				case DISCONNECT:{
 						/* Accept message by clearing ACK */
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-						cmd->device->disconnect = 1;
 						LIST(cmd, hostdata->disconnected_queue);
 						cmd->host_scribble = (unsigned char *)
 						    hostdata->disconnected_queue;
@@ -2266,11 +2153,6 @@ static void NCR5380_information_transfer
 				 * use the dma transfer function.  
 				 */
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
-				if (!cmd->device->disconnect && should_disconnect(cmd->cmnd[0])) {
-					NCR5380_set_timer(hostdata, USLEEP_SLEEP);
-					dprintk(NDEBUG_USLEEP, "scsi%d : issued command, sleeping until %lu\n", instance->host_no, hostdata->time_expires);
-					return;
-				}
 				break;
 			case PHASE_STATIN:
 				len = 1;
@@ -2282,15 +2164,10 @@ static void NCR5380_information_transfer
 				printk("scsi%d : unknown phase\n", instance->host_no);
 				NCR5380_dprint(NDEBUG_ANY, instance);
 			}	/* switch(phase) */
-		}		/* if (tmp * SR_REQ) */
-		else {
-			/* RvC: go to sleep if polling time expired
-			 */
-			if (!cmd->device->disconnect && time_after_eq(jiffies, poll_time)) {
-				NCR5380_set_timer(hostdata, USLEEP_SLEEP);
-				dprintk(NDEBUG_USLEEP, "scsi%d : poll timed out, sleeping until %lu\n", instance->host_no, hostdata->time_expires);
-				return;
-			}
+		} else {
+			spin_unlock_irq(instance->host_lock);
+			NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
+			spin_lock_irq(instance->host_lock);
 		}
 	}			/* while (1) */
 }
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-11-18 19:33:33.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-11-18 19:33:38.000000000 +1100
@@ -205,16 +205,6 @@
 
 #define PHASE_SR_TO_TCR(phase) ((phase) >> 2)
 
-/*
- * The internal should_disconnect() function returns these based on the 
- * expected length of a disconnect if a device supports disconnect/
- * reconnect.
- */
-
-#define DISCONNECT_NONE		0
-#define DISCONNECT_TIME_TO_DATA	1
-#define DISCONNECT_LONG		2
-
 /* 
  * "Special" value for the (unsigned char) command tag, to indicate
  * I_T_L nexus instead of I_T_L_Q.
@@ -266,7 +256,6 @@ struct NCR5380_hostdata {
 	volatile struct scsi_cmnd *issue_queue;	/* waiting to be issued */
 	volatile struct scsi_cmnd *disconnected_queue;	/* waiting for reconnect */
 	int flags;
-	unsigned long time_expires;		/* in jiffies, set prior to sleeping */
 	struct delayed_work coroutine;		/* our co-routine */
 	struct scsi_eh_save ses;
 	char info[256];
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:35.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:38.000000000 +1100
@@ -126,17 +126,7 @@
  * piece of hardware that requires you to sit in a loop polling for
  * the REQ signal as long as you are connected.  Some devices are
  * brain dead (ie, many TEXEL CD ROM drives) and won't disconnect
- * while doing long seek operations.
- *
- * The workaround for this is to keep track of devices that have
- * disconnected.  If the device hasn't disconnected, for commands that
- * should disconnect, we do something like
- *
- * while (!REQ is asserted) { sleep for N usecs; poll for M usecs }
- *
- * Some tweaking of N and M needs to be done.  An algorithm based
- * on "time to data" would give the best results as long as short time
- * to datas (ie, on the same track) were considered, however these
+ * while doing long seek operations. [...] These
  * broken devices are the exception rather than the rule and I'd rather
  * spend my time optimizing for the normal case.
  *
@@ -1734,13 +1724,14 @@ static int NCR5380_transfer_pio(struct S
 		 * Wait for assertion of REQ, after which the phase bits will be
 		 * valid
 		 */
-		while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ))
-			;
+
+		if (NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ) < 0)
+			break;
 
 		dprintk(NDEBUG_HANDSHAKE, "scsi%d: REQ detected\n", HOSTNO);
 
 		/* Check for phase mismatch */
-		if ((tmp & PHASE_MASK) != p) {
+		if ((NCR5380_read(STATUS_REG) & PHASE_MASK) != p) {
 			dprintk(NDEBUG_PIO, "scsi%d: phase mismatch\n", HOSTNO);
 			NCR5380_dprint_phase(NDEBUG_PIO, instance);
 			break;
@@ -2393,7 +2384,6 @@ static void NCR5380_information_transfer
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 					local_irq_save(flags);
-					cmd->device->disconnect = 1;
 					LIST(cmd,hostdata->disconnected_queue);
 					SET_NEXT(cmd, hostdata->disconnected_queue);
 					hostdata->connected = NULL;
@@ -2558,7 +2548,9 @@ static void NCR5380_information_transfer
 				printk("scsi%d: unknown phase\n", HOSTNO);
 				NCR5380_dprint(NDEBUG_ANY, instance);
 			} /* switch(phase) */
-		} /* if (tmp * SR_REQ) */
+		} else {
+			NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
+		}
 	} /* while (1) */
 }
 
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-11-18 19:33:35.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-11-18 19:33:38.000000000 +1100
@@ -56,10 +56,6 @@
  *     
  */
 
-/* settings for DTC3181E card with only Mustek scanner attached */
-#define USLEEP_POLL	msecs_to_jiffies(10)
-#define USLEEP_SLEEP	msecs_to_jiffies(200)
-
 #define AUTOPROBE_IRQ
 
 #ifdef CONFIG_SCSI_GENERIC_NCR53C400
