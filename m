From: Mike Christie <mikenc@us.ibm.com>
Subject: [PATCH] fixes compile errors in cpqfcTS driver
Date: Mon, 21 Apr 2003 16:57:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EA48555.8020600@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060004060501010809050602"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:26261 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262682AbTDUXqH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 19:46:07 -0400
Received: from northrelay01.pok.ibm.com (northrelay01.pok.ibm.com [9.56.224.149])
	by e4.ny.us.ibm.com (8.12.9/8.12.2) with ESMTP id h3LNw6sZ123804
	for <linux-scsi@vger.kernel.org>; Mon, 21 Apr 2003 19:58:06 -0400
Received: from us.ibm.com (dyn9-47-17-167.beaverton.ibm.com [9.47.17.167])
	by northrelay01.pok.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h3LNw3SU037910
	for <linux-scsi@vger.kernel.org>; Mon, 21 Apr 2003 19:58:04 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060004060501010809050602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch fixes the compile errors in the cpqfcTS driver caused 
by changes in Scsi_Cmnd described in Bugzilla bug #346 at 
http://bugme.osdl.org/show_bug.cgi?id=346.  It was built against 2.5.68. 
I do not have the hardware, so I have only 
verified that it compiles correctly.

Mike Christie
mikenc@us.ibm.com



 cpqfcTSinit.c   |    6 ++++--
 cpqfcTSworker.c |   44 ++++++++++++++++++++++----------------------
 2 files changed, 26 insertions(+), 24 deletions(-)

--------------060004060501010809050602
Content-Type: text/plain;
 name="cpfc_patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cpfc_patch"

diff -puNr linux-2.5.68-orig/drivers/scsi/cpqfcTSinit.c linux-2.5.68/drivers/scsi/cpqfcTSinit.c
--- linux-2.5.68-orig/drivers/scsi/cpqfcTSinit.c	Sat Apr 19 19:48:50 2003
+++ linux-2.5.68/drivers/scsi/cpqfcTSinit.c	Mon Apr 21 16:11:03 2003
@@ -931,6 +931,7 @@ int cpqfcTS_proc_info (char *buffer, cha
 {
   struct Scsi_Host *host;
   Scsi_Cmnd DumCmnd;
+  Scsi_Device DumSdev;
   int Chan, Targ, i;
   struct info_str info;
   CPQFCHBA *cpqfcHBA;
@@ -963,11 +964,12 @@ int cpqfcTS_proc_info (char *buffer, cha
 
 #define DISPLAY_WWN_INFO
 #ifdef DISPLAY_WWN_INFO
+  DumCmnd.device = &DumSdev;
   copy_info(&info, "WWN database: (\"port_id: 000000\" means disconnected)\n");
   for ( Chan=0; Chan <= host->max_channel; Chan++) {
-    DumCmnd.channel = Chan;
+    DumCmnd.device->channel = Chan;
     for (Targ=0; Targ <= host->max_id; Targ++) {
-      DumCmnd.target = Targ;
+      DumCmnd.device->id = Targ;
       if ((pLoggedInPort = fcFindLoggedInPort( fcChip,
 	    			&DumCmnd, // search Scsi Nexus
     				0,        // DON'T search list for FC port id
diff -puNr linux-2.5.68-orig/drivers/scsi/cpqfcTSworker.c linux-2.5.68/drivers/scsi/cpqfcTSworker.c
--- linux-2.5.68-orig/drivers/scsi/cpqfcTSworker.c	Sat Apr 19 19:50:35 2003
+++ linux-2.5.68/drivers/scsi/cpqfcTSworker.c	Mon Apr 21 16:11:03 2003
@@ -1196,9 +1196,9 @@ void cpqfcTSTerminateExchange( 
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
@@ -2681,7 +2681,7 @@ static void SendLogins( CPQFCHBA *cpqfcH
 // D. Deming, 1994, pg 7-19 (ISBN 1-879936-08-9)
 static void ScsiReportLunsDone(Scsi_Cmnd *Cmnd)
 {
-  struct Scsi_Host *HostAdapter = Cmnd->host;
+  struct Scsi_Host *HostAdapter = Cmnd->device->host;
   CPQFCHBA *cpqfcHBAdata = (CPQFCHBA *)HostAdapter->hostdata;
   PTACHYON fcChip = &cpqfcHBAdata->fcChip;
   FC_EXCHANGES *Exchanges = fcChip->Exchanges;
@@ -2887,11 +2887,11 @@ static void 
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
@@ -2952,7 +2952,7 @@ static void IssueReportLunsCommand( 
     memset( ucBuff, 0, REPORT_LUNS_PL);
     
     Cmnd->scsi_done = ScsiReportLunsDone;
-    Cmnd->host = cpqfcHBAdata->HostAdapter;
+    Cmnd->device->host = cpqfcHBAdata->HostAdapter;
 
     Cmnd->request_buffer = pLoggedInPort->ReportLunsPayload; 
     Cmnd->request_bufflen = REPORT_LUNS_PL; 
@@ -2962,8 +2962,8 @@ static void IssueReportLunsCommand( 
     Cmnd->cmnd[9] = (UCHAR)REPORT_LUNS_PL;
     Cmnd->cmd_len = 12;
 
-    Cmnd->channel = pLoggedInPort->ScsiNexus.channel;
-    Cmnd->target = pLoggedInPort->ScsiNexus.target;
+    Cmnd->device->channel = pLoggedInPort->ScsiNexus.channel;
+    Cmnd->device->id = pLoggedInPort->ScsiNexus.target;
 
 	    
     ulStatus = cpqfcTSBuildExchange(
@@ -3361,22 +3361,22 @@ PFC_LOGGEDIN_PORT  fcFindLoggedInPort( 
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
 	
@@ -3391,17 +3391,17 @@ PFC_LOGGEDIN_PORT  fcFindLoggedInPort( 
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
@@ -3507,9 +3507,9 @@ static void UnblockScsiDevice( struct Sc
 
 
       // Are there any Q'd commands for this target?
-      if( (Cmnd->target == pLoggedInPort->ScsiNexus.target)
+      if( (Cmnd->device->id == pLoggedInPort->ScsiNexus.target)
 	       &&
-          (Cmnd->channel == pLoggedInPort->ScsiNexus.channel) )
+          (Cmnd->device->channel == pLoggedInPort->ScsiNexus.channel) )
       {
         Cmnd->result = (DID_SOFT_ERROR <<16); // force retry
         if( Cmnd->scsi_done == NULL) 

--------------060004060501010809050602--

