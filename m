From: Bob Doyle <doyle@primenet.com>
Subject: BusLogic cleanup
Date: Thu, 01 Jan 2004 23:47:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FF513FE.17A1C2FD@primenet.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------7071404970DB7F41ED5C1832"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3.roc2.gblx.net ([64.215.96.102]:40338 "EHLO
	smtp3.roc2.gblx.net") by vger.kernel.org with ESMTP id S265132AbUABGrf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jan 2004 01:47:35 -0500
Received: (from smmsp@localhost)
	by smtp3.roc2.gblx.net (8.12.9/8.12.8) id i026lX9r039284
	for <linux-scsi@vger.kernel.org>; Fri, 2 Jan 2004 06:47:33 GMT
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------7071404970DB7F41ED5C1832
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

I'm starting to do some cleanup to the BusLogic SCSI driver.
Since I'm a rank-newbie at anything SCSI, I thought I'd post a snap-shot
of where I am, and solicity direction and comments from the experts...

Please review and comment.

This patch is against linux-2.6.1-rc1.  It works for me but the normal
caveats apply.  Consider it a work-in-progress.

Deleted dead code:
- BusLogic_ReportTargetDeviceInfo()
- BusLogic_SelectQueueDepths()
- BusLogic_SendBusDeviceReset()
- BusLogic_ResetCommand()

Fixed:
- removed dependancy on "scsi_obsolete.h"
  o Changes to BusLogic_ResetHostAdapter()
  o Changes to BusLogic_AbortCommand()
- changed the device initialization to use module_init() and removed
 'scsi_module.c' code.

Left to do:
- Test eh_abort_handler
- Test eh_host_reset_handler
- I haven't compiled as a moduled and tried to unload the module.
- I'd really really like to run the code through 'indent' to match the
  kernel coding standards but for now I don't want to confuse formatting
  changes with code changes.  It is very difficult to read as it is
  currently formatted.

So - now the questions...

How do I test the eh_* handler functions?  I've tried everything
I can think of to provoke them but haven't managed to.  For now,
I don't know if they work or not.

Is it worth the trouble to make the device reset and bus reset
handlers work?  It looks like many drivers don't bother to implement
them.

Also I clearly don't understand the command completion in the
context the error handlers.  Do the eh_* functions need to
do command completion?

Does anyone understand what the 'reset_chain' linked list
that is commented out did and/or should do?  I read in some
archive that it was BusLogic specific but it did not elaborate.
Does it need to be re-implemented?

Lastly, does someone have the BusLogic docs anymore?  The code
is fairly well documented but still it would be nice to have
the docs.

Thanks in advance,

Bob.
--------------7071404970DB7F41ED5C1832
Content-Type: text/plain; charset=us-ascii;
 name="BusLogic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="BusLogic.patch"

diff -Nru linux-2.6.1-rc1/drivers/scsi/BusLogic.c linux-2.6.1-rc1-scsi-dorking/drivers/scsi/BusLogic.c
--- linux-2.6.1-rc1/drivers/scsi/BusLogic.c	Wed Dec 31 22:28:06 2003
+++ linux-2.6.1-rc1-scsi-dorking/drivers/scsi/BusLogic.c	Thu Jan  1 22:45:41 2004
@@ -26,7 +26,6 @@
 
 */
 
-
 #define BusLogic_DriverVersion		"2.1.16"
 #define BusLogic_DriverDate		"18 July 2002"
 
@@ -42,7 +41,6 @@
 #include <linux/stat.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
-/* #include <scsi/scsicam.h> This include file is currently busted */
 
 #include <asm/dma.h>
 #include <asm/io.h>
@@ -2598,84 +2596,6 @@
   return true;
 }
 
