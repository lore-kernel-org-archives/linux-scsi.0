From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] Re: [PATCH 2.5.52] Janitoring drivers_acorn_scsi_fas216.c
Date: Tue, 14 Jan 2003 13:41:20 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030114025452.951672C3E4@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

[ This patch just cleans up documentation --RR ]
From:  Pablo Menichini <pablo@menichini.com.ar>

  Done.
  
  > but I don't like the int changes: int is the standard "bool" type in
  > pre-ISO C.
  
  I don't see the problem with "unsigned" bools, but I have modified the
  patch so only iterators are unsigned.It must be apply after the other one.
  Sorry for not splitting the patch before.
  
  Thanks,
  	Pablo Menichini
  
  

--- trivial-2.5.57/drivers/acorn/scsi/fas216.c.orig	2003-01-14 12:54:28.000000000 +1100
+++ trivial-2.5.57/drivers/acorn/scsi/fas216.c	2003-01-14 12:54:28.000000000 +1100
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/arm/drivers/scsi/fas216.c
+ *  linux/drivers/acorn/scsi/fas216.c
  *
  *  Copyright (C) 1997-2000 Russell King
  *
@@ -308,11 +308,12 @@
 
 static void fas216_done(FAS216_Info *info, unsigned int result);
 
-/* Function: int fas216_clockrate(unsigned int clock)
- * Purpose : calculate correct value to be written into clock conversion
- *	     factor register.
- * Params  : clock - clock speed in MHz
- * Returns : CLKF_ value
+/** 
+ * fast216_clockrate - calculate clock conversion factor
+ * @clock: clock speed in MHz
+ * 
+ * Calculate correct value to be written into clock conversion factor 
+ * register. Returns CLKF_ value.
  */
 static int fas216_clockrate(int clock)
 {
@@ -326,10 +327,12 @@
 	return clock;
 }
 
-/* Function: unsigned short fas216_get_last_msg(FAS216_Info *info, int pos)
- * Purpose : retrieve a last message from the list, using position in fifo
- * Params  : info - interface to search
- *         : pos  - current fifo position
+/** 
+ * fas216_get_last_msg - retrive last message from the list
+ * @info: interface to search
+ * @pos: current fifo position
+ * 
+ * Retrieve a last message from the list, using position in fifo.
  */
 static inline unsigned short
 fas216_get_last_msg(FAS216_Info *info, int pos)
@@ -356,12 +359,13 @@
 	return packed_msg;
 }
 
-/* Function: int fas216_syncperiod(FAS216_Info *info, int ns)
- * Purpose : Calculate value to be loaded into the STP register
- *           for a given period in ns
- * Params  : info - state structure for interface connected to device
- *         : ns   - period in ns (between subsequent bytes)
- * Returns : Value suitable for REG_STP
+/** 
+ * fas216_syncperiod - calculate STP register value
+ * @info: state structure for interface connected to device
+ * @ns: period in ns (between subsequent bytes)
+ * 
+ * Calculate value to be loaded into the STP register for a given period 
+ * in ns. Returns a value suitable for REG_STP.
  */
 static int fas216_syncperiod(FAS216_Info *info, int ns)
 {
@@ -377,10 +381,12 @@
 	return value & 31;
 }
 
-/* Function: void fas216_set_sync(FAS216_Info *info, int target)
- * Purpose : Correctly setup FAS216 chip for specified transfer period.
- * Params  : info   - state structure for interface
- *         : target - target
+/**  
+ * fas216_set_sync - setup FAS216 chip for specified transfer period.
+ * @info: state structure for interface connected to device 
+ * @target: target
+ * 
+ * Correctly setup FAS216 chip for specified transfer period.
  * Notes   : we need to switch the chip out of FASTSCSI mode if we have
  *           a transfer period >= 200ns - otherwise the chip will violate
  *           the SCSI timings.
@@ -419,10 +425,12 @@
  * we have synchronous transfers disabled for this device.
  */
 
