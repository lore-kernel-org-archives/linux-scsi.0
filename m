From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 15/24] aacraid: Include HBA direct interface
Date: Mon, 23 Jan 2017 10:08:59 -0800
Message-ID: <20170123180908.3465-16-RaghavaAditya.Renukunta@microsemi.com>
References: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0086.outbound.protection.outlook.com ([104.47.37.86]:57375
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751919AbdAXArB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 19:47:01 -0500
In-Reply-To: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Banesh@microsemi.com

Added support to send direct pasthru srb commands from management utilty
to the  controller.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h  | 175 ++++++++++++++++++++++--
 drivers/scsi/aacraid/commctrl.c | 294 ++++++++++++++++++++++++++++++----------
 drivers/scsi/aacraid/commsup.c  | 134 +++++++++++++++---
 drivers/scsi/aacraid/dpcsup.c   | 136 ++++++++++++-------
 drivers/scsi/aacraid/linit.c    |   1 +
 drivers/scsi/aacraid/src.c      | 118 ++++++++++------
 6 files changed, 669 insertions(+), 189 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 6709de4..6ca77ff 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -86,6 +86,7 @@ enum {
 #define AAC_MAX_BUSES			5
 #define AAC_MAX_TARGETS		256
 #define AAC_MAX_NATIVE_SIZE		2048
+#define FW_ERROR_BUFFER_SIZE		512
 
 /* Thor AIF events */
 #define SA_AIF_HOTPLUG			(1<<1)
@@ -95,6 +96,141 @@ enum {
 #define SA_AIF_BPSTAT_CHANGE		(1<<30)
 #define SA_AIF_BPCFG_CHANGE		(1<<31)
 
+#define HBA_MAX_SG_EMBEDDED		28
+#define HBA_MAX_SG_SEPARATE		90
+#define HBA_SENSE_DATA_LEN_MAX		32
+#define HBA_REQUEST_TAG_ERROR_FLAG	0x00000002
+#define HBA_SGL_FLAGS_EXT		0x80000000UL
+
+struct aac_hba_sgl {
+	u32		addr_lo; /* Lower 32-bits of SGL element address */
+	u32		addr_hi; /* Upper 32-bits of SGL element address */
+	u32		len;	/* Length of SGL element in bytes */
+	u32		flags;	/* SGL element flags */
+};
+
+enum {
+	HBA_IU_TYPE_SCSI_CMD_REQ		= 0x40,
+	HBA_IU_TYPE_SCSI_TM_REQ			= 0x41,
+	HBA_IU_TYPE_SATA_REQ			= 0x42,
+	HBA_IU_TYPE_RESP			= 0x60,
+	HBA_IU_TYPE_COALESCED_RESP		= 0x61,
+	HBA_IU_TYPE_INT_COALESCING_CFG_REQ	= 0x70
+};
+
+enum {
+	HBA_CMD_BYTE1_DATA_DIR_IN		= 0x1,
+	HBA_CMD_BYTE1_DATA_DIR_OUT		= 0x2,
+	HBA_CMD_BYTE1_DATA_TYPE_DDR		= 0x4,
+	HBA_CMD_BYTE1_CRYPTO_ENABLE		= 0x8
+};
+
+enum {
+	HBA_CMD_BYTE1_BITOFF_DATA_DIR_IN	= 0x0,
+	HBA_CMD_BYTE1_BITOFF_DATA_DIR_OUT,
+	HBA_CMD_BYTE1_BITOFF_DATA_TYPE_DDR,
+	HBA_CMD_BYTE1_BITOFF_CRYPTO_ENABLE
+};
+
+enum {
+	HBA_RESP_DATAPRES_NO_DATA		= 0x0,
+	HBA_RESP_DATAPRES_RESPONSE_DATA,
+	HBA_RESP_DATAPRES_SENSE_DATA
+};
+
+enum {
+	HBA_RESP_SVCRES_TASK_COMPLETE		= 0x0,
+	HBA_RESP_SVCRES_FAILURE,
+	HBA_RESP_SVCRES_TMF_COMPLETE,
+	HBA_RESP_SVCRES_TMF_SUCCEEDED,
+	HBA_RESP_SVCRES_TMF_REJECTED,
+	HBA_RESP_SVCRES_TMF_LUN_INVALID
+};
+
+enum {
+	HBA_RESP_STAT_IO_ERROR			= 0x1,
+	HBA_RESP_STAT_IO_ABORTED,
+	HBA_RESP_STAT_NO_PATH_TO_DEVICE,
+	HBA_RESP_STAT_INVALID_DEVICE,
+	HBA_RESP_STAT_HBAMODE_DISABLED		= 0xE,
+	HBA_RESP_STAT_UNDERRUN			= 0x51,
+	HBA_RESP_STAT_OVERRUN			= 0x75
+};
+
+struct aac_hba_cmd_req {
+	u8	iu_type;	/* HBA information unit type */
+	/*
+	 * byte1:
+	 * [1:0] DIR - 0=No data, 0x1 = IN, 0x2 = OUT
+	 * [2]   TYPE - 0=PCI, 1=DDR
+	 * [3]   CRYPTO_ENABLE - 0=Crypto disabled, 1=Crypto enabled
+	 */
+	u8	byte1;
+	u8	reply_qid;	/* Host reply queue to post response to */
+	u8	reserved1;
+	__le32	it_nexus;	/* Device handle for the request */
+	__le32	request_id;	/* Sender context */
+	/* Lower 32-bits of tweak value for crypto enabled IOs */
+	__le32	tweak_value_lo;
+	u8	cdb[16];	/* SCSI CDB of the command */
+	u8	lun[8];		/* SCSI LUN of the command */
+
+	/* Total data length in bytes to be read/written (if any) */
+	__le32	data_length;
+
+	/* [2:0] Task Attribute, [6:3] Command Priority */
+	u8	attr_prio;
+
+	/* Number of SGL elements embedded in the HBA req */
+	u8	emb_data_desc_count;
+
+	__le16	dek_index;	/* DEK index for crypto enabled IOs */
+
+	/* Lower 32-bits of reserved error data target location on the host */
+	__le32	error_ptr_lo;
+
+	/* Upper 32-bits of reserved error data target location on the host */
+	__le32	error_ptr_hi;
+
+	/* Length of reserved error data area on the host in bytes */
+	__le32	error_length;
+
+	/* Upper 32-bits of tweak value for crypto enabled IOs */
+	__le32	tweak_value_hi;
+
+	struct aac_hba_sgl sge[HBA_MAX_SG_SEPARATE+2]; /* SG list space */
+
+	/*
+	 * structure must not exceed
+	 * AAC_MAX_NATIVE_SIZE-FW_ERROR_BUFFER_SIZE
+	 */
+};
+
+struct aac_hba_resp {
+	u8	iu_type;		/* HBA information unit type */
+	u8	reserved1[3];
+	__le32	request_identifier;	/* sender context */
+	__le32	reserved2;
+	u8	service_response;	/* SCSI service response */
+	u8	status;			/* SCSI status */
+	u8	datapres;	/* [1:0] - data present, [7:2] - reserved */
+	u8	sense_response_data_len;	/* Sense/response data length */
+	__le32	residual_count;		/* Residual data length in bytes */
+	/* Sense/response data */
+	u8	sense_response_buf[HBA_SENSE_DATA_LEN_MAX];
+};
+
+struct aac_native_hba {
+	union {
+		struct aac_hba_cmd_req cmd;
+		u8 cmd_bytes[AAC_MAX_NATIVE_SIZE-FW_ERROR_BUFFER_SIZE];
+	} cmd;
+	union {
+		struct aac_hba_resp err;
+		u8 resp_bytes[FW_ERROR_BUFFER_SIZE];
+	} resp;
+};
+
 #define CISS_REPORT_PHYSICAL_LUNS	0xc3
 #define WRITE_HOST_WELLNESS		0xa5
 #define CISS_IDENTIFY_PHYSICAL_DEVICE	0x15
@@ -472,10 +608,10 @@ enum aac_queue_types {
 
 /* transport FIB header (PMC) */
 struct aac_fib_xporthdr {
-	u64	HostAddress;	/* FIB host address w/o xport header */
-	u32	Size;		/* FIB size excluding xport header */
-	u32	Handle;		/* driver handle to reference the FIB */
-	u64	Reserved[2];
+	__le64	HostAddress;	/* FIB host address w/o xport header */
+	__le32	Size;		/* FIB size excluding xport header */
+	__le32	Handle;		/* driver handle to reference the FIB */
+	__le64	Reserved[2];
 };
 
 #define		ALIGN32		32
@@ -982,17 +1118,20 @@ struct src_mu_registers {
 	__le32	IQ_L;		/*  c0h | Inbound Queue (Low address) */
 	__le32	IQ_H;		/*  c4h | Inbound Queue (High address) */
 	__le32	ODR_MSI;	/*  c8h | MSI register for sync./AIF */
+	__le32  reserved5;	/*  cch | Reserved */
+	__le32	IQN_L;		/*  d0h | Inbound (native cmd) low  */
+	__le32	IQN_H;		/*  d4h | Inbound (native cmd) high */
 };
 
 struct src_registers {
 	struct src_mu_registers MUnit;	/* 00h - cbh */
 	union {
 		struct {
-			__le32 reserved1[130789];	/* cch - 7fc5fh */
+			__le32 reserved1[130786];	/* d8h - 7fc5fh */
 			struct src_inbound IndexRegs;	/* 7fc60h */
 		} tupelo;
 		struct {
-			__le32 reserved1[973];		/* cch - fffh */
+			__le32 reserved1[970];		/* d8h - fffh */
 			struct src_inbound IndexRegs;	/* 1000h */
 		} denali;
 	} u;
@@ -1106,8 +1245,10 @@ struct fib {
 	struct list_head	fiblink;
 	void			*data;
 	u32			vector_no;
-	struct hw_fib		*hw_fib_va;		/* Actual shared object */
-	dma_addr_t		hw_fib_pa;		/* physical address of hw_fib*/
+	struct hw_fib		*hw_fib_va;	/* also used for native */
+	dma_addr_t		hw_fib_pa;	/* physical address of hw_fib*/
+	dma_addr_t		hw_sgl_pa;	/* extra sgl for native */
+	dma_addr_t		hw_error_pa;	/* error buffer for native */
 	u32			hbacmd_size;	/* cmd size for native */
 };
 
@@ -1289,6 +1430,7 @@ struct aac_bus_info_response {
 #define AAC_OPT_NEW_COMM		cpu_to_le32(1<<17)
 #define AAC_OPT_NEW_COMM_64		cpu_to_le32(1<<18)
 #define AAC_OPT_EXTENDED		cpu_to_le32(1<<23)
+#define AAC_OPT_NATIVE_HBA		cpu_to_le32(1<<25)
 #define AAC_OPT_NEW_COMM_TYPE1		cpu_to_le32(1<<28)
 #define AAC_OPT_NEW_COMM_TYPE2		cpu_to_le32(1<<29)
 #define AAC_OPT_NEW_COMM_TYPE3		cpu_to_le32(1<<30)
@@ -1326,8 +1468,8 @@ struct aac_dev
 	/*
 	 *	Map for 128 fib objects (64k)
 	 */
-	dma_addr_t		hw_fib_pa;
-	struct hw_fib		*hw_fib_va;
+	dma_addr_t		hw_fib_pa;	/* also used for native cmd */
+	struct hw_fib		*hw_fib_va;	/* also used for native cmd */
 	struct hw_fib		*aif_base_va;
 	/*
 	 *	Fib Headers
@@ -1502,6 +1644,8 @@ struct aac_dev
 #define FIB_CONTEXT_FLAG			(0x00000002)
 #define FIB_CONTEXT_FLAG_WAIT			(0x00000004)
 #define FIB_CONTEXT_FLAG_FASTRESP		(0x00000008)
+#define FIB_CONTEXT_FLAG_NATIVE_HBA		(0x00000010)
+#define FIB_CONTEXT_FLAG_NATIVE_HBA_TMF	(0x00000020)
 
 /*
  *	Define the command values
@@ -2161,6 +2305,8 @@ struct aac_common
 #ifdef DBG
 	u32 FibsSent;
 	u32 FibRecved;
+	u32 NativeSent;
+	u32 NativeRecved;
 	u32 NoResponseSent;
 	u32 NoResponseRecved;
 	u32 AsyncSent;
@@ -2172,7 +2318,6 @@ struct aac_common
 
 extern struct aac_common aac_config;
 
-
 /*
  *	The following macro is used when sending and receiving FIBs. It is
  *	only used for debugging.
@@ -2299,9 +2444,10 @@ extern struct aac_common aac_config;
 
 /* PMC NEW COMM: Request the event data */
 #define		AifReqEvent		200
+#define		AifRawDeviceRemove	203	/* RAW device deleted */
+#define		AifNativeDeviceAdd	204	/* native HBA device added */
+#define		AifNativeDeviceRemove	205	/* native HBA device removed */
 
-/* RAW device deleted */
-#define		AifRawDeviceRemove	203
 
 /*
  *	Adapter Initiated FIB command structures. Start with the adapter
@@ -2346,9 +2492,12 @@ void aac_fib_free(struct fib * context);
 void aac_fib_init(struct fib * context);
 void aac_printf(struct aac_dev *dev, u32 val);
 int aac_fib_send(u16 command, struct fib * context, unsigned long size, int priority, int wait, int reply, fib_callback callback, void *ctxt);
+int aac_hba_send(u8 command, struct fib *context,
+		fib_callback callback, void *ctxt);
 int aac_consumer_get(struct aac_dev * dev, struct aac_queue * q, struct aac_entry **entry);
 void aac_consumer_free(struct aac_dev * dev, struct aac_queue * q, u32 qnum);
 int aac_fib_complete(struct fib * context);
+void aac_hba_callback(void *context, struct fib *fibptr);
 #define fib_data(fibctx) ((void *)(fibctx)->hw_fib_va->data)
 struct aac_dev *aac_init_adapter(struct aac_dev *dev);
 void aac_src_access_devreg(struct aac_dev *dev, int mode);
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 5648b71..b2af77f 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -477,20 +477,24 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	struct fib* srbfib;
 	int status;
 	struct aac_srb *srbcmd = NULL;
+	struct aac_hba_cmd_req *hbacmd = NULL;
 	struct user_aac_srb *user_srbcmd = NULL;
 	struct user_aac_srb __user *user_srb = arg;
 	struct aac_srb_reply __user *user_reply;
-	struct aac_srb_reply* reply;
+	u32 chn;
 	u32 fibsize = 0;
 	u32 flags = 0;
 	s32 rcode = 0;
 	u32 data_dir;
-	void __user *sg_user[32];
-	void *sg_list[32];
+	void __user *sg_user[HBA_MAX_SG_EMBEDDED];
+	void *sg_list[HBA_MAX_SG_EMBEDDED];
+	u32 sg_count[HBA_MAX_SG_EMBEDDED];
 	u32 sg_indx = 0;
 	u32 byte_count = 0;
 	u32 actual_fibsize64, actual_fibsize = 0;
 	int i;
+	int is_native_device;
+	u64 address;
 
 
 	if (dev->in_reset) {
@@ -507,11 +511,6 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	if (!(srbfib = aac_fib_alloc(dev))) {
 		return -ENOMEM;
 	}
-	aac_fib_init(srbfib);
-	/* raw_srb FIB is not FastResponseCapable */
-	srbfib->hw_fib_va->header.XferState &= ~cpu_to_le32(FastResponseCapable);
-
-	srbcmd = (struct aac_srb*) fib_data(srbfib);
 
 	memset(sg_list, 0, sizeof(sg_list)); /* cleanup may take issue */
 	if(copy_from_user(&fibsize, &user_srb->count,sizeof(u32))){
@@ -538,21 +537,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		goto cleanup;
 	}
 
-	user_reply = arg+fibsize;
-
 	flags = user_srbcmd->flags; /* from user in cpu order */
-	// Fix up srb for endian and force some values
-
-	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);	// Force this
-	srbcmd->channel	 = cpu_to_le32(user_srbcmd->channel);
-	srbcmd->id	 = cpu_to_le32(user_srbcmd->id);
-	srbcmd->lun	 = cpu_to_le32(user_srbcmd->lun);
-	srbcmd->timeout	 = cpu_to_le32(user_srbcmd->timeout);
-	srbcmd->flags	 = cpu_to_le32(flags);
-	srbcmd->retry_limit = 0; // Obsolete parameter
-	srbcmd->cdb_size = cpu_to_le32(user_srbcmd->cdb_size);
-	memcpy(srbcmd->cdb, user_srbcmd->cdb, sizeof(srbcmd->cdb));
-
 	switch (flags & (SRB_DataIn | SRB_DataOut)) {
 	case SRB_DataOut:
 		data_dir = DMA_TO_DEVICE;
@@ -568,7 +553,12 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	}
 	if (user_srbcmd->sg.count > ARRAY_SIZE(sg_list)) {
 		dprintk((KERN_DEBUG"aacraid: too many sg entries %d\n",
-		  le32_to_cpu(srbcmd->sg.count)));
+			user_srbcmd->sg.count));
+		rcode = -EINVAL;
+		goto cleanup;
+	}
+	if ((data_dir == DMA_NONE) && user_srbcmd->sg.count) {
+		dprintk((KERN_DEBUG"aacraid:SG with no direction specified\n"));
 		rcode = -EINVAL;
 		goto cleanup;
 	}
@@ -588,13 +578,136 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		rcode = -EINVAL;
 		goto cleanup;
 	}
-	if ((data_dir == DMA_NONE) && user_srbcmd->sg.count) {
-		dprintk((KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n"));
-		rcode = -EINVAL;
-		goto cleanup;
+
+	chn = aac_logical_to_phys(user_srbcmd->channel);
+	if (chn < AAC_MAX_BUSES && user_srbcmd->id < AAC_MAX_TARGETS &&
+		dev->hba_map[chn][user_srbcmd->id].devtype ==
+		AAC_DEVTYPE_NATIVE_RAW) {
+		is_native_device = 1;
+		hbacmd = (struct aac_hba_cmd_req *)srbfib->hw_fib_va;
+		memset(hbacmd, 0, 96);	/* sizeof(*hbacmd) is not necessary */
+
+		/* iu_type is a parameter of aac_hba_send */
+		switch (data_dir) {
+		case DMA_TO_DEVICE:
+			hbacmd->byte1 = 2;
+			break;
+		case DMA_FROM_DEVICE:
+		case DMA_BIDIRECTIONAL:
+			hbacmd->byte1 = 1;
+			break;
+		case DMA_NONE:
+		default:
+			break;
+		}
+		hbacmd->lun[1] = cpu_to_le32(user_srbcmd->lun);
+		hbacmd->it_nexus = dev->hba_map[chn][user_srbcmd->id].rmw_nexus;
+
+		/*
+		 * we fill in reply_qid later in aac_src_deliver_message
+		 * we fill in iu_type, request_id later in aac_hba_send
+		 * we fill in emb_data_desc_count, data_length later
+		 * in sg list build
+		 */
+
+		memcpy(hbacmd->cdb, user_srbcmd->cdb, sizeof(hbacmd->cdb));
+
+		address = (u64)srbfib->hw_error_pa;
+		hbacmd->error_ptr_hi = cpu_to_le32((u32)(address >> 32));
+		hbacmd->error_ptr_lo = cpu_to_le32((u32)(address & 0xffffffff));
+		hbacmd->error_length = cpu_to_le32(FW_ERROR_BUFFER_SIZE);
+		hbacmd->emb_data_desc_count =
+					cpu_to_le32(user_srbcmd->sg.count);
+		srbfib->hbacmd_size = 64 +
+			user_srbcmd->sg.count * sizeof(struct aac_hba_sgl);
+
+	} else {
+		is_native_device = 0;
+		aac_fib_init(srbfib);
+
+		/* raw_srb FIB is not FastResponseCapable */
+		srbfib->hw_fib_va->header.XferState &=
+			~cpu_to_le32(FastResponseCapable);
+
+		srbcmd = (struct aac_srb *) fib_data(srbfib);
+
+		// Fix up srb for endian and force some values
+
+		srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi); // Force this
+		srbcmd->channel	 = cpu_to_le32(user_srbcmd->channel);
+		srbcmd->id	 = cpu_to_le32(user_srbcmd->id);
+		srbcmd->lun	 = cpu_to_le32(user_srbcmd->lun);
+		srbcmd->timeout	 = cpu_to_le32(user_srbcmd->timeout);
+		srbcmd->flags	 = cpu_to_le32(flags);
+		srbcmd->retry_limit = 0; // Obsolete parameter
+		srbcmd->cdb_size = cpu_to_le32(user_srbcmd->cdb_size);
+		memcpy(srbcmd->cdb, user_srbcmd->cdb, sizeof(srbcmd->cdb));
 	}
+
 	byte_count = 0;
-	if (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64) {
+	if (is_native_device) {
+		struct user_sgmap *usg32 = &user_srbcmd->sg;
+		struct user_sgmap64 *usg64 =
+			(struct user_sgmap64 *)&user_srbcmd->sg;
+
+		for (i = 0; i < usg32->count; i++) {
+			void *p;
+			u64 addr;
+
+			sg_count[i] = (actual_fibsize64 == fibsize) ?
+				usg64->sg[i].count : usg32->sg[i].count;
+			if (sg_count[i] >
+				(dev->scsi_host_ptr->max_sectors << 9)) {
+				pr_err("aacraid: upsg->sg[%d].count=%u>%u\n",
+					i, sg_count[i],
+					dev->scsi_host_ptr->max_sectors << 9);
+				rcode = -EINVAL;
+				goto cleanup;
+			}
+
+			p = kmalloc(sg_count[i], GFP_KERNEL|__GFP_DMA);
+			if (!p) {
+				rcode = -ENOMEM;
+				goto cleanup;
+			}
+
+			if (actual_fibsize64 == fibsize) {
+				addr = (u64)usg64->sg[i].addr[0];
+				addr += ((u64)usg64->sg[i].addr[1]) << 32;
+			} else {
+				addr = (u64)usg32->sg[i].addr;
+			}
+
+			sg_user[i] = (void __user *)(uintptr_t)addr;
+			sg_list[i] = p; // save so we can clean up later
+			sg_indx = i;
+
+			if (flags & SRB_DataOut) {
+				if (copy_from_user(p, sg_user[i],
+					sg_count[i])) {
+					rcode = -EFAULT;
+					goto cleanup;
+				}
+			}
+			addr = pci_map_single(dev->pdev, p, sg_count[i],
+						data_dir);
+			hbacmd->sge[i].addr_hi = cpu_to_le32((u32)(addr>>32));
+			hbacmd->sge[i].addr_lo = cpu_to_le32(
+						(u32)(addr & 0xffffffff));
+			hbacmd->sge[i].len = cpu_to_le32(sg_count[i]);
+			hbacmd->sge[i].flags = 0;
+			byte_count += sg_count[i];
+		}
+
+		if (usg32->count > 0)	/* embedded sglist */
+			hbacmd->sge[usg32->count-1].flags =
+				cpu_to_le32(0x40000000);
+		hbacmd->data_length = cpu_to_le32(byte_count);
+
+		status = aac_hba_send(HBA_IU_TYPE_SCSI_CMD_REQ, srbfib,
+					NULL, NULL);
+
+	} else if (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64) {
 		struct user_sgmap64* upsg = (struct user_sgmap64*)&user_srbcmd->sg;
 		struct sgmap64* psg = (struct sgmap64*)&srbcmd->sg;
 
@@ -606,7 +719,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			for (i = 0; i < upsg->count; i++) {
 				u64 addr;
 				void* p;
-				if (upsg->sg[i].count >
+
+				sg_count[i] = upsg->sg[i].count;
+				if (sg_count[i] >
 				    ((dev->adapter_info.options &
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
@@ -615,10 +730,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					goto cleanup;
 				}
 				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(upsg->sg[i].count,GFP_KERNEL|__GFP_DMA);
+				p = kmalloc(sg_count[i], GFP_KERNEL|__GFP_DMA);
 				if(!p) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
-					  upsg->sg[i].count,i,upsg->count));
+					  sg_count[i], i, upsg->count));
 					rcode = -ENOMEM;
 					goto cleanup;
 				}
@@ -629,18 +744,20 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				sg_indx = i;
 
 				if (flags & SRB_DataOut) {
-					if(copy_from_user(p,sg_user[i],upsg->sg[i].count)){
+					if (copy_from_user(p, sg_user[i],
+						sg_count[i])){
 						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
 						rcode = -EFAULT;
 						goto cleanup;
 					}
 				}
-				addr = pci_map_single(dev->pdev, p, upsg->sg[i].count, data_dir);
+				addr = pci_map_single(dev->pdev, p,
+							sg_count[i], data_dir);
 
 				psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
 				psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
-				byte_count += upsg->sg[i].count;
-				psg->sg[i].count = cpu_to_le32(upsg->sg[i].count);
+				byte_count += sg_count[i];
+				psg->sg[i].count = cpu_to_le32(sg_count[i]);
 			}
 		} else {
 			struct user_sgmap* usg;
@@ -657,7 +774,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			for (i = 0; i < usg->count; i++) {
 				u64 addr;
 				void* p;
-				if (usg->sg[i].count >
+
+				sg_count[i] = usg->sg[i].count;
+				if (sg_count[i] >
 				    ((dev->adapter_info.options &
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
@@ -667,10 +786,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					goto cleanup;
 				}
 				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
+				p = kmalloc(sg_count[i], GFP_KERNEL|__GFP_DMA);
 				if(!p) {
 					dprintk((KERN_DEBUG "aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
-					  usg->sg[i].count,i,usg->count));
+						sg_count[i], i, usg->count));
 					kfree(usg);
 					rcode = -ENOMEM;
 					goto cleanup;
@@ -680,19 +799,21 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				sg_indx = i;
 
 				if (flags & SRB_DataOut) {
-					if(copy_from_user(p,sg_user[i],upsg->sg[i].count)){
+					if (copy_from_user(p, sg_user[i],
+						sg_count[i])) {
 						kfree (usg);
 						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
 						rcode = -EFAULT;
 						goto cleanup;
 					}
 				}
-				addr = pci_map_single(dev->pdev, p, usg->sg[i].count, data_dir);
+				addr = pci_map_single(dev->pdev, p,
+							sg_count[i], data_dir);
 
 				psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
 				psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
-				byte_count += usg->sg[i].count;
-				psg->sg[i].count = cpu_to_le32(usg->sg[i].count);
+				byte_count += sg_count[i];
+				psg->sg[i].count = cpu_to_le32(sg_count[i]);
 			}
 			kfree (usg);
 		}
@@ -711,7 +832,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			for (i = 0; i < upsg->count; i++) {
 				uintptr_t addr;
 				void* p;
-				if (usg->sg[i].count >
+
+				sg_count[i] = usg->sg[i].count;
+				if (sg_count[i] >
 				    ((dev->adapter_info.options &
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
@@ -720,10 +843,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					goto cleanup;
 				}
 				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
-				if(!p) {
+				p = kmalloc(sg_count[i], GFP_KERNEL|__GFP_DMA);
+				if (!p) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
-					  usg->sg[i].count,i,usg->count));
+						sg_count[i], i, usg->count));
 					rcode = -ENOMEM;
 					goto cleanup;
 				}
@@ -734,7 +857,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				sg_indx = i;
 
 				if (flags & SRB_DataOut) {
-					if(copy_from_user(p,sg_user[i],usg->sg[i].count)){
+					if (copy_from_user(p, sg_user[i],
+						sg_count[i])){
 						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
 						rcode = -EFAULT;
 						goto cleanup;
@@ -744,13 +868,15 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 
 				psg->sg[i].addr = cpu_to_le32(addr & 0xffffffff);
 				byte_count += usg->sg[i].count;
-				psg->sg[i].count = cpu_to_le32(usg->sg[i].count);
+				psg->sg[i].count = cpu_to_le32(sg_count[i]);
 			}
 		} else {
 			for (i = 0; i < upsg->count; i++) {
 				dma_addr_t addr;
 				void* p;
-				if (upsg->sg[i].count >
+
+				sg_count[i] = upsg->sg[i].count;
+				if (sg_count[i] >
 				    ((dev->adapter_info.options &
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
@@ -758,10 +884,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					rcode = -EINVAL;
 					goto cleanup;
 				}
-				p = kmalloc(upsg->sg[i].count, GFP_KERNEL);
+				p = kmalloc(sg_count[i], GFP_KERNEL);
 				if (!p) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
-					  upsg->sg[i].count, i, upsg->count));
+					  sg_count[i], i, upsg->count));
 					rcode = -ENOMEM;
 					goto cleanup;
 				}
@@ -770,19 +896,19 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				sg_indx = i;
 
 				if (flags & SRB_DataOut) {
-					if(copy_from_user(p, sg_user[i],
-							upsg->sg[i].count)) {
+					if (copy_from_user(p, sg_user[i],
+						sg_count[i])) {
 						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
 						rcode = -EFAULT;
 						goto cleanup;
 					}
 				}
 				addr = pci_map_single(dev->pdev, p,
-					upsg->sg[i].count, data_dir);
+					sg_count[i], data_dir);
 
 				psg->sg[i].addr = cpu_to_le32(addr);
-				byte_count += upsg->sg[i].count;
-				psg->sg[i].count = cpu_to_le32(upsg->sg[i].count);
+				byte_count += sg_count[i];
+				psg->sg[i].count = cpu_to_le32(sg_count[i]);
 			}
 		}
 		srbcmd->count = cpu_to_le32(byte_count);
@@ -792,12 +918,13 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			psg->count = 0;
 		status = aac_fib_send(ScsiPortCommand, srbfib, actual_fibsize, FsaNormal, 1, 1, NULL, NULL);
 	}
+
 	if (status == -ERESTARTSYS) {
 		rcode = -ERESTARTSYS;
 		goto cleanup;
 	}
 
-	if (status != 0){
+	if (status != 0) {
 		dprintk((KERN_DEBUG"aacraid: Could not send raw srb fib to hba\n"));
 		rcode = -ENXIO;
 		goto cleanup;
@@ -805,11 +932,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 
 	if (flags & SRB_DataIn) {
 		for(i = 0 ; i <= sg_indx; i++){
-			byte_count = le32_to_cpu(
-			  (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)
-			      ? ((struct sgmap64*)&srbcmd->sg)->sg[i].count
-			      : srbcmd->sg.sg[i].count);
-			if(copy_to_user(sg_user[i], sg_list[i], byte_count)){
+			if (copy_to_user(sg_user[i], sg_list[i], sg_count[i])) {
 				dprintk((KERN_DEBUG"aacraid: Could not copy sg data to user\n"));
 				rcode = -EFAULT;
 				goto cleanup;
@@ -818,19 +941,50 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		}
 	}
 
-	reply = (struct aac_srb_reply *) fib_data(srbfib);
-	if(copy_to_user(user_reply,reply,sizeof(struct aac_srb_reply))){
-		dprintk((KERN_DEBUG"aacraid: Could not copy reply to user\n"));
-		rcode = -EFAULT;
-		goto cleanup;
+	user_reply = arg + fibsize;
+	if (is_native_device) {
+		struct aac_hba_resp *err =
+			&((struct aac_native_hba *)srbfib->hw_fib_va)->resp.err;
+		struct aac_srb_reply reply;
+
+		reply.status = ST_OK;
+		if (srbfib->flags & FIB_CONTEXT_FLAG_FASTRESP) {
+			/* fast response */
+			reply.srb_status = SRB_STATUS_SUCCESS;
+			reply.scsi_status = 0;
+			reply.data_xfer_length = byte_count;
+		} else {
+			reply.srb_status = err->service_response;
+			reply.scsi_status = err->status;
+			reply.data_xfer_length = byte_count -
+				le32_to_cpu(err->residual_count);
+			reply.sense_data_size = err->sense_response_data_len;
+			memcpy(reply.sense_data, err->sense_response_buf,
+				AAC_SENSE_BUFFERSIZE);
+		}
+		if (copy_to_user(user_reply, &reply,
+			sizeof(struct aac_srb_reply))) {
+			dprintk((KERN_DEBUG"aacraid: Copy to user failed\n"));
+			rcode = -EFAULT;
+			goto cleanup;
+		}
+	} else {
+		struct aac_srb_reply *reply;
+
+		reply = (struct aac_srb_reply *) fib_data(srbfib);
+		if (copy_to_user(user_reply, reply,
+			sizeof(struct aac_srb_reply))) {
+			dprintk((KERN_DEBUG"aacraid: Copy to user failed\n"));
+			rcode = -EFAULT;
+			goto cleanup;
+		}
 	}
 
 cleanup:
 	kfree(user_srbcmd);
-	for(i=0; i <= sg_indx; i++){
-		kfree(sg_list[i]);
-	}
 	if (rcode != -ERESTARTSYS) {
+		for (i = 0; i <= sg_indx; i++)
+			kfree(sg_list[i]);
 		aac_fib_complete(srbfib);
 		aac_fib_free(srbfib);
 	}
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index f8c219e..13c5c10 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -65,6 +65,11 @@ static int fib_map_alloc(struct aac_dev *dev)
 		dev->max_cmd_size = AAC_MAX_NATIVE_SIZE;
 	else
 		dev->max_cmd_size = dev->max_fib_size;
+	if (dev->max_fib_size < AAC_MAX_NATIVE_SIZE) {
+		dev->max_cmd_size = AAC_MAX_NATIVE_SIZE;
+	} else {
+		dev->max_cmd_size = dev->max_fib_size;
+	}
 
 	dprintk((KERN_INFO
 	  "allocate hardware fibs pci_alloc_consistent(%p, %d * (%d + %d), %p)\n",
@@ -153,7 +158,7 @@ int aac_fib_setup(struct aac_dev * dev)
 		(hw_fib_pa - dev->hw_fib_pa));
 	dev->hw_fib_pa = hw_fib_pa;
 	memset(dev->hw_fib_va, 0,
-		(dev->max_fib_size + sizeof(struct aac_fib_xporthdr)) *
+		(dev->max_cmd_size + sizeof(struct aac_fib_xporthdr)) *
 		(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB));
 
 	/* add Xport header */
@@ -179,8 +184,18 @@ int aac_fib_setup(struct aac_dev * dev)
 		sema_init(&fibptr->event_wait, 0);
 		spin_lock_init(&fibptr->event_lock);
 		hw_fib->header.XferState = cpu_to_le32(0xffffffff);
-		hw_fib->header.SenderSize = cpu_to_le16(dev->max_fib_size);
+		hw_fib->header.SenderSize =
+			cpu_to_le16(dev->max_fib_size);	/* ?? max_cmd_size */
 		fibptr->hw_fib_pa = hw_fib_pa;
+		fibptr->hw_sgl_pa = hw_fib_pa +
+			offsetof(struct aac_hba_cmd_req, sge[2]);
+		/*
+		 * one element is for the ptr to the separate sg list,
+		 * second element for 32 byte alignment
+		 */
+		fibptr->hw_error_pa = hw_fib_pa +
+			offsetof(struct aac_native_hba, resp.resp_bytes[0]);
+
 		hw_fib = (struct hw_fib *)((unsigned char *)hw_fib +
 			dev->max_cmd_size + sizeof(struct aac_fib_xporthdr));
 		hw_fib_pa = hw_fib_pa +
@@ -282,7 +297,8 @@ void aac_fib_free(struct fib *fibptr)
 	spin_lock_irqsave(&fibptr->dev->fib_lock, flags);
 	if (unlikely(fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT))
 		aac_config.fib_timeouts++;
-	if (fibptr->hw_fib_va->header.XferState != 0) {
+	if (!(fibptr->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) &&
+		fibptr->hw_fib_va->header.XferState != 0) {
 		printk(KERN_WARNING "aac_fib_free, XferState != 0, fibptr = 0x%p, XferState = 0x%x\n",
 			 (void*)fibptr,
 			 le32_to_cpu(fibptr->hw_fib_va->header.XferState));
@@ -510,8 +526,15 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 	 *	Map the fib into 32bits by using the fib number
 	 */
 
-	hw_fib->header.SenderFibAddress = cpu_to_le32(((u32)(fibptr - dev->fibs)) << 2);
-	hw_fib->header.Handle = (u32)(fibptr - dev->fibs) + 1;
+	hw_fib->header.SenderFibAddress =
+		cpu_to_le32(((u32)(fibptr - dev->fibs)) << 2);
+
+	/* use the same shifted value for handle to be compatible
+	 * with the new native hba command handle
+	 */
+	hw_fib->header.Handle =
+		cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + 1);
+
 	/*
 	 *	Set FIB state to indicate where it came from and if we want a
 	 *	response from the adapter. Also load the command from the
@@ -679,6 +702,82 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 		return 0;
 }
 
+int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
+		void *callback_data)
+{
+	struct aac_dev *dev = fibptr->dev;
+	int wait;
+	unsigned long flags = 0;
+	unsigned long mflags = 0;
+
+	fibptr->flags = (FIB_CONTEXT_FLAG | FIB_CONTEXT_FLAG_NATIVE_HBA);
+	if (callback) {
+		wait = 0;
+		fibptr->callback = callback;
+		fibptr->callback_data = callback_data;
+	} else
+		wait = 1;
+
+
+	if (command == HBA_IU_TYPE_SCSI_CMD_REQ) {
+		struct aac_hba_cmd_req *hbacmd =
+			(struct aac_hba_cmd_req *)fibptr->hw_fib_va;
+
+		hbacmd->iu_type = command;
+		/* bit1 of request_id must be 0 */
+		hbacmd->request_id =
+			cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + 1);
+	} else
+		return -EINVAL;
+
+
+	if (wait) {
+		spin_lock_irqsave(&dev->manage_lock, mflags);
+		if (dev->management_fib_count >= AAC_NUM_MGT_FIB) {
+			spin_unlock_irqrestore(&dev->manage_lock, mflags);
+			return -EBUSY;
+		}
+		dev->management_fib_count++;
+		spin_unlock_irqrestore(&dev->manage_lock, mflags);
+		spin_lock_irqsave(&fibptr->event_lock, flags);
+	}
+
+	if (aac_adapter_deliver(fibptr) != 0) {
+		if (wait) {
+			spin_unlock_irqrestore(&fibptr->event_lock, flags);
+			spin_lock_irqsave(&dev->manage_lock, mflags);
+			dev->management_fib_count--;
+			spin_unlock_irqrestore(&dev->manage_lock, mflags);
+		}
+		return -EBUSY;
+	}
+	FIB_COUNTER_INCREMENT(aac_config.NativeSent);
+
+	if (wait) {
+		spin_unlock_irqrestore(&fibptr->event_lock, flags);
+		/* Only set for first known interruptable command */
+		if (down_interruptible(&fibptr->event_wait)) {
+			fibptr->done = 2;
+			up(&fibptr->event_wait);
+		}
+		spin_lock_irqsave(&fibptr->event_lock, flags);
+		if ((fibptr->done == 0) || (fibptr->done == 2)) {
+			fibptr->done = 2; /* Tell interrupt we aborted */
+			spin_unlock_irqrestore(&fibptr->event_lock, flags);
+			return -ERESTARTSYS;
+		}
+		spin_unlock_irqrestore(&fibptr->event_lock, flags);
+		WARN_ON(fibptr->done == 0);
+
+		if (unlikely(fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT))
+			return -ETIMEDOUT;
+
+		return 0;
+	}
+
+	return -EINPROGRESS;
+}
+
 /**
  *	aac_consumer_get	-	get the top of the queue
  *	@dev: Adapter
@@ -837,11 +936,17 @@ int aac_fib_complete(struct fib *fibptr)
 {
 	struct hw_fib * hw_fib = fibptr->hw_fib_va;
 
+	if (fibptr->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) {
+		fib_dealloc(fibptr);
+		return 0;
+	}
+
 	/*
-	 *	Check for a fib which has already been completed
+	 *	Check for a fib which has already been completed or with a
+	 *	status wait timeout
 	 */
 
-	if (hw_fib->header.XferState == 0)
+	if (hw_fib->header.XferState == 0 || fibptr->done == 2)
 		return 0;
 	/*
 	 *	If we plan to do anything check the structure type first.
@@ -994,20 +1099,9 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 			lun = (container >> 16) & 0xFF;
 			container = (u32)-1;
 			channel = aac_phys_to_logical(channel);
-			device_config_needed =
-			  (((__le32 *)aifcmd->data)[0] ==
-			    cpu_to_le32(AifRawDeviceRemove)) ? DELETE : ADD;
-
-			if (device_config_needed == ADD) {
-				device = scsi_device_lookup(
-					dev->scsi_host_ptr,
-					channel, id, lun);
-				if (device) {
-					scsi_remove_device(device);
-					scsi_device_put(device);
-				}
-			}
+			device_config_needed = DELETE;
 			break;
+
 		/*
 		 *	Morph or Expand complete
 		 */
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index 8077dba..c426ea2 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -346,7 +346,7 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 index, int isAif,
 			(fib_callback)aac_aif_callback, fibctx);
 	} else {
 		struct fib *fib = &dev->fibs[index];
-		struct hw_fib * hwfib = fib->hw_fib_va;
+		int start_callback = 0;
 
 		/*
 		 *	Remove this fib from the Outstanding I/O queue.
@@ -364,60 +364,104 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 index, int isAif,
 			return 0;
 		}
 
-		if (isFastResponse) {
-			/*
-			 *	Doctor the fib
-			 */
-			*(__le32 *)hwfib->data = cpu_to_le32(ST_OK);
-			hwfib->header.XferState |= cpu_to_le32(AdapterProcessed);
-			fib->flags |= FIB_CONTEXT_FLAG_FASTRESP;
-		}
-
 		FIB_COUNTER_INCREMENT(aac_config.FibRecved);
 
-		if (hwfib->header.Command == cpu_to_le16(NuFileSystem))
-		{
-			__le32 *pstatus = (__le32 *)hwfib->data;
-			if (*pstatus & cpu_to_le32(0xffff0000))
-				*pstatus = cpu_to_le32(ST_OK);
-		}
-		if (hwfib->header.XferState & cpu_to_le32(NoResponseExpected | Async)) 
-		{
-	        	if (hwfib->header.XferState & cpu_to_le32(NoResponseExpected))
-				FIB_COUNTER_INCREMENT(aac_config.NoResponseRecved);
-			else 
-				FIB_COUNTER_INCREMENT(aac_config.AsyncRecved);
-			/*
-			 *	NOTE:  we cannot touch the fib after this
-			 *	    call, because it may have been deallocated.
-			 */
-			if (likely(fib->callback && fib->callback_data)) {
-				fib->flags &= FIB_CONTEXT_FLAG_FASTRESP;
-				fib->callback(fib->callback_data, fib);
-			} else
-				dev_info(&dev->pdev->dev,
-				"Invalid callback_fib[%d] (*%p)(%p)\n",
-				index, fib->callback, fib->callback_data);
+		if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) {
+
+			if (isFastResponse)
+				fib->flags |= FIB_CONTEXT_FLAG_FASTRESP;
+
+			if (fib->callback) {
+				start_callback = 1;
+			} else {
+				unsigned long flagv;
+				int complete = 0;
+
+				dprintk((KERN_INFO "event_wait up\n"));
+				spin_lock_irqsave(&fib->event_lock, flagv);
+				if (fib->done == 2) {
+					fib->done = 1;
+					complete = 1;
+				} else {
+					fib->done = 1;
+					up(&fib->event_wait);
+				}
+				spin_unlock_irqrestore(&fib->event_lock, flagv);
+
+				spin_lock_irqsave(&dev->manage_lock, mflags);
+				dev->management_fib_count--;
+				spin_unlock_irqrestore(&dev->manage_lock,
+					mflags);
+
+				FIB_COUNTER_INCREMENT(aac_config.NativeRecved);
+				if (complete)
+					aac_fib_complete(fib);
+			}
 		} else {
-			unsigned long flagv;
-	  		dprintk((KERN_INFO "event_wait up\n"));
-			spin_lock_irqsave(&fib->event_lock, flagv);
-			if (!fib->done) {
-				fib->done = 1;
-				up(&fib->event_wait);
+			struct hw_fib *hwfib = fib->hw_fib_va;
+
+			if (isFastResponse) {
+				/* Doctor the fib */
+				*(__le32 *)hwfib->data = cpu_to_le32(ST_OK);
+				hwfib->header.XferState |=
+					cpu_to_le32(AdapterProcessed);
+				fib->flags |= FIB_CONTEXT_FLAG_FASTRESP;
 			}
-			spin_unlock_irqrestore(&fib->event_lock, flagv);
 
-			spin_lock_irqsave(&dev->manage_lock, mflags);
-			dev->management_fib_count--;
-			spin_unlock_irqrestore(&dev->manage_lock, mflags);
+			if (hwfib->header.Command ==
+				cpu_to_le16(NuFileSystem)) {
+				__le32 *pstatus = (__le32 *)hwfib->data;
 
-			FIB_COUNTER_INCREMENT(aac_config.NormalRecved);
-			if (fib->done == 2) {
+				if (*pstatus & cpu_to_le32(0xffff0000))
+					*pstatus = cpu_to_le32(ST_OK);
+			}
+			if (hwfib->header.XferState &
+				cpu_to_le32(NoResponseExpected | Async)) {
+				if (hwfib->header.XferState & cpu_to_le32(
+					NoResponseExpected))
+					FIB_COUNTER_INCREMENT(
+						aac_config.NoResponseRecved);
+				else
+					FIB_COUNTER_INCREMENT(
+						aac_config.AsyncRecved);
+				start_callback = 1;
+			} else {
+				unsigned long flagv;
+				int complete = 0;
+
+				dprintk((KERN_INFO "event_wait up\n"));
 				spin_lock_irqsave(&fib->event_lock, flagv);
-				fib->done = 0;
+				if (fib->done == 2) {
+					fib->done = 1;
+					complete = 1;
+				} else {
+					fib->done = 1;
+					up(&fib->event_wait);
+				}
 				spin_unlock_irqrestore(&fib->event_lock, flagv);
+
+				spin_lock_irqsave(&dev->manage_lock, mflags);
+				dev->management_fib_count--;
+				spin_unlock_irqrestore(&dev->manage_lock,
+					mflags);
+
+				FIB_COUNTER_INCREMENT(aac_config.NormalRecved);
+				if (complete)
+					aac_fib_complete(fib);
+			}
+		}
+
+
+		if (start_callback) {
+			/*
+			 * NOTE:  we cannot touch the fib after this
+			 *  call, because it may have been deallocated.
+			 */
+			if (likely(fib->callback && fib->callback_data)) {
+				fib->callback(fib->callback_data, fib);
+			} else {
 				aac_fib_complete(fib);
+				aac_fib_free(fib);
 			}
 
 		}
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 698d522..e95f1e5 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1102,6 +1102,7 @@ static void __aac_shutdown(struct aac_dev * aac)
 {
 	int i;
 
+	aac->adapter_shutdown = 1;
 	aac_send_shutdown(aac);
 
 	if (aac->aif_thread) {
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index af31c09..124efe6 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -457,6 +457,11 @@ static int aac_src_check_health(struct aac_dev *dev)
 	return 0;
 }
 
+static inline u32 aac_get_vector(struct aac_dev *dev)
+{
+	return atomic_inc_return(&dev->msix_counter)%dev->max_msix;
+}
+
 /**
  *	aac_src_deliver_message
  *	@fib: fib to issue
@@ -470,67 +475,100 @@ static int aac_src_deliver_message(struct fib *fib)
 	u32 fibsize;
 	dma_addr_t address;
 	struct aac_fib_xporthdr *pFibX;
+	int native_hba;
 #if !defined(writeq)
 	unsigned long flags;
 #endif
 
-	u16 hdr_size = le16_to_cpu(fib->hw_fib_va->header.Size);
 	u16 vector_no;
 
 	atomic_inc(&q->numpending);
 
-	if (dev->msi_enabled && fib->hw_fib_va->header.Command != AifRequest &&
-	    dev->max_msix > 1) {
-		vector_no = fib->vector_no;
-		fib->hw_fib_va->header.Handle += (vector_no << 16);
+	native_hba = (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) ? 1 : 0;
+
+
+	if (dev->msi_enabled && dev->max_msix > 1 &&
+		(native_hba || fib->hw_fib_va->header.Command != AifRequest)) {
+
+		if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)
+			&& dev->sa_firmware)
+			vector_no = aac_get_vector(dev);
+		else
+			vector_no = fib->vector_no;
+
+		if (native_hba) {
+			((struct aac_hba_cmd_req *)fib->hw_fib_va)->reply_qid
+				= vector_no;
+			((struct aac_hba_cmd_req *)fib->hw_fib_va)->request_id
+				+= (vector_no << 16);
+		} else {
+			fib->hw_fib_va->header.Handle += (vector_no << 16);
+		}
 	} else {
 		vector_no = 0;
 	}
 
 	atomic_inc(&dev->rrq_outstanding[vector_no]);
 
-	if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) ||
-		(dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)) {
-		/* Calculate the amount to the fibsize bits */
-		fibsize = (hdr_size + 127) / 128 - 1;
-		if (fibsize > (ALIGN32 - 1))
-			return -EMSGSIZE;
-		/* New FIB header, 32-bit */
+	if (native_hba) {
 		address = fib->hw_fib_pa;
-		fib->hw_fib_va->header.StructType = FIB_MAGIC2;
-		fib->hw_fib_va->header.SenderFibAddress = (u32)address;
-		fib->hw_fib_va->header.u.TimeStamp = 0;
-		BUG_ON(upper_32_bits(address) != 0L);
+		fibsize = (fib->hbacmd_size + 127) / 128 - 1;
+		if (fibsize > 31)
+			fibsize = 31;
 		address |= fibsize;
+#if defined(writeq)
+		src_writeq(dev, MUnit.IQN_L, (u64)address);
+#else
+		spin_lock_irqsave(&fib->dev->iq_lock, flags);
+		src_writel(dev, MUnit.IQN_H,
+			upper_32_bits(address) & 0xffffffff);
+		src_writel(dev, MUnit.IQN_L, address & 0xffffffff);
+		spin_unlock_irqrestore(&fib->dev->iq_lock, flags);
+#endif
 	} else {
-		/* Calculate the amount to the fibsize bits */
-		fibsize = (sizeof(struct aac_fib_xporthdr) + hdr_size + 127) / 128 - 1;
-		if (fibsize > (ALIGN32 - 1))
-			return -EMSGSIZE;
-
-		/* Fill XPORT header */
-		pFibX = (void *)fib->hw_fib_va - sizeof(struct aac_fib_xporthdr);
-		pFibX->Handle = cpu_to_le32(fib->hw_fib_va->header.Handle);
-		pFibX->HostAddress = cpu_to_le64(fib->hw_fib_pa);
-		pFibX->Size = cpu_to_le32(hdr_size);
-
-		/*
-		 * The xport header has been 32-byte aligned for us so that fibsize
-		 * can be masked out of this address by hardware. -- BenC
-		 */
-		address = fib->hw_fib_pa - sizeof(struct aac_fib_xporthdr);
-		if (address & (ALIGN32 - 1))
-			return -EINVAL;
+		if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2 ||
+			dev->comm_interface == AAC_COMM_MESSAGE_TYPE3) {
+			/* Calculate the amount to the fibsize bits */
+			fibsize = (le16_to_cpu(fib->hw_fib_va->header.Size)
+				+ 127) / 128 - 1;
+			/* New FIB header, 32-bit */
+			address = fib->hw_fib_pa;
+			fib->hw_fib_va->header.StructType = FIB_MAGIC2;
+			fib->hw_fib_va->header.SenderFibAddress =
+				cpu_to_le32((u32)address);
+			fib->hw_fib_va->header.u.TimeStamp = 0;
+			WARN_ON(((u32)(((address) >> 16) >> 16)) != 0L);
+		} else {
+			/* Calculate the amount to the fibsize bits */
+			fibsize = (sizeof(struct aac_fib_xporthdr) +
+				le16_to_cpu(fib->hw_fib_va->header.Size)
+				+ 127) / 128 - 1;
+			/* Fill XPORT header */
+			pFibX = (struct aac_fib_xporthdr *)
+				((unsigned char *)fib->hw_fib_va -
+				sizeof(struct aac_fib_xporthdr));
+			pFibX->Handle = fib->hw_fib_va->header.Handle;
+			pFibX->HostAddress =
+				cpu_to_le64((u64)fib->hw_fib_pa);
+			pFibX->Size = cpu_to_le32(
+				le16_to_cpu(fib->hw_fib_va->header.Size));
+			address = fib->hw_fib_pa -
+				(u64)sizeof(struct aac_fib_xporthdr);
+		}
+		if (fibsize > 31)
+			fibsize = 31;
 		address |= fibsize;
-	}
+
 #if defined(writeq)
-	src_writeq(dev, MUnit.IQ_L, (u64)address);
+		src_writeq(dev, MUnit.IQ_L, (u64)address);
 #else
-	spin_lock_irqsave(&fib->dev->iq_lock, flags);
-	src_writel(dev, MUnit.IQ_H, upper_32_bits(address) & 0xffffffff);
-	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
-	spin_unlock_irqrestore(&fib->dev->iq_lock, flags);
+		spin_lock_irqsave(&fib->dev->iq_lock, flags);
+		src_writel(dev, MUnit.IQ_H,
+			upper_32_bits(address) & 0xffffffff);
+		src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
+		spin_unlock_irqrestore(&fib->dev->iq_lock, flags);
 #endif
+	}
 	return 0;
 }
 
-- 
2.7.4

