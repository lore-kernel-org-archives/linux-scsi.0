From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: [PATCH v1.3 9/11] arcmsr: Fixed sparse warning or errors
Date: Fri, 21 Feb 2014 12:29:26 +0800
Message-ID: <CAKiknE-1r1+jpf1UoDHp2FjfH+Der6pQaLK44kjRp-WiA+mZKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Cc: fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Ching <ching2048@areca.com.tw>

Fixed sparse warning or errors.

Singed-off-by: Ching <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h      2014-02-18 01:30:16.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h      2014-02-20 23:23:30.000000000 +0800
@@ -408,9 +408,9 @@ struct MessageUnit_A
 struct MessageUnit_B
 {
        uint32_t        post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
-       uint32_t        done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
+       volatile uint32_t done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
        uint32_t        postq_index;
-       uint32_t        doneq_index;
+       volatile uint32_t doneq_index;
        uint32_t                __iomem *drv2iop_doorbell;
        uint32_t                __iomem *drv2iop_doorbell_mask;
        uint32_t                __iomem *iop2drv_doorbell;
@@ -506,6 +506,7 @@ struct AdapterControlBlock
        #define ACB_ADAPTER_TYPE_B            0x00000002        /* hbb M IOP */
        #define ACB_ADAPTER_TYPE_C            0x00000004        /* hbc P IOP */
        #define ACB_ADAPTER_TYPE_D            0x00000008        /* hbd A IOP */
+       u32             roundup_ccbsize;
        struct pci_dev *                pdev;
        struct Scsi_Host *              host;
        unsigned long                   vir2phy_offset;
@@ -564,6 +565,7 @@ struct AdapterControlBlock
        dma_addr_t                      dma_coherent_handle;
        /* dma_coherent_handle used for memory free */
        dma_addr_t                      dma_coherent_handle2;
+       void                            *dma_coherent2;
        unsigned int                    uncache_size;
        uint8_t                         rqbuffer[ARCMSR_MAX_QBUFFER];
        /* data collection buffer for read from 80331 */
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 02:04:50.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-20 19:10:08.000000000 +0800
@@ -78,7 +78,7 @@ MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 #define        ARCMSR_SLEEPTIME        10
 #define        ARCMSR_RETRYCOUNT       12

-wait_queue_head_t wait_q;
+static wait_queue_head_t wait_q;
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
                                        struct scsi_cmnd *cmd);
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb);
@@ -182,13 +182,10 @@ static struct pci_driver arcmsr_pci_driv
 static void arcmsr_free_mu(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
-       case ACB_ADAPTER_TYPE_A:
-       case ACB_ADAPTER_TYPE_C:
-               break;
        case ACB_ADAPTER_TYPE_B: {
-               dma_free_coherent(&acb->pdev->dev,
-                       sizeof(struct MessageUnit_B),
-                       acb->pmuB, acb->dma_coherent_handle2);
+               dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
+                       acb->dma_coherent2, acb->dma_coherent_handle2);
+               break;
                }
        }
 }
