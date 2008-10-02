From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [5/21] SCSI-ISA-DMA: Remove unchecked_isa in BusLogic
Date: Thu,  2 Oct 2008 09:58:43 +0200 (CEST)
Message-ID: <20081002075843.2D4D63E6A09@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYJBH6p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:45 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


- ->cmnd handling audited and does always copy
- Allocate hostdata separately
- Enable sense_buffer isa bounce buffering
- Remove unchecked_isa_dma
- Enable block layer bouncing explicitely for isa adapters

Untested due to lack of hardware

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/BusLogic.c |   77 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 59 insertions(+), 18 deletions(-)

Index: linux/drivers/scsi/BusLogic.c
===================================================================
--- linux.orig/drivers/scsi/BusLogic.c
+++ linux/drivers/scsi/BusLogic.c
@@ -62,6 +62,13 @@
 
 static struct scsi_host_template Bus_Logic_template;
 
+struct host_ptr {
+	struct BusLogic_HostAdapter *host;
+	dma_addr_t dma;
+};
+#define bl_shost_priv(shost) (((struct host_ptr *)shost_priv(shost))->host)
+#define bl_shost_dma(shost) (((struct host_ptr *)shost_priv(shost))->dma)
+
 /*
   BusLogic_DriverOptionsCount is a count of the number of BusLogic Driver
   Options specifications provided via the Linux Kernel Command Line or via
@@ -124,6 +131,12 @@ static int BusLogic_ProbeInfoCount;
 
 static struct BusLogic_ProbeInfo *BusLogic_ProbeInfoList;
 
+static int buslogic_adjust_queue(struct scsi_device *device)
+{
+	if (device->host->sense_buffer_isa)
+		blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
+	return 0;
+}
 
 /*
   BusLogic_CommandFailureReason holds a string identifying the reason why a
@@ -152,7 +165,7 @@ static void BusLogic_AnnounceDriver(stru
 
 static const char *BusLogic_DriverInfo(struct Scsi_Host *Host)
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Host->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(Host);
 	return HostAdapter->FullModelName;
 }
 
@@ -1610,9 +1623,6 @@ static bool __init BusLogic_ReadHostAdap
 	   BIOS_Address is 0.
 	 */
 	HostAdapter->BIOS_Address = ExtendedSetupInformation.BIOS_Address << 12;
-	/*
-	   ISA Host Adapters require Bounce Buffers if there is more than 16MB memory.
-	 */
 	if (HostAdapter->HostAdapterBusType == BusLogic_ISA_Bus && (void *) high_memory > (void *) MAX_DMA_ADDRESS)
 		HostAdapter->BounceBuffersRequired = true;
 	/*
@@ -2131,7 +2141,9 @@ static void __init BusLogic_InitializeHo
 	Host->this_id = HostAdapter->SCSI_ID;
 	Host->can_queue = HostAdapter->DriverQueueDepth;
 	Host->sg_tablesize = HostAdapter->DriverScatterGatherLimit;
-	Host->unchecked_isa_dma = HostAdapter->BounceBuffersRequired;
+	if (HostAdapter->BounceBuffersRequired)
+		Host->sense_buffer_isa = 1;
+
 	Host->cmd_per_lun = HostAdapter->UntaggedQueueDepth;
 }
 
@@ -2145,7 +2157,7 @@ static void __init BusLogic_InitializeHo
 */
 static int BusLogic_SlaveConfigure(struct scsi_device *Device)
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Device->host->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(Device->host);
 	int TargetID = Device->id;
 	int QueueDepth = HostAdapter->QueueDepth[TargetID];
 
@@ -2170,6 +2182,35 @@ static int BusLogic_SlaveConfigure(struc
 	return 0;
 }
 
+static struct Scsi_Host *buslogic_host_alloc(gfp_t gfp)
+{
+	struct BusLogic_HostAdapter *board;
+	struct Scsi_Host *shost;
+
+
+	shost = scsi_host_alloc(&Bus_Logic_template, sizeof(struct host_ptr));
+	if (!shost)
+		return NULL;
+
+	board = dma_alloc_coherent(NULL, sizeof(struct BusLogic_HostAdapter),
+					&bl_shost_dma(shost), GFP_KERNEL);
+	if (!board) {
+		scsi_host_put(shost);
+		return NULL;
+	}
+
+	bl_shost_priv(shost) = board;
+
+	return shost;
+}
+
+static void buslogic_free_host(struct Scsi_Host *shost)
+{
+	dma_free_coherent(NULL, sizeof(struct BusLogic_HostAdapter),
+			  bl_shost_priv(shost), bl_shost_dma(shost));
+	scsi_host_put(shost);
+}
+
 /*
   BusLogic_DetectHostAdapter probes for BusLogic Host Adapters at the standard
   I/O Addresses where they may be located, initializing, registering, and
@@ -2270,12 +2311,12 @@ static int __init BusLogic_init(void)
 		   Register the SCSI Host structure.
 		 */
 