-/* Function: void fas216_handlesync(FAS216_Info *info, char *msg)
- * Purpose : Handle a synchronous transfer message from the target
- * Params  : info - state structure for interface
- *         : msg  - message from target
+/**
+ * fas216_handlesync - Handle a synchronous transfer message
+ * @info: state structure for interface
+ * @ms: message from target
+ * 
+ * Handle a synchronous transfer message from the target
  */
 static void fas216_handlesync(FAS216_Info *info, char *msg)
 {
@@ -530,10 +538,12 @@
 	}
 }
 
-/* Function: void fas216_handlewide(FAS216_Info *info, char *msg)
- * Purpose : Handle a wide transfer message from the target
- * Params  : info - state structure for interface
- *         : msg  - message from target
+/** 
+ * fas216_handlewide - Handle a wide transfer message 
+ * @info: state structure for interface
+ * @msg: message from target
+ * 
+ * Handle a wide transfer message from the target
  */
 static void fas216_handlewide(FAS216_Info *info, char *msg)
 {
@@ -627,10 +637,12 @@
 	}
 }
 
-/* Function: void fas216_updateptrs(FAS216_Info *info, int bytes_transferred)
- * Purpose : update data pointers after transfer suspended/paused
- * Params  : info              - interface's local pointer to update
- *           bytes_transferred - number of bytes transferred
+/** 
+ * fas216_updateptrs - update data pointers after transfer suspended/paused
+ * @info: interface's local pointer to update
+ * @bytes_transferred: number of bytes transferred
+ * 
+ * Update data pointers after transfer suspended/paused
  */
 static void fas216_updateptrs(FAS216_Info *info, int bytes_transferred)
 {
@@ -664,11 +676,13 @@
 		SCp->ptr = NULL;
 }
 
-/* Function: void fas216_pio(FAS216_Info *info, fasdmadir_t direction)
- * Purpose : transfer data off of/on to card using programmed IO
- * Params  : info      - interface to transfer data to/from
- *           direction - direction to transfer data (DMA_OUT/DMA_IN)
- * Notes   : this is incredibly slow
+/**
+ * fas216_pio - transfer data off of/on to card using programmed IO
+ * @info: interface to transfer data to/from
+ * @direction: direction to transfer data (DMA_OUT/DMA_IN)
+ * 
+ * Transfer data off of/on to card using programmed IO.
+ * Notes: this is incredibly slow.
  */
 static void fas216_pio(FAS216_Info *info, fasdmadir_t direction)
 {
@@ -730,11 +744,12 @@
 	info->dma.transfer_type = fasdma_none;
 }
 
-/* Function: void fas216_starttransfer(FAS216_Info *info,
- *				       fasdmadir_t direction)
- * Purpose : Start a DMA/PIO transfer off of/on to card
- * Params  : info      - interface from which device disconnected from
- *           direction - transfer direction (DMA_OUT/DMA_IN)
+/** 
+ * fas216_starttransfer - Start a DMA/PIO transfer off of/on to card
+ * @info: interface from which device disconnected from
+ * @direction: transfer direction (DMA_OUT/DMA_IN)
+ * 
+ * Start a DMA/PIO transfer off of/on to card
  */
 static void fas216_starttransfer(FAS216_Info *info, fasdmadir_t direction)
 {
@@ -824,9 +839,11 @@
 	}
 }
 
-/* Function: void fas216_stoptransfer(FAS216_Info *info)
- * Purpose : Stop a DMA transfer onto / off of the card
- * Params  : info      - interface from which device disconnected from
+/** 
+ * fas216_stoptransfer - Stop a DMA transfer onto / off of the card
+ * @info: interface from which device disconnected from
+ * 
+ * Stop a DMA transfer onto / off of the card
  */
 static void fas216_stoptransfer(FAS216_Info *info)
 {
@@ -856,9 +873,11 @@
 	fas216_cmd(info, CMD_FLUSHFIFO);
 }
 
-/* Function: void fas216_disconnected_intr(FAS216_Info *info)
- * Purpose : handle device disconnection
- * Params  : info - interface from which device disconnected from
+/** 
+ * fas216_disconnected_intr - handle device disconnection
+ * @info: interface from which device disconnected from
+ * 
+ * Handle device disconnection
  */
 static void fas216_disconnect_intr(FAS216_Info *info)
 {
@@ -905,9 +924,11 @@
 	}
 }
 
