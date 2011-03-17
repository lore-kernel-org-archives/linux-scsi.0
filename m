From: "Mahesh Rajashekhara" <Mahesh_Rajashekhara@pmc-sierra.com>
Subject: RE: [PATCH 1/1] AACRAID driver update patch version - 28000
Date: Thu, 17 Mar 2011 02:10:32 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C83926670E888C4F@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CBE483.2AD6F512"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:55068 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936Ab1CQJKj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 05:10:39 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Achim Leubner <Achim_Leubner@pmc-sierra.com>, Tony Ruiz <Tony_Ruiz@pmc-sierra.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01CBE483.2AD6F512
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi James,

Thanks for your comments.

We have added the changes suggested by Mark Salyzyn in this driver =
patch.

Patch description:
Added new hardware device 0x28b interface for PMC-Sierra's SRC based =
controller family.
- new src.c file for 0x28b specific functions
- new XPORT header required
- sync. command interface: doorbell bits shifted (SRC_ODR_SHIFT, =
SRC_IDR_SHIFT)
- async. Interface: different inbound queue handling, no outbound I2O =
queue available, using doorbell ("PmDoorBellResponseSent") and response =
buffer on the host ("host_rrq") for status
- changed AIF (adapter initiated FIBs) interface: "DoorBellAifPending" =
bit to inform about pending AIF, "AifRequest" command to read AIF, =
"NoMoreAifDataAvailable" to mark the end of the AIFs

Please see the patch below:

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's =
handling of patch attachments (inline gets damaged, please use =
attachment).

Signed-off-by: Mahesh Rajashekhara <aacraid@pmc-sierra.com>

---

drivers/scsi/aacraid/Makefile   |    2
drivers/scsi/aacraid/aachba.c   |    7
drivers/scsi/aacraid/aacraid.h  |  106 ++++++-
drivers/scsi/aacraid/commctrl.c |    3
drivers/scsi/aacraid/comminit.c |   58 +++
drivers/scsi/aacraid/commsup.c  |   41 ++
drivers/scsi/aacraid/dpcsup.c   |   85 ++++-
drivers/scsi/aacraid/linit.c    |   15 -
drivers/scsi/aacraid/nark.c     |    3
drivers/scsi/aacraid/rkt.c      |    3
drivers/scsi/aacraid/rx.c       |   33 +-
drivers/scsi/aacraid/sa.c       |    7
drivers/scsi/aacraid/src.c      |  594 =
++++++++++++++++++++++++++++++++++++++++
13 files changed, 898 insertions(+), 59 deletions(-)

diff -purN a/drivers/scsi/aacraid/aachba.c =
b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c	2011-03-11 14:16:36.000000000 +0530
+++ b/drivers/scsi/aacraid/aachba.c	2011-03-16 16:30:58.000000000 +0530
@@ -5,7 +5,8 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2010 Adaptec, Inc.
+ *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -1486,7 +1487,9 @@ int aac_get_adapter_info(struct aac_dev*
 			dev->a_ops.adapter_write =3D aac_write_block;
 		}
 		dev->scsi_host_ptr->max_sectors =3D AAC_MAX_32BIT_SGBCOUNT;
