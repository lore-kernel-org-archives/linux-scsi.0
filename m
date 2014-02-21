From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: [PATCH v1.3 5/11] arcmsr: Rename function name and variables for readability
Date: Fri, 21 Feb 2014 12:01:31 +0800
Message-ID: <CAKiknE9EfEGrJ=pL=cZ=hTi4y-RF-fHVSB1Ji1hgQ510dfJ+NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:32970 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaBUEBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 23:01:32 -0500
Received: by mail-vc0-f173.google.com with SMTP id ld13so2737298vcb.4
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2014 20:01:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Cc: fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>

From: Ching <ching2048@areca.com.tw>

Rename function name and variables for readability.

Singed-off-by: Ching <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h      2014-01-13 23:21:56.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h      2014-01-14 23:27:40.000000000 +0800
@@ -358,7 +358,7 @@ struct ARCMSR_CDB
 #define ARCMSR_CDB_FLAG_ORDEREDQ           0x10

        uint8_t                                                 msgPages;
-       uint32_t                                                Context;
+       uint32_t                                                msgContext;
        uint32_t                                                DataLength;
        uint8_t                                                 Cdb[16];
        uint8_t                                                 DeviceStatus;
@@ -561,8 +561,8 @@ struct AdapterControlBlock
        /* dma_coherent used for memory free */
        dma_addr_t                      dma_coherent_handle;
        /* dma_coherent_handle used for memory free */
-       dma_addr_t                              dma_coherent_handle_hbb_mu;
-       unsigned int                            uncache_size;
+       dma_addr_t                      dma_coherent_handle2;
+       unsigned int                    uncache_size;
        uint8_t                         rqbuffer[ARCMSR_MAX_QBUFFER];
        /* data collection buffer for read from 80331 */
        int32_t                         rqbuf_firstindex;
@@ -611,7 +611,7 @@ struct CommandControlBlock{
        struct list_head                list;
 /*x32: 8byte, x64: 16byte*/
        struct scsi_cmnd                *pcmd;
 /*8 bytes pointer of linux scsi command */
        struct AdapterControlBlock      *acb;
 /*x32: 4byte, x64: 8byte*/
-       uint32_t                        cdb_phyaddr_pattern;
 /*x32: 4byte, x64: 4byte*/
+       uint32_t                        cdb_phyaddr;
 /*x32: 4byte, x64: 4byte*/
        uint32_t                        arc_cdb_size;
 /*x32:4byte,x64:4byte*/
        uint16_t                        ccb_flags;
 /*x32: 2byte, x64: 2byte*/
        #define                 CCB_FLAG_READ                   0x0000
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 02:01:56.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 02:02:34.000000000 +0800
@@ -98,12 +98,12 @@ static u32 arcmsr_disable_outbound_ints(
 static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
        u32 intmask_org);
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);
-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
+static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb);
+static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb);
 static void arcmsr_request_device_map(unsigned long pacb);
-static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb);
-static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb);
-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb);
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
@@ -179,17 +179,17 @@ static struct pci_driver arcmsr_pci_driv
 ****************************************************************************
 */

-static void arcmsr_free_hbb_mu(struct AdapterControlBlock *acb)
+static void arcmsr_free_mu(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A:
        case ACB_ADAPTER_TYPE_C:
                break;
-       case ACB_ADAPTER_TYPE_B:{
+       case ACB_ADAPTER_TYPE_B: {
                dma_free_coherent(&acb->pdev->dev,
                        sizeof(struct MessageUnit_B),
-                       acb->pmuB, acb->dma_coherent_handle_hbb_mu);
-       }
+                       acb->pmuB, acb->dma_coherent_handle2);
+               }
        }
 }

@@ -314,7 +314,7 @@ static void arcmsr_define_adapter_type(s
        }
 }

-static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
        int i;
@@ -332,7 +332,7 @@ static uint8_t arcmsr_hba_wait_msgint_re
        return false;
 }

-static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg = acb->pmuB;
        int i;
@@ -352,7 +352,7 @@ static uint8_t arcmsr_hbb_wait_msgint_re
        return false;
 }

-static uint8_t arcmsr_hbc_wait_msgint_ready(struct AdapterControlBlock *pACB)
+static uint8_t arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)
 {
        struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
        int i;
@@ -370,13 +370,13 @@ static uint8_t arcmsr_hbc_wait_msgint_re
        return false;
 }