-/* Function: void fas216_reselected_intr(FAS216_Info *info)
- * Purpose : Start reconnection of a device
- * Params  : info - interface which was reselected
+/** 
+ * fas216_reselected_intr - start reconnection of a device
+ * @info: interface which was reselected
+ * 
+ * Start reconnection of a device
  */
 static void
 fas216_reselected_intr(FAS216_Info *info)
@@ -1018,9 +1039,11 @@
 	fas216_cmd(info, CMD_MSGACCEPTED);
 }
 
-/* Function: void fas216_finish_reconnect(FAS216_Info *info)
- * Purpose : finish reconnection sequence for device
- * Params  : info - interface which caused function done interrupt
+/** 
+ * fas216_finish_reconnect - finish reconnection sequence for device
+ * @info: interface which caused function done interrupt
+ *
+ * Finish reconnection sequence for device
  */
 static void
 fas216_finish_reconnect(FAS216_Info *info)
@@ -1258,9 +1281,11 @@
 	return -3;
 }
 
-/* Function: void fas216_message(FAS216_Info *info)
- * Purpose : handle a function done interrupt from FAS216 chip
- * Params  : info - interface which caused function done interrupt
+/**
+ * fas216_message - handle a function done interrupt from FAS216 chip
+ * @info: interface which caused function done interrupt
+ * 
+ * Handle a function done interrupt from FAS216 chip
  */
 static void fas216_message(FAS216_Info *info)
 {
@@ -1326,9 +1351,11 @@
 	return;
 }
 
-/* Function: void fas216_send_command(FAS216_Info *info)
- * Purpose : send a command to a target after all message bytes have been sent
- * Params  : info - interface which caused bus service
+/**
+ * fas216_send_command - send command after all message bytes have been sent
+ * @info: interface which caused bus service
+ * 
+ * Send a command to a target after all message bytes have been sent
  */
 static void fas216_send_command(FAS216_Info *info)
 {
@@ -1348,10 +1375,12 @@
 	info->scsi.phase = PHASE_COMMAND;
 }
 
-/* Function: void fas216_send_messageout(FAS216_Info *info, int start)
- * Purpose : handle bus service to send a message
- * Params  : info - interface which caused bus service
- * Note    : We do not allow the device to change the data direction!
+/** 
+ * fas216_send_messageout - handle bus service to send a message
+ * @info: interface which caused bus service
+ * 
+ * Handle bus service to send a message.
+ * Note: We do not allow the device to change the data direction!
  */
 static void fas216_send_messageout(FAS216_Info *info, int start)
 {
@@ -1382,11 +1411,13 @@
 	info->scsi.phase = PHASE_MSGOUT;
 }
 
-/* Function: void fas216_busservice_intr(FAS216_Info *info, unsigned int stat, unsigned int ssr)
- * Purpose : handle a bus service interrupt from FAS216 chip
- * Params  : info - interface which caused bus service interrupt
- *           stat - Status register contents
- *           ssr  - SCSI Status register contents
+/** 
+ * fas216_busservice_intr - handle bus service interrupt from FAS216 chip
+ * @info: interface which caused bus service interrupt
+ * @stat: Status register contents
+ * @ssr: SCSI Status register contents
+ * 
+ * Handle a bus service interrupt from FAS216 chip
  */
 static void fas216_busservice_intr(FAS216_Info *info, unsigned int stat, unsigned int ssr)
 {
@@ -1589,11 +1620,13 @@
 	fas216_done(info, DID_ERROR);
 }
 