-
-/*
-  BusLogic_ReportTargetDeviceInfo reports about the Target Devices accessible
-  through Host Adapter.
-*/
-
-/*static void BusLogic_ReportTargetDeviceInfo(BusLogic_HostAdapter_T
-					    *HostAdapter)
-{
-  int TargetID;
-*/  /*
-    Inhibit the Target Device Inquiry and Reporting if requested.
-  */
-/*  if (BusLogic_MultiMasterHostAdapterP(HostAdapter) &&
-      HostAdapter->DriverOptions != NULL &&
-      HostAdapter->DriverOptions->LocalOptions.InhibitTargetInquiry)
-    return;
-*/  /*
-    Report on the Target Devices found.
-  */
-/*  for (TargetID = 0; TargetID < HostAdapter->MaxTargetDevices; TargetID++)
-    {
-      BusLogic_TargetFlags_T *TargetFlags = &HostAdapter->TargetFlags[TargetID];
-      if (TargetFlags->TargetExists && !TargetFlags->TargetInfoReported)
-	{
-	  int SynchronousTransferRate = 0;
-	  if (BusLogic_FlashPointHostAdapterP(HostAdapter))
-	    {
-	      unsigned char WideTransfersActive;
-	      FlashPoint_InquireTargetInfo(
-		HostAdapter->CardHandle, TargetID,
-		&HostAdapter->SynchronousPeriod[TargetID],
-		&HostAdapter->SynchronousOffset[TargetID],
-		&WideTransfersActive);
-	      TargetFlags->WideTransfersActive = WideTransfersActive;
-	    }
-	  else if (TargetFlags->WideTransfersSupported &&
-		   (HostAdapter->WidePermitted & (1 << TargetID)) &&
-		   strcmp(HostAdapter->FirmwareVersion, "5.06L") < 0)
-	    TargetFlags->WideTransfersActive = true;
-	  if (HostAdapter->SynchronousPeriod[TargetID] > 0)
-	    SynchronousTransferRate =
-	      100000 / HostAdapter->SynchronousPeriod[TargetID];
-	  if (TargetFlags->WideTransfersActive)
-	    SynchronousTransferRate <<= 1;
-	  if (SynchronousTransferRate >= 9950)
-	    {
-	      SynchronousTransferRate = (SynchronousTransferRate + 50) / 100;
-	      BusLogic_Info("Target %d: Queue Depth %d, %sSynchronous at "
-			    "%d.%01d MB/sec, offset %d\n",
-			    HostAdapter, TargetID,
-			    HostAdapter->QueueDepth[TargetID],
-			    (TargetFlags->WideTransfersActive ? "Wide " : ""),
-			    SynchronousTransferRate / 10,
-			    SynchronousTransferRate % 10,
-			    HostAdapter->SynchronousOffset[TargetID]);
-	    }
-	  else if (SynchronousTransferRate > 0)
-	    {
-	      SynchronousTransferRate = (SynchronousTransferRate + 5) / 10;
-	      BusLogic_Info("Target %d: Queue Depth %d, %sSynchronous at "
-			    "%d.%02d MB/sec, offset %d\n",
-			    HostAdapter, TargetID,
-			    HostAdapter->QueueDepth[TargetID],
-			    (TargetFlags->WideTransfersActive ? "Wide " : ""),
-			    SynchronousTransferRate / 100,
-			    SynchronousTransferRate % 100,
-			    HostAdapter->SynchronousOffset[TargetID]);
-	    }
-	  else BusLogic_Info("Target %d: Queue Depth %d, Asynchronous\n",
-			     HostAdapter, TargetID,
-			     HostAdapter->QueueDepth[TargetID]);
-	  TargetFlags->TargetInfoReported = true;
-	}
-    }
-}
-*/
-
 /*
   BusLogic_InitializeHostStructure initializes the fields in the SCSI Host
   structure.  The base, io_port, n_io_ports, irq, and dma_channel fields in the
@@ -2745,85 +2665,6 @@
 }
 
 /*
-  BusLogic_SelectQueueDepths selects Queue Depths for each Target Device based
-  on the Host Adapter's Total Queue Depth and the number, type, speed, and
-  capabilities of the Target Devices.  When called for the last Host Adapter,
-  it reports on the Target Device Information for all BusLogic Host Adapters
-  since all the Target Devices have now been probed.
-*/
-
-/* static void BusLogic_SelectQueueDepths(SCSI_Host_T *Host,
-				       SCSI_Device_T *DeviceList)
-{
-  BusLogic_HostAdapter_T *HostAdapter =
-    (BusLogic_HostAdapter_T *) Host->hostdata;
-  int TaggedDeviceCount = 0, AutomaticTaggedDeviceCount = 0;
-  int UntaggedDeviceCount = 0, AutomaticTaggedQueueDepth = 0;
-  int AllocatedQueueDepth = 0;
-  SCSI_Device_T *Device;
-  int TargetID;
-  for (TargetID = 0; TargetID < HostAdapter->MaxTargetDevices; TargetID++)
-    if (HostAdapter->TargetFlags[TargetID].TargetExists)
-      {
-	int QueueDepth = HostAdapter->QueueDepth[TargetID];
-	if (HostAdapter->TargetFlags[TargetID].TaggedQueuingSupported &&
-	    (HostAdapter->TaggedQueuingPermitted & (1 << TargetID)))
-	  {
-	    TaggedDeviceCount++;
-	    if (QueueDepth == 0) AutomaticTaggedDeviceCount++;
-	  }
-	else
-	  {
-	    UntaggedDeviceCount++;
-	    if (QueueDepth == 0 ||
-		QueueDepth > HostAdapter->UntaggedQueueDepth)
-	      {
-		QueueDepth = HostAdapter->UntaggedQueueDepth;
-		HostAdapter->QueueDepth[TargetID] = QueueDepth;
-	      }
-	  }
-	AllocatedQueueDepth += QueueDepth;
-	if (QueueDepth == 1)
-	  HostAdapter->TaggedQueuingPermitted &= ~(1 << TargetID);
-      }
-  HostAdapter->TargetDeviceCount = TaggedDeviceCount + UntaggedDeviceCount;
-  if (AutomaticTaggedDeviceCount > 0)
-    {
-      AutomaticTaggedQueueDepth =
-	(HostAdapter->HostAdapterQueueDepth - AllocatedQueueDepth)
-	/ AutomaticTaggedDeviceCount;
-      if (AutomaticTaggedQueueDepth > BusLogic_MaxAutomaticTaggedQueueDepth)
-	AutomaticTaggedQueueDepth = BusLogic_MaxAutomaticTaggedQueueDepth;
-      if (AutomaticTaggedQueueDepth < BusLogic_MinAutomaticTaggedQueueDepth)
-	AutomaticTaggedQueueDepth = BusLogic_MinAutomaticTaggedQueueDepth;
-      for (TargetID = 0; TargetID < HostAdapter->MaxTargetDevices; TargetID++)
-	if (HostAdapter->TargetFlags[TargetID].TargetExists &&
-	    HostAdapter->QueueDepth[TargetID] == 0)
-	  {
-	    AllocatedQueueDepth += AutomaticTaggedQueueDepth;
-	    HostAdapter->QueueDepth[TargetID] = AutomaticTaggedQueueDepth;
-	  }
-    }
-  for (Device = DeviceList; Device != NULL; Device = Device->next)
-    if (Device->host == Host)
-      Device->queue_depth = HostAdapter->QueueDepth[Device->id];
-*/  /* Allocate an extra CCB for each Target Device for a Bus Device Reset. */
-/*  AllocatedQueueDepth += HostAdapter->TargetDeviceCount;
-  if (AllocatedQueueDepth > HostAdapter->DriverQueueDepth)
-    AllocatedQueueDepth = HostAdapter->DriverQueueDepth;
-  BusLogic_CreateAdditionalCCBs(HostAdapter,
-				AllocatedQueueDepth
-				- HostAdapter->AllocatedCCBs,
-				false);
-  if (HostAdapter == BusLogic_LastRegisteredHostAdapter)
-    for (HostAdapter = BusLogic_FirstRegisteredHostAdapter;
-	 HostAdapter != NULL;
-	 HostAdapter = HostAdapter->Next)
-      BusLogic_ReportTargetDeviceInfo(HostAdapter);
-}
-*/
-
-/*
   BusLogic_DetectHostAdapter probes for BusLogic Host Adapters at the standard
   I/O Addresses where they may be located, initializing, registering, and
   reporting the configuration of each BusLogic Host Adapter it finds.  It
@@ -2914,7 +2755,8 @@
       /*
 	Register the SCSI Host structure.
       */
