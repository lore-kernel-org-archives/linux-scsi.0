From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] first steps at BusLogic cleanup
Date: Sun, 29 Aug 2004 15:45:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040829134539.GB31541@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:50609 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267838AbUH2Npm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Aug 2004 09:45:42 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

 - switch to a normal lists.h list for all hbas
 - merge BusLogic_DetectHostAdapter and BusLogic_init
 - move scsi_remove_host into BusLogic_ReleaseHostAdapter instead
   of a second iteration over all hosts


--- 1.32/drivers/scsi/BusLogic.c	2004-08-23 23:09:44 +02:00
+++ edited/drivers/scsi/BusLogic.c	2004-08-29 16:58:42 +02:00
@@ -56,6 +56,8 @@
 #define FAILURE (-1)
 #endif
 
+static struct scsi_host_template Bus_Logic_template;
+
 /*
   BusLogic_DriverOptionsCount is a count of the number of BusLogic Driver
   Options specifications provided via the Linux Kernel Command Line or via
@@ -100,15 +102,7 @@
 
 static struct BusLogic_GlobalOptions BusLogic_GlobalOptions;
 
-
-/*
-  BusLogic_FirstRegisteredHostAdapter and BusLogic_LastRegisteredHostAdapter
-  are pointers to the first and last registered BusLogic Host Adapters.
-*/
-
-static struct BusLogic_HostAdapter *BusLogic_FirstRegisteredHostAdapter;
-static struct BusLogic_HostAdapter *BusLogic_LastRegisteredHostAdapter;
-
+static LIST_HEAD(BusLogic_host_list);
 
 /*
   BusLogic_ProbeInfoCount is the number of entries in BusLogic_ProbeInfoList.
@@ -158,47 +152,6 @@
 	return HostAdapter->FullModelName;
 }
 
-
-/*
-  BusLogic_RegisterHostAdapter adds Host Adapter to the list of registered
-  BusLogic Host Adapters.
-*/
-
-static void __init BusLogic_RegisterHostAdapter(struct BusLogic_HostAdapter *HostAdapter)
-{
-	HostAdapter->Next = NULL;
-	if (BusLogic_FirstRegisteredHostAdapter == NULL) {
-		BusLogic_FirstRegisteredHostAdapter = HostAdapter;
-		BusLogic_LastRegisteredHostAdapter = HostAdapter;
-	} else {
-		BusLogic_LastRegisteredHostAdapter->Next = HostAdapter;
-		BusLogic_LastRegisteredHostAdapter = HostAdapter;
-	}
-}
-
-
-/*
-  BusLogic_UnregisterHostAdapter removes Host Adapter from the list of
-  registered BusLogic Host Adapters.
-*/
-
-static void BusLogic_UnregisterHostAdapter(struct BusLogic_HostAdapter *HostAdapter)
-{
-	if (HostAdapter == BusLogic_FirstRegisteredHostAdapter) {
-		BusLogic_FirstRegisteredHostAdapter = BusLogic_FirstRegisteredHostAdapter->Next;
-		if (HostAdapter == BusLogic_LastRegisteredHostAdapter)
-			BusLogic_LastRegisteredHostAdapter = NULL;
-	} else {
-		struct BusLogic_HostAdapter *PreviousHostAdapter = BusLogic_FirstRegisteredHostAdapter;
-		while (PreviousHostAdapter != NULL && PreviousHostAdapter->Next != HostAdapter)
-			PreviousHostAdapter = PreviousHostAdapter->Next;
-		if (PreviousHostAdapter != NULL)
-			PreviousHostAdapter->Next = HostAdapter->Next;
-	}
-	HostAdapter->Next = NULL;
-}
-
-
 /*
   BusLogic_InitializeCCBs initializes a group of Command Control Blocks (CCBs)
   for Host Adapter from the BlockSize bytes located at BlockPointer.  The newly
@@ -2208,17 +2161,23 @@
   registered.
 */
 