-/* Function: void fas216_funcdone_intr(FAS216_Info *info, unsigned int stat, unsigned int ssr)
- * Purpose : handle a function done interrupt from FAS216 chip
- * Params  : info - interface which caused function done interrupt
- *           stat - Status register contents
- *           ssr  - SCSI Status register contents
+/**
+ * fas216_funcdone_intr - handle a function done interrupt from FAS216 chip
+ * @info: interface which caused function done interrupt
+ * @stat: Status register contents
+ * @ssr: SCSI Status register contents
+ * 
+ * Handle a function done interrupt from FAS216 chip
  */
 static void fas216_funcdone_intr(FAS216_Info *info, unsigned int stat, unsigned int ssr)
 {
@@ -1681,9 +1714,11 @@
 	wake_up(&info->eh_wait);
 }
 
-/* Function: void fas216_intr(struct Scsi_Host *instance)
- * Purpose : handle interrupts from the interface to progress a command
- * Params  : instance - interface to service
+/** 
+ * fas216_intr - handle interrupts to progress a command
+ * @instance: interface to service
+ * 
+ * Handle interrupts from the interface to progress a command
  */
 void fas216_intr(struct Scsi_Host *instance)
 {
@@ -1954,10 +1989,12 @@
 	fas216_cmd(info, CMD_SELECTATNSTOP);
 }
 
-/* Function: void fas216_kick(FAS216_Info *info)
- * Purpose : kick a command to the interface - interface should be idle
- * Params  : info - our host interface to kick
- * Notes   : Interrupts are always disabled!
+/**
+ * fas216_kick - kick a command to the interface
+ * @info: our host interface to kick
+ * 
+ * kick a command to the interface, interface should be idle.
+ * Notes: Interrupts are always disabled!
  */
 static void fas216_kick(FAS216_Info *info)
 {
@@ -2052,11 +2089,13 @@
 	wake_up(&info->eh_wait);
 }
 
-/* Function: void fas216_rq_sns_done(info, SCpnt, result)
- * Purpose : Finish processing automatic request sense command
- * Params  : info   - interface that completed
- *	     SCpnt  - command that completed
- *	     result - driver byte of result
+/**
+ * fas216_rq_sns_done - Finish processing automatic request sense command
+ * @info: interface that completed
+ * @SCpnt: command that completed
+ * @result: driver byte of result
+ * 
+ * Finish processing automatic request sense command
  */
 static void
 fas216_rq_sns_done(FAS216_Info *info, Scsi_Cmnd *SCpnt, unsigned int result)
@@ -2083,11 +2122,13 @@
 	SCpnt->scsi_done(SCpnt);
 }
 
-/* Function: void fas216_std_done(info, SCpnt, result)
- * Purpose : Finish processing of standard command
- * Params  : info   - interface that completed
- *	     SCpnt  - command that completed
- *	     result - driver byte of result
+/**
+ * fas216_std_done - finish processing of standard command
+ * @info: interface that completed
+ * @SCpnt: command that completed
+ * @result: driver byte of result
+ * 
+ * Finish processing of standard command
  */
 static void
 fas216_std_done(FAS216_Info *info, Scsi_Cmnd *SCpnt, unsigned int result)
@@ -2188,10 +2229,12 @@
 	info->reqSCpnt = SCpnt;
 }
 
-/* Function: void fas216_done(FAS216_Info *info, unsigned int result)
- * Purpose : complete processing for current command
- * Params  : info   - interface that completed
- *	     result - driver byte of result
+/**
+ * fas216_done - complete processing for current command
+ * @info: interface that completed
+ * @result: driver byte of result
+ * 
+ * Complete processing for current command
  */
 static void fas216_done(FAS216_Info *info, unsigned int result)
 {
@@ -2251,12 +2294,14 @@
 		info->host->host_no);
 }
 