-      Host = scsi_register(HostTemplate, sizeof(BusLogic_HostAdapter_T));
+
+      Host = scsi_host_alloc(HostTemplate, sizeof(BusLogic_HostAdapter_T));
       if(Host==NULL)
       {
       	release_region(HostAdapter->IO_Address, HostAdapter->AddressCount);
@@ -2925,10 +2767,6 @@
       HostAdapter->SCSI_Host = Host;
       HostAdapter->HostNumber = Host->host_no;
       /*
-       * This function is deprecated
-      Host->select_queue_depths = BusLogic_SelectQueueDepths;
-       */
-      /*
 	Add Host Adapter to the end of the list of registered BusLogic
 	Host Adapters.
       */
@@ -2963,10 +2801,12 @@
 		  BusLogic_DestroyCCBs(HostAdapter);
 		  BusLogic_ReleaseResources(HostAdapter);
 		  BusLogic_UnregisterHostAdapter(HostAdapter);
-		  scsi_unregister(Host);
+		  scsi_host_put(Host);
 	  }
 	  else {
 		  BusLogic_InitializeHostStructure(HostAdapter, Host);
+	          scsi_add_host(Host, NULL);
+	          scsi_scan_host(Host);
 		  BusLogicHostAdapterCount++;
 	  }
 	}
@@ -2983,7 +2823,7 @@
 	  BusLogic_DestroyCCBs(HostAdapter);
 	  BusLogic_ReleaseResources(HostAdapter);
 	  BusLogic_UnregisterHostAdapter(HostAdapter);
-	  scsi_unregister(Host);
+	  scsi_host_put(Host);
 	}
     }
   kfree(PrototypeHostAdapter);
@@ -3409,11 +3249,20 @@
   /*
     Reset the Host Adapter if requested.
   */
