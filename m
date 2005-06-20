From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid: New products patch
Date: Mon, 20 Jun 2005 10:18:00 -0700
Message-ID: <1119287880.21986.16.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:58294 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261386AbVFTRSH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 13:18:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

This patch add the following products to the driver:
        IBM ServeRAID 8i
        ICP 9014R0
        ICP 9024R0
        ICP 9047MA
        ICP 9087MA
        ICP 9085LI
        ICP 5085AU

Patch updated to apply to the latest scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

 README    |    8 ++++++
 TODO      |    2 -
 aachba.c  |   44 +++++++++++++++++++++++++++++++--
 aacraid.h |   24 ++++++++++++++++++
 linit.c   |   81 +++++++++++++++++++++++++++++++++++++++-----------------------
 5 files changed, 125 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/aacraid/README b/drivers/scsi/aacraid/README
--- a/drivers/scsi/aacraid/README
+++ b/drivers/scsi/aacraid/README
@@ -13,6 +13,7 @@ Supported Cards/Chipsets
 	Adaptec 2020S
 	Adaptec 2025S
 	Adaptec 2120S
+	Adaptec 2130S
 	Adaptec 2200S
 	Adaptec 2230S
 	Adaptec 2240S
@@ -35,6 +36,13 @@ Supported Cards/Chipsets
 	HP NetRAID-4M
 	Legend S220
 	Legend S230
+	IBM ServeRAID 8i
+	ICP 9014R0
+	ICP 9024R0
+	ICP 9047MA
+	ICP 9087MA
+	ICP 9085LI
+	ICP 5085AU
 
 People
 -------------------------
diff --git a/drivers/scsi/aacraid/TODO b/drivers/scsi/aacraid/TODO
--- a/drivers/scsi/aacraid/TODO
+++ b/drivers/scsi/aacraid/TODO
@@ -1,6 +1,4 @@
 o	Testing
 o	More testing
-o	Feature request: display the firmware/bios/etc revisions in the
-	/proc info
 o	Drop irq_mask, basically unused
 o	I/O size increase
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -276,7 +276,6 @@ int aac_get_containers(struct aac_dev *d
 
 	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
 		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
-
 	fsa_dev_ptr = (struct fsa_dev_info *) kmalloc(
 	  sizeof(*fsa_dev_ptr) * maximum_num_containers, GFP_KERNEL);
 	if (!fsa_dev_ptr) {
@@ -527,6 +526,11 @@ static char *container_types[] = {
         "V-MIRRORS",          
         "PSEUDO R4",          
 	"RAID50",
+	"RAID5D",
+	"RAID5D0",
+	"RAID1E",
+	"RAID6",
+	"RAID60",
         "Unknown"
 };
 
@@ -610,7 +614,9 @@ int aac_get_adapter_info(struct aac_dev*
 	struct fib* fibptr;
 	int rcode;
 	u32 tmp;
-	struct aac_adapter_info * info;
+	struct aac_adapter_info *info;
+	struct aac_bus_info *command;
+	struct aac_bus_info_response *bus_info;
 
 	if (!(fibptr = fib_alloc(dev)))
 		return -ENOMEM;
@@ -655,6 +661,36 @@ int aac_get_adapter_info(struct aac_dev*
 			memcpy(&dev->supplement_adapter_info, info, sizeof(*info));
 	}
 
+
+	/* 
+	 * GetBusInfo 
+	 */
+
+	fib_init(fibptr);
+
+	bus_info = (struct aac_bus_info_response *) fib_data(fibptr);
+
+	memset(info,0,sizeof(*bus_info));
+
+	command = (struct aac_bus_info *)bus_info;
+
+	command->Command = cpu_to_le32(VM_Ioctl);
+	command->ObjType = cpu_to_le32(FT_DRIVE);
+	command->MethodId = cpu_to_le32(1);
+	command->CtlCmd = cpu_to_le32(GetBusInfo);
+
+	rcode = fib_send(ContainerCommand,
+			 fibptr,
+			 sizeof (*bus_info),
+			 FsaNormal,
+			 1, 1,
+			 NULL, NULL);
+
+	if (rcode >= 0 && le32_to_cpu(bus_info->Status) == ST_OK) {
+		dev->maximum_num_physicals = le32_to_cpu(bus_info->TargetsPerBus);
+		dev->maximum_num_channels = le32_to_cpu(bus_info->BusCount);
+	}
+
 	tmp = le32_to_cpu(dev->adapter_info.kernelrev);
 	printk(KERN_INFO "%s%d: kernel %d.%d-%d[%d] %.*s\n", 
 			dev->name, 
@@ -1818,7 +1854,9 @@ static int aac_send_srb_fib(struct scsi_
 	u32 flag;
 	u32 timeout;
 
-	if( scsicmd->device->id > 15 || scsicmd->device->lun > 7) {
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
+	if (scsicmd->device->id >= dev->maximum_num_physicals || 
+			scsicmd->device->lun > 7) {
 		scsicmd->result = DID_NO_CONNECT << 16;
 		scsicmd->scsi_done(scsicmd);
 		return 0;
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -845,6 +845,28 @@ struct aac_supplement_adapter_info
 #define AAC_SIS_VERSION_V3	3
 #define AAC_SIS_SLOT_UNKNOWN	0xFF
 
+#define GetBusInfo 0x00000009
+struct aac_bus_info {
+	__le32	Command;	/* VM_Ioctl */
+	__le32	ObjType;	/* FT_DRIVE */
+	__le32	MethodId;	/* 1 = SCSI Layer */
+	__le32	ObjectId;	/* Handle */
+	__le32	CtlCmd;		/* GetBusInfo */
+};
+
+struct aac_bus_info_response {
+	__le32	Status;		/* ST_OK */
+	__le32	ObjType;
+	__le32	MethodId;	/* unused */
+	__le32	ObjectId;	/* unused */
+	__le32	CtlCmd;		/* unused */
+	__le32	ProbeComplete;
+	__le32	BusCount;
+	__le32	TargetsPerBus;
+	u8	InitiatorBusId[10];
+	u8	BusValid[10];
+};
+
 /*
  * Battery platforms
  */
@@ -934,6 +956,8 @@ struct aac_dev
 
 	struct Scsi_Host	*scsi_host_ptr;
 	int			maximum_num_containers;
+	int			maximum_num_physicals;
+	int			maximum_num_channels;
 	struct fsa_dev_info	*fsa_dev;
 	pid_t			thread_pid;
 	int			cardtype;
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -102,32 +102,43 @@ static struct pci_device_id aac_pci_tbl[
 	{ 0x9005, 0x0286, 0x9005, 0x029b, 0, 0, 22 }, /* AAR-2820SA (Intruder) */
 	{ 0x9005, 0x0286, 0x9005, 0x029c, 0, 0, 23 }, /* AAR-2620SA (Intruder) */
 	{ 0x9005, 0x0286, 0x9005, 0x029d, 0, 0, 24 }, /* AAR-2420SA (Intruder) */
-	{ 0x9005, 0x0286, 0x9005, 0x0800, 0, 0, 25 }, /* Callisto Jupiter Platform */
-	{ 0x9005, 0x0285, 0x9005, 0x028e, 0, 0, 26 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
-	{ 0x9005, 0x0285, 0x9005, 0x028f, 0, 0, 27 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
-	{ 0x9005, 0x0285, 0x9005, 0x0290, 0, 0, 28 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
-	{ 0x9005, 0x0285, 0x1028, 0x0291, 0, 0, 29 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
-	{ 0x9005, 0x0285, 0x9005, 0x0292, 0, 0, 30 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
-	{ 0x9005, 0x0285, 0x9005, 0x0293, 0, 0, 31 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
-	{ 0x9005, 0x0285, 0x9005, 0x0294, 0, 0, 32 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
-	{ 0x9005, 0x0285, 0x103C, 0x3227, 0, 0, 33 }, /* AAR-2610SA PCI SATA 6ch */
-	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 34 }, /* ASR-2240S (SabreExpress) */
-	{ 0x9005, 0x0285, 0x9005, 0x0297, 0, 0, 35 }, /* ASR-4005SAS */
-	{ 0x9005, 0x0285, 0x1014, 0x02F2, 0, 0, 36 }, /* IBM 8i (AvonPark) */
-	{ 0x9005, 0x0285, 0x9005, 0x0298, 0, 0, 37 }, /* ASR-4000SAS (BlackBird) */
-	{ 0x9005, 0x0285, 0x9005, 0x0299, 0, 0, 38 }, /* ASR-4800SAS (Marauder-X) */
-	{ 0x9005, 0x0285, 0x9005, 0x029A, 0, 0, 39 }, /* ASR-4805SAS (Marauder-E) */
-
-	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 40 }, /* Perc 320/DC*/
-	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 41 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x0364, 0, 0, 42 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x1364, 0, 0, 43 }, /* Dell PERC2/QC */
-	{ 0x1011, 0x0046, 0x103c, 0x10c2, 0, 0, 44 }, /* HP NetRAID-4M */
-
-	{ 0x9005, 0x0285, 0x1028, PCI_ANY_ID, 0, 0, 45 }, /* Dell Catchall */
-	{ 0x9005, 0x0285, 0x17aa, PCI_ANY_ID, 0, 0, 46 }, /* Legend Catchall */
-	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 47 }, /* Adaptec Catch All */
-	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 48 }, /* Adaptec Rocket Catch All */
+	{ 0x9005, 0x0286, 0x9005, 0x029e, 0, 0, 25 }, /* ICP9024R0 (Lancer) */
+	{ 0x9005, 0x0286, 0x9005, 0x029f, 0, 0, 26 }, /* ICP9014R0 (Lancer) */
+	{ 0x9005, 0x0286, 0x9005, 0x02a0, 0, 0, 27 }, /* ICP9047MA (Lancer) */
+	{ 0x9005, 0x0286, 0x9005, 0x02a1, 0, 0, 28 }, /* ICP9087MA (Lancer) */
+	{ 0x9005, 0x0286, 0x9005, 0x02a3, 0, 0, 29 }, /* ICP5085AU (Hurricane) */
+	{ 0x9005, 0x0285, 0x9005, 0x02a4, 0, 0, 30 }, /* ICP9085LI (Marauder-X) */
+	{ 0x9005, 0x0285, 0x9005, 0x02a5, 0, 0, 31 }, /* ICP5085BR (Marauder-E) */
+	{ 0x9005, 0x0287, 0x9005, 0x0800, 0, 0, 32 }, /* Themisto Jupiter Platform */
+	{ 0x9005, 0x0200, 0x9005, 0x0200, 0, 0, 32 }, /* Themisto Jupiter Platform */
+	{ 0x9005, 0x0286, 0x9005, 0x0800, 0, 0, 33 }, /* Callisto Jupiter Platform */
+	{ 0x9005, 0x0285, 0x9005, 0x028e, 0, 0, 34 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
+	{ 0x9005, 0x0285, 0x9005, 0x028f, 0, 0, 35 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
+	{ 0x9005, 0x0285, 0x9005, 0x0290, 0, 0, 36 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
+	{ 0x9005, 0x0285, 0x1028, 0x0291, 0, 0, 37 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
+	{ 0x9005, 0x0285, 0x9005, 0x0292, 0, 0, 38 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
+	{ 0x9005, 0x0285, 0x9005, 0x0293, 0, 0, 39 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
+	{ 0x9005, 0x0285, 0x9005, 0x0294, 0, 0, 40 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
+	{ 0x9005, 0x0285, 0x103C, 0x3227, 0, 0, 41 }, /* AAR-2610SA PCI SATA 6ch */
+	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 42 }, /* ASR-2240S (SabreExpress) */
+	{ 0x9005, 0x0285, 0x9005, 0x0297, 0, 0, 43 }, /* ASR-4005SAS */
+	{ 0x9005, 0x0285, 0x1014, 0x02F2, 0, 0, 44 }, /* IBM 8i (AvonPark) */
+	{ 0x9005, 0x0285, 0x1014, 0x0312, 0, 0, 44 }, /* IBM 8i (AvonPark Lite) */
+	{ 0x9005, 0x0285, 0x9005, 0x0298, 0, 0, 45 }, /* ASR-4000SAS (BlackBird) */
+	{ 0x9005, 0x0285, 0x9005, 0x0299, 0, 0, 46 }, /* ASR-4800SAS (Marauder-X) */
+	{ 0x9005, 0x0285, 0x9005, 0x029a, 0, 0, 47 }, /* ASR-4805SAS (Marauder-E) */
+	{ 0x9005, 0x0286, 0x9005, 0x02a2, 0, 0, 48 }, /* ASR-4810SAS (Hurricane */
+
+	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 49 }, /* Perc 320/DC*/
+	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 50 }, /* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x0364, 0, 0, 51 }, /* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x1364, 0, 0, 52 }, /* Dell PERC2/QC */
+	{ 0x1011, 0x0046, 0x103c, 0x10c2, 0, 0, 53 }, /* HP NetRAID-4M */
+
+	{ 0x9005, 0x0285, 0x1028, PCI_ANY_ID, 0, 0, 54 }, /* Dell Catchall */
+	{ 0x9005, 0x0285, 0x17aa, PCI_ANY_ID, 0, 0, 55 }, /* Legend Catchall */
+	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 56 }, /* Adaptec Catch All */
+	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 57 }, /* Adaptec Rocket Catch All */
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
@@ -164,6 +175,14 @@ static struct aac_driver_ident aac_drive
 	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "AAR-2820SA      ", 1 }, /* AAR-2820SA (Intruder) */
 	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "AAR-2620SA      ", 1 }, /* AAR-2620SA (Intruder) */
 	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "AAR-2420SA      ", 1 }, /* AAR-2420SA (Intruder) */
+	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9024R0       ", 2 }, /* ICP9024R0 (Lancer) */
+	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9014R0       ", 1 }, /* ICP9014R0 (Lancer) */
+	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9047MA       ", 1 }, /* ICP9047MA (Lancer) */
+	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9087MA       ", 1 }, /* ICP9087MA (Lancer) */
+	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP5085AU       ", 1 }, /* ICP5085AU (Hurricane) */
+	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9085LI       ", 1 }, /* ICP9085LI (Marauder-X) */
+	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP5085BR       ", 1 }, /* ICP5085BR (Marauder-E) */
+	{ NULL        , "aacraid",  "ADAPTEC ", "Themisto        ", 0, AAC_QUIRK_SLAVE }, /* Jupiter Platform */
 	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "Callisto        ", 2, AAC_QUIRK_MASTER }, /* Jupiter Platform */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020SA       ", 1 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2025SA       ", 1 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
@@ -175,10 +194,11 @@ static struct aac_driver_ident aac_drive
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2610SA      ", 1 }, /* SATA 6Ch (Bearcat) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2240S       ", 1 }, /* ASR-2240S (SabreExpress) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4005SAS     ", 1 }, /* ASR-4005SAS */
-	{ aac_rx_init, "aacraid",  "IBM     ", "ServeRAID 8i    ", 1 }, /* IBM 8i (AvonPark) */
+	{ aac_rx_init, "ServeRAID","IBM     ", "ServeRAID 8i    ", 1 }, /* IBM 8i (AvonPark) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4000SAS     ", 1 }, /* ASR-4000SAS (BlackBird & AvonPark) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4800SAS     ", 1 }, /* ASR-4800SAS (Marauder-X) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4805SAS     ", 1 }, /* ASR-4805SAS (Marauder-E) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4810SAS     ", 1 }, /* ASR-4810SAS (Hurricane) */
 
 	{ aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Perc 320/DC*/
 	{ aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4, AAC_QUIRK_34SG }, /* Adaptec 5400S (Mustang)*/
@@ -681,7 +701,7 @@ static struct scsi_host_template aac_dri
 	.slave_configure		= aac_slave_configure,
 	.eh_host_reset_handler		= aac_eh_reset,
 	.can_queue      		= AAC_NUM_IO_FIB,	
-	.this_id        		= 16,
+	.this_id        		= MAXIMUM_NUM_CONTAINERS,
 	.sg_tablesize   		= 16,
 	.max_sectors    		= 128,
 #if (AAC_NUM_IO_FIB > 256)
@@ -760,6 +780,7 @@ static int __devinit aac_probe_one(struc
 		if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL))
 			goto out_free_fibs;
 
+	aac->maximum_num_channels = aac_drivers[index].channels;
 	aac_get_adapter_info(aac);
 
 	/*
@@ -786,7 +807,7 @@ static int __devinit aac_probe_one(struc
 	 * physical channels are address by their actual physical number+1
 	 */
 	if (aac->nondasd_support == 1)
-		shost->max_channel = aac_drivers[index].channels+1;
+		shost->max_channel = aac->maximum_num_channels + 1;
 	else
 		shost->max_channel = 1;
 
@@ -795,6 +816,8 @@ static int __devinit aac_probe_one(struc
 	list_add(&aac->entry, insert);
 
 	shost->max_id = aac->maximum_num_containers;
+	if (shost->max_id < aac->maximum_num_physicals)
+		shost->max_id = aac->maximum_num_physicals;
 	if (shost->max_id < MAXIMUM_NUM_CONTAINERS)
 		shost->max_id = MAXIMUM_NUM_CONTAINERS;
 	else

-- 
Mark Haverkamp <markh@osdl.org>

