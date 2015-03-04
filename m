From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH 4/7] aacraid: MSI-x support
Date: Wed, 4 Mar 2015 03:38:30 -0500
Message-ID: <1425458313-1956-5-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:33941 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758097AbbCDJRX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2015 04:17:23 -0500
In-Reply-To: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Achim.Leubner@pmcs.com, Rajinikanth.Pandurangan@pmcs.com, Rich.Bono@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Add MSI-x interrupt mode support.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aachba.c   |    6 +-
 drivers/scsi/aacraid/aacraid.h  |   79 ++++++++-
 drivers/scsi/aacraid/comminit.c |   86 +++++++++-
 drivers/scsi/aacraid/commsup.c  |   19 ++-
 drivers/scsi/aacraid/dpcsup.c   |    9 +-
 drivers/scsi/aacraid/linit.c    |   18 ++-
 drivers/scsi/aacraid/src.c      |  365 +++++++++++++++++++++++++++++----------
 7 files changed, 473 insertions(+), 109 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 0819644..eb524e6 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -473,7 +473,7 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 	if ((le32_to_cpu(get_name_reply->status) == CT_OK)
 	 && (get_name_reply->data[0] != '\0')) {
 		char *sp = get_name_reply->data;
-		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)-1] = '\0';
+		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)] = '\0';
 		while (*sp == ' ')
 			++sp;
 		if (*sp) {
@@ -613,7 +613,9 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 	int status;
 
 	dresp = (struct aac_mount *) fib_data(fibptr);
-	dresp->mnt[0].capacityhigh = 0;
+	if (!(fibptr->dev->supplement_adapter_info.SupportedOptions2 &
+	    AAC_OPTION_VARIABLE_BLOCK_SIZE))
+		dresp->mnt[0].capacityhigh = 0;
 	if ((le32_to_cpu(dresp->status) != ST_OK) ||
 	    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE)) {
 		_aac_probe_container2(context, fibptr);
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 93579f3..c162a65 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -6,11 +6,61 @@
 #define nblank(x) _nblank(x)[0]
 
 #include <linux/interrupt.h>
+#include <linux/pci.h>
 
 /*------------------------------------------------------------------------------
  *              D E F I N E S
  *----------------------------------------------------------------------------*/
 
+#define AAC_MAX_MSIX		32	/* vectors */
+#define AAC_PCI_MSI_ENABLE	0x8000
+
+enum {
+	AAC_ENABLE_INTERRUPT	= 0x0,
+	AAC_DISABLE_INTERRUPT,
+	AAC_ENABLE_MSIX,
+	AAC_DISABLE_MSIX,
+	AAC_CLEAR_AIF_BIT,
+	AAC_CLEAR_SYNC_BIT,
+	AAC_ENABLE_INTX
+};
+
+#define AAC_INT_MODE_INTX		(1<<0)
+#define AAC_INT_MODE_MSI		(1<<1)
+#define AAC_INT_MODE_AIF		(1<<2)
+#define AAC_INT_MODE_SYNC		(1<<3)
+
+#define AAC_INT_ENABLE_TYPE1_INTX	0xfffffffb
+#define AAC_INT_ENABLE_TYPE1_MSIX	0xfffffffa
+#define AAC_INT_DISABLE_ALL		0xffffffff
+
+/* Bit definitions in IOA->Host Interrupt Register */
+#define PMC_TRANSITION_TO_OPERATIONAL	(0x80000000 >> 0)
+#define PMC_IOARCB_TRANSFER_FAILED	(0x80000000 >> 3)
+#define PMC_IOA_UNIT_CHECK		(0x80000000 >> 4)
+#define PMC_NO_HOST_RRQ_FOR_CMD_RESPONSE (0x80000000 >> 5)
+#define PMC_CRITICAL_IOA_OP_IN_PROGRESS	(0x80000000 >> 6)
+#define PMC_IOARRIN_LOST		(0x80000000 >> 27)
+#define PMC_SYSTEM_BUS_MMIO_ERROR	(0x80000000 >> 28)
+#define PMC_IOA_PROCESSOR_IN_ERROR_STATE (0x80000000 >> 29)
+#define PMC_HOST_RRQ_VALID		(0x80000000 >> 30)
+#define PMC_OPERATIONAL_STATUS		(0x80000000 >> 0)
+#define PMC_ALLOW_MSIX_VECTOR0		(0x80000000 >> 31)
+
+#define PMC_IOA_ERROR_INTERRUPTS	(PMC_IOARCB_TRANSFER_FAILED | \
+					 PMC_IOA_UNIT_CHECK | \
+					 PMC_NO_HOST_RRQ_FOR_CMD_RESPONSE | \
+					 PMC_IOARRIN_LOST | \
+					 PMC_SYSTEM_BUS_MMIO_ERROR | \
+					 PMC_IOA_PROCESSOR_IN_ERROR_STATE)
+
+#define PMC_ALL_INTERRUPT_BITS		(PMC_IOA_ERROR_INTERRUPTS | \
+					 PMC_HOST_RRQ_VALID | \
+					 PMC_TRANSITION_TO_OPERATIONAL | \
+					 PMC_ALLOW_MSIX_VECTOR0)
+#define	PMC_GLOBAL_INT_BIT2		0x00000004
+#define	PMC_GLOBAL_INT_BIT0		0x00000001
+
 #ifndef AAC_DRIVER_BUILD
 # define AAC_DRIVER_BUILD 30300
 # define AAC_DRIVER_BRANCH "-ms"