-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
        int retry_count = 30;
        writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
        do {
-               if (arcmsr_hba_wait_msgint_ready(acb))
+               if (arcmsr_hbaA_wait_msgint_ready(acb))
                        break;
                else {
                        retry_count--;
@@ -386,13 +386,13 @@ static void arcmsr_flush_hba_cache(struc
        } while (retry_count != 0);
 }

-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg = acb->pmuB;
        int retry_count = 30;
        writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);
        do {
-               if (arcmsr_hbb_wait_msgint_ready(acb))
+               if (arcmsr_hbaB_wait_msgint_ready(acb))
                        break;
                else {
                        retry_count--;
@@ -402,14 +402,14 @@ static void arcmsr_flush_hbb_cache(struc
        } while (retry_count != 0);
 }

-static void arcmsr_flush_hbc_cache(struct AdapterControlBlock *pACB)
+static void arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
 {
        struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
        int retry_count = 30;/* enlarge wait flush adapter cache time:
10 minute */
        writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
        do {
-               if (arcmsr_hbc_wait_msgint_ready(pACB)) {
+               if (arcmsr_hbaC_wait_msgint_ready(pACB)) {
                        break;
                } else {
                        retry_count--;
@@ -424,16 +424,16 @@ static void arcmsr_flush_adapter_cache(s
        switch (acb->adapter_type) {

        case ACB_ADAPTER_TYPE_A: {
-               arcmsr_flush_hba_cache(acb);
+               arcmsr_hbaA_flush_cache(acb);
                }
                break;

        case ACB_ADAPTER_TYPE_B: {
-               arcmsr_flush_hbb_cache(acb);
+               arcmsr_hbaB_flush_cache(acb);
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
-               arcmsr_flush_hbc_cache(acb);
+               arcmsr_hbaC_flush_cache(acb);
                }
        }
 }
@@ -478,7 +478,7 @@ static int arcmsr_alloc_ccb_pool(struct
        acb->vir2phy_offset = (unsigned long)dma_coherent - (unsigned
long)dma_coherent_handle;
        for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){
                cdb_phyaddr = dma_coherent_handle + offsetof(struct
CommandControlBlock, arcmsr_cdb);
-               ccb_tmp->cdb_phyaddr_pattern = ((acb->adapter_type ==
ACB_ADAPTER_TYPE_C) ? cdb_phyaddr : (cdb_phyaddr >> 5));
+               ccb_tmp->cdb_phyaddr = ((acb->adapter_type ==
ACB_ADAPTER_TYPE_C) ? cdb_phyaddr : (cdb_phyaddr >> 5));
                acb->pccb_pool[i] = ccb_tmp;
                ccb_tmp->acb = acb;
                INIT_LIST_HEAD(&ccb_tmp->list);
@@ -850,7 +850,7 @@ RAID_controller_stop:
        arcmsr_flush_adapter_cache(acb);
        arcmsr_free_ccb_pool(acb);
 free_mu:
-       arcmsr_free_hbb_mu(acb);
+       arcmsr_free_mu(acb);
 unmap_pci_region:
        arcmsr_unmap_pciregion(acb);
 pci_release_regs:
@@ -862,11 +862,11 @@ pci_disable_dev:
        return -ENODEV;
 }

-static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hbaA_abort_allcmd(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
        writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
-       if (!arcmsr_hba_wait_msgint_ready(acb)) {
+       if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
                printk(KERN_NOTICE
                        "arcmsr%d: wait 'abort all outstanding
command' timeout \n"
                        , acb->host->host_no);
@@ -875,12 +875,12 @@ static uint8_t arcmsr_abort_hba_allcmd(s
        return true;
 }

-static uint8_t arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hbaB_abort_allcmd(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg = acb->pmuB;

        writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell);
-       if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+       if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
                printk(KERN_NOTICE
                        "arcmsr%d: wait 'abort all outstanding
command' timeout \n"
                        , acb->host->host_no);
@@ -888,12 +888,12 @@ static uint8_t arcmsr_abort_hbb_allcmd(s
        }
        return true;
 }
-static uint8_t arcmsr_abort_hbc_allcmd(struct AdapterControlBlock *pACB)
+static uint8_t arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB)
 {
        struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
        writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
-       if (!arcmsr_hbc_wait_msgint_ready(pACB)) {
+       if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
                printk(KERN_NOTICE
                        "arcmsr%d: wait 'abort all outstanding
command' timeout \n"
                        , pACB->host->host_no);
@@ -906,27 +906,27 @@ static uint8_t arcmsr_abort_allcmd(struc
        uint8_t rtnval = 0;
        switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A: {
-               rtnval = arcmsr_abort_hba_allcmd(acb);
+               rtnval = arcmsr_hbaA_abort_allcmd(acb);
                }
                break;

        case ACB_ADAPTER_TYPE_B: {
-               rtnval = arcmsr_abort_hbb_allcmd(acb);
+               rtnval = arcmsr_hbaB_abort_allcmd(acb);
                }
                break;

        case ACB_ADAPTER_TYPE_C: {
-               rtnval = arcmsr_abort_hbc_allcmd(acb);
+               rtnval = arcmsr_hbaC_abort_allcmd(acb);
                }
        }
        return rtnval;
 }

-static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock *pacb)
+static bool arcmsr_hbaB_enable_driver_mode(struct AdapterControlBlock *pacb)
 {
        struct MessageUnit_B *reg = pacb->pmuB;
        writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
-       if (!arcmsr_hbb_wait_msgint_ready(pacb)) {
+       if (!arcmsr_hbaB_wait_msgint_ready(pacb)) {
                printk(KERN_ERR "arcmsr%d: can't set driver mode. \n",
pacb->host->host_no);
                return false;
        }
@@ -1189,7 +1189,7 @@ static void arcmsr_remove(struct pci_dev
        } else
                free_irq(pdev->irq, acb);
        arcmsr_free_ccb_pool(acb);
-       arcmsr_free_hbb_mu(acb);
+       arcmsr_free_mu(acb);
        arcmsr_unmap_pciregion(acb);
        pci_release_regions(pdev);
        scsi_host_put(host);
@@ -1283,7 +1283,7 @@ static int arcmsr_build_ccb(struct Adapt
        arcmsr_cdb->TargetID = pcmd->device->id;
        arcmsr_cdb->LUN = pcmd->device->lun;
        arcmsr_cdb->Function = 1;
-       arcmsr_cdb->Context = 0;
+       arcmsr_cdb->msgContext = 0;
        memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);

        nseg = scsi_dma_map(pcmd);
@@ -1324,7 +1324,7 @@ static int arcmsr_build_ccb(struct Adapt

 static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct
CommandControlBlock *ccb)
 {
-       uint32_t cdb_phyaddr_pattern = ccb->cdb_phyaddr_pattern;
+       uint32_t cdb_phyaddr = ccb->cdb_phyaddr;
        struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
        atomic_inc(&acb->ccboutstandingcount);
        ccb->startdone = ARCMSR_CCB_START;
@@ -1333,10 +1333,10 @@ static void arcmsr_post_ccb(struct Adapt
                struct MessageUnit_A __iomem *reg = acb->pmuA;

                if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
-                       writel(cdb_phyaddr_pattern |
ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
+                       writel(cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
                        &reg->inbound_queueport);
                else {
-                               writel(cdb_phyaddr_pattern,
&reg->inbound_queueport);
+                               writel(cdb_phyaddr, &reg->inbound_queueport);
                }
                }
                break;
@@ -1348,10 +1348,10 @@ static void arcmsr_post_ccb(struct Adapt
                ending_index = ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);
                writel(0, &reg->post_qbuffer[ending_index]);
                if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {
-                       writel(cdb_phyaddr_pattern |
ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
+                       writel(cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
                                                 &reg->post_qbuffer[index]);
                } else {
-                       writel(cdb_phyaddr_pattern, &reg->post_qbuffer[index]);
+                       writel(cdb_phyaddr, &reg->post_qbuffer[index]);
                }
                index++;
                index %= ARCMSR_MAX_HBB_POSTQUEUE;/*if last index
number set it to 0 */
@@ -1364,7 +1364,7 @@ static void arcmsr_post_ccb(struct Adapt
                uint32_t ccb_post_stamp, arc_cdb_size;

                arc_cdb_size = (ccb->arc_cdb_size > 0x300) ? 0x300 :
ccb->arc_cdb_size;
-               ccb_post_stamp = (cdb_phyaddr_pattern | ((arc_cdb_size
- 1) >> 6) | 1);
+               ccb_post_stamp = (cdb_phyaddr | ((arc_cdb_size - 1) >> 6) | 1);
                if (acb->cdb_phyaddr_hi32) {
                        writel(acb->cdb_phyaddr_hi32,
&phbcmu->inbound_queueport_high);
                        writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
@@ -1375,38 +1375,38 @@ static void arcmsr_post_ccb(struct Adapt
        }
 }

-static void arcmsr_stop_hba_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_stop_bgrb(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
        acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
        writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
-       if (!arcmsr_hba_wait_msgint_ready(acb)) {
+       if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
                printk(KERN_NOTICE
                        "arcmsr%d: wait 'stop adapter background
rebulid' timeout \n"
                        , acb->host->host_no);
        }
 }

-static void arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_stop_bgrb(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg = acb->pmuB;
        acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
        writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);

-       if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+       if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
                printk(KERN_NOTICE
                        "arcmsr%d: wait 'stop adapter background
rebulid' timeout \n"
                        , acb->host->host_no);
        }
 }

-static void arcmsr_stop_hbc_bgrb(struct AdapterControlBlock *pACB)
+static void arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)
 {
        struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
        pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
        writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
-       if (!arcmsr_hbc_wait_msgint_ready(pACB)) {
+       if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
                printk(KERN_NOTICE
                        "arcmsr%d: wait 'stop adapter background
rebulid' timeout \n"
                        , pACB->host->host_no);
@@ -1417,16 +1417,16 @@ static void arcmsr_stop_adapter_bgrb(str
 {
        switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A: {
-               arcmsr_stop_hba_bgrb(acb);
+               arcmsr_hbaA_stop_bgrb(acb);
                }
                break;

        case ACB_ADAPTER_TYPE_B: {
-               arcmsr_stop_hbb_bgrb(acb);
+               arcmsr_hbaB_stop_bgrb(acb);
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
-               arcmsr_stop_hbc_bgrb(acb);
+               arcmsr_hbaC_stop_bgrb(acb);
                }
        }
 }
@@ -2272,7 +2272,7 @@ arcmsr_hbaA_get_config(struct AdapterCon
                (char __iomem *)(&reg->message_rwbuffer[21]);
        int count;
        writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-       if (!arcmsr_hba_wait_msgint_ready(acb)) {
+       if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
                pr_notice("arcmsr%d: wait 'get adapter firmware "
                        "miscellaneous data' timeout\n", acb->host->host_no);
                return false;
@@ -2335,10 +2335,10 @@ arcmsr_hbaB_get_config(struct AdapterCon
                GFP_KERNEL);
        if (!dma_coherent) {
                pr_notice("arcmsr%d: dma_alloc_coherent "
-                       "got error for hbb mu\n", acb->host->host_no);
+                       "got error for hbaB mu\n", acb->host->host_no);
                return false;
        }
-       acb->dma_coherent_handle_hbb_mu = dma_coherent_handle;
+       acb->dma_coherent_handle2 = dma_coherent_handle;
        reg = (struct MessageUnit_B *)dma_coherent;
        acb->pmuB = reg;
        reg->drv2iop_doorbell = (uint32_t __iomem *)
@@ -2360,7 +2360,7 @@ arcmsr_hbaB_get_config(struct AdapterCon
        iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);

        writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
-       if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+       if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
                pr_notice("arcmsr%d: wait 'get adapter firmware "
                        "miscellaneous data' timeout\n", acb->host->host_no);
                return false;
@@ -2492,7 +2492,7 @@ arcmsr_get_firmware_spec(struct AdapterC
        return rtn;
 }

-static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
+static int arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,
        struct CommandControlBlock *poll_ccb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -2501,7 +2501,7 @@ static int arcmsr_polling_hba_ccbdone(st
        uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0,
poll_count = 0;
        int rtn;
        bool error;
-       polling_hba_ccb_retry:
+       polling_hbaA_ccb_retry:
        poll_count++;
        outbound_intstatus = readl(&reg->outbound_intstatus) &
acb->outbound_int_enable;
        writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
@@ -2516,7 +2516,7 @@ static int arcmsr_polling_hba_ccbdone(st
                                        rtn = FAILED;
                                        break;
                                }
-                               goto polling_hba_ccb_retry;
+                               goto polling_hbaA_ccb_retry;
                        }
                }
                arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
+ (flag_ccb << 5));
@@ -2548,7 +2548,7 @@ static int arcmsr_polling_hba_ccbdone(st
        return rtn;
 }

-static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
+static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
                                        struct CommandControlBlock *poll_ccb)
 {
        struct MessageUnit_B *reg = acb->pmuB;
@@ -2557,7 +2557,7 @@ static int arcmsr_polling_hbb_ccbdone(st
        uint32_t flag_ccb, poll_ccb_done = 0, poll_count = 0;
        int index, rtn;
        bool error;
-       polling_hbb_ccb_retry:
+       polling_hbaB_ccb_retry:

        poll_count++;
        /* clear doorbell interrupt */
@@ -2574,7 +2574,7 @@ static int arcmsr_polling_hbb_ccbdone(st
                                        rtn = FAILED;
                                        break;
                                }
-                               goto polling_hbb_ccb_retry;
+                               goto polling_hbaB_ccb_retry;
                        }
                }
                writel(0, &reg->done_qbuffer[index]);
@@ -2612,7 +2612,7 @@ static int arcmsr_polling_hbb_ccbdone(st
        return rtn;
 }

-static int arcmsr_polling_hbc_ccbdone(struct AdapterControlBlock
*acb, struct CommandControlBlock *poll_ccb)
+static int arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock
*acb, struct CommandControlBlock *poll_ccb)
 {
        struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
        uint32_t flag_ccb, ccb_cdb_phy;
@@ -2621,7 +2621,7 @@ static int arcmsr_polling_hbc_ccbdone(st
        struct CommandControlBlock *pCCB;
        uint32_t poll_ccb_done = 0, poll_count = 0;
        int rtn;
-polling_hbc_ccb_retry:
+polling_hbaC_ccb_retry:
        poll_count++;
        while (1) {
                if ((readl(&reg->host_int_status) &
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) == 0) {
@@ -2634,7 +2634,7 @@ polling_hbc_ccb_retry:
                                        rtn = FAILED;
                                        break;
                                }
-                               goto polling_hbc_ccb_retry;
+                               goto polling_hbaC_ccb_retry;
                        }
                }
                flag_ccb = readl(&reg->outbound_queueport_low);
@@ -2675,16 +2675,16 @@ static int arcmsr_polling_ccbdone(struct
        switch (acb->adapter_type) {

        case ACB_ADAPTER_TYPE_A: {
-               rtn = arcmsr_polling_hba_ccbdone(acb, poll_ccb);
+               rtn = arcmsr_hbaA_polling_ccbdone(acb, poll_ccb);
                }
                break;

        case ACB_ADAPTER_TYPE_B: {
-               rtn = arcmsr_polling_hbb_ccbdone(acb, poll_ccb);
+               rtn = arcmsr_hbaB_polling_ccbdone(acb, poll_ccb);
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
-               rtn = arcmsr_polling_hbc_ccbdone(acb, poll_ccb);
+               rtn = arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);
                }
        }
        return rtn;
@@ -2719,7 +2719,7 @@ static int arcmsr_iop_confirm(struct Ada
                        writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
                        writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
                                                        &reg->inbound_msgaddr0);
-                       if (!arcmsr_hba_wait_msgint_ready(acb)) {
+                       if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
                                printk(KERN_NOTICE "arcmsr%d: ""set ccb high \
                                part physical address timeout\n",
                                acb->host->host_no);
@@ -2737,12 +2737,12 @@ static int arcmsr_iop_confirm(struct Ada
                reg->postq_index = 0;
                reg->doneq_index = 0;
                writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);
-               if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+               if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
                        printk(KERN_NOTICE "arcmsr%d:can not set diver
mode\n", \
                                acb->host->host_no);
                        return 1;
                }
-               post_queue_phyaddr = acb->dma_coherent_handle_hbb_mu;
+               post_queue_phyaddr = acb->dma_coherent_handle2;
                rwbuffer = reg->message_rwbuffer;
                /* driver "set config" signature */
                writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
@@ -2756,12 +2756,12 @@ static int arcmsr_iop_confirm(struct Ada
                writel(1056, rwbuffer);

                writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
-               if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+               if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
                        printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
                        timeout \n",acb->host->host_no);
                        return 1;
                }
-               arcmsr_hbb_enable_driver_mode(acb);
+               arcmsr_hbaB_enable_driver_mode(acb);
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
@@ -2774,7 +2774,7 @@ static int arcmsr_iop_confirm(struct Ada
                        writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);
                        writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,
&reg->inbound_msgaddr0);
                        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
-                       if (!arcmsr_hbc_wait_msgint_ready(acb)) {
+                       if (!arcmsr_hbaC_wait_msgint_ready(acb)) {
                                printk(KERN_NOTICE "arcmsr%d: 'set
command Q window' \
                                timeout \n", acb->host->host_no);
                                return 1;
@@ -2815,7 +2815,7 @@ static void arcmsr_wait_firmware_ready(s
        }
 }

-static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
        if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
@@ -2837,7 +2837,7 @@ static void arcmsr_request_hba_device_ma
        return;
 }

-static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B __iomem *reg = acb->pmuB;
        if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
@@ -2859,7 +2859,7 @@ static void arcmsr_request_hbb_device_ma
        return;
 }

-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock *acb)
+static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_C __iomem *reg = acb->pmuC;
        if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0) || ((acb->acb_flags &
ACB_F_ABORT) != 0)) {
@@ -2887,48 +2887,48 @@ static void arcmsr_request_device_map(un
        struct AdapterControlBlock *acb = (struct AdapterControlBlock *)pacb;
        switch (acb->adapter_type) {
                case ACB_ADAPTER_TYPE_A: {
-                       arcmsr_request_hba_device_map(acb);
+                       arcmsr_hbaA_request_device_map(acb);
                }
                break;
                case ACB_ADAPTER_TYPE_B: {
-                       arcmsr_request_hbb_device_map(acb);
+                       arcmsr_hbaB_request_device_map(acb);
                }
                break;
                case ACB_ADAPTER_TYPE_C: {
-                       arcmsr_request_hbc_device_map(acb);
+                       arcmsr_hbaC_request_device_map(acb);
                }
        }
 }

-static void arcmsr_start_hba_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_start_bgrb(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
        acb->acb_flags |= ACB_F_MSG_START_BGRB;
        writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
-       if (!arcmsr_hba_wait_msgint_ready(acb)) {
+       if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
                printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
                                rebulid' timeout \n", acb->host->host_no);
        }
 }

-static void arcmsr_start_hbb_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_start_bgrb(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg = acb->pmuB;
        acb->acb_flags |= ACB_F_MSG_START_BGRB;
        writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);
-       if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+       if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
                printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
                                rebulid' timeout \n",acb->host->host_no);
        }
 }

-static void arcmsr_start_hbc_bgrb(struct AdapterControlBlock *pACB)
+static void arcmsr_hbaC_start_bgrb(struct AdapterControlBlock *pACB)
 {
        struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
        pACB->acb_flags |= ACB_F_MSG_START_BGRB;
        writel(ARCMSR_INBOUND_MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&phbcmu->inbound_doorbell);
-       if (!arcmsr_hbc_wait_msgint_ready(pACB)) {
+       if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
                printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
                                rebulid' timeout \n", pACB->host->host_no);
        }
@@ -2938,13 +2938,13 @@ static void arcmsr_start_adapter_bgrb(st
 {
        switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A:
-               arcmsr_start_hba_bgrb(acb);
+               arcmsr_hbaA_start_bgrb(acb);
                break;
        case ACB_ADAPTER_TYPE_B:
-               arcmsr_start_hbb_bgrb(acb);
+               arcmsr_hbaB_start_bgrb(acb);
                break;
        case ACB_ADAPTER_TYPE_C:
-               arcmsr_start_hbc_bgrb(acb);
+               arcmsr_hbaC_start_bgrb(acb);
        }
 }

@@ -2990,7 +2990,7 @@ static void arcmsr_enable_eoi_mode(struc
                {
                        struct MessageUnit_B *reg = acb->pmuB;
                        writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE,
reg->drv2iop_doorbell);
-                       if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+                       if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
                                printk(KERN_NOTICE "ARCMSR IOP enables
EOI_MODE TIMEOUT");
                                return;
                        }
