From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: [PATCH v1.3 4/11] arcmsr: Revise xxx_get_config functions
Date: Fri, 21 Feb 2014 11:53:50 +0800
Message-ID: <CAKiknE-sMvSW55RGCTRQpBCdb9FoTMJkYCK4wR-AKud0Wwc8Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Cc: fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Ching <ching2048@areca.com.tw>

Revise xxx_get_config functions.

Singed-off-by: Ching <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h      2014-01-11 03:14:14.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h      2014-01-13 23:21:56.000000000 +0800
@@ -598,6 +598,7 @@ struct AdapterControlBlock
                                #define FW_DEADLOCK     0x0010
        atomic_t                        rq_map_token;
        atomic_t                        ante_token_value;
+       uint32_t        maxOutstanding;
 };/* HW_DEVICE_EXTENSION */
 /*
 *******************************************************************************
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 02:00:16.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 02:01:56.000000000 +0800
@@ -2241,8 +2241,7 @@ static int arcmsr_queue_command_lck(stru
                arcmsr_handle_virtual_command(acb, cmd);
                return 0;
        }
-       if (atomic_read(&acb->ccboutstandingcount) >=
-                       ARCMSR_MAX_OUTSTANDING_CMD)
+       if (atomic_read(&acb->ccboutstandingcount) >= acb->maxOutstanding)
                return SCSI_MLQUEUE_HOST_BUSY;
        ccb = arcmsr_get_freeccb(acb);
        if (!ccb)
@@ -2258,24 +2257,28 @@ static int arcmsr_queue_command_lck(stru

 static DEF_SCSI_QCMD(arcmsr_queue_command)

-static bool arcmsr_get_hba_config(struct AdapterControlBlock *acb)
+static bool
+arcmsr_hbaA_get_config(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
        char *acb_firm_model = acb->firm_model;
        char *acb_firm_version = acb->firm_version;
        char *acb_device_map = acb->device_map;
-       char __iomem *iop_firm_model = (char __iomem
*)(&reg->message_rwbuffer[15]);
-       char __iomem *iop_firm_version = (char __iomem
*)(&reg->message_rwbuffer[17]);
-       char __iomem *iop_device_map = (char __iomem
*)(&reg->message_rwbuffer[21]);
+       char __iomem *iop_firm_model =
+               (char __iomem *)(&reg->message_rwbuffer[15]);
+       char __iomem *iop_firm_version =
+               (char __iomem *)(&reg->message_rwbuffer[17]);
+       char __iomem *iop_device_map =
+               (char __iomem *)(&reg->message_rwbuffer[21]);
        int count;
        writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
        if (!arcmsr_hba_wait_msgint_ready(acb)) {
-               printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
-                       miscellaneous data' timeout \n", acb->host->host_no);
+               pr_notice("arcmsr%d: wait 'get adapter firmware "
+                       "miscellaneous data' timeout\n", acb->host->host_no);
                return false;
        }
        count = 8;
-       while (count){
+       while (count) {
                *acb_firm_model = readb(iop_firm_model);
                acb_firm_model++;
                iop_firm_model++;
@@ -2283,7 +2286,7 @@ static bool arcmsr_get_hba_config(struct
        }

        count = 16;
-       while (count){
+       while (count) {
                *acb_firm_version = readb(iop_firm_version);
                acb_firm_version++;
                iop_firm_version++;
@@ -2291,27 +2294,29 @@ static bool arcmsr_get_hba_config(struct
        }

        count=16;
-       while(count){
+       while (count) {
                *acb_device_map = readb(iop_device_map);
                acb_device_map++;
                iop_device_map++;
                count--;
        }
-       printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
+       pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
                acb->host->host_no,
-               acb->firm_version,
-               acb->firm_model);
+               acb->firm_model,
+               acb->firm_version);
        acb->signature = readl(&reg->message_rwbuffer[0]);
        acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
        acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
        acb->firm_sdram_size = readl(&reg->message_rwbuffer[3]);
        acb->firm_hd_channels = readl(&reg->message_rwbuffer[4]);
-       acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);
/*firm_cfg_version,25,100-103*/
+       acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);
        return true;
 }
