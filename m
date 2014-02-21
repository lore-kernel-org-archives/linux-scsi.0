From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: [PATCH v1.3 11/11] arcmsr: Adding support Areca ARC1214/1224/1264/1284
 SATA 6Gb raid controllers
Date: Fri, 21 Feb 2014 12:40:40 +0800
Message-ID: <CAKiknE-7TOGtN01xsXyay2gv69ruVvAEq22ozu=vTzh_R=SxuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:53815 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaBUEkm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 23:40:42 -0500
Received: by mail-lb0-f182.google.com with SMTP id w7so2012245lbi.27
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2014 20:40:41 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Cc: fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>, =?UTF-8?B?5ZCz56Kn5ra8?= <billion.wu@areca.com.tw>

From: Ching <ching2048@areca.com.tw>

Adding support Areca ARC1214/1224/1264/1284 SATA 6Gb raid controllers.

Singed-off-by: Ching <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h      2014-02-20 20:14:42.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h      2014-02-20 20:01:46.000000000 +0800
@@ -62,12 +62,17 @@ struct device_attribute;
 #define ARCMSR_MAX_QBUFFER             4096
 #define ARCMSR_DEFAULT_SG_ENTRIES      38
 #define ARCMSR_MAX_HBB_POSTQUEUE       264
+#define ARCMSR_MAX_ARC1214_POSTQUEUE   256
+#define ARCMSR_MAX_ARC1214_DONEQUEUE   257
 #define ARCMSR_MAX_XFER_LEN            0x26000
 #define ARCMSR_CDB_SG_PAGE_LENGTH      256
 #define ARCMST_NUM_MSIX_VECTORS                4
 #ifndef PCI_DEVICE_ID_ARECA_1880
        #define PCI_DEVICE_ID_ARECA_1880        0x1880
 #endif
+#ifndef PCI_DEVICE_ID_ARECA_1214
+       #define PCI_DEVICE_ID_ARECA_1214        0x1214
+#endif
 /*
 **********************************************************************************
 **
@@ -341,6 +346,56 @@ struct FIRMWARE_INFO
 #define ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK               0x80000000
 /*
 *******************************************************************************
+**                SPEC. for Areca Type D adapter
+*******************************************************************************
+*/
+#define ARCMSR_ARC1214_CHIP_ID                         0x00004
+#define ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION                0x00008
+#define ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK          0x00034
+#define ARCMSR_ARC1214_SAMPLE_RESET                    0x00100
+#define ARCMSR_ARC1214_RESET_REQUEST                   0x00108
+#define ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS           0x00200
+#define ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE                0x0020C
+#define ARCMSR_ARC1214_INBOUND_MESSAGE0                        0x00400
+#define ARCMSR_ARC1214_INBOUND_MESSAGE1                        0x00404
+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE0               0x00420
+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE1               0x00424
+#define ARCMSR_ARC1214_INBOUND_DOORBELL                        0x00460
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL               0x00480
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE                0x00484
+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW           0x01000
+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH          0x01004
+#define ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER      0x01018
+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW          0x01060
+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH         0x01064
+#define ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER      0x0106C
+#define ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER      0x01070
+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE                0x01088
+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE       0x0108C
+#define ARCMSR_ARC1214_MESSAGE_WBUFFER                 0x02000
+#define ARCMSR_ARC1214_MESSAGE_RBUFFER                 0x02100
+#define ARCMSR_ARC1214_MESSAGE_RWBUFFER                        0x02200
+/* Host Interrupt Mask */
+#define ARCMSR_ARC1214_ALL_INT_ENABLE                  0x00001010
+#define ARCMSR_ARC1214_ALL_INT_DISABLE                 0x00000000
+/* Host Interrupt Status */
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR           0x00001000
+#define ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR          0x00000010
+/* DoorBell*/
+#define ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY           0x00000001
+#define ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ           0x00000002
+/*inbound message 0 ready*/
+#define ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK           0x00000001
+/*outbound DATA WRITE isr door bell clear*/
+#define ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK            0x00000002
+/*outbound message 0 ready*/
+#define ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE                0x02000000
+/*outbound message cmd isr door bell clear*/
+/*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/
+#define ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK             0x80000000
+#define ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR   0x00000001
+/*
+*******************************************************************************
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)
 *******************************************************************************
 */
@@ -501,6 +556,55 @@ struct MessageUnit_C {
        uint32_t msgcode_rwbuffer[256];                 /*2200 23FF*/
 };
 /*
+*********************************************************************
+**     Messaging Unit (MU) of Type D processor
+*********************************************************************
+*/
+struct InBound_SRB {
+       uint32_t addressLow; /* pointer to SRB block */
+       uint32_t addressHigh;
+       uint32_t length; /* in DWORDs */
+       uint32_t reserved0;
+};
+
+struct OutBound_SRB {
+       uint32_t addressLow; /* pointer to SRB block */
+       uint32_t addressHigh;
+};
+
+struct MessageUnit_D {
+       struct InBound_SRB      post_qbuffer[ARCMSR_MAX_ARC1214_POSTQUEUE];
+       volatile struct OutBound_SRB
done_qbuffer[ARCMSR_MAX_ARC1214_DONEQUEUE];
+       u16 postq_index;
+       volatile u16 doneq_index;
+       u32 __iomem *chip_id;                   /* 0x00004 */
+       u32 __iomem *cpu_mem_config;            /* 0x00008 */
+       u32 __iomem *i2o_host_interrupt_mask;   /* 0x00034 */
+       u32 __iomem *sample_at_reset;           /* 0x00100 */
+       u32 __iomem *reset_request;             /* 0x00108 */
+       u32 __iomem *host_int_status;           /* 0x00200 */
+       u32 __iomem *pcief0_int_enable;         /* 0x0020C */
+       u32 __iomem *inbound_msgaddr0;          /* 0x00400 */
+       u32 __iomem *inbound_msgaddr1;          /* 0x00404 */
+       u32 __iomem *outbound_msgaddr0;         /* 0x00420 */
+       u32 __iomem *outbound_msgaddr1;         /* 0x00424 */
+       u32 __iomem *inbound_doorbell;          /* 0x00460 */
+       u32 __iomem *outbound_doorbell;         /* 0x00480 */
+       u32 __iomem *outbound_doorbell_enable;  /* 0x00484 */
+       u32 __iomem *inboundlist_base_low;      /* 0x01000 */
+       u32 __iomem *inboundlist_base_high;     /* 0x01004 */
+       u32 __iomem *inboundlist_write_pointer; /* 0x01018 */
+       u32 __iomem *outboundlist_base_low;     /* 0x01060 */
+       u32 __iomem *outboundlist_base_high;    /* 0x01064 */
+       u32 __iomem *outboundlist_copy_pointer; /* 0x0106C */
+       u32 __iomem *outboundlist_read_pointer; /* 0x01070 0x01072 */
+       u32 __iomem *outboundlist_interrupt_cause;      /* 0x1088 */
+       u32 __iomem *outboundlist_interrupt_enable;     /* 0x108C */
+       u32 __iomem *message_wbuffer;           /* 0x2000 */
+       u32 __iomem *message_rbuffer;           /* 0x2100 */
+       u32 __iomem *msgcode_rwbuffer;          /* 0x2200 */
+};
+/*
 *******************************************************************************
 **                 Adapter Control Block
 *******************************************************************************
@@ -522,12 +626,15 @@ struct AdapterControlBlock
        uint32_t        cdb_phyaddr_hi32;
        spinlock_t      eh_lock;
        spinlock_t      ccblist_lock;
+       spinlock_t      postq_lock;
+       spinlock_t      doneq_lock;
        spinlock_t      rqbuffer_lock;
        spinlock_t      wqbuffer_lock;
        union {
                struct MessageUnit_A __iomem    *pmuA;
                struct MessageUnit_B            *pmuB;
                struct MessageUnit_C __iomem    *pmuC;
+               struct MessageUnit_D            *pmuD;
        };
        /* message unit ATU inbound base address0 */
        void __iomem    *mem_base0;
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-20 19:11:05.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 01:47:26.000000000 +0800
@@ -102,6 +102,7 @@ static void arcmsr_message_isr_bh_fn(str
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);
+static void arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);

