From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V4 03/24] aacraid: added support for init_struct_8
Date: Thu, 2 Feb 2017 15:53:17 -0800
Message-ID: <20170202235338.14724-4-RaghavaAditya.Renukunta@microsemi.com>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0070.outbound.protection.outlook.com ([104.47.40.70]:43072
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752508AbdBCGar (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 01:30:47 -0500
In-Reply-To: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de

This  patch lays the groundwork for supporting the new HBA-1000 controller
family.A new INIT structure INIT_STRUCT_8 has been added which allows for a
variable size for MSI-x vectors among other things,  and is used for both
Series-8, HBA-1000 and SmartIOC-2000.

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---

Changes in  V2:
None

Changes in V3:
Removed Camel Case header variable definitions

Changes in  V4:
None

 drivers/scsi/aacraid/aachba.c   |   8 +-
 drivers/scsi/aacraid/aacraid.h  | 100 +++++++++++------
 drivers/scsi/aacraid/comminit.c | 239 +++++++++++++++++++++++++---------------
 drivers/scsi/aacraid/commsup.c  |  13 ++-
 drivers/scsi/aacraid/linit.c    |   2 +-
 drivers/scsi/aacraid/rkt.c      |   2 +-
 drivers/scsi/aacraid/rx.c       |   4 +-
 drivers/scsi/aacraid/sa.c       |   4 +-
 drivers/scsi/aacraid/src.c      |  27 +++--
 9 files changed, 261 insertions(+), 138 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 6678d1f..8a58b96 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1144,7 +1144,9 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 	long ret;
 
 	aac_fib_init(fib);
-	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2 && !dev->sync_mode) {
+	if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE2 ||
+		dev->comm_interface == AAC_COMM_MESSAGE_TYPE3) &&
+		!dev->sync_mode) {
 		struct aac_raw_io2 *readcmd2;
 		readcmd2 = (struct aac_raw_io2 *) fib_data(fib);
 		memset(readcmd2, 0, sizeof(struct aac_raw_io2));
@@ -1270,7 +1272,9 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
 	long ret;
 
 	aac_fib_init(fib);
-	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2 && !dev->sync_mode) {
+	if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE2 ||
+		dev->comm_interface == AAC_COMM_MESSAGE_TYPE3) &&
+		!dev->sync_mode) {
 		struct aac_raw_io2 *writecmd2;
 		writecmd2 = (struct aac_raw_io2 *) fib_data(fib);
 		memset(writecmd2, 0, sizeof(struct aac_raw_io2));
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 01b457b..f712d8d 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -82,6 +82,11 @@ enum {
 #define AAC_DEBUG_INSTRUMENT_AIF_DELETE
 
 /*
+ * Interrupts
+ */
+#define AAC_MAX_HRRQ		64
+
+/*
  * These macros convert from physical channels to virtual channels
  */
 #define CONTAINER_CHANNEL		(0)
@@ -491,41 +496,64 @@ enum fib_xfer_state {
 #define ADAPTER_INIT_STRUCT_REVISION_4		4 // rocket science
 #define ADAPTER_INIT_STRUCT_REVISION_6		6 /* PMC src */
 #define ADAPTER_INIT_STRUCT_REVISION_7		7 /* Denali */
+#define ADAPTER_INIT_STRUCT_REVISION_8		8 // Thor
 
-struct aac_init
+union aac_init
 {
-	__le32	InitStructRevision;
-	__le32	Sa_MSIXVectors;
-	__le32	fsrev;
-	__le32	CommHeaderAddress;
-	__le32	FastIoCommAreaAddress;
-	__le32	AdapterFibsPhysicalAddress;
-	__le32	AdapterFibsVirtualAddress;
-	__le32	AdapterFibsSize;
-	__le32	AdapterFibAlign;
-	__le32	printfbuf;
-	__le32	printfbufsiz;
-	__le32	HostPhysMemPages;   /* number of 4k pages of host
-				       physical memory */
-	__le32	HostElapsedSeconds; /* number of seconds since 1970. */
-	/*
-	 * ADAPTER_INIT_STRUCT_REVISION_4 begins here
-	 */
-	__le32	InitFlags;	/* flags for supported features */
+	struct _r7 {
+		__le32	init_struct_revision;
+		__le32	no_of_msix_vectors;
+		__le32	fsrev;
+		__le32	comm_header_address;
+		__le32	fast_io_comm_area_address;
+		__le32	adapter_fibs_physical_address;
+		__le32	adapter_fibs_virtual_address;
+		__le32	adapter_fibs_size;
+		__le32	adapter_fib_align;
+		__le32	printfbuf;
+		__le32	printfbufsiz;
+		/* number of 4k pages of host phys. mem. */
+		__le32	host_phys_mem_pages;
+		/* number of seconds since 1970. */
+		__le32	host_elapsed_seconds;
+		/* ADAPTER_INIT_STRUCT_REVISION_4 begins here */
+		__le32	init_flags;	/* flags for supported features */
 #define INITFLAGS_NEW_COMM_SUPPORTED	0x00000001
 #define INITFLAGS_DRIVER_USES_UTC_TIME	0x00000010
 #define INITFLAGS_DRIVER_SUPPORTS_PM	0x00000020
 #define INITFLAGS_NEW_COMM_TYPE1_SUPPORTED	0x00000040
 #define INITFLAGS_FAST_JBOD_SUPPORTED	0x00000080
 #define INITFLAGS_NEW_COMM_TYPE2_SUPPORTED	0x00000100
-	__le32	MaxIoCommands;	/* max outstanding commands */
-	__le32	MaxIoSize;	/* largest I/O command */
-	__le32	MaxFibSize;	/* largest FIB to adapter */
-	/* ADAPTER_INIT_STRUCT_REVISION_5 begins here */
-	__le32	MaxNumAif;	/* max number of aif */
-	/* ADAPTER_INIT_STRUCT_REVISION_6 begins here */
-	__le32	HostRRQ_AddrLow;
-	__le32	HostRRQ_AddrHigh;	/* Host RRQ (response queue) for SRC */
+#define INITFLAGS_DRIVER_SUPPORTS_HBA_MODE  0x00000400
+		__le32	max_io_commands;	/* max outstanding commands */
+		__le32	max_io_size;	/* largest I/O command */
+		__le32	max_fib_size;	/* largest FIB to adapter */
+		/* ADAPTER_INIT_STRUCT_REVISION_5 begins here */
+		__le32	max_num_aif;	/* max number of aif */
+		/* ADAPTER_INIT_STRUCT_REVISION_6 begins here */
+		/* Host RRQ (response queue) for SRC */
+		__le32	host_rrq_addr_low;
+		__le32	host_rrq_addr_high;
+	} r7;
+	struct _r8 {
+		/* ADAPTER_INIT_STRUCT_REVISION_8 */
+		__le32	init_struct_revision;
+		__le32	rr_queue_count;
+		__le32	host_elapsed_seconds; /* number of secs since 1970. */
+		__le32	init_flags;
+		__le32	max_io_size;	/* largest I/O command */
+		__le32	max_num_aif;	/* max number of aif */
+		__le32	reserved1;
+		__le32	reserved2;
+		struct _rrq {
+			__le32	host_addr_low;
+			__le32	host_addr_high;
+			__le16	msix_id;
+			__le16	element_count;
+			__le16	comp_thresh;
+			__le16	unused;
+		} rrq[1];		/* up to 64 RRQ addresses */
+	} r8;
 };
 
 enum aac_log_level {
@@ -729,6 +757,7 @@ struct sa_registers {
 
 
 #define SA_INIT_NUM_MSIXVECTORS		1
+#define SA_MINIPORT_REVISION		SA_INIT_NUM_MSIXVECTORS
 
 #define sa_readw(AEP, CSR)		readl(&((AEP)->regs.sa->CSR))
 #define sa_readl(AEP, CSR)		readl(&((AEP)->regs.sa->CSR))
@@ -1106,6 +1135,12 @@ struct aac_bus_info_response {
 #define AAC_OPT_NEW_COMM_TYPE3		cpu_to_le32(1<<30)
 #define AAC_OPT_NEW_COMM_TYPE4		cpu_to_le32(1<<31)
 
+#define AAC_COMM_PRODUCER		0
+#define AAC_COMM_MESSAGE		1
+#define AAC_COMM_MESSAGE_TYPE1		3
+#define AAC_COMM_MESSAGE_TYPE2		4
+#define AAC_COMM_MESSAGE_TYPE3		5
+
 /* MSIX context */
 struct aac_msix_ctx {
 	int		vector_no;
@@ -1159,8 +1194,11 @@ struct aac_dev
 
 	resource_size_t		base_size, dbg_size;	/* Size of
 							 *  mapped in region */
-
-	struct aac_init		*init;		/* Holds initialization info to communicate with adapter */
+	/*
+	 * Holds initialization info
+	 * to communicate with adapter
+	 */
+	union aac_init		*init;
 	dma_addr_t		init_pa;	/* Holds physical address of the init struct */
 
 	u32			*host_rrq;	/* response queue
@@ -1229,10 +1267,6 @@ struct aac_dev
 	u8			needs_dac;
 	u8			raid_scsi_mode;
 	u8			comm_interface;
-#	define AAC_COMM_PRODUCER 0
-#	define AAC_COMM_MESSAGE  1
-#	define AAC_COMM_MESSAGE_TYPE1	3
-#	define AAC_COMM_MESSAGE_TYPE2	4
 	u8			raw_io_interface;
 	u8			raw_io_64;
 	u8			printf_enabled;
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 4f56b10..480ff01 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -68,104 +68,167 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 	unsigned long size, align;
 	const unsigned long fibsize = dev->max_fib_size;
 	const unsigned long printfbufsiz = 256;
-	unsigned long host_rrq_size = 0;
-	struct aac_init *init;
+	unsigned long host_rrq_size, aac_init_size;
+	union aac_init *init;
 	dma_addr_t phys;
 	unsigned long aac_max_hostphysmempages;
 
-	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE1 ||
-	    dev->comm_interface == AAC_COMM_MESSAGE_TYPE2)
-		host_rrq_size = (dev->scsi_host_ptr->can_queue
-			+ AAC_NUM_MGT_FIB) * sizeof(u32);
-	size = fibsize + sizeof(struct aac_init) + commsize +
-			commalign + printfbufsiz + host_rrq_size;
- 
+	if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE1) ||
+		(dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) ||
+		(dev->comm_interface == AAC_COMM_MESSAGE_TYPE3))
+		host_rrq_size =
+			(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB)
+				* sizeof(u32);
+	else
+		host_rrq_size = 0;
+
+	aac_init_size = sizeof(union aac_init);
+	size = fibsize + aac_init_size + commsize + commalign +
+			printfbufsiz + host_rrq_size;
+
 	base = pci_alloc_consistent(dev->pdev, size, &phys);
 
-	if(base == NULL)
-	{
+	if (base == NULL) {
 		printk(KERN_ERR "aacraid: unable to create mapping.\n");
 		return 0;
 	}
+
 	dev->comm_addr = (void *)base;
 	dev->comm_phys = phys;
 	dev->comm_size = size;
-	
-	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE1 ||
-	    dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) {
+
+	if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE1) ||
+	    (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) ||
+	    (dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)) {
 		dev->host_rrq = (u32 *)(base + fibsize);
 		dev->host_rrq_pa = phys + fibsize;
 		memset(dev->host_rrq, 0, host_rrq_size);
 	}
 
-	dev->init = (struct aac_init *)(base + fibsize + host_rrq_size);
+	dev->init = (union aac_init *)(base + fibsize + host_rrq_size);
 	dev->init_pa = phys + fibsize + host_rrq_size;
 
 	init = dev->init;
 
-	init->InitStructRevision = cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION);
-	if (dev->max_fib_size != sizeof(struct hw_fib))
-		init->InitStructRevision = cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_4);
-	init->Sa_MSIXVectors = cpu_to_le32(SA_INIT_NUM_MSIXVECTORS);
-	init->fsrev = cpu_to_le32(dev->fsrev);
+	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE3) {
+		int i;
+		u64 addr;
+
+		init->r8.init_struct_revision =
+			cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_8);
+		init->r8.init_flags = cpu_to_le32(INITFLAGS_NEW_COMM_SUPPORTED |
+					INITFLAGS_DRIVER_USES_UTC_TIME |
+					INITFLAGS_DRIVER_SUPPORTS_PM);
+		init->r8.init_flags |=
+				cpu_to_le32(INITFLAGS_DRIVER_SUPPORTS_HBA_MODE);
+		init->r8.rr_queue_count = cpu_to_le32(dev->max_msix);
+		init->r8.max_io_size =
+			cpu_to_le32(dev->scsi_host_ptr->max_sectors << 9);
+		init->r8.max_num_aif = init->r8.reserved1 =
+			init->r8.reserved2 = 0;
+
+		for (i = 0; i < dev->max_msix; i++) {
+			addr = (u64)dev->host_rrq_pa + dev->vector_cap * i *
+					sizeof(u32);
+			init->r8.rrq[i].host_addr_high = cpu_to_le32(
+						upper_32_bits(addr));
+			init->r8.rrq[i].host_addr_low = cpu_to_le32(
+						lower_32_bits(addr));
+			init->r8.rrq[i].msix_id = i;
+			init->r8.rrq[i].element_count = cpu_to_le16(
+					(u16)dev->vector_cap);
+			init->r8.rrq[i].comp_thresh =
+					init->r8.rrq[i].unused = 0;
+		}
 
-	/*
-	 *	Adapter Fibs are the first thing allocated so that they
-	 *	start page aligned
-	 */
-	dev->aif_base_va = (struct hw_fib *)base;
-	
-	init->AdapterFibsVirtualAddress = 0;
-	init->AdapterFibsPhysicalAddress = cpu_to_le32((u32)phys);
-	init->AdapterFibsSize = cpu_to_le32(fibsize);
-	init->AdapterFibAlign = cpu_to_le32(sizeof(struct hw_fib));
-	/*
-	 * number of 4k pages of host physical memory. The aacraid fw needs
-	 * this number to be less than 4gb worth of pages. New firmware doesn't
-	 * have any issues with the mapping system, but older Firmware did, and
-	 * had *troubles* dealing with the math overloading past 32 bits, thus
-	 * we must limit this field.
-	 */
-	aac_max_hostphysmempages = dma_get_required_mask(&dev->pdev->dev) >> 12;
-	if (aac_max_hostphysmempages < AAC_MAX_HOSTPHYSMEMPAGES)
-		init->HostPhysMemPages = cpu_to_le32(aac_max_hostphysmempages);
-	else
-		init->HostPhysMemPages = cpu_to_le32(AAC_MAX_HOSTPHYSMEMPAGES);
-
-	init->InitFlags = cpu_to_le32(INITFLAGS_DRIVER_USES_UTC_TIME |
-		INITFLAGS_DRIVER_SUPPORTS_PM);
-	init->MaxIoCommands = cpu_to_le32(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
-	init->MaxIoSize = cpu_to_le32(dev->scsi_host_ptr->max_sectors << 9);
-	init->MaxFibSize = cpu_to_le32(dev->max_fib_size);
-	init->MaxNumAif = cpu_to_le32(dev->max_num_aif);
-
-	if (dev->comm_interface == AAC_COMM_MESSAGE) {
-		init->InitFlags |= cpu_to_le32(INITFLAGS_NEW_COMM_SUPPORTED);
-		dprintk((KERN_WARNING"aacraid: New Comm Interface enabled\n"));
-	} else if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE1) {
-		init->InitStructRevision = cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_6);
-		init->InitFlags |= cpu_to_le32(INITFLAGS_NEW_COMM_SUPPORTED |
-			INITFLAGS_NEW_COMM_TYPE1_SUPPORTED | INITFLAGS_FAST_JBOD_SUPPORTED);
-		init->HostRRQ_AddrHigh = cpu_to_le32((u32)((u64)dev->host_rrq_pa >> 32));
-		init->HostRRQ_AddrLow = cpu_to_le32((u32)(dev->host_rrq_pa & 0xffffffff));
-		dprintk((KERN_WARNING"aacraid: New Comm Interface type1 enabled\n"));
-	} else if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) {
-		init->InitStructRevision = cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_7);
-		init->InitFlags |= cpu_to_le32(INITFLAGS_NEW_COMM_SUPPORTED |
-			INITFLAGS_NEW_COMM_TYPE2_SUPPORTED | INITFLAGS_FAST_JBOD_SUPPORTED);
-		init->HostRRQ_AddrHigh = cpu_to_le32((u32)((u64)dev->host_rrq_pa >> 32));
-		init->HostRRQ_AddrLow = cpu_to_le32((u32)(dev->host_rrq_pa & 0xffffffff));
-		/* number of MSI-X */
-		init->Sa_MSIXVectors = cpu_to_le32(dev->max_msix);
-		dprintk((KERN_WARNING"aacraid: New Comm Interface type2 enabled\n"));
+		pr_warn("aacraid: Comm Interface type3 enabled\n");
+	} else {
+		init->r7.init_struct_revision =
+			cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION);
+		if (dev->max_fib_size != sizeof(struct hw_fib))
+			init->r7.init_struct_revision =
+				cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_4);
+		init->r7.no_of_msix_vectors = cpu_to_le32(SA_MINIPORT_REVISION);
+		init->r7.fsrev = cpu_to_le32(dev->fsrev);
+
+		/*
+		 *	Adapter Fibs are the first thing allocated so that they
+		 *	start page aligned
+		 */
+		dev->aif_base_va = (struct hw_fib *)base;
+
+		init->r7.adapter_fibs_virtual_address = 0;
+		init->r7.adapter_fibs_physical_address = cpu_to_le32((u32)phys);
+		init->r7.adapter_fibs_size = cpu_to_le32(fibsize);
+		init->r7.adapter_fib_align = cpu_to_le32(sizeof(struct hw_fib));
+
+		/*
+		 * number of 4k pages of host physical memory. The aacraid fw
+		 * needs this number to be less than 4gb worth of pages. New
+		 * firmware doesn't have any issues with the mapping system, but
+		 * older Firmware did, and had *troubles* dealing with the math
+		 * overloading past 32 bits, thus we must limit this field.
+		 */
+		aac_max_hostphysmempages =
+				dma_get_required_mask(&dev->pdev->dev) >> 12;
+		if (aac_max_hostphysmempages < AAC_MAX_HOSTPHYSMEMPAGES)
+			init->r7.host_phys_mem_pages =
+					cpu_to_le32(aac_max_hostphysmempages);
+		else
+			init->r7.host_phys_mem_pages =
+					cpu_to_le32(AAC_MAX_HOSTPHYSMEMPAGES);
+
+		init->r7.init_flags =
+			cpu_to_le32(INITFLAGS_DRIVER_USES_UTC_TIME |
+			INITFLAGS_DRIVER_SUPPORTS_PM);
+		init->r7.max_io_commands =
+			cpu_to_le32(dev->scsi_host_ptr->can_queue +
+					AAC_NUM_MGT_FIB);
+		init->r7.max_io_size =
+			cpu_to_le32(dev->scsi_host_ptr->max_sectors << 9);
+		init->r7.max_fib_size = cpu_to_le32(dev->max_fib_size);
+		init->r7.max_num_aif = cpu_to_le32(dev->max_num_aif);
+
+		if (dev->comm_interface == AAC_COMM_MESSAGE) {
+			init->r7.init_flags |=
+				cpu_to_le32(INITFLAGS_NEW_COMM_SUPPORTED);
+			pr_warn("aacraid: Comm Interface enabled\n");
+		} else if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE1) {
+			init->r7.init_struct_revision =
+				cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_6);
+			init->r7.init_flags |=
+				cpu_to_le32(INITFLAGS_NEW_COMM_SUPPORTED |
+				INITFLAGS_NEW_COMM_TYPE1_SUPPORTED |
+				INITFLAGS_FAST_JBOD_SUPPORTED);
+			init->r7.host_rrq_addr_high =
+				cpu_to_le32(upper_32_bits(dev->host_rrq_pa));
+			init->r7.host_rrq_addr_low =
+				cpu_to_le32(lower_32_bits(dev->host_rrq_pa));
+			pr_warn("aacraid: Comm Interface type1 enabled\n");
+		} else if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) {
+			init->r7.init_struct_revision =
+				cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_7);
+			init->r7.init_flags |=
+				cpu_to_le32(INITFLAGS_NEW_COMM_SUPPORTED |
+				INITFLAGS_NEW_COMM_TYPE2_SUPPORTED |
+				INITFLAGS_FAST_JBOD_SUPPORTED);
+			init->r7.host_rrq_addr_high =
+				cpu_to_le32(upper_32_bits(dev->host_rrq_pa));
+			init->r7.host_rrq_addr_low =
+				cpu_to_le32(lower_32_bits(dev->host_rrq_pa));
+			init->r7.no_of_msix_vectors =
+				cpu_to_le32(dev->max_msix);
+			/* must be the COMM_PREFERRED_SETTINGS values */
+			pr_warn("aacraid: Comm Interface type2 enabled\n");
+		}
 	}
 
 	/*
 	 * Increment the base address by the amount already used
 	 */