-  if (HostAdapter->HostAdapterExternalReset ||
-      HostAdapter->HostAdapterInternalError)
+  if (HostAdapter->HostAdapterExternalReset)
     {
-      BusLogic_ResetHostAdapter(HostAdapter, NULL, 0);
+      BusLogic_Warning("Resetting %s due to External SCSI Bus Reset\n",
+		       HostAdapter, HostAdapter->FullModelName);
+      BusLogic_IncrementErrorCounter(&HostAdapter->ExternalHostAdapterResets);
+      BusLogic_ResetHostAdapter(HostAdapter, false);
       HostAdapter->HostAdapterExternalReset = false;
+    }
+  else if (HostAdapter->HostAdapterInternalError)
+    {
+      BusLogic_Warning("Resetting %s due to Host Adapter Internal Error\n",
+		       HostAdapter, HostAdapter->FullModelName);
+      BusLogic_IncrementErrorCounter(&HostAdapter->HostAdapterInternalErrors);
+      BusLogic_ResetHostAdapter(HostAdapter, true);
       HostAdapter->HostAdapterInternalError = false;
     }
   /*
@@ -3469,10 +3318,11 @@
 	BusLogic_HostAdapter_T *HostAdapter =
 		(BusLogic_HostAdapter_T *) SCpnt->device->host->hostdata;
 
-	/* printk("BusLogic_host_reset\n"); */
-	HostAdapter->HostAdapterExternalReset = 1;
-	BusLogic_ResetHostAdapter(HostAdapter, NULL, 0);
-	return SUCCESS;
+	unsigned int id = SCpnt->device->id;
+	BusLogic_TargetStatistics_T *stats = &HostAdapter->TargetStatistics[id];
+	BusLogic_IncrementErrorCounter(&stats->HostAdapterResetsRequested);
+
+	return BusLogic_ResetHostAdapter(HostAdapter, false);
 }
 
 /*
@@ -3725,7 +3575,6 @@
 
   int TargetID = Command->device->id;
   BusLogic_CCB_T *CCB;
-  int Result;
   BusLogic_IncrementErrorCounter(
     &HostAdapter->TargetStatistics[TargetID].CommandAbortsRequested);
   /*
@@ -3735,7 +3584,7 @@
     {
       BusLogic_Warning("Unable to Abort Command to Target %d - "
 		       "Already Completed\n", HostAdapter, TargetID);
-      return SCSI_ABORT_NOT_RUNNING;
+      return SUCCESS;
     }
   /*
     Attempt to find an Active CCB for this Command.  If no Active CCB for this
@@ -3747,19 +3596,19 @@
     {
       BusLogic_Warning("Unable to Abort Command to Target %d - "
 		       "No CCB Found\n", HostAdapter, TargetID);
-      return SCSI_ABORT_NOT_RUNNING;
+      return SUCCESS;
     }
   else if (CCB->Status == BusLogic_CCB_Completed)
     {
       BusLogic_Warning("Unable to Abort Command to Target %d - "
 		       "CCB Completed\n", HostAdapter, TargetID);
-      return SCSI_ABORT_NOT_RUNNING;
+      return SUCCESS;
     }
   else if (CCB->Status == BusLogic_CCB_Reset)
     {
       BusLogic_Warning("Unable to Abort Command to Target %d - "
 		       "CCB Reset\n", HostAdapter, TargetID);
-      return SCSI_ABORT_PENDING;
+      return SUCCESS;
     }
   if (BusLogic_MultiMasterHostAdapterP(HostAdapter))
     {
@@ -3779,7 +3628,7 @@
 	  BusLogic_Warning("Unable to Abort CCB #%ld to Target %d - "
 			   "Abort Tag Not Supported\n",
 			   HostAdapter, CCB->SerialNumber, TargetID);
-	  Result = SCSI_ABORT_SNOOZE;
+	  return FAILURE;
 	}
       else if (BusLogic_WriteOutgoingMailbox(
 		 HostAdapter, BusLogic_MailboxAbortCommand, CCB))
@@ -3788,14 +3637,14 @@
 			   HostAdapter, CCB->SerialNumber, TargetID);
 	  BusLogic_IncrementErrorCounter(
 	    &HostAdapter->TargetStatistics[TargetID].CommandAbortsAttempted);
-	  Result = SCSI_ABORT_PENDING;
+	  return SUCCESS;
 	}
       else
 	{
 	  BusLogic_Warning("Unable to Abort CCB #%ld to Target %d - "
 			   "No Outgoing Mailboxes\n",
 			    HostAdapter, CCB->SerialNumber, TargetID);
-	  Result = SCSI_ABORT_BUSY;
+	  return FAILURE;
 	}
     }
   else
@@ -3813,413 +3662,63 @@
 	BusLogic_QueueCompletedCCB been called, or it
 	may still be pending.
       */
-      Result = SCSI_ABORT_PENDING;
       if (CCB->Status == BusLogic_CCB_Completed)
 	{
 	  BusLogic_ProcessCompletedCCBs(HostAdapter);
-	  Result = SCSI_ABORT_SUCCESS;
 	}
+      return SUCCESS;
     }
-  return Result;
+  return SUCCESS;
 }
 