@@ -144,6 +145,7 @@ static struct pci_device_id arcmsr_devic
        {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1201)},
        {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1202)},
        {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210)},
+       {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1214)},
        {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1220)},
        {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1230)},
        {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1260)},
@@ -174,7 +176,8 @@ static struct pci_driver arcmsr_pci_driv
 static void arcmsr_free_mu(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
-       case ACB_ADAPTER_TYPE_B: {
+       case ACB_ADAPTER_TYPE_B:
+       case ACB_ADAPTER_TYPE_D: {
                dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
                        acb->dma_coherent2, acb->dma_coherent_handle2);
                break;
@@ -234,6 +237,25 @@ static bool arcmsr_remap_pciregion(struc
                }
                break;
        }
+       case ACB_ADAPTER_TYPE_D: {
+               void __iomem *mem_base0;
+               unsigned long addr, range, flags;
+
+               addr = (unsigned long)pci_resource_start(pdev, 0);
+               range = pci_resource_len(pdev, 0);
+               flags = pci_resource_flags(pdev, 0);
+               if (flags & IORESOURCE_CACHEABLE)
+                       mem_base0 = ioremap(addr, range);
+               else
+                       mem_base0 = ioremap_nocache(addr, range);
+               if (!mem_base0) {
+                       pr_notice("arcmsr%d: memory mapping region fail\n",
+                               acb->host->host_no);
+                       return false;
+               }
+               acb->mem_base0 = mem_base0;
+               break;
+               }
        }
        return true;
 }
@@ -251,6 +273,9 @@ static void arcmsr_unmap_pciregion(struc
        case ACB_ADAPTER_TYPE_C:
                iounmap(acb->pmuC);
                break;
+       case ACB_ADAPTER_TYPE_D:
+               iounmap(acb->mem_base0);
+               break;
        }
 }

@@ -300,6 +325,9 @@ arcmsr_define_adapter_type(struct Adapte
        pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
        acb->dev_id = dev_id;
        switch (dev_id) {
+       case 0x1214:
+               acb->adapter_type = ACB_ADAPTER_TYPE_D;
+               break;
        case 0x1880:
                acb->adapter_type = ACB_ADAPTER_TYPE_C;
                break;
@@ -387,6 +415,24 @@ arcmsr_hbaC_wait_msgint_ready(struct Ada
        return false;
 }

+static bool
+arcmsr_hbaD_wait_msgint_ready(struct AdapterControlBlock *pACB)
+{
+       struct MessageUnit_D *reg = pACB->pmuD;
+       int i;
+
+       for (i = 0; i < 2000; i++) {
+               if (readl(reg->outbound_doorbell)
+                       & ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {
+                       writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,
+                               reg->outbound_doorbell);
+                       return true;
+               }
+               msleep(10);
+       } /* max 20 seconds */
+       return false;
+}
+
 static void
 arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb)
 {
@@ -448,6 +494,25 @@ arcmsr_hbaC_flush_cache(struct AdapterCo
 }

 static void
+arcmsr_hbaD_flush_cache(struct AdapterControlBlock *pACB)
+{
+       int retry_count = 6;
+       struct MessageUnit_D *reg = pACB->pmuD;
+
+       writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, reg->inbound_msgaddr0);
+       do {
+               if (arcmsr_hbaD_wait_msgint_ready(pACB))
+                       break;
+               else {
+                       retry_count--;
+                       pr_notice("arcmsr%d: wait 'flush adapter "
+                               "cache' timeout, retry count down = %d\n",
+                               pACB->host->host_no, retry_count);
+               }
+       } while (retry_count != 0);
+}
+
+static void
 arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
@@ -460,6 +525,9 @@ arcmsr_flush_adapter_cache(struct Adapte
        case ACB_ADAPTER_TYPE_C:
                arcmsr_hbaC_flush_cache(acb);
                break;
+       case ACB_ADAPTER_TYPE_D:
+               arcmsr_hbaD_flush_cache(acb);
+               break;
        }
 }

@@ -512,6 +580,7 @@ arcmsr_alloc_ccb_pool(struct AdapterCont
                        ccb_tmp->cdb_phyaddr = cdb_phyaddr >> 5;
                        break;
                case ACB_ADAPTER_TYPE_C:
+               case ACB_ADAPTER_TYPE_D:
                        ccb_tmp->cdb_phyaddr = cdb_phyaddr;
                        break;
                }