-static bool arcmsr_get_hbb_config(struct AdapterControlBlock *acb)
+
+static bool
+arcmsr_hbaB_get_config(struct AdapterControlBlock *acb)
 {
-       struct MessageUnit_B *reg = acb->pmuB;
+       struct MessageUnit_B *reg;
        struct pci_dev *pdev = acb->pdev;
        void *dma_coherent;
        dma_addr_t dma_coherent_handle;
@@ -2325,40 +2330,50 @@ static bool arcmsr_get_hbb_config(struct
        char __iomem *iop_device_map;
        /*firm_version,21,84-99*/
        int count;
-       dma_coherent = dma_alloc_coherent(&pdev->dev, sizeof(struct
MessageUnit_B), &dma_coherent_handle, GFP_KERNEL);
-       if (!dma_coherent){
-               printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got
error for hbb mu\n", acb->host->host_no);
+       dma_coherent = dma_alloc_coherent(&pdev->dev,
+               sizeof(struct MessageUnit_B), &dma_coherent_handle,
+               GFP_KERNEL);
+       if (!dma_coherent) {
+               pr_notice("arcmsr%d: dma_alloc_coherent "
+                       "got error for hbb mu\n", acb->host->host_no);
                return false;
        }
        acb->dma_coherent_handle_hbb_mu = dma_coherent_handle;
        reg = (struct MessageUnit_B *)dma_coherent;
        acb->pmuB = reg;
-       reg->drv2iop_doorbell= (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
-       reg->drv2iop_doorbell_mask = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);
-       reg->iop2drv_doorbell = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL);
-       reg->iop2drv_doorbell_mask = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);
-       reg->message_wbuffer = (uint32_t __iomem *)((unsigned
long)acb->mem_base1 + ARCMSR_MESSAGE_WBUFFER);
-       reg->message_rbuffer =  (uint32_t __iomem *)((unsigned
long)acb->mem_base1 + ARCMSR_MESSAGE_RBUFFER);
-       reg->message_rwbuffer = (uint32_t __iomem *)((unsigned
long)acb->mem_base1 + ARCMSR_MESSAGE_RWBUFFER);
-       iop_firm_model = (char __iomem *)(&reg->message_rwbuffer[15]);
 /*firm_model,15,60-67*/
-       iop_firm_version = (char __iomem
*)(&reg->message_rwbuffer[17]);        /*firm_version,17,68-83*/
-       iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);
 /*firm_version,21,84-99*/