-static int __init BusLogic_DetectHostAdapter(struct scsi_host_template *HostTemplate)
+static int __init BusLogic_init(void)
 {
 	int BusLogicHostAdapterCount = 0, DriverOptionsIndex = 0, ProbeIndex;
 	struct BusLogic_HostAdapter *PrototypeHostAdapter;
+
+#ifdef MODULE
+	if (BusLogic)
+		BusLogic_Setup(BusLogic);
+#endif
+
 	if (BusLogic_ProbeOptions.NoProbe)
-		return 0;
+		return -ENODEV;
 	BusLogic_ProbeInfoList = (struct BusLogic_ProbeInfo *)
 	    kmalloc(BusLogic_MaxHostAdapters * sizeof(struct BusLogic_ProbeInfo), GFP_ATOMIC);
 	if (BusLogic_ProbeInfoList == NULL) {
 		BusLogic_Error("BusLogic: Unable to allocate Probe Info List\n", NULL);
-		return 0;
+		return -ENOMEM;
 	}
 	memset(BusLogic_ProbeInfoList, 0, BusLogic_MaxHostAdapters * sizeof(struct BusLogic_ProbeInfo));
 	PrototypeHostAdapter = (struct BusLogic_HostAdapter *)
@@ -2226,7 +2185,7 @@
 	if (PrototypeHostAdapter == NULL) {
 		kfree(BusLogic_ProbeInfoList);
 		BusLogic_Error("BusLogic: Unable to allocate Prototype " "Host Adapter\n", NULL);
-		return 0;
+		return -ENOMEM;
 	}
 	memset(PrototypeHostAdapter, 0, sizeof(struct BusLogic_HostAdapter));
 #ifdef MODULE
@@ -2289,7 +2248,7 @@
 		   Register the SCSI Host structure.
 		 */
 
-		Host = scsi_host_alloc(HostTemplate, sizeof(struct BusLogic_HostAdapter));
+		Host = scsi_host_alloc(&Bus_Logic_template, sizeof(struct BusLogic_HostAdapter));
 		if (Host == NULL) {
 			release_region(HostAdapter->IO_Address, HostAdapter->AddressCount);
 			continue;
@@ -2302,7 +2261,8 @@
 		   Add Host Adapter to the end of the list of registered BusLogic
 		   Host Adapters.
 		 */
-		BusLogic_RegisterHostAdapter(HostAdapter);
+		list_add_tail(&HostAdapter->host_list, &BusLogic_host_list);
+
 		/*
 		   Read the Host Adapter Configuration, Configure the Host Adapter,
 		   Acquire the System Resources necessary to use the Host Adapter, then
@@ -2322,7 +2282,7 @@
 				printk(KERN_WARNING "BusLogic: Release and re-register of " "port 0x%04lx failed \n", (unsigned long) HostAdapter->IO_Address);
 				BusLogic_DestroyCCBs(HostAdapter);
 				BusLogic_ReleaseResources(HostAdapter);
-				BusLogic_UnregisterHostAdapter(HostAdapter);
+				list_del(&HostAdapter->host_list);
 				scsi_host_put(Host);
 			} else {
 				BusLogic_InitializeHostStructure(HostAdapter, Host);
@@ -2341,14 +2301,14 @@
 			 */
 			BusLogic_DestroyCCBs(HostAdapter);
 			BusLogic_ReleaseResources(HostAdapter);
-			BusLogic_UnregisterHostAdapter(HostAdapter);
+			list_del(&HostAdapter->host_list);
 			scsi_host_put(Host);
 		}
 	}
 	kfree(PrototypeHostAdapter);
 	kfree(BusLogic_ProbeInfoList);
 	BusLogic_ProbeInfoList = NULL;
-	return BusLogicHostAdapterCount;
+	return 0;
 }
 
 
@@ -2358,9 +2318,12 @@
   unregisters the BusLogic Host Adapter.
 */
 
-static int __exit BusLogic_ReleaseHostAdapter(struct Scsi_Host *Host)
+static int __exit BusLogic_ReleaseHostAdapter(struct BusLogic_HostAdapter *HostAdapter)
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Host->hostdata;
+	struct Scsi_Host *Host = HostAdapter->SCSI_Host;
+
+	scsi_remove_host(Host);
+
 	/*
 	   FlashPoint Host Adapters must first be released by the FlashPoint
 	   SCCB Manager.
@@ -2380,7 +2343,7 @@
 	/*
 	   Remove Host Adapter from the list of registered BusLogic Host Adapters.
 	 */