@@ -560,6 +629,12 @@ arcmsr_message_isr_bh_fn(struct work_str
                devicemap = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
                break;
                }
+       case ACB_ADAPTER_TYPE_D: {
+               struct MessageUnit_D *reg  = acb->pmuD;
+               signature = (uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);
+               devicemap = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
+               break;
+               }
        }
        atomic_inc(&acb->rq_map_token);
        if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
@@ -756,6 +831,8 @@ static int arcmsr_probe(struct pci_dev *
                goto scsi_host_release;
        spin_lock_init(&acb->eh_lock);
        spin_lock_init(&acb->ccblist_lock);
+       spin_lock_init(&acb->postq_lock);
+       spin_lock_init(&acb->doneq_lock);
        spin_lock_init(&acb->rqbuffer_lock);
        spin_lock_init(&acb->wqbuffer_lock);
        acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
@@ -899,6 +976,20 @@ arcmsr_hbaC_abort_allcmd(struct AdapterC
 }

 static uint8_t
+arcmsr_hbaD_abort_allcmd(struct AdapterControlBlock *pACB)
+{
+       struct MessageUnit_D *reg = pACB->pmuD;
+
+       writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, reg->inbound_msgaddr0);
+       if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {
+               pr_notice("arcmsr%d: wait 'abort all outstanding "
+                       "command' timeout\n", pACB->host->host_no);
+               return false;
+       }
+       return true;
+}
+
+static uint8_t
 arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
 {
        uint8_t rtnval = 0;
@@ -915,6 +1006,10 @@ arcmsr_abort_allcmd(struct AdapterContro
        case ACB_ADAPTER_TYPE_C:
                rtnval = arcmsr_hbaC_abort_allcmd(acb);
                break;
+
+       case ACB_ADAPTER_TYPE_D:
+               rtnval = arcmsr_hbaD_abort_allcmd(acb);
+               break;
        }
        return rtnval;
 }
@@ -992,6 +1087,12 @@ arcmsr_disable_outbound_ints(struct Adap
                readl(&reg->host_int_mask);
                }
                break;
+       case ACB_ADAPTER_TYPE_D: {
+               struct MessageUnit_D *reg = acb->pmuD;
+               /* disable all outbound interrupt */
+               writel(ARCMSR_ARC1214_ALL_INT_DISABLE, reg->pcief0_int_enable);
+               }
+               break;
        }
        return orig_mask;
 }
@@ -1144,6 +1245,58 @@ arcmsr_done4abort_postqueue(struct Adapt
                }
                }
                break;
+       case ACB_ADAPTER_TYPE_D: {
+               struct MessageUnit_D  *pmu = acb->pmuD;
+               uint32_t ccb_cdb_phy, outbound_write_pointer;
+               uint32_t doneq_index, index_stripped, addressLow, residual;
+               bool error;
+               struct CommandControlBlock *pCCB;
+               outbound_write_pointer = pmu->done_qbuffer[0].addressLow + 1;
+               doneq_index = pmu->doneq_index;
+               residual = atomic_read(&acb->ccboutstandingcount);
+               for (i = 0; i < residual; i++) {
+                       while ((doneq_index & 0xFFF) !=
+                               (outbound_write_pointer & 0xFFF)) {
+                               if (doneq_index & 0x4000) {
+                                       index_stripped = doneq_index & 0xFFF;
+                                       index_stripped += 1;
+                                       index_stripped %=
+                                               ARCMSR_MAX_ARC1214_DONEQUEUE;
+                                       pmu->doneq_index = index_stripped ?
+                                               (index_stripped | 0x4000) :
+                                               (index_stripped + 1);
+                               } else {
+                                       index_stripped = doneq_index;
+                                       index_stripped += 1;
+                                       index_stripped %=
+                                               ARCMSR_MAX_ARC1214_DONEQUEUE;
+                                       pmu->doneq_index = index_stripped ?
+                                               index_stripped :
+                                               ((index_stripped | 0x4000) + 1);
+                               }
+                               doneq_index = pmu->doneq_index;
+                               addressLow = pmu->done_qbuffer[doneq_index &
+                                       0xFFF].addressLow;
+                               ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
+                               pARCMSR_CDB = (struct  ARCMSR_CDB *)
+                                       (acb->vir2phy_offset + ccb_cdb_phy);
+                               pCCB = container_of(pARCMSR_CDB,
+                                       struct CommandControlBlock, arcmsr_cdb);
+                               error = (addressLow &
+                                       ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ?
+                                       true : false;
+                               arcmsr_drain_donequeue(acb, pCCB, error);
+                               writel(doneq_index,
pmu->outboundlist_read_pointer);
+                       }
+                       mdelay(10);
+                       outbound_write_pointer =
+                               pmu->done_qbuffer[0].addressLow + 1;
+                       doneq_index = pmu->doneq_index;
+               }
+               pmu->postq_index = 0;
+               pmu->doneq_index = 0x40FF;
+               }
+               break;
        }
 }

@@ -1277,6 +1430,12 @@ arcmsr_enable_outbound_ints(struct Adapt
                acb->outbound_int_enable = ~(intmask_org & mask) & 0x0000000f;
                break;
                }
+       case ACB_ADAPTER_TYPE_D: {
+               struct MessageUnit_D *reg = acb->pmuD;
+               mask = ARCMSR_ARC1214_ALL_INT_ENABLE;
+               writel(intmask_org | mask, reg->pcief0_int_enable);
+               break;
+               }
        }
 }

@@ -1387,6 +1546,36 @@ arcmsr_post_ccb(struct AdapterControlBlo
                                &phbcmu->inbound_queueport_low);
                }
                break;