-/* Function: int fas216_queue_command(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
- * Purpose : queue a command for adapter to process.
- * Params  : SCpnt - Command to queue
- *	     done  - done function to call once command is complete
- * Returns : 0 - success, else error
- * Notes   : io_request_lock is held, interrupts are disabled.
+/**
+ * fas216_queue_command - queue a command for adapter to process.
+ * @SCpnt: Command to queue
+ * @done: done function to call once command is complete
+ * 
+ * Queue a command for adapter to process.
+ * Returns: 0 in success, else error. 
+ * Notes: io_request_lock is held, interrupts are disabled.
  */
 int fas216_queue_command(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 {
@@ -2304,9 +2349,11 @@
 	return result;
 }
 
-/* Function: void fas216_internal_done(Scsi_Cmnd *SCpnt)
- * Purpose : trigger restart of a waiting thread in fas216_command
- * Params  : SCpnt - Command to wake
+/**
+ * fas216_internal_done - trigger restart of a waiting thread in fas216_command
+ * @SCpnt: Command to wake
+ * 
+ * Trigger restart of a waiting thread in fas216_command
  */
 static void fas216_internal_done(Scsi_Cmnd *SCpnt)
 {
@@ -2317,11 +2364,13 @@
 	info->internal_done = 1;
 }
 
-/* Function: int fas216_command(Scsi_Cmnd *SCpnt)
- * Purpose : queue a command for adapter to process.
- * Params  : SCpnt - Command to queue
- * Returns : scsi result code
- * Notes   : io_request_lock is held, interrupts are disabled.
+/**
+ * fas216_command - queue a command for adapter to process.
+ * @SCpnt:  Command to queue
+ * 
+ * Qqueue a command for adapter to process.
+ * Returns: scsi result code.
+ * Notes: io_request_lock is held, interrupts are disabled.
  */
 int fas216_command(Scsi_Cmnd *SCpnt)
 {
@@ -2394,11 +2443,12 @@
 	res_hw_abort		/* command on disconnected dev	*/
 };
 
-/*
- * Prototype: enum res_find fas216_do_abort(FAS216_Info *info, Scsi_Cmnd *SCpnt)
- * Purpose  : decide how to abort a command
- * Params   : SCpnt - command to abort
- * Returns  : abort status
+/**
+ * fas216_do_abort - decide how to abort a command
+ * @SCpnt: command to abort
+ * 
+ * Decide how to abort a command.
+ * Returns: abort status
  */
 static enum res_find fas216_find_command(FAS216_Info *info, Scsi_Cmnd *SCpnt)
 {
@@ -2459,11 +2509,13 @@
 	return res;
 }
 
-/* Function: int fas216_eh_abort(Scsi_Cmnd *SCpnt)
- * Purpose : abort this command
- * Params  : SCpnt - command to abort
- * Returns : FAILED if unable to abort
- * Notes   : io_request_lock is taken, and irqs are disabled
+/**
+ * fas216_eh_abort - abort this command
+ * @SCpnt: command to abort
+ * 
+ * Abort this command.
+ * Returns: FAILED if unable to abort
+ * Notes: io_request_lock is taken, and irqs are disabled
  */
 int fas216_eh_abort(Scsi_Cmnd *SCpnt)
 {
@@ -2513,12 +2565,14 @@
 	return result;
 }
 
-/* Function: int fas216_eh_device_reset(Scsi_Cmnd *SCpnt)
- * Purpose : Reset the device associated with this command
- * Params  : SCpnt - command specifing device to reset
- * Returns : FAILED if unable to reset
- * Notes   : We won't be re-entered, so we'll only have one device
- *           reset on the go at one time.
+/**
+ * fas216_eh_device_reset - Reset the device associated with this command
+ * @SCpnt:  command specifing device to reset
+ * 
+ * Reset the device associated with this command.
+ * Returns: FAILED if unable to reset.
+ * Notes: We won't be re-entered, so we'll only have one device
+ *        reset on the go at one time.
  */
 int fas216_eh_device_reset(Scsi_Cmnd *SCpnt)
 {
@@ -2593,11 +2647,13 @@
 	return res;
 }
 
-/* Function: int fas216_eh_bus_reset(Scsi_Cmnd *SCpnt)
- * Purpose : Reset the bus associated with the command
- * Params  : SCpnt - command specifing bus to reset
- * Returns : FAILED if unable to reset
- * Notes   : Further commands are blocked.
+/**
+ * fas216_eh_bus_reset - Reset the bus associated with the command
+ * @SCpnt: command specifing bus to reset
+ * 
+ * Reset the bus associated with the command.
+ * Returns: FAILED if unable to reset.
+ * Notes: Further commands are blocked.
  */
 int fas216_eh_bus_reset(Scsi_Cmnd *SCpnt)
 {
@@ -2670,9 +2726,11 @@
 	return info->rst_bus_status == 1 ? SUCCESS : FAILED;
 }
 
-/* Function: void fas216_init_chip(FAS216_Info *info)
- * Purpose : Initialise FAS216 state after reset
- * Params  : info - state structure for interface
+/**
+ * fas216_init_chip - Initialise FAS216 state after reset
+ * @info:  state structure for interface
+ * 
+ * Initialise FAS216 state after reset
  */
 static void fas216_init_chip(FAS216_Info *info)
 {
@@ -2686,11 +2744,13 @@
 	outb(info->scsi.cfg[0], REG_CNTL1(info));
 }
 
-/* Function: int fas216_eh_host_reset(Scsi_Cmnd *SCpnt)
- * Purpose : Reset the host associated with this command
- * Params  : SCpnt - command specifing host to reset
- * Returns : FAILED if unable to reset
- * Notes   : io_request_lock is taken, and irqs are disabled
+/**
+ * fas216_eh_host_reset - Reset the host associated with this command
+ * @SCpnt: command specifing host to reset
+ * 
+ * Reset the host associated with this command.
+ * Returns: FAILED if unable to reset.
+ * Notes: io_request_lock is taken, and irqs are disabled
  */
 int fas216_eh_host_reset(Scsi_Cmnd *SCpnt)
 {
@@ -2826,9 +2886,11 @@
 	return TYPE_NCR53C9x;
 }
 
-/* Function: void fas216_reset_state(FAS216_Info *info)
- * Purpose : Initialise driver internal state
- * Params  : info - state to initialise
+/** 
+ * fas216_reset_state - Initialise driver internal state
+ * @info: state to initialise
+ * 
+ * Initialise driver internal state
  */
 static void fas216_reset_state(FAS216_Info *info)
 {
@@ -2864,10 +2926,12 @@
 	info->origSCpnt = NULL;
 }
 
-/* Function: int fas216_init(struct Scsi_Host *instance)
- * Purpose : initialise FAS/NCR/AMD SCSI ic.
- * Params  : instance - a driver-specific filled-out structure
- * Returns : 0 on success
+/**
+ * fas216_init - initialise FAS/NCR/AMD SCSI ic.
+ * @instance: a driver-specific filled-out structure
+ * 
+ * Initialise FAS/NCR/AMD SCSI ic.
+ * Returns: 0 on success
  */
 int fas216_init(struct Scsi_Host *instance)
 {
@@ -2937,11 +3001,12 @@
 	return 0;
 }
 
-/* Function: int fas216_release(struct Scsi_Host *instance)
- * Purpose : release all resources and put everything to bed for
- *           FAS/NCR/AMD SCSI ic.
- * Params  : instance - a driver-specific filled-out structure
- * Returns : 0 on success
+/**
+ * fas216_release - release all resources for FAS/NCR/AMD SCSI ic.
+ * @instance: a driver-specific filled-out structure
+ * 
+ * release all resources and put everything to bed for FAS/NCR/AMD SCSI ic,
+ * Returns: 0 on success.
  */
 int fas216_release(struct Scsi_Host *instance)
 {
@@ -2956,13 +3021,13 @@
 	return 0;
 }
 
-/*
- * Function: int fas216_info(FAS216_Info *info, char *buffer)
- * Purpose : generate a string containing information about this
- *	     host.
- * Params  : info   - FAS216 host information
- *	     buffer - string buffer to build string
- * Returns : size of built string
+/**
+ * fas216_info - generate a string containing information about host.
+ * @info: FAS216 host information
+ * @buffer: string buffer to build string
+ * 
+ * Generate a string containing information about this host.
+ * Returns: size of built string
  */
 int fas216_info(FAS216_Info *info, char *buffer)
 {
-- 
  Don't blame me: the Monkey is driving
  File: Pablo Menichini <pablo@menichini.com.ar>: Re: [PATCH 2.5.52] Janitoring drivers_acorn_scsi_fas216.c 