-		Host = scsi_host_alloc(&Bus_Logic_template, sizeof(struct BusLogic_HostAdapter));
+		Host = buslogic_host_alloc(PrototypeHostAdapter->BounceBuffersRequired ? GFP_DMA : 0);
 		if (Host == NULL) {
 			release_region(HostAdapter->IO_Address, HostAdapter->AddressCount);
 			continue;
 		}
-		HostAdapter = (struct BusLogic_HostAdapter *) Host->hostdata;
+		HostAdapter = bl_shost_priv(Host);
 		memcpy(HostAdapter, PrototypeHostAdapter, sizeof(struct BusLogic_HostAdapter));
 		HostAdapter->SCSI_Host = Host;
 		HostAdapter->HostNumber = Host->host_no;
@@ -2321,7 +2362,7 @@ static int __init BusLogic_init(void)
 				BusLogic_DestroyCCBs(HostAdapter);
 				BusLogic_ReleaseResources(HostAdapter);
 				list_del(&HostAdapter->host_list);
-				scsi_host_put(Host);
+				buslogic_free_host(Host);
 				ret = -ENOMEM;
 			} else {
 				BusLogic_InitializeHostStructure(HostAdapter,
@@ -2335,7 +2376,7 @@ static int __init BusLogic_init(void)
 					BusLogic_DestroyCCBs(HostAdapter);
 					BusLogic_ReleaseResources(HostAdapter);
 					list_del(&HostAdapter->host_list);
-					scsi_host_put(Host);
+					buslogic_free_host(Host);
 					ret = -ENODEV;
 				} else {
 					scsi_scan_host(Host);
@@ -2354,7 +2395,7 @@ static int __init BusLogic_init(void)
 			BusLogic_DestroyCCBs(HostAdapter);
 			BusLogic_ReleaseResources(HostAdapter);
 			list_del(&HostAdapter->host_list);
-			scsi_host_put(Host);
+			buslogic_free_host(Host);
 			ret = -ENODEV;
 		}
 	}
@@ -2398,7 +2439,7 @@ static int __exit BusLogic_ReleaseHostAd
 	 */
 	list_del(&HostAdapter->host_list);
 
-	scsi_host_put(Host);
+	buslogic_free_host(Host);
 	return 0;
 }
 
@@ -2786,7 +2827,7 @@ static bool BusLogic_WriteOutgoingMailbo
 
 static int BusLogic_host_reset(struct scsi_cmnd * SCpnt)
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) SCpnt->device->host->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(SCpnt->device->host);
 
 	unsigned int id = SCpnt->device->id;
 	struct BusLogic_TargetStatistics *stats = &HostAdapter->TargetStatistics[id];
@@ -2808,7 +2849,7 @@ static int BusLogic_host_reset(struct sc
 
 static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRoutine) (struct scsi_cmnd *))
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Command->device->host->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(Command->device->host);
 	struct BusLogic_TargetFlags *TargetFlags = &HostAdapter->TargetFlags[Command->device->id];
 	struct BusLogic_TargetStatistics *TargetStatistics = HostAdapter->TargetStatistics;
 	unsigned char *CDB = Command->cmnd;
@@ -3001,7 +3042,7 @@ static int BusLogic_QueueCommand(struct 
 
 static int BusLogic_AbortCommand(struct scsi_cmnd *Command)
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Command->device->host->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(Command->device->host);
 
 	int TargetID = Command->device->id;
 	struct BusLogic_CCB *CCB;
@@ -3131,7 +3172,7 @@ static int BusLogic_ResetHostAdapter(str
 
 static int BusLogic_BIOSDiskParameters(struct scsi_device *sdev, struct block_device *Device, sector_t capacity, int *Parameters)
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) sdev->host->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(sdev->host);
 	struct BIOS_DiskParameters *DiskParameters = (struct BIOS_DiskParameters *) Parameters;
 	unsigned char *buf;
 	if (HostAdapter->ExtendedTranslationEnabled && capacity >= 2 * 1024 * 1024 /* 1 GB in 512 byte sectors */ ) {
@@ -3202,7 +3243,7 @@ static int BusLogic_BIOSDiskParameters(s
 
 static int BusLogic_ProcDirectoryInfo(struct Scsi_Host *shost, char *ProcBuffer, char **StartPointer, off_t Offset, int BytesAvailable, int WriteFlag)
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) shost->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(shost);
 	struct BusLogic_TargetStatistics *TargetStatistics;
 	int TargetID, Length;
 	char *Buffer;
@@ -3575,9 +3616,9 @@ static struct scsi_host_template Bus_Log
 #if 0
 	.eh_abort_handler = BusLogic_AbortCommand,
 #endif
-	.unchecked_isa_dma = 1,
 	.max_sectors = 128,
 	.use_clustering = ENABLE_CLUSTERING,
+	.slave_alloc = buslogic_adjust_queue,
 };
 
 /*