+       case ACB_ADAPTER_TYPE_D: {
+               struct MessageUnit_D  *pmu = acb->pmuD;
+               u16 index_stripped;
+               u16 postq_index;
+               unsigned long flags;
+               struct InBound_SRB *pinbound_srb;
+               spin_lock_irqsave(&acb->postq_lock, flags);
+               postq_index = pmu->postq_index;
+               pinbound_srb = (struct InBound_SRB
*)&(pmu->post_qbuffer[postq_index & 0xFF]);
+               pinbound_srb->addressHigh = dma_addr_hi32(cdb_phyaddr);
+               pinbound_srb->addressLow = dma_addr_lo32(cdb_phyaddr);
+               pinbound_srb->length = ccb->arc_cdb_size >> 2;
+               arcmsr_cdb->msgContext = dma_addr_lo32(cdb_phyaddr);
+               if (postq_index & 0x4000) {
+                       index_stripped = postq_index & 0xFF;
+                       index_stripped += 1;
+                       index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
+                       pmu->postq_index = index_stripped ?
+                               (index_stripped | 0x4000) : index_stripped;
+               } else {
+                       index_stripped = postq_index;
+                       index_stripped += 1;
+                       index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
+                       pmu->postq_index = index_stripped ? index_stripped :
+                               (index_stripped | 0x4000);
+               }
+               writel(postq_index, pmu->inboundlist_write_pointer);
+               spin_unlock_irqrestore(&acb->postq_lock, flags);
+               break;
+       }
        }
 }

@@ -1428,6 +1617,18 @@ arcmsr_hbaC_stop_bgrb(struct AdapterCont
 }

 static void
+arcmsr_hbaD_stop_bgrb(struct AdapterControlBlock *pACB)
+{
+       struct MessageUnit_D *reg = pACB->pmuD;
+
+       pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
+       writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, reg->inbound_msgaddr0);
+       if (!arcmsr_hbaD_wait_msgint_ready(pACB))
+               pr_notice("arcmsr%d: wait 'stop adapter background rebulid' "
+                       "timeout\n", pACB->host->host_no);
+}
+
+static void
 arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
@@ -1440,6 +1641,9 @@ arcmsr_stop_adapter_bgrb(struct AdapterC
        case ACB_ADAPTER_TYPE_C:
                arcmsr_hbaC_stop_bgrb(acb);
                break;
+       case ACB_ADAPTER_TYPE_D:
+               arcmsr_hbaD_stop_bgrb(acb);
+               break;
        }
 }

@@ -1471,6 +1675,12 @@ arcmsr_iop_message_read(struct AdapterCo
                        &reg->inbound_doorbell);
                }
                break;
+       case ACB_ADAPTER_TYPE_D: {
+               struct MessageUnit_D *reg = acb->pmuD;
+               writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,
+                       reg->inbound_doorbell);
+               }
+               break;
        }
 }

@@ -1507,6 +1717,12 @@ arcmsr_iop_message_wrote(struct AdapterC
                        &reg->inbound_doorbell);
                }
                break;
+       case ACB_ADAPTER_TYPE_D: {
+               struct MessageUnit_D *reg = acb->pmuD;
+               writel(ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY,
+                       reg->inbound_doorbell);
+               }
+               break;
        }
 }

@@ -1531,6 +1747,11 @@ struct QBUFFER __iomem
                qbuffer = (struct QBUFFER __iomem *)&reg->message_rbuffer;
                }
                break;
+       case ACB_ADAPTER_TYPE_D: {
+               struct MessageUnit_D *reg = acb->pmuD;
+               qbuffer = (struct QBUFFER __iomem *)reg->message_rbuffer;
+               }
+               break;
        }
        return qbuffer;
 }
@@ -1556,6 +1777,11 @@ static struct QBUFFER __iomem
                pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;
                }
                break;
+       case ACB_ADAPTER_TYPE_D: {
+               struct MessageUnit_D *reg = acb->pmuD;
+               pqbuffer = (struct QBUFFER __iomem *)reg->message_wbuffer;
+               }
+               break;
        }
        return pqbuffer;
 }
