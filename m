From: Mike Christie <mikenc@us.ibm.com>
Subject: [PATCH] [RESEND] fixes compile errors in cpqfc driver
Date: Mon, 14 Jul 2003 12:54:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F130A78.6030004@us.ibm.com>
Reply-To: mikenc@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060808040700010209050605"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:41160 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S270869AbTGNTjr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2003 15:39:47 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Harris, Fred" <Fred.Harris@hp.com>

This is a multi-part message in MIME format.
--------------060808040700010209050605
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The attached path fixes the compile errors in the cpqfc driver caused by 
changes in scsi_cmnd. And, per Christoph and James's comments 
http://marc.theaimsgroup.com/?l=linux-scsi&m=105099392420649&w=2 I have 
removed the scsi_cmnd stack usage.

I do not have the hardware, so I have only verified that it compiles.


Mike Christie
mikenc@us.ibm.com



cpqfcTSinit.c    |   35 +++++++++++++++++++++---------
cpqfcTSstructs.h |    1
cpqfcTSworker.c  |   63 
+++++++++++++++++++++++++++++++------------------------
3 files changed, 61 insertions(+), 38 deletions(-)

--------------060808040700010209050605
Content-Type: text/plain;
 name="cpqfc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cpqfc.patch"

diff -uar linux-2.5.75/drivers/scsi/cpqfcTSinit.c linux-2.5.75-cpqfc/drivers/scsi/cpqfcTSinit.c
--- linux-2.5.75/drivers/scsi/cpqfcTSinit.c	2003-07-10 13:04:48.000000000 -0700
+++ linux-2.5.75-cpqfc/drivers/scsi/cpqfcTSinit.c	2003-07-13 00:19:56.000000000 -0700
@@ -549,14 +549,14 @@
 			hba->private_data_bits+(i/BITS_PER_LONG));
 }
 