-
 /*
   BusLogic_ResetHostAdapter resets Host Adapter if possible, marking all
   currently executing SCSI Commands as having been Reset.
 */
 
 static int BusLogic_ResetHostAdapter(BusLogic_HostAdapter_T *HostAdapter,
-				     SCSI_Command_T *Command,
-				     unsigned int ResetFlags)
+				     boolean HardReset)
 {
-  BusLogic_CCB_T *CCB;
-  int TargetID, Result;
-  boolean HardReset;
-  if (HostAdapter->HostAdapterExternalReset)
-    {
-      BusLogic_IncrementErrorCounter(&HostAdapter->ExternalHostAdapterResets);
-      HardReset = false;
-    }
-  else if (HostAdapter->HostAdapterInternalError)
-    {
-      BusLogic_IncrementErrorCounter(&HostAdapter->HostAdapterInternalErrors);
-      HardReset = true;
-    }
-  else
-    {
-      BusLogic_IncrementErrorCounter(
-	&HostAdapter->TargetStatistics[Command->device->id]
-		      .HostAdapterResetsRequested);
-      HardReset = true;
-    }
-  /*
-    If this is an Asynchronous Reset and this Command has already completed,
-    then no Reset is necessary.
-  */
-  if (ResetFlags & SCSI_RESET_ASYNCHRONOUS)
-    {
-      TargetID = Command->device->id;
-      if (Command->serial_number != Command->serial_number_at_timeout)
-	{
-	  BusLogic_Warning("Unable to Reset Command to Target %d - "
-			   "Already Completed or Reset\n",
-			   HostAdapter, TargetID);
-	  Result = SCSI_RESET_NOT_RUNNING;
-	  goto Done;
-      }
-      for (CCB = HostAdapter->All_CCBs; CCB != NULL; CCB = CCB->NextAll)
-	if (CCB->Command == Command) break;
-      if (CCB == NULL)
-	{
-	  BusLogic_Warning("Unable to Reset Command to Target %d - "
-			   "No CCB Found\n", HostAdapter, TargetID);
-	  Result = SCSI_RESET_NOT_RUNNING;
-	  goto Done;
-	}
-      else if (CCB->Status == BusLogic_CCB_Completed)
-	{
-	  BusLogic_Warning("Unable to Reset Command to Target %d - "
-			   "CCB Completed\n", HostAdapter, TargetID);
-	  Result = SCSI_RESET_NOT_RUNNING;
-	  goto Done;
-	}
-      else if (CCB->Status == BusLogic_CCB_Reset &&
-	       HostAdapter->BusDeviceResetPendingCCB[TargetID] == NULL)
-	{
-	  BusLogic_Warning("Unable to Reset Command to Target %d - "
-			   "Reset Pending\n", HostAdapter, TargetID);
-	  Result = SCSI_RESET_PENDING;
-	  goto Done;
-	}
-    }
-  if (Command == NULL)
-    {
-      if (HostAdapter->HostAdapterInternalError)
-	BusLogic_Warning("Resetting %s due to Host Adapter Internal Error\n",
-			 HostAdapter, HostAdapter->FullModelName);
-      else BusLogic_Warning("Resetting %s due to External SCSI Bus Reset\n",
-			    HostAdapter, HostAdapter->FullModelName);
-    }
-  else
-    {
-      BusLogic_Warning("Resetting %s due to Target %d\n", HostAdapter,
-		       HostAdapter->FullModelName, Command->device->id);
-      BusLogic_IncrementErrorCounter(
-	&HostAdapter->TargetStatistics[Command->device->id]
-		      .HostAdapterResetsAttempted);
-    }
-  /*
-    Attempt to Reset and Reinitialize the Host Adapter.
-  */
-  if (!(BusLogic_HardwareResetHostAdapter(HostAdapter, HardReset) &&
-	BusLogic_InitializeHostAdapter(HostAdapter)))
-    {
-      BusLogic_Error("Resetting %s Failed\n", HostAdapter,
-		     HostAdapter->FullModelName);
-      Result = SCSI_RESET_ERROR;
-      goto Done;
-    }
-  if (Command != NULL)
-    BusLogic_IncrementErrorCounter(
-      &HostAdapter->TargetStatistics[Command->device->id]
-		    .HostAdapterResetsCompleted);
-  /*
-    Mark all currently executing CCBs as having been Reset.
-  */
-  for (CCB = HostAdapter->All_CCBs; CCB != NULL; CCB = CCB->NextAll)
-    if (CCB->Status == BusLogic_CCB_Active)
-      CCB->Status = BusLogic_CCB_Reset;
-  /*
-    Wait a few seconds between the Host Adapter Hard Reset which initiates
-    a SCSI Bus Reset and issuing any SCSI Commands.  Some SCSI devices get
-    confused if they receive SCSI Commands too soon after a SCSI Bus Reset.
-    Note that a timer interrupt may occur here, but all active CCBs have
-    already been marked Reset and so a reentrant call will return Pending.
-  */
-  if (HardReset)
-    {
-      BusLogic_ReleaseHostAdapterLock(HostAdapter);
-      BusLogic_Delay(HostAdapter->BusSettleTime);
-      BusLogic_AcquireHostAdapterLock(HostAdapter);
-    }
-  /*
-    If this is a Synchronous Reset, perform completion processing for
-    the Command being Reset.
-  */
-  if (ResetFlags & SCSI_RESET_SYNCHRONOUS)
-    {
-      Command->result = DID_RESET << 16;
-      Command->scsi_done(Command);
-    }
-  /*
-    Perform completion processing for all CCBs marked as Reset.
-  */
-  for (CCB = HostAdapter->All_CCBs; CCB != NULL; CCB = CCB->NextAll)
-    if (CCB->Status == BusLogic_CCB_Reset)
-      {
-	Command = CCB->Command;
-	BusLogic_DeallocateCCB(CCB);
-#if 0	/* this needs to be redone different for new EH */
-	while (Command != NULL)
-	  {
-	    SCSI_Command_T *NextCommand = Command->reset_chain;
-	    Command->reset_chain = NULL;
-	    Command->result = DID_RESET << 16;
-	    Command->scsi_done(Command);
-	    Command = NextCommand;
-	  }
-#endif
-      }
-  for (TargetID = 0; TargetID < HostAdapter->MaxTargetDevices; TargetID++)
-    {
-      HostAdapter->LastResetAttempted[TargetID] = jiffies;
-      HostAdapter->LastResetCompleted[TargetID] = jiffies;
-    }
-  Result = SCSI_RESET_SUCCESS | SCSI_RESET_HOST_RESET;
-Done:
-  return Result;
-}
-
-#if 0	/* old-style EH code references a dead struct scsi_cmnd member */
-/*
-  BusLogic_SendBusDeviceReset sends a Bus Device Reset to the Target
-  Device associated with Command.
-*/
+	BusLogic_CCB_T *CCB;
+	int TargetID;
 