@@ -1610,7 +1836,7 @@ arcmsr_Read_iop_rqbuffer_data(struct Ada
        uint8_t __iomem *iop_data;
        uint32_t iop_len;

-       if (acb->adapter_type & ACB_ADAPTER_TYPE_C)
+       if (acb->adapter_type & (ACB_ADAPTER_TYPE_C | ACB_ADAPTER_TYPE_D))
                return arcmsr_Read_iop_rqbuffer_in_DWORD(acb, prbuffer);
        iop_data = (uint8_t __iomem *)prbuffer->data;
        iop_len = readl(&prbuffer->data_len);
@@ -1698,7 +1924,7 @@ arcmsr_write_ioctldata2iop(struct Adapte
        uint8_t __iomem *iop_data;
        int32_t allxfer_len = 0;

-       if (acb->adapter_type & ACB_ADAPTER_TYPE_C) {
+       if (acb->adapter_type & (ACB_ADAPTER_TYPE_C | ACB_ADAPTER_TYPE_D)) {
                arcmsr_write_ioctldata2iop_in_DWORD(acb);
                return;
        }
@@ -1775,6 +2001,27 @@ arcmsr_hbaC_doorbell_isr(struct AdapterC
 }

 static void
+arcmsr_hbaD_doorbell_isr(struct AdapterControlBlock *pACB)
+{
+       uint32_t outbound_doorbell;
+       struct MessageUnit_D  *pmu = pACB->pmuD;
+
+       outbound_doorbell = readl(pmu->outbound_doorbell);
+       do {
+               writel(outbound_doorbell, pmu->outbound_doorbell);
+               if (outbound_doorbell & ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE)
+                       arcmsr_hbaD_message_isr(pACB);
+               if (outbound_doorbell & ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK)
+                       arcmsr_iop2drv_data_wrote_handle(pACB);
+               if (outbound_doorbell & ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK)
+                       arcmsr_iop2drv_data_read_handle(pACB);
+               outbound_doorbell = readl(pmu->outbound_doorbell);
+       } while (outbound_doorbell & (ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK
+               | ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK
+               | ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE));
+}
+
+static void
 arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)
 {
        uint32_t flag_ccb;
@@ -1855,6 +2102,59 @@ arcmsr_hbaC_postqueue_isr(struct Adapter
 }

 static void
+arcmsr_hbaD_postqueue_isr(struct AdapterControlBlock *acb)
+{
+       u32 outbound_write_pointer, doneq_index, index_stripped;
+       uint32_t addressLow, ccb_cdb_phy;
+       int error;
+       struct MessageUnit_D  *pmu;
+       struct ARCMSR_CDB *arcmsr_cdb;
+       struct CommandControlBlock *ccb;
+       unsigned long flags;
+
+       spin_lock_irqsave(&acb->doneq_lock, flags);
+       pmu = acb->pmuD;
+       outbound_write_pointer = pmu->done_qbuffer[0].addressLow + 1;
+       doneq_index = pmu->doneq_index;
+       if ((doneq_index & 0xFFF) != (outbound_write_pointer & 0xFFF)) {
+               do {
+                       if (doneq_index & 0x4000) {
+                               index_stripped = doneq_index & 0xFFF;
+                               index_stripped += 1;
+                               index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
+                               pmu->doneq_index = index_stripped
+                                       ? (index_stripped | 0x4000) :
+                                       (index_stripped + 1);
+                       } else {
+                               index_stripped = doneq_index;
+                               index_stripped += 1;
+                               index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
+                               pmu->doneq_index = index_stripped
+                                       ? index_stripped :
+                                       ((index_stripped | 0x4000) + 1);
+                       }
+                       doneq_index = pmu->doneq_index;
+                       addressLow = pmu->done_qbuffer[doneq_index &
+                               0xFFF].addressLow;
+                       ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
+                       arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
+                               + ccb_cdb_phy);
+                       ccb = container_of(arcmsr_cdb,
+                               struct CommandControlBlock, arcmsr_cdb);
+                       error = (addressLow & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+                               ? true : false;
+                       arcmsr_drain_donequeue(acb, ccb, error);
+                       writel(doneq_index, pmu->outboundlist_read_pointer);
+               } while ((doneq_index & 0xFFF) !=
+                       (outbound_write_pointer & 0xFFF));
+       }
+       writel(ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR,
+               pmu->outboundlist_interrupt_cause);
+       readl(pmu->outboundlist_interrupt_cause);
+       spin_unlock_irqrestore(&acb->doneq_lock, flags);
+}
+
+static void
 arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg  = acb->pmuA;
@@ -1885,6 +2185,16 @@ arcmsr_hbaC_message_isr(struct AdapterCo
        schedule_work(&acb->arcmsr_do_message_isr_bh);
 }

+static void
+arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb)
+{
+       struct MessageUnit_D *reg  = acb->pmuD;
+
+       writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE, reg->outbound_doorbell);
+       readl(reg->outbound_doorbell);
+       schedule_work(&acb->arcmsr_do_message_isr_bh);
+}
+
 static irqreturn_t
 arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)
 {
@@ -1965,6 +2275,32 @@ arcmsr_hbaC_handle_isr(struct AdapterCon
 }

 static irqreturn_t
+arcmsr_hbaD_handle_isr(struct AdapterControlBlock *pACB)
+{
+       u32 host_interrupt_status;
+       struct MessageUnit_D  *pmu = pACB->pmuD;
+
+       host_interrupt_status = readl(pmu->host_int_status) &
+               (ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR |
+               ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR);
+       if (!host_interrupt_status)
+               return IRQ_NONE;
+       do {
+               /* MU post queue interrupts*/
+               if (host_interrupt_status &
+                       ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR)
+                       arcmsr_hbaD_postqueue_isr(pACB);
+               if (host_interrupt_status &
+                       ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR)
+                       arcmsr_hbaD_doorbell_isr(pACB);
+               host_interrupt_status = readl(pmu->host_int_status);
+       } while (host_interrupt_status &
+               (ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR |
+               ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR));
+       return IRQ_HANDLED;
+}
+
+static irqreturn_t
 arcmsr_interrupt(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
@@ -1977,6 +2313,9 @@ arcmsr_interrupt(struct AdapterControlBl
        case ACB_ADAPTER_TYPE_C:
                return arcmsr_hbaC_handle_isr(acb);
                break;
+       case ACB_ADAPTER_TYPE_D:
+               return arcmsr_hbaD_handle_isr(acb);
+               break;
        default:
                return IRQ_NONE;
        }
@@ -2665,6 +3004,142 @@ arcmsr_hbaC_get_config(struct AdapterCon
 }

 static bool
+arcmsr_hbaD_get_config(struct AdapterControlBlock *acb)
+{
+       char *acb_firm_model = acb->firm_model;
+       char *acb_firm_version = acb->firm_version;
+       char *acb_device_map = acb->device_map;
+       char __iomem *iop_firm_model;
+       char __iomem *iop_firm_version;
+       char __iomem *iop_device_map;
+       u32 count;
+       struct MessageUnit_D *reg ;
+       void *dma_coherent2;
+       dma_addr_t dma_coherent_handle2;
+       struct pci_dev *pdev = acb->pdev;
+
+       acb->roundup_ccbsize = roundup(sizeof(struct MessageUnit_D), 32);
+       dma_coherent2 = dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsize,
+               &dma_coherent_handle2, GFP_KERNEL);
+       if (!dma_coherent2) {
+               pr_notice("DMA allocation failed...\n");
+               return false;
+       }
+       memset(dma_coherent2, 0, acb->roundup_ccbsize);
+       acb->dma_coherent_handle2 = dma_coherent_handle2;
+       acb->dma_coherent2 = dma_coherent2;
+       reg = (struct MessageUnit_D *)dma_coherent2;
+       acb->pmuD = reg;
+       reg->chip_id = (u32 __iomem *)((unsigned long)acb->mem_base0 +
+               ARCMSR_ARC1214_CHIP_ID);
+       reg->cpu_mem_config = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);
+       reg->i2o_host_interrupt_mask = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
+       reg->sample_at_reset = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_SAMPLE_RESET);
+       reg->reset_request = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_RESET_REQUEST);
+       reg->host_int_status = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);
+       reg->pcief0_int_enable = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);
+       reg->inbound_msgaddr0 = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_INBOUND_MESSAGE0);
+       reg->inbound_msgaddr1 = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_INBOUND_MESSAGE1);
+       reg->outbound_msgaddr0 = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_MESSAGE0);
+       reg->outbound_msgaddr1 = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_MESSAGE1);
+       reg->inbound_doorbell = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_INBOUND_DOORBELL);
+       reg->outbound_doorbell = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_DOORBELL);
+       reg->outbound_doorbell_enable = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);
+       reg->inboundlist_base_low = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);
+       reg->inboundlist_base_high = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);
+       reg->inboundlist_write_pointer = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);
+       reg->outboundlist_base_low = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);
+       reg->outboundlist_base_high = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);
+       reg->outboundlist_copy_pointer = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);
+       reg->outboundlist_read_pointer = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);
+       reg->outboundlist_interrupt_cause = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);
+       reg->outboundlist_interrupt_enable = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);
+       reg->message_wbuffer = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_WBUFFER);
+       reg->message_rbuffer = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_RBUFFER);
+       reg->msgcode_rwbuffer = (u32 __iomem *)((unsigned long)
+               acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_RWBUFFER);
+       iop_firm_model = (char __iomem *)(&reg->msgcode_rwbuffer[15]);
+       iop_firm_version = (char __iomem *)(&reg->msgcode_rwbuffer[17]);
+       iop_device_map = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
+       if (readl(acb->pmuD->outbound_doorbell) &
+               ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {
+               writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,
+                       acb->pmuD->outbound_doorbell);/*clear interrupt*/
+       }
+       /* post "get config" instruction */
+       writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, reg->inbound_msgaddr0);
+       /* wait message ready */
+       if (!arcmsr_hbaD_wait_msgint_ready(acb)) {
+               pr_notice("arcmsr%d: wait get adapter firmware "
+                       "miscellaneous data timeout\n", acb->host->host_no);
+               dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
+                       acb->dma_coherent2, acb->dma_coherent_handle2);
+               return false;
+       }
+       count = 8;
+       while (count) {
+               *acb_firm_model = readb(iop_firm_model);
+               acb_firm_model++;
+               iop_firm_model++;
+               count--;
+       }
+       count = 16;
+       while (count) {
+               *acb_firm_version = readb(iop_firm_version);
+               acb_firm_version++;
+               iop_firm_version++;
+               count--;
+       }
+       count = 16;
+       while (count) {
+               *acb_device_map = readb(iop_device_map);
+               acb_device_map++;
+               iop_device_map++;
+               count--;
+       }
+       acb->signature = readl(&reg->msgcode_rwbuffer[1]);
+       /*firm_signature,1,00-03*/
+       acb->firm_request_len = readl(&reg->msgcode_rwbuffer[2]);
+       /*firm_request_len,1,04-07*/
+       acb->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[3]);
+       /*firm_numbers_queue,2,08-11*/
+       acb->firm_sdram_size = readl(&reg->msgcode_rwbuffer[4]);
+       /*firm_sdram_size,3,12-15*/
+       acb->firm_hd_channels = readl(&reg->msgcode_rwbuffer[5]);
+       /*firm_hd_channels,4,16-19*/
+       acb->firm_cfg_version = readl(&reg->msgcode_rwbuffer[25]);
+       pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
+               acb->host->host_no,
+               acb->firm_model,
+               acb->firm_version);
+       return true;
+}
+
+static bool
 arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
        bool rtn = false;