-int cpqfcTS_ioctl( Scsi_Device *ScsiDev, int Cmnd, void *arg)
+int cpqfcTS_ioctl( struct scsi_device *ScsiDev, int Cmnd, void *arg)
 {
   int result = 0;
   struct Scsi_Host *HostAdapter = ScsiDev->host;
   CPQFCHBA *cpqfcHBAdata = (CPQFCHBA *)HostAdapter->hostdata;
   PTACHYON fcChip = &cpqfcHBAdata->fcChip;
   PFC_LOGGEDIN_PORT pLoggedInPort = NULL;
-  Scsi_Cmnd DumCmnd;
+  struct scsi_cmnd *DumCmnd;
   int i, j;
   VENDOR_IOCTL_REQ ioc;
   cpqfc_passthru_t *vendor_cmd;
@@ -723,13 +723,16 @@
 /* 	DumCmnd.target  = ScsiDev->id; */
 /* 	DumCmnd.lun     = ScsiDev->lun; */
 
-        DumCmnd.device = ScsiDev;
+	DumCmnd = scsi_get_command (ScsiDev, GFP_KERNEL);
+	if (!DumCmnd)
+		return -ENOMEM;
 	
 	pLoggedInPort = fcFindLoggedInPort( fcChip,
-		&DumCmnd, // search Scsi Nexus
+		DumCmnd, // search Scsi Nexus
 		0,        // DON'T search linked list for FC port id
 		NULL,     // DON'T search linked list for FC WWN
 		NULL);    // DON'T care about end of list
+	scsi_put_command (DumCmnd);
 	if (pLoggedInPort == NULL) {
 		result = -ENXIO;
 		break;
@@ -918,7 +921,8 @@
 int cpqfcTS_proc_info (struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, 
 		       int inout)
 {
-  Scsi_Cmnd DumCmnd;
+  struct scsi_cmnd *DumCmnd;
+  struct scsi_device *ScsiDev;
   int Chan, Targ, i;
   struct info_str info;
   CPQFCHBA *cpqfcHBA;
@@ -946,13 +950,21 @@
 
 #define DISPLAY_WWN_INFO
 #ifdef DISPLAY_WWN_INFO
+  ScsiDev = scsi_get_host_dev (host);
+  if (!ScsiDev) 
+    return -ENOMEM;
+  DumCmnd = scsi_get_command (ScsiDev, GFP_KERNEL);
+  if (!DumCmnd) {
+    scsi_free_host_dev (ScsiDev);
+    return -ENOMEM;
+  }
   copy_info(&info, "WWN database: (\"port_id: 000000\" means disconnected)\n");
   for ( Chan=0; Chan <= host->max_channel; Chan++) {
-    DumCmnd.channel = Chan;
+    DumCmnd->device->channel = Chan;
     for (Targ=0; Targ <= host->max_id; Targ++) {
-      DumCmnd.target = Targ;
+      DumCmnd->device->id = Targ;
       if ((pLoggedInPort = fcFindLoggedInPort( fcChip,
-	    			&DumCmnd, // search Scsi Nexus
+	    			DumCmnd,  // search Scsi Nexus
     				0,        // DON'T search list for FC port id
     				NULL,     // DON'T search list for FC WWN
     				NULL))){   // DON'T care about end of list
@@ -966,6 +978,9 @@
       }
     }
   }
+
+  scsi_put_command (DumCmnd);
+  scsi_free_host_dev (ScsiDev);
 #endif
 
 
@@ -1578,7 +1593,7 @@
 // Scsi_Request, etc.
 // For now, so people don't fall into a hole...
 return -ENOTSUPP;
-
+/*
   // printk("   ENTERING cpqfcTS_TargetDeviceReset() - flag=%d \n",reset_flags);
 
   if (ScsiDev->host->eh_active) return FAILED;
@@ -1600,7 +1615,7 @@
 	SCpnt->request->CPQFC_WAITING = NULL;
   }
     
-/*
+
       if(driver_byte(SCpnt->result) != 0)
 	  switch(SCpnt->sense_buffer[2] & 0xf) {
 	case ILLEGAL_REQUEST:
diff -uar linux-2.5.75/drivers/scsi/cpqfcTSstructs.h linux-2.5.75-cpqfc/drivers/scsi/cpqfcTSstructs.h
--- linux-2.5.75/drivers/scsi/cpqfcTSstructs.h	2003-07-10 13:08:26.000000000 -0700
+++ linux-2.5.75-cpqfc/drivers/scsi/cpqfcTSstructs.h	2003-07-13 00:16:29.000000000 -0700
@@ -696,7 +696,6 @@
 
   ULONG port_id;     // a FC 24-bit address of port (lower 8 bits = al_pa)
 
-  Scsi_Cmnd ScsiCmnd;   // command buffer for Report Luns
 #define REPORT_LUNS_PL 256  
   UCHAR ReportLunsPayload[REPORT_LUNS_PL];
   
diff -uar linux-2.5.75/drivers/scsi/cpqfcTSworker.c linux-2.5.75-cpqfc/drivers/scsi/cpqfcTSworker.c
--- linux-2.5.75/drivers/scsi/cpqfcTSworker.c	2003-07-10 13:12:59.000000000 -0700
+++ linux-2.5.75-cpqfc/drivers/scsi/cpqfcTSworker.c	2003-07-13 15:40:09.000000000 -0700
@@ -30,6 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/smp_lock.h>
+#include <linux/pci.h>
 
 #define __KERNEL_SYSCALLS__
 
@@ -1196,9 +1197,9 @@
 	// have to terminate by SCSI target, NOT port_id.
         if( Exchanges->fcExchange[x_ID].Cmnd) // Cmnd in progress?
 	{	                 
-	  if( (Exchanges->fcExchange[x_ID].Cmnd->target == ScsiNexus->target)
+	  if( (Exchanges->fcExchange[x_ID].Cmnd->device->id == ScsiNexus->target)
 			&&
-            (Exchanges->fcExchange[x_ID].Cmnd->channel == ScsiNexus->channel)) 
+            (Exchanges->fcExchange[x_ID].Cmnd->device->channel == ScsiNexus->channel)) 
           {
             Exchanges->fcExchange[x_ID].status = TerminateStatus;
             cpqfcTSPutLinkQue( cpqfcHBAdata, BLS_ABTS, &x_ID ); // timed-out
@@ -2681,7 +2682,7 @@
 // D. Deming, 1994, pg 7-19 (ISBN 1-879936-08-9)
 static void ScsiReportLunsDone(Scsi_Cmnd *Cmnd)
 {
-  struct Scsi_Host *HostAdapter = Cmnd->host;
+  struct Scsi_Host *HostAdapter = Cmnd->device->host;
   CPQFCHBA *cpqfcHBAdata = (CPQFCHBA *)HostAdapter->hostdata;
   PTACHYON fcChip = &cpqfcHBAdata->fcChip;
   FC_EXCHANGES *Exchanges = fcChip->Exchanges;
@@ -2887,11 +2888,11 @@
 call_scsi_done(Scsi_Cmnd *Cmnd)
 {
 	CPQFCHBA *hba;
-	hba = (CPQFCHBA *) Cmnd->host->hostdata;
+	hba = (CPQFCHBA *) Cmnd->device->host->hostdata;
 	// Was this command a cpqfc passthru ioctl ?
-        if (Cmnd->sc_request != NULL && Cmnd->host != NULL && 
-		Cmnd->host->hostdata != NULL &&
-		is_private_data_of_cpqfc((CPQFCHBA *) Cmnd->host->hostdata,
+        if (Cmnd->sc_request != NULL && Cmnd->device->host != NULL && 
+		Cmnd->device->host->hostdata != NULL &&
+		is_private_data_of_cpqfc((CPQFCHBA *) Cmnd->device->host->hostdata,
 			Cmnd->sc_request->upper_private_data)) {
 		cpqfc_free_private_data(hba, 
 			Cmnd->sc_request->upper_private_data);	
@@ -2918,7 +2919,8 @@
 {
   PTACHYON fcChip = &cpqfcHBAdata->fcChip;
   PFC_LOGGEDIN_PORT pLoggedInPort; 
-  Scsi_Cmnd *Cmnd;
+  struct scsi_cmnd *Cmnd = NULL;
+  struct scsi_device *ScsiDev = NULL;
   LONG x_ID;
   ULONG ulStatus;
   UCHAR *ucBuff;
@@ -2942,17 +2944,20 @@
     if( !(pLoggedInPort->fcp_info & TARGET_FUNCTION) )
       goto Done;  // forget it - FC device not a "target"
 
-    // now use the port's Scsi Command buffer for the 
-    // Report Luns Command
  
-    Cmnd = &pLoggedInPort->ScsiCmnd; 
+    ScsiDev = scsi_get_host_dev (cpqfcHBAdata->HostAdapter);
+    if (!ScsiDev)
+      goto Done;
+    
+    Cmnd = scsi_get_command (ScsiDev, GFP_KERNEL);
+    if (!Cmnd) 
+      goto Done;
+
     ucBuff = pLoggedInPort->ReportLunsPayload;
     
-    memset( Cmnd, 0, sizeof(Scsi_Cmnd));
     memset( ucBuff, 0, REPORT_LUNS_PL);
     
     Cmnd->scsi_done = ScsiReportLunsDone;
-    Cmnd->host = cpqfcHBAdata->HostAdapter;
 
     Cmnd->request_buffer = pLoggedInPort->ReportLunsPayload; 
     Cmnd->request_bufflen = REPORT_LUNS_PL; 
@@ -2962,8 +2967,8 @@
     Cmnd->cmnd[9] = (UCHAR)REPORT_LUNS_PL;
     Cmnd->cmd_len = 12;
 
-    Cmnd->channel = pLoggedInPort->ScsiNexus.channel;
-    Cmnd->target = pLoggedInPort->ScsiNexus.target;
+    Cmnd->device->channel = pLoggedInPort->ScsiNexus.channel;
+    Cmnd->device->id = pLoggedInPort->ScsiNexus.target;
 
 	    
     ulStatus = cpqfcTSBuildExchange(
@@ -3003,6 +3008,10 @@
 
 Done:
 
+  if (Cmnd)
+    scsi_put_command (Cmnd);
+  if (ScsiDev) 
+    scsi_free_host_dev (ScsiDev);
 }
 
 
@@ -3361,22 +3370,22 @@
     {
       // check Linux Scsi Cmnd for channel/target Nexus match
       // (all luns are accessed through matching "pLoggedInPort")
-      if( (pLoggedInPort->ScsiNexus.target == Cmnd->target)
+      if( (pLoggedInPort->ScsiNexus.target == Cmnd->device->id)
                 &&
-          (pLoggedInPort->ScsiNexus.channel == Cmnd->channel))
+          (pLoggedInPort->ScsiNexus.channel == Cmnd->device->channel))
       {
         // For "passthru" modes, the IOCTL caller is responsible
 	// for setting the FCP-LUN addressing
-	if (Cmnd->sc_request != NULL && Cmnd->host != NULL && 
-		Cmnd->host->hostdata != NULL &&
-		is_private_data_of_cpqfc((CPQFCHBA *) Cmnd->host->hostdata,
+	if (Cmnd->sc_request != NULL && Cmnd->device->host != NULL && 
+		Cmnd->device->host->hostdata != NULL &&
+		is_private_data_of_cpqfc((CPQFCHBA *) Cmnd->device->host->hostdata,
 			Cmnd->sc_request->upper_private_data)) { 
 		/* This is a passthru... */
 		cpqfc_passthru_private_t *pd;
 		pd = Cmnd->sc_request->upper_private_data;
         	Cmnd->SCp.phase = pd->bus;
 		// Cmnd->SCp.have_data_in = pd->pdrive;
-		Cmnd->SCp.have_data_in = Cmnd->lun;
+		Cmnd->SCp.have_data_in = Cmnd->device->lun;
 	} else {
 	  /* This is not a passthru... */
 	
@@ -3391,17 +3400,17 @@
 	  // Report Luns command
           if( pLoggedInPort->ScsiNexus.LunMasking == 1) 
 	  {
-	    if (Cmnd->lun > sizeof(pLoggedInPort->ScsiNexus.lun))
+	    if (Cmnd->device->lun > sizeof(pLoggedInPort->ScsiNexus.lun))
 		return NULL;
             // we KNOW all the valid LUNs... 0xFF is invalid!
-            Cmnd->SCp.have_data_in = pLoggedInPort->ScsiNexus.lun[Cmnd->lun];
-	    if (pLoggedInPort->ScsiNexus.lun[Cmnd->lun] == 0xFF)
+            Cmnd->SCp.have_data_in = pLoggedInPort->ScsiNexus.lun[Cmnd->device->lun];
+	    if (pLoggedInPort->ScsiNexus.lun[Cmnd->device->lun] == 0xFF)
 		return NULL;
 	    // printk("xlating lun %d to 0x%02x\n", Cmnd->lun, 
             //	pLoggedInPort->ScsiNexus.lun[Cmnd->lun]);
 	  }
 	  else
-	    Cmnd->SCp.have_data_in = Cmnd->lun; // Linux & target luns match
+	    Cmnd->SCp.have_data_in = Cmnd->device->lun; // Linux & target luns match
 	}
 	break; // found it!
       }
@@ -3507,9 +3516,9 @@
 
 
       // Are there any Q'd commands for this target?
-      if( (Cmnd->target == pLoggedInPort->ScsiNexus.target)
+      if( (Cmnd->device->id == pLoggedInPort->ScsiNexus.target)
 	       &&
-          (Cmnd->channel == pLoggedInPort->ScsiNexus.channel) )
+          (Cmnd->device->channel == pLoggedInPort->ScsiNexus.channel) )
       {
         Cmnd->result = (DID_SOFT_ERROR <<16); // force retry
         if( Cmnd->scsi_done == NULL) 

--------------060808040700010209050605--