+       reg->drv2iop_doorbell = (uint32_t __iomem *)
+               ((unsigned long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
+       reg->drv2iop_doorbell_mask = (uint32_t __iomem *)
+               ((unsigned long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);
+       reg->iop2drv_doorbell = (uint32_t __iomem *)
+               ((unsigned long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL);
+       reg->iop2drv_doorbell_mask = (uint32_t __iomem *)
+               ((unsigned long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);
+       reg->message_wbuffer = (uint32_t __iomem *)
+               ((unsigned long)acb->mem_base1 + ARCMSR_MESSAGE_WBUFFER);
+       reg->message_rbuffer = (uint32_t __iomem *)
+               ((unsigned long)acb->mem_base1 + ARCMSR_MESSAGE_RBUFFER);
+       reg->message_rwbuffer = (uint32_t __iomem *)
+               ((unsigned long)acb->mem_base1 + ARCMSR_MESSAGE_RWBUFFER);
+       iop_firm_model = (char __iomem *)(&reg->message_rwbuffer[15]);
+       iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);
+       iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);

        writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
        if (!arcmsr_hbb_wait_msgint_ready(acb)) {
-               printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
-                       miscellaneous data' timeout \n", acb->host->host_no);
+               pr_notice("arcmsr%d: wait 'get adapter firmware "
+                       "miscellaneous data' timeout\n", acb->host->host_no);
                return false;
        }
        count = 8;
-       while (count){
+       while (count) {
                *acb_firm_model = readb(iop_firm_model);
                acb_firm_model++;
                iop_firm_model++;
                count--;
        }
        count = 16;
-       while (count){
+       while (count) {
                *acb_firm_version = readb(iop_firm_version);
                acb_firm_version++;
                iop_firm_version++;
@@ -2366,17 +2381,17 @@ static bool arcmsr_get_hbb_config(struct
        }

        count = 16;
-       while(count){
+       while (count) {
                *acb_device_map = readb(iop_device_map);
                acb_device_map++;
                iop_device_map++;
                count--;
        }
-
-       printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
+
+       pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
                acb->host->host_no,
-               acb->firm_version,
-               acb->firm_model);
+               acb->firm_model,
+               acb->firm_version);

        acb->signature = readl(&reg->message_rwbuffer[1]);
        /*firm_signature,1,00-03*/
@@ -2387,25 +2402,25 @@ static bool arcmsr_get_hbb_config(struct
        acb->firm_sdram_size = readl(&reg->message_rwbuffer[4]);
        /*firm_sdram_size,3,12-15*/
        acb->firm_hd_channels = readl(&reg->message_rwbuffer[5]);
-       /*firm_ide_channels,4,16-19*/
-       acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);
/*firm_cfg_version,25,100-103*/
-       /*firm_ide_channels,4,16-19*/
+       /*firm_hd_channels,4,16-19*/
+       acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);
        return true;
 }

-static bool arcmsr_get_hbc_config(struct AdapterControlBlock *pACB)
+static bool
+arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)
 {
        uint32_t intmask_org, Index, firmware_state = 0;
-       struct MessageUnit_C *reg = pACB->pmuC;
+       struct MessageUnit_C __iomem *reg = pACB->pmuC;
        char *acb_firm_model = pACB->firm_model;
        char *acb_firm_version = pACB->firm_version;
-       char *iop_firm_model = (char *)(&reg->msgcode_rwbuffer[15]);
 /*firm_model,15,60-67*/
-       char *iop_firm_version = (char *)(&reg->msgcode_rwbuffer[17]);
 /*firm_version,17,68-83*/
+       char *iop_firm_model = (char *)(&reg->msgcode_rwbuffer[15]);
+       char *iop_firm_version = (char *)(&reg->msgcode_rwbuffer[17]);
        int count;
        /* disable all outbound interrupt */
-       intmask_org = readl(&reg->host_int_mask); /* disable outbound
message0 int */
-       writel(intmask_org|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);
-       /* wait firmware ready */
+       intmask_org = readl(&reg->host_int_mask);
+       writel(intmask_org | ARCMSR_HBCMU_ALL_INTMASKENABLE,
+               &reg->host_int_mask);
        do {
                firmware_state = readl(&reg->outbound_msgaddr1);
        } while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
@@ -2414,15 +2429,17 @@ static bool arcmsr_get_hbc_config(struct
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
        /* wait message ready */
        for (Index = 0; Index < 2000; Index++) {
-               if (readl(&reg->outbound_doorbell) &
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-
writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&reg->outbound_doorbell_clear);/*clear interrupt*/
+               if (readl(&reg->outbound_doorbell) &
+                       ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
+
writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+                               &reg->outbound_doorbell_clear);
                        break;
                }
                udelay(10);
        } /*max 1 seconds*/
        if (Index >= 2000) {
-               printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
-                       miscellaneous data' timeout \n", pACB->host->host_no);
+               pr_notice("arcmsr%d: wait 'get adapter firmware "
+                       "miscellaneous data' timeout\n", pACB->host->host_no);
                return false;
        }
        count = 8;
@@ -2439,26 +2456,40 @@ static bool arcmsr_get_hbc_config(struct
                iop_firm_version++;
                count--;
        }
-       printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
+       pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
                pACB->host->host_no,
-               pACB->firm_version,
-               pACB->firm_model);
-       pACB->firm_request_len = readl(&reg->msgcode_rwbuffer[1]);
/*firm_request_len,1,04-07*/
-       pACB->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[2]);
/*firm_numbers_queue,2,08-11*/
-       pACB->firm_sdram_size = readl(&reg->msgcode_rwbuffer[3]);
/*firm_sdram_size,3,12-15*/
-       pACB->firm_hd_channels = readl(&reg->msgcode_rwbuffer[4]);
/*firm_ide_channels,4,16-19*/
-       pACB->firm_cfg_version = readl(&reg->msgcode_rwbuffer[25]);
/*firm_cfg_version,25,100-103*/
-       /*all interrupt service will be enable at arcmsr_iop_init*/
+               pACB->firm_model,
+               pACB->firm_version);
+       pACB->firm_request_len = readl(&reg->msgcode_rwbuffer[1]);
+       pACB->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[2]);
+       pACB->firm_sdram_size = readl(&reg->msgcode_rwbuffer[3]);
+       pACB->firm_hd_channels = readl(&reg->msgcode_rwbuffer[4]);
+       pACB->firm_cfg_version = readl(&reg->msgcode_rwbuffer[25]);
        return true;
 }
-static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
+
+static bool
+arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
-       if (acb->adapter_type == ACB_ADAPTER_TYPE_A)
-               return arcmsr_get_hba_config(acb);
-       else if (acb->adapter_type == ACB_ADAPTER_TYPE_B)
-               return arcmsr_get_hbb_config(acb);
+       bool rtn = false;
+       switch (acb->adapter_type) {
+       case ACB_ADAPTER_TYPE_A:
+               rtn = arcmsr_hbaA_get_config(acb);
+               break;
+       case ACB_ADAPTER_TYPE_B:
+               rtn = arcmsr_hbaB_get_config(acb);
+               break;
+       case ACB_ADAPTER_TYPE_C:
+               rtn = arcmsr_hbaC_get_config(acb);
+               break;
+       default:
+               break;
+       }
+       if(acb->firm_numbers_queue > ARCMSR_MAX_FREECCB_NUM)
+               acb->maxOutstanding = ARCMSR_MAX_FREECCB_NUM-1;
        else
-               return arcmsr_get_hbc_config(acb);
+               acb->maxOutstanding = acb->firm_numbers_queue - 1;
+       return rtn;
 }

 static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