-static int BusLogic_SendBusDeviceReset(BusLogic_HostAdapter_T *HostAdapter,
-				       SCSI_Command_T *Command,
-				       unsigned int ResetFlags)
-{
-  int TargetID = Command->device->id;
-  BusLogic_CCB_T *CCB, *XCCB;
-  int Result = -1;
-  BusLogic_IncrementErrorCounter(
-    &HostAdapter->TargetStatistics[TargetID].BusDeviceResetsRequested);
-  /*
-    If this is an Asynchronous Reset and this Command has already completed,
-    then no Reset is necessary.
-  */
-  if (ResetFlags & SCSI_RESET_ASYNCHRONOUS)
-    {
-      if (Command->serial_number != Command->serial_number_at_timeout)
-	{
-	  BusLogic_Warning("Unable to Reset Command to Target %d - "
-			   "Already Completed\n", HostAdapter, TargetID);
-	  Result = SCSI_RESET_NOT_RUNNING;
-	  goto Done;
-	}
-      for (CCB = HostAdapter->All_CCBs; CCB != NULL; CCB = CCB->NextAll)
-	if (CCB->Command == Command) break;
-      if (CCB == NULL)
-	{
-	  BusLogic_Warning("Unable to Reset Command to Target %d - "
-			   "No CCB Found\n", HostAdapter, TargetID);
-	  Result = SCSI_RESET_NOT_RUNNING;
-	  goto Done;
-	}
-      else if (CCB->Status == BusLogic_CCB_Completed)
-	{
-	  BusLogic_Warning("Unable to Reset Command to Target %d - "
-			   "CCB Completed\n", HostAdapter, TargetID);
-	  Result = SCSI_RESET_NOT_RUNNING;
-	  goto Done;
-	}
-      else if (CCB->Status == BusLogic_CCB_Reset)
-	{
-	  BusLogic_Warning("Unable to Reset Command to Target %d - "
-			   "Reset Pending\n", HostAdapter, TargetID);
-	  Result = SCSI_RESET_PENDING;
-	  goto Done;
-	}
-      else if (HostAdapter->BusDeviceResetPendingCCB[TargetID] != NULL)
-	{
-	  BusLogic_Warning("Bus Device Reset already pending to Target %d\n",
-			   HostAdapter, TargetID);
-	  goto Done;
-	}
-    }
-  /*
-    If this is a Synchronous Reset and a Bus Device Reset is already pending
-    for this Target Device, do not send a second one.  Add this Command to
-    the list of Commands for which completion processing must be performed
-    when the Bus Device Reset CCB completes.
-  */
-  if (ResetFlags & SCSI_RESET_SYNCHRONOUS)
-    if ((CCB = HostAdapter->BusDeviceResetPendingCCB[TargetID]) != NULL)
-      {
-	Command->reset_chain = CCB->Command;
-	CCB->Command = Command;
-	BusLogic_Warning("Unable to Reset Command to Target %d - "
-			 "Reset Pending\n", HostAdapter, TargetID);
-	Result = SCSI_RESET_PENDING;
-	goto Done;
-      }
-  if (BusLogic_MultiMasterHostAdapterP(HostAdapter))
-    {
-      /*
-	MultiMaster Firmware versions prior to 5.xx treat a Bus Device Reset as
-	a non-tagged command.  Since non-tagged commands are not sent by the
-	Host Adapter until the queue of outstanding tagged commands has
-	completed, it is effectively impossible to send a Bus Device Reset
-	while there are tagged commands outstanding.  Therefore, in that case a
-	full Host Adapter Hard Reset and SCSI Bus Reset must be done.
-      */
-      if (HostAdapter->TargetFlags[TargetID].TaggedQueuingActive &&
-	  HostAdapter->ActiveCommands[TargetID] > 0 &&
-	  HostAdapter->FirmwareVersion[0] < '5')
-	goto Done;
-    }
-  /*
-    Allocate a CCB from the Host Adapter's free list.  In the unlikely event
-    that there are none available and memory allocation fails, attempt a full
-    Host Adapter Hard Reset and SCSI Bus Reset.
-  */
-  CCB = BusLogic_AllocateCCB(HostAdapter);
-  if (CCB == NULL) goto Done;
-  BusLogic_Warning("Sending Bus Device Reset CCB #%ld to Target %d\n",
-		   HostAdapter, CCB->SerialNumber, TargetID);
-  CCB->Opcode = BusLogic_BusDeviceReset;
-  CCB->TargetID = TargetID;
-  /*
-    For Synchronous Resets, arrange for the interrupt handler to perform
-    completion processing for the Command being Reset.
-  */
-  if (ResetFlags & SCSI_RESET_SYNCHRONOUS)
-    {
-      Command->reset_chain = NULL;
-      CCB->Command = Command;
-    }
-  if (BusLogic_MultiMasterHostAdapterP(HostAdapter))
-    {
-      /*
-	Attempt to write an Outgoing Mailbox with the Bus Device Reset CCB.
-	If sending a Bus Device Reset is impossible, attempt a full Host
-	Adapter Hard Reset and SCSI Bus Reset.
-      */
-      if (!(BusLogic_WriteOutgoingMailbox(
-	      HostAdapter, BusLogic_MailboxStartCommand, CCB)))
-	{
-	  BusLogic_Warning("Unable to write Outgoing Mailbox for "
-			   "Bus Device Reset\n", HostAdapter);
-	  BusLogic_DeallocateCCB(CCB);
-	  goto Done;
+	/*
+	 * Attempt to Reset and Reinitialize the Host Adapter.
+	 */
+
+	if (!(BusLogic_HardwareResetHostAdapter(HostAdapter, HardReset) &&
+		BusLogic_InitializeHostAdapter(HostAdapter))) {
+		BusLogic_Error("Resetting %s Failed\n", HostAdapter,
+			       HostAdapter->FullModelName);
+		return FAILURE;
+	}
+
+	/*
+	 * Deallocate all currently executing CCBs.
+	 */
+
+	for (CCB = HostAdapter->All_CCBs; CCB != NULL; CCB = CCB->NextAll)
+		if (CCB->Status == BusLogic_CCB_Active)
+			BusLogic_DeallocateCCB(CCB);
+	/*
+	 * Wait a few seconds between the Host Adapter Hard Reset which
+	 * initiates a SCSI Bus Reset and issuing any SCSI Commands.  Some
+	 * SCSI devices get confused if they receive SCSI Commands too soon
+	 * after a SCSI Bus Reset.
+	 */
+
+	if (HardReset) {
+		BusLogic_ReleaseHostAdapterLock(HostAdapter);
+		BusLogic_Delay(HostAdapter->BusSettleTime);
+		BusLogic_AcquireHostAdapterLock(HostAdapter);
+	}
+
+	for (TargetID = 0; TargetID < HostAdapter->MaxTargetDevices; TargetID++) {
+		HostAdapter->LastResetAttempted[TargetID] = jiffies;
+		HostAdapter->LastResetCompleted[TargetID] = jiffies;
 	}
-    }
-  else
-    {
-      /*
-	Call the FlashPoint SCCB Manager to start execution of the CCB.
-      */
-      CCB->Status = BusLogic_CCB_Active;
-      HostAdapter->ActiveCommands[TargetID]++;
-      FlashPoint_StartCCB(HostAdapter->CardHandle, CCB);
-    }
-  /*
-    If there is a currently executing CCB in the Host Adapter for this Command
-    (i.e. this is an Asynchronous Reset), then an Incoming Mailbox entry may be
-    made with a completion code of BusLogic_HostAdapterAssertedBusDeviceReset.
-    If there is no active CCB for this Command (i.e. this is a Synchronous
-    Reset), then the Bus Device Reset CCB's Command field will have been set
-    to the Command so that the interrupt for the completion of the Bus Device
-    Reset can call the Completion Routine for the Command.  On successful
-    execution of a Bus Device Reset, older firmware versions did return the
-    pending CCBs with the appropriate completion code, but more recent firmware
-    versions only return the Bus Device Reset CCB itself.  This driver handles
-    both cases by marking all the currently executing CCBs to this Target
-    Device as Reset.  When the Bus Device Reset CCB is processed by the
-    interrupt handler, any remaining CCBs marked as Reset will have completion
-    processing performed.
-  */
-  BusLogic_IncrementErrorCounter(
-    &HostAdapter->TargetStatistics[TargetID].BusDeviceResetsAttempted);
-  HostAdapter->BusDeviceResetPendingCCB[TargetID] = CCB;
-  HostAdapter->LastResetAttempted[TargetID] = jiffies;
-  for (XCCB = HostAdapter->All_CCBs; XCCB != NULL; XCCB = XCCB->NextAll)
-    if (XCCB->Status == BusLogic_CCB_Active && XCCB->TargetID == TargetID)
-      XCCB->Status = BusLogic_CCB_Reset;
-  /*
-    FlashPoint Host Adapters may have already completed the Bus Device
-    Reset and BusLogic_QueueCompletedCCB been called, or it may still be
-    pending.
-  */
-  Result = SCSI_RESET_PENDING;
-  if (BusLogic_FlashPointHostAdapterP(HostAdapter))
-    if (CCB->Status == BusLogic_CCB_Completed)
-      {
-	BusLogic_ProcessCompletedCCBs(HostAdapter);
-	Result = SCSI_RESET_SUCCESS;
-      }
-  /*
-    If a Bus Device Reset was not possible for some reason, force a full
-    Host Adapter Hard Reset and SCSI Bus Reset.
-  */
-Done:
-  if (Result < 0)
-    Result = BusLogic_ResetHostAdapter(HostAdapter, Command, ResetFlags);
-  return Result;
-}
-
-
-/*
-  BusLogic_ResetCommand takes appropriate action to reset Command.
-*/
-
-int BusLogic_ResetCommand(SCSI_Command_T *Command, unsigned int ResetFlags)
-{
-  BusLogic_HostAdapter_T *HostAdapter =
-    (BusLogic_HostAdapter_T *) Command->device->host->hostdata;
-  int TargetID = Command->device->id;
-  BusLogic_ErrorRecoveryStrategy_T
-    ErrorRecoveryStrategy = HostAdapter->ErrorRecoveryStrategy[TargetID];
-  /*
-    Disable Tagged Queuing if it is active for this Target Device and if
-    it has been less than 10 minutes since the last reset occurred, or since
-    the system was initialized if no prior resets have occurred.
-  */
-  if (HostAdapter->TargetFlags[TargetID].TaggedQueuingActive &&
-      jiffies - HostAdapter->LastResetCompleted[TargetID] < 10*60*HZ)
-    {
-      HostAdapter->TaggedQueuingPermitted &= ~(1 << TargetID);
-      HostAdapter->TargetFlags[TargetID].TaggedQueuingActive = false;
-      BusLogic_Warning("Tagged Queuing now disabled for Target %d\n",
-		       HostAdapter, TargetID);
-    }
-  switch (ErrorRecoveryStrategy)
-    {
-    case BusLogic_ErrorRecovery_Default:
-      if (ResetFlags & SCSI_RESET_SUGGEST_HOST_RESET)
-	return BusLogic_ResetHostAdapter(HostAdapter, Command, ResetFlags);
-      else if (ResetFlags & SCSI_RESET_SUGGEST_BUS_RESET)
-	return BusLogic_ResetHostAdapter(HostAdapter, Command, ResetFlags);
-      /* Fall through to Bus Device Reset case. */
-    case BusLogic_ErrorRecovery_BusDeviceReset:
-      /*
-	The Bus Device Reset Error Recovery Strategy only graduates to a Hard
-	Reset when no commands have completed successfully since the last Bus
-	Device Reset and it has been at least 100 milliseconds.  This prevents
-	a sequence of commands that all timeout together from immediately
-	forcing a Hard Reset before the Bus Device Reset has had a chance to
-	clear the error condition.
-      */
-      if (HostAdapter->TargetFlags[TargetID].CommandSuccessfulFlag ||
-	  jiffies - HostAdapter->LastResetAttempted[TargetID] < HZ/10)
-	{
-	  HostAdapter->TargetFlags[TargetID].CommandSuccessfulFlag = false;
-	  return BusLogic_SendBusDeviceReset(HostAdapter, Command, ResetFlags);
-	}
-      /* Fall through to Hard Reset case. */
-    case BusLogic_ErrorRecovery_HardReset:
-      return BusLogic_ResetHostAdapter(HostAdapter, Command, ResetFlags);
-    case BusLogic_ErrorRecovery_None:
-      BusLogic_Warning("Error Recovery for Target %d Suppressed\n",
-		       HostAdapter, TargetID);
-      break;
-    }
-  return SCSI_RESET_PUNT;
+	return SUCCESS;
 }
-#endif
-
 
 /*
   BusLogic_BIOSDiskParameters returns the Heads/Sectors/Cylinders BIOS Disk
@@ -4887,13 +4386,34 @@
     return 1;
 }
 
+/*
+  Get it all started
+*/
+MODULE_LICENSE("GPL");
+
+static SCSI_Host_Template_T driver_template = {
+	.module			= THIS_MODULE,
+	.proc_name		= "BusLogic",
+	.proc_info		= BusLogic_ProcDirectoryInfo,
+	.name			= "BusLogic",
+	.info			= BusLogic_DriverInfo,
+	.queuecommand		= BusLogic_QueueCommand,
+	.slave_configure	= BusLogic_SlaveConfigure,
+	.bios_param		= BusLogic_BIOSDiskParameters,
+	.eh_host_reset_handler	= BusLogic_host_reset,
+#if 0
+	.eh_abort_handler	= BusLogic_AbortCommand,
+#endif
+	.unchecked_isa_dma	= 1,
+	.max_sectors		= 128,
+	.use_clustering		= ENABLE_CLUSTERING,
+};
 
 /*
   BusLogic_Setup handles processing of Kernel Command Line Arguments.
 */
 
-static int __init 
-BusLogic_Setup(char *str)
+static int __init BusLogic_Setup(char *str)
 {
 	int ints[3];
 
@@ -4909,27 +4429,41 @@
 	return BusLogic_ParseDriverOptions(str);
 }
 
-__setup("BusLogic=", BusLogic_Setup);
+/*
+ * Initialization function
+ */
+
+static int __init BusLogic_init(void) {
+
+#ifdef MODULE
+	if (BusLogic)
+		BusLogic_Setup(BusLogic);
+#endif
+	 
+	return BusLogic_DetectHostAdapter(&driver_template) ? 0 : -ENODEV;
+}
 
 /*
-  Get it all started
-*/
-MODULE_LICENSE("GPL");
+ * Exit function.  Deletes all hosts associated with this driver.
+ */
 
-static SCSI_Host_Template_T driver_template = {
-	.proc_name		= "BusLogic",
-	.proc_info		= BusLogic_ProcDirectoryInfo,
-	.name			= "BusLogic",
-	.detect			= BusLogic_DetectHostAdapter,
-	.release		= BusLogic_ReleaseHostAdapter,
-	.info			= BusLogic_DriverInfo,
-	.queuecommand		= BusLogic_QueueCommand,
-	.slave_configure	= BusLogic_SlaveConfigure,
-	.bios_param		= BusLogic_BIOSDiskParameters,
-	.eh_host_reset_handler	= BusLogic_host_reset,
-	.unchecked_isa_dma	= 1,
-	.max_sectors		= 128,
-	.use_clustering		= ENABLE_CLUSTERING,
-};
-#include "scsi_module.c"
+static void __exit BusLogic_exit(void)
+{
+	struct BusLogic_HostAdapter *HostAdapter;
+	for (HostAdapter = BusLogic_FirstRegisteredHostAdapter;
+		HostAdapter != NULL; HostAdapter = HostAdapter->Next) {
+		struct Scsi_Host *host = HostAdapter->SCSI_Host;
+		scsi_remove_host(host);
+
+	}
+	for (HostAdapter = BusLogic_FirstRegisteredHostAdapter;
+		HostAdapter != NULL; HostAdapter = HostAdapter->Next) {
+		struct Scsi_Host *host = HostAdapter->SCSI_Host;
+		BusLogic_ReleaseHostAdapter(host);
+	}
+}
+
+__setup("BusLogic=", BusLogic_Setup);
 
+module_init(BusLogic_init);
+module_exit(BusLogic_exit);
diff -Nru linux-2.6.1-rc1/drivers/scsi/BusLogic.h linux-2.6.1-rc1-scsi-dorking/drivers/scsi/BusLogic.h
--- linux-2.6.1-rc1/drivers/scsi/BusLogic.h	Wed Dec 17 19:58:48 2003
+++ linux-2.6.1-rc1-scsi-dorking/drivers/scsi/BusLogic.h	Wed Dec 31 21:10:37 2003
@@ -1741,7 +1741,7 @@
 static void BusLogic_QueueCompletedCCB(BusLogic_CCB_T *);
 static irqreturn_t BusLogic_InterruptHandler(int, void *, Registers_T *);
 static int BusLogic_ResetHostAdapter(BusLogic_HostAdapter_T *,
-				     SCSI_Command_T *, unsigned int);
+				     boolean HardReset);
 static void BusLogic_Message(BusLogic_MessageLevel_T, char *,
 			     BusLogic_HostAdapter_T *, ...);
 

--------------7071404970DB7F41ED5C1832--

