From: Tom Coughlan <coughlan@redhat.com>
Subject: [PATCH] 2.6 aacraid: remove aac_handle_aif
Date: Wed, 08 Dec 2004 11:12:22 -0500
Message-ID: <1102522342.14284.13975.camel@bianchi.boston.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-pY7RSkZtYudgFYUHXixZ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:2709 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261249AbULHQNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2004 11:13:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: alan@redhat.com, markh@osdl.org, Mark_Salyzyn@adaptec.com


--=-pY7RSkZtYudgFYUHXixZ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

When aac_command_thread detects an adapter event (AifCmdDriverNotify or
AifCmdEventNotify) it calls aac_handle_aif. This routine sets a flag,
calls fib_adapter_complete, and returns. The bad news is that after the
return, aac_command_thread continues to process the command and calls
fib_adapter_complete again.   

Under some circumstances this causes the driver to take the device
offline. In my case, it happens with a Dell CERC SATA with a RAID 5 in
the "building" state:

aacraid: Host adapter reset request. SCSI hang ?
aacraid: Host adapter appears dead
scsi: Device offlined - not ready after error recovery: host 0 channel 0
id 0 lun 0
SCSI error : <0 0 0 0> return code = 0x6000000
end_request: I/O error, dev sda, sector 976537592

Mark Salyzyn says the intent is for aac_handle_aif to perform some
plug-n-play actions based on the adapter event, and return, leaving the
command completion to the caller. 

The attached patch solves the problem by removing aac_handle_aif
entirely, since it is wrong, and there is currently no code in the
driver to actually do anything with these events.

Thanks to Alan, Mark S., and Mark H. for looking this over.

Tom

--=-pY7RSkZtYudgFYUHXixZ
Content-Disposition: attachment; filename=aac-remove-handle-aif.patch
Content-Type: text/x-patch; name=aac-remove-handle-aif.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 7bit

diff -ruNp linux-2.6.9/drivers/scsi/aacraid-orig/commsup.c linux-2.6.9/drivers/scsi/aacraid/commsup.c
--- linux-2.6.9/drivers/scsi/aacraid-orig/commsup.c
+++ linux-2.6.9/drivers/scsi/aacraid/commsup.c
@@ -768,28 +768,6 @@ void aac_printf(struct aac_dev *dev, u32
 	memset(cp, 0,  256);
 }
 
-
-/**
- *	aac_handle_aif		-	Handle a message from the firmware
- *	@dev: Which adapter this fib is from
- *	@fibptr: Pointer to fibptr from adapter
- *
- *	This routine handles a driver notify fib from the adapter and
- *	dispatches it to the appropriate routine for handling.
- */
-
-static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
-{
-	struct hw_fib * hw_fib = fibptr->hw_fib;
-	/*
-	 * Set the status of this FIB to be Invalid parameter.
-	 *
-	 *	*(u32 *)fib->data = ST_INVAL;
-	 */
-	*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
-	fib_adapter_complete(fibptr, sizeof(u32));
-}
-
 /**
  *	aac_command_thread	-	command processing thread
  *	@dev: Adapter to monitor
@@ -859,7 +837,6 @@ int aac_command_thread(struct aac_dev * 
 			aifcmd = (struct aac_aifcmd *) hw_fib->data;
 			if (aifcmd->command == cpu_to_le32(AifCmdDriverNotify)) {
 				/* Handle Driver Notify Events */
-				aac_handle_aif(dev, fib);
 				*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
 				fib_adapter_complete(fib, sizeof(u32));
 			} else {
@@ -870,10 +847,6 @@ int aac_command_thread(struct aac_dev * 
 				u32 time_now, time_last;
 				unsigned long flagv;
 				
-				/* Sniff events */
-				if (aifcmd->command == cpu_to_le32(AifCmdEventNotify))
-					aac_handle_aif(dev, fib);
-				
 				time_now = jiffies/HZ;
 
 				spin_lock_irqsave(&dev->fib_lock, flagv);

--=-pY7RSkZtYudgFYUHXixZ--