@@ -2679,6 +3154,9 @@ arcmsr_get_firmware_spec(struct AdapterC
        case ACB_ADAPTER_TYPE_C:
                rtn = arcmsr_hbaC_get_config(acb);
                break;
+       case ACB_ADAPTER_TYPE_D:
+               rtn = arcmsr_hbaD_get_config(acb);
+               break;
        default:
                break;
        }
@@ -2894,6 +3372,89 @@ polling_hbc_ccb_retry:
 }

 static int
+arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
+                               struct CommandControlBlock *poll_ccb)
+{
+       bool error;
+       uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb, ccb_cdb_phy;
+       int rtn, doneq_index, index_stripped, outbound_write_pointer;
+       unsigned long flags;
+       struct ARCMSR_CDB *arcmsr_cdb;
+       struct CommandControlBlock *pCCB;
+       struct MessageUnit_D *pmu = acb->pmuD;
+
+       spin_lock_irqsave(&acb->doneq_lock, flags);
+polling_hbaD_ccb_retry:
+       poll_count++;
+       while (1) {
+               outbound_write_pointer = pmu->done_qbuffer[0].addressLow + 1;
+               doneq_index = pmu->doneq_index;
+               if ((outbound_write_pointer & 0xFFF) == (doneq_index & 0xFFF)) {
+                       if (poll_ccb_done) {
+                               rtn = SUCCESS;
+                               break;
+                       } else {
+                               msleep(25);
+                               if (poll_count > 100) {
+                                       rtn = FAILED;
+                                       break;
+                               }
+                               goto polling_hbaD_ccb_retry;
+                       }
+               }
+               if (doneq_index & 0x4000) {
+                       index_stripped = doneq_index & 0xFFF;
+                       index_stripped += 1;
+                       index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
+                       pmu->doneq_index = index_stripped ?
+                               (index_stripped | 0x4000) :
+                               (index_stripped + 1);
+               } else {
+                       index_stripped = doneq_index;
+                       index_stripped += 1;
+                       index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
+                       pmu->doneq_index = index_stripped ? index_stripped :
+                               ((index_stripped | 0x4000) + 1);
+               }
+               doneq_index = pmu->doneq_index;
+               flag_ccb = pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;
+               ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
+               arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
+                       ccb_cdb_phy);
+               pCCB = container_of(arcmsr_cdb, struct CommandControlBlock,
+                       arcmsr_cdb);
+               poll_ccb_done = (pCCB == poll_ccb) ? 1 : 0;
+               if ((pCCB->acb != acb) ||
+                       (pCCB->startdone != ARCMSR_CCB_START)) {
+                       if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
+                               pr_notice("arcmsr%d: scsi id = %d "
+                                       "lun = %d ccb = '0x%p' poll command "
+                                       "abort successfully\n"
+                                       , acb->host->host_no
+                                       , pCCB->pcmd->device->id
+                                       , pCCB->pcmd->device->lun
+                                       , pCCB);
+                               pCCB->pcmd->result = DID_ABORT << 16;
+                               arcmsr_ccb_complete(pCCB);
+                               continue;
+                       }
+                       pr_notice("arcmsr%d: polling an illegal "
+                               "ccb command done ccb = '0x%p' "
+                               "ccboutstandingcount = %d\n"
+                               , acb->host->host_no
+                               , pCCB
+                               , atomic_read(&acb->ccboutstandingcount));
+                       continue;
+               }
+               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+                       ? true : false;
+               arcmsr_report_ccb_state(acb, pCCB, error);
+       }
+       spin_unlock_irqrestore(&acb->doneq_lock, flags);
+       return rtn;
+}
+
+static int
 arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
                                struct CommandControlBlock *poll_ccb)
 {
@@ -2909,6 +3470,9 @@ arcmsr_polling_ccbdone(struct AdapterCon
        case ACB_ADAPTER_TYPE_C:
                rtn = arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);
                break;
+       case ACB_ADAPTER_TYPE_D:
+               rtn = arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);
+               break;
        }
        return rtn;
 }