-		if(!(dev->adapter_info.options & AAC_OPT_NEW_COMM)) {
+		if (dev->adapter_info.options & AAC_OPT_NEW_COMM_TYPE1)
+			dev->adapter_info.options |=3D AAC_OPT_NEW_COMM;
+		if (!(dev->adapter_info.options & AAC_OPT_NEW_COMM)) {
 			/*
 			 * Worst case size that could cause sg overflow when
 			 * we break up SG elements that are larger than 64KB.
diff -purN a/drivers/scsi/aacraid/aacraid.h =
b/drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h	2011-03-11 14:16:36.000000000 +0530
+++ b/drivers/scsi/aacraid/aacraid.h	2011-03-16 16:50:55.000000000 +0530
@@ -12,7 +12,7 @@
  =
*------------------------------------------------------------------------=
----*/
=20
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 26400
+# define AAC_DRIVER_BUILD 28000
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
@@ -277,6 +277,16 @@ enum aac_queue_types {
=20
 #define		FsaNormal	1
=20
+/* transport FIB header (PMC) */
+struct aac_fib_xporthdr {
+	u64	HostAddress;	/* FIB host address w/o xport header */
+	u32	Size;		/* FIB size excluding xport header */
+	u32	Handle;		/* driver handle to reference the FIB */
+	u64	Reserved[2];
+};
+
+#define		ALIGN32		32
+
 /*
  * Define the FIB. The FIB is the where all the requested data and
  * command information are put to the application on the FSA adapter.
@@ -394,7 +404,9 @@ enum fib_xfer_state {
 	AdapterMicroFib			=3D (1<<17),
 	BIOSFibPath			=3D (1<<18),
 	FastResponseCapable		=3D (1<<19),
-	ApiFib				=3D (1<<20)	// Its an API Fib.
+	ApiFib				=3D (1<<20),	/* Its an API Fib */
+	/* PMC NEW COMM: There is no more AIF data pending */
+	NoMoreAifDataAvailable		=3D (1<<21)
 };
=20
 /*
@@ -404,6 +416,7 @@ enum fib_xfer_state {
=20
 #define ADAPTER_INIT_STRUCT_REVISION		3
 #define ADAPTER_INIT_STRUCT_REVISION_4		4 // rocket science
+#define ADAPTER_INIT_STRUCT_REVISION_6		6 /* PMC src */
=20
 struct aac_init
 {
@@ -428,9 +441,15 @@ struct aac_init
 #define INITFLAGS_NEW_COMM_SUPPORTED	0x00000001
 #define INITFLAGS_DRIVER_USES_UTC_TIME	0x00000010
 #define INITFLAGS_DRIVER_SUPPORTS_PM	0x00000020
+#define INITFLAGS_NEW_COMM_TYPE1_SUPPORTED	0x00000041
 	__le32	MaxIoCommands;	/* max outstanding commands */
 	__le32	MaxIoSize;	/* largest I/O command */
 	__le32	MaxFibSize;	/* largest FIB to adapter */
+	/* ADAPTER_INIT_STRUCT_REVISION_5 begins here */
+	__le32	MaxNumAif;	/* max number of aif */
+	/* ADAPTER_INIT_STRUCT_REVISION_6 begins here */
+	__le32	HostRRQ_AddrLow;
+	__le32	HostRRQ_AddrHigh;	/* Host RRQ (response queue) for SRC */
 };
=20
 enum aac_log_level {
@@ -685,7 +704,7 @@ struct rx_inbound {
 #define OutboundDoorbellReg	MUnit.ODR
=20
 struct rx_registers {
-	struct rx_mu_registers		MUnit;		/* 1300h - 1344h */
+	struct rx_mu_registers		MUnit;		/* 1300h - 1347h */
 	__le32				reserved1[2];	/* 1348h - 134ch */
 	struct rx_inbound		IndexRegs;
 };
@@ -703,7 +722,7 @@ struct rx_registers {
 #define rkt_inbound rx_inbound
=20
 struct rkt_registers {
-	struct rkt_mu_registers		MUnit;		 /* 1300h - 1344h */
+	struct rkt_mu_registers		MUnit;		 /* 1300h - 1347h */
 	__le32				reserved1[1006]; /* 1348h - 22fch */
 	struct rkt_inbound		IndexRegs;	 /* 2300h - */
 };
@@ -713,6 +732,44 @@ struct rkt_registers {
 #define rkt_writeb(AEP, CSR, value)	writeb(value, =
&((AEP)->regs.rkt->CSR))
 #define rkt_writel(AEP, CSR, value)	writel(value, =
&((AEP)->regs.rkt->CSR))
=20
+/*
+ * PMC SRC message unit registers
+ */
+
+#define src_inbound rx_inbound
+
+struct src_mu_registers {
+				/*	PCI*| Name */
+	__le32	reserved0[8];	/*	00h | Reserved */
+	__le32	IDR;		/*	20h | Inbound Doorbell Register */
+	__le32	IISR;		/*	24h | Inbound Int. Status Register */
+	__le32	reserved1[3];	/*	28h | Reserved */
+	__le32	OIMR;		/*	34h | Outbound Int. Mask Register */
+	__le32	reserved2[25];	/*	38h | Reserved */
+	__le32	ODR_R;		/*	9ch | Outbound Doorbell Read */
+	__le32	ODR_C;		/*	a0h | Outbound Doorbell Clear */
+	__le32	reserved3[6];	/*	a4h | Reserved */
+	__le32	OMR;		/*	bch | Outbound Message Register */
+	__le32	IQ_L;		/*  c0h | Inbound Queue (Low address) */
+	__le32	IQ_H;		/*  c4h | Inbound Queue (High address) */
+};
+
+struct src_registers {
+	struct src_mu_registers MUnit;	/* 00h - c7h */
+	__le32 reserved1[130790];	/* c8h - 7fc5fh */
+	struct src_inbound IndexRegs;	/* 7fc60h */
+};
+
+#define src_readb(AEP, CSR)		readb(&((AEP)->regs.src.bar0->CSR))
+#define src_readl(AEP, CSR)		readl(&((AEP)->regs.src.bar0->CSR))
+#define src_writeb(AEP, CSR, value)	writeb(value, \
+						&((AEP)->regs.src.bar0->CSR))
+#define src_writel(AEP, CSR, value)	writel(value, \
+						&((AEP)->regs.src.bar0->CSR))
+
+#define SRC_ODR_SHIFT		12
+#define SRC_IDR_SHIFT		9
+
 typedef void (*fib_callback)(void *ctxt, struct fib *fibctx);
=20
 struct aac_fib_context {
@@ -879,6 +936,7 @@ struct aac_supplement_adapter_info
 #define AAC_OPTION_MU_RESET		cpu_to_le32(0x00000001)
 #define AAC_OPTION_IGNORE_RESET		cpu_to_le32(0x00000002)
 #define AAC_OPTION_POWER_MANAGEMENT	cpu_to_le32(0x00000004)
+#define AAC_OPTION_DOORBELL_RESET	cpu_to_le32(0x00004000)
 #define AAC_SIS_VERSION_V3	3
 #define AAC_SIS_SLOT_UNKNOWN	0xFF
=20
@@ -940,6 +998,7 @@ struct aac_bus_info_response {
 #define AAC_OPT_SUPPLEMENT_ADAPTER_INFO	cpu_to_le32(1<<16)
 #define AAC_OPT_NEW_COMM		cpu_to_le32(1<<17)
 #define AAC_OPT_NEW_COMM_64		cpu_to_le32(1<<18)
+#define AAC_OPT_NEW_COMM_TYPE1		cpu_to_le32(1<<28)
=20
 struct aac_dev
 {
@@ -952,6 +1011,7 @@ struct aac_dev
 	 */
 	unsigned		max_fib_size;
 	unsigned		sg_tablesize;
+	unsigned		max_num_aif;
=20
 	/*
 	 *	Map for 128 fib objects (64k)
@@ -980,10 +1040,21 @@ struct aac_dev
 	struct adapter_ops	a_ops;
 	unsigned long		fsrev;		/* Main driver's revision number */
=20
-	unsigned		base_size;	/* Size of mapped in region */
+	unsigned long		dbg_base;	/* address of UART
+						 * debug buffer */
+
+	unsigned		base_size, dbg_size;	/* Size of
+							 *  mapped in region */
+
 	struct aac_init		*init;		/* Holds initialization info to communicate =
with adapter */
 	dma_addr_t		init_pa;	/* Holds physical address of the init struct */
=20
+	u32			*host_rrq;	/* response queue
+						 * if AAC_COMM_MESSAGE_TYPE1 */
+
+	dma_addr_t		host_rrq_pa;	/* phys. address */
+	u32			host_rrq_idx;	/* index into rrq buffer */
+
 	struct pci_dev		*pdev;		/* Our PCI interface */
 	void *			printfbuf;	/* pointer to buffer used for printf's from the =
adapter */
 	void *			comm_addr;	/* Base address of Comm area */
@@ -1003,14 +1074,20 @@ struct aac_dev
 	 */
 #ifndef AAC_MIN_FOOTPRINT_SIZE
 #	define AAC_MIN_FOOTPRINT_SIZE 8192
+#	define AAC_MIN_SRC_BAR0_SIZE 0x400000
+#	define AAC_MIN_SRC_BAR1_SIZE 0x800
 #endif
 	union
 	{
 		struct sa_registers __iomem *sa;
 		struct rx_registers __iomem *rx;
 		struct rkt_registers __iomem *rkt;
+		struct {
+			struct src_registers __iomem *bar0;
+			char __iomem *bar1;
+		} src;
 	} regs;
-	volatile void __iomem *base;
+	volatile void __iomem *base, *dbg_base_mapped;
 	volatile struct rx_inbound __iomem *IndexRegs;
 	u32			OIMR; /* Mask Register Cache */
 	/*
@@ -1031,9 +1108,8 @@ struct aac_dev
 	u8			comm_interface;
 #	define AAC_COMM_PRODUCER 0
 #	define AAC_COMM_MESSAGE  1
-	/* macro side-effects BEWARE */
-#	define			raw_io_interface \
-	  =
init->InitStructRevision=3D=3Dcpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_4)=

+#	define AAC_COMM_MESSAGE_TYPE1	3
+	u8			raw_io_interface;
 	u8			raw_io_64;
 	u8			printf_enabled;
 	u8			in_reset;
@@ -1789,6 +1865,10 @@ extern struct aac_common aac_config;
 #define DoorBellAdapterNormCmdNotFull	(1<<3)	/* Adapter -> Host */
 #define DoorBellAdapterNormRespNotFull	(1<<4)	/* Adapter -> Host */
 #define DoorBellPrintfReady		(1<<5)	/* Adapter -> Host */
+#define DoorBellAifPending		(1<<6)	/* Adapter -> Host */
+
+/* PMC specific outbound doorbell bits */
+#define PmDoorBellResponseSent		(1<<1)	/* Adapter -> Host */
=20
 /*
  *	For FIB communication, we need all of the following things
@@ -1831,6 +1911,9 @@ extern struct aac_common aac_config;
 #define		AifReqAPIJobUpdate	109	/* Update a job report from the API */
 #define		AifReqAPIJobFinish	110	/* Finish a job from the API */
=20
+/* PMC NEW COMM: Request the event data */
+#define		AifReqEvent		200
+
 /*
  *	Adapter Initiated FIB command structures. Start with the adapter
  *	initiated FIBs that really come from the adapter, and get responded
@@ -1886,10 +1969,13 @@ int aac_rx_init(struct aac_dev *dev);
 int aac_rkt_init(struct aac_dev *dev);
 int aac_nark_init(struct aac_dev *dev);
 int aac_sa_init(struct aac_dev *dev);
+int aac_src_init(struct aac_dev *dev);
 int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct =
hw_fib * hw_fib, int wait, struct fib * fibptr, unsigned long =
*nonotify);
 unsigned int aac_response_normal(struct aac_queue * q);
 unsigned int aac_command_normal(struct aac_queue * q);
-unsigned int aac_intr_normal(struct aac_dev * dev, u32 Index);
+unsigned int aac_intr_normal(struct aac_dev *dev, u32 Index,
+			int isAif, int isFastResponse,
+			struct hw_fib *aif_fib);
 int aac_reset_adapter(struct aac_dev * dev, int forced);
 int aac_check_health(struct aac_dev * dev);
 int aac_command_thread(void *data);
diff -purN a/drivers/scsi/aacraid/commctrl.c =
b/drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c	2011-03-11 14:16:36.000000000 =
+0530
+++ b/drivers/scsi/aacraid/commctrl.c	2011-03-16 16:30:58.000000000 =
+0530
@@ -5,7 +5,8 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2010 Adaptec, Inc.
+ *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff -purN a/drivers/scsi/aacraid/comminit.c =
b/drivers/scsi/aacraid/comminit.c
--- a/drivers/scsi/aacraid/comminit.c	2011-03-11 14:16:36.000000000 =
+0530
+++ b/drivers/scsi/aacraid/comminit.c	2011-03-16 16:30:58.000000000 =
+0530
@@ -5,7 +5,8 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2010 Adaptec, Inc.
+ *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -52,12 +53,16 @@ static int aac_alloc_comm(struct aac_dev
 	unsigned long size, align;
 	const unsigned long fibsize =3D 4096;
 	const unsigned long printfbufsiz =3D 256;
+	unsigned long host_rrq_size =3D 0;
 	struct aac_init *init;
 	dma_addr_t phys;
 	unsigned long aac_max_hostphysmempages;
=20
-	size =3D fibsize + sizeof(struct aac_init) + commsize + commalign + =
printfbufsiz;
-
+	if (dev->comm_interface =3D=3D AAC_COMM_MESSAGE_TYPE1)
+		host_rrq_size =3D (dev->scsi_host_ptr->can_queue
+			+ AAC_NUM_MGT_FIB) * sizeof(u32);
+	size =3D fibsize + sizeof(struct aac_init) + commsize +
+			commalign + printfbufsiz + host_rrq_size;
 =20
 	base =3D pci_alloc_consistent(dev->pdev, size, &phys);
=20
@@ -70,8 +75,14 @@ static int aac_alloc_comm(struct aac_dev
 	dev->comm_phys =3D phys;
 	dev->comm_size =3D size;
 =09
-	dev->init =3D (struct aac_init *)(base + fibsize);
-	dev->init_pa =3D phys + fibsize;
+	if (dev->comm_interface =3D=3D AAC_COMM_MESSAGE_TYPE1) {
+		dev->host_rrq =3D (u32 *)(base + fibsize);
+		dev->host_rrq_pa =3D phys + fibsize;
+		memset(dev->host_rrq, 0, host_rrq_size);
+	}
+
+	dev->init =3D (struct aac_init *)(base + fibsize + host_rrq_size);
+	dev->init_pa =3D phys + fibsize + host_rrq_size;
=20
 	init =3D dev->init;
=20
@@ -106,8 +117,13 @@ static int aac_alloc_comm(struct aac_dev
=20
 	init->InitFlags =3D 0;
 	if (dev->comm_interface =3D=3D AAC_COMM_MESSAGE) {
-		init->InitFlags =3D cpu_to_le32(INITFLAGS_NEW_COMM_SUPPORTED);
+		init->InitFlags |=3D cpu_to_le32(INITFLAGS_NEW_COMM_SUPPORTED);
 		dprintk((KERN_WARNING"aacraid: New Comm Interface enabled\n"));
+	} else if (dev->comm_interface =3D=3D AAC_COMM_MESSAGE_TYPE1) {
+		init->InitStructRevision =3D =
cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_6);
+		init->InitFlags |=3D cpu_to_le32(INITFLAGS_NEW_COMM_TYPE1_SUPPORTED);
+		dprintk((KERN_WARNING
+			"aacraid: New Comm Interface type1 enabled\n"));
 	}
 	init->InitFlags |=3D cpu_to_le32(INITFLAGS_DRIVER_USES_UTC_TIME |
 				       INITFLAGS_DRIVER_SUPPORTS_PM);
@@ -115,11 +131,18 @@ static int aac_alloc_comm(struct aac_dev
 	init->MaxIoSize =3D cpu_to_le32(dev->scsi_host_ptr->max_sectors << 9);
 	init->MaxFibSize =3D cpu_to_le32(dev->max_fib_size);
=20
+	init->MaxNumAif =3D cpu_to_le32(dev->max_num_aif);
+	init->HostRRQ_AddrHigh =3D (u32)((u64)dev->host_rrq_pa >> 32);
+	init->HostRRQ_AddrLow =3D (u32)(dev->host_rrq_pa & 0xffffffff);
+
+
 	/*
 	 * Increment the base address by the amount already used
 	 */
-	base =3D base + fibsize + sizeof(struct aac_init);
-	phys =3D (dma_addr_t)((ulong)phys + fibsize + sizeof(struct =
aac_init));
+	base =3D base + fibsize + host_rrq_size + sizeof(struct aac_init);
+	phys =3D (dma_addr_t)((ulong)phys + fibsize + host_rrq_size +
+		sizeof(struct aac_init));
+
 	/*
 	 *	Align the beginning of Headers to commalign
 	 */
@@ -314,15 +337,22 @@ struct aac_dev *aac_init_adapter(struct=20
 		- sizeof(struct aac_write) + sizeof(struct sgentry))
 			/ sizeof(struct sgentry);
 	dev->comm_interface =3D AAC_COMM_PRODUCER;
-	dev->raw_io_64 =3D 0;
+	dev->raw_io_interface =3D dev->raw_io_64 =3D 0;
+
 	if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
 		0, 0, 0, 0, 0, 0, status+0, status+1, status+2, NULL, NULL)) &&
 	 		(status[0] =3D=3D 0x00000001)) {
 		if (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_64))
 			dev->raw_io_64 =3D 1;
-		if (dev->a_ops.adapter_comm &&
-		    (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM)))
-			dev->comm_interface =3D AAC_COMM_MESSAGE;
+		if (dev->a_ops.adapter_comm) {
+			if (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_TYPE1)) {
+				dev->comm_interface =3D AAC_COMM_MESSAGE_TYPE1;
+				dev->raw_io_interface =3D 1;
+			} else if (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM)) {
+				dev->comm_interface =3D AAC_COMM_MESSAGE;
+				dev->raw_io_interface =3D 1;
+			}
+		}
 		if ((dev->comm_interface =3D=3D AAC_COMM_MESSAGE) &&
 		    (status[2] > dev->base_size)) {
 			aac_adapter_ioremap(dev, 0);
@@ -350,10 +380,12 @@ struct aac_dev *aac_init_adapter(struct=20
 		 *	status[3] & 0xFFFF	maximum number FIBs outstanding
 		 */
 		host->max_sectors =3D (status[1] >> 16) << 1;
-		dev->max_fib_size =3D status[1] & 0xFFFF;
+		/* Multiple of 32 for PMC */
+		dev->max_fib_size =3D status[1] & 0xFFE0;
 		host->sg_tablesize =3D status[2] >> 16;
 		dev->sg_tablesize =3D status[2] & 0xFFFF;
 		host->can_queue =3D (status[3] & 0xFFFF) - AAC_NUM_MGT_FIB;
+		dev->max_num_aif =3D status[4] & 0xFFFF;
 		/*
 		 *	NOTE:
 		 *	All these overrides are based on a fixed internal
diff -purN a/drivers/scsi/aacraid/commsup.c =
b/drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c	2011-03-11 14:16:36.000000000 +0530
+++ b/drivers/scsi/aacraid/commsup.c	2011-03-16 16:38:02.000000000 +0530
@@ -5,7 +5,8 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2010 Adaptec, Inc.
+ *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -63,9 +64,11 @@ static int fib_map_alloc(struct aac_dev=20
 	  "allocate hardware fibs pci_alloc_consistent(%p, %d * (%d + %d), =
%p)\n",
 	  dev->pdev, dev->max_fib_size, dev->scsi_host_ptr->can_queue,
 	  AAC_NUM_MGT_FIB, &dev->hw_fib_pa));
-	if((dev->hw_fib_va =3D pci_alloc_consistent(dev->pdev, =
dev->max_fib_size
-	  * (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB),
-	  &dev->hw_fib_pa))=3D=3DNULL)
+	dev->hw_fib_va =3D pci_alloc_consistent(dev->pdev,
+		(dev->max_fib_size + sizeof(struct aac_fib_xporthdr))
+		* (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) + (ALIGN32 - 1),
+		&dev->hw_fib_pa);
+	if (dev->hw_fib_va =3D=3D NULL)
 		return -ENOMEM;
 	return 0;
 }
@@ -110,9 +113,22 @@ int aac_fib_setup(struct aac_dev * dev)
 	if (i<0)
 		return -ENOMEM;
=20
+	/* 32 byte alignment for PMC */
+	hw_fib_pa =3D (dev->hw_fib_pa + (ALIGN32 - 1)) & ~(ALIGN32 - 1);
+	dev->hw_fib_va =3D (struct hw_fib *)((unsigned char *)dev->hw_fib_va +
+		(hw_fib_pa - dev->hw_fib_pa));
+	dev->hw_fib_pa =3D hw_fib_pa;
+	memset(dev->hw_fib_va, 0,
+		(dev->max_fib_size + sizeof(struct aac_fib_xporthdr)) *
+		(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB));
+
+	/* add Xport header */
+	dev->hw_fib_va =3D (struct hw_fib *)((unsigned char *)dev->hw_fib_va +
+		sizeof(struct aac_fib_xporthdr));
+	dev->hw_fib_pa +=3D sizeof(struct aac_fib_xporthdr);
+
 	hw_fib =3D dev->hw_fib_va;
 	hw_fib_pa =3D dev->hw_fib_pa;
-	memset(hw_fib, 0, dev->max_fib_size * (dev->scsi_host_ptr->can_queue + =
AAC_NUM_MGT_FIB));
 	/*
 	 *	Initialise the fibs
 	 */
@@ -129,8 +145,10 @@ int aac_fib_setup(struct aac_dev * dev)
 		hw_fib->header.XferState =3D cpu_to_le32(0xffffffff);
 		hw_fib->header.SenderSize =3D cpu_to_le16(dev->max_fib_size);
 		fibptr->hw_fib_pa =3D hw_fib_pa;
-		hw_fib =3D (struct hw_fib *)((unsigned char *)hw_fib + =
dev->max_fib_size);
-		hw_fib_pa =3D hw_fib_pa + dev->max_fib_size;
+		hw_fib =3D (struct hw_fib *)((unsigned char *)hw_fib +
+			dev->max_fib_size + sizeof(struct aac_fib_xporthdr));
+		hw_fib_pa =3D hw_fib_pa +
+			dev->max_fib_size + sizeof(struct aac_fib_xporthdr);
 	}
 	/*
 	 *	Add the fib chain to the free list
@@ -664,9 +682,14 @@ int aac_fib_adapter_complete(struct fib=20
 	unsigned long nointr =3D 0;
 	unsigned long qflags;
=20
+	if (dev->comm_interface =3D=3D AAC_COMM_MESSAGE_TYPE1) {
+		kfree(hw_fib);
+		return 0;
+	}
+
 	if (hw_fib->header.XferState =3D=3D 0) {
 		if (dev->comm_interface =3D=3D AAC_COMM_MESSAGE)
-			kfree (hw_fib);
+			kfree(hw_fib);
 		return 0;
 	}
 	/*
@@ -674,7 +697,7 @@ int aac_fib_adapter_complete(struct fib=20
 	 */
 	if (hw_fib->header.StructType !=3D FIB_MAGIC) {
 		if (dev->comm_interface =3D=3D AAC_COMM_MESSAGE)
-			kfree (hw_fib);
+			kfree(hw_fib);
 		return -EINVAL;
 	}
 	/*
diff -purN a/drivers/scsi/aacraid/dpcsup.c =
b/drivers/scsi/aacraid/dpcsup.c
--- a/drivers/scsi/aacraid/dpcsup.c	2011-03-11 14:16:36.000000000 +0530
+++ b/drivers/scsi/aacraid/dpcsup.c	2011-03-16 16:30:58.000000000 +0530
@@ -5,7 +5,8 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2010 Adaptec, Inc.
+ *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -228,6 +229,48 @@ unsigned int aac_command_normal(struct a
 	return 0;
 }
=20
+/*
+ *
+ * aac_aif_callback
+ * @context: the context set in the fib - here it is scsi cmd
+ * @fibptr: pointer to the fib
+ *
+ * Handles the AIFs - new method (SRC)
+ *
+ */
+
+static void aac_aif_callback(void *context, struct fib * fibptr)
+{
+	struct fib *fibctx;
+	struct aac_dev *dev;
+	struct aac_aifcmd *cmd;
+	int status;
+
+	fibctx =3D (struct fib *)context;
+	BUG_ON(fibptr =3D=3D NULL);
+	dev =3D fibptr->dev;
+
+	if (fibptr->hw_fib_va->header.XferState &
+	    cpu_to_le32(NoMoreAifDataAvailable)) {
+		aac_fib_complete(fibptr);
+		aac_fib_free(fibptr);
+		return;
+	}
+
+	aac_intr_normal(dev, 0, 1, 0, fibptr->hw_fib_va);
+
+	aac_fib_init(fibctx);
+	cmd =3D (struct aac_aifcmd *) fib_data(fibctx);
+	cmd->command =3D cpu_to_le32(AifReqEvent);
+
+	status =3D aac_fib_send(AifRequest,
+		fibctx,
+		sizeof(struct hw_fib)-sizeof(struct aac_fibhdr),
+		FsaNormal,
+		0, 1,
+		(fib_callback)aac_aif_callback, fibctx);
+}
+
=20
 /**
  *	aac_intr_normal	-	Handle command replies
@@ -238,19 +281,17 @@ unsigned int aac_command_normal(struct a
  *	know there is a response on our normal priority queue. We will pull =
off
  *	all QE there are and wake up all the waiters before exiting.
  */
-
-unsigned int aac_intr_normal(struct aac_dev * dev, u32 index)
+unsigned int aac_intr_normal(struct aac_dev *dev, u32 index,
+			int isAif, int isFastResponse, struct hw_fib *aif_fib)
 {
 	unsigned long mflags;
 	dprintk((KERN_INFO "aac_intr_normal(%p,%x)\n", dev, index));
-	if ((index & 0x00000002L)) {
+	if (isAif =3D=3D 1) {	/* AIF - common */
 		struct hw_fib * hw_fib;
 		struct fib * fib;
 		struct aac_queue *q =3D &dev->queues->queue[HostNormCmdQueue];
 		unsigned long flags;
=20
-		if (index =3D=3D 0xFFFFFFFEL) /* Special Case */
-			return 0;	  /* Do nothing */
 		/*
 		 *	Allocate a FIB. For non queued stuff we can just use
 		 * the stack so we are happy. We need a fib object in order to
@@ -263,8 +304,13 @@ unsigned int aac_intr_normal(struct aac_
 			kfree (fib);
 			return 1;
 		}
-		memcpy(hw_fib, (struct hw_fib *)(((uintptr_t)(dev->regs.sa)) +
-		  (index & ~0x00000002L)), sizeof(struct hw_fib));
+		if (aif_fib !=3D NULL) {
+			memcpy(hw_fib, aif_fib, sizeof(struct hw_fib));
+		} else {
+			memcpy(hw_fib,
+				(struct hw_fib *)(((uintptr_t)(dev->regs.sa)) +
+				index), sizeof(struct hw_fib));
+		}
 		INIT_LIST_HEAD(&fib->fiblink);
 		fib->type =3D FSAFS_NTC_FIB_CONTEXT;
 		fib->size =3D sizeof(struct fib);
@@ -277,9 +323,26 @@ unsigned int aac_intr_normal(struct aac_
 	        wake_up_interruptible(&q->cmdready);
 		spin_unlock_irqrestore(q->lock, flags);
 		return 1;
+	} else if (isAif =3D=3D 2) {	/* AIF - new (SRC) */
+		struct fib *fibctx;
+		struct aac_aifcmd *cmd;
+
+		fibctx =3D aac_fib_alloc(dev);
+		if (!fibctx)
+			return 1;
+		aac_fib_init(fibctx);
+
+		cmd =3D (struct aac_aifcmd *) fib_data(fibctx);
+		cmd->command =3D cpu_to_le32(AifReqEvent);
+
+		return aac_fib_send(AifRequest,
+			fibctx,
+			sizeof(struct hw_fib)-sizeof(struct aac_fibhdr),
+			FsaNormal,
+			0, 1,
+			(fib_callback)aac_aif_callback, fibctx);
 	} else {
-		int fast =3D index & 0x01;
-		struct fib * fib =3D &dev->fibs[index >> 2];
+		struct fib *fib =3D &dev->fibs[index];
 		struct hw_fib * hwfib =3D fib->hw_fib_va;
=20
 		/*
@@ -298,7 +361,7 @@ unsigned int aac_intr_normal(struct aac_
 			return 0;
 		}
=20
-		if (fast) {
+		if (isFastResponse) {
 			/*
 			 *	Doctor the fib
 			 */
diff -purN a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c	2011-03-11 14:16:36.000000000 +0530
+++ b/drivers/scsi/aacraid/linit.c	2011-03-16 16:30:58.000000000 +0530
@@ -5,7 +5,8 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2010 Adaptec, Inc.
+ *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -54,7 +55,7 @@
=20
 #include "aacraid.h"
=20
-#define AAC_DRIVER_VERSION		"1.1-5"
+#define AAC_DRIVER_VERSION		"1.1-7"
 #ifndef AAC_DRIVER_BRANCH
 #define AAC_DRIVER_BRANCH		""
 #endif
@@ -161,6 +162,7 @@ static const struct pci_device_id aac_pc
 	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 59 }, /* Adaptec Catch =
All */
 	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 60 }, /* Adaptec =
Rocket Catch All */
 	{ 0x9005, 0x0288, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 61 }, /* Adaptec =
NEMER/ARK Catch All */
+	{ 0x9005, 0x028b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 62 }, /* Adaptec PMC =
Catch All */
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
@@ -235,7 +237,8 @@ static struct aac_driver_ident aac_drive
 	{ aac_rx_init, "aacraid",  "Legend  ", "RAID            ", 2, =
AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend =
Catchall */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "RAID            ", 2 }, /* =
Adaptec Catch All */
 	{ aac_rkt_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }, /* =
Adaptec Rocket Catch All */
-	{ aac_nark_init, "aacraid", "ADAPTEC ", "RAID            ", 2 } /* =
Adaptec NEMER/ARK Catch All */
+	{ aac_nark_init, "aacraid", "ADAPTEC ", "RAID           ", 2 }, /* =
Adaptec NEMER/ARK Catch All */
+	{ aac_src_init, "aacraid", "ADAPTEC ", "RAID            ", 2 } /* =
Adaptec PMC Catch All */
 };
=20
 /**
@@ -653,8 +656,10 @@ static int aac_eh_reset(struct scsi_cmnd
 	 * This adapter needs a blind reset, only do so for Adapters that
 	 * support a register, instead of a commanded, reset.
 	 */
-	if ((aac->supplement_adapter_info.SupportedOptions2 &
-	   AAC_OPTION_MU_RESET) &&
+	if (((aac->supplement_adapter_info.SupportedOptions2 &
+	  AAC_OPTION_MU_RESET) ||
+	  (aac->supplement_adapter_info.SupportedOptions2 &
+	  AAC_OPTION_DOORBELL_RESET)) &&
 	  aac_check_reset &&
 	  ((aac_check_reset !=3D 1) ||
 	   !(aac->supplement_adapter_info.SupportedOptions2 &
diff -purN a/drivers/scsi/aacraid/Makefile =
b/drivers/scsi/aacraid/Makefile
--- a/drivers/scsi/aacraid/Makefile	2011-03-11 14:16:36.000000000 +0530
+++ b/drivers/scsi/aacraid/Makefile	2011-03-16 16:30:58.000000000 +0530
@@ -3,6 +3,6 @@
 obj-$(CONFIG_SCSI_AACRAID) :=3D aacraid.o
=20
 aacraid-objs	:=3D linit.o aachba.o commctrl.o comminit.o commsup.o \
-		   dpcsup.o rx.o sa.o rkt.o nark.o
+		   dpcsup.o rx.o sa.o rkt.o nark.o src.o
=20
 EXTRA_CFLAGS	:=3D -Idrivers/scsi
diff -purN a/drivers/scsi/aacraid/nark.c b/drivers/scsi/aacraid/nark.c
--- a/drivers/scsi/aacraid/nark.c	2011-03-11 14:16:36.000000000 +0530
+++ b/drivers/scsi/aacraid/nark.c	2011-03-16 16:30:58.000000000 +0530
@@ -4,7 +4,8 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2006-2007 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2010 Adaptec, Inc.
+ *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff -purN a/drivers/scsi/aacraid/rkt.c b/drivers/scsi/aacraid/rkt.c
--- a/drivers/scsi/aacraid/rkt.c	2011-03-11 14:16:36.000000000 +0530
+++ b/drivers/scsi/aacraid/rkt.c	2011-03-16 16:30:58.000000000 +0530
@@ -5,7 +5,8 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2010 Adaptec, Inc.
+ *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff -purN a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
--- a/drivers/scsi/aacraid/rx.c	2011-03-11 14:16:36.000000000 +0530
+++ b/drivers/scsi/aacraid/rx.c	2011-03-16 16:30:58.000000000 +0530
@@ -5,7 +5,8 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2010 Adaptec, Inc.
+ *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -84,15 +85,35 @@ static irqreturn_t aac_rx_intr_producer(
=20
 static irqreturn_t aac_rx_intr_message(int irq, void *dev_id)
 {
+	int isAif, isFastResponse, isSpecial;
 	struct aac_dev *dev =3D dev_id;
 	u32 Index =3D rx_readl(dev, MUnit.OutboundQueue);
 	if (unlikely(Index =3D=3D 0xFFFFFFFFL))
 		Index =3D rx_readl(dev, MUnit.OutboundQueue);
 	if (likely(Index !=3D 0xFFFFFFFFL)) {
 		do {
-			if (unlikely(aac_intr_normal(dev, Index))) {
-				rx_writel(dev, MUnit.OutboundQueue, Index);
-				rx_writel(dev, MUnit.ODR, DoorBellAdapterNormRespReady);
+			isAif =3D isFastResponse =3D isSpecial =3D 0;
+			if (Index & 0x00000002L) {
+				isAif =3D 1;
+				if (Index =3D=3D 0xFFFFFFFEL)
+					isSpecial =3D 1;
+				Index &=3D ~0x00000002L;
+			} else {
+				if (Index & 0x00000001L)
+					isFastResponse =3D 1;
+				Index >>=3D 2;
+			}
+			if (!isSpecial) {
+				if (unlikely(aac_intr_normal(dev,
+						Index, isAif,
+						isFastResponse, NULL))) {
+					rx_writel(dev,
+						MUnit.OutboundQueue,
+						Index);
+					rx_writel(dev,
+						MUnit.ODR,
+						DoorBellAdapterNormRespReady);
+				}
 			}
 			Index =3D rx_readl(dev, MUnit.OutboundQueue);
 		} while (Index !=3D 0xFFFFFFFFL);
@@ -631,6 +652,10 @@ int _aac_rx_init(struct aac_dev *dev)
 			name, instance);
 		goto error_iounmap;
 	}
+	dev->dbg_base =3D dev->scsi_host_ptr->base;
+	dev->dbg_base_mapped =3D dev->base;
+	dev->dbg_size =3D dev->base_size;
+
 	aac_adapter_enable_int(dev);
 	/*
 	 *	Tell the adapter that all is configured, and it can
diff -purN a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
--- a/drivers/scsi/aacraid/sa.c	2011-03-11 14:16:36.000000000 +0530
+++ b/drivers/scsi/aacraid/sa.c	2011-03-16 16:30:58.000000000 +0530
@@ -5,7 +5,8 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2010 Adaptec, Inc.
+ *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -391,6 +392,10 @@ int aac_sa_init(struct aac_dev *dev)
 			name, instance);
 		goto error_iounmap;
 	}
+	dev->dbg_base =3D dev->scsi_host_ptr->base;
+	dev->dbg_base_mapped =3D dev->base;
+	dev->dbg_size =3D dev->base_size;
+
 	aac_adapter_enable_int(dev);
=20
 	/*
diff -purN a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
--- a/drivers/scsi/aacraid/src.c	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/scsi/aacraid/src.c	2011-03-16 16:44:27.000000000 +0530
@@ -0,0 +1,594 @@
+/*
+ *	Adaptec AAC series RAID controller driver
+ *	(c) Copyright 2001 Red Hat Inc.
+ *
+ * based on the old aacraid driver that is..
+ * Adaptec aacraid device driver for Linux.
+ *
+ * Copyright (c) 2000-2010 Adaptec, Inc.
+ *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, =
USA.
+ *
+ * Module Name:
+ *  src.c
+ *
+ * Abstract: Hardware Device Interface for PMC SRC based controllers
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/version.h>
+#include <linux/completion.h>
+#include <linux/time.h>
+#include <linux/interrupt.h>
+#include <scsi/scsi_host.h>
+
+#include "aacraid.h"
+
+static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
+{
+	struct aac_dev *dev =3D dev_id;
+	unsigned long bellbits, bellbits_shifted;
+	int our_interrupt =3D 0;
+	int isFastResponse;
+	u32 index, handle;
+
+	bellbits =3D src_readl(dev, MUnit.ODR_R);
+	if (bellbits & PmDoorBellResponseSent) {
+		bellbits =3D PmDoorBellResponseSent;
+		/* handle async. status */
+		our_interrupt =3D 1;
+		index =3D dev->host_rrq_idx;
+		if (dev->host_rrq[index] =3D=3D 0) {
+			u32 old_index =3D index;
+			/* adjust index */
+			do {
+				index++;
+				if (index =3D=3D dev->scsi_host_ptr->can_queue +
+							AAC_NUM_MGT_FIB)
+					index =3D 0;
+				if (dev->host_rrq[index] !=3D 0)
+					break;
+			} while (index !=3D old_index);
+			dev->host_rrq_idx =3D index;
+		}
+		for (;;) {
+			isFastResponse =3D 0;
+			/* remove toggle bit (31) */
+			handle =3D (dev->host_rrq[index] & 0x7fffffff);
+			/* check fast response bit (30) */
+			if (handle & 0x40000000)
+				isFastResponse =3D 1;
+			handle &=3D 0x0000ffff;
+			if (handle =3D=3D 0)
+				break;
+
+			aac_intr_normal(dev, handle-1, 0, isFastResponse, NULL);
+
+			dev->host_rrq[index++] =3D 0;
+			if (index =3D=3D dev->scsi_host_ptr->can_queue +
+						AAC_NUM_MGT_FIB)
+				index =3D 0;
+			dev->host_rrq_idx =3D index;
+		}
+	} else {
+		bellbits_shifted =3D (bellbits >> SRC_ODR_SHIFT);
+		if (bellbits_shifted & DoorBellAifPending) {
+			our_interrupt =3D 1;
+			/* handle AIF */
+			aac_intr_normal(dev, 0, 2, 0, NULL);
+		}
+	}
+
+	if (our_interrupt) {
+		src_writel(dev, MUnit.ODR_C, bellbits);
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
+
+/**
+ *	aac_src_disable_interrupt	-	Disable interrupts
+ *	@dev: Adapter
+ */
+
+static void aac_src_disable_interrupt(struct aac_dev *dev)
+{
+	src_writel(dev, MUnit.OIMR, dev->OIMR =3D 0xffffffff);
+}
+
+/**
+ *	aac_src_enable_interrupt_message	-	Enable interrupts
+ *	@dev: Adapter
+ */
+
+static void aac_src_enable_interrupt_message(struct aac_dev *dev)
+{
+	src_writel(dev, MUnit.OIMR, dev->OIMR =3D 0xfffffff8);
+}
+
+/**
+ *	src_sync_cmd	-	send a command and wait
+ *	@dev: Adapter
+ *	@command: Command to execute
+ *	@p1: first parameter
+ *	@ret: adapter status
+ *
+ *	This routine will send a synchronous command to the adapter and wait
+ *	for its	completion.
+ */
+
+static int src_sync_cmd(struct aac_dev *dev, u32 command,
+	u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6,
+	u32 *status, u32 * r1, u32 * r2, u32 * r3, u32 * r4)
+{
+	unsigned long start;
+	int ok;
+
+	/*
+	 *	Write the command into Mailbox 0
+	 */
+	writel(command, &dev->IndexRegs->Mailbox[0]);
+	/*
+	 *	Write the parameters into Mailboxes 1 - 6
+	 */
+	writel(p1, &dev->IndexRegs->Mailbox[1]);
+	writel(p2, &dev->IndexRegs->Mailbox[2]);
+	writel(p3, &dev->IndexRegs->Mailbox[3]);
+	writel(p4, &dev->IndexRegs->Mailbox[4]);
+
+	/*
+	 *	Clear the synch command doorbell to start on a clean slate.
+	 */
+	src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
+
+	/*
+	 *	Disable doorbell interrupts
+	 */
+	src_writel(dev, MUnit.OIMR, dev->OIMR =3D 0xffffffff);
+
+	/*
+	 *	Force the completion of the mask register write before issuing
+	 *	the interrupt.
+	 */
+	src_readl(dev, MUnit.OIMR);
+
+	/*
+	 *	Signal that there is a new synch command
+	 */
+	src_writel(dev, MUnit.IDR, INBOUNDDOORBELL_0 << SRC_IDR_SHIFT);
+
+	ok =3D 0;
+	start =3D jiffies;
+
+	/*
+	 *	Wait up to 30 seconds
+	 */
+	while (time_before(jiffies, start+30*HZ)) {
+		/* Delay 5 microseconds to let Mon960 get info. */
+		udelay(5);
+
+		/* Mon960 will set doorbell0 bit
+		 * when it has completed the command
+		 */
+		if ((src_readl(dev, MUnit.ODR_R) >> SRC_ODR_SHIFT) & =
OUTBOUNDDOORBELL_0) {
+			/* Clear the doorbell */
+			src_writel(dev,
+				MUnit.ODR_C,
+				OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
+			ok =3D 1;
+			break;
+		}
+
+		 /* Yield the processor in case we are slow */
+		msleep(1);
+	}
+	if (unlikely(ok !=3D 1)) {
+		 /* Restore interrupt mask even though we timed out */
+		aac_adapter_enable_int(dev);
+		return -ETIMEDOUT;
+	}
+
+	 /* Pull the synch status from Mailbox 0 */
+	if (status)
+		*status =3D readl(&dev->IndexRegs->Mailbox[0]);
+	if (r1)
+		*r1 =3D readl(&dev->IndexRegs->Mailbox[1]);
+	if (r2)
+		*r2 =3D readl(&dev->IndexRegs->Mailbox[2]);
+	if (r3)
+		*r3 =3D readl(&dev->IndexRegs->Mailbox[3]);
+	if (r4)
+		*r4 =3D readl(&dev->IndexRegs->Mailbox[4]);
+
+	 /* Clear the synch command doorbell */
+	src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
+
+	 /* Restore interrupt mask */
+	aac_adapter_enable_int(dev);
+	return 0;
+
+}
+
+/**
+ *	aac_src_interrupt_adapter	-	interrupt adapter
+ *	@dev: Adapter
+ *
+ *	Send an interrupt to the i960 and breakpoint it.
+ */
+
+static void aac_src_interrupt_adapter(struct aac_dev *dev)
+{
+	src_sync_cmd(dev, BREAKPOINT_REQUEST,
+		0, 0, 0, 0, 0, 0,
+		NULL, NULL, NULL, NULL, NULL);
+}
+
+/**
+ *	aac_src_notify_adapter		-	send an event to the adapter
+ *	@dev: Adapter
+ *	@event: Event to send
+ *
+ *	Notify the i960 that something it probably cares about has
+ *	happened.
+ */
+
+static void aac_src_notify_adapter(struct aac_dev *dev, u32 event)
+{
+	switch (event) {
+
+	case AdapNormCmdQue:
+		src_writel(dev, MUnit.ODR_C,
+			INBOUNDDOORBELL_1 << SRC_ODR_SHIFT);
+		break;
+	case HostNormRespNotFull:
+		src_writel(dev, MUnit.ODR_C,
+			INBOUNDDOORBELL_4 << SRC_ODR_SHIFT);
+		break;
+	case AdapNormRespQue:
+		src_writel(dev, MUnit.ODR_C,
+			INBOUNDDOORBELL_2 << SRC_ODR_SHIFT);
+		break;
+	case HostNormCmdNotFull:
+		src_writel(dev, MUnit.ODR_C,
+			INBOUNDDOORBELL_3 << SRC_ODR_SHIFT);
+		break;
+	case FastIo:
+		src_writel(dev, MUnit.ODR_C,
+			INBOUNDDOORBELL_6 << SRC_ODR_SHIFT);
+		break;
+	case AdapPrintfDone:
+		src_writel(dev, MUnit.ODR_C,
+			INBOUNDDOORBELL_5 << SRC_ODR_SHIFT);
+		break;
+	default:
+		BUG();
+		break;
+	}
+}
+
+/**
+ *	aac_src_start_adapter		-	activate adapter
+ *	@dev:	Adapter
+ *
+ *	Start up processing on an i960 based AAC adapter
+ */
+
+static void aac_src_start_adapter(struct aac_dev *dev)
+{
+	struct aac_init *init;
+
+	init =3D dev->init;
+	init->HostElapsedSeconds =3D cpu_to_le32(get_seconds());
+
+	/* We can only use a 32 bit address here */
+	src_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa,
+	  0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL);
+}
+
+/**
+ *	aac_src_check_health
+ *	@dev: device to check if healthy
+ *
+ *	Will attempt to determine if the specified adapter is alive and
+ *	capable of handling requests, returning 0 if alive.
+ */
+static int aac_src_check_health(struct aac_dev *dev)
+{
+	u32 status =3D src_readl(dev, MUnit.OMR);
+
+	/*
+	 *	Check to see if the board failed any self tests.
+	 */
+	if (unlikely(status & SELF_TEST_FAILED))
+		return -1;
+
+	/*
+	 *	Check to see if the board panic'd.
+	 */
+	if (unlikely(status & KERNEL_PANIC))
+		return (status >> 16) & 0xFF;
+	/*
+	 *	Wait for the adapter to be up and running.
+	 */
+	if (unlikely(!(status & KERNEL_UP_AND_RUNNING)))
+		return -3;
+	/*
+	 *	Everything is OK
+	 */
+	return 0;
+}
+
+/**
+ *	aac_src_deliver_message
+ *	@fib: fib to issue
+ *
+ *	Will send a fib, returning 0 if successful.
+ */
+static int aac_src_deliver_message(struct fib *fib)
+{
+	struct aac_dev *dev =3D fib->dev;
+	struct aac_queue *q =3D &dev->queues->queue[AdapNormCmdQueue];
+	unsigned long qflags;
+	u32 fibsize;
+	u64 address;
+	struct aac_fib_xporthdr *pFibX;
+
+	spin_lock_irqsave(q->lock, qflags);
+	q->numpending++;
+	spin_unlock_irqrestore(q->lock, qflags);
+
+	/* Calculate the amount to the fibsize bits */
+	fibsize =3D (sizeof(struct aac_fib_xporthdr) +
+		fib->hw_fib_va->header.Size + 127) / 128 - 1;
+	if (fibsize > (ALIGN32 - 1))
+		fibsize =3D ALIGN32 - 1;
+
+    /* Fill XPORT header */
+	pFibX =3D (struct aac_fib_xporthdr *)
+		((unsigned char *)fib->hw_fib_va -
+		sizeof(struct aac_fib_xporthdr));
+	pFibX->Handle =3D fib->hw_fib_va->header.SenderData + 1;
+	pFibX->HostAddress =3D fib->hw_fib_pa;
+	pFibX->Size =3D fib->hw_fib_va->header.Size;
+	address =3D fib->hw_fib_pa - (u64)sizeof(struct aac_fib_xporthdr);
+
+	src_writel(dev, MUnit.IQ_H, (u32)(address >> 32));
+	src_writel(dev, MUnit.IQ_L, (u32)(address & 0xffffffff) + fibsize);
+	return 0;
+}
+
+/**
+ *	aac_src_ioremap
+ *	@size: mapping resize request
+ *
+ */
+static int aac_src_ioremap(struct aac_dev *dev, u32 size)
+{
+	if (!size) {
+		iounmap(dev->regs.src.bar0);
+		dev->regs.src.bar0 =3D NULL;
+		iounmap(dev->base);
+		dev->base =3D NULL;
+		return 0;
+	}
+	dev->regs.src.bar1 =3D ioremap(pci_resource_start(dev->pdev, 2),
+		AAC_MIN_SRC_BAR1_SIZE);
+	dev->base =3D NULL;
+	if (dev->regs.src.bar1 =3D=3D NULL)
+		return -1;
+	dev->base =3D dev->regs.src.bar0 =3D ioremap(dev->scsi_host_ptr->base,
+				size);
+	if (dev->base =3D=3D NULL) {
+		iounmap(dev->regs.src.bar1);
+		dev->regs.src.bar1 =3D NULL;
+		return -1;
+	}
+	dev->IndexRegs =3D &((struct src_registers __iomem *)
+		dev->base)->IndexRegs;
+	return 0;
+}
+
+static int aac_src_restart_adapter(struct aac_dev *dev, int bled)
+{
+	u32 var, reset_mask;
+
+	if (bled >=3D 0) {
+		if (bled)
+			printk(KERN_ERR "%s%d: adapter kernel panic'd %x.\n",
+				dev->name, dev->id, bled);
+		bled =3D aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS,
+			0, 0, 0, 0, 0, 0, &var, &reset_mask, NULL, NULL, NULL);
+			if (bled || (var !=3D 0x00000001))
+				bled =3D -EINVAL;
+		if (dev->supplement_adapter_info.SupportedOptions2 &
+			AAC_OPTION_DOORBELL_RESET) {
+			src_writel(dev, MUnit.IDR, reset_mask);
+			msleep(5000); /* Delay 5 seconds */
+		}
+	}
+
+	if (src_readl(dev, MUnit.OMR) & KERNEL_PANIC)
+		return -ENODEV;
+
+	if (startup_timeout < 300)
+		startup_timeout =3D 300;
+
+	return 0;
+}
+
+/**
+ *	aac_src_select_comm	-	Select communications method
+ *	@dev: Adapter
+ *	@comm: communications method
+ */
+int aac_src_select_comm(struct aac_dev *dev, int comm)
+{
+	switch (comm) {
+	case AAC_COMM_MESSAGE:
+		dev->a_ops.adapter_enable_int =3D aac_src_enable_interrupt_message;
+		dev->a_ops.adapter_intr =3D aac_src_intr_message;
+		dev->a_ops.adapter_deliver =3D aac_src_deliver_message;
+		break;
+	default:
+		return 1;
+	}
+	return 0;
+}
+
+/**
+ *  aac_src_init	-	initialize an Cardinal Frey Bar card
+ *  @dev: device to configure
+ *
+ */
+
+int aac_src_init(struct aac_dev *dev)
+{
+	unsigned long start;
+	unsigned long status;
+	int restart =3D 0;
+	int instance =3D dev->id;
+	const char *name =3D dev->name;
+
+	dev->a_ops.adapter_ioremap =3D aac_src_ioremap;
+	dev->a_ops.adapter_comm =3D aac_src_select_comm;
+
+	dev->base_size =3D AAC_MIN_SRC_BAR0_SIZE;
+	if (aac_adapter_ioremap(dev, dev->base_size)) {
+		printk(KERN_WARNING "%s: unable to map adapter.\n", name);
+		goto error_iounmap;
+	}
+
+	/* Failure to reset here is an option ... */
+	dev->a_ops.adapter_sync_cmd =3D src_sync_cmd;
+	dev->a_ops.adapter_enable_int =3D aac_src_disable_interrupt;
+	if ((aac_reset_devices || reset_devices) &&
+		!aac_src_restart_adapter(dev, 0))
+		++restart;
+	/*
+	 *	Check to see if the board panic'd while booting.
+	 */
+	status =3D src_readl(dev, MUnit.OMR);
+	if (status & KERNEL_PANIC) {
+		if (aac_src_restart_adapter(dev, aac_src_check_health(dev)))
+			goto error_iounmap;
+		++restart;
+	}
+	/*
+	 *	Check to see if the board failed any self tests.
+	 */
+	status =3D src_readl(dev, MUnit.OMR);
+	if (status & SELF_TEST_FAILED) {
+		printk(KERN_ERR "%s%d: adapter self-test failed.\n",
+			dev->name, instance);
+		goto error_iounmap;
+	}
+	/*
+	 *	Check to see if the monitor panic'd while booting.
+	 */
+	if (status & MONITOR_PANIC) {
+		printk(KERN_ERR "%s%d: adapter monitor panic.\n",
+			dev->name, instance);
+		goto error_iounmap;
+	}
+	start =3D jiffies;
+	/*
+	 *	Wait for the adapter to be up and running. Wait up to 3 minutes
+	 */
+	while (!((status =3D src_readl(dev, MUnit.OMR)) &
+		KERNEL_UP_AND_RUNNING)) {
+		if ((restart &&
+		  (status & (KERNEL_PANIC|SELF_TEST_FAILED|MONITOR_PANIC))) ||
+		  time_after(jiffies, start+HZ*startup_timeout)) {
+			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status =
=3D %lx.\n",
+					dev->name, instance, status);
+			goto error_iounmap;
+		}
+		if (!restart &&
+		  ((status & (KERNEL_PANIC|SELF_TEST_FAILED|MONITOR_PANIC)) ||
+		  time_after(jiffies, start + HZ *
+		  ((startup_timeout > 60)
+		    ? (startup_timeout - 60)
+		    : (startup_timeout / 2))))) {
+			if (likely(!aac_src_restart_adapter(dev,
+			    aac_src_check_health(dev))))
+				start =3D jiffies;
+			++restart;
+		}
+		msleep(1);
+	}
+	if (restart && aac_commit)
+		aac_commit =3D 1;
+	/*
+	 *	Fill in the common function dispatch table.
+	 */
+	dev->a_ops.adapter_interrupt =3D aac_src_interrupt_adapter;
+	dev->a_ops.adapter_disable_int =3D aac_src_disable_interrupt;
+	dev->a_ops.adapter_notify =3D aac_src_notify_adapter;
+	dev->a_ops.adapter_sync_cmd =3D src_sync_cmd;
+	dev->a_ops.adapter_check_health =3D aac_src_check_health;
+	dev->a_ops.adapter_restart =3D aac_src_restart_adapter;
+
+	/*
+	 *	First clear out all interrupts.  Then enable the one's that we
+	 *	can handle.
+	 */
+	aac_adapter_comm(dev, AAC_COMM_MESSAGE);
+	aac_adapter_disable_int(dev);
+	src_writel(dev, MUnit.ODR_C, 0xffffffff);
+	aac_adapter_enable_int(dev);
+
+	if (aac_init_adapter(dev) =3D=3D NULL)
+		goto error_iounmap;
+	if (dev->comm_interface !=3D AAC_COMM_MESSAGE_TYPE1)
+		goto error_iounmap;
+
+	dev->msi =3D aac_msi && !pci_enable_msi(dev->pdev);
+
+	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
+			IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {
+
+		if (dev->msi)
+			pci_disable_msi(dev->pdev);
+
+		printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
+			name, instance);
+		goto error_iounmap;
+	}
+	dev->dbg_base =3D pci_resource_start(dev->pdev, 2);
+	dev->dbg_base_mapped =3D dev->regs.src.bar1;
+	dev->dbg_size =3D AAC_MIN_SRC_BAR1_SIZE;
+
+	aac_adapter_enable_int(dev);
+	/*
+	 *	Tell the adapter that all is configured, and it can
+	 * start accepting requests
+	 */
+	aac_src_start_adapter(dev);
+
+	return 0;
+
+error_iounmap:
+
+	return -1;
+}

Regards - Mahesh Rajashekhara

------_=_NextPart_001_01CBE483.2AD6F512
Content-Type: application/octet-stream;
	name="AACRAID-Series6.patch"
Content-Transfer-Encoding: base64
Content-Description: AACRAID-Series6.patch
Content-Disposition: attachment;
	filename="AACRAID-Series6.patch"

VGhpcyBhdHRhY2hlZCBwYXRjaCBpcyBhZ2FpbnN0IGN1cnJlbnQgc2NzaS1taXNjLTIuNi4KCk9i
bGlnYXRvcnlEaXNjbGFpbWVyOiBQbGVhc2UgYWNjZXB0IG15IGNvbmRvbGVuY2VzIHJlZ2FyZGlu
ZyBPdXRsb29rJ3MgaGFuZGxpbmcgb2YgcGF0Y2ggYXR0YWNobWVudHMgKGlubGluZSBnZXRzIGRh
bWFnZWQsIHBsZWFzZSB1c2UgYXR0YWNobWVudCkuCgpTaWduZWQtb2ZmLWJ5OiBNYWhlc2ggUmFq
YXNoZWtoYXJhIDxhYWNyYWlkQHBtYy1zaWVycmEuY29tPgoKLS0tCgpkcml2ZXJzL3Njc2kvYWFj
cmFpZC9NYWtlZmlsZSAgIHwgICAgMgpkcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyAgIHwg
ICAgNwpkcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNyYWlkLmggIHwgIDEwNiArKysrKystCmRyaXZl
cnMvc2NzaS9hYWNyYWlkL2NvbW1jdHJsLmMgfCAgICAzCmRyaXZlcnMvc2NzaS9hYWNyYWlkL2Nv
bW1pbml0LmMgfCAgIDU4ICsrKwpkcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tc3VwLmMgIHwgICA0
MSArKwpkcml2ZXJzL3Njc2kvYWFjcmFpZC9kcGNzdXAuYyAgIHwgICA4NSArKysrLQpkcml2ZXJz
L3Njc2kvYWFjcmFpZC9saW5pdC5jICAgIHwgICAxNSAtCmRyaXZlcnMvc2NzaS9hYWNyYWlkL25h
cmsuYyAgICAgfCAgICAzCmRyaXZlcnMvc2NzaS9hYWNyYWlkL3JrdC5jICAgICAgfCAgICAzCmRy
aXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMgICAgICAgfCAgIDMzICstCmRyaXZlcnMvc2NzaS9hYWNy
YWlkL3NhLmMgICAgICAgfCAgICA3CmRyaXZlcnMvc2NzaS9hYWNyYWlkL3NyYy5jICAgICAgfCAg
NTk0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKMTMgZmlsZXMgY2hh
bmdlZCwgODk4IGluc2VydGlvbnMoKyksIDU5IGRlbGV0aW9ucygtKQoKZGlmZiAtcHVyTiBhL2Ry
aXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFjaGJh
LmMKLS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFjaGJhLmMJMjAxMS0wMy0xMSAxNDoxNjoz
Ni4wMDAwMDAwMDAgKzA1MzAKKysrIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFjaGJhLmMJMjAx
MS0wMy0xNiAxNjozMDo1OC4wMDAwMDAwMDAgKzA1MzAKQEAgLTUsNyArNSw4IEBACiAgKiBiYXNl
ZCBvbiB0aGUgb2xkIGFhY3JhaWQgZHJpdmVyIHRoYXQgaXMuLgogICogQWRhcHRlYyBhYWNyYWlk
IGRldmljZSBkcml2ZXIgZm9yIExpbnV4LgogICoKLSAqIENvcHlyaWdodCAoYykgMjAwMC0yMDA3
IEFkYXB0ZWMsIEluYy4gKGFhY3JhaWRAYWRhcHRlYy5jb20pCisgKiBDb3B5cmlnaHQgKGMpIDIw
MDAtMjAxMCBBZGFwdGVjLCBJbmMuCisgKiAgICAgICAgICAgICAgIDIwMTAgUE1DLVNpZXJyYSwg
SW5jLiAoYWFjcmFpZEBwbWMtc2llcnJhLmNvbSkKICAqCiAgKiBUaGlzIHByb2dyYW0gaXMgZnJl
ZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQogICogaXQg
dW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJs
aXNoZWQgYnkKQEAgLTE0ODYsNyArMTQ4Nyw5IEBAIGludCBhYWNfZ2V0X2FkYXB0ZXJfaW5mbyhz
dHJ1Y3QgYWFjX2RldioKIAkJCWRldi0+YV9vcHMuYWRhcHRlcl93cml0ZSA9IGFhY193cml0ZV9i
bG9jazsKIAkJfQogCQlkZXYtPnNjc2lfaG9zdF9wdHItPm1heF9zZWN0b3JzID0gQUFDX01BWF8z
MkJJVF9TR0JDT1VOVDsKLQkJaWYoIShkZXYtPmFkYXB0ZXJfaW5mby5vcHRpb25zICYgQUFDX09Q
VF9ORVdfQ09NTSkpIHsKKwkJaWYgKGRldi0+YWRhcHRlcl9pbmZvLm9wdGlvbnMgJiBBQUNfT1BU
X05FV19DT01NX1RZUEUxKQorCQkJZGV2LT5hZGFwdGVyX2luZm8ub3B0aW9ucyB8PSBBQUNfT1BU
X05FV19DT01NOworCQlpZiAoIShkZXYtPmFkYXB0ZXJfaW5mby5vcHRpb25zICYgQUFDX09QVF9O
RVdfQ09NTSkpIHsKIAkJCS8qCiAJCQkgKiBXb3JzdCBjYXNlIHNpemUgdGhhdCBjb3VsZCBjYXVz
ZSBzZyBvdmVyZmxvdyB3aGVuCiAJCQkgKiB3ZSBicmVhayB1cCBTRyBlbGVtZW50cyB0aGF0IGFy
ZSBsYXJnZXIgdGhhbiA2NEtCLgpkaWZmIC1wdXJOIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFj
cmFpZC5oIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFjcmFpZC5oCi0tLSBhL2RyaXZlcnMvc2Nz
aS9hYWNyYWlkL2FhY3JhaWQuaAkyMDExLTAzLTExIDE0OjE2OjM2LjAwMDAwMDAwMCArMDUzMAor
KysgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNyYWlkLmgJMjAxMS0wMy0xNiAxNjo1MDo1NS4w
MDAwMDAwMDAgKzA1MzAKQEAgLTEyLDcgKzEyLDcgQEAKICAqLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSov
CiAKICNpZm5kZWYgQUFDX0RSSVZFUl9CVUlMRAotIyBkZWZpbmUgQUFDX0RSSVZFUl9CVUlMRCAy
NjQwMAorIyBkZWZpbmUgQUFDX0RSSVZFUl9CVUlMRCAyODAwMAogIyBkZWZpbmUgQUFDX0RSSVZF
Ul9CUkFOQ0ggIi1tcyIKICNlbmRpZgogI2RlZmluZSBNQVhJTVVNX05VTV9DT05UQUlORVJTCTMy
CkBAIC0yNzcsNiArMjc3LDE2IEBAIGVudW0gYWFjX3F1ZXVlX3R5cGVzIHsKIAogI2RlZmluZQkJ
RnNhTm9ybWFsCTEKIAorLyogdHJhbnNwb3J0IEZJQiBoZWFkZXIgKFBNQykgKi8KK3N0cnVjdCBh
YWNfZmliX3hwb3J0aGRyIHsKKwl1NjQJSG9zdEFkZHJlc3M7CS8qIEZJQiBob3N0IGFkZHJlc3Mg
dy9vIHhwb3J0IGhlYWRlciAqLworCXUzMglTaXplOwkJLyogRklCIHNpemUgZXhjbHVkaW5nIHhw
b3J0IGhlYWRlciAqLworCXUzMglIYW5kbGU7CQkvKiBkcml2ZXIgaGFuZGxlIHRvIHJlZmVyZW5j
ZSB0aGUgRklCICovCisJdTY0CVJlc2VydmVkWzJdOworfTsKKworI2RlZmluZQkJQUxJR04zMgkJ
MzIKKwogLyoKICAqIERlZmluZSB0aGUgRklCLiBUaGUgRklCIGlzIHRoZSB3aGVyZSBhbGwgdGhl
IHJlcXVlc3RlZCBkYXRhIGFuZAogICogY29tbWFuZCBpbmZvcm1hdGlvbiBhcmUgcHV0IHRvIHRo
ZSBhcHBsaWNhdGlvbiBvbiB0aGUgRlNBIGFkYXB0ZXIuCkBAIC0zOTQsNyArNDA0LDkgQEAgZW51
bSBmaWJfeGZlcl9zdGF0ZSB7CiAJQWRhcHRlck1pY3JvRmliCQkJPSAoMTw8MTcpLAogCUJJT1NG
aWJQYXRoCQkJPSAoMTw8MTgpLAogCUZhc3RSZXNwb25zZUNhcGFibGUJCT0gKDE8PDE5KSwKLQlB
cGlGaWIJCQkJPSAoMTw8MjApCS8vIEl0cyBhbiBBUEkgRmliLgorCUFwaUZpYgkJCQk9ICgxPDwy
MCksCS8qIEl0cyBhbiBBUEkgRmliICovCisJLyogUE1DIE5FVyBDT01NOiBUaGVyZSBpcyBubyBt
b3JlIEFJRiBkYXRhIHBlbmRpbmcgKi8KKwlOb01vcmVBaWZEYXRhQXZhaWxhYmxlCQk9ICgxPDwy
MSkKIH07CiAKIC8qCkBAIC00MDQsNiArNDE2LDcgQEAgZW51bSBmaWJfeGZlcl9zdGF0ZSB7CiAK
ICNkZWZpbmUgQURBUFRFUl9JTklUX1NUUlVDVF9SRVZJU0lPTgkJMwogI2RlZmluZSBBREFQVEVS
X0lOSVRfU1RSVUNUX1JFVklTSU9OXzQJCTQgLy8gcm9ja2V0IHNjaWVuY2UKKyNkZWZpbmUgQURB
UFRFUl9JTklUX1NUUlVDVF9SRVZJU0lPTl82CQk2IC8qIFBNQyBzcmMgKi8KIAogc3RydWN0IGFh
Y19pbml0CiB7CkBAIC00MjgsOSArNDQxLDE1IEBAIHN0cnVjdCBhYWNfaW5pdAogI2RlZmluZSBJ
TklURkxBR1NfTkVXX0NPTU1fU1VQUE9SVEVECTB4MDAwMDAwMDEKICNkZWZpbmUgSU5JVEZMQUdT
X0RSSVZFUl9VU0VTX1VUQ19USU1FCTB4MDAwMDAwMTAKICNkZWZpbmUgSU5JVEZMQUdTX0RSSVZF
Ul9TVVBQT1JUU19QTQkweDAwMDAwMDIwCisjZGVmaW5lIElOSVRGTEFHU19ORVdfQ09NTV9UWVBF
MV9TVVBQT1JURUQJMHgwMDAwMDA0MQogCV9fbGUzMglNYXhJb0NvbW1hbmRzOwkvKiBtYXggb3V0
c3RhbmRpbmcgY29tbWFuZHMgKi8KIAlfX2xlMzIJTWF4SW9TaXplOwkvKiBsYXJnZXN0IEkvTyBj
b21tYW5kICovCiAJX19sZTMyCU1heEZpYlNpemU7CS8qIGxhcmdlc3QgRklCIHRvIGFkYXB0ZXIg
Ki8KKwkvKiBBREFQVEVSX0lOSVRfU1RSVUNUX1JFVklTSU9OXzUgYmVnaW5zIGhlcmUgKi8KKwlf
X2xlMzIJTWF4TnVtQWlmOwkvKiBtYXggbnVtYmVyIG9mIGFpZiAqLworCS8qIEFEQVBURVJfSU5J
VF9TVFJVQ1RfUkVWSVNJT05fNiBiZWdpbnMgaGVyZSAqLworCV9fbGUzMglIb3N0UlJRX0FkZHJM
b3c7CisJX19sZTMyCUhvc3RSUlFfQWRkckhpZ2g7CS8qIEhvc3QgUlJRIChyZXNwb25zZSBxdWV1
ZSkgZm9yIFNSQyAqLwogfTsKIAogZW51bSBhYWNfbG9nX2xldmVsIHsKQEAgLTY4NSw3ICs3MDQs
NyBAQCBzdHJ1Y3QgcnhfaW5ib3VuZCB7CiAjZGVmaW5lIE91dGJvdW5kRG9vcmJlbGxSZWcJTVVu
aXQuT0RSCiAKIHN0cnVjdCByeF9yZWdpc3RlcnMgewotCXN0cnVjdCByeF9tdV9yZWdpc3RlcnMJ
CU1Vbml0OwkJLyogMTMwMGggLSAxMzQ0aCAqLworCXN0cnVjdCByeF9tdV9yZWdpc3RlcnMJCU1V
bml0OwkJLyogMTMwMGggLSAxMzQ3aCAqLwogCV9fbGUzMgkJCQlyZXNlcnZlZDFbMl07CS8qIDEz
NDhoIC0gMTM0Y2ggKi8KIAlzdHJ1Y3QgcnhfaW5ib3VuZAkJSW5kZXhSZWdzOwogfTsKQEAgLTcw
Myw3ICs3MjIsNyBAQCBzdHJ1Y3QgcnhfcmVnaXN0ZXJzIHsKICNkZWZpbmUgcmt0X2luYm91bmQg
cnhfaW5ib3VuZAogCiBzdHJ1Y3Qgcmt0X3JlZ2lzdGVycyB7Ci0Jc3RydWN0IHJrdF9tdV9yZWdp
c3RlcnMJCU1Vbml0OwkJIC8qIDEzMDBoIC0gMTM0NGggKi8KKwlzdHJ1Y3Qgcmt0X211X3JlZ2lz
dGVycwkJTVVuaXQ7CQkgLyogMTMwMGggLSAxMzQ3aCAqLwogCV9fbGUzMgkJCQlyZXNlcnZlZDFb
MTAwNl07IC8qIDEzNDhoIC0gMjJmY2ggKi8KIAlzdHJ1Y3Qgcmt0X2luYm91bmQJCUluZGV4UmVn
czsJIC8qIDIzMDBoIC0gKi8KIH07CkBAIC03MTMsNiArNzMyLDQ0IEBAIHN0cnVjdCBya3RfcmVn
aXN0ZXJzIHsKICNkZWZpbmUgcmt0X3dyaXRlYihBRVAsIENTUiwgdmFsdWUpCXdyaXRlYih2YWx1
ZSwgJigoQUVQKS0+cmVncy5ya3QtPkNTUikpCiAjZGVmaW5lIHJrdF93cml0ZWwoQUVQLCBDU1Is
IHZhbHVlKQl3cml0ZWwodmFsdWUsICYoKEFFUCktPnJlZ3Mucmt0LT5DU1IpKQogCisvKgorICog
UE1DIFNSQyBtZXNzYWdlIHVuaXQgcmVnaXN0ZXJzCisgKi8KKworI2RlZmluZSBzcmNfaW5ib3Vu
ZCByeF9pbmJvdW5kCisKK3N0cnVjdCBzcmNfbXVfcmVnaXN0ZXJzIHsKKwkJCQkvKglQQ0kqfCBO
YW1lICovCisJX19sZTMyCXJlc2VydmVkMFs4XTsJLyoJMDBoIHwgUmVzZXJ2ZWQgKi8KKwlfX2xl
MzIJSURSOwkJLyoJMjBoIHwgSW5ib3VuZCBEb29yYmVsbCBSZWdpc3RlciAqLworCV9fbGUzMglJ
SVNSOwkJLyoJMjRoIHwgSW5ib3VuZCBJbnQuIFN0YXR1cyBSZWdpc3RlciAqLworCV9fbGUzMgly
ZXNlcnZlZDFbM107CS8qCTI4aCB8IFJlc2VydmVkICovCisJX19sZTMyCU9JTVI7CQkvKgkzNGgg
fCBPdXRib3VuZCBJbnQuIE1hc2sgUmVnaXN0ZXIgKi8KKwlfX2xlMzIJcmVzZXJ2ZWQyWzI1XTsJ
LyoJMzhoIHwgUmVzZXJ2ZWQgKi8KKwlfX2xlMzIJT0RSX1I7CQkvKgk5Y2ggfCBPdXRib3VuZCBE
b29yYmVsbCBSZWFkICovCisJX19sZTMyCU9EUl9DOwkJLyoJYTBoIHwgT3V0Ym91bmQgRG9vcmJl
bGwgQ2xlYXIgKi8KKwlfX2xlMzIJcmVzZXJ2ZWQzWzZdOwkvKglhNGggfCBSZXNlcnZlZCAqLwor
CV9fbGUzMglPTVI7CQkvKgliY2ggfCBPdXRib3VuZCBNZXNzYWdlIFJlZ2lzdGVyICovCisJX19s
ZTMyCUlRX0w7CQkvKiAgYzBoIHwgSW5ib3VuZCBRdWV1ZSAoTG93IGFkZHJlc3MpICovCisJX19s
ZTMyCUlRX0g7CQkvKiAgYzRoIHwgSW5ib3VuZCBRdWV1ZSAoSGlnaCBhZGRyZXNzKSAqLworfTsK
Kworc3RydWN0IHNyY19yZWdpc3RlcnMgeworCXN0cnVjdCBzcmNfbXVfcmVnaXN0ZXJzIE1Vbml0
OwkvKiAwMGggLSBjN2ggKi8KKwlfX2xlMzIgcmVzZXJ2ZWQxWzEzMDc5MF07CS8qIGM4aCAtIDdm
YzVmaCAqLworCXN0cnVjdCBzcmNfaW5ib3VuZCBJbmRleFJlZ3M7CS8qIDdmYzYwaCAqLworfTsK
KworI2RlZmluZSBzcmNfcmVhZGIoQUVQLCBDU1IpCQlyZWFkYigmKChBRVApLT5yZWdzLnNyYy5i
YXIwLT5DU1IpKQorI2RlZmluZSBzcmNfcmVhZGwoQUVQLCBDU1IpCQlyZWFkbCgmKChBRVApLT5y
ZWdzLnNyYy5iYXIwLT5DU1IpKQorI2RlZmluZSBzcmNfd3JpdGViKEFFUCwgQ1NSLCB2YWx1ZSkJ
d3JpdGViKHZhbHVlLCBcCisJCQkJCQkmKChBRVApLT5yZWdzLnNyYy5iYXIwLT5DU1IpKQorI2Rl
ZmluZSBzcmNfd3JpdGVsKEFFUCwgQ1NSLCB2YWx1ZSkJd3JpdGVsKHZhbHVlLCBcCisJCQkJCQkm
KChBRVApLT5yZWdzLnNyYy5iYXIwLT5DU1IpKQorCisjZGVmaW5lIFNSQ19PRFJfU0hJRlQJCTEy
CisjZGVmaW5lIFNSQ19JRFJfU0hJRlQJCTkKKwogdHlwZWRlZiB2b2lkICgqZmliX2NhbGxiYWNr
KSh2b2lkICpjdHh0LCBzdHJ1Y3QgZmliICpmaWJjdHgpOwogCiBzdHJ1Y3QgYWFjX2ZpYl9jb250
ZXh0IHsKQEAgLTg3OSw2ICs5MzYsNyBAQCBzdHJ1Y3QgYWFjX3N1cHBsZW1lbnRfYWRhcHRlcl9p
bmZvCiAjZGVmaW5lIEFBQ19PUFRJT05fTVVfUkVTRVQJCWNwdV90b19sZTMyKDB4MDAwMDAwMDEp
CiAjZGVmaW5lIEFBQ19PUFRJT05fSUdOT1JFX1JFU0VUCQljcHVfdG9fbGUzMigweDAwMDAwMDAy
KQogI2RlZmluZSBBQUNfT1BUSU9OX1BPV0VSX01BTkFHRU1FTlQJY3B1X3RvX2xlMzIoMHgwMDAw
MDAwNCkKKyNkZWZpbmUgQUFDX09QVElPTl9ET09SQkVMTF9SRVNFVAljcHVfdG9fbGUzMigweDAw
MDA0MDAwKQogI2RlZmluZSBBQUNfU0lTX1ZFUlNJT05fVjMJMwogI2RlZmluZSBBQUNfU0lTX1NM
T1RfVU5LTk9XTgkweEZGCiAKQEAgLTk0MCw2ICs5OTgsNyBAQCBzdHJ1Y3QgYWFjX2J1c19pbmZv
X3Jlc3BvbnNlIHsKICNkZWZpbmUgQUFDX09QVF9TVVBQTEVNRU5UX0FEQVBURVJfSU5GTwljcHVf
dG9fbGUzMigxPDwxNikKICNkZWZpbmUgQUFDX09QVF9ORVdfQ09NTQkJY3B1X3RvX2xlMzIoMTw8
MTcpCiAjZGVmaW5lIEFBQ19PUFRfTkVXX0NPTU1fNjQJCWNwdV90b19sZTMyKDE8PDE4KQorI2Rl
ZmluZSBBQUNfT1BUX05FV19DT01NX1RZUEUxCQljcHVfdG9fbGUzMigxPDwyOCkKIAogc3RydWN0
IGFhY19kZXYKIHsKQEAgLTk1Miw2ICsxMDExLDcgQEAgc3RydWN0IGFhY19kZXYKIAkgKi8KIAl1
bnNpZ25lZAkJbWF4X2ZpYl9zaXplOwogCXVuc2lnbmVkCQlzZ190YWJsZXNpemU7CisJdW5zaWdu
ZWQJCW1heF9udW1fYWlmOwogCiAJLyoKIAkgKglNYXAgZm9yIDEyOCBmaWIgb2JqZWN0cyAoNjRr
KQpAQCAtOTgwLDEwICsxMDQwLDIxIEBAIHN0cnVjdCBhYWNfZGV2CiAJc3RydWN0IGFkYXB0ZXJf
b3BzCWFfb3BzOwogCXVuc2lnbmVkIGxvbmcJCWZzcmV2OwkJLyogTWFpbiBkcml2ZXIncyByZXZp
c2lvbiBudW1iZXIgKi8KIAotCXVuc2lnbmVkCQliYXNlX3NpemU7CS8qIFNpemUgb2YgbWFwcGVk
IGluIHJlZ2lvbiAqLworCXVuc2lnbmVkIGxvbmcJCWRiZ19iYXNlOwkvKiBhZGRyZXNzIG9mIFVB
UlQKKwkJCQkJCSAqIGRlYnVnIGJ1ZmZlciAqLworCisJdW5zaWduZWQJCWJhc2Vfc2l6ZSwgZGJn
X3NpemU7CS8qIFNpemUgb2YKKwkJCQkJCQkgKiAgbWFwcGVkIGluIHJlZ2lvbiAqLworCiAJc3Ry
dWN0IGFhY19pbml0CQkqaW5pdDsJCS8qIEhvbGRzIGluaXRpYWxpemF0aW9uIGluZm8gdG8gY29t
bXVuaWNhdGUgd2l0aCBhZGFwdGVyICovCiAJZG1hX2FkZHJfdAkJaW5pdF9wYTsJLyogSG9sZHMg
cGh5c2ljYWwgYWRkcmVzcyBvZiB0aGUgaW5pdCBzdHJ1Y3QgKi8KIAorCXUzMgkJCSpob3N0X3Jy
cTsJLyogcmVzcG9uc2UgcXVldWUKKwkJCQkJCSAqIGlmIEFBQ19DT01NX01FU1NBR0VfVFlQRTEg
Ki8KKworCWRtYV9hZGRyX3QJCWhvc3RfcnJxX3BhOwkvKiBwaHlzLiBhZGRyZXNzICovCisJdTMy
CQkJaG9zdF9ycnFfaWR4OwkvKiBpbmRleCBpbnRvIHJycSBidWZmZXIgKi8KKwogCXN0cnVjdCBw
Y2lfZGV2CQkqcGRldjsJCS8qIE91ciBQQ0kgaW50ZXJmYWNlICovCiAJdm9pZCAqCQkJcHJpbnRm
YnVmOwkvKiBwb2ludGVyIHRvIGJ1ZmZlciB1c2VkIGZvciBwcmludGYncyBmcm9tIHRoZSBhZGFw
dGVyICovCiAJdm9pZCAqCQkJY29tbV9hZGRyOwkvKiBCYXNlIGFkZHJlc3Mgb2YgQ29tbSBhcmVh
ICovCkBAIC0xMDAzLDE0ICsxMDc0LDIwIEBAIHN0cnVjdCBhYWNfZGV2CiAJICovCiAjaWZuZGVm
IEFBQ19NSU5fRk9PVFBSSU5UX1NJWkUKICMJZGVmaW5lIEFBQ19NSU5fRk9PVFBSSU5UX1NJWkUg
ODE5MgorIwlkZWZpbmUgQUFDX01JTl9TUkNfQkFSMF9TSVpFIDB4NDAwMDAwCisjCWRlZmluZSBB
QUNfTUlOX1NSQ19CQVIxX1NJWkUgMHg4MDAKICNlbmRpZgogCXVuaW9uCiAJewogCQlzdHJ1Y3Qg
c2FfcmVnaXN0ZXJzIF9faW9tZW0gKnNhOwogCQlzdHJ1Y3QgcnhfcmVnaXN0ZXJzIF9faW9tZW0g
KnJ4OwogCQlzdHJ1Y3Qgcmt0X3JlZ2lzdGVycyBfX2lvbWVtICpya3Q7CisJCXN0cnVjdCB7CisJ
CQlzdHJ1Y3Qgc3JjX3JlZ2lzdGVycyBfX2lvbWVtICpiYXIwOworCQkJY2hhciBfX2lvbWVtICpi
YXIxOworCQl9IHNyYzsKIAl9IHJlZ3M7Ci0Jdm9sYXRpbGUgdm9pZCBfX2lvbWVtICpiYXNlOwor
CXZvbGF0aWxlIHZvaWQgX19pb21lbSAqYmFzZSwgKmRiZ19iYXNlX21hcHBlZDsKIAl2b2xhdGls
ZSBzdHJ1Y3QgcnhfaW5ib3VuZCBfX2lvbWVtICpJbmRleFJlZ3M7CiAJdTMyCQkJT0lNUjsgLyog
TWFzayBSZWdpc3RlciBDYWNoZSAqLwogCS8qCkBAIC0xMDMxLDkgKzExMDgsOCBAQCBzdHJ1Y3Qg
YWFjX2RldgogCXU4CQkJY29tbV9pbnRlcmZhY2U7CiAjCWRlZmluZSBBQUNfQ09NTV9QUk9EVUNF
UiAwCiAjCWRlZmluZSBBQUNfQ09NTV9NRVNTQUdFICAxCi0JLyogbWFjcm8gc2lkZS1lZmZlY3Rz
IEJFV0FSRSAqLwotIwlkZWZpbmUJCQlyYXdfaW9faW50ZXJmYWNlIFwKLQkgIGluaXQtPkluaXRT
dHJ1Y3RSZXZpc2lvbj09Y3B1X3RvX2xlMzIoQURBUFRFUl9JTklUX1NUUlVDVF9SRVZJU0lPTl80
KQorIwlkZWZpbmUgQUFDX0NPTU1fTUVTU0FHRV9UWVBFMQkzCisJdTgJCQlyYXdfaW9faW50ZXJm
YWNlOwogCXU4CQkJcmF3X2lvXzY0OwogCXU4CQkJcHJpbnRmX2VuYWJsZWQ7CiAJdTgJCQlpbl9y
ZXNldDsKQEAgLTE3ODksNiArMTg2NSwxMCBAQCBleHRlcm4gc3RydWN0IGFhY19jb21tb24gYWFj
X2NvbmZpZzsKICNkZWZpbmUgRG9vckJlbGxBZGFwdGVyTm9ybUNtZE5vdEZ1bGwJKDE8PDMpCS8q
IEFkYXB0ZXIgLT4gSG9zdCAqLwogI2RlZmluZSBEb29yQmVsbEFkYXB0ZXJOb3JtUmVzcE5vdEZ1
bGwJKDE8PDQpCS8qIEFkYXB0ZXIgLT4gSG9zdCAqLwogI2RlZmluZSBEb29yQmVsbFByaW50ZlJl
YWR5CQkoMTw8NSkJLyogQWRhcHRlciAtPiBIb3N0ICovCisjZGVmaW5lIERvb3JCZWxsQWlmUGVu
ZGluZwkJKDE8PDYpCS8qIEFkYXB0ZXIgLT4gSG9zdCAqLworCisvKiBQTUMgc3BlY2lmaWMgb3V0
Ym91bmQgZG9vcmJlbGwgYml0cyAqLworI2RlZmluZSBQbURvb3JCZWxsUmVzcG9uc2VTZW50CQko
MTw8MSkJLyogQWRhcHRlciAtPiBIb3N0ICovCiAKIC8qCiAgKglGb3IgRklCIGNvbW11bmljYXRp
b24sIHdlIG5lZWQgYWxsIG9mIHRoZSBmb2xsb3dpbmcgdGhpbmdzCkBAIC0xODMxLDYgKzE5MTEs
OSBAQCBleHRlcm4gc3RydWN0IGFhY19jb21tb24gYWFjX2NvbmZpZzsKICNkZWZpbmUJCUFpZlJl
cUFQSUpvYlVwZGF0ZQkxMDkJLyogVXBkYXRlIGEgam9iIHJlcG9ydCBmcm9tIHRoZSBBUEkgKi8K
ICNkZWZpbmUJCUFpZlJlcUFQSUpvYkZpbmlzaAkxMTAJLyogRmluaXNoIGEgam9iIGZyb20gdGhl
IEFQSSAqLwogCisvKiBQTUMgTkVXIENPTU06IFJlcXVlc3QgdGhlIGV2ZW50IGRhdGEgKi8KKyNk
ZWZpbmUJCUFpZlJlcUV2ZW50CQkyMDAKKwogLyoKICAqCUFkYXB0ZXIgSW5pdGlhdGVkIEZJQiBj
b21tYW5kIHN0cnVjdHVyZXMuIFN0YXJ0IHdpdGggdGhlIGFkYXB0ZXIKICAqCWluaXRpYXRlZCBG
SUJzIHRoYXQgcmVhbGx5IGNvbWUgZnJvbSB0aGUgYWRhcHRlciwgYW5kIGdldCByZXNwb25kZWQK
QEAgLTE4ODYsMTAgKzE5NjksMTMgQEAgaW50IGFhY19yeF9pbml0KHN0cnVjdCBhYWNfZGV2ICpk
ZXYpOwogaW50IGFhY19ya3RfaW5pdChzdHJ1Y3QgYWFjX2RldiAqZGV2KTsKIGludCBhYWNfbmFy
a19pbml0KHN0cnVjdCBhYWNfZGV2ICpkZXYpOwogaW50IGFhY19zYV9pbml0KHN0cnVjdCBhYWNf
ZGV2ICpkZXYpOworaW50IGFhY19zcmNfaW5pdChzdHJ1Y3QgYWFjX2RldiAqZGV2KTsKIGludCBh
YWNfcXVldWVfZ2V0KHN0cnVjdCBhYWNfZGV2ICogZGV2LCB1MzIgKiBpbmRleCwgdTMyIHFpZCwg
c3RydWN0IGh3X2ZpYiAqIGh3X2ZpYiwgaW50IHdhaXQsIHN0cnVjdCBmaWIgKiBmaWJwdHIsIHVu
c2lnbmVkIGxvbmcgKm5vbm90aWZ5KTsKIHVuc2lnbmVkIGludCBhYWNfcmVzcG9uc2Vfbm9ybWFs
KHN0cnVjdCBhYWNfcXVldWUgKiBxKTsKIHVuc2lnbmVkIGludCBhYWNfY29tbWFuZF9ub3JtYWwo
c3RydWN0IGFhY19xdWV1ZSAqIHEpOwotdW5zaWduZWQgaW50IGFhY19pbnRyX25vcm1hbChzdHJ1
Y3QgYWFjX2RldiAqIGRldiwgdTMyIEluZGV4KTsKK3Vuc2lnbmVkIGludCBhYWNfaW50cl9ub3Jt
YWwoc3RydWN0IGFhY19kZXYgKmRldiwgdTMyIEluZGV4LAorCQkJaW50IGlzQWlmLCBpbnQgaXNG
YXN0UmVzcG9uc2UsCisJCQlzdHJ1Y3QgaHdfZmliICphaWZfZmliKTsKIGludCBhYWNfcmVzZXRf
YWRhcHRlcihzdHJ1Y3QgYWFjX2RldiAqIGRldiwgaW50IGZvcmNlZCk7CiBpbnQgYWFjX2NoZWNr
X2hlYWx0aChzdHJ1Y3QgYWFjX2RldiAqIGRldik7CiBpbnQgYWFjX2NvbW1hbmRfdGhyZWFkKHZv
aWQgKmRhdGEpOwpkaWZmIC1wdXJOIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvY29tbWN0cmwuYyBi
L2RyaXZlcnMvc2NzaS9hYWNyYWlkL2NvbW1jdHJsLmMKLS0tIGEvZHJpdmVycy9zY3NpL2FhY3Jh
aWQvY29tbWN0cmwuYwkyMDExLTAzLTExIDE0OjE2OjM2LjAwMDAwMDAwMCArMDUzMAorKysgYi9k
cml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tY3RybC5jCTIwMTEtMDMtMTYgMTY6MzA6NTguMDAwMDAw
MDAwICswNTMwCkBAIC01LDcgKzUsOCBAQAogICogYmFzZWQgb24gdGhlIG9sZCBhYWNyYWlkIGRy
aXZlciB0aGF0IGlzLi4KICAqIEFkYXB0ZWMgYWFjcmFpZCBkZXZpY2UgZHJpdmVyIGZvciBMaW51
eC4KICAqCi0gKiBDb3B5cmlnaHQgKGMpIDIwMDAtMjAwNyBBZGFwdGVjLCBJbmMuIChhYWNyYWlk
QGFkYXB0ZWMuY29tKQorICogQ29weXJpZ2h0IChjKSAyMDAwLTIwMTAgQWRhcHRlYywgSW5jLgor
ICogICAgICAgICAgICAgICAyMDEwIFBNQy1TaWVycmEsIEluYy4gKGFhY3JhaWRAcG1jLXNpZXJy
YS5jb20pCiAgKgogICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVk
aXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKICAqIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUg
R05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5CmRpZmYgLXB1ck4gYS9k
cml2ZXJzL3Njc2kvYWFjcmFpZC9jb21taW5pdC5jIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvY29t
bWluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21taW5pdC5jCTIwMTEtMDMtMTEg
MTQ6MTY6MzYuMDAwMDAwMDAwICswNTMwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2NvbW1p
bml0LmMJMjAxMS0wMy0xNiAxNjozMDo1OC4wMDAwMDAwMDAgKzA1MzAKQEAgLTUsNyArNSw4IEBA
CiAgKiBiYXNlZCBvbiB0aGUgb2xkIGFhY3JhaWQgZHJpdmVyIHRoYXQgaXMuLgogICogQWRhcHRl
YyBhYWNyYWlkIGRldmljZSBkcml2ZXIgZm9yIExpbnV4LgogICoKLSAqIENvcHlyaWdodCAoYykg
MjAwMC0yMDA3IEFkYXB0ZWMsIEluYy4gKGFhY3JhaWRAYWRhcHRlYy5jb20pCisgKiBDb3B5cmln
aHQgKGMpIDIwMDAtMjAxMCBBZGFwdGVjLCBJbmMuCisgKiAgICAgICAgICAgICAgIDIwMTAgUE1D
LVNpZXJyYSwgSW5jLiAoYWFjcmFpZEBwbWMtc2llcnJhLmNvbSkKICAqCiAgKiBUaGlzIHByb2dy
YW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlm
eQogICogaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5z
ZSBhcyBwdWJsaXNoZWQgYnkKQEAgLTUyLDEyICs1MywxNiBAQCBzdGF0aWMgaW50IGFhY19hbGxv
Y19jb21tKHN0cnVjdCBhYWNfZGV2CiAJdW5zaWduZWQgbG9uZyBzaXplLCBhbGlnbjsKIAljb25z
dCB1bnNpZ25lZCBsb25nIGZpYnNpemUgPSA0MDk2OwogCWNvbnN0IHVuc2lnbmVkIGxvbmcgcHJp
bnRmYnVmc2l6ID0gMjU2OworCXVuc2lnbmVkIGxvbmcgaG9zdF9ycnFfc2l6ZSA9IDA7CiAJc3Ry
dWN0IGFhY19pbml0ICppbml0OwogCWRtYV9hZGRyX3QgcGh5czsKIAl1bnNpZ25lZCBsb25nIGFh
Y19tYXhfaG9zdHBoeXNtZW1wYWdlczsKIAotCXNpemUgPSBmaWJzaXplICsgc2l6ZW9mKHN0cnVj
dCBhYWNfaW5pdCkgKyBjb21tc2l6ZSArIGNvbW1hbGlnbiArIHByaW50ZmJ1ZnNpejsKLQorCWlm
IChkZXYtPmNvbW1faW50ZXJmYWNlID09IEFBQ19DT01NX01FU1NBR0VfVFlQRTEpCisJCWhvc3Rf
cnJxX3NpemUgPSAoZGV2LT5zY3NpX2hvc3RfcHRyLT5jYW5fcXVldWUKKwkJCSsgQUFDX05VTV9N
R1RfRklCKSAqIHNpemVvZih1MzIpOworCXNpemUgPSBmaWJzaXplICsgc2l6ZW9mKHN0cnVjdCBh
YWNfaW5pdCkgKyBjb21tc2l6ZSArCisJCQljb21tYWxpZ24gKyBwcmludGZidWZzaXogKyBob3N0
X3JycV9zaXplOwogIAogCWJhc2UgPSBwY2lfYWxsb2NfY29uc2lzdGVudChkZXYtPnBkZXYsIHNp
emUsICZwaHlzKTsKIApAQCAtNzAsOCArNzUsMTQgQEAgc3RhdGljIGludCBhYWNfYWxsb2NfY29t
bShzdHJ1Y3QgYWFjX2RldgogCWRldi0+Y29tbV9waHlzID0gcGh5czsKIAlkZXYtPmNvbW1fc2l6
ZSA9IHNpemU7CiAJCi0JZGV2LT5pbml0ID0gKHN0cnVjdCBhYWNfaW5pdCAqKShiYXNlICsgZmli
c2l6ZSk7Ci0JZGV2LT5pbml0X3BhID0gcGh5cyArIGZpYnNpemU7CisJaWYgKGRldi0+Y29tbV9p
bnRlcmZhY2UgPT0gQUFDX0NPTU1fTUVTU0FHRV9UWVBFMSkgeworCQlkZXYtPmhvc3RfcnJxID0g
KHUzMiAqKShiYXNlICsgZmlic2l6ZSk7CisJCWRldi0+aG9zdF9ycnFfcGEgPSBwaHlzICsgZmli
c2l6ZTsKKwkJbWVtc2V0KGRldi0+aG9zdF9ycnEsIDAsIGhvc3RfcnJxX3NpemUpOworCX0KKwor
CWRldi0+aW5pdCA9IChzdHJ1Y3QgYWFjX2luaXQgKikoYmFzZSArIGZpYnNpemUgKyBob3N0X3Jy
cV9zaXplKTsKKwlkZXYtPmluaXRfcGEgPSBwaHlzICsgZmlic2l6ZSArIGhvc3RfcnJxX3NpemU7
CiAKIAlpbml0ID0gZGV2LT5pbml0OwogCkBAIC0xMDYsOCArMTE3LDEzIEBAIHN0YXRpYyBpbnQg
YWFjX2FsbG9jX2NvbW0oc3RydWN0IGFhY19kZXYKIAogCWluaXQtPkluaXRGbGFncyA9IDA7CiAJ
aWYgKGRldi0+Y29tbV9pbnRlcmZhY2UgPT0gQUFDX0NPTU1fTUVTU0FHRSkgewotCQlpbml0LT5J
bml0RmxhZ3MgPSBjcHVfdG9fbGUzMihJTklURkxBR1NfTkVXX0NPTU1fU1VQUE9SVEVEKTsKKwkJ
aW5pdC0+SW5pdEZsYWdzIHw9IGNwdV90b19sZTMyKElOSVRGTEFHU19ORVdfQ09NTV9TVVBQT1JU
RUQpOwogCQlkcHJpbnRrKChLRVJOX1dBUk5JTkciYWFjcmFpZDogTmV3IENvbW0gSW50ZXJmYWNl
IGVuYWJsZWRcbiIpKTsKKwl9IGVsc2UgaWYgKGRldi0+Y29tbV9pbnRlcmZhY2UgPT0gQUFDX0NP
TU1fTUVTU0FHRV9UWVBFMSkgeworCQlpbml0LT5Jbml0U3RydWN0UmV2aXNpb24gPSBjcHVfdG9f
bGUzMihBREFQVEVSX0lOSVRfU1RSVUNUX1JFVklTSU9OXzYpOworCQlpbml0LT5Jbml0RmxhZ3Mg
fD0gY3B1X3RvX2xlMzIoSU5JVEZMQUdTX05FV19DT01NX1RZUEUxX1NVUFBPUlRFRCk7CisJCWRw
cmludGsoKEtFUk5fV0FSTklORworCQkJImFhY3JhaWQ6IE5ldyBDb21tIEludGVyZmFjZSB0eXBl
MSBlbmFibGVkXG4iKSk7CiAJfQogCWluaXQtPkluaXRGbGFncyB8PSBjcHVfdG9fbGUzMihJTklU
RkxBR1NfRFJJVkVSX1VTRVNfVVRDX1RJTUUgfAogCQkJCSAgICAgICBJTklURkxBR1NfRFJJVkVS
X1NVUFBPUlRTX1BNKTsKQEAgLTExNSwxMSArMTMxLDE4IEBAIHN0YXRpYyBpbnQgYWFjX2FsbG9j
X2NvbW0oc3RydWN0IGFhY19kZXYKIAlpbml0LT5NYXhJb1NpemUgPSBjcHVfdG9fbGUzMihkZXYt
PnNjc2lfaG9zdF9wdHItPm1heF9zZWN0b3JzIDw8IDkpOwogCWluaXQtPk1heEZpYlNpemUgPSBj
cHVfdG9fbGUzMihkZXYtPm1heF9maWJfc2l6ZSk7CiAKKwlpbml0LT5NYXhOdW1BaWYgPSBjcHVf
dG9fbGUzMihkZXYtPm1heF9udW1fYWlmKTsKKwlpbml0LT5Ib3N0UlJRX0FkZHJIaWdoID0gKHUz
MikoKHU2NClkZXYtPmhvc3RfcnJxX3BhID4+IDMyKTsKKwlpbml0LT5Ib3N0UlJRX0FkZHJMb3cg
PSAodTMyKShkZXYtPmhvc3RfcnJxX3BhICYgMHhmZmZmZmZmZik7CisKKwogCS8qCiAJICogSW5j
cmVtZW50IHRoZSBiYXNlIGFkZHJlc3MgYnkgdGhlIGFtb3VudCBhbHJlYWR5IHVzZWQKIAkgKi8K
LQliYXNlID0gYmFzZSArIGZpYnNpemUgKyBzaXplb2Yoc3RydWN0IGFhY19pbml0KTsKLQlwaHlz
ID0gKGRtYV9hZGRyX3QpKCh1bG9uZylwaHlzICsgZmlic2l6ZSArIHNpemVvZihzdHJ1Y3QgYWFj
X2luaXQpKTsKKwliYXNlID0gYmFzZSArIGZpYnNpemUgKyBob3N0X3JycV9zaXplICsgc2l6ZW9m
KHN0cnVjdCBhYWNfaW5pdCk7CisJcGh5cyA9IChkbWFfYWRkcl90KSgodWxvbmcpcGh5cyArIGZp
YnNpemUgKyBob3N0X3JycV9zaXplICsKKwkJc2l6ZW9mKHN0cnVjdCBhYWNfaW5pdCkpOworCiAJ
LyoKIAkgKglBbGlnbiB0aGUgYmVnaW5uaW5nIG9mIEhlYWRlcnMgdG8gY29tbWFsaWduCiAJICov
CkBAIC0zMTQsMTUgKzMzNywyMiBAQCBzdHJ1Y3QgYWFjX2RldiAqYWFjX2luaXRfYWRhcHRlcihz
dHJ1Y3QgCiAJCS0gc2l6ZW9mKHN0cnVjdCBhYWNfd3JpdGUpICsgc2l6ZW9mKHN0cnVjdCBzZ2Vu
dHJ5KSkKIAkJCS8gc2l6ZW9mKHN0cnVjdCBzZ2VudHJ5KTsKIAlkZXYtPmNvbW1faW50ZXJmYWNl
ID0gQUFDX0NPTU1fUFJPRFVDRVI7Ci0JZGV2LT5yYXdfaW9fNjQgPSAwOworCWRldi0+cmF3X2lv
X2ludGVyZmFjZSA9IGRldi0+cmF3X2lvXzY0ID0gMDsKKwogCWlmICgoIWFhY19hZGFwdGVyX3N5
bmNfY21kKGRldiwgR0VUX0FEQVBURVJfUFJPUEVSVElFUywKIAkJMCwgMCwgMCwgMCwgMCwgMCwg
c3RhdHVzKzAsIHN0YXR1cysxLCBzdGF0dXMrMiwgTlVMTCwgTlVMTCkpICYmCiAJIAkJKHN0YXR1
c1swXSA9PSAweDAwMDAwMDAxKSkgewogCQlpZiAoc3RhdHVzWzFdICYgbGUzMl90b19jcHUoQUFD
X09QVF9ORVdfQ09NTV82NCkpCiAJCQlkZXYtPnJhd19pb182NCA9IDE7Ci0JCWlmIChkZXYtPmFf
b3BzLmFkYXB0ZXJfY29tbSAmJgotCQkgICAgKHN0YXR1c1sxXSAmIGxlMzJfdG9fY3B1KEFBQ19P
UFRfTkVXX0NPTU0pKSkKLQkJCWRldi0+Y29tbV9pbnRlcmZhY2UgPSBBQUNfQ09NTV9NRVNTQUdF
OworCQlpZiAoZGV2LT5hX29wcy5hZGFwdGVyX2NvbW0pIHsKKwkJCWlmIChzdGF0dXNbMV0gJiBs
ZTMyX3RvX2NwdShBQUNfT1BUX05FV19DT01NX1RZUEUxKSkgeworCQkJCWRldi0+Y29tbV9pbnRl
cmZhY2UgPSBBQUNfQ09NTV9NRVNTQUdFX1RZUEUxOworCQkJCWRldi0+cmF3X2lvX2ludGVyZmFj
ZSA9IDE7CisJCQl9IGVsc2UgaWYgKHN0YXR1c1sxXSAmIGxlMzJfdG9fY3B1KEFBQ19PUFRfTkVX
X0NPTU0pKSB7CisJCQkJZGV2LT5jb21tX2ludGVyZmFjZSA9IEFBQ19DT01NX01FU1NBR0U7CisJ
CQkJZGV2LT5yYXdfaW9faW50ZXJmYWNlID0gMTsKKwkJCX0KKwkJfQogCQlpZiAoKGRldi0+Y29t
bV9pbnRlcmZhY2UgPT0gQUFDX0NPTU1fTUVTU0FHRSkgJiYKIAkJICAgIChzdGF0dXNbMl0gPiBk
ZXYtPmJhc2Vfc2l6ZSkpIHsKIAkJCWFhY19hZGFwdGVyX2lvcmVtYXAoZGV2LCAwKTsKQEAgLTM1
MCwxMCArMzgwLDEyIEBAIHN0cnVjdCBhYWNfZGV2ICphYWNfaW5pdF9hZGFwdGVyKHN0cnVjdCAK
IAkJICoJc3RhdHVzWzNdICYgMHhGRkZGCW1heGltdW0gbnVtYmVyIEZJQnMgb3V0c3RhbmRpbmcK
IAkJICovCiAJCWhvc3QtPm1heF9zZWN0b3JzID0gKHN0YXR1c1sxXSA+PiAxNikgPDwgMTsKLQkJ
ZGV2LT5tYXhfZmliX3NpemUgPSBzdGF0dXNbMV0gJiAweEZGRkY7CisJCS8qIE11bHRpcGxlIG9m
IDMyIGZvciBQTUMgKi8KKwkJZGV2LT5tYXhfZmliX3NpemUgPSBzdGF0dXNbMV0gJiAweEZGRTA7
CiAJCWhvc3QtPnNnX3RhYmxlc2l6ZSA9IHN0YXR1c1syXSA+PiAxNjsKIAkJZGV2LT5zZ190YWJs
ZXNpemUgPSBzdGF0dXNbMl0gJiAweEZGRkY7CiAJCWhvc3QtPmNhbl9xdWV1ZSA9IChzdGF0dXNb
M10gJiAweEZGRkYpIC0gQUFDX05VTV9NR1RfRklCOworCQlkZXYtPm1heF9udW1fYWlmID0gc3Rh
dHVzWzRdICYgMHhGRkZGOwogCQkvKgogCQkgKglOT1RFOgogCQkgKglBbGwgdGhlc2Ugb3ZlcnJp
ZGVzIGFyZSBiYXNlZCBvbiBhIGZpeGVkIGludGVybmFsCmRpZmYgLXB1ck4gYS9kcml2ZXJzL3Nj
c2kvYWFjcmFpZC9jb21tc3VwLmMgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tc3VwLmMKLS0t
IGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvY29tbXN1cC5jCTIwMTEtMDMtMTEgMTQ6MTY6MzYuMDAw
MDAwMDAwICswNTMwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2NvbW1zdXAuYwkyMDExLTAz
LTE2IDE2OjM4OjAyLjAwMDAwMDAwMCArMDUzMApAQCAtNSw3ICs1LDggQEAKICAqIGJhc2VkIG9u
IHRoZSBvbGQgYWFjcmFpZCBkcml2ZXIgdGhhdCBpcy4uCiAgKiBBZGFwdGVjIGFhY3JhaWQgZGV2
aWNlIGRyaXZlciBmb3IgTGludXguCiAgKgotICogQ29weXJpZ2h0IChjKSAyMDAwLTIwMDcgQWRh
cHRlYywgSW5jLiAoYWFjcmFpZEBhZGFwdGVjLmNvbSkKKyAqIENvcHlyaWdodCAoYykgMjAwMC0y
MDEwIEFkYXB0ZWMsIEluYy4KKyAqICAgICAgICAgICAgICAgMjAxMCBQTUMtU2llcnJhLCBJbmMu
IChhYWNyYWlkQHBtYy1zaWVycmEuY29tKQogICoKICAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNv
ZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CiAgKiBpdCB1bmRl
ciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hl
ZCBieQpAQCAtNjMsOSArNjQsMTEgQEAgc3RhdGljIGludCBmaWJfbWFwX2FsbG9jKHN0cnVjdCBh
YWNfZGV2IAogCSAgImFsbG9jYXRlIGhhcmR3YXJlIGZpYnMgcGNpX2FsbG9jX2NvbnNpc3RlbnQo
JXAsICVkICogKCVkICsgJWQpLCAlcClcbiIsCiAJICBkZXYtPnBkZXYsIGRldi0+bWF4X2ZpYl9z
aXplLCBkZXYtPnNjc2lfaG9zdF9wdHItPmNhbl9xdWV1ZSwKIAkgIEFBQ19OVU1fTUdUX0ZJQiwg
JmRldi0+aHdfZmliX3BhKSk7Ci0JaWYoKGRldi0+aHdfZmliX3ZhID0gcGNpX2FsbG9jX2NvbnNp
c3RlbnQoZGV2LT5wZGV2LCBkZXYtPm1heF9maWJfc2l6ZQotCSAgKiAoZGV2LT5zY3NpX2hvc3Rf
cHRyLT5jYW5fcXVldWUgKyBBQUNfTlVNX01HVF9GSUIpLAotCSAgJmRldi0+aHdfZmliX3BhKSk9
PU5VTEwpCisJZGV2LT5od19maWJfdmEgPSBwY2lfYWxsb2NfY29uc2lzdGVudChkZXYtPnBkZXYs
CisJCShkZXYtPm1heF9maWJfc2l6ZSArIHNpemVvZihzdHJ1Y3QgYWFjX2ZpYl94cG9ydGhkcikp
CisJCSogKGRldi0+c2NzaV9ob3N0X3B0ci0+Y2FuX3F1ZXVlICsgQUFDX05VTV9NR1RfRklCKSAr
IChBTElHTjMyIC0gMSksCisJCSZkZXYtPmh3X2ZpYl9wYSk7CisJaWYgKGRldi0+aHdfZmliX3Zh
ID09IE5VTEwpCiAJCXJldHVybiAtRU5PTUVNOwogCXJldHVybiAwOwogfQpAQCAtMTEwLDkgKzEx
MywyMiBAQCBpbnQgYWFjX2ZpYl9zZXR1cChzdHJ1Y3QgYWFjX2RldiAqIGRldikKIAlpZiAoaTww
KQogCQlyZXR1cm4gLUVOT01FTTsKIAorCS8qIDMyIGJ5dGUgYWxpZ25tZW50IGZvciBQTUMgKi8K
Kwlod19maWJfcGEgPSAoZGV2LT5od19maWJfcGEgKyAoQUxJR04zMiAtIDEpKSAmIH4oQUxJR04z
MiAtIDEpOworCWRldi0+aHdfZmliX3ZhID0gKHN0cnVjdCBod19maWIgKikoKHVuc2lnbmVkIGNo
YXIgKilkZXYtPmh3X2ZpYl92YSArCisJCShod19maWJfcGEgLSBkZXYtPmh3X2ZpYl9wYSkpOwor
CWRldi0+aHdfZmliX3BhID0gaHdfZmliX3BhOworCW1lbXNldChkZXYtPmh3X2ZpYl92YSwgMCwK
KwkJKGRldi0+bWF4X2ZpYl9zaXplICsgc2l6ZW9mKHN0cnVjdCBhYWNfZmliX3hwb3J0aGRyKSkg
KgorCQkoZGV2LT5zY3NpX2hvc3RfcHRyLT5jYW5fcXVldWUgKyBBQUNfTlVNX01HVF9GSUIpKTsK
KworCS8qIGFkZCBYcG9ydCBoZWFkZXIgKi8KKwlkZXYtPmh3X2ZpYl92YSA9IChzdHJ1Y3QgaHdf
ZmliICopKCh1bnNpZ25lZCBjaGFyICopZGV2LT5od19maWJfdmEgKworCQlzaXplb2Yoc3RydWN0
IGFhY19maWJfeHBvcnRoZHIpKTsKKwlkZXYtPmh3X2ZpYl9wYSArPSBzaXplb2Yoc3RydWN0IGFh
Y19maWJfeHBvcnRoZHIpOworCiAJaHdfZmliID0gZGV2LT5od19maWJfdmE7CiAJaHdfZmliX3Bh
ID0gZGV2LT5od19maWJfcGE7Ci0JbWVtc2V0KGh3X2ZpYiwgMCwgZGV2LT5tYXhfZmliX3NpemUg
KiAoZGV2LT5zY3NpX2hvc3RfcHRyLT5jYW5fcXVldWUgKyBBQUNfTlVNX01HVF9GSUIpKTsKIAkv
KgogCSAqCUluaXRpYWxpc2UgdGhlIGZpYnMKIAkgKi8KQEAgLTEyOSw4ICsxNDUsMTAgQEAgaW50
IGFhY19maWJfc2V0dXAoc3RydWN0IGFhY19kZXYgKiBkZXYpCiAJCWh3X2ZpYi0+aGVhZGVyLlhm
ZXJTdGF0ZSA9IGNwdV90b19sZTMyKDB4ZmZmZmZmZmYpOwogCQlod19maWItPmhlYWRlci5TZW5k
ZXJTaXplID0gY3B1X3RvX2xlMTYoZGV2LT5tYXhfZmliX3NpemUpOwogCQlmaWJwdHItPmh3X2Zp
Yl9wYSA9IGh3X2ZpYl9wYTsKLQkJaHdfZmliID0gKHN0cnVjdCBod19maWIgKikoKHVuc2lnbmVk
IGNoYXIgKilod19maWIgKyBkZXYtPm1heF9maWJfc2l6ZSk7Ci0JCWh3X2ZpYl9wYSA9IGh3X2Zp
Yl9wYSArIGRldi0+bWF4X2ZpYl9zaXplOworCQlod19maWIgPSAoc3RydWN0IGh3X2ZpYiAqKSgo
dW5zaWduZWQgY2hhciAqKWh3X2ZpYiArCisJCQlkZXYtPm1heF9maWJfc2l6ZSArIHNpemVvZihz
dHJ1Y3QgYWFjX2ZpYl94cG9ydGhkcikpOworCQlod19maWJfcGEgPSBod19maWJfcGEgKworCQkJ
ZGV2LT5tYXhfZmliX3NpemUgKyBzaXplb2Yoc3RydWN0IGFhY19maWJfeHBvcnRoZHIpOwogCX0K
IAkvKgogCSAqCUFkZCB0aGUgZmliIGNoYWluIHRvIHRoZSBmcmVlIGxpc3QKQEAgLTY2NCw5ICs2
ODIsMTQgQEAgaW50IGFhY19maWJfYWRhcHRlcl9jb21wbGV0ZShzdHJ1Y3QgZmliIAogCXVuc2ln
bmVkIGxvbmcgbm9pbnRyID0gMDsKIAl1bnNpZ25lZCBsb25nIHFmbGFnczsKIAorCWlmIChkZXYt
PmNvbW1faW50ZXJmYWNlID09IEFBQ19DT01NX01FU1NBR0VfVFlQRTEpIHsKKwkJa2ZyZWUoaHdf
ZmliKTsKKwkJcmV0dXJuIDA7CisJfQorCiAJaWYgKGh3X2ZpYi0+aGVhZGVyLlhmZXJTdGF0ZSA9
PSAwKSB7CiAJCWlmIChkZXYtPmNvbW1faW50ZXJmYWNlID09IEFBQ19DT01NX01FU1NBR0UpCi0J
CQlrZnJlZSAoaHdfZmliKTsKKwkJCWtmcmVlKGh3X2ZpYik7CiAJCXJldHVybiAwOwogCX0KIAkv
KgpAQCAtNjc0LDcgKzY5Nyw3IEBAIGludCBhYWNfZmliX2FkYXB0ZXJfY29tcGxldGUoc3RydWN0
IGZpYiAKIAkgKi8KIAlpZiAoaHdfZmliLT5oZWFkZXIuU3RydWN0VHlwZSAhPSBGSUJfTUFHSUMp
IHsKIAkJaWYgKGRldi0+Y29tbV9pbnRlcmZhY2UgPT0gQUFDX0NPTU1fTUVTU0FHRSkKLQkJCWtm
cmVlIChod19maWIpOworCQkJa2ZyZWUoaHdfZmliKTsKIAkJcmV0dXJuIC1FSU5WQUw7CiAJfQog
CS8qCmRpZmYgLXB1ck4gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9kcGNzdXAuYyBiL2RyaXZlcnMv
c2NzaS9hYWNyYWlkL2RwY3N1cC5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2RwY3N1cC5j
CTIwMTEtMDMtMTEgMTQ6MTY6MzYuMDAwMDAwMDAwICswNTMwCisrKyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2RwY3N1cC5jCTIwMTEtMDMtMTYgMTY6MzA6NTguMDAwMDAwMDAwICswNTMwCkBAIC01
LDcgKzUsOCBAQAogICogYmFzZWQgb24gdGhlIG9sZCBhYWNyYWlkIGRyaXZlciB0aGF0IGlzLi4K
ICAqIEFkYXB0ZWMgYWFjcmFpZCBkZXZpY2UgZHJpdmVyIGZvciBMaW51eC4KICAqCi0gKiBDb3B5
cmlnaHQgKGMpIDIwMDAtMjAwNyBBZGFwdGVjLCBJbmMuIChhYWNyYWlkQGFkYXB0ZWMuY29tKQor
ICogQ29weXJpZ2h0IChjKSAyMDAwLTIwMTAgQWRhcHRlYywgSW5jLgorICogICAgICAgICAgICAg
ICAyMDEwIFBNQy1TaWVycmEsIEluYy4gKGFhY3JhaWRAcG1jLXNpZXJyYS5jb20pCiAgKgogICog
VGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFu
ZC9vciBtb2RpZnkKICAqIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVi
bGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5CkBAIC0yMjgsNiArMjI5LDQ4IEBAIHVuc2lnbmVk
IGludCBhYWNfY29tbWFuZF9ub3JtYWwoc3RydWN0IGEKIAlyZXR1cm4gMDsKIH0KIAorLyoKKyAq
CisgKiBhYWNfYWlmX2NhbGxiYWNrCisgKiBAY29udGV4dDogdGhlIGNvbnRleHQgc2V0IGluIHRo
ZSBmaWIgLSBoZXJlIGl0IGlzIHNjc2kgY21kCisgKiBAZmlicHRyOiBwb2ludGVyIHRvIHRoZSBm
aWIKKyAqCisgKiBIYW5kbGVzIHRoZSBBSUZzIC0gbmV3IG1ldGhvZCAoU1JDKQorICoKKyAqLwor
CitzdGF0aWMgdm9pZCBhYWNfYWlmX2NhbGxiYWNrKHZvaWQgKmNvbnRleHQsIHN0cnVjdCBmaWIg
KiBmaWJwdHIpCit7CisJc3RydWN0IGZpYiAqZmliY3R4OworCXN0cnVjdCBhYWNfZGV2ICpkZXY7
CisJc3RydWN0IGFhY19haWZjbWQgKmNtZDsKKwlpbnQgc3RhdHVzOworCisJZmliY3R4ID0gKHN0
cnVjdCBmaWIgKiljb250ZXh0OworCUJVR19PTihmaWJwdHIgPT0gTlVMTCk7CisJZGV2ID0gZmli
cHRyLT5kZXY7CisKKwlpZiAoZmlicHRyLT5od19maWJfdmEtPmhlYWRlci5YZmVyU3RhdGUgJgor
CSAgICBjcHVfdG9fbGUzMihOb01vcmVBaWZEYXRhQXZhaWxhYmxlKSkgeworCQlhYWNfZmliX2Nv
bXBsZXRlKGZpYnB0cik7CisJCWFhY19maWJfZnJlZShmaWJwdHIpOworCQlyZXR1cm47CisJfQor
CisJYWFjX2ludHJfbm9ybWFsKGRldiwgMCwgMSwgMCwgZmlicHRyLT5od19maWJfdmEpOworCisJ
YWFjX2ZpYl9pbml0KGZpYmN0eCk7CisJY21kID0gKHN0cnVjdCBhYWNfYWlmY21kICopIGZpYl9k
YXRhKGZpYmN0eCk7CisJY21kLT5jb21tYW5kID0gY3B1X3RvX2xlMzIoQWlmUmVxRXZlbnQpOwor
CisJc3RhdHVzID0gYWFjX2ZpYl9zZW5kKEFpZlJlcXVlc3QsCisJCWZpYmN0eCwKKwkJc2l6ZW9m
KHN0cnVjdCBod19maWIpLXNpemVvZihzdHJ1Y3QgYWFjX2ZpYmhkciksCisJCUZzYU5vcm1hbCwK
KwkJMCwgMSwKKwkJKGZpYl9jYWxsYmFjaylhYWNfYWlmX2NhbGxiYWNrLCBmaWJjdHgpOworfQor
CiAKIC8qKgogICoJYWFjX2ludHJfbm9ybWFsCS0JSGFuZGxlIGNvbW1hbmQgcmVwbGllcwpAQCAt
MjM4LDE5ICsyODEsMTcgQEAgdW5zaWduZWQgaW50IGFhY19jb21tYW5kX25vcm1hbChzdHJ1Y3Qg
YQogICoJa25vdyB0aGVyZSBpcyBhIHJlc3BvbnNlIG9uIG91ciBub3JtYWwgcHJpb3JpdHkgcXVl
dWUuIFdlIHdpbGwgcHVsbCBvZmYKICAqCWFsbCBRRSB0aGVyZSBhcmUgYW5kIHdha2UgdXAgYWxs
IHRoZSB3YWl0ZXJzIGJlZm9yZSBleGl0aW5nLgogICovCi0KLXVuc2lnbmVkIGludCBhYWNfaW50
cl9ub3JtYWwoc3RydWN0IGFhY19kZXYgKiBkZXYsIHUzMiBpbmRleCkKK3Vuc2lnbmVkIGludCBh
YWNfaW50cl9ub3JtYWwoc3RydWN0IGFhY19kZXYgKmRldiwgdTMyIGluZGV4LAorCQkJaW50IGlz
QWlmLCBpbnQgaXNGYXN0UmVzcG9uc2UsIHN0cnVjdCBod19maWIgKmFpZl9maWIpCiB7CiAJdW5z
aWduZWQgbG9uZyBtZmxhZ3M7CiAJZHByaW50aygoS0VSTl9JTkZPICJhYWNfaW50cl9ub3JtYWwo
JXAsJXgpXG4iLCBkZXYsIGluZGV4KSk7Ci0JaWYgKChpbmRleCAmIDB4MDAwMDAwMDJMKSkgewor
CWlmIChpc0FpZiA9PSAxKSB7CS8qIEFJRiAtIGNvbW1vbiAqLwogCQlzdHJ1Y3QgaHdfZmliICog
aHdfZmliOwogCQlzdHJ1Y3QgZmliICogZmliOwogCQlzdHJ1Y3QgYWFjX3F1ZXVlICpxID0gJmRl
di0+cXVldWVzLT5xdWV1ZVtIb3N0Tm9ybUNtZFF1ZXVlXTsKIAkJdW5zaWduZWQgbG9uZyBmbGFn
czsKIAotCQlpZiAoaW5kZXggPT0gMHhGRkZGRkZGRUwpIC8qIFNwZWNpYWwgQ2FzZSAqLwotCQkJ
cmV0dXJuIDA7CSAgLyogRG8gbm90aGluZyAqLwogCQkvKgogCQkgKglBbGxvY2F0ZSBhIEZJQi4g
Rm9yIG5vbiBxdWV1ZWQgc3R1ZmYgd2UgY2FuIGp1c3QgdXNlCiAJCSAqIHRoZSBzdGFjayBzbyB3
ZSBhcmUgaGFwcHkuIFdlIG5lZWQgYSBmaWIgb2JqZWN0IGluIG9yZGVyIHRvCkBAIC0yNjMsOCAr
MzA0LDEzIEBAIHVuc2lnbmVkIGludCBhYWNfaW50cl9ub3JtYWwoc3RydWN0IGFhY18KIAkJCWtm
cmVlIChmaWIpOwogCQkJcmV0dXJuIDE7CiAJCX0KLQkJbWVtY3B5KGh3X2ZpYiwgKHN0cnVjdCBo
d19maWIgKikoKCh1aW50cHRyX3QpKGRldi0+cmVncy5zYSkpICsKLQkJICAoaW5kZXggJiB+MHgw
MDAwMDAwMkwpKSwgc2l6ZW9mKHN0cnVjdCBod19maWIpKTsKKwkJaWYgKGFpZl9maWIgIT0gTlVM
TCkgeworCQkJbWVtY3B5KGh3X2ZpYiwgYWlmX2ZpYiwgc2l6ZW9mKHN0cnVjdCBod19maWIpKTsK
KwkJfSBlbHNlIHsKKwkJCW1lbWNweShod19maWIsCisJCQkJKHN0cnVjdCBod19maWIgKikoKCh1
aW50cHRyX3QpKGRldi0+cmVncy5zYSkpICsKKwkJCQlpbmRleCksIHNpemVvZihzdHJ1Y3QgaHdf
ZmliKSk7CisJCX0KIAkJSU5JVF9MSVNUX0hFQUQoJmZpYi0+ZmlibGluayk7CiAJCWZpYi0+dHlw
ZSA9IEZTQUZTX05UQ19GSUJfQ09OVEVYVDsKIAkJZmliLT5zaXplID0gc2l6ZW9mKHN0cnVjdCBm
aWIpOwpAQCAtMjc3LDkgKzMyMywyNiBAQCB1bnNpZ25lZCBpbnQgYWFjX2ludHJfbm9ybWFsKHN0
cnVjdCBhYWNfCiAJICAgICAgICB3YWtlX3VwX2ludGVycnVwdGlibGUoJnEtPmNtZHJlYWR5KTsK
IAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShxLT5sb2NrLCBmbGFncyk7CiAJCXJldHVybiAxOwor
CX0gZWxzZSBpZiAoaXNBaWYgPT0gMikgewkvKiBBSUYgLSBuZXcgKFNSQykgKi8KKwkJc3RydWN0
IGZpYiAqZmliY3R4OworCQlzdHJ1Y3QgYWFjX2FpZmNtZCAqY21kOworCisJCWZpYmN0eCA9IGFh
Y19maWJfYWxsb2MoZGV2KTsKKwkJaWYgKCFmaWJjdHgpCisJCQlyZXR1cm4gMTsKKwkJYWFjX2Zp
Yl9pbml0KGZpYmN0eCk7CisKKwkJY21kID0gKHN0cnVjdCBhYWNfYWlmY21kICopIGZpYl9kYXRh
KGZpYmN0eCk7CisJCWNtZC0+Y29tbWFuZCA9IGNwdV90b19sZTMyKEFpZlJlcUV2ZW50KTsKKwor
CQlyZXR1cm4gYWFjX2ZpYl9zZW5kKEFpZlJlcXVlc3QsCisJCQlmaWJjdHgsCisJCQlzaXplb2Yo
c3RydWN0IGh3X2ZpYiktc2l6ZW9mKHN0cnVjdCBhYWNfZmliaGRyKSwKKwkJCUZzYU5vcm1hbCwK
KwkJCTAsIDEsCisJCQkoZmliX2NhbGxiYWNrKWFhY19haWZfY2FsbGJhY2ssIGZpYmN0eCk7CiAJ
fSBlbHNlIHsKLQkJaW50IGZhc3QgPSBpbmRleCAmIDB4MDE7Ci0JCXN0cnVjdCBmaWIgKiBmaWIg
PSAmZGV2LT5maWJzW2luZGV4ID4+IDJdOworCQlzdHJ1Y3QgZmliICpmaWIgPSAmZGV2LT5maWJz
W2luZGV4XTsKIAkJc3RydWN0IGh3X2ZpYiAqIGh3ZmliID0gZmliLT5od19maWJfdmE7CiAKIAkJ
LyoKQEAgLTI5OCw3ICszNjEsNyBAQCB1bnNpZ25lZCBpbnQgYWFjX2ludHJfbm9ybWFsKHN0cnVj
dCBhYWNfCiAJCQlyZXR1cm4gMDsKIAkJfQogCi0JCWlmIChmYXN0KSB7CisJCWlmIChpc0Zhc3RS
ZXNwb25zZSkgewogCQkJLyoKIAkJCSAqCURvY3RvciB0aGUgZmliCiAJCQkgKi8KZGlmZiAtcHVy
TiBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xpbml0LmMgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9s
aW5pdC5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xpbml0LmMJMjAxMS0wMy0xMSAxNDox
NjozNi4wMDAwMDAwMDAgKzA1MzAKKysrIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvbGluaXQuYwky
MDExLTAzLTE2IDE2OjMwOjU4LjAwMDAwMDAwMCArMDUzMApAQCAtNSw3ICs1LDggQEAKICAqIGJh
c2VkIG9uIHRoZSBvbGQgYWFjcmFpZCBkcml2ZXIgdGhhdCBpcy4uCiAgKiBBZGFwdGVjIGFhY3Jh
aWQgZGV2aWNlIGRyaXZlciBmb3IgTGludXguCiAgKgotICogQ29weXJpZ2h0IChjKSAyMDAwLTIw
MDcgQWRhcHRlYywgSW5jLiAoYWFjcmFpZEBhZGFwdGVjLmNvbSkKKyAqIENvcHlyaWdodCAoYykg
MjAwMC0yMDEwIEFkYXB0ZWMsIEluYy4KKyAqICAgICAgICAgICAgICAgMjAxMCBQTUMtU2llcnJh
LCBJbmMuIChhYWNyYWlkQHBtYy1zaWVycmEuY29tKQogICoKICAqIFRoaXMgcHJvZ3JhbSBpcyBm
cmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CiAgKiBp
dCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1
Ymxpc2hlZCBieQpAQCAtNTQsNyArNTUsNyBAQAogCiAjaW5jbHVkZSAiYWFjcmFpZC5oIgogCi0j
ZGVmaW5lIEFBQ19EUklWRVJfVkVSU0lPTgkJIjEuMS01IgorI2RlZmluZSBBQUNfRFJJVkVSX1ZF
UlNJT04JCSIxLjEtNyIKICNpZm5kZWYgQUFDX0RSSVZFUl9CUkFOQ0gKICNkZWZpbmUgQUFDX0RS
SVZFUl9CUkFOQ0gJCSIiCiAjZW5kaWYKQEAgLTE2MSw2ICsxNjIsNyBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IHBjaV9kZXZpY2VfaWQgYWFjX3BjCiAJeyAweDkwMDUsIDB4MDI4NSwgUENJX0FOWV9J
RCwgUENJX0FOWV9JRCwgMCwgMCwgNTkgfSwgLyogQWRhcHRlYyBDYXRjaCBBbGwgKi8KIAl7IDB4
OTAwNSwgMHgwMjg2LCBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lELCAwLCAwLCA2MCB9LCAvKiBBZGFw
dGVjIFJvY2tldCBDYXRjaCBBbGwgKi8KIAl7IDB4OTAwNSwgMHgwMjg4LCBQQ0lfQU5ZX0lELCBQ
Q0lfQU5ZX0lELCAwLCAwLCA2MSB9LCAvKiBBZGFwdGVjIE5FTUVSL0FSSyBDYXRjaCBBbGwgKi8K
Kwl7IDB4OTAwNSwgMHgwMjhiLCBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lELCAwLCAwLCA2MiB9LCAv
KiBBZGFwdGVjIFBNQyBDYXRjaCBBbGwgKi8KIAl7IDAsfQogfTsKIE1PRFVMRV9ERVZJQ0VfVEFC
TEUocGNpLCBhYWNfcGNpX3RibCk7CkBAIC0yMzUsNyArMjM3LDggQEAgc3RhdGljIHN0cnVjdCBh
YWNfZHJpdmVyX2lkZW50IGFhY19kcml2ZQogCXsgYWFjX3J4X2luaXQsICJhYWNyYWlkIiwgICJM
ZWdlbmQgICIsICJSQUlEICAgICAgICAgICAgIiwgMiwgQUFDX1FVSVJLXzMxQklUIHwgQUFDX1FV
SVJLXzM0U0cgfCBBQUNfUVVJUktfU0NTSV8zMiB9LCAvKiBMZWdlbmQgQ2F0Y2hhbGwgKi8KIAl7
IGFhY19yeF9pbml0LCAiYWFjcmFpZCIsICAiQURBUFRFQyAiLCAiUkFJRCAgICAgICAgICAgICIs
IDIgfSwgLyogQWRhcHRlYyBDYXRjaCBBbGwgKi8KIAl7IGFhY19ya3RfaW5pdCwgImFhY3JhaWQi
LCAiQURBUFRFQyAiLCAiUkFJRCAgICAgICAgICAgICIsIDIgfSwgLyogQWRhcHRlYyBSb2NrZXQg
Q2F0Y2ggQWxsICovCi0JeyBhYWNfbmFya19pbml0LCAiYWFjcmFpZCIsICJBREFQVEVDICIsICJS
QUlEICAgICAgICAgICAgIiwgMiB9IC8qIEFkYXB0ZWMgTkVNRVIvQVJLIENhdGNoIEFsbCAqLwor
CXsgYWFjX25hcmtfaW5pdCwgImFhY3JhaWQiLCAiQURBUFRFQyAiLCAiUkFJRCAgICAgICAgICAg
IiwgMiB9LCAvKiBBZGFwdGVjIE5FTUVSL0FSSyBDYXRjaCBBbGwgKi8KKwl7IGFhY19zcmNfaW5p
dCwgImFhY3JhaWQiLCAiQURBUFRFQyAiLCAiUkFJRCAgICAgICAgICAgICIsIDIgfSAvKiBBZGFw
dGVjIFBNQyBDYXRjaCBBbGwgKi8KIH07CiAKIC8qKgpAQCAtNjUzLDggKzY1NiwxMCBAQCBzdGF0
aWMgaW50IGFhY19laF9yZXNldChzdHJ1Y3Qgc2NzaV9jbW5kCiAJICogVGhpcyBhZGFwdGVyIG5l
ZWRzIGEgYmxpbmQgcmVzZXQsIG9ubHkgZG8gc28gZm9yIEFkYXB0ZXJzIHRoYXQKIAkgKiBzdXBw
b3J0IGEgcmVnaXN0ZXIsIGluc3RlYWQgb2YgYSBjb21tYW5kZWQsIHJlc2V0LgogCSAqLwotCWlm
ICgoYWFjLT5zdXBwbGVtZW50X2FkYXB0ZXJfaW5mby5TdXBwb3J0ZWRPcHRpb25zMiAmCi0JICAg
QUFDX09QVElPTl9NVV9SRVNFVCkgJiYKKwlpZiAoKChhYWMtPnN1cHBsZW1lbnRfYWRhcHRlcl9p
bmZvLlN1cHBvcnRlZE9wdGlvbnMyICYKKwkgIEFBQ19PUFRJT05fTVVfUkVTRVQpIHx8CisJICAo
YWFjLT5zdXBwbGVtZW50X2FkYXB0ZXJfaW5mby5TdXBwb3J0ZWRPcHRpb25zMiAmCisJICBBQUNf
T1BUSU9OX0RPT1JCRUxMX1JFU0VUKSkgJiYKIAkgIGFhY19jaGVja19yZXNldCAmJgogCSAgKChh
YWNfY2hlY2tfcmVzZXQgIT0gMSkgfHwKIAkgICAhKGFhYy0+c3VwcGxlbWVudF9hZGFwdGVyX2lu
Zm8uU3VwcG9ydGVkT3B0aW9uczIgJgpkaWZmIC1wdXJOIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQv
TWFrZWZpbGUgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9NYWtlZmlsZQotLS0gYS9kcml2ZXJzL3Nj
c2kvYWFjcmFpZC9NYWtlZmlsZQkyMDExLTAzLTExIDE0OjE2OjM2LjAwMDAwMDAwMCArMDUzMAor
KysgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9NYWtlZmlsZQkyMDExLTAzLTE2IDE2OjMwOjU4LjAw
MDAwMDAwMCArMDUzMApAQCAtMyw2ICszLDYgQEAKIG9iai0kKENPTkZJR19TQ1NJX0FBQ1JBSUQp
IDo9IGFhY3JhaWQubwogCiBhYWNyYWlkLW9ianMJOj0gbGluaXQubyBhYWNoYmEubyBjb21tY3Ry
bC5vIGNvbW1pbml0Lm8gY29tbXN1cC5vIFwKLQkJICAgZHBjc3VwLm8gcngubyBzYS5vIHJrdC5v
IG5hcmsubworCQkgICBkcGNzdXAubyByeC5vIHNhLm8gcmt0Lm8gbmFyay5vIHNyYy5vCiAKIEVY
VFJBX0NGTEFHUwk6PSAtSWRyaXZlcnMvc2NzaQpkaWZmIC1wdXJOIGEvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbmFyay5jIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvbmFyay5jCi0tLSBhL2RyaXZlcnMv
c2NzaS9hYWNyYWlkL25hcmsuYwkyMDExLTAzLTExIDE0OjE2OjM2LjAwMDAwMDAwMCArMDUzMAor
KysgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9uYXJrLmMJMjAxMS0wMy0xNiAxNjozMDo1OC4wMDAw
MDAwMDAgKzA1MzAKQEAgLTQsNyArNCw4IEBACiAgKiBiYXNlZCBvbiB0aGUgb2xkIGFhY3JhaWQg
ZHJpdmVyIHRoYXQgaXMuLgogICogQWRhcHRlYyBhYWNyYWlkIGRldmljZSBkcml2ZXIgZm9yIExp
bnV4LgogICoKLSAqIENvcHlyaWdodCAoYykgMjAwNi0yMDA3IEFkYXB0ZWMsIEluYy4gKGFhY3Jh
aWRAYWRhcHRlYy5jb20pCisgKiBDb3B5cmlnaHQgKGMpIDIwMDAtMjAxMCBBZGFwdGVjLCBJbmMu
CisgKiAgICAgICAgICAgICAgIDIwMTAgUE1DLVNpZXJyYSwgSW5jLiAoYWFjcmFpZEBwbWMtc2ll
cnJhLmNvbSkKICAqCiAgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiBy
ZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQogICogaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRo
ZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkKZGlmZiAtcHVyTiBh
L2RyaXZlcnMvc2NzaS9hYWNyYWlkL3JrdC5jIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvcmt0LmMK
LS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvcmt0LmMJMjAxMS0wMy0xMSAxNDoxNjozNi4wMDAw
MDAwMDAgKzA1MzAKKysrIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvcmt0LmMJMjAxMS0wMy0xNiAx
NjozMDo1OC4wMDAwMDAwMDAgKzA1MzAKQEAgLTUsNyArNSw4IEBACiAgKiBiYXNlZCBvbiB0aGUg
b2xkIGFhY3JhaWQgZHJpdmVyIHRoYXQgaXMuLgogICogQWRhcHRlYyBhYWNyYWlkIGRldmljZSBk
cml2ZXIgZm9yIExpbnV4LgogICoKLSAqIENvcHlyaWdodCAoYykgMjAwMC0yMDA3IEFkYXB0ZWMs
IEluYy4gKGFhY3JhaWRAYWRhcHRlYy5jb20pCisgKiBDb3B5cmlnaHQgKGMpIDIwMDAtMjAxMCBB
ZGFwdGVjLCBJbmMuCisgKiAgICAgICAgICAgICAgIDIwMTAgUE1DLVNpZXJyYSwgSW5jLiAoYWFj
cmFpZEBwbWMtc2llcnJhLmNvbSkKICAqCiAgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2Fy
ZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQogICogaXQgdW5kZXIgdGhl
IHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkK
ZGlmZiAtcHVyTiBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMgYi9kcml2ZXJzL3Njc2kvYWFj
cmFpZC9yeC5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMJMjAxMS0wMy0xMSAxNDox
NjozNi4wMDAwMDAwMDAgKzA1MzAKKysrIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvcnguYwkyMDEx
LTAzLTE2IDE2OjMwOjU4LjAwMDAwMDAwMCArMDUzMApAQCAtNSw3ICs1LDggQEAKICAqIGJhc2Vk
IG9uIHRoZSBvbGQgYWFjcmFpZCBkcml2ZXIgdGhhdCBpcy4uCiAgKiBBZGFwdGVjIGFhY3JhaWQg
ZGV2aWNlIGRyaXZlciBmb3IgTGludXguCiAgKgotICogQ29weXJpZ2h0IChjKSAyMDAwLTIwMDcg
QWRhcHRlYywgSW5jLiAoYWFjcmFpZEBhZGFwdGVjLmNvbSkKKyAqIENvcHlyaWdodCAoYykgMjAw
MC0yMDEwIEFkYXB0ZWMsIEluYy4KKyAqICAgICAgICAgICAgICAgMjAxMCBQTUMtU2llcnJhLCBJ
bmMuIChhYWNyYWlkQHBtYy1zaWVycmEuY29tKQogICoKICAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVl
IHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CiAgKiBpdCB1
bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxp
c2hlZCBieQpAQCAtODQsMTUgKzg1LDM1IEBAIHN0YXRpYyBpcnFyZXR1cm5fdCBhYWNfcnhfaW50
cl9wcm9kdWNlcigKIAogc3RhdGljIGlycXJldHVybl90IGFhY19yeF9pbnRyX21lc3NhZ2UoaW50
IGlycSwgdm9pZCAqZGV2X2lkKQogeworCWludCBpc0FpZiwgaXNGYXN0UmVzcG9uc2UsIGlzU3Bl
Y2lhbDsKIAlzdHJ1Y3QgYWFjX2RldiAqZGV2ID0gZGV2X2lkOwogCXUzMiBJbmRleCA9IHJ4X3Jl
YWRsKGRldiwgTVVuaXQuT3V0Ym91bmRRdWV1ZSk7CiAJaWYgKHVubGlrZWx5KEluZGV4ID09IDB4
RkZGRkZGRkZMKSkKIAkJSW5kZXggPSByeF9yZWFkbChkZXYsIE1Vbml0Lk91dGJvdW5kUXVldWUp
OwogCWlmIChsaWtlbHkoSW5kZXggIT0gMHhGRkZGRkZGRkwpKSB7CiAJCWRvIHsKLQkJCWlmICh1
bmxpa2VseShhYWNfaW50cl9ub3JtYWwoZGV2LCBJbmRleCkpKSB7Ci0JCQkJcnhfd3JpdGVsKGRl
diwgTVVuaXQuT3V0Ym91bmRRdWV1ZSwgSW5kZXgpOwotCQkJCXJ4X3dyaXRlbChkZXYsIE1Vbml0
Lk9EUiwgRG9vckJlbGxBZGFwdGVyTm9ybVJlc3BSZWFkeSk7CisJCQlpc0FpZiA9IGlzRmFzdFJl
c3BvbnNlID0gaXNTcGVjaWFsID0gMDsKKwkJCWlmIChJbmRleCAmIDB4MDAwMDAwMDJMKSB7CisJ
CQkJaXNBaWYgPSAxOworCQkJCWlmIChJbmRleCA9PSAweEZGRkZGRkZFTCkKKwkJCQkJaXNTcGVj
aWFsID0gMTsKKwkJCQlJbmRleCAmPSB+MHgwMDAwMDAwMkw7CisJCQl9IGVsc2UgeworCQkJCWlm
IChJbmRleCAmIDB4MDAwMDAwMDFMKQorCQkJCQlpc0Zhc3RSZXNwb25zZSA9IDE7CisJCQkJSW5k
ZXggPj49IDI7CisJCQl9CisJCQlpZiAoIWlzU3BlY2lhbCkgeworCQkJCWlmICh1bmxpa2VseShh
YWNfaW50cl9ub3JtYWwoZGV2LAorCQkJCQkJSW5kZXgsIGlzQWlmLAorCQkJCQkJaXNGYXN0UmVz
cG9uc2UsIE5VTEwpKSkgeworCQkJCQlyeF93cml0ZWwoZGV2LAorCQkJCQkJTVVuaXQuT3V0Ym91
bmRRdWV1ZSwKKwkJCQkJCUluZGV4KTsKKwkJCQkJcnhfd3JpdGVsKGRldiwKKwkJCQkJCU1Vbml0
Lk9EUiwKKwkJCQkJCURvb3JCZWxsQWRhcHRlck5vcm1SZXNwUmVhZHkpOworCQkJCX0KIAkJCX0K
IAkJCUluZGV4ID0gcnhfcmVhZGwoZGV2LCBNVW5pdC5PdXRib3VuZFF1ZXVlKTsKIAkJfSB3aGls
ZSAoSW5kZXggIT0gMHhGRkZGRkZGRkwpOwpAQCAtNjMxLDYgKzY1MiwxMCBAQCBpbnQgX2FhY19y
eF9pbml0KHN0cnVjdCBhYWNfZGV2ICpkZXYpCiAJCQluYW1lLCBpbnN0YW5jZSk7CiAJCWdvdG8g
ZXJyb3JfaW91bm1hcDsKIAl9CisJZGV2LT5kYmdfYmFzZSA9IGRldi0+c2NzaV9ob3N0X3B0ci0+
YmFzZTsKKwlkZXYtPmRiZ19iYXNlX21hcHBlZCA9IGRldi0+YmFzZTsKKwlkZXYtPmRiZ19zaXpl
ID0gZGV2LT5iYXNlX3NpemU7CisKIAlhYWNfYWRhcHRlcl9lbmFibGVfaW50KGRldik7CiAJLyoK
IAkgKglUZWxsIHRoZSBhZGFwdGVyIHRoYXQgYWxsIGlzIGNvbmZpZ3VyZWQsIGFuZCBpdCBjYW4K
ZGlmZiAtcHVyTiBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3NhLmMgYi9kcml2ZXJzL3Njc2kvYWFj
cmFpZC9zYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3NhLmMJMjAxMS0wMy0xMSAxNDox
NjozNi4wMDAwMDAwMDAgKzA1MzAKKysrIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvc2EuYwkyMDEx
LTAzLTE2IDE2OjMwOjU4LjAwMDAwMDAwMCArMDUzMApAQCAtNSw3ICs1LDggQEAKICAqIGJhc2Vk
IG9uIHRoZSBvbGQgYWFjcmFpZCBkcml2ZXIgdGhhdCBpcy4uCiAgKiBBZGFwdGVjIGFhY3JhaWQg
ZGV2aWNlIGRyaXZlciBmb3IgTGludXguCiAgKgotICogQ29weXJpZ2h0IChjKSAyMDAwLTIwMDcg
QWRhcHRlYywgSW5jLiAoYWFjcmFpZEBhZGFwdGVjLmNvbSkKKyAqIENvcHlyaWdodCAoYykgMjAw
MC0yMDEwIEFkYXB0ZWMsIEluYy4KKyAqICAgICAgICAgICAgICAgMjAxMCBQTUMtU2llcnJhLCBJ
bmMuIChhYWNyYWlkQHBtYy1zaWVycmEuY29tKQogICoKICAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVl
IHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CiAgKiBpdCB1
bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxp
c2hlZCBieQpAQCAtMzkxLDYgKzM5MiwxMCBAQCBpbnQgYWFjX3NhX2luaXQoc3RydWN0IGFhY19k
ZXYgKmRldikKIAkJCW5hbWUsIGluc3RhbmNlKTsKIAkJZ290byBlcnJvcl9pb3VubWFwOwogCX0K
KwlkZXYtPmRiZ19iYXNlID0gZGV2LT5zY3NpX2hvc3RfcHRyLT5iYXNlOworCWRldi0+ZGJnX2Jh
c2VfbWFwcGVkID0gZGV2LT5iYXNlOworCWRldi0+ZGJnX3NpemUgPSBkZXYtPmJhc2Vfc2l6ZTsK
KwogCWFhY19hZGFwdGVyX2VuYWJsZV9pbnQoZGV2KTsKIAogCS8qCmRpZmYgLXB1ck4gYS9kcml2
ZXJzL3Njc2kvYWFjcmFpZC9zcmMuYyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3NyYy5jCi0tLSBh
L2RyaXZlcnMvc2NzaS9hYWNyYWlkL3NyYy5jCTE5NzAtMDEtMDEgMDU6MzA6MDAuMDAwMDAwMDAw
ICswNTMwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3NyYy5jCTIwMTEtMDMtMTYgMTY6NDQ6
MjcuMDAwMDAwMDAwICswNTMwCkBAIC0wLDAgKzEsNTk0IEBACisvKgorICoJQWRhcHRlYyBBQUMg
c2VyaWVzIFJBSUQgY29udHJvbGxlciBkcml2ZXIKKyAqCShjKSBDb3B5cmlnaHQgMjAwMSBSZWQg
SGF0IEluYy4KKyAqCisgKiBiYXNlZCBvbiB0aGUgb2xkIGFhY3JhaWQgZHJpdmVyIHRoYXQgaXMu
LgorICogQWRhcHRlYyBhYWNyYWlkIGRldmljZSBkcml2ZXIgZm9yIExpbnV4LgorICoKKyAqIENv
cHlyaWdodCAoYykgMjAwMC0yMDEwIEFkYXB0ZWMsIEluYy4KKyAqICAgICAgICAgICAgICAgMjAx
MCBQTUMtU2llcnJhLCBJbmMuIChhYWNyYWlkQHBtYy1zaWVycmEuY29tKQorICoKKyAqIFRoaXMg
cHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3Ig
bW9kaWZ5CisgKiBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBM
aWNlbnNlIGFzIHB1Ymxpc2hlZCBieQorICogdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsg
ZWl0aGVyIHZlcnNpb24gMiwgb3IgKGF0IHlvdXIgb3B0aW9uKQorICogYW55IGxhdGVyIHZlcnNp
b24uCisgKgorICogVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQg
aXQgd2lsbCBiZSB1c2VmdWwsCisgKiBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQg
ZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgorICogTUVSQ0hBTlRBQklMSVRZIG9yIEZJVE5F
U1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZQorICogR05VIEdlbmVyYWwgUHVi
bGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4KKyAqCisgKiBZb3Ugc2hvdWxkIGhhdmUgcmVj
ZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQorICogYWxvbmcg
d2l0aCB0aGlzIHByb2dyYW07IHNlZSB0aGUgZmlsZSBDT1BZSU5HLiAgSWYgbm90LCB3cml0ZSB0
bworICogdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbiwgNjc1IE1hc3MgQXZlLCBDYW1icmlk
Z2UsIE1BIDAyMTM5LCBVU0EuCisgKgorICogTW9kdWxlIE5hbWU6CisgKiAgc3JjLmMKKyAqCisg
KiBBYnN0cmFjdDogSGFyZHdhcmUgRGV2aWNlIEludGVyZmFjZSBmb3IgUE1DIFNSQyBiYXNlZCBj
b250cm9sbGVycworICoKKyAqLworCisjaW5jbHVkZSA8bGludXgva2VybmVsLmg+CisjaW5jbHVk
ZSA8bGludXgvaW5pdC5oPgorI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CisjaW5jbHVkZSA8bGlu
dXgvcGNpLmg+CisjaW5jbHVkZSA8bGludXgvc3BpbmxvY2suaD4KKyNpbmNsdWRlIDxsaW51eC9z
bGFiLmg+CisjaW5jbHVkZSA8bGludXgvYmxrZGV2Lmg+CisjaW5jbHVkZSA8bGludXgvZGVsYXku
aD4KKyNpbmNsdWRlIDxsaW51eC92ZXJzaW9uLmg+CisjaW5jbHVkZSA8bGludXgvY29tcGxldGlv
bi5oPgorI2luY2x1ZGUgPGxpbnV4L3RpbWUuaD4KKyNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQu
aD4KKyNpbmNsdWRlIDxzY3NpL3Njc2lfaG9zdC5oPgorCisjaW5jbHVkZSAiYWFjcmFpZC5oIgor
CitzdGF0aWMgaXJxcmV0dXJuX3QgYWFjX3NyY19pbnRyX21lc3NhZ2UoaW50IGlycSwgdm9pZCAq
ZGV2X2lkKQoreworCXN0cnVjdCBhYWNfZGV2ICpkZXYgPSBkZXZfaWQ7CisJdW5zaWduZWQgbG9u
ZyBiZWxsYml0cywgYmVsbGJpdHNfc2hpZnRlZDsKKwlpbnQgb3VyX2ludGVycnVwdCA9IDA7CisJ
aW50IGlzRmFzdFJlc3BvbnNlOworCXUzMiBpbmRleCwgaGFuZGxlOworCisJYmVsbGJpdHMgPSBz
cmNfcmVhZGwoZGV2LCBNVW5pdC5PRFJfUik7CisJaWYgKGJlbGxiaXRzICYgUG1Eb29yQmVsbFJl
c3BvbnNlU2VudCkgeworCQliZWxsYml0cyA9IFBtRG9vckJlbGxSZXNwb25zZVNlbnQ7CisJCS8q
IGhhbmRsZSBhc3luYy4gc3RhdHVzICovCisJCW91cl9pbnRlcnJ1cHQgPSAxOworCQlpbmRleCA9
IGRldi0+aG9zdF9ycnFfaWR4OworCQlpZiAoZGV2LT5ob3N0X3JycVtpbmRleF0gPT0gMCkgewor
CQkJdTMyIG9sZF9pbmRleCA9IGluZGV4OworCQkJLyogYWRqdXN0IGluZGV4ICovCisJCQlkbyB7
CisJCQkJaW5kZXgrKzsKKwkJCQlpZiAoaW5kZXggPT0gZGV2LT5zY3NpX2hvc3RfcHRyLT5jYW5f
cXVldWUgKworCQkJCQkJCUFBQ19OVU1fTUdUX0ZJQikKKwkJCQkJaW5kZXggPSAwOworCQkJCWlm
IChkZXYtPmhvc3RfcnJxW2luZGV4XSAhPSAwKQorCQkJCQlicmVhazsKKwkJCX0gd2hpbGUgKGlu
ZGV4ICE9IG9sZF9pbmRleCk7CisJCQlkZXYtPmhvc3RfcnJxX2lkeCA9IGluZGV4OworCQl9CisJ
CWZvciAoOzspIHsKKwkJCWlzRmFzdFJlc3BvbnNlID0gMDsKKwkJCS8qIHJlbW92ZSB0b2dnbGUg
Yml0ICgzMSkgKi8KKwkJCWhhbmRsZSA9IChkZXYtPmhvc3RfcnJxW2luZGV4XSAmIDB4N2ZmZmZm
ZmYpOworCQkJLyogY2hlY2sgZmFzdCByZXNwb25zZSBiaXQgKDMwKSAqLworCQkJaWYgKGhhbmRs
ZSAmIDB4NDAwMDAwMDApCisJCQkJaXNGYXN0UmVzcG9uc2UgPSAxOworCQkJaGFuZGxlICY9IDB4
MDAwMGZmZmY7CisJCQlpZiAoaGFuZGxlID09IDApCisJCQkJYnJlYWs7CisKKwkJCWFhY19pbnRy
X25vcm1hbChkZXYsIGhhbmRsZS0xLCAwLCBpc0Zhc3RSZXNwb25zZSwgTlVMTCk7CisKKwkJCWRl
di0+aG9zdF9ycnFbaW5kZXgrK10gPSAwOworCQkJaWYgKGluZGV4ID09IGRldi0+c2NzaV9ob3N0
X3B0ci0+Y2FuX3F1ZXVlICsKKwkJCQkJCUFBQ19OVU1fTUdUX0ZJQikKKwkJCQlpbmRleCA9IDA7
CisJCQlkZXYtPmhvc3RfcnJxX2lkeCA9IGluZGV4OworCQl9CisJfSBlbHNlIHsKKwkJYmVsbGJp
dHNfc2hpZnRlZCA9IChiZWxsYml0cyA+PiBTUkNfT0RSX1NISUZUKTsKKwkJaWYgKGJlbGxiaXRz
X3NoaWZ0ZWQgJiBEb29yQmVsbEFpZlBlbmRpbmcpIHsKKwkJCW91cl9pbnRlcnJ1cHQgPSAxOwor
CQkJLyogaGFuZGxlIEFJRiAqLworCQkJYWFjX2ludHJfbm9ybWFsKGRldiwgMCwgMiwgMCwgTlVM
TCk7CisJCX0KKwl9CisKKwlpZiAob3VyX2ludGVycnVwdCkgeworCQlzcmNfd3JpdGVsKGRldiwg
TVVuaXQuT0RSX0MsIGJlbGxiaXRzKTsKKwkJcmV0dXJuIElSUV9IQU5ETEVEOworCX0KKwlyZXR1
cm4gSVJRX05PTkU7Cit9CisKKy8qKgorICoJYWFjX3NyY19kaXNhYmxlX2ludGVycnVwdAktCURp
c2FibGUgaW50ZXJydXB0cworICoJQGRldjogQWRhcHRlcgorICovCisKK3N0YXRpYyB2b2lkIGFh
Y19zcmNfZGlzYWJsZV9pbnRlcnJ1cHQoc3RydWN0IGFhY19kZXYgKmRldikKK3sKKwlzcmNfd3Jp
dGVsKGRldiwgTVVuaXQuT0lNUiwgZGV2LT5PSU1SID0gMHhmZmZmZmZmZik7Cit9CisKKy8qKgor
ICoJYWFjX3NyY19lbmFibGVfaW50ZXJydXB0X21lc3NhZ2UJLQlFbmFibGUgaW50ZXJydXB0cwor
ICoJQGRldjogQWRhcHRlcgorICovCisKK3N0YXRpYyB2b2lkIGFhY19zcmNfZW5hYmxlX2ludGVy
cnVwdF9tZXNzYWdlKHN0cnVjdCBhYWNfZGV2ICpkZXYpCit7CisJc3JjX3dyaXRlbChkZXYsIE1V
bml0Lk9JTVIsIGRldi0+T0lNUiA9IDB4ZmZmZmZmZjgpOworfQorCisvKioKKyAqCXNyY19zeW5j
X2NtZAktCXNlbmQgYSBjb21tYW5kIGFuZCB3YWl0CisgKglAZGV2OiBBZGFwdGVyCisgKglAY29t
bWFuZDogQ29tbWFuZCB0byBleGVjdXRlCisgKglAcDE6IGZpcnN0IHBhcmFtZXRlcgorICoJQHJl
dDogYWRhcHRlciBzdGF0dXMKKyAqCisgKglUaGlzIHJvdXRpbmUgd2lsbCBzZW5kIGEgc3luY2hy
b25vdXMgY29tbWFuZCB0byB0aGUgYWRhcHRlciBhbmQgd2FpdAorICoJZm9yIGl0cwljb21wbGV0
aW9uLgorICovCisKK3N0YXRpYyBpbnQgc3JjX3N5bmNfY21kKHN0cnVjdCBhYWNfZGV2ICpkZXYs
IHUzMiBjb21tYW5kLAorCXUzMiBwMSwgdTMyIHAyLCB1MzIgcDMsIHUzMiBwNCwgdTMyIHA1LCB1
MzIgcDYsCisJdTMyICpzdGF0dXMsIHUzMiAqIHIxLCB1MzIgKiByMiwgdTMyICogcjMsIHUzMiAq
IHI0KQoreworCXVuc2lnbmVkIGxvbmcgc3RhcnQ7CisJaW50IG9rOworCisJLyoKKwkgKglXcml0
ZSB0aGUgY29tbWFuZCBpbnRvIE1haWxib3ggMAorCSAqLworCXdyaXRlbChjb21tYW5kLCAmZGV2
LT5JbmRleFJlZ3MtPk1haWxib3hbMF0pOworCS8qCisJICoJV3JpdGUgdGhlIHBhcmFtZXRlcnMg
aW50byBNYWlsYm94ZXMgMSAtIDYKKwkgKi8KKwl3cml0ZWwocDEsICZkZXYtPkluZGV4UmVncy0+
TWFpbGJveFsxXSk7CisJd3JpdGVsKHAyLCAmZGV2LT5JbmRleFJlZ3MtPk1haWxib3hbMl0pOwor
CXdyaXRlbChwMywgJmRldi0+SW5kZXhSZWdzLT5NYWlsYm94WzNdKTsKKwl3cml0ZWwocDQsICZk
ZXYtPkluZGV4UmVncy0+TWFpbGJveFs0XSk7CisKKwkvKgorCSAqCUNsZWFyIHRoZSBzeW5jaCBj
b21tYW5kIGRvb3JiZWxsIHRvIHN0YXJ0IG9uIGEgY2xlYW4gc2xhdGUuCisJICovCisJc3JjX3dy
aXRlbChkZXYsIE1Vbml0Lk9EUl9DLCBPVVRCT1VORERPT1JCRUxMXzAgPDwgU1JDX09EUl9TSElG
VCk7CisKKwkvKgorCSAqCURpc2FibGUgZG9vcmJlbGwgaW50ZXJydXB0cworCSAqLworCXNyY193
cml0ZWwoZGV2LCBNVW5pdC5PSU1SLCBkZXYtPk9JTVIgPSAweGZmZmZmZmZmKTsKKworCS8qCisJ
ICoJRm9yY2UgdGhlIGNvbXBsZXRpb24gb2YgdGhlIG1hc2sgcmVnaXN0ZXIgd3JpdGUgYmVmb3Jl
IGlzc3VpbmcKKwkgKgl0aGUgaW50ZXJydXB0LgorCSAqLworCXNyY19yZWFkbChkZXYsIE1Vbml0
Lk9JTVIpOworCisJLyoKKwkgKglTaWduYWwgdGhhdCB0aGVyZSBpcyBhIG5ldyBzeW5jaCBjb21t
YW5kCisJICovCisJc3JjX3dyaXRlbChkZXYsIE1Vbml0LklEUiwgSU5CT1VORERPT1JCRUxMXzAg
PDwgU1JDX0lEUl9TSElGVCk7CisKKwlvayA9IDA7CisJc3RhcnQgPSBqaWZmaWVzOworCisJLyoK
KwkgKglXYWl0IHVwIHRvIDMwIHNlY29uZHMKKwkgKi8KKwl3aGlsZSAodGltZV9iZWZvcmUoamlm
Zmllcywgc3RhcnQrMzAqSFopKSB7CisJCS8qIERlbGF5IDUgbWljcm9zZWNvbmRzIHRvIGxldCBN
b245NjAgZ2V0IGluZm8uICovCisJCXVkZWxheSg1KTsKKworCQkvKiBNb245NjAgd2lsbCBzZXQg
ZG9vcmJlbGwwIGJpdAorCQkgKiB3aGVuIGl0IGhhcyBjb21wbGV0ZWQgdGhlIGNvbW1hbmQKKwkJ
ICovCisJCWlmICgoc3JjX3JlYWRsKGRldiwgTVVuaXQuT0RSX1IpID4+IFNSQ19PRFJfU0hJRlQp
ICYgT1VUQk9VTkRET09SQkVMTF8wKSB7CisJCQkvKiBDbGVhciB0aGUgZG9vcmJlbGwgKi8KKwkJ
CXNyY193cml0ZWwoZGV2LAorCQkJCU1Vbml0Lk9EUl9DLAorCQkJCU9VVEJPVU5ERE9PUkJFTExf
MCA8PCBTUkNfT0RSX1NISUZUKTsKKwkJCW9rID0gMTsKKwkJCWJyZWFrOworCQl9CisKKwkJIC8q
IFlpZWxkIHRoZSBwcm9jZXNzb3IgaW4gY2FzZSB3ZSBhcmUgc2xvdyAqLworCQltc2xlZXAoMSk7
CisJfQorCWlmICh1bmxpa2VseShvayAhPSAxKSkgeworCQkgLyogUmVzdG9yZSBpbnRlcnJ1cHQg
bWFzayBldmVuIHRob3VnaCB3ZSB0aW1lZCBvdXQgKi8KKwkJYWFjX2FkYXB0ZXJfZW5hYmxlX2lu
dChkZXYpOworCQlyZXR1cm4gLUVUSU1FRE9VVDsKKwl9CisKKwkgLyogUHVsbCB0aGUgc3luY2gg
c3RhdHVzIGZyb20gTWFpbGJveCAwICovCisJaWYgKHN0YXR1cykKKwkJKnN0YXR1cyA9IHJlYWRs
KCZkZXYtPkluZGV4UmVncy0+TWFpbGJveFswXSk7CisJaWYgKHIxKQorCQkqcjEgPSByZWFkbCgm
ZGV2LT5JbmRleFJlZ3MtPk1haWxib3hbMV0pOworCWlmIChyMikKKwkJKnIyID0gcmVhZGwoJmRl
di0+SW5kZXhSZWdzLT5NYWlsYm94WzJdKTsKKwlpZiAocjMpCisJCSpyMyA9IHJlYWRsKCZkZXYt
PkluZGV4UmVncy0+TWFpbGJveFszXSk7CisJaWYgKHI0KQorCQkqcjQgPSByZWFkbCgmZGV2LT5J
bmRleFJlZ3MtPk1haWxib3hbNF0pOworCisJIC8qIENsZWFyIHRoZSBzeW5jaCBjb21tYW5kIGRv
b3JiZWxsICovCisJc3JjX3dyaXRlbChkZXYsIE1Vbml0Lk9EUl9DLCBPVVRCT1VORERPT1JCRUxM
XzAgPDwgU1JDX09EUl9TSElGVCk7CisKKwkgLyogUmVzdG9yZSBpbnRlcnJ1cHQgbWFzayAqLwor
CWFhY19hZGFwdGVyX2VuYWJsZV9pbnQoZGV2KTsKKwlyZXR1cm4gMDsKKworfQorCisvKioKKyAq
CWFhY19zcmNfaW50ZXJydXB0X2FkYXB0ZXIJLQlpbnRlcnJ1cHQgYWRhcHRlcgorICoJQGRldjog
QWRhcHRlcgorICoKKyAqCVNlbmQgYW4gaW50ZXJydXB0IHRvIHRoZSBpOTYwIGFuZCBicmVha3Bv
aW50IGl0LgorICovCisKK3N0YXRpYyB2b2lkIGFhY19zcmNfaW50ZXJydXB0X2FkYXB0ZXIoc3Ry
dWN0IGFhY19kZXYgKmRldikKK3sKKwlzcmNfc3luY19jbWQoZGV2LCBCUkVBS1BPSU5UX1JFUVVF
U1QsCisJCTAsIDAsIDAsIDAsIDAsIDAsCisJCU5VTEwsIE5VTEwsIE5VTEwsIE5VTEwsIE5VTEwp
OworfQorCisvKioKKyAqCWFhY19zcmNfbm90aWZ5X2FkYXB0ZXIJCS0Jc2VuZCBhbiBldmVudCB0
byB0aGUgYWRhcHRlcgorICoJQGRldjogQWRhcHRlcgorICoJQGV2ZW50OiBFdmVudCB0byBzZW5k
CisgKgorICoJTm90aWZ5IHRoZSBpOTYwIHRoYXQgc29tZXRoaW5nIGl0IHByb2JhYmx5IGNhcmVz
IGFib3V0IGhhcworICoJaGFwcGVuZWQuCisgKi8KKworc3RhdGljIHZvaWQgYWFjX3NyY19ub3Rp
ZnlfYWRhcHRlcihzdHJ1Y3QgYWFjX2RldiAqZGV2LCB1MzIgZXZlbnQpCit7CisJc3dpdGNoIChl
dmVudCkgeworCisJY2FzZSBBZGFwTm9ybUNtZFF1ZToKKwkJc3JjX3dyaXRlbChkZXYsIE1Vbml0
Lk9EUl9DLAorCQkJSU5CT1VORERPT1JCRUxMXzEgPDwgU1JDX09EUl9TSElGVCk7CisJCWJyZWFr
OworCWNhc2UgSG9zdE5vcm1SZXNwTm90RnVsbDoKKwkJc3JjX3dyaXRlbChkZXYsIE1Vbml0Lk9E
Ul9DLAorCQkJSU5CT1VORERPT1JCRUxMXzQgPDwgU1JDX09EUl9TSElGVCk7CisJCWJyZWFrOwor
CWNhc2UgQWRhcE5vcm1SZXNwUXVlOgorCQlzcmNfd3JpdGVsKGRldiwgTVVuaXQuT0RSX0MsCisJ
CQlJTkJPVU5ERE9PUkJFTExfMiA8PCBTUkNfT0RSX1NISUZUKTsKKwkJYnJlYWs7CisJY2FzZSBI
b3N0Tm9ybUNtZE5vdEZ1bGw6CisJCXNyY193cml0ZWwoZGV2LCBNVW5pdC5PRFJfQywKKwkJCUlO
Qk9VTkRET09SQkVMTF8zIDw8IFNSQ19PRFJfU0hJRlQpOworCQlicmVhazsKKwljYXNlIEZhc3RJ
bzoKKwkJc3JjX3dyaXRlbChkZXYsIE1Vbml0Lk9EUl9DLAorCQkJSU5CT1VORERPT1JCRUxMXzYg
PDwgU1JDX09EUl9TSElGVCk7CisJCWJyZWFrOworCWNhc2UgQWRhcFByaW50ZkRvbmU6CisJCXNy
Y193cml0ZWwoZGV2LCBNVW5pdC5PRFJfQywKKwkJCUlOQk9VTkRET09SQkVMTF81IDw8IFNSQ19P
RFJfU0hJRlQpOworCQlicmVhazsKKwlkZWZhdWx0OgorCQlCVUcoKTsKKwkJYnJlYWs7CisJfQor
fQorCisvKioKKyAqCWFhY19zcmNfc3RhcnRfYWRhcHRlcgkJLQlhY3RpdmF0ZSBhZGFwdGVyCisg
KglAZGV2OglBZGFwdGVyCisgKgorICoJU3RhcnQgdXAgcHJvY2Vzc2luZyBvbiBhbiBpOTYwIGJh
c2VkIEFBQyBhZGFwdGVyCisgKi8KKworc3RhdGljIHZvaWQgYWFjX3NyY19zdGFydF9hZGFwdGVy
KHN0cnVjdCBhYWNfZGV2ICpkZXYpCit7CisJc3RydWN0IGFhY19pbml0ICppbml0OworCisJaW5p
dCA9IGRldi0+aW5pdDsKKwlpbml0LT5Ib3N0RWxhcHNlZFNlY29uZHMgPSBjcHVfdG9fbGUzMihn
ZXRfc2Vjb25kcygpKTsKKworCS8qIFdlIGNhbiBvbmx5IHVzZSBhIDMyIGJpdCBhZGRyZXNzIGhl
cmUgKi8KKwlzcmNfc3luY19jbWQoZGV2LCBJTklUX1NUUlVDVF9CQVNFX0FERFJFU1MsICh1MzIp
KHVsb25nKWRldi0+aW5pdF9wYSwKKwkgIDAsIDAsIDAsIDAsIDAsIE5VTEwsIE5VTEwsIE5VTEws
IE5VTEwsIE5VTEwpOworfQorCisvKioKKyAqCWFhY19zcmNfY2hlY2tfaGVhbHRoCisgKglAZGV2
OiBkZXZpY2UgdG8gY2hlY2sgaWYgaGVhbHRoeQorICoKKyAqCVdpbGwgYXR0ZW1wdCB0byBkZXRl
cm1pbmUgaWYgdGhlIHNwZWNpZmllZCBhZGFwdGVyIGlzIGFsaXZlIGFuZAorICoJY2FwYWJsZSBv
ZiBoYW5kbGluZyByZXF1ZXN0cywgcmV0dXJuaW5nIDAgaWYgYWxpdmUuCisgKi8KK3N0YXRpYyBp
bnQgYWFjX3NyY19jaGVja19oZWFsdGgoc3RydWN0IGFhY19kZXYgKmRldikKK3sKKwl1MzIgc3Rh
dHVzID0gc3JjX3JlYWRsKGRldiwgTVVuaXQuT01SKTsKKworCS8qCisJICoJQ2hlY2sgdG8gc2Vl
IGlmIHRoZSBib2FyZCBmYWlsZWQgYW55IHNlbGYgdGVzdHMuCisJICovCisJaWYgKHVubGlrZWx5
KHN0YXR1cyAmIFNFTEZfVEVTVF9GQUlMRUQpKQorCQlyZXR1cm4gLTE7CisKKwkvKgorCSAqCUNo
ZWNrIHRvIHNlZSBpZiB0aGUgYm9hcmQgcGFuaWMnZC4KKwkgKi8KKwlpZiAodW5saWtlbHkoc3Rh
dHVzICYgS0VSTkVMX1BBTklDKSkKKwkJcmV0dXJuIChzdGF0dXMgPj4gMTYpICYgMHhGRjsKKwkv
KgorCSAqCVdhaXQgZm9yIHRoZSBhZGFwdGVyIHRvIGJlIHVwIGFuZCBydW5uaW5nLgorCSAqLwor
CWlmICh1bmxpa2VseSghKHN0YXR1cyAmIEtFUk5FTF9VUF9BTkRfUlVOTklORykpKQorCQlyZXR1
cm4gLTM7CisJLyoKKwkgKglFdmVyeXRoaW5nIGlzIE9LCisJICovCisJcmV0dXJuIDA7Cit9CisK
Ky8qKgorICoJYWFjX3NyY19kZWxpdmVyX21lc3NhZ2UKKyAqCUBmaWI6IGZpYiB0byBpc3N1ZQor
ICoKKyAqCVdpbGwgc2VuZCBhIGZpYiwgcmV0dXJuaW5nIDAgaWYgc3VjY2Vzc2Z1bC4KKyAqLwor
c3RhdGljIGludCBhYWNfc3JjX2RlbGl2ZXJfbWVzc2FnZShzdHJ1Y3QgZmliICpmaWIpCit7CisJ
c3RydWN0IGFhY19kZXYgKmRldiA9IGZpYi0+ZGV2OworCXN0cnVjdCBhYWNfcXVldWUgKnEgPSAm
ZGV2LT5xdWV1ZXMtPnF1ZXVlW0FkYXBOb3JtQ21kUXVldWVdOworCXVuc2lnbmVkIGxvbmcgcWZs
YWdzOworCXUzMiBmaWJzaXplOworCXU2NCBhZGRyZXNzOworCXN0cnVjdCBhYWNfZmliX3hwb3J0
aGRyICpwRmliWDsKKworCXNwaW5fbG9ja19pcnFzYXZlKHEtPmxvY2ssIHFmbGFncyk7CisJcS0+
bnVtcGVuZGluZysrOworCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUocS0+bG9jaywgcWZsYWdzKTsK
KworCS8qIENhbGN1bGF0ZSB0aGUgYW1vdW50IHRvIHRoZSBmaWJzaXplIGJpdHMgKi8KKwlmaWJz
aXplID0gKHNpemVvZihzdHJ1Y3QgYWFjX2ZpYl94cG9ydGhkcikgKworCQlmaWItPmh3X2ZpYl92
YS0+aGVhZGVyLlNpemUgKyAxMjcpIC8gMTI4IC0gMTsKKwlpZiAoZmlic2l6ZSA+IChBTElHTjMy
IC0gMSkpCisJCWZpYnNpemUgPSBBTElHTjMyIC0gMTsKKworICAgIC8qIEZpbGwgWFBPUlQgaGVh
ZGVyICovCisJcEZpYlggPSAoc3RydWN0IGFhY19maWJfeHBvcnRoZHIgKikKKwkJKCh1bnNpZ25l
ZCBjaGFyICopZmliLT5od19maWJfdmEgLQorCQlzaXplb2Yoc3RydWN0IGFhY19maWJfeHBvcnRo
ZHIpKTsKKwlwRmliWC0+SGFuZGxlID0gZmliLT5od19maWJfdmEtPmhlYWRlci5TZW5kZXJEYXRh
ICsgMTsKKwlwRmliWC0+SG9zdEFkZHJlc3MgPSBmaWItPmh3X2ZpYl9wYTsKKwlwRmliWC0+U2l6
ZSA9IGZpYi0+aHdfZmliX3ZhLT5oZWFkZXIuU2l6ZTsKKwlhZGRyZXNzID0gZmliLT5od19maWJf
cGEgLSAodTY0KXNpemVvZihzdHJ1Y3QgYWFjX2ZpYl94cG9ydGhkcik7CisKKwlzcmNfd3JpdGVs
KGRldiwgTVVuaXQuSVFfSCwgKHUzMikoYWRkcmVzcyA+PiAzMikpOworCXNyY193cml0ZWwoZGV2
LCBNVW5pdC5JUV9MLCAodTMyKShhZGRyZXNzICYgMHhmZmZmZmZmZikgKyBmaWJzaXplKTsKKwly
ZXR1cm4gMDsKK30KKworLyoqCisgKglhYWNfc3JjX2lvcmVtYXAKKyAqCUBzaXplOiBtYXBwaW5n
IHJlc2l6ZSByZXF1ZXN0CisgKgorICovCitzdGF0aWMgaW50IGFhY19zcmNfaW9yZW1hcChzdHJ1
Y3QgYWFjX2RldiAqZGV2LCB1MzIgc2l6ZSkKK3sKKwlpZiAoIXNpemUpIHsKKwkJaW91bm1hcChk
ZXYtPnJlZ3Muc3JjLmJhcjApOworCQlkZXYtPnJlZ3Muc3JjLmJhcjAgPSBOVUxMOworCQlpb3Vu
bWFwKGRldi0+YmFzZSk7CisJCWRldi0+YmFzZSA9IE5VTEw7CisJCXJldHVybiAwOworCX0KKwlk
ZXYtPnJlZ3Muc3JjLmJhcjEgPSBpb3JlbWFwKHBjaV9yZXNvdXJjZV9zdGFydChkZXYtPnBkZXYs
IDIpLAorCQlBQUNfTUlOX1NSQ19CQVIxX1NJWkUpOworCWRldi0+YmFzZSA9IE5VTEw7CisJaWYg
KGRldi0+cmVncy5zcmMuYmFyMSA9PSBOVUxMKQorCQlyZXR1cm4gLTE7CisJZGV2LT5iYXNlID0g
ZGV2LT5yZWdzLnNyYy5iYXIwID0gaW9yZW1hcChkZXYtPnNjc2lfaG9zdF9wdHItPmJhc2UsCisJ
CQkJc2l6ZSk7CisJaWYgKGRldi0+YmFzZSA9PSBOVUxMKSB7CisJCWlvdW5tYXAoZGV2LT5yZWdz
LnNyYy5iYXIxKTsKKwkJZGV2LT5yZWdzLnNyYy5iYXIxID0gTlVMTDsKKwkJcmV0dXJuIC0xOwor
CX0KKwlkZXYtPkluZGV4UmVncyA9ICYoKHN0cnVjdCBzcmNfcmVnaXN0ZXJzIF9faW9tZW0gKikK
KwkJZGV2LT5iYXNlKS0+SW5kZXhSZWdzOworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IGFh
Y19zcmNfcmVzdGFydF9hZGFwdGVyKHN0cnVjdCBhYWNfZGV2ICpkZXYsIGludCBibGVkKQorewor
CXUzMiB2YXIsIHJlc2V0X21hc2s7CisKKwlpZiAoYmxlZCA+PSAwKSB7CisJCWlmIChibGVkKQor
CQkJcHJpbnRrKEtFUk5fRVJSICIlcyVkOiBhZGFwdGVyIGtlcm5lbCBwYW5pYydkICV4LlxuIiwK
KwkJCQlkZXYtPm5hbWUsIGRldi0+aWQsIGJsZWQpOworCQlibGVkID0gYWFjX2FkYXB0ZXJfc3lu
Y19jbWQoZGV2LCBJT1BfUkVTRVRfQUxXQVlTLAorCQkJMCwgMCwgMCwgMCwgMCwgMCwgJnZhciwg
JnJlc2V0X21hc2ssIE5VTEwsIE5VTEwsIE5VTEwpOworCQkJaWYgKGJsZWQgfHwgKHZhciAhPSAw
eDAwMDAwMDAxKSkKKwkJCQlibGVkID0gLUVJTlZBTDsKKwkJaWYgKGRldi0+c3VwcGxlbWVudF9h
ZGFwdGVyX2luZm8uU3VwcG9ydGVkT3B0aW9uczIgJgorCQkJQUFDX09QVElPTl9ET09SQkVMTF9S
RVNFVCkgeworCQkJc3JjX3dyaXRlbChkZXYsIE1Vbml0LklEUiwgcmVzZXRfbWFzayk7CisJCQlt
c2xlZXAoNTAwMCk7IC8qIERlbGF5IDUgc2Vjb25kcyAqLworCQl9CisJfQorCisJaWYgKHNyY19y
ZWFkbChkZXYsIE1Vbml0Lk9NUikgJiBLRVJORUxfUEFOSUMpCisJCXJldHVybiAtRU5PREVWOwor
CisJaWYgKHN0YXJ0dXBfdGltZW91dCA8IDMwMCkKKwkJc3RhcnR1cF90aW1lb3V0ID0gMzAwOwor
CisJcmV0dXJuIDA7Cit9CisKKy8qKgorICoJYWFjX3NyY19zZWxlY3RfY29tbQktCVNlbGVjdCBj
b21tdW5pY2F0aW9ucyBtZXRob2QKKyAqCUBkZXY6IEFkYXB0ZXIKKyAqCUBjb21tOiBjb21tdW5p
Y2F0aW9ucyBtZXRob2QKKyAqLworaW50IGFhY19zcmNfc2VsZWN0X2NvbW0oc3RydWN0IGFhY19k
ZXYgKmRldiwgaW50IGNvbW0pCit7CisJc3dpdGNoIChjb21tKSB7CisJY2FzZSBBQUNfQ09NTV9N
RVNTQUdFOgorCQlkZXYtPmFfb3BzLmFkYXB0ZXJfZW5hYmxlX2ludCA9IGFhY19zcmNfZW5hYmxl
X2ludGVycnVwdF9tZXNzYWdlOworCQlkZXYtPmFfb3BzLmFkYXB0ZXJfaW50ciA9IGFhY19zcmNf
aW50cl9tZXNzYWdlOworCQlkZXYtPmFfb3BzLmFkYXB0ZXJfZGVsaXZlciA9IGFhY19zcmNfZGVs
aXZlcl9tZXNzYWdlOworCQlicmVhazsKKwlkZWZhdWx0OgorCQlyZXR1cm4gMTsKKwl9CisJcmV0
dXJuIDA7Cit9CisKKy8qKgorICogIGFhY19zcmNfaW5pdAktCWluaXRpYWxpemUgYW4gQ2FyZGlu
YWwgRnJleSBCYXIgY2FyZAorICogIEBkZXY6IGRldmljZSB0byBjb25maWd1cmUKKyAqCisgKi8K
KworaW50IGFhY19zcmNfaW5pdChzdHJ1Y3QgYWFjX2RldiAqZGV2KQoreworCXVuc2lnbmVkIGxv
bmcgc3RhcnQ7CisJdW5zaWduZWQgbG9uZyBzdGF0dXM7CisJaW50IHJlc3RhcnQgPSAwOworCWlu
dCBpbnN0YW5jZSA9IGRldi0+aWQ7CisJY29uc3QgY2hhciAqbmFtZSA9IGRldi0+bmFtZTsKKwor
CWRldi0+YV9vcHMuYWRhcHRlcl9pb3JlbWFwID0gYWFjX3NyY19pb3JlbWFwOworCWRldi0+YV9v
cHMuYWRhcHRlcl9jb21tID0gYWFjX3NyY19zZWxlY3RfY29tbTsKKworCWRldi0+YmFzZV9zaXpl
ID0gQUFDX01JTl9TUkNfQkFSMF9TSVpFOworCWlmIChhYWNfYWRhcHRlcl9pb3JlbWFwKGRldiwg
ZGV2LT5iYXNlX3NpemUpKSB7CisJCXByaW50ayhLRVJOX1dBUk5JTkcgIiVzOiB1bmFibGUgdG8g
bWFwIGFkYXB0ZXIuXG4iLCBuYW1lKTsKKwkJZ290byBlcnJvcl9pb3VubWFwOworCX0KKworCS8q
IEZhaWx1cmUgdG8gcmVzZXQgaGVyZSBpcyBhbiBvcHRpb24gLi4uICovCisJZGV2LT5hX29wcy5h
ZGFwdGVyX3N5bmNfY21kID0gc3JjX3N5bmNfY21kOworCWRldi0+YV9vcHMuYWRhcHRlcl9lbmFi
bGVfaW50ID0gYWFjX3NyY19kaXNhYmxlX2ludGVycnVwdDsKKwlpZiAoKGFhY19yZXNldF9kZXZp
Y2VzIHx8IHJlc2V0X2RldmljZXMpICYmCisJCSFhYWNfc3JjX3Jlc3RhcnRfYWRhcHRlcihkZXYs
IDApKQorCQkrK3Jlc3RhcnQ7CisJLyoKKwkgKglDaGVjayB0byBzZWUgaWYgdGhlIGJvYXJkIHBh
bmljJ2Qgd2hpbGUgYm9vdGluZy4KKwkgKi8KKwlzdGF0dXMgPSBzcmNfcmVhZGwoZGV2LCBNVW5p
dC5PTVIpOworCWlmIChzdGF0dXMgJiBLRVJORUxfUEFOSUMpIHsKKwkJaWYgKGFhY19zcmNfcmVz
dGFydF9hZGFwdGVyKGRldiwgYWFjX3NyY19jaGVja19oZWFsdGgoZGV2KSkpCisJCQlnb3RvIGVy
cm9yX2lvdW5tYXA7CisJCSsrcmVzdGFydDsKKwl9CisJLyoKKwkgKglDaGVjayB0byBzZWUgaWYg
dGhlIGJvYXJkIGZhaWxlZCBhbnkgc2VsZiB0ZXN0cy4KKwkgKi8KKwlzdGF0dXMgPSBzcmNfcmVh
ZGwoZGV2LCBNVW5pdC5PTVIpOworCWlmIChzdGF0dXMgJiBTRUxGX1RFU1RfRkFJTEVEKSB7CisJ
CXByaW50ayhLRVJOX0VSUiAiJXMlZDogYWRhcHRlciBzZWxmLXRlc3QgZmFpbGVkLlxuIiwKKwkJ
CWRldi0+bmFtZSwgaW5zdGFuY2UpOworCQlnb3RvIGVycm9yX2lvdW5tYXA7CisJfQorCS8qCisJ
ICoJQ2hlY2sgdG8gc2VlIGlmIHRoZSBtb25pdG9yIHBhbmljJ2Qgd2hpbGUgYm9vdGluZy4KKwkg
Ki8KKwlpZiAoc3RhdHVzICYgTU9OSVRPUl9QQU5JQykgeworCQlwcmludGsoS0VSTl9FUlIgIiVz
JWQ6IGFkYXB0ZXIgbW9uaXRvciBwYW5pYy5cbiIsCisJCQlkZXYtPm5hbWUsIGluc3RhbmNlKTsK
KwkJZ290byBlcnJvcl9pb3VubWFwOworCX0KKwlzdGFydCA9IGppZmZpZXM7CisJLyoKKwkgKglX
YWl0IGZvciB0aGUgYWRhcHRlciB0byBiZSB1cCBhbmQgcnVubmluZy4gV2FpdCB1cCB0byAzIG1p
bnV0ZXMKKwkgKi8KKwl3aGlsZSAoISgoc3RhdHVzID0gc3JjX3JlYWRsKGRldiwgTVVuaXQuT01S
KSkgJgorCQlLRVJORUxfVVBfQU5EX1JVTk5JTkcpKSB7CisJCWlmICgocmVzdGFydCAmJgorCQkg
IChzdGF0dXMgJiAoS0VSTkVMX1BBTklDfFNFTEZfVEVTVF9GQUlMRUR8TU9OSVRPUl9QQU5JQykp
KSB8fAorCQkgIHRpbWVfYWZ0ZXIoamlmZmllcywgc3RhcnQrSFoqc3RhcnR1cF90aW1lb3V0KSkg
eworCQkJcHJpbnRrKEtFUk5fRVJSICIlcyVkOiBhZGFwdGVyIGtlcm5lbCBmYWlsZWQgdG8gc3Rh
cnQsIGluaXQgc3RhdHVzID0gJWx4LlxuIiwKKwkJCQkJZGV2LT5uYW1lLCBpbnN0YW5jZSwgc3Rh
dHVzKTsKKwkJCWdvdG8gZXJyb3JfaW91bm1hcDsKKwkJfQorCQlpZiAoIXJlc3RhcnQgJiYKKwkJ
ICAoKHN0YXR1cyAmIChLRVJORUxfUEFOSUN8U0VMRl9URVNUX0ZBSUxFRHxNT05JVE9SX1BBTklD
KSkgfHwKKwkJICB0aW1lX2FmdGVyKGppZmZpZXMsIHN0YXJ0ICsgSFogKgorCQkgICgoc3RhcnR1
cF90aW1lb3V0ID4gNjApCisJCSAgICA/IChzdGFydHVwX3RpbWVvdXQgLSA2MCkKKwkJICAgIDog
KHN0YXJ0dXBfdGltZW91dCAvIDIpKSkpKSB7CisJCQlpZiAobGlrZWx5KCFhYWNfc3JjX3Jlc3Rh
cnRfYWRhcHRlcihkZXYsCisJCQkgICAgYWFjX3NyY19jaGVja19oZWFsdGgoZGV2KSkpKQorCQkJ
CXN0YXJ0ID0gamlmZmllczsKKwkJCSsrcmVzdGFydDsKKwkJfQorCQltc2xlZXAoMSk7CisJfQor
CWlmIChyZXN0YXJ0ICYmIGFhY19jb21taXQpCisJCWFhY19jb21taXQgPSAxOworCS8qCisJICoJ
RmlsbCBpbiB0aGUgY29tbW9uIGZ1bmN0aW9uIGRpc3BhdGNoIHRhYmxlLgorCSAqLworCWRldi0+
YV9vcHMuYWRhcHRlcl9pbnRlcnJ1cHQgPSBhYWNfc3JjX2ludGVycnVwdF9hZGFwdGVyOworCWRl
di0+YV9vcHMuYWRhcHRlcl9kaXNhYmxlX2ludCA9IGFhY19zcmNfZGlzYWJsZV9pbnRlcnJ1cHQ7
CisJZGV2LT5hX29wcy5hZGFwdGVyX25vdGlmeSA9IGFhY19zcmNfbm90aWZ5X2FkYXB0ZXI7CisJ
ZGV2LT5hX29wcy5hZGFwdGVyX3N5bmNfY21kID0gc3JjX3N5bmNfY21kOworCWRldi0+YV9vcHMu
YWRhcHRlcl9jaGVja19oZWFsdGggPSBhYWNfc3JjX2NoZWNrX2hlYWx0aDsKKwlkZXYtPmFfb3Bz
LmFkYXB0ZXJfcmVzdGFydCA9IGFhY19zcmNfcmVzdGFydF9hZGFwdGVyOworCisJLyoKKwkgKglG
aXJzdCBjbGVhciBvdXQgYWxsIGludGVycnVwdHMuICBUaGVuIGVuYWJsZSB0aGUgb25lJ3MgdGhh
dCB3ZQorCSAqCWNhbiBoYW5kbGUuCisJICovCisJYWFjX2FkYXB0ZXJfY29tbShkZXYsIEFBQ19D
T01NX01FU1NBR0UpOworCWFhY19hZGFwdGVyX2Rpc2FibGVfaW50KGRldik7CisJc3JjX3dyaXRl
bChkZXYsIE1Vbml0Lk9EUl9DLCAweGZmZmZmZmZmKTsKKwlhYWNfYWRhcHRlcl9lbmFibGVfaW50
KGRldik7CisKKwlpZiAoYWFjX2luaXRfYWRhcHRlcihkZXYpID09IE5VTEwpCisJCWdvdG8gZXJy
b3JfaW91bm1hcDsKKwlpZiAoZGV2LT5jb21tX2ludGVyZmFjZSAhPSBBQUNfQ09NTV9NRVNTQUdF
X1RZUEUxKQorCQlnb3RvIGVycm9yX2lvdW5tYXA7CisKKwlkZXYtPm1zaSA9IGFhY19tc2kgJiYg
IXBjaV9lbmFibGVfbXNpKGRldi0+cGRldik7CisKKwlpZiAocmVxdWVzdF9pcnEoZGV2LT5wZGV2
LT5pcnEsIGRldi0+YV9vcHMuYWRhcHRlcl9pbnRyLAorCQkJSVJRRl9TSEFSRUR8SVJRRl9ESVNB
QkxFRCwgImFhY3JhaWQiLCBkZXYpIDwgMCkgeworCisJCWlmIChkZXYtPm1zaSkKKwkJCXBjaV9k
aXNhYmxlX21zaShkZXYtPnBkZXYpOworCisJCXByaW50ayhLRVJOX0VSUiAiJXMlZDogSW50ZXJy
dXB0IHVuYXZhaWxhYmxlLlxuIiwKKwkJCW5hbWUsIGluc3RhbmNlKTsKKwkJZ290byBlcnJvcl9p
b3VubWFwOworCX0KKwlkZXYtPmRiZ19iYXNlID0gcGNpX3Jlc291cmNlX3N0YXJ0KGRldi0+cGRl
diwgMik7CisJZGV2LT5kYmdfYmFzZV9tYXBwZWQgPSBkZXYtPnJlZ3Muc3JjLmJhcjE7CisJZGV2
LT5kYmdfc2l6ZSA9IEFBQ19NSU5fU1JDX0JBUjFfU0laRTsKKworCWFhY19hZGFwdGVyX2VuYWJs
ZV9pbnQoZGV2KTsKKwkvKgorCSAqCVRlbGwgdGhlIGFkYXB0ZXIgdGhhdCBhbGwgaXMgY29uZmln
dXJlZCwgYW5kIGl0IGNhbgorCSAqIHN0YXJ0IGFjY2VwdGluZyByZXF1ZXN0cworCSAqLworCWFh
Y19zcmNfc3RhcnRfYWRhcHRlcihkZXYpOworCisJcmV0dXJuIDA7CisKK2Vycm9yX2lvdW5tYXA6
CisKKwlyZXR1cm4gLTE7Cit9CgpSZWdhcmRzIC0gTWFoZXNoIFJhamFzaGVraGFyYQo=

------_=_NextPart_001_01CBE483.2AD6F512--
