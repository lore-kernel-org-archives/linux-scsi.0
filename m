From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] 2.6 aacraid: Variable FIB size (updated patch)
Date: Mon, 16 May 2005 11:28:42 -0700
Message-ID: <1116268122.29157.4.camel@markh1.pdx.osdl.net>
References: <1115763750.10955.5.camel@markh1.pdx.osdl.net>
	 <1116256165.5040.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:47511 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261777AbVEPS2t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 14:28:49 -0400
In-Reply-To: <1116256165.5040.10.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, 2005-05-16 at 10:09 -0500, James Bottomley wrote:

[...] 

> This is a formatting change that makes the driver harder to read.  If
> you want one argument per line, they should at least line up with the
> opening bracket of the function.

OK, I changed the indentation to line up the args on the opening
bracket.

> 

[ ... ] 

> 
> This is wrong.  You're basically assuming the block layer is returning
> something that goes over your segment descriptor size.
> 
> There's no API for this in SCSI, but what you should be doing is
> 
> blk_queue_max_segment_size(sdev->request_queue, 65536);
> 
> in your slave_configure routine.

Thanks,  I reverted the aac_build_sg* code and added the
blk_queue_max_segment_size call in aac_slave_configure.

Here is the updated patch:

----
New code from the Adaptec driver.  Performance enhancement for newer
adapters.  I hope that this isn't too big for a single patch.  I believe
that other than the few small cleanups mentioned, that the changes are
all related.

- Added Variable FIB size negotiation for new adapters.
- Added support to maximize scatter gather tables and thus permit
  requests larger than 64KB/each.
- Limit Scatter Gather to 34 elements for ROMB platforms.
- aac_printf is only enabled with AAC_QUIRK_34SG
- Large FIB ioctl support
- some minor cleanup

Passes sparse check.
I have tested it on x86 and ppc64 machines.
Applies to scsi-misc-2.6 git tree.

 aachba.c   |  132 ++++++++++++++++++++++++++++++++------------
 aacraid.h  |   70 +++++++++++++++++++----
 commctrl.c |  180 ++++++++++++++++++++++++++++++++++++++-----------------------
 comminit.c |   86 ++++++++++++++++++++++++++++-
 commsup.c  |   85 ++++++++++++++++------------
 linit.c    |   35 ++++++++++-
 rkt.c      |   39 +++++++------
 rx.c       |   40 +++++++------
 sa.c       |   31 ++++++++--
 9 files changed, 502 insertions(+), 196 deletions(-)

--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -53,10 +53,6 @@
 #define	INQD_PDT_DMASK	0x1F	/* Peripheral Device Type Mask */
 #define	INQD_PDT_QMASK	0xE0	/* Peripheral Device Qualifer Mask */
 
-#define MAX_FIB_DATA (sizeof(struct hw_fib) - sizeof(FIB_HEADER))
-
-#define MAX_DRIVER_SG_SEGMENT_COUNT 17
-
 /*
  *	Sense codes
  */
@@ -158,6 +154,13 @@ MODULE_PARM_DESC(dacmode, "Control wheth
 module_param(commit, int, 0);
 MODULE_PARM_DESC(commit, "Control whether a COMMIT_CONFIG is issued to the adapter for foreign arrays.\nThis is typically needed in systems that do not have a BIOS. 0=off, 1=on");
 
+int numacb = -1;
+module_param(numacb, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(numacb, "Request a limit to the number of adapter control blocks (FIB) allocated. Valid\nvalues are 512 and down. Default is to use suggestion from Firmware.");
+
+int acbsize = -1;
+module_param(acbsize, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(acbsize, "Request a specific adapter control block (FIB) size. Valid values are 512,\n2048, 4096 and 8192. Default is to use suggestion from Firmware.");
 /**
  *	aac_get_config_status	-	check the adapter configuration
  *	@common: adapter to query
@@ -462,7 +465,7 @@ static int probe_container(struct aac_de
 			    1, 1,
 			    NULL, NULL);
 	if (status < 0) {
-		printk(KERN_WARNING "aacraid: probe_containers query failed.\n");
+		printk(KERN_WARNING "aacraid: probe_container query failed.\n");
 		goto error;
 	}
 
@@ -605,35 +608,63 @@ static void set_sense(u8 *sense_buf, u8 
 int aac_get_adapter_info(struct aac_dev* dev)
 {
 	struct fib* fibptr;
-	struct aac_adapter_info* info;
 	int rcode;
 	u32 tmp;
+	struct aac_adapter_info * info;
+
 	if (!(fibptr = fib_alloc(dev)))
 		return -ENOMEM;
 
 	fib_init(fibptr);
-	info = (struct aac_adapter_info*) fib_data(fibptr);
-
-	memset(info,0,sizeof(struct aac_adapter_info));
+	info = (struct aac_adapter_info *) fib_data(fibptr);
+	memset(info,0,sizeof(*info));
 
 	rcode = fib_send(RequestAdapterInfo,
-			fibptr, 
-			sizeof(struct aac_adapter_info),
-			FsaNormal, 
-			1, 1, 
-			NULL, 
-			NULL);
+			 fibptr, 
+			 sizeof(*info),
+			 FsaNormal, 
+			 1, 1, 
+			 NULL, 
+			 NULL);
 
-	memcpy(&dev->adapter_info, info, sizeof(struct aac_adapter_info));
+	if (rcode < 0) {
+		fib_complete(fibptr);
+		fib_free(fibptr);
+		return rcode;
+	}
+	memcpy(&dev->adapter_info, info, sizeof(*info));
+
+	if (dev->adapter_info.options & AAC_OPT_SUPPLEMENT_ADAPTER_INFO) {
+		struct aac_supplement_adapter_info * info;
+
+		fib_init(fibptr);
+
+		info = (struct aac_supplement_adapter_info *) fib_data(fibptr);
+
+		memset(info,0,sizeof(*info));
+
+		rcode = fib_send(RequestSupplementAdapterInfo,
+				 fibptr,
+				 sizeof(*info),
+				 FsaNormal,
+				 1, 1,
+				 NULL,
+				 NULL);
+
+		if (rcode >= 0)
+			memcpy(&dev->supplement_adapter_info, info, sizeof(*info));
+	}
 
 	tmp = le32_to_cpu(dev->adapter_info.kernelrev);
-	printk(KERN_INFO "%s%d: kernel %d.%d-%d[%d]\n", 
+	printk(KERN_INFO "%s%d: kernel %d.%d-%d[%d] %.*s\n", 
 			dev->name, 
 			dev->id,
 			tmp>>24,
 			(tmp>>16)&0xff,
 			tmp&0xff,
-			le32_to_cpu(dev->adapter_info.kernelbuild));
+			le32_to_cpu(dev->adapter_info.kernelbuild),
+			(int)sizeof(dev->supplement_adapter_info.BuildDate),
+			dev->supplement_adapter_info.BuildDate);
 	tmp = le32_to_cpu(dev->adapter_info.monitorrev);
 	printk(KERN_INFO "%s%d: monitor %d.%d-%d[%d]\n", 
 			dev->name, dev->id,
@@ -707,6 +738,38 @@ int aac_get_adapter_info(struct aac_dev*
 			rcode = -ENOMEM;
 		}
 	}
+	/* 
+	 * 57 scatter gather elements 
+	 */
+	dev->scsi_host_ptr->sg_tablesize = (dev->max_fib_size -
+		sizeof(struct aac_fibhdr) -
+		sizeof(struct aac_write) + sizeof(struct sgmap)) /
+			sizeof(struct sgmap);
+	if (dev->dac_support) {
+		/* 
+		 * 38 scatter gather elements 
+		 */
+		dev->scsi_host_ptr->sg_tablesize =
+			(dev->max_fib_size -
+			sizeof(struct aac_fibhdr) -
+			sizeof(struct aac_write64) +
+			sizeof(struct sgmap64)) /
+				sizeof(struct sgmap64);
+	}
+	dev->scsi_host_ptr->max_sectors = AAC_MAX_32BIT_SGBCOUNT;
+	if(!(dev->adapter_info.options & AAC_OPT_NEW_COMM)) {
+		/*
+		 * Worst case size that could cause sg overflow when
+		 * we break up SG elements that are larger than 64KB.
+		 * Would be nice if we could tell the SCSI layer what
+		 * the maximum SG element size can be. Worst case is
+		 * (sg_tablesize-1) 4KB elements with one 64KB
+		 * element.
+		 *	32bit -> 468 or 238KB	64bit -> 424 or 212KB
+		 */
+		dev->scsi_host_ptr->max_sectors =
+		  (dev->scsi_host_ptr->sg_tablesize * 8) + 112;
+	}
 
 	fib_complete(fibptr);
 	fib_free(fibptr);
@@ -747,8 +810,10 @@ static void read_callback(void *context,
 	if (le32_to_cpu(readreply->status) == ST_OK)
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 	else {
-		printk(KERN_WARNING "read_callback: read failed, status = %d\n",
-				le32_to_cpu(readreply->status));
+#ifdef AAC_DETAILED_STATUS_INFO
+		printk(KERN_WARNING "read_callback: io failed, status = %d\n",
+		  le32_to_cpu(readreply->status));
+#endif
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
 		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
 				    HARDWARE_ERROR,
@@ -842,7 +907,8 @@ static int aac_read(struct scsi_cmnd * s
 		lba = (scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16) | (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
 		count = (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
 	}
-	dprintk((KERN_DEBUG "aac_read[cpu %d]: lba = %u, t = %ld.\n", smp_processor_id(), lba, jiffies));
+	dprintk((KERN_DEBUG "aac_read[cpu %d]: lba = %u, t = %ld.\n",
+	  smp_processor_id(), (unsigned long long)lba, jiffies));
 	/*
 	 *	Alocate and initialize a Fib
 	 */
@@ -852,7 +918,7 @@ static int aac_read(struct scsi_cmnd * s
 
 	fib_init(cmd_fibcontext);
 
-	if(dev->dac_support == 1) {
+	if (dev->dac_support == 1) {
 		struct aac_read64 *readcmd;
 		readcmd = (struct aac_read64 *) fib_data(cmd_fibcontext);
 		readcmd->command = cpu_to_le32(VM_CtHostRead64);
@@ -886,14 +952,11 @@ static int aac_read(struct scsi_cmnd * s
 		readcmd->block = cpu_to_le32(lba);
 		readcmd->count = cpu_to_le32(count * 512);
 
-		if (count * 512 > (64 * 1024))
-			BUG();
-
 		aac_build_sg(scsicmd, &readcmd->sg);
 		fibsize = sizeof(struct aac_read) + 
 			((le32_to_cpu(readcmd->sg.count) - 1) * 
 			 sizeof (struct sgentry));
-		BUG_ON (fibsize > (sizeof(struct hw_fib) - 
+		BUG_ON (fibsize > (dev->max_fib_size -
 					sizeof(struct aac_fibhdr)));
 		/*
 		 *	Now send the Fib to the adapter
@@ -976,7 +1039,7 @@ static int aac_write(struct scsi_cmnd * 
 		fibsize = sizeof(struct aac_write64) + 
 			((le32_to_cpu(writecmd->sg.count) - 1) * 
 			 sizeof (struct sgentry64));
-		BUG_ON (fibsize > (sizeof(struct hw_fib) - 
+		BUG_ON (fibsize > (dev->max_fib_size -
 					sizeof(struct aac_fibhdr)));
 		/*
 		 *	Now send the Fib to the adapter
@@ -998,15 +1061,11 @@ static int aac_write(struct scsi_cmnd * 
 		writecmd->sg.count = cpu_to_le32(1);
 		/* ->stable is not used - it did mean which type of write */
 
-		if (count * 512 > (64 * 1024)) {
-			BUG();
-		}
-
 		aac_build_sg(scsicmd, &writecmd->sg);
 		fibsize = sizeof(struct aac_write) + 
 			((le32_to_cpu(writecmd->sg.count) - 1) * 
 			 sizeof (struct sgentry));
-		BUG_ON (fibsize > (sizeof(struct hw_fib) - 
+		BUG_ON (fibsize > (dev->max_fib_size -
 					sizeof(struct aac_fibhdr)));
 		/*
 		 *	Now send the Fib to the adapter
@@ -1025,7 +1084,6 @@ static int aac_write(struct scsi_cmnd * 
 	 */
 	if (status == -EINPROGRESS)
 	{
-		dprintk("write queued.\n");
 		return 0;
 	}
 
@@ -1111,7 +1169,7 @@ static int aac_synchronize(struct scsi_c
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
 	/*
-	 *	Alocate and initialize a Fib
+	 *	Allocate and initialize a Fib
 	 */
 	if (!(cmd_fibcontext = 
 	    fib_alloc((struct aac_dev *)scsicmd->device->host->hostdata))) 
@@ -1403,7 +1461,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 			/*
 			 *	Unhandled commands
 			 */
-			printk(KERN_WARNING "Unhandled SCSI Command: 0x%x.\n", scsicmd->cmnd[0]);
+			dprintk((KERN_WARNING "Unhandled SCSI Command: 0x%x.\n", scsicmd->cmnd[0]));
 			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
 			set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
 				ILLEGAL_REQUEST, SENCODE_INVALID_COMMAND,
@@ -1818,7 +1876,7 @@ static int aac_send_srb_fib(struct scsi_
 		fibsize = sizeof (struct aac_srb) - sizeof (struct sgentry) +
 			((le32_to_cpu(srbcmd->sg.count) & 0xff) * 
 			 sizeof (struct sgentry64));
-		BUG_ON (fibsize > (sizeof(struct hw_fib) - 
+		BUG_ON (fibsize > (dev->max_fib_size -
 					sizeof(struct aac_fibhdr)));
 
 		/*
@@ -1840,7 +1898,7 @@ static int aac_send_srb_fib(struct scsi_
 		fibsize = sizeof (struct aac_srb) + 
 			(((le32_to_cpu(srbcmd->sg.count) & 0xff) - 1) * 
 			 sizeof (struct sgentry));
-		BUG_ON (fibsize > (sizeof(struct hw_fib) - 
+		BUG_ON (fibsize > (dev->max_fib_size -
 					sizeof(struct aac_fibhdr)));
 
 		/*
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -8,12 +8,18 @@
 
 #define MAXIMUM_NUM_CONTAINERS	32
 
-#define AAC_NUM_FIB		(256 + 64)
-#define AAC_NUM_IO_FIB		100
+#define AAC_NUM_MGT_FIB         8
+#define AAC_NUM_IO_FIB		(512 - AAC_NUM_MGT_FIB)
+#define AAC_NUM_FIB		(AAC_NUM_IO_FIB + AAC_NUM_MGT_FIB)
 
 #define AAC_MAX_LUN		(8)
 
 #define AAC_MAX_HOSTPHYSMEMPAGES (0xfffff)
+/*
+ *  max_sectors is an unsigned short, otherwise limit is 0x100000000 / 512
+ * Linux has starvation problems if we permit larger than 4MB I/O ...
+ */
+#define AAC_MAX_32BIT_SGBCOUNT	((unsigned short)8192)
 
 /*
  * These macros convert from physical channels to virtual channels
@@ -303,12 +309,9 @@ struct aac_fibhdr {
 	} _u;
 };
 
-#define FIB_DATA_SIZE_IN_BYTES (512 - sizeof(struct aac_fibhdr))
-
-
 struct hw_fib {
 	struct aac_fibhdr header;
-	u8 data[FIB_DATA_SIZE_IN_BYTES];		// Command specific data
+	u8 data[512-sizeof(struct aac_fibhdr)];	// Command specific data
 };
 
 /*
@@ -370,11 +373,12 @@ struct hw_fib {
 #define		RequestAdapterInfo		703
 #define		IsAdapterPaused			704
 #define		SendHostTime			705
-#define		LastMiscCommand			706
+#define		RequestSupplementAdapterInfo	706
+#define		LastMiscCommand			707
 
-//
-// Commands that will target the failover level on the FSA adapter
-//
+/*
+ * Commands that will target the failover level on the FSA adapter
+ */
 
 enum fib_xfer_state {
 	HostOwned 			= (1<<0),
@@ -407,6 +411,7 @@ enum fib_xfer_state {
  */
 
 #define ADAPTER_INIT_STRUCT_REVISION		3
+#define ADAPTER_INIT_STRUCT_REVISION_4		4 // rocket science
 
 struct aac_init
 {
@@ -424,6 +429,14 @@ struct aac_init
 	__le32	HostPhysMemPages;   /* number of 4k pages of host 
 				       physical memory */
 	__le32	HostElapsedSeconds; /* number of seconds since 1970. */
+	/*
+	 * ADAPTER_INIT_STRUCT_REVISION_4 begins here
+	 */
+	__le32	InitFlags;	/* flags for supported features */
+#define INITFLAGS_NEW_COMM_SUPPORTED	0x00000001
+	__le32	MaxIoCommands;	/* max outstanding commands */
+	__le32	MaxIoSize;	/* largest I/O command */
+	__le32	MaxFibSize;	/* largest FIB to adapter */
 };
 
 enum aac_log_level {
@@ -447,7 +460,7 @@ struct adapter_ops
 {
 	void (*adapter_interrupt)(struct aac_dev *dev);
 	void (*adapter_notify)(struct aac_dev *dev, u32 event);
-	int  (*adapter_sync_cmd)(struct aac_dev *dev, u32 command, u32 p1, u32 *status);
+	int  (*adapter_sync_cmd)(struct aac_dev *dev, u32 command, u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6, u32 *status, u32 *r1, u32 *r2, u32 *r3, u32 *r4);
 	int  (*adapter_check_health)(struct aac_dev *dev);
 };
 
@@ -567,6 +580,7 @@ struct sa_drawbridge_CSR {
 #define Mailbox3	SaDbCSR.MAILBOX3
 #define Mailbox4	SaDbCSR.MAILBOX4
 #define Mailbox5	SaDbCSR.MAILBOX5
+#define Mailbox6	SaDbCSR.MAILBOX6
 #define Mailbox7	SaDbCSR.MAILBOX7
 	
 #define DoorbellReg_p SaDbCSR.PRISETIRQ
@@ -812,6 +826,25 @@ struct aac_adapter_info
 	__le32	OEM;
 };
 
+struct aac_supplement_adapter_info
+{
+	u8	AdapterTypeText[17+1];
+	u8	Pad[2];
+	__le32	FlashMemoryByteSize;
+	__le32	FlashImageId;
+	__le32	MaxNumberPorts;
+	__le32	Version;
+	__le32	FeatureBits;
+	u8	SlotNumber;
+	u8	ReservedPad0[0];
+	u8	BuildDate[12];
+	__le32	CurrentNumberPorts;
+	__le32	ReservedGrowth[24];
+};
+#define AAC_FEATURE_FALCON	0x00000010
+#define AAC_SIS_VERSION_V3	3
+#define AAC_SIS_SLOT_UNKNOWN	0xFF
+
 /*
  * Battery platforms
  */
@@ -857,6 +890,12 @@ struct aac_dev
 
 	u16			irq_mask;
 	/*
+	 *	negotiated FIB settings
+	 */
+	unsigned		max_fib_size;
+	unsigned		sg_tablesize;
+
+	/*
 	 *	Map for 128 fib objects (64k)
 	 */	
 	dma_addr_t		hw_fib_pa;
@@ -915,12 +954,14 @@ struct aac_dev
 	u32			aif_thread;
 	struct completion	aif_completion;
 	struct aac_adapter_info adapter_info;
+	struct aac_supplement_adapter_info supplement_adapter_info;
 	/* These are in adapter info but they are in the io flow so
 	 * lets break them out so we don't have to do an AND to check them
 	 */
 	u8			nondasd_support; 
 	u8			dac_support;
 	u8			raid_scsi_mode;
+	u8			printf_enabled;
 };
 
 #define aac_adapter_interrupt(dev) \
@@ -929,6 +970,8 @@ struct aac_dev
 #define aac_adapter_notify(dev, event) \
 	(dev)->a_ops.adapter_notify(dev, event)
 
+#define aac_adapter_sync_cmd(dev, command, p1, p2, p3, p4, p5, p6, status, r1, r2, r3, r4) \
+	(dev)->a_ops.adapter_sync_cmd(dev, command, p1, p2, p3, p4, p5, p6, status, r1, r2, r3, r4)
 
 #define aac_adapter_check_health(dev) \
 	(dev)->a_ops.adapter_check_health(dev)
@@ -1327,7 +1370,7 @@ struct aac_commit_config {
 };
 
 /*
- *	Query for Container Configuration Count
+ *	Query for Container Configuration Status
  */
 
 #define CT_GET_CONTAINER_COUNT 4
@@ -1481,6 +1524,7 @@ struct revision
 #define FSACTL_GET_PCI_INFO               	CTL_CODE(2119, METHOD_BUFFERED)
 #define FSACTL_FORCE_DELETE_DISK		CTL_CODE(2120, METHOD_NEITHER)
 #define FSACTL_GET_CONTAINERS			2131
+#define FSACTL_SEND_LARGE_FIB			CTL_CODE(2138, METHOD_BUFFERED)
 
 
 struct aac_common
@@ -1667,3 +1711,5 @@ int fib_adapter_complete(struct fib * fi
 struct aac_driver_ident* aac_get_driver_ident(int devtype);
 int aac_get_adapter_info(struct aac_dev* dev);
 int aac_send_shutdown(struct aac_dev *dev);
+extern int numacb;
+extern int acbsize;
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -51,15 +51,22 @@
  *	This routine sends a fib to the adapter on behalf of a user level
  *	program.
  */
+# define AAC_DEBUG_PREAMBLE	KERN_INFO
+# define AAC_DEBUG_POSTAMBLE
  
 static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 {
 	struct hw_fib * kfib;
 	struct fib *fibptr;
+	struct hw_fib * hw_fib = (struct hw_fib *)0;
+	dma_addr_t hw_fib_pa = (dma_addr_t)0LL;
+	unsigned size;
+	int retval;
 
 	fibptr = fib_alloc(dev);
-	if(fibptr == NULL)
+	if(fibptr == NULL) {
 		return -ENOMEM;
+	}
 		
 	kfib = fibptr->hw_fib;
 	/*
@@ -74,16 +81,21 @@ static int ioctl_send_fib(struct aac_dev
 	 *	will not overrun the buffer when we copy the memory. Return
 	 *	an error if we would.
 	 */
-	if (le16_to_cpu(kfib->header.Size) > 
-			sizeof(struct hw_fib) - sizeof(struct aac_fibhdr)) {
-		fib_free(fibptr);
-		return -EINVAL;
+	size = le16_to_cpu(kfib->header.Size) + sizeof(struct aac_fibhdr);
+	if (size < le16_to_cpu(kfib->header.SenderSize))
+		size = le16_to_cpu(kfib->header.SenderSize);
+	if (size > dev->max_fib_size) {
+		/* Highjack the hw_fib */
+		hw_fib = fibptr->hw_fib;
+		hw_fib_pa = fibptr->hw_fib_pa;
+		fibptr->hw_fib = kfib = pci_alloc_consistent(dev->pdev, size, &fibptr->hw_fib_pa);
+		memset(((char *)kfib) + dev->max_fib_size, 0, size - dev->max_fib_size);
+		memcpy(kfib, hw_fib, dev->max_fib_size);
 	}
 
-	if (copy_from_user(kfib, arg, le16_to_cpu(kfib->header.Size) +
-				sizeof(struct aac_fibhdr))) {
-		fib_free(fibptr);
-		return -EFAULT;
+	if (copy_from_user(kfib, arg, size)) {
+		retval = -EFAULT;
+		goto cleanup;
 	}
 
 	if (kfib->header.Command == cpu_to_le16(TakeABreakPt)) {
@@ -94,16 +106,15 @@ static int ioctl_send_fib(struct aac_dev
 		 */
 		kfib->header.XferState = 0;
 	} else {
-		int retval = fib_send(le16_to_cpu(kfib->header.Command), fibptr,
+		retval = fib_send(le16_to_cpu(kfib->header.Command), fibptr,
 				le16_to_cpu(kfib->header.Size) , FsaNormal,
 				1, 1, NULL, NULL);
 		if (retval) {
-			fib_free(fibptr);
-			return retval;
+			goto cleanup;
 		}
 		if (fib_complete(fibptr) != 0) {
-			fib_free(fibptr);
-			return -EINVAL;
+			retval = -EINVAL;
+			goto cleanup;
 		}
 	}
 	/*
@@ -114,12 +125,17 @@ static int ioctl_send_fib(struct aac_dev
 	 *	was already included by the adapter.)
 	 */
 
-	if (copy_to_user(arg, (void *)kfib, le16_to_cpu(kfib->header.Size))) {
-		fib_free(fibptr);
-		return -EFAULT;
+	retval = 0;
+	if (copy_to_user(arg, (void *)kfib, size))
+		retval = -EFAULT;
+cleanup:
+	if (hw_fib) {
+		pci_free_consistent(dev->pdev, size, kfib, fibptr->hw_fib_pa);
+		fibptr->hw_fib_pa = hw_fib_pa;
+		fibptr->hw_fib = hw_fib;
 	}
 	fib_free(fibptr);
-	return 0;
+	return retval;
 }
 
 /**
@@ -399,6 +415,7 @@ static int check_revision(struct aac_dev
 	return 0;
 }
 
+
 /**
  *
  * aac_send_raw_scb
@@ -427,7 +444,7 @@ static int aac_send_raw_srb(struct aac_d
 
 
 	if (!capable(CAP_SYS_ADMIN)){
-		printk(KERN_DEBUG"aacraid: No permission to send raw srb\n"); 
+		dprintk((KERN_DEBUG"aacraid: No permission to send raw srb\n")); 
 		return -EPERM;
 	}
 	/*
@@ -440,20 +457,26 @@ static int aac_send_raw_srb(struct aac_d
 
 	srbcmd = (struct aac_srb*) fib_data(srbfib);
 
+	memset(sg_list, 0, sizeof(sg_list)); /* cleanup may take issue */
 	if(copy_from_user(&fibsize, &user_srb->count,sizeof(u32))){
-		printk(KERN_DEBUG"aacraid: Could not copy data size from user\n"); 
+		dprintk((KERN_DEBUG"aacraid: Could not copy data size from user\n")); 
 		rcode = -EFAULT;
 		goto cleanup;
 	}
 
-	if (fibsize > FIB_DATA_SIZE_IN_BYTES) {
+	if (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr))) {
 		rcode = -EINVAL;
 		goto cleanup;
 	}
 
 	user_srbcmd = kmalloc(GFP_KERNEL, fibsize);
+	if (!user_srbcmd) {
+		dprintk((KERN_DEBUG"aacraid: Could not make a copy of the srb\n"));
+		rcode = -ENOMEM;
+		goto cleanup;
+	}
 	if(copy_from_user(user_srbcmd, user_srb,fibsize)){
-		printk(KERN_DEBUG"aacraid: Could not copy srb from user\n"); 
+		dprintk((KERN_DEBUG"aacraid: Could not copy srb from user\n")); 
 		rcode = -EFAULT;
 		goto cleanup;
 	}
@@ -464,12 +487,12 @@ static int aac_send_raw_srb(struct aac_d
 	// Fix up srb for endian and force some values
 
 	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);	// Force this
-	srbcmd->channel = cpu_to_le32(user_srbcmd->channel);
-	srbcmd->id = cpu_to_le32(user_srbcmd->id);
-	srbcmd->lun = cpu_to_le32(user_srbcmd->lun);
-	srbcmd->flags = cpu_to_le32(user_srbcmd->flags);
-	srbcmd->timeout = cpu_to_le32(user_srbcmd->timeout);
-	srbcmd->retry_limit = 0; 
+	srbcmd->channel  = cpu_to_le32(user_srbcmd->channel);
+	srbcmd->id	 = cpu_to_le32(user_srbcmd->id);
+	srbcmd->lun      = cpu_to_le32(user_srbcmd->lun);
+	srbcmd->flags    = cpu_to_le32(flags);
+	srbcmd->timeout  = cpu_to_le32(user_srbcmd->timeout);
+	srbcmd->retry_limit =cpu_to_le32(0); // Obsolete parameter
 	srbcmd->cdb_size = cpu_to_le32(user_srbcmd->cdb_size);
 	
 	switch (flags & (SRB_DataIn | SRB_DataOut)) {
@@ -485,75 +508,98 @@ static int aac_send_raw_srb(struct aac_d
 	default:
 		data_dir = DMA_NONE;
 	}
+	if (le32_to_cpu(srbcmd->sg.count) > (sizeof(sg_list)/sizeof(sg_list[0]))) {
+		dprintk((KERN_DEBUG"aacraid: too many sg entries %d\n",
+		  le32_to_cpu(srbcmd->sg.count)));
+		rcode = -EINVAL;
+		goto cleanup;
+	}
 	if (dev->dac_support == 1) {
 		struct user_sgmap64* upsg = (struct user_sgmap64*)&user_srbcmd->sg;
 		struct sgmap64* psg = (struct sgmap64*)&user_srbcmd->sg;
+		struct user_sgmap* usg;
 		byte_count = 0;
 
 		/*
 		 * This should also catch if user used the 32 bit sgmap
 		 */
 		actual_fibsize = sizeof(struct aac_srb) - 
-			sizeof(struct sgentry) + 
-			((user_srbcmd->sg.count & 0xff) * 
-		 	sizeof(struct sgentry64));
+			sizeof(struct sgentry) +
+			((upsg->count & 0xff) * 
+		 	sizeof(struct sgentry));
 		if(actual_fibsize != fibsize){ // User made a mistake - should not continue
-			printk(KERN_DEBUG"aacraid: Bad Size specified in Raw SRB command\n");
+			dprintk((KERN_DEBUG"aacraid: Bad Size specified in Raw SRB command\n"));
 			rcode = -EINVAL;
 			goto cleanup;
 		}
-		if ((data_dir == DMA_NONE) && upsg->count) { 
-			printk(KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n");
+		usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
+		  + sizeof(struct sgmap), GFP_KERNEL);
+		if (!usg) {
+			dprintk((KERN_DEBUG"aacraid: Allocation error in Raw SRB command\n"));
+			rcode = -ENOMEM;
+			goto cleanup;
+		}
+		memcpy (usg, upsg, actual_fibsize - sizeof(struct aac_srb)
+		  + sizeof(struct sgmap));
+		actual_fibsize = sizeof(struct aac_srb) - 
+			sizeof(struct sgentry) + ((usg->count & 0xff) * 
+			 	sizeof(struct sgentry64));
+		if ((data_dir == DMA_NONE) && upsg->count) {
+			kfree (usg);
+			dprintk((KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n"));
 			rcode = -EINVAL;
 			goto cleanup;
 		}
 
-		for (i = 0; i < upsg->count; i++) {
-			u64 addr; 
+		for (i = 0; i < usg->count; i++) {
+			u64 addr;
 			void* p;
-			p = kmalloc(upsg->sg[i].count, GFP_KERNEL|__GFP_DMA);
+			/* Does this really need to be GFP_DMA? */
+			p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
 			if(p == 0) {
-				printk(KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
-				upsg->sg[i].count,i,upsg->count);
+				kfree (usg);
+				dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
+				  usg->sg[i].count,i,usg->count));
 				rcode = -ENOMEM;
 				goto cleanup;
 			}
-			sg_user[i] = (void __user *)upsg->sg[i].addr;
+			sg_user[i] = (void __user *)usg->sg[i].addr;
 			sg_list[i] = p; // save so we can clean up later
 			sg_indx = i;
 
 			if( flags & SRB_DataOut ){
 				if(copy_from_user(p,sg_user[i],upsg->sg[i].count)){
-					printk(KERN_DEBUG"aacraid: Could not copy sg data from user\n"); 
+					kfree (usg);
+					dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n")); 
 					rcode = -EFAULT;
 					goto cleanup;
 				}
 			}
-			addr = pci_map_single(dev->pdev, p, upsg->sg[i].count, data_dir);
+			addr = pci_map_single(dev->pdev, p, usg->sg[i].count, data_dir);
 
 			psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
-			psg->sg[i].addr[1] = cpu_to_le32(addr >> 32);
-			psg->sg[i].count = cpu_to_le32(upsg->sg[i].count);  
-			byte_count += upsg->sg[i].count;
+			psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
+			psg->sg[i].count = cpu_to_le32(usg->sg[i].count);  
+			byte_count += usg->sg[i].count;
 		}
+		kfree (usg);
 
 		srbcmd->count = cpu_to_le32(byte_count);
+		psg->count = cpu_to_le32(sg_indx+1);
 		status = fib_send(ScsiPortCommand64, srbfib, actual_fibsize, FsaNormal, 1, 1,NULL,NULL);
 	} else {
 		struct user_sgmap* upsg = &user_srbcmd->sg;
 		struct sgmap* psg = &srbcmd->sg;
 		byte_count = 0;
 
-		actual_fibsize = sizeof (struct aac_srb) + 
-			(((le32_to_cpu(srbcmd->sg.count) & 0xff) - 1) * 
-			 sizeof (struct sgentry));
+		actual_fibsize = sizeof (struct aac_srb) + (((le32_to_cpu(srbcmd->sg.count) & 0xff) - 1) * sizeof (struct sgentry));
 		if(actual_fibsize != fibsize){ // User made a mistake - should not continue
-			printk(KERN_DEBUG"aacraid: Bad Size specified in Raw SRB command\n");
+			dprintk((KERN_DEBUG"aacraid: Bad Size specified in Raw SRB command\n"));
 			rcode = -EINVAL;
 			goto cleanup;
 		}
 		if ((data_dir == DMA_NONE) && upsg->count) {
-			printk(KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n");
+			dprintk((KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n"));
 			rcode = -EINVAL;
 			goto cleanup;
 		}
@@ -562,44 +608,48 @@ static int aac_send_raw_srb(struct aac_d
 			void* p;
 			p = kmalloc(upsg->sg[i].count, GFP_KERNEL);
 			if(p == 0) {
-				printk(KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
-				upsg->sg[i].count, i, upsg->count);
+				dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
+				  upsg->sg[i].count, i, upsg->count));
 				rcode = -ENOMEM;
 				goto cleanup;
 			}
-			sg_user[i] = (void __user *)upsg->sg[i].addr; 
+			sg_user[i] = (void __user *)upsg->sg[i].addr;
 			sg_list[i] = p; // save so we can clean up later
 			sg_indx = i;
 
 			if( flags & SRB_DataOut ){
-				if(copy_from_user(p, sg_user[i], 
-							upsg->sg[i].count)) {
-					printk(KERN_DEBUG"aacraid: Could not copy sg data from user\n"); 
+				if(copy_from_user(p, sg_user[i],
+						upsg->sg[i].count)) {
+					dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n")); 
 					rcode = -EFAULT;
 					goto cleanup;
 				}
 			}
-			addr = pci_map_single(dev->pdev, p, 
-					upsg->sg[i].count, data_dir);
+			addr = pci_map_single(dev->pdev, p,
+				upsg->sg[i].count, data_dir);
 
 			psg->sg[i].addr = cpu_to_le32(addr);
 			psg->sg[i].count = cpu_to_le32(upsg->sg[i].count);  
 			byte_count += upsg->sg[i].count;
 		}
 		srbcmd->count = cpu_to_le32(byte_count);
+		psg->count = cpu_to_le32(sg_indx+1);
 		status = fib_send(ScsiPortCommand, srbfib, actual_fibsize, FsaNormal, 1, 1, NULL, NULL);
 	}
 
 	if (status != 0){
-		printk(KERN_DEBUG"aacraid: Could not send raw srb fib to hba\n"); 
+		dprintk((KERN_DEBUG"aacraid: Could not send raw srb fib to hba\n")); 
 		rcode = -1;
 		goto cleanup;
 	}
 
 	if( flags & SRB_DataIn ) {
 		for(i = 0 ; i <= sg_indx; i++){
-			if(copy_to_user(sg_user[i],sg_list[i],le32_to_cpu(srbcmd->sg.sg[i].count))){
-				printk(KERN_DEBUG"aacraid: Could not copy sg data to user\n"); 
+			byte_count = le32_to_cpu((dev->dac_support == 1)
+			      ? ((struct sgmap64*)&srbcmd->sg)->sg[i].count
+			      : srbcmd->sg.sg[i].count);
+			if(copy_to_user(sg_user[i], sg_list[i], byte_count)){
+				dprintk((KERN_DEBUG"aacraid: Could not copy sg data to user\n")); 
 				rcode = -EFAULT;
 				goto cleanup;
 
@@ -609,7 +659,7 @@ static int aac_send_raw_srb(struct aac_d
 
 	reply = (struct aac_srb_reply *) fib_data(srbfib);
 	if(copy_to_user(user_reply,reply,sizeof(struct aac_srb_reply))){
-		printk(KERN_DEBUG"aacraid: Could not copy reply to user\n"); 
+		dprintk((KERN_DEBUG"aacraid: Could not copy reply to user\n")); 
 		rcode = -EFAULT;
 		goto cleanup;
 	}
@@ -625,7 +675,6 @@ cleanup:
 	return rcode;
 }
 
-
 struct aac_pci_info {
         u32 bus;
         u32 slot;
@@ -640,11 +689,11 @@ static int aac_get_pci_info(struct aac_d
 	pci_info.slot = PCI_SLOT(dev->pdev->devfn);
 
        if (copy_to_user(arg, &pci_info, sizeof(struct aac_pci_info))) {
-		printk(KERN_DEBUG "aacraid: Could not copy pci info\n");
+               dprintk((KERN_DEBUG "aacraid: Could not copy pci info\n"));
                return -EFAULT;
 	}
         return 0;
- }
+}
  
 
 int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
@@ -663,6 +712,7 @@ int aac_do_ioctl(struct aac_dev * dev, i
 	case FSACTL_MINIPORT_REV_CHECK:
 		status = check_revision(dev, arg);
 		break;
+	case FSACTL_SEND_LARGE_FIB:
 	case FSACTL_SENDFIB:
 		status = ioctl_send_fib(dev, arg);
 		break;
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -39,6 +39,7 @@
 #include <linux/blkdev.h>
 #include <linux/completion.h>
 #include <linux/mm.h>
+#include <scsi/scsi_host.h>
 #include <asm/semaphore.h>
 
 #include "aacraid.h"
@@ -49,8 +50,8 @@ static int aac_alloc_comm(struct aac_dev
 {
 	unsigned char *base;
 	unsigned long size, align;
-	unsigned long fibsize = 4096;
-	unsigned long printfbufsiz = 256;
+	const unsigned long fibsize = 4096;
+	const unsigned long printfbufsiz = 256;
 	struct aac_init *init;
 	dma_addr_t phys;
 
@@ -74,6 +75,8 @@ static int aac_alloc_comm(struct aac_dev
 	init = dev->init;
 
 	init->InitStructRevision = cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION);
+	if (dev->max_fib_size != sizeof(struct hw_fib))
+		init->InitStructRevision = cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_4);
 	init->MiniPortRevision = cpu_to_le32(Sa_MINIPORT_REVISION);
 	init->fsrev = cpu_to_le32(dev->fsrev);
 
@@ -110,6 +113,10 @@ static int aac_alloc_comm(struct aac_dev
 		init->HostPhysMemPages = cpu_to_le32(AAC_MAX_HOSTPHYSMEMPAGES);
 	}
 
+	init->InitFlags = 0;
+	init->MaxIoCommands = cpu_to_le32(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
+	init->MaxIoSize = cpu_to_le32(dev->scsi_host_ptr->max_sectors << 9);
+	init->MaxFibSize = cpu_to_le32(dev->max_fib_size);
 
 	/*
 	 * Increment the base address by the amount already used
@@ -173,6 +180,8 @@ int aac_send_shutdown(struct aac_dev * d
 	int status;
 
 	fibctx = fib_alloc(dev);
+	if (!fibctx)
+		return -ENOMEM;
 	fib_init(fibctx);
 
 	cmd = (struct aac_close *) fib_data(fibctx);
@@ -293,6 +302,79 @@ static int aac_comm_init(struct aac_dev 
 
 struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 {
+	u32 status[5];
+	struct Scsi_Host * host = dev->scsi_host_ptr;
+
+	/*
+	 *	Check the preferred comm settings, defaults from template.
+	 */
+	dev->max_fib_size = sizeof(struct hw_fib);
+	dev->sg_tablesize = host->sg_tablesize = (dev->max_fib_size
+		- sizeof(struct aac_fibhdr)
+		- sizeof(struct aac_write) + sizeof(struct sgmap))
+			/ sizeof(struct sgmap);
+	if ((!aac_adapter_sync_cmd(dev, GET_COMM_PREFERRED_SETTINGS,
+	  0, 0, 0, 0, 0, 0,
+	  status+0, status+1, status+2, status+3, status+4))
+	 && (status[0] == 0x00000001)) {
+		/*
+		 *	status[1] >> 16		maximum command size in KB
+		 *	status[1] & 0xFFFF	maximum FIB size
+		 *	status[2] >> 16		maximum SG elements to driver
+		 *	status[2] & 0xFFFF	maximum SG elements from driver
+		 *	status[3] & 0xFFFF	maximum number FIBs outstanding
+		 */
+		host->max_sectors = (status[1] >> 16) << 1;
+		dev->max_fib_size = status[1] & 0xFFFF;
+		host->sg_tablesize = status[2] >> 16;
+		dev->sg_tablesize = status[2] & 0xFFFF;
+		host->can_queue = (status[3] & 0xFFFF) - AAC_NUM_MGT_FIB;
+		/*
+		 *	NOTE:
+		 *	All these overrides are based on a fixed internal
+		 *	knowledge and understanding of existing adapters,
+		 *	acbsize should be set with caution.
+		 */
+		if (acbsize == 512) {
+			host->max_sectors = AAC_MAX_32BIT_SGBCOUNT;
+			dev->max_fib_size = 512;
+			dev->sg_tablesize = host->sg_tablesize
+			  = (512 - sizeof(struct aac_fibhdr)
+			    - sizeof(struct aac_write) + sizeof(struct sgmap))
+			     / sizeof(struct sgmap);
+			host->can_queue = AAC_NUM_IO_FIB;
+		} else if (acbsize == 2048) {
+			host->max_sectors = 512;
+			dev->max_fib_size = 2048;
+			host->sg_tablesize = 65;
+			dev->sg_tablesize = 81;
+			host->can_queue = 512 - AAC_NUM_MGT_FIB;
+		} else if (acbsize == 4096) {
+			host->max_sectors = 1024;
+			dev->max_fib_size = 4096;
+			host->sg_tablesize = 129;
+			dev->sg_tablesize = 166;
+			host->can_queue = 256 - AAC_NUM_MGT_FIB;
+		} else if (acbsize == 8192) {
+			host->max_sectors = 2048;
+			dev->max_fib_size = 8192;
+			host->sg_tablesize = 257;
+			dev->sg_tablesize = 337;
+			host->can_queue = 128 - AAC_NUM_MGT_FIB;
+		} else if (acbsize > 0) {
+			printk("Illegal acbsize=%d ignored\n", acbsize);
+		}
+	}
+	{
+
+		if (numacb > 0) {
+			if (numacb < host->can_queue)
+				host->can_queue = numacb;
+			else
+				printk("numacb=%d ignored\n", numacb);
+		}
+	}
+
 	/*
 	 *	Ok now init the communication subsystem
 	 */
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -25,7 +25,7 @@
  *  commsup.c
  *
  * Abstract: Contain all routines that are required for FSA host/adapter
- *    commuication.
+ *    communication.
  *
  */
 
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/completion.h>
 #include <linux/blkdev.h>
+#include <scsi/scsi_host.h>
 #include <asm/semaphore.h>
 
 #include "aacraid.h"
@@ -52,7 +53,13 @@
  
 static int fib_map_alloc(struct aac_dev *dev)
 {
-	if((dev->hw_fib_va = pci_alloc_consistent(dev->pdev, sizeof(struct hw_fib) * AAC_NUM_FIB, &dev->hw_fib_pa))==NULL)
+	dprintk((KERN_INFO
+	  "allocate hardware fibs pci_alloc_consistent(%p, %d * (%d + %d), %p)\n",
+	  dev->pdev, dev->max_fib_size, dev->scsi_host_ptr->can_queue,
+	  AAC_NUM_MGT_FIB, &dev->hw_fib_pa));
+	if((dev->hw_fib_va = pci_alloc_consistent(dev->pdev, dev->max_fib_size
+	  * (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB),
+	  &dev->hw_fib_pa))==NULL)
 		return -ENOMEM;
 	return 0;
 }
@@ -67,7 +74,7 @@ static int fib_map_alloc(struct aac_dev 
 
 void fib_map_free(struct aac_dev *dev)
 {
-	pci_free_consistent(dev->pdev, sizeof(struct hw_fib) * AAC_NUM_FIB, dev->hw_fib_va, dev->hw_fib_pa);
+	pci_free_consistent(dev->pdev, dev->max_fib_size * (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB), dev->hw_fib_va, dev->hw_fib_pa);
 }
 
 /**
@@ -84,17 +91,22 @@ int fib_setup(struct aac_dev * dev)
 	struct hw_fib *hw_fib_va;
 	dma_addr_t hw_fib_pa;
 	int i;
-	
-	if(fib_map_alloc(dev)<0)
+
+	while (((i = fib_map_alloc(dev)) == -ENOMEM)
+	 && (dev->scsi_host_ptr->can_queue > (64 - AAC_NUM_MGT_FIB))) {
+		dev->init->MaxIoCommands = cpu_to_le32((dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) >> 1);
+		dev->scsi_host_ptr->can_queue = le32_to_cpu(dev->init->MaxIoCommands) - AAC_NUM_MGT_FIB;
+	}
+	if (i<0)
 		return -ENOMEM;
 		
 	hw_fib_va = dev->hw_fib_va;
 	hw_fib_pa = dev->hw_fib_pa;
-	memset(hw_fib_va, 0, sizeof(struct hw_fib) * AAC_NUM_FIB);
+	memset(hw_fib_va, 0, dev->max_fib_size * (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB));
 	/*
 	 *	Initialise the fibs
 	 */
-	for (i = 0, fibptr = &dev->fibs[i]; i < AAC_NUM_FIB; i++, fibptr++) 
+	for (i = 0, fibptr = &dev->fibs[i]; i < (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB); i++, fibptr++) 
 	{
 		fibptr->dev = dev;
 		fibptr->hw_fib = hw_fib_va;
@@ -103,15 +115,15 @@ int fib_setup(struct aac_dev * dev)
 		init_MUTEX_LOCKED(&fibptr->event_wait);
 		spin_lock_init(&fibptr->event_lock);
 		hw_fib_va->header.XferState = cpu_to_le32(0xffffffff);
-		hw_fib_va->header.SenderSize = cpu_to_le16(sizeof(struct hw_fib));
+		hw_fib_va->header.SenderSize = cpu_to_le16(dev->max_fib_size);
 		fibptr->hw_fib_pa = hw_fib_pa;
-		hw_fib_va = (struct hw_fib *)((unsigned char *)hw_fib_va + sizeof(struct hw_fib));
-		hw_fib_pa = hw_fib_pa + sizeof(struct hw_fib); 
+		hw_fib_va = (struct hw_fib *)((unsigned char *)hw_fib_va + dev->max_fib_size);
+		hw_fib_pa = hw_fib_pa + dev->max_fib_size;
 	}
 	/*
 	 *	Add the fib chain to the free list
 	 */
-	dev->fibs[AAC_NUM_FIB-1].next = NULL;
+	dev->fibs[dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB - 1].next = NULL;
 	/*
 	 *	Enable this to debug out of queue space
 	 */
@@ -124,7 +136,7 @@ int fib_setup(struct aac_dev * dev)
  *	@dev: Adapter to allocate the fib for
  *
  *	Allocate a fib from the adapter fib pool. If the pool is empty we
- *	wait for fibs to become free.
+ *	return NULL.
  */
  
 struct fib * fib_alloc(struct aac_dev *dev)
@@ -133,10 +145,10 @@ struct fib * fib_alloc(struct aac_dev *d
 	unsigned long flags;
 	spin_lock_irqsave(&dev->fib_lock, flags);
 	fibptr = dev->free_fib;	
-	/* Cannot sleep here or you get hangs. Instead we did the
-	   maths at compile time. */
-	if(!fibptr)
-		BUG();
+	if(!fibptr){
+		spin_unlock_irqrestore(&dev->fib_lock, flags);
+		return fibptr;
+	}
 	dev->free_fib = fibptr->next;
 	spin_unlock_irqrestore(&dev->fib_lock, flags);
 	/*
@@ -196,11 +208,11 @@ void fib_init(struct fib *fibptr)
 	struct hw_fib *hw_fib = fibptr->hw_fib;
 
 	hw_fib->header.StructType = FIB_MAGIC;
-	hw_fib->header.Size = cpu_to_le16(sizeof(struct hw_fib));
-        hw_fib->header.XferState = cpu_to_le32(HostOwned | FibInitialized | FibEmpty | FastResponseCapable);
+	hw_fib->header.Size = cpu_to_le16(fibptr->dev->max_fib_size);
+	hw_fib->header.XferState = cpu_to_le32(HostOwned | FibInitialized | FibEmpty | FastResponseCapable);
 	hw_fib->header.SenderFibAddress = cpu_to_le32(fibptr->hw_fib_pa);
 	hw_fib->header.ReceiverFibAddress = cpu_to_le32(fibptr->hw_fib_pa);
-	hw_fib->header.SenderSize = cpu_to_le16(sizeof(struct hw_fib));
+	hw_fib->header.SenderSize = cpu_to_le16(fibptr->dev->max_fib_size);
 }
 
 /**
@@ -279,7 +291,7 @@ static int aac_get_entry (struct aac_dev
 	}
 
         if ((*index + 1) == le32_to_cpu(*(q->headers.consumer))) { /* Queue is full */
-		printk(KERN_WARNING "Queue %d full, %d outstanding.\n",
+		printk(KERN_WARNING "Queue %d full, %u outstanding.\n",
 				qid, q->numpending);
 		return 0;
 	} else {
@@ -743,22 +755,25 @@ int fib_complete(struct fib * fibptr)
 
 void aac_printf(struct aac_dev *dev, u32 val)
 {
-	int length = val & 0xffff;
-	int level = (val >> 16) & 0xffff;
 	char *cp = dev->printfbuf;
-	
-	/*
-	 *	The size of the printfbuf is set in port.c
-	 *	There is no variable or define for it
-	 */
-	if (length > 255)
-		length = 255;
-	if (cp[length] != 0)
-		cp[length] = 0;
-	if (level == LOG_AAC_HIGH_ERROR)
-		printk(KERN_WARNING "aacraid:%s", cp);
-	else
-		printk(KERN_INFO "aacraid:%s", cp);
+	if (dev->printf_enabled)
+	{
+		int length = val & 0xffff;
+		int level = (val >> 16) & 0xffff;
+		
+		/*
+		 *	The size of the printfbuf is set in port.c
+		 *	There is no variable or define for it
+		 */
+		if (length > 255)
+			length = 255;
+		if (cp[length] != 0)
+			cp[length] = 0;
+		if (level == LOG_AAC_HIGH_ERROR)
+			printk(KERN_WARNING "aacraid:%s", cp);
+		else
+			printk(KERN_INFO "aacraid:%s", cp);
+	}
 	memset(cp, 0,  256);
 }
 
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -347,10 +347,16 @@ static int aac_biosparm(struct scsi_devi
 
 static int aac_slave_configure(struct scsi_device *sdev)
 {
+	struct Scsi_Host *host = sdev->host;
+
 	if (sdev->tagged_supported)
 		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, 128);
 	else
 		scsi_adjust_queue_depth(sdev, 0, 1);
+
+	if (host->max_sectors < AAC_MAX_32BIT_SGBCOUNT)
+		blk_queue_max_segment_size(sdev->request_queue, 65536);
+
 	return 0;
 }
 
@@ -439,18 +445,18 @@ static int aac_eh_reset(struct scsi_cmnd
 static int aac_cfg_open(struct inode *inode, struct file *file)
 {
 	struct aac_dev *aac;
-	unsigned minor = iminor(inode);
+	unsigned minor_number = iminor(inode);
 	int err = -ENODEV;
 
 	list_for_each_entry(aac, &aac_devices, entry) {
-		if (aac->id == minor) {
+		if (aac->id == minor_number) {
 			file->private_data = aac;
 			err = 0;
 			break;
 		}
 	}
 
-	return 0;
+	return err;
 }
 
 /**
@@ -489,6 +495,7 @@ static long aac_compat_do_ioctl(struct a
 	case FSACTL_DELETE_DISK:
 	case FSACTL_FORCE_DELETE_DISK:
 	case FSACTL_GET_CONTAINERS: 
+	case FSACTL_SEND_LARGE_FIB:
 		ret = aac_do_ioctl(dev, cmd, (void __user *)arg);
 		break;
 
@@ -538,7 +545,7 @@ static struct file_operations aac_cfg_fo
 static struct scsi_host_template aac_driver_template = {
 	.module				= THIS_MODULE,
 	.name           		= "AAC",
-	.proc_name			= "aacraid",
+	.proc_name			= AAC_DRIVERNAME,
 	.info           		= aac_info,
 	.ioctl          		= aac_ioctl,
 #ifdef CONFIG_COMPAT
@@ -612,7 +619,7 @@ static int __devinit aac_probe_one(struc
 	aac->cardtype =  index;
 	INIT_LIST_HEAD(&aac->entry);
 
-	aac->fibs = kmalloc(sizeof(struct fib) * AAC_NUM_FIB, GFP_KERNEL);
+	aac->fibs = kmalloc(sizeof(struct fib) * (shost->can_queue + AAC_NUM_MGT_FIB), GFP_KERNEL);
 	if (!aac->fibs)
 		goto out_free_host;
 	spin_lock_init(&aac->fib_lock);
@@ -632,6 +639,24 @@ static int __devinit aac_probe_one(struc
 	aac_get_adapter_info(aac);
 
 	/*
+ 	 * Lets override negotiations and drop the maximum SG limit to 34
+ 	 */
+ 	if ((aac_drivers[index].quirks & AAC_QUIRK_34SG) && 
+			(aac->scsi_host_ptr->sg_tablesize > 34)) {
+ 		aac->scsi_host_ptr->sg_tablesize = 34;
+ 		aac->scsi_host_ptr->max_sectors
+ 		  = (aac->scsi_host_ptr->sg_tablesize * 8) + 112;
+ 	}
+
+	/*
+	 * Firware printf works only with older firmware.
+	 */
+	if (aac_drivers[index].quirks & AAC_QUIRK_34SG) 
+		aac->printf_enabled = 1;
+	else
+		aac->printf_enabled = 0;
+ 
+ 	/*
 	 * max channel will be the physical channels plus 1 virtual channel
 	 * all containers are on the virtual channel 0
 	 * physical channels are address by their actual physical number+1
--- a/drivers/scsi/aacraid/rkt.c
+++ b/drivers/scsi/aacraid/rkt.c
@@ -98,7 +98,9 @@ static irqreturn_t aac_rkt_intr(int irq,
  *	for its	completion.
  */
 
-static int rkt_sync_cmd(struct aac_dev *dev, u32 command, u32 p1, u32 *status)
+static int rkt_sync_cmd(struct aac_dev *dev, u32 command,
+	u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6,
+	u32 *status, u32 *r1, u32 *r2, u32 *r3, u32 *r4)
 {
 	unsigned long start;
 	int ok;
@@ -107,12 +109,12 @@ static int rkt_sync_cmd(struct aac_dev *
 	 */
 	rkt_writel(dev, InboundMailbox0, command);
 	/*
-	 *	Write the parameters into Mailboxes 1 - 4
+	 *	Write the parameters into Mailboxes 1 - 6
 	 */
 	rkt_writel(dev, InboundMailbox1, p1);
-	rkt_writel(dev, InboundMailbox2, 0);
-	rkt_writel(dev, InboundMailbox3, 0);
-	rkt_writel(dev, InboundMailbox4, 0);
+	rkt_writel(dev, InboundMailbox2, p2);
+	rkt_writel(dev, InboundMailbox3, p3);
+	rkt_writel(dev, InboundMailbox4, p4);
 	/*
 	 *	Clear the synch command doorbell to start on a clean slate.
 	 */
@@ -169,6 +171,14 @@ static int rkt_sync_cmd(struct aac_dev *
 	 */
 	if (status)
 		*status = rkt_readl(dev, IndexRegs.Mailbox[0]);
+	if (r1)
+		*r1 = rkt_readl(dev, IndexRegs.Mailbox[1]);
+	if (r2)
+		*r2 = rkt_readl(dev, IndexRegs.Mailbox[2]);
+	if (r3)
+		*r3 = rkt_readl(dev, IndexRegs.Mailbox[3]);
+	if (r4)
+		*r4 = rkt_readl(dev, IndexRegs.Mailbox[4]);
 	/*
 	 *	Clear the synch command doorbell.
 	 */
@@ -190,8 +200,8 @@ static int rkt_sync_cmd(struct aac_dev *
 
 static void aac_rkt_interrupt_adapter(struct aac_dev *dev)
 {
-	u32 ret;
-	rkt_sync_cmd(dev, BREAKPOINT_REQUEST, 0, &ret);
+	rkt_sync_cmd(dev, BREAKPOINT_REQUEST, 0, 0, 0, 0, 0, 0,
+	  NULL, NULL, NULL, NULL, NULL);
 }
 
 /**
@@ -220,7 +230,8 @@ static void aac_rkt_notify_adapter(struc
 		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_3);
 		break;
 	case HostShutdown:
-//		rkt_sync_cmd(dev, HOST_CRASHING, 0, 0, 0, 0, &ret);
+//		rkt_sync_cmd(dev, HOST_CRASHING, 0, 0, 0, 0, 0, 0,
+//		  NULL, NULL, NULL, NULL, NULL);
 		break;
 	case FastIo:
 		rkt_writel(dev, MUnit.IDR,INBOUNDDOORBELL_6);
@@ -243,17 +254,11 @@ static void aac_rkt_notify_adapter(struc
 
 static void aac_rkt_start_adapter(struct aac_dev *dev)
 {
-	u32 status;
 	struct aac_init *init;
 
 	init = dev->init;
 	init->HostElapsedSeconds = cpu_to_le32(get_seconds());
 	/*
-	 *	Tell the adapter we are back and up and running so it will scan
-	 *	its command queues and enable our interrupts
-	 */
-	dev->irq_mask = (DoorBellPrintfReady | OUTBOUNDDOORBELL_1 | OUTBOUNDDOORBELL_2 | OUTBOUNDDOORBELL_3 | OUTBOUNDDOORBELL_4);
-	/*
 	 *	First clear out all interrupts.  Then enable the one's that we
 	 *	can handle.
 	 */
@@ -263,7 +268,8 @@ static void aac_rkt_start_adapter(struct
 	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
 
 	// We can only use a 32 bit address here
-	rkt_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa, &status);
+	rkt_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa,
+	  0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL);
 }
 
 /**
@@ -310,7 +316,8 @@ static int aac_rkt_check_health(struct a
 		post->Post_Command = cpu_to_le32(COMMAND_POST_RESULTS);
                 post->Post_Address = cpu_to_le32(baddr);
                 rkt_writel(dev, MUnit.IMRx[0], paddr);
-                rkt_sync_cmd(dev, COMMAND_POST_RESULTS, baddr, &status);
+                rkt_sync_cmd(dev, COMMAND_POST_RESULTS, baddr, 0, 0, 0, 0, 0,
+		  NULL, NULL, NULL, NULL, NULL);
 		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
 		  post, paddr);
                 if ((buffer[0] == '0') && (buffer[1] == 'x')) {
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -98,7 +98,9 @@ static irqreturn_t aac_rx_intr(int irq, 
  *	for its	completion.
  */
 
-static int rx_sync_cmd(struct aac_dev *dev, u32 command, u32 p1, u32 *status)
+static int rx_sync_cmd(struct aac_dev *dev, u32 command,
+	u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6,
+	u32 *status, u32 * r1, u32 * r2, u32 * r3, u32 * r4)
 {
 	unsigned long start;
 	int ok;
@@ -107,12 +109,12 @@ static int rx_sync_cmd(struct aac_dev *d
 	 */
 	rx_writel(dev, InboundMailbox0, command);
 	/*
-	 *	Write the parameters into Mailboxes 1 - 4
+	 *	Write the parameters into Mailboxes 1 - 6
 	 */
 	rx_writel(dev, InboundMailbox1, p1);
-	rx_writel(dev, InboundMailbox2, 0);
-	rx_writel(dev, InboundMailbox3, 0);
-	rx_writel(dev, InboundMailbox4, 0);
+	rx_writel(dev, InboundMailbox2, p2);
+	rx_writel(dev, InboundMailbox3, p3);
+	rx_writel(dev, InboundMailbox4, p4);
 	/*
 	 *	Clear the synch command doorbell to start on a clean slate.
 	 */
@@ -120,7 +122,7 @@ static int rx_sync_cmd(struct aac_dev *d
 	/*
 	 *	Disable doorbell interrupts
 	 */
-	rx_writeb(dev, MUnit.OIMR, dev->OIMR |= 0x04);
+	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
 	/*
 	 *	Force the completion of the mask register write before issuing
 	 *	the interrupt.
@@ -169,6 +171,14 @@ static int rx_sync_cmd(struct aac_dev *d
 	 */
 	if (status)
 		*status = rx_readl(dev, IndexRegs.Mailbox[0]);
+	if (r1)
+		*r1 = rx_readl(dev, IndexRegs.Mailbox[1]);
+	if (r2)
+		*r2 = rx_readl(dev, IndexRegs.Mailbox[2]);
+	if (r3)
+		*r3 = rx_readl(dev, IndexRegs.Mailbox[3]);
+	if (r4)
+		*r4 = rx_readl(dev, IndexRegs.Mailbox[4]);
 	/*
 	 *	Clear the synch command doorbell.
 	 */
@@ -190,8 +200,7 @@ static int rx_sync_cmd(struct aac_dev *d
 
 static void aac_rx_interrupt_adapter(struct aac_dev *dev)
 {
-	u32 ret;
-	rx_sync_cmd(dev, BREAKPOINT_REQUEST, 0, &ret);
+	rx_sync_cmd(dev, BREAKPOINT_REQUEST, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL);
 }
 
 /**
@@ -220,7 +229,8 @@ static void aac_rx_notify_adapter(struct
 		rx_writel(dev, MUnit.IDR,INBOUNDDOORBELL_3);
 		break;
 	case HostShutdown:
-//		rx_sync_cmd(dev, HOST_CRASHING, 0, 0, 0, 0, &ret);
+//		rx_sync_cmd(dev, HOST_CRASHING, 0, 0, 0, 0, 0, 0,
+//		  NULL, NULL, NULL, NULL, NULL);
 		break;
 	case FastIo:
 		rx_writel(dev, MUnit.IDR,INBOUNDDOORBELL_6);
@@ -243,17 +253,11 @@ static void aac_rx_notify_adapter(struct
 
 static void aac_rx_start_adapter(struct aac_dev *dev)
 {
-	u32 status;
 	struct aac_init *init;
 
 	init = dev->init;
 	init->HostElapsedSeconds = cpu_to_le32(get_seconds());
 	/*
-	 *	Tell the adapter we are back and up and running so it will scan
-	 *	its command queues and enable our interrupts
-	 */
-	dev->irq_mask = (DoorBellPrintfReady | OUTBOUNDDOORBELL_1 | OUTBOUNDDOORBELL_2 | OUTBOUNDDOORBELL_3 | OUTBOUNDDOORBELL_4);
-	/*
 	 *	First clear out all interrupts.  Then enable the one's that we
 	 *	can handle.
 	 */
@@ -263,7 +267,8 @@ static void aac_rx_start_adapter(struct 
 	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
 
 	// We can only use a 32 bit address here
-	rx_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa, &status);
+	rx_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa,
+	  0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL);
 }
 
 /**
@@ -310,7 +315,8 @@ static int aac_rx_check_health(struct aa
 		post->Post_Command = cpu_to_le32(COMMAND_POST_RESULTS);
 		post->Post_Address = cpu_to_le32(baddr);
 		rx_writel(dev, MUnit.IMRx[0], paddr);
-		rx_sync_cmd(dev, COMMAND_POST_RESULTS, baddr, &status);
+		rx_sync_cmd(dev, COMMAND_POST_RESULTS, baddr, 0, 0, 0, 0, 0,
+		  NULL, NULL, NULL, NULL, NULL);
 		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
 		  post, paddr);
 		if ((buffer[0] == '0') && (buffer[1] == 'x')) {
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -106,7 +106,10 @@ static void aac_sa_notify_adapter(struct
 		sa_writew(dev, DoorbellReg_s,DOORBELL_3);
 		break;
 	case HostShutdown:
-		//sa_sync_cmd(dev, HOST_CRASHING, 0, &ret);
+		/*
+		sa_sync_cmd(dev, HOST_CRASHING, 0, 0, 0, 0, 0, 0,
+		NULL, NULL, NULL, NULL, NULL);
+		*/
 		break;
 	case FastIo:
 		sa_writew(dev, DoorbellReg_s,DOORBELL_6);
@@ -132,7 +135,9 @@ static void aac_sa_notify_adapter(struct
  *	for its	completion.
  */
 
-static int sa_sync_cmd(struct aac_dev *dev, u32 command, u32 p1, u32 *ret)
+static int sa_sync_cmd(struct aac_dev *dev, u32 command, 
+		u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6,
+		u32 *ret, u32 *r1, u32 *r2, u32 *r3, u32 *r4)
 {
 	unsigned long start;
  	int ok;
@@ -144,9 +149,10 @@ static int sa_sync_cmd(struct aac_dev *d
 	 *	Write the parameters into Mailboxes 1 - 4
 	 */
 	sa_writel(dev, Mailbox1, p1);
-	sa_writel(dev, Mailbox2, 0);
-	sa_writel(dev, Mailbox3, 0);
-	sa_writel(dev, Mailbox4, 0);
+	sa_writel(dev, Mailbox2, p2);
+	sa_writel(dev, Mailbox3, p3);
+	sa_writel(dev, Mailbox4, p4);
+
 	/*
 	 *	Clear the synch command doorbell to start on a clean slate.
 	 */
@@ -188,6 +194,14 @@ static int sa_sync_cmd(struct aac_dev *d
 	 */
 	if (ret)
 		*ret = sa_readl(dev, Mailbox0);
+	if (r1)
+		*r1 = sa_readl(dev, Mailbox1);
+	if (r2)
+		*r2 = sa_readl(dev, Mailbox2);
+	if (r3)
+		*r3 = sa_readl(dev, Mailbox3);
+	if (r4)
+		*r4 = sa_readl(dev, Mailbox4);
 	return 0;
 }
 
@@ -201,7 +215,8 @@ static int sa_sync_cmd(struct aac_dev *d
 static void aac_sa_interrupt_adapter (struct aac_dev *dev)
 {
 	u32 ret;
-	sa_sync_cmd(dev, BREAKPOINT_REQUEST, 0, &ret);
+	sa_sync_cmd(dev, BREAKPOINT_REQUEST, 0, 0, 0, 0, 0, 0,
+			&ret, NULL, NULL, NULL, NULL);
 }
 
 /**
@@ -233,7 +248,9 @@ static void aac_sa_start_adapter(struct 
 	sa_writew(dev, SaDbCSR.PRISETIRQMASK, 0xffff);
 	sa_writew(dev, SaDbCSR.PRICLEARIRQMASK, (PrintfReady | DOORBELL_1 | DOORBELL_2 | DOORBELL_3 | DOORBELL_4));
 	/* We can only use a 32 bit address here */
-	sa_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa, &ret);
+	sa_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, 
+			(u32)(ulong)dev->init_pa, 0, 0, 0, 0, 0,
+			&ret, NULL, NULL, NULL, NULL);
 }
 
 /**


-- 
Mark Haverkamp <markh@osdl.org>