-	base = base + fibsize + host_rrq_size + sizeof(struct aac_init);
+	base = base + fibsize + host_rrq_size + aac_init_size;
 	phys = (dma_addr_t)((ulong)phys + fibsize + host_rrq_size +
-		sizeof(struct aac_init));
+			aac_init_size);
 
 	/*
 	 *	Align the beginning of Headers to commalign
@@ -177,7 +240,8 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 	 *	Fill in addresses of the Comm Area Headers and Queues
 	 */
 	*commaddr = base;
-	init->CommHeaderAddress = cpu_to_le32((u32)phys);
+	if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE3)
+		init->r7.comm_header_address = cpu_to_le32((u32)phys);
 	/*
 	 *	Increment the base address by the size of the CommArea
 	 */
@@ -187,12 +251,14 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 	 *	 Place the Printf buffer area after the Fast I/O comm area.
 	 */
 	dev->printfbuf = (void *)base;
-	init->printfbuf = cpu_to_le32(phys);
-	init->printfbufsiz = cpu_to_le32(printfbufsiz);
+	if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE3) {
+		init->r7.printfbuf = cpu_to_le32(phys);
+		init->r7.printfbufsiz = cpu_to_le32(printfbufsiz);
+	}
 	memset(base, 0, printfbufsiz);
 	return 1;
 }