-	BusLogic_UnregisterHostAdapter(HostAdapter);
+	list_del(&HostAdapter->host_list);
 	return 0;
 }
 
@@ -3181,17 +3144,11 @@
 
 static int BusLogic_ProcDirectoryInfo(struct Scsi_Host *shost, char *ProcBuffer, char **StartPointer, off_t Offset, int BytesAvailable, int WriteFlag)
 {
-	struct BusLogic_HostAdapter *HostAdapter;
+	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) shost->hostdata;
 	struct BusLogic_TargetStatistics *TargetStatistics;
 	int TargetID, Length;
 	char *Buffer;
-	for (HostAdapter = BusLogic_FirstRegisteredHostAdapter; HostAdapter != NULL; HostAdapter = HostAdapter->Next)
-		if (HostAdapter->HostNumber == shost->host_no)
-			break;
-	if (HostAdapter == NULL) {
-		BusLogic_Error("Cannot find Host Adapter for SCSI Host %d\n", NULL, shost->host_no);
-		return 0;
-	}
+
 	TargetStatistics = HostAdapter->TargetStatistics;
 	if (WriteFlag) {
 		HostAdapter->ExternalHostAdapterResets = 0;
@@ -3547,7 +3504,7 @@
   Get it all started
 */
 
-static struct scsi_host_template driver_template = {
+static struct scsi_host_template Bus_Logic_template = {
 	.module = THIS_MODULE,
 	.proc_name = "BusLogic",
 	.proc_info = BusLogic_ProcDirectoryInfo,
@@ -3585,36 +3542,15 @@
 }
 
 /*
- * Initialization function
- */
-
-static int __init BusLogic_init(void)
-{
-
-#ifdef MODULE
-	if (BusLogic)
-		BusLogic_Setup(BusLogic);
-#endif
-
-	return BusLogic_DetectHostAdapter(&driver_template) ? 0 : -ENODEV;
-}
-
-/*
  * Exit function.  Deletes all hosts associated with this driver.
  */
 
 static void __exit BusLogic_exit(void)
 {
-	struct BusLogic_HostAdapter *HostAdapter;
-	for (HostAdapter = BusLogic_FirstRegisteredHostAdapter; HostAdapter != NULL; HostAdapter = HostAdapter->Next) {
-		struct Scsi_Host *host = HostAdapter->SCSI_Host;
-		scsi_remove_host(host);
+	struct BusLogic_HostAdapter *ha, *next;
 
-	}
-	for (HostAdapter = BusLogic_FirstRegisteredHostAdapter; HostAdapter != NULL; HostAdapter = HostAdapter->Next) {
-		struct Scsi_Host *host = HostAdapter->SCSI_Host;
-		BusLogic_ReleaseHostAdapter(host);
-	}
+	list_for_each_entry_safe(ha, next, &BusLogic_host_list, host_list)
+		BusLogic_ReleaseHostAdapter(ha);
 }
 
 __setup("BusLogic=", BusLogic_Setup);
--- 1.18/drivers/scsi/BusLogic.h	2004-08-23 23:09:44 +02:00
+++ edited/drivers/scsi/BusLogic.h	2004-08-29 16:58:54 +02:00
@@ -1098,7 +1098,7 @@
 	struct BusLogic_DriverOptions *DriverOptions;
 	struct FlashPoint_Info FlashPointInfo;
 	FlashPoint_CardHandle_T CardHandle;
-	struct BusLogic_HostAdapter *Next;
+	struct list_head host_list;
 	struct BusLogic_CCB *All_CCBs;
 	struct BusLogic_CCB *Free_CCBs;
 	struct BusLogic_CCB *FirstCompletedCCB;
@@ -1386,8 +1386,6 @@
 */
 
 static const char *BusLogic_DriverInfo(struct Scsi_Host *);
-static int BusLogic_DetectHostAdapter(struct scsi_host_template *);
-static int BusLogic_ReleaseHostAdapter(struct Scsi_Host *);
 static int BusLogic_QueueCommand(struct scsi_cmnd *, void (*CompletionRoutine) (struct scsi_cmnd *));
 static int BusLogic_BIOSDiskParameters(struct scsi_device *, struct block_device *, sector_t, int *);
 static int BusLogic_ProcDirectoryInfo(struct Scsi_Host *, char *, char **, off_t, int, int);