@@ -374,7 +371,7 @@ static uint8_t arcmsr_hbaB_wait_msgint_r

 static uint8_t arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)
 {
-       struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
+       struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;
        int i;

        for (i = 0; i < 2000; i++) {
@@ -424,7 +421,7 @@ static void arcmsr_hbaB_flush_cache(stru

 static void arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
 {
-       struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
+       struct MessageUnit_C __iomem *reg = pACB->pmuC;
        int retry_count = 30;/* enlarge wait flush adapter cache time:
10 minute */
        writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
@@ -861,7 +858,7 @@ static uint8_t arcmsr_hbaB_abort_allcmd(
 }
 static uint8_t arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB)
 {
-       struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
+       struct MessageUnit_C __iomem *reg = pACB->pmuC;
        writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
        if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
@@ -961,7 +958,7 @@ static u32 arcmsr_disable_outbound_ints(
                }
                break;
        case ACB_ADAPTER_TYPE_C:{
-               struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+               struct MessageUnit_C __iomem *reg = acb->pmuC;
                /* disable all outbound interrupt */
                orig_mask = readl(&reg->host_int_mask); /* disable
outbound message0 int */
                writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE,
&reg->host_int_mask);
@@ -1085,8 +1082,9 @@ static void arcmsr_done4abort_postqueue(
                /*clear all outbound posted Q*/
                writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
reg->iop2drv_doorbell); /* clear doorbell interrupt */
                for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
-                       if ((flag_ccb = readl(&reg->done_qbuffer[i])) != 0) {
-                               writel(0, &reg->done_qbuffer[i]);
+                       flag_ccb = reg->done_qbuffer[i];
+                       if (flag_ccb != 0) {
+                               reg->done_qbuffer[i] = 0;
                                pARCMSR_CDB = (struct ARCMSR_CDB
*)(acb->vir2phy_offset+(flag_ccb << 5));/*frame must be 32 bytes
aligned*/
                                pCCB = container_of(pARCMSR_CDB,
struct CommandControlBlock, arcmsr_cdb);
                                error = (flag_ccb &
ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
@@ -1099,7 +1097,7 @@ static void arcmsr_done4abort_postqueue(
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
-               struct MessageUnit_C *reg = acb->pmuC;
+               struct MessageUnit_C __iomem *reg = acb->pmuC;
                struct  ARCMSR_CDB *pARCMSR_CDB;
                uint32_t flag_ccb, ccb_cdb_phy;
                bool error;
@@ -1231,7 +1229,7 @@ static void arcmsr_enable_outbound_ints(
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
-               struct MessageUnit_C *reg = acb->pmuC;
+               struct MessageUnit_C __iomem *reg = acb->pmuC;
                mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |
ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);
                writel(intmask_org & mask, &reg->host_int_mask);
                acb->outbound_int_enable = ~(intmask_org & mask) & 0x0000000f;
@@ -1318,13 +1316,12 @@ static void arcmsr_post_ccb(struct Adapt
                uint32_t ending_index, index = reg->postq_index;

                ending_index = ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);
-               writel(0, &reg->post_qbuffer[ending_index]);
-               if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {
-                       writel(cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
-                                                &reg->post_qbuffer[index]);
-               } else {
-                       writel(cdb_phyaddr, &reg->post_qbuffer[index]);
-               }
+               reg->post_qbuffer[ending_index] = 0;
+               if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
+                       reg->post_qbuffer[index] =
+                               cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE;
+               else
+                       reg->post_qbuffer[index] = cdb_phyaddr;
                index++;
                index %= ARCMSR_MAX_HBB_POSTQUEUE;/*if last index
number set it to 0 */
                reg->postq_index = index;
@@ -1332,7 +1329,7 @@ static void arcmsr_post_ccb(struct Adapt
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
-               struct MessageUnit_C *phbcmu = (struct MessageUnit_C
*)acb->pmuC;
+               struct MessageUnit_C __iomem *phbcmu = acb->pmuC;
                uint32_t ccb_post_stamp, arc_cdb_size;

                arc_cdb_size = (ccb->arc_cdb_size > 0x300) ? 0x300 :
ccb->arc_cdb_size;
@@ -1374,7 +1371,7 @@ static void arcmsr_hbaB_stop_bgrb(struct

 static void arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)
 {
-       struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
+       struct MessageUnit_C __iomem *reg = pACB->pmuC;
        pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
        writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
@@ -1408,7 +1405,7 @@ static void arcmsr_free_ccb_pool(struct
        dma_free_coherent(&acb->pdev->dev, acb->uncache_size,
acb->dma_coherent, acb->dma_coherent_handle);
 }

-void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
+static void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A: {
@@ -1480,7 +1477,7 @@ struct QBUFFER __iomem *arcmsr_get_iop_r
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
-               struct MessageUnit_C *phbcmu = (struct MessageUnit_C
*)acb->pmuC;
+               struct MessageUnit_C __iomem *phbcmu = acb->pmuC;
                qbuffer = (struct QBUFFER __iomem *)&phbcmu->message_rbuffer;
                }
        }
@@ -1504,7 +1501,7 @@ static struct QBUFFER __iomem *arcmsr_ge
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
-               struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+               struct MessageUnit_C __iomem *reg = acb->pmuC;
                pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;
        }

@@ -1752,8 +1749,8 @@ arcmsr_hbaB_postqueue_isr(struct Adapter
        struct CommandControlBlock *pCCB;
        bool error;
        index = reg->doneq_index;
-       while ((flag_ccb = readl(&reg->done_qbuffer[index])) != 0) {
-               writel(0, &reg->done_qbuffer[index]);
+       while ((flag_ccb = reg->done_qbuffer[index]) != 0) {
+               reg->done_qbuffer[index] = 0;
                pARCMSR_CDB = (struct ARCMSR_CDB *)
                        (acb->vir2phy_offset + (flag_ccb << 5));
                pCCB = container_of(pARCMSR_CDB,
@@ -2290,7 +2287,7 @@ static struct CommandControlBlock *arcms
                list_del_init(&ccb->list);
        }else{
                spin_unlock_irqrestore(&acb->ccblist_lock, flags);
-               return 0;
+               return NULL;
        }
        spin_unlock_irqrestore(&acb->ccblist_lock, flags);
        return ccb;
@@ -2447,8 +2444,8 @@ arcmsr_hbaB_get_config(struct AdapterCon
 {
        struct MessageUnit_B *reg;
        struct pci_dev *pdev = acb->pdev;
-       void *dma_coherent;
-       dma_addr_t dma_coherent_handle;
+       void *dma_coherent2;
+       dma_addr_t dma_coherent_handle2;
        char *acb_firm_model = acb->firm_model;
        char *acb_firm_version = acb->firm_version;
        char *acb_device_map = acb->device_map;
@@ -2459,16 +2456,17 @@ arcmsr_hbaB_get_config(struct AdapterCon
        char __iomem *iop_device_map;
        /*firm_version,21,84-99*/
        int count;
-       dma_coherent = dma_alloc_coherent(&pdev->dev,
-               sizeof(struct MessageUnit_B), &dma_coherent_handle,
-               GFP_KERNEL);
-       if (!dma_coherent) {
+       acb->roundup_ccbsize = roundup(sizeof(struct MessageUnit_B), 32);
+       dma_coherent2 = dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsize,
+               &dma_coherent_handle2, GFP_KERNEL);
+       if (!dma_coherent2) {
                pr_notice("arcmsr%d: dma_alloc_coherent "
                        "got error for hbaB mu\n", acb->host->host_no);
                return false;
        }
-       acb->dma_coherent_handle2 = dma_coherent_handle;
-       reg = (struct MessageUnit_B *)dma_coherent;
+       acb->dma_coherent_handle2 = dma_coherent_handle2;
+       acb->dma_coherent2 = dma_coherent2;
+       reg = (struct MessageUnit_B *)dma_coherent2;
        acb->pmuB = reg;
        reg->drv2iop_doorbell = (uint32_t __iomem *)
                ((unsigned long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
@@ -2492,6 +2490,8 @@ arcmsr_hbaB_get_config(struct AdapterCon
        if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
                pr_notice("arcmsr%d: wait 'get adapter firmware "
                        "miscellaneous data' timeout\n", acb->host->host_no);
+               dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
+                       acb->dma_coherent2, acb->dma_coherent_handle2);
                return false;
        }
        count = 8;
@@ -2543,8 +2543,8 @@ arcmsr_hbaC_get_config(struct AdapterCon
        struct MessageUnit_C __iomem *reg = pACB->pmuC;
        char *acb_firm_model = pACB->firm_model;
        char *acb_firm_version = pACB->firm_version;
-       char *iop_firm_model = (char *)(&reg->msgcode_rwbuffer[15]);
-       char *iop_firm_version = (char *)(&reg->msgcode_rwbuffer[17]);
+       char __iomem *iop_firm_model = (char __iomem
*)(&reg->msgcode_rwbuffer[15]);
+       char __iomem *iop_firm_version = (char __iomem
*)(&reg->msgcode_rwbuffer[17]);
        int count;
        /* disable all outbound interrupt */
        intmask_org = readl(&reg->host_int_mask);
@@ -2693,7 +2693,8 @@ static int arcmsr_hbaB_polling_ccbdone(s
        writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
        while(1){
                index = reg->doneq_index;
-               if ((flag_ccb = readl(&reg->done_qbuffer[index])) == 0) {
+               flag_ccb = reg->done_qbuffer[index];
+               if (flag_ccb == 0) {
                        if (poll_ccb_done){
                                rtn = SUCCESS;
                                break;
@@ -2706,7 +2707,7 @@ static int arcmsr_hbaB_polling_ccbdone(s
                                goto polling_hbaB_ccb_retry;
                        }
                }
-               writel(0, &reg->done_qbuffer[index]);
+               reg->done_qbuffer[index] = 0;
                index++;
                /*if last index number set it to 0 */
                index %= ARCMSR_MAX_HBB_POSTQUEUE;
@@ -2743,7 +2744,7 @@ static int arcmsr_hbaB_polling_ccbdone(s

 static int arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock
*acb, struct CommandControlBlock *poll_ccb)
 {
-       struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+       struct MessageUnit_C __iomem *reg = acb->pmuC;
        uint32_t flag_ccb, ccb_cdb_phy;
        struct ARCMSR_CDB *arcmsr_cdb;
        bool error;
@@ -2895,7 +2896,7 @@ static int arcmsr_iop_confirm(struct Ada
                break;
        case ACB_ADAPTER_TYPE_C: {
                if (cdb_phyaddr_hi32 != 0) {
-                       struct MessageUnit_C *reg = (struct
MessageUnit_C *)acb->pmuC;
+                       struct MessageUnit_C __iomem *reg = acb->pmuC;

                        printk(KERN_NOTICE "arcmsr%d: cdb_phyaddr_hi32=0x%x\n",
                                        acb->adapter_index, cdb_phyaddr_hi32);
@@ -2936,7 +2937,7 @@ static void arcmsr_wait_firmware_ready(s
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
-               struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+               struct MessageUnit_C __iomem *reg = acb->pmuC;
                do {
                        firmware_state = readl(&reg->outbound_msgaddr1);
                } while ((firmware_state &
ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
@@ -2968,7 +2969,7 @@ static void arcmsr_hbaA_request_device_m

 static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb)
 {
-       struct MessageUnit_B __iomem *reg = acb->pmuB;
+       struct MessageUnit_B *reg = acb->pmuB;
        if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
                mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
                return;
@@ -3053,7 +3054,7 @@ static void arcmsr_hbaB_start_bgrb(struc

 static void arcmsr_hbaC_start_bgrb(struct AdapterControlBlock *pACB)
 {
-       struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
+       struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;
        pACB->acb_flags |= ACB_F_MSG_START_BGRB;
        writel(ARCMSR_INBOUND_MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&phbcmu->inbound_doorbell);
@@ -3100,7 +3101,7 @@ static void arcmsr_clear_doorbell_queue_
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
-               struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+               struct MessageUnit_C __iomem *reg = acb->pmuC;
                uint32_t outbound_doorbell;
                /* empty doorbell Qbuffer if door bell ringed */
                outbound_doorbell = readl(&reg->outbound_doorbell);