@@ -2925,13 +3489,21 @@ arcmsr_iop_confirm(struct AdapterControl
        ** if freeccb.HighPart is not zero
        ********************************************************************
        */
-       dma_coherent_handle = acb->dma_coherent_handle;
+       switch (acb->adapter_type) {
+               case ACB_ADAPTER_TYPE_B:
+               case ACB_ADAPTER_TYPE_D:
+                       dma_coherent_handle = acb->dma_coherent_handle2;
+                       break;
+               default:
+                       dma_coherent_handle = acb->dma_coherent_handle;
+                       break;
+       }
        cdb_phyaddr_lo32 = (uint32_t)(dma_coherent_handle & 0xffffffff);
        cdb_phyaddr_hi32 = (uint32_t)((dma_coherent_handle >> 16) >> 16);
        acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;
        /*
        ***********************************************************************
-       ** if adapter type B set window of "post command Q"
+       ** if adapter type B or D, set window of "post command Q"
        ***********************************************************************
        */
        switch (acb->adapter_type) {
@@ -2953,7 +3525,6 @@ arcmsr_iop_confirm(struct AdapterControl
                }
                break;
        case ACB_ADAPTER_TYPE_B: {
-               unsigned long post_queue_phyaddr;
                uint32_t __iomem *rwbuffer;

                struct MessageUnit_B *reg = acb->pmuB;
@@ -2965,16 +3536,15 @@ arcmsr_iop_confirm(struct AdapterControl
                                acb->host->host_no);
                        return 1;
                }
-               post_queue_phyaddr = acb->dma_coherent_handle2;
                rwbuffer = reg->message_rwbuffer;
                /* driver "set config" signature */
                writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
                /* normal should be zero */
                writel(cdb_phyaddr_hi32, rwbuffer++);
                /* postQ size (256 + 8)*4        */
-               writel(post_queue_phyaddr, rwbuffer++);
+               writel(cdb_phyaddr_lo32, rwbuffer++);
                /* doneQ size (256 + 8)*4        */
-               writel(post_queue_phyaddr + 1056, rwbuffer++);
+               writel(cdb_phyaddr_lo32 + 1056, rwbuffer++);
                /* ccb maxQ size must be --> [(256 + 8)*4]*/
                writel(1056, rwbuffer);
                writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
@@ -3012,6 +3582,26 @@ arcmsr_iop_confirm(struct AdapterControl
                }
                }
                break;
+       case ACB_ADAPTER_TYPE_D: {
+               uint32_t __iomem *rwbuffer;
+               struct MessageUnit_D *reg = acb->pmuD;
+               reg->postq_index = 0;
+               reg->doneq_index = 0;
+               rwbuffer = reg->msgcode_rwbuffer;
+               writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
+               writel(cdb_phyaddr_hi32, rwbuffer++);
+               writel(cdb_phyaddr_lo32, rwbuffer++);
+               writel(cdb_phyaddr_lo32 + (ARCMSR_MAX_ARC1214_POSTQUEUE *
+                       sizeof(struct InBound_SRB)), rwbuffer++);
+               writel(0x100, rwbuffer);
+               writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, reg->inbound_msgaddr0);
+               if (!arcmsr_hbaD_wait_msgint_ready(acb)) {
+                       pr_notice("arcmsr%d: 'set command Q window' timeout\n",
+                               acb->host->host_no);
+                       return 1;
+               }
+               }
+               break;
        }
        return 0;
 }
@@ -3022,7 +3612,6 @@ arcmsr_wait_firmware_ready(struct Adapte
        uint32_t firmware_state = 0;

        switch (acb->adapter_type) {
-
        case ACB_ADAPTER_TYPE_A: {
                struct MessageUnit_A __iomem *reg = acb->pmuA;
                do {
@@ -3047,6 +3636,14 @@ arcmsr_wait_firmware_ready(struct Adapte
                        ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
                }
                break;
+       case ACB_ADAPTER_TYPE_D: {
+               struct MessageUnit_D *reg = acb->pmuD;
+               do {
+                       firmware_state = readl(reg->outbound_msgaddr1);
+               } while ((firmware_state &
+                       ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK) == 0);
+               }
+               break;
        }
 }

@@ -3140,6 +3737,36 @@ arcmsr_hbaC_request_device_map(struct Ad
 }

 static void
+arcmsr_hbaD_request_device_map(struct AdapterControlBlock *acb)
+{
+       struct MessageUnit_D *reg = acb->pmuD;
+
+       if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
+               ((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
+               ((acb->acb_flags & ACB_F_ABORT) != 0)) {
+               mod_timer(&acb->eternal_timer,
+                       jiffies + msecs_to_jiffies(6 * HZ));
+       } else {
+               acb->fw_flag = FW_NORMAL;
+               if (atomic_read(&acb->ante_token_value) ==
+                       atomic_read(&acb->rq_map_token)) {
+                       atomic_set(&acb->rq_map_token, 16);
+               }
+               atomic_set(&acb->ante_token_value,
+                       atomic_read(&acb->rq_map_token));
+               if (atomic_dec_and_test(&acb->rq_map_token)) {
+                       mod_timer(&acb->eternal_timer, jiffies +
+                               msecs_to_jiffies(6 * HZ));
+                       return;
+               }
+               writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
+                       reg->inbound_msgaddr0);
+               mod_timer(&acb->eternal_timer, jiffies +
+                       msecs_to_jiffies(6 * HZ));
+       }
+}
+
+static void
 arcmsr_request_device_map(unsigned long pacb)
 {
        struct AdapterControlBlock *acb = (struct AdapterControlBlock *)pacb;
@@ -3154,6 +3781,9 @@ arcmsr_request_device_map(unsigned long
        case ACB_ADAPTER_TYPE_C:
                arcmsr_hbaC_request_device_map(acb);
                break;
+       case ACB_ADAPTER_TYPE_D:
+               arcmsr_hbaD_request_device_map(acb);
+               break;
        }
 }

@@ -3198,6 +3828,19 @@ arcmsr_hbaC_start_bgrb(struct AdapterCon
 }

 static void
+arcmsr_hbaD_start_bgrb(struct AdapterControlBlock *pACB)
+{
+       struct MessageUnit_D *pmu = pACB->pmuD;
+
+       pACB->acb_flags |= ACB_F_MSG_START_BGRB;
+       writel(ARCMSR_INBOUND_MESG0_START_BGRB, pmu->inbound_msgaddr0);
+       if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {
+               pr_notice("arcmsr%d: wait 'start adapter "
+                       "background rebulid' timeout\n", pACB->host->host_no);
+       }
+}
+
+static void
 arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
@@ -3210,6 +3853,9 @@ arcmsr_start_adapter_bgrb(struct Adapter
        case ACB_ADAPTER_TYPE_C:
                arcmsr_hbaC_start_bgrb(acb);
                break;
+       case ACB_ADAPTER_TYPE_D:
+               arcmsr_hbaD_start_bgrb(acb);
+               break;
        }
 }

@@ -3258,6 +3904,28 @@ arcmsr_clear_doorbell_queue_buffer(struc
                }
                }
                break;