@@ -36,6 +86,7 @@
 #define CONTAINER_TO_ID(cont)		(cont)
 #define CONTAINER_TO_LUN(cont)		(0)
 
+#define PMC_DEVICE_S6	0x28b
 #define PMC_DEVICE_S7	0x28c
 #define PMC_DEVICE_S8	0x28d
 #define PMC_DEVICE_S9	0x28f
@@ -434,7 +485,7 @@ enum fib_xfer_state {
 struct aac_init
 {
 	__le32	InitStructRevision;
-	__le32	MiniPortRevision;
+	__le32	NoOfMSIXVectors;
 	__le32	fsrev;
 	__le32	CommHeaderAddress;
 	__le32	FastIoCommAreaAddress;
@@ -755,7 +806,8 @@ struct rkt_registers {
 
 struct src_mu_registers {
 				/*	PCI*| Name */
-	__le32	reserved0[8];	/*	00h | Reserved */
+	__le32	reserved0[6];	/*	00h | Reserved */
+	__le32	IOAR[2];	/*	18h | IOA->host interrupt register */
 	__le32	IDR;		/*	20h | Inbound Doorbell Register */
 	__le32	IISR;		/*	24h | Inbound Int. Status Register */
 	__le32	reserved1[3];	/*	28h | Reserved */
@@ -767,17 +819,18 @@ struct src_mu_registers {
 	__le32	OMR;		/*	bch | Outbound Message Register */
 	__le32	IQ_L;		/*  c0h | Inbound Queue (Low address) */
 	__le32	IQ_H;		/*  c4h | Inbound Queue (High address) */
+	__le32	ODR_MSI;	/*  c8h | MSI register for sync./AIF */
 };
 
 struct src_registers {
-	struct src_mu_registers MUnit;	/* 00h - c7h */
+	struct src_mu_registers MUnit;	/* 00h - cbh */
 	union {
 		struct {
-			__le32 reserved1[130790];	/* c8h - 7fc5fh */
+			__le32 reserved1[130789];	/* cch - 7fc5fh */
 			struct src_inbound IndexRegs;	/* 7fc60h */
 		} tupelo;
 		struct {
-			__le32 reserved1[974];		/* c8h - fffh */
+			__le32 reserved1[973];		/* cch - fffh */
 			struct src_inbound IndexRegs;	/* 1000h */
 		} denali;
 	} u;
@@ -1028,6 +1081,11 @@ struct aac_bus_info_response {
 #define AAC_OPT_NEW_COMM_TYPE3		cpu_to_le32(1<<30)
 #define AAC_OPT_NEW_COMM_TYPE4		cpu_to_le32(1<<31)
 
+/* MSIX context */
+struct aac_msix_ctx {
+	int		vector_no;
+	struct aac_dev	*dev;
+};
 
 struct aac_dev
 {
@@ -1083,8 +1141,9 @@ struct aac_dev
 						 * if AAC_COMM_MESSAGE_TYPE1 */
 
 	dma_addr_t		host_rrq_pa;	/* phys. address */
-	u32			host_rrq_idx;	/* index into rrq buffer */
-
+	u32			host_rrq_idx[AAC_MAX_MSIX];	/* index into rrq buffer */
+	atomic_t		rrq_outstanding[AAC_MAX_MSIX];
+	u32			fibs_pushed_no;
 	struct pci_dev		*pdev;		/* Our PCI interface */
 	void *			printfbuf;	/* pointer to buffer used for printf's from the adapter */
 	void *			comm_addr;	/* Base address of Comm area */
@@ -1153,6 +1212,11 @@ struct aac_dev
 	int			sync_mode;
 	struct fib		*sync_fib;
 	struct list_head	sync_fib_list;
+	u32			max_msix;	/* max. MSI-X vectors */
+	u32			vector_cap;	/* MSI-X vector capab.*/
+	int			msi_enabled;	/* MSI/MSI-X enabled */
+	struct msix_entry	msixentry[AAC_MAX_MSIX];
+	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
 };
 
 #define aac_adapter_interrupt(dev) \
@@ -2035,6 +2099,7 @@ void aac_consumer_free(struct aac_dev * dev, struct aac_queue * q, u32 qnum);
 int aac_fib_complete(struct fib * context);
 #define fib_data(fibctx) ((void *)(fibctx)->hw_fib_va->data)
 struct aac_dev *aac_init_adapter(struct aac_dev *dev);
+void aac_src_access_devreg(struct aac_dev *dev, int mode);
 int aac_get_config_status(struct aac_dev *dev, int commit_flag);
 int aac_get_containers(struct aac_dev *dev);
 int aac_scsi_cmd(struct scsi_cmnd *cmd);
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 177b094..29c35c8 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -43,6 +43,8 @@
 
 #include "aacraid.h"
 
+static void aac_define_int_mode(struct aac_dev *dev);
+
 struct aac_common aac_config = {
 	.irq_mod = 1
 };
@@ -91,7 +93,7 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 	init->InitStructRevision = cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION);
 	if (dev->max_fib_size != sizeof(struct hw_fib))
 		init->InitStructRevision = cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_4);
-	init->MiniPortRevision = cpu_to_le32(Sa_MINIPORT_REVISION);
+	init->NoOfMSIXVectors = cpu_to_le32(Sa_MINIPORT_REVISION);
 	init->fsrev = cpu_to_le32(dev->fsrev);
 
 	/*
@@ -140,7 +142,7 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 			INITFLAGS_NEW_COMM_TYPE2_SUPPORTED | INITFLAGS_FAST_JBOD_SUPPORTED);
 		init->HostRRQ_AddrHigh = cpu_to_le32((u32)((u64)dev->host_rrq_pa >> 32));
 		init->HostRRQ_AddrLow = cpu_to_le32((u32)(dev->host_rrq_pa & 0xffffffff));
-		init->MiniPortRevision = cpu_to_le32(0L);		/* number of MSI-X */
+		init->NoOfMSIXVectors = cpu_to_le32(dev->max_msix);	/* number of MSI-X */
 		dprintk((KERN_WARNING"aacraid: New Comm Interface type2 enabled\n"));
 	}
 
@@ -228,6 +230,11 @@ int aac_send_shutdown(struct aac_dev * dev)
 	/* FIB should be freed only after getting the response from the F/W */
 	if (status != -ERESTARTSYS)
 		aac_fib_free(fibctx);
+	if ((dev->pdev->device == PMC_DEVICE_S7 ||
+	     dev->pdev->device == PMC_DEVICE_S8 ||
+	     dev->pdev->device == PMC_DEVICE_S9) &&
+	     dev->msi_enabled)
+		aac_src_access_devreg(dev, AAC_ENABLE_INTX);
 	return status;
 }
 
@@ -388,6 +395,8 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 			}
 		}
 	}
+	dev->max_msix = 0;
+	dev->msi_enabled = 0;
 	if ((!aac_adapter_sync_cmd(dev, GET_COMM_PREFERRED_SETTINGS,
 	  0, 0, 0, 0, 0, 0,
 	  status+0, status+1, status+2, status+3, status+4))
@@ -461,6 +470,11 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	if (host->can_queue > AAC_NUM_IO_FIB)
 		host->can_queue = AAC_NUM_IO_FIB;
 
+	if (dev->pdev->device == PMC_DEVICE_S6 ||
+	    dev->pdev->device == PMC_DEVICE_S7 ||
+	    dev->pdev->device == PMC_DEVICE_S8 ||
+	    dev->pdev->device == PMC_DEVICE_S9)
+		aac_define_int_mode(dev);
 	/*
 	 *	Ok now init the communication subsystem
 	 */
@@ -489,4 +503,70 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	return dev;
 }
 
-    
+static void aac_define_int_mode(struct aac_dev *dev)
+{
+
+	int i, msi_count;
+
+	/* max. vectors from GET_COMM_PREFERRED_SETTINGS */
+	if (dev->max_msix == 0 ||
+	    dev->pdev->device == PMC_DEVICE_S6 ||
+	    dev->sync_mode) {
+		dev->max_msix = 1;
+		dev->vector_cap = dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB;
+		return;
+	}
+
+	msi_count = min(dev->max_msix,
+		(unsigned int)num_online_cpus());
+
+	dev->max_msix = msi_count;
+
+	if (msi_count > AAC_MAX_MSIX)
+		msi_count = AAC_MAX_MSIX;
+
+	for (i = 0; i < msi_count; i++)
+		dev->msixentry[i].entry = i;
+
+	if (msi_count > 1 && pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
+
+		i = pci_enable_msix(dev->pdev, dev->msixentry, msi_count);
+		 /* Check how many MSIX vectors are allocated */
+		if (i >= 0) {
+			dev->msi_enabled = 1;
+			if (i) {
+				msi_count = i;
+				if (pci_enable_msix(dev->pdev, dev->msixentry, msi_count)) {
+					dev->msi_enabled = 0;
+					printk(KERN_ERR "%s%d: MSIX not supported!! Will try MSI 0x%x.\n",
+							dev->name, dev->id, i);
+				}
+			}
+		} else {
+			dev->msi_enabled = 0;
+			printk(KERN_ERR "%s%d: MSIX not supported!! Will try MSI 0x%x.\n",
+					dev->name, dev->id, i);
+		}
+	}
+
+	if (!dev->msi_enabled) {
+		msi_count = 1;
+		i = !pci_enable_msi(dev->pdev);
+
+		if (i) {
+			dev->msi_enabled = 1;
+			dev->msi = 1;
+		} else {
+			printk(KERN_ERR "%s%d: MSI not supported!! Will try INTx 0x%x.\n",
+					dev->name, dev->id, i);
+		}
+	}
+
+	if (!dev->msi_enabled)
+		dev->max_msix = msi_count = 1;
+	else {
+		if (dev->max_msix > msi_count)
+			dev->max_msix = msi_count;
+	}
+	dev->vector_cap = (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) / msi_count;
+}
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 090ba68..83c5d3f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -868,7 +868,7 @@ void aac_printf(struct aac_dev *dev, u32 val)
  *	dispatches it to the appropriate routine for handling.
  */
 
-#define AIF_SNIFF_TIMEOUT	(30*HZ)
+#define AIF_SNIFF_TIMEOUT	(500*HZ)
 static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 {
 	struct hw_fib * hw_fib = fibptr->hw_fib_va;
@@ -1251,7 +1251,7 @@ retry_next:
 static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 {
 	int index, quirks;
-	int retval;
+	int retval, i;
 	struct Scsi_Host *host;
 	struct scsi_device *dev;
 	struct scsi_cmnd *command;
@@ -1319,7 +1319,20 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 	aac->comm_phys = 0;
 	kfree(aac->queues);
 	aac->queues = NULL;
-	free_irq(aac->pdev->irq, aac);
+	if (aac->pdev->device == PMC_DEVICE_S6 ||
+	    aac->pdev->device == PMC_DEVICE_S7 ||
+	    aac->pdev->device == PMC_DEVICE_S8 ||
+	    aac->pdev->device == PMC_DEVICE_S9) {
+		if (aac->max_msix > 1) {
+			for (i = 0; i < aac->max_msix; i++)
+				free_irq(aac->msixentry[i].vector, &(aac->aac_msix[i]));
+			pci_disable_msix(aac->pdev);
+		} else {
+			free_irq(aac->pdev->irq, &(aac->aac_msix[0]));
+		}
+	} else {
+		free_irq(aac->pdev->irq, aac);
+	}
 	if (aac->msi)
 		pci_disable_msi(aac->pdev);
 	kfree(aac->fsa_dev);
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index d81b281..2e39466 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -389,8 +389,13 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 index,
 			 *	NOTE:  we cannot touch the fib after this
 			 *	    call, because it may have been deallocated.
 			 */
-			fib->flags &= FIB_CONTEXT_FLAG_FASTRESP;
-			fib->callback(fib->callback_data, fib);
+			if (likely(fib->callback && fib->callback_data)) {
+				fib->flags &= FIB_CONTEXT_FLAG_FASTRESP;
+				fib->callback(fib->callback_data, fib);
+			} else {
+				aac_fib_complete(fib);
+				aac_fib_free(fib);
+			}
 		} else {
 			unsigned long flagv;
 	  		dprintk((KERN_INFO "event_wait up\n"));
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index fdcdf9f..7813a9b 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1082,6 +1082,8 @@ static struct scsi_host_template aac_driver_template = {
 
 static void __aac_shutdown(struct aac_dev * aac)
 {
+	int i;
+
 	if (aac->aif_thread) {
 		int i;
 		/* Clear out events first */
@@ -1095,9 +1097,23 @@ static void __aac_shutdown(struct aac_dev * aac)
 	}
 	aac_send_shutdown(aac);
 	aac_adapter_disable_int(aac);
-	free_irq(aac->pdev->irq, aac);
+	if (aac->pdev->device == PMC_DEVICE_S6 ||
+	    aac->pdev->device == PMC_DEVICE_S7 ||
+	    aac->pdev->device == PMC_DEVICE_S8 ||
+	    aac->pdev->device == PMC_DEVICE_S9) {
+		if (aac->max_msix > 1) {
+			for (i = 0; i < aac->max_msix; i++)
+				free_irq(aac->msixentry[i].vector, &(aac->aac_msix[i]));
+		} else {
+			free_irq(aac->pdev->irq, &(aac->aac_msix[0]));
+		}
+	} else {
+		free_irq(aac->pdev->irq, aac);
+	}
 	if (aac->msi)
 		pci_disable_msi(aac->pdev);
+	else if (aac->max_msix > 1)
+		pci_disable_msix(aac->pdev);
 }
 
 static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 9c65aed..c010248 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -44,98 +44,124 @@
 
 #include "aacraid.h"
 
-static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
+static int aac_src_get_sync_status(struct aac_dev *dev);
+
+irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 {
-	struct aac_dev *dev = dev_id;
+	struct aac_msix_ctx *ctx;
+	struct aac_dev *dev;
 	unsigned long bellbits, bellbits_shifted;
-	int our_interrupt = 0;
-	int isFastResponse;
+	int vector_no;
+	int isFastResponse, mode;
 	u32 index, handle;
 
-	bellbits = src_readl(dev, MUnit.ODR_R);
-	if (bellbits & PmDoorBellResponseSent) {
-		bellbits = PmDoorBellResponseSent;
-		/* handle async. status */
-		src_writel(dev, MUnit.ODR_C, bellbits);
-		src_readl(dev, MUnit.ODR_C);
-		our_interrupt = 1;
-		index = dev->host_rrq_idx;
-		for (;;) {
-			isFastResponse = 0;
-			/* remove toggle bit (31) */
-			handle = le32_to_cpu(dev->host_rrq[index]) & 0x7fffffff;
-			/* check fast response bit (30) */
-			if (handle & 0x40000000)
-				isFastResponse = 1;
-			handle &= 0x0000ffff;
-			if (handle == 0)
-				break;
-
-			aac_intr_normal(dev, handle-1, 0, isFastResponse, NULL);
-
-			dev->host_rrq[index++] = 0;
-			if (index == dev->scsi_host_ptr->can_queue +
-						AAC_NUM_MGT_FIB)
-				index = 0;
-			dev->host_rrq_idx = index;
+	ctx = (struct aac_msix_ctx *)dev_id;
+	dev = ctx->dev;
+	vector_no = ctx->vector_no;
+
+	if (dev->msi_enabled) {
+		mode = AAC_INT_MODE_MSI;
+		if (vector_no == 0) {
+			bellbits = src_readl(dev, MUnit.ODR_MSI);
+			if (bellbits & 0x40000)
+				mode |= AAC_INT_MODE_AIF;
+			if (bellbits & 0x1000)
+				mode |= AAC_INT_MODE_SYNC;
 		}
 	} else {
-		bellbits_shifted = (bellbits >> SRC_ODR_SHIFT);
-		if (bellbits_shifted & DoorBellAifPending) {
+		mode = AAC_INT_MODE_INTX;
+		bellbits = src_readl(dev, MUnit.ODR_R);
+		if (bellbits & PmDoorBellResponseSent) {
+			bellbits = PmDoorBellResponseSent;
+			src_writel(dev, MUnit.ODR_C, bellbits);
+			src_readl(dev, MUnit.ODR_C);
+		} else {
+			bellbits_shifted = (bellbits >> SRC_ODR_SHIFT);
 			src_writel(dev, MUnit.ODR_C, bellbits);
 			src_readl(dev, MUnit.ODR_C);
-			our_interrupt = 1;
-			/* handle AIF */
-			aac_intr_normal(dev, 0, 2, 0, NULL);
-		} else if (bellbits_shifted & OUTBOUNDDOORBELL_0) {
-			unsigned long sflags;
-			struct list_head *entry;
-			int send_it = 0;
-			extern int aac_sync_mode;
 
+			if (bellbits_shifted & DoorBellAifPending)
+				mode |= AAC_INT_MODE_AIF;
+			else if (bellbits_shifted & OUTBOUNDDOORBELL_0)
+				mode |= AAC_INT_MODE_SYNC;
+		}
+	}
+
+	if (mode & AAC_INT_MODE_SYNC) {
+		unsigned long sflags;
+		struct list_head *entry;
+		int send_it = 0;
+		extern int aac_sync_mode;
+
+		if (!aac_sync_mode && !dev->msi_enabled) {
 			src_writel(dev, MUnit.ODR_C, bellbits);
 			src_readl(dev, MUnit.ODR_C);
+		}
 
-			if (!aac_sync_mode) {
-				src_writel(dev, MUnit.ODR_C, bellbits);
-				src_readl(dev, MUnit.ODR_C);
-				our_interrupt = 1;
+		if (dev->sync_fib) {
+			if (dev->sync_fib->callback)
+				dev->sync_fib->callback(dev->sync_fib->callback_data,
+					dev->sync_fib);
+			spin_lock_irqsave(&dev->sync_fib->event_lock, sflags);
+			if (dev->sync_fib->flags & FIB_CONTEXT_FLAG_WAIT) {
+				dev->management_fib_count--;
+				up(&dev->sync_fib->event_wait);
 			}
-
-			if (dev->sync_fib) {
-				our_interrupt = 1;
-				if (dev->sync_fib->callback)
-					dev->sync_fib->callback(dev->sync_fib->callback_data,
-						dev->sync_fib);
-				spin_lock_irqsave(&dev->sync_fib->event_lock, sflags);
-				if (dev->sync_fib->flags & FIB_CONTEXT_FLAG_WAIT) {
-					dev->management_fib_count--;
-					up(&dev->sync_fib->event_wait);
-				}
-				spin_unlock_irqrestore(&dev->sync_fib->event_lock, sflags);
-				spin_lock_irqsave(&dev->sync_lock, sflags);
-				if (!list_empty(&dev->sync_fib_list)) {
-					entry = dev->sync_fib_list.next;
-					dev->sync_fib = list_entry(entry, struct fib, fiblink);
-					list_del(entry);
-					send_it = 1;
-				} else {
-					dev->sync_fib = NULL;
-				}
-				spin_unlock_irqrestore(&dev->sync_lock, sflags);
-				if (send_it) {
-					aac_adapter_sync_cmd(dev, SEND_SYNCHRONOUS_FIB,
-						(u32)dev->sync_fib->hw_fib_pa, 0, 0, 0, 0, 0,
-						NULL, NULL, NULL, NULL, NULL);
-				}
+			spin_unlock_irqrestore(&dev->sync_fib->event_lock, sflags);
+			spin_lock_irqsave(&dev->sync_lock, sflags);
+			if (!list_empty(&dev->sync_fib_list)) {
+				entry = dev->sync_fib_list.next;
+				dev->sync_fib = list_entry(entry, struct fib, fiblink);
+				list_del(entry);
+				send_it = 1;
+			} else {
+				dev->sync_fib = NULL;
+			}
+			spin_unlock_irqrestore(&dev->sync_lock, sflags);
+			if (send_it) {
+				aac_adapter_sync_cmd(dev, SEND_SYNCHRONOUS_FIB,
+					(u32)dev->sync_fib->hw_fib_pa, 0, 0, 0, 0, 0,
+					NULL, NULL, NULL, NULL, NULL);
 			}
 		}
+		if (!dev->msi_enabled)
+			mode = 0;
+
 	}
 
-	if (our_interrupt) {
-		return IRQ_HANDLED;
+	if (mode & AAC_INT_MODE_AIF) {
+		/* handle AIF */
+		aac_intr_normal(dev, 0, 2, 0, NULL);
+		if (dev->msi_enabled)
+			aac_src_access_devreg(dev, AAC_CLEAR_AIF_BIT);
+		mode = 0;
 	}
-	return IRQ_NONE;
+
+	if (mode) {
+		index = dev->host_rrq_idx[vector_no];
+
+		for (;;) {
+			isFastResponse = 0;
+			/* remove toggle bit (31) */
+			handle = (dev->host_rrq[index] & 0x7fffffff);
+			/* check fast response bit (30) */
+			if (handle & 0x40000000)
+				isFastResponse = 1;
+			handle &= 0x0000ffff;
+			if (handle == 0)
+				break;
+			if (dev->msi_enabled && dev->max_msix > 1)
+				atomic_dec(&dev->rrq_outstanding[vector_no]);
+			aac_intr_normal(dev, handle-1, 0, isFastResponse, NULL);
+			dev->host_rrq[index++] = 0;
+			if (index == (vector_no + 1) * dev->vector_cap)
+				index = vector_no * dev->vector_cap;
+			dev->host_rrq_idx[vector_no] = index;
+		}
+		mode = 0;
+	}
+
+	return IRQ_HANDLED;
 }
 
 /**
@@ -155,7 +181,7 @@ static void aac_src_disable_interrupt(struct aac_dev *dev)
 
 static void aac_src_enable_interrupt_message(struct aac_dev *dev)
 {
-	src_writel(dev, MUnit.OIMR, dev->OIMR = 0xfffffff8);
+	aac_src_access_devreg(dev, AAC_ENABLE_INTERRUPT);
 }
 
 /**
@@ -191,7 +217,8 @@ static int src_sync_cmd(struct aac_dev *dev, u32 command,
 	/*
 	 *	Clear the synch command doorbell to start on a clean slate.
 	 */
-	src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
+	if (!dev->msi_enabled)
+		src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
 
 	/*
 	 *	Disable doorbell interrupts
@@ -221,11 +248,14 @@ static int src_sync_cmd(struct aac_dev *dev, u32 command,
 			/*
 			 *	Mon960 will set doorbell0 bit when it has completed the command.
 			 */
-			if ((src_readl(dev, MUnit.ODR_R) >> SRC_ODR_SHIFT) & OUTBOUNDDOORBELL_0) {
+			if (aac_src_get_sync_status(dev) & OUTBOUNDDOORBELL_0) {
 				/*
 				 *	Clear the doorbell.
 				 */
-				src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
+				if (dev->msi_enabled)
+					aac_src_access_devreg(dev, AAC_CLEAR_SYNC_BIT);
+				else
+					src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
 				ok = 1;
 				break;
 			}
@@ -254,11 +284,13 @@ static int src_sync_cmd(struct aac_dev *dev, u32 command,
 			*r3 = readl(&dev->IndexRegs->Mailbox[3]);
 		if (r4)
 			*r4 = readl(&dev->IndexRegs->Mailbox[4]);
-
+		if (command == GET_COMM_PREFERRED_SETTINGS)
+			dev->max_msix = readl(&dev->IndexRegs->Mailbox[5]) & 0xFFFF;
 		/*
 		 *	Clear the synch command doorbell.
 		 */
-		src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
+		if (!dev->msi_enabled)
+			src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
 	}
 
 	/*
@@ -335,9 +367,14 @@ static void aac_src_notify_adapter(struct aac_dev *dev, u32 event)
 static void aac_src_start_adapter(struct aac_dev *dev)
 {
 	struct aac_init *init;
+	int i;
 
 	 /* reset host_rrq_idx first */
-	dev->host_rrq_idx = 0;
+	for (i = 0; i < dev->max_msix; i++) {
+		dev->host_rrq_idx[i] = i * dev->vector_cap;
+		atomic_set(&dev->rrq_outstanding[i], 0);
+	}
+	dev->fibs_pushed_no = 0;
 
 	init = dev->init;
 	init->HostElapsedSeconds = cpu_to_le32(get_seconds());
@@ -400,6 +437,33 @@ static int aac_src_deliver_message(struct fib *fib)
 	q->numpending++;
 	spin_unlock_irqrestore(q->lock, qflags);
 
+	if (dev->msi_enabled && fib->hw_fib_va->header.Command != AifRequest &&
+	    dev->max_msix > 1) {
+		u_int16_t vector_no, first_choice = 0xffff;
+
+		vector_no = dev->fibs_pushed_no % dev->max_msix;
+		do {
+			vector_no += 1;
+			if (vector_no == dev->max_msix)
+				vector_no = 1;
+			if (atomic_read(&dev->rrq_outstanding[vector_no]) <
+			    dev->vector_cap)
+				break;
+			if (0xffff == first_choice)
+				first_choice = vector_no;
+			else if (vector_no == first_choice)
+				break;
+		} while (1);
+		if (vector_no == first_choice)
+			vector_no = 0;
+		atomic_inc(&dev->rrq_outstanding[vector_no]);
+		if (dev->fibs_pushed_no == 0xffffffff)
+			dev->fibs_pushed_no = 0;
+		else
+			dev->fibs_pushed_no++;
+		fib->hw_fib_va->header.Handle += (vector_no << 16);
+	}
+
 	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) {
 		/* Calculate the amount to the fibsize bits */
 		fibsize = (hdr_size + 127) / 128 - 1;
@@ -502,10 +566,19 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled)
 			0, 0, 0, 0, 0, 0, &var, &reset_mask, NULL, NULL, NULL);
 			if (bled || (var != 0x00000001))
 				return -EINVAL;
+
+		if ((dev->pdev->device == PMC_DEVICE_S7 ||
+		    dev->pdev->device == PMC_DEVICE_S8 ||
+		    dev->pdev->device == PMC_DEVICE_S9) && dev->msi_enabled) {
+			aac_src_access_devreg(dev, AAC_ENABLE_INTX);
+			dev->msi_enabled = 0;
+			msleep(5000); /* Delay 5 seconds */
+		}
+
 		if (dev->supplement_adapter_info.SupportedOptions2 &
 			AAC_OPTION_DOORBELL_RESET) {
 			src_writel(dev, MUnit.IDR, reset_mask);
-			msleep(5000); /* Delay 5 seconds */
+			ssleep(45);
 		}
 	}
 
@@ -646,8 +719,11 @@ int aac_src_init(struct aac_dev *dev)
 
 	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
 
+	dev->aac_msix[0].vector_no = 0;
+	dev->aac_msix[0].dev = dev;
+
 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-			IRQF_SHARED, "aacraid", dev) < 0) {
+			IRQF_SHARED, "aacraid", &(dev->aac_msix[0]))  < 0) {
 
 		if (dev->msi)
 			pci_disable_msi(dev->pdev);
@@ -688,6 +764,7 @@ int aac_srcv_init(struct aac_dev *dev)
 	unsigned long status;
 	int restart = 0;
 	int instance = dev->id;
+	int i, j;
 	const char *name = dev->name;
 
 	dev->a_ops.adapter_ioremap = aac_srcv_ioremap;
@@ -802,14 +879,36 @@ int aac_srcv_init(struct aac_dev *dev)
 		goto error_iounmap;
 	if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE2)
 		goto error_iounmap;
-	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
-	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-		IRQF_SHARED, "aacraid", dev) < 0) {
-		if (dev->msi)
-			pci_disable_msi(dev->pdev);
-		printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
-			name, instance);
-		goto error_iounmap;
+	if (dev->msi_enabled)
+		aac_src_access_devreg(dev, AAC_ENABLE_MSIX);
+	if (!dev->sync_mode && dev->msi_enabled && dev->max_msix > 1) {
+		for (i = 0; i < dev->max_msix; i++) {
+			dev->aac_msix[i].vector_no = i;
+			dev->aac_msix[i].dev = dev;
+
+			if (request_irq(dev->msixentry[i].vector, dev->a_ops.adapter_intr,
+					0, "aacraid", &(dev->aac_msix[i]))) {
+				printk(KERN_ERR "%s%d: Failed to register IRQ for vector %d.\n",
+						name, instance, i);
+				for (j = 0 ; j < i ; j++)
+					free_irq(dev->msixentry[j].vector,
+						 &(dev->aac_msix[j]));
+				pci_disable_msix(dev->pdev);
+				goto error_iounmap;
+			}
+		}
+	} else {
+		dev->aac_msix[0].vector_no = 0;
+		dev->aac_msix[0].dev = dev;
+
+		if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
+				IRQF_SHARED, "aacraid", &(dev->aac_msix[0])) < 0) {
+			if (dev->msi)
+				pci_disable_msi(dev->pdev);
+			printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
+					name, instance);
+			goto error_iounmap;
+		}
 	}
 	dev->dbg_base = dev->base_start;
 	dev->dbg_base_mapped = dev->base;
@@ -831,3 +930,87 @@ error_iounmap:
 	return -1;
 }
 
+void aac_src_access_devreg(struct aac_dev *dev, int mode)
+{
+	u_int32_t val;
+
+	switch (mode) {
+	case AAC_ENABLE_INTERRUPT:
+		src_writel(dev, MUnit.OIMR, dev->OIMR = (dev->msi_enabled ? AAC_INT_ENABLE_TYPE1_MSIX :
+									    AAC_INT_ENABLE_TYPE1_INTX));
+		break;
+
+	case AAC_DISABLE_INTERRUPT:
+		src_writel(dev, MUnit.OIMR, dev->OIMR = AAC_INT_DISABLE_ALL);
+		break;
+
+	case AAC_ENABLE_MSIX:
+		/* set bit 6 */
+		val = src_readl(dev, MUnit.IDR);
+		val |= 0x40;
+		src_writel(dev,  MUnit.IDR, val);
+		src_readl(dev, MUnit.IDR);
+		/* unmask int. */
+		val = PMC_ALL_INTERRUPT_BITS;
+		src_writel(dev, MUnit.IOAR, val);
+		val = src_readl(dev, MUnit.OIMR);
+		src_writel(dev, MUnit.OIMR,
+				val & (~(PMC_GLOBAL_INT_BIT2 | PMC_GLOBAL_INT_BIT0)));
+		break;
+
+	case AAC_DISABLE_MSIX:
+		/* reset bit 6 */
+		val = src_readl(dev, MUnit.IDR);
+		val &= ~0x40;
+		src_writel(dev, MUnit.IDR, val);
+		src_readl(dev, MUnit.IDR);
+		break;
+
+	case AAC_CLEAR_AIF_BIT:
+		/* set bit 5 */
+		val = src_readl(dev, MUnit.IDR);
+		val |= 0x20;
+		src_writel(dev, MUnit.IDR, val);
+		src_readl(dev, MUnit.IDR);
+		break;
+
+	case AAC_CLEAR_SYNC_BIT:
+		/* set bit 4 */
+		val = src_readl(dev, MUnit.IDR);
+		val |= 0x10;
+		src_writel(dev, MUnit.IDR, val);
+		src_readl(dev, MUnit.IDR);
+		break;
+
+	case AAC_ENABLE_INTX:
+		/* set bit 7 */
+		val = src_readl(dev, MUnit.IDR);
+		val |= 0x80;
+		src_writel(dev, MUnit.IDR, val);
+		src_readl(dev, MUnit.IDR);
+		/* unmask int. */
+		val = PMC_ALL_INTERRUPT_BITS;
+		src_writel(dev, MUnit.IOAR, val);
+		src_readl(dev, MUnit.IOAR);
+		val = src_readl(dev, MUnit.OIMR);
+		src_writel(dev, MUnit.OIMR,
+				val & (~(PMC_GLOBAL_INT_BIT2)));
+		break;
+
+	default:
+		break;
+	}
+}
+
+static int aac_src_get_sync_status(struct aac_dev *dev)
+{
+
+	int val;
+
+	if (dev->msi_enabled)
+		val = src_readl(dev, MUnit.ODR_MSI) & 0x1000 ? 1 : 0;
+	else
+		val = src_readl(dev, MUnit.ODR_R) >> SRC_ODR_SHIFT;
+
+	return val;
+}
-- 
1.7.7.3