-    
+
 static void aac_queue_init(struct aac_dev * dev, struct aac_queue * q, u32 *mem, int qsize)
 {
 	atomic_set(&q->numpending, 0);
@@ -436,26 +502,27 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 
 	if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
 		0, 0, 0, 0, 0, 0,
-		status+0, status+1, status+2, status+3, NULL)) &&
-	 		(status[0] == 0x00000001)) {
+		status+0, status+1, status+2, status+3, status+4)) &&
+		(status[0] == 0x00000001)) {
 		dev->doorbell_mask = status[3];
-		if (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_64))
+		if (status[1] & AAC_OPT_NEW_COMM_64)
 			dev->raw_io_64 = 1;
 		dev->sync_mode = aac_sync_mode;
 		if (dev->a_ops.adapter_comm &&
-			(status[1] & le32_to_cpu(AAC_OPT_NEW_COMM))) {
+			(status[1] & AAC_OPT_NEW_COMM)) {
 				dev->comm_interface = AAC_COMM_MESSAGE;
 				dev->raw_io_interface = 1;
-			if ((status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_TYPE1))) {
+			if ((status[1] & AAC_OPT_NEW_COMM_TYPE1)) {
 				/* driver supports TYPE1 (Tupelo) */
 				dev->comm_interface = AAC_COMM_MESSAGE_TYPE1;
-			} else if ((status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_TYPE2))) {
-				/* driver supports TYPE2 (Denali) */
+			} else if (status[1] & AAC_OPT_NEW_COMM_TYPE2) {
+				/* driver supports TYPE2 (Denali, Yosemite) */
 				dev->comm_interface = AAC_COMM_MESSAGE_TYPE2;
-			} else if ((status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_TYPE4)) ||
-				  (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_TYPE3))) {
-				/* driver doesn't TYPE3 and TYPE4 */
-				/* switch to sync. mode */
+			} else if (status[1] & AAC_OPT_NEW_COMM_TYPE3) {
+				/* driver supports TYPE3 (Yosemite, Thor) */
+				dev->comm_interface = AAC_COMM_MESSAGE_TYPE3;
+			} else if (status[1] & AAC_OPT_NEW_COMM_TYPE4) {
+				/* not supported TYPE - switch to sync. mode */
 				dev->comm_interface = AAC_COMM_MESSAGE_TYPE2;
 				dev->sync_mode = 1;
 			}
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 9e7551f..d18ed9a 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -129,11 +129,14 @@ int aac_fib_setup(struct aac_dev * dev)
 	struct hw_fib *hw_fib;
 	dma_addr_t hw_fib_pa;
 	int i;
+	u32 max_cmds;
 
 	while (((i = fib_map_alloc(dev)) == -ENOMEM)
 	 && (dev->scsi_host_ptr->can_queue > (64 - AAC_NUM_MGT_FIB))) {
-		dev->init->MaxIoCommands = cpu_to_le32((dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) >> 1);
-		dev->scsi_host_ptr->can_queue = le32_to_cpu(dev->init->MaxIoCommands) - AAC_NUM_MGT_FIB;
+		max_cmds = (dev->scsi_host_ptr->can_queue+AAC_NUM_MGT_FIB) >> 1;
+		dev->scsi_host_ptr->can_queue = max_cmds - AAC_NUM_MGT_FIB;
+		if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE3)
+			dev->init->r7.max_io_commands = cpu_to_le32(max_cmds);
 	}
 	if (i<0)
 		return -ENOMEM;
@@ -761,7 +764,8 @@ int aac_fib_adapter_complete(struct fib *fibptr, unsigned short size)
 	unsigned long qflags;
 
 	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE1 ||
-	    dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) {
+		dev->comm_interface == AAC_COMM_MESSAGE_TYPE2 ||
+		dev->comm_interface == AAC_COMM_MESSAGE_TYPE3) {
 		kfree(hw_fib);
 		return 0;
 	}
@@ -1817,7 +1821,8 @@ int aac_command_thread(void *data)
 				 * and pre-allocate a set of fibs outside the
 				 * lock.
 				 */
-				num = le32_to_cpu(dev->init->AdapterFibsSize)
+				num = le32_to_cpu(dev->init->
+							r7.adapter_fibs_size)
 				    / sizeof(struct hw_fib); /* some extra */
 				spin_lock_irqsave(&dev->fib_lock, flagv);
 				entry = dev->fib_list.next;
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index fd26a2d..0f3de1e 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1368,7 +1368,7 @@ static int aac_acquire_resources(struct aac_dev *dev)
 		/* After EEH recovery or suspend resume, max_msix count
 		 * may change, therfore updating in init as well.
 		 */
-		dev->init->Sa_MSIXVectors = cpu_to_le32(dev->max_msix);
+		dev->init->r7.no_of_msix_vectors = cpu_to_le32(dev->max_msix);
 		aac_adapter_start(dev);
 	}
 	return 0;
diff --git a/drivers/scsi/aacraid/rkt.c b/drivers/scsi/aacraid/rkt.c
index 7d8013f..6dff8ad 100644
--- a/drivers/scsi/aacraid/rkt.c
+++ b/drivers/scsi/aacraid/rkt.c
@@ -60,7 +60,7 @@ static int aac_rkt_select_comm(struct aac_dev *dev, int comm)
 		 * case warrants this half baked, but convenient, check here.
 		 */
 		if (dev->scsi_host_ptr->can_queue > AAC_NUM_IO_FIB_RKT) {
-			dev->init->MaxIoCommands =
+			dev->init->r7.max_io_commands =
 				cpu_to_le32(AAC_NUM_IO_FIB_RKT + AAC_NUM_MGT_FIB);
 			dev->scsi_host_ptr->can_queue = AAC_NUM_IO_FIB_RKT;
 		}
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index ac16380..67213b9 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -315,10 +315,10 @@ static void aac_rx_notify_adapter(struct aac_dev *dev, u32 event)
 
 static void aac_rx_start_adapter(struct aac_dev *dev)
 {
-	struct aac_init *init;
+	union aac_init *init;
 
 	init = dev->init;
-	init->HostElapsedSeconds = cpu_to_le32(get_seconds());
+	init->r7.host_elapsed_seconds = cpu_to_le32(get_seconds());
 	// We can only use a 32 bit address here
 	rx_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa,
 	  0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL);
diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
index 869aea2..b8538e0 100644
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -245,12 +245,12 @@ static void aac_sa_interrupt_adapter (struct aac_dev *dev)
 
 static void aac_sa_start_adapter(struct aac_dev *dev)
 {
-	struct aac_init *init;
+	union aac_init *init;
 	/*
 	 * Fill in the remaining pieces of the init.
 	 */
 	init = dev->init;
-	init->HostElapsedSeconds = cpu_to_le32(get_seconds());
+	init->r7.host_elapsed_seconds = cpu_to_le32(get_seconds());
 	/* We can only use a 32 bit address here */
 	sa_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, 
 			(u32)(ulong)dev->init_pa, 0, 0, 0, 0, 0,
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 0c45388..a5f7a6f 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -384,7 +384,7 @@ static void aac_src_notify_adapter(struct aac_dev *dev, u32 event)
 
 static void aac_src_start_adapter(struct aac_dev *dev)
 {
-	struct aac_init *init;
+	union aac_init *init;
 	int i;
 
 	 /* reset host_rrq_idx first */
@@ -395,11 +395,22 @@ static void aac_src_start_adapter(struct aac_dev *dev)
 	dev->fibs_pushed_no = 0;
 
 	init = dev->init;
-	init->HostElapsedSeconds = cpu_to_le32(get_seconds());
+	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE3) {
+		init->r8.host_elapsed_seconds = cpu_to_le32(get_seconds());
+		src_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS,
+			(u32)(ulong)dev->init_pa,
+			(u32)((ulong)dev->init_pa>>32),
+			sizeof(struct _r8) +
+			(AAC_MAX_HRRQ - 1) * sizeof(struct _rrq),
+			0, 0, 0, NULL, NULL, NULL, NULL, NULL);
+	} else {
+		init->r7.host_elapsed_seconds = cpu_to_le32(get_seconds());
+		// We can only use a 32 bit address here
+		src_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS,
+			(u32)(ulong)dev->init_pa, 0, 0, 0, 0, 0,
+			NULL, NULL, NULL, NULL, NULL);
+	}
 
-	/* We can only use a 32 bit address here */
-	src_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa,
-	  0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL);
 }
 
 /**
@@ -467,7 +478,8 @@ static int aac_src_deliver_message(struct fib *fib)
 
 	atomic_inc(&dev->rrq_outstanding[vector_no]);
 
-	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) {
+	if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) ||
+		(dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)) {
 		/* Calculate the amount to the fibsize bits */
 		fibsize = (hdr_size + 127) / 128 - 1;
 		if (fibsize > (ALIGN32 - 1))
@@ -897,7 +909,8 @@ int aac_srcv_init(struct aac_dev *dev)
 
 	if (aac_init_adapter(dev) == NULL)
 		goto error_iounmap;
-	if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE2)
+	if ((dev->comm_interface != AAC_COMM_MESSAGE_TYPE2) &&
+		(dev->comm_interface != AAC_COMM_MESSAGE_TYPE3))
 		goto error_iounmap;
 	if (dev->msi_enabled)
 		aac_src_access_devreg(dev, AAC_ENABLE_MSIX);
-- 
2.7.4