+       case ACB_ADAPTER_TYPE_D: {
+               struct MessageUnit_D *reg = acb->pmuD;
+               uint32_t outbound_doorbell, i;
+               /* empty doorbell Qbuffer if door bell ringed */
+               outbound_doorbell = readl(reg->outbound_doorbell);
+               writel(outbound_doorbell, reg->outbound_doorbell);
+               writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,
+                       reg->inbound_doorbell);
+               for (i = 0; i < 200; i++) {
+                       msleep(20);
+                       outbound_doorbell = readl(reg->outbound_doorbell);
+                       if (outbound_doorbell &
+                               ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK) {
+                               writel(outbound_doorbell,
+                                       reg->outbound_doorbell);
+                               writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,
+                                       reg->inbound_doorbell);
+                       } else
+                               break;
+               }
+               }
+               break;
        }
 }

@@ -3280,6 +3948,7 @@ arcmsr_hardware_reset(struct AdapterCont
        int i, count = 0;
        struct MessageUnit_A __iomem *pmuA = acb->pmuA;
        struct MessageUnit_C __iomem *pmuC = acb->pmuC;
+       struct MessageUnit_D *pmuD = acb->pmuD;

        /* backup pci config data */
        pr_notice("arcmsr%d: executing hw bus reset .....\n",
@@ -3302,6 +3971,8 @@ arcmsr_hardware_reset(struct AdapterCont
                } while (((readl(&pmuC->host_diagnostic) &
                        ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
                writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);
+       } else if ((acb->dev_id == 0x1214)) {
+               writel(0x20, pmuD->reset_request);
        } else {
                pci_write_config_byte(acb->pdev, 0x84, 0x20);
        }
@@ -3520,6 +4191,66 @@ sleep:
                }
                break;
        }
+       case ACB_ADAPTER_TYPE_D: {
+               if (acb->acb_flags & ACB_F_BUS_RESET) {
+                       long timeout;
+                       pr_notice("arcmsr: there is an bus reset"
+                               " eh proceeding.......\n");
+                       timeout = wait_event_timeout(wait_q, (acb->acb_flags
+                               & ACB_F_BUS_RESET) == 0, 220 * HZ);
+                       if (timeout)
+                               return SUCCESS;
+               }
+               acb->acb_flags |= ACB_F_BUS_RESET;
+               if (!arcmsr_iop_reset(acb)) {
+                       struct MessageUnit_D *reg;
+                       reg = acb->pmuD;
+                       arcmsr_hardware_reset(acb);
+                       acb->acb_flags &= ~ACB_F_IOP_INITED;
+               nap:
+                       ssleep(ARCMSR_SLEEPTIME);
+                       if ((readl(reg->sample_at_reset) & 0x80) != 0) {
+                               pr_err("arcmsr%d: waiting for "
+                                       "hw bus reset return, retry=%d\n",
+                                       acb->host->host_no, retry_count);
+                               if (retry_count > ARCMSR_RETRYCOUNT) {
+                                       acb->fw_flag = FW_DEADLOCK;
+                                       pr_err("arcmsr%d: waiting for hw bus"
+                                               " reset return, "
+                                               "RETRY TERMINATED!!\n",
+                                               acb->host->host_no);
+                                       return FAILED;
+                               }
+                               retry_count++;
+                               goto nap;
+                       }
+                       acb->acb_flags |= ACB_F_IOP_INITED;
+                       /* disable all outbound interrupt */
+                       intmask_org = arcmsr_disable_outbound_ints(acb);
+                       arcmsr_get_firmware_spec(acb);
+                       arcmsr_start_adapter_bgrb(acb);
+                       arcmsr_clear_doorbell_queue_buffer(acb);
+                       arcmsr_enable_outbound_ints(acb, intmask_org);
+                       atomic_set(&acb->rq_map_token, 16);
+                       atomic_set(&acb->ante_token_value, 16);
+                       acb->fw_flag = FW_NORMAL;
+                       mod_timer(&acb->eternal_timer,
+                               jiffies + msecs_to_jiffies(6 * HZ));
+                       acb->acb_flags &= ~ACB_F_BUS_RESET;
+                       rtn = SUCCESS;
+                       pr_err("arcmsr: scsi bus reset "
+                               "eh returns with success\n");
+               } else {
+                       acb->acb_flags &= ~ACB_F_BUS_RESET;
+                       atomic_set(&acb->rq_map_token, 16);
+                       atomic_set(&acb->ante_token_value, 16);
+                       acb->fw_flag = FW_NORMAL;
+                       mod_timer(&acb->eternal_timer,
+                               jiffies + msecs_to_jiffies(6 * HZ));
+                       rtn = SUCCESS;
+               }
+               break;
+               }
        }
        return rtn;
 }
@@ -3600,6 +4331,7 @@ static const char
        case PCI_DEVICE_ID_ARECA_1280:
                type = "SATA";
                break;
+       case PCI_DEVICE_ID_ARECA_1214:
        case PCI_DEVICE_ID_ARECA_1380:
        case PCI_DEVICE_ID_ARECA_1381:
        case PCI_DEVICE_ID_ARECA_1680:
