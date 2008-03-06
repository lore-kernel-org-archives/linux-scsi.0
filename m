From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [2/21] Remove unchecked_isa in BusLogic
Date: Thu,  6 Mar 2008 21:51:17 +0100 (CET)
Message-ID: <20080306205120.16B741B419C@basil.firstfloor.org>
References: <20080306951.147874949@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:15033 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761185AbYCFUv3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 15:51:29 -0500
In-Reply-To: <20080306951.147874949@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


- ->cmnd handling audited and does always copy
- Allocate hostdata separately
- Enable sense_buffer isa bounce buffering
- Remove unchecked_isa_dma
- Enable block layer bouncing explicitely for isa adapters

Untested due to lack of hardware

Signed-off-by: Andi Kleen <ak@suse.de>

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
+	if (device->host->sense_buffer_mask)
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
 
@@ -1607,9 +1620,6 @@ static bool __init BusLogic_ReadHostAdap
 	   BIOS_Address is 0.
 	 */
 	HostAdapter->BIOS_Address = ExtendedSetupInformation.BIOS_Address << 12;
-	/*
-	   ISA Host Adapters require Bounce Buffers if there is more than 16MB memory.
-	 */
 	if (HostAdapter->HostAdapterBusType == BusLogic_ISA_Bus && (void *) high_memory > (void *) MAX_DMA_ADDRESS)
 		HostAdapter->BounceBuffersRequired = true;
 	/*
@@ -2128,7 +2138,9 @@ static void __init BusLogic_InitializeHo
 	Host->this_id = HostAdapter->SCSI_ID;
 	Host->can_queue = HostAdapter->DriverQueueDepth;
 	Host->sg_tablesize = HostAdapter->DriverScatterGatherLimit;
-	Host->unchecked_isa_dma = HostAdapter->BounceBuffersRequired;
+	if (HostAdapter->BounceBuffersRequired) {
+		Host->sense_buffer_mask = DMA_24BIT_MASK;
+	}
 	Host->cmd_per_lun = HostAdapter->UntaggedQueueDepth;
 }
 
@@ -2142,7 +2154,7 @@ static void __init BusLogic_InitializeHo
 */
 static int BusLogic_SlaveConfigure(struct scsi_device *Device)
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Device->host->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(Device->host);
 	int TargetID = Device->id;
 	int QueueDepth = HostAdapter->QueueDepth[TargetID];
 
@@ -2167,6 +2179,35 @@ static int BusLogic_SlaveConfigure(struc
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
@@ -2267,12 +2308,12 @@ static int __init BusLogic_init(void)
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
@@ -2318,7 +2359,7 @@ static int __init BusLogic_init(void)
 				BusLogic_DestroyCCBs(HostAdapter);
 				BusLogic_ReleaseResources(HostAdapter);
 				list_del(&HostAdapter->host_list);
-				scsi_host_put(Host);
+				buslogic_free_host(Host);
 				ret = -ENOMEM;
 			} else {
 				BusLogic_InitializeHostStructure(HostAdapter,
@@ -2332,7 +2373,7 @@ static int __init BusLogic_init(void)
 					BusLogic_DestroyCCBs(HostAdapter);
 					BusLogic_ReleaseResources(HostAdapter);
 					list_del(&HostAdapter->host_list);
-					scsi_host_put(Host);
+					buslogic_free_host(Host);
 					ret = -ENODEV;
 				} else {
 					scsi_scan_host(Host);
@@ -2351,7 +2392,7 @@ static int __init BusLogic_init(void)
 			BusLogic_DestroyCCBs(HostAdapter);
 			BusLogic_ReleaseResources(HostAdapter);
 			list_del(&HostAdapter->host_list);
-			scsi_host_put(Host);
+			buslogic_free_host(Host);
 			ret = -ENODEV;
 		}
 	}
@@ -2395,7 +2436,7 @@ static int __exit BusLogic_ReleaseHostAd
 	 */
 	list_del(&HostAdapter->host_list);
 
-	scsi_host_put(Host);
+	buslogic_free_host(Host);
 	return 0;
 }
 
@@ -2783,7 +2824,7 @@ static bool BusLogic_WriteOutgoingMailbo
 
 static int BusLogic_host_reset(struct scsi_cmnd * SCpnt)
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) SCpnt->device->host->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(SCpnt->device->host);
 
 	unsigned int id = SCpnt->device->id;
 	struct BusLogic_TargetStatistics *stats = &HostAdapter->TargetStatistics[id];
@@ -2805,7 +2846,7 @@ static int BusLogic_host_reset(struct sc
 
 static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRoutine) (struct scsi_cmnd *))
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Command->device->host->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(Command->device->host);
 	struct BusLogic_TargetFlags *TargetFlags = &HostAdapter->TargetFlags[Command->device->id];
 	struct BusLogic_TargetStatistics *TargetStatistics = HostAdapter->TargetStatistics;
 	unsigned char *CDB = Command->cmnd;
@@ -2998,7 +3039,7 @@ static int BusLogic_QueueCommand(struct 
 
 static int BusLogic_AbortCommand(struct scsi_cmnd *Command)
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Command->device->host->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(Command->device->host);
 
 	int TargetID = Command->device->id;
 	struct BusLogic_CCB *CCB;
@@ -3128,7 +3169,7 @@ static int BusLogic_ResetHostAdapter(str
 
 static int BusLogic_BIOSDiskParameters(struct scsi_device *sdev, struct block_device *Device, sector_t capacity, int *Parameters)
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) sdev->host->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(sdev->host);
 	struct BIOS_DiskParameters *DiskParameters = (struct BIOS_DiskParameters *) Parameters;
 	unsigned char *buf;
 	if (HostAdapter->ExtendedTranslationEnabled && capacity >= 2 * 1024 * 1024 /* 1 GB in 512 byte sectors */ ) {
@@ -3199,7 +3240,7 @@ static int BusLogic_BIOSDiskParameters(s
 
 static int BusLogic_ProcDirectoryInfo(struct Scsi_Host *shost, char *ProcBuffer, char **StartPointer, off_t Offset, int BytesAvailable, int WriteFlag)
 {
-	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) shost->hostdata;
+	struct BusLogic_HostAdapter *HostAdapter = bl_shost_priv(shost);
 	struct BusLogic_TargetStatistics *TargetStatistics;
 	int TargetID, Length;
 	char *Buffer;
@@ -3572,9 +3613,9 @@ static struct scsi_host_template Bus_Log
 #if 0
 	.eh_abort_handler = BusLogic_AbortCommand,
 #endif
-	.unchecked_isa_dma = 1,
 	.max_sectors = 128,
 	.use_clustering = ENABLE_CLUSTERING,
+	.slave_alloc = buslogic_adjust_queue,
 };
 
 /*
