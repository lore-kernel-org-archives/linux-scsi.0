From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [ADVANSYS] Add basic highmem/DMA support
Date: 31 May 2004 13:02:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086026538.2004.7.camel@mulgrave>
References: <20040508003906.GA26338@gondor.apana.org.au>
	<20040519103800.GA9891@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:61388 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264710AbUEaSCo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2004 14:02:44 -0400
In-Reply-To: <20040519103800.GA9891@gondor.apana.org.au>
List-Id: linux-scsi@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, Gene Heskett <gene.heskett@verizon.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Wed, 2004-05-19 at 05:38, Herbert Xu wrote:
> Hi:
> 
> This is a resend of my patch that adds basic support for highmem
> on i386 to the advansys driver.  It has been tested in
> http://bugs.debian.org/245238.
> 
> The maintainer email address listed in the MAINTAINERS file bounced
> so someone else will need to look at this.

I converted your patch to use the DMA-API.  This will be necessary to
use the EISA advansys boards---Of course, EISA won't work properly until
the entire driver is converted to the driverfs probing API, sigh, but
I'll get around to that eventually.

OK, and I couldn't resist getting rid of the stupid in_isr locking on
the done function.

Could someone who actually has one of these things please test?  Thanks,

James

===== drivers/scsi/advansys.c 1.38 vs edited =====
--- 1.38/drivers/scsi/advansys.c	2004-02-03 23:29:29 -06:00
+++ edited/drivers/scsi/advansys.c	2004-05-31 12:14:32 -05:00
@@ -801,6 +801,7 @@
 #include <linux/blkdev.h>
 #include <linux/stat.h>
 #include <linux/spinlock.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
@@ -1576,7 +1577,7 @@
     uchar               sdtr_period_offset[ASC_MAX_TID + 1];
     ushort              pci_slot_info;
     uchar               adapter_info[6];
-    struct pci_dev	*pci_dev;
+    struct device	*dev;
 } ASC_DVC_CFG;
 
 #define ASC_DEF_DVC_CNTL       0xFFFF
@@ -3082,7 +3083,7 @@
   ushort serial1;           /* EEPROM serial number word 1 */
   ushort serial2;           /* EEPROM serial number word 2 */
   ushort serial3;           /* EEPROM serial number word 3 */
-  struct pci_dev *pci_dev;  /* pointer to the pci dev structure for this board */
+  struct device *dev;  /* pointer to the pci dev structure for this board */
 } ADV_DVC_CFG;
 
 struct adv_dvc_var;
@@ -4210,11 +4211,11 @@
 
 STATIC irqreturn_t advansys_interrupt(int, void *, struct pt_regs *);
 STATIC int	  advansys_slave_configure(Scsi_Device *);
-STATIC void       asc_scsi_done_list(Scsi_Cmnd *, int from_isr);
+STATIC void       asc_scsi_done_list(Scsi_Cmnd *);
 STATIC int        asc_execute_scsi_cmnd(Scsi_Cmnd *);
 STATIC int        asc_build_req(asc_board_t *, Scsi_Cmnd *);
 STATIC int        adv_build_req(asc_board_t *, Scsi_Cmnd *, ADV_SCSI_REQ_Q **);
-STATIC int        adv_get_sglist(asc_board_t *, adv_req_t *, Scsi_Cmnd *);
+STATIC int        adv_get_sglist(asc_board_t *, adv_req_t *, Scsi_Cmnd *, int);
 STATIC void       asc_isr_callback(ASC_DVC_VAR *, ASC_QDONE_INFO *);
 STATIC void       adv_isr_callback(ADV_DVC_VAR *, ADV_SCSI_REQ_Q *);
 STATIC void       adv_async_callback(ADV_DVC_VAR *, uchar);
@@ -4526,6 +4527,7 @@
     struct pci_dev      *pci_devicep[ASC_NUM_BOARD_SUPPORTED];
     int                 pci_card_cnt_max = 0;
     int                 pci_card_cnt = 0;
+    struct device	*dev = NULL;
     struct pci_dev      *pci_devp = NULL;
     int                 pci_device_id_cnt = 0;
     unsigned int        pci_device_id[ASC_PCI_DEVICE_ID_CNT] = {
@@ -4735,6 +4737,9 @@
                     ASC_DBG2(2, "advansys_detect: iop %X, irqLine %d\n",
                         iop, pci_devp->irq);
                 }
+		if(pci_devp)
+		    dev = &pci_devp->dev;
+
 #endif /* CONFIG_PCI */
                 break;
 
@@ -4765,7 +4770,7 @@
                 continue;
             }
 
-	    scsi_set_device(shp, &pci_devp->dev);
+	    scsi_set_device(shp, dev);
 
             /* Save a pointer to the Scsi_Host of each board found. */
             asc_host[asc_board_count++] = shp;
@@ -4904,7 +4909,8 @@
 #endif /* CONFIG_PROC_FS */
 
             if (ASC_NARROW_BOARD(boardp)) {
-                /*
+		asc_dvc_varp->cfg->dev = dev;
+		/*
                  * Set the board bus type and PCI IRQ before
                  * calling AscInitGetConfig().
                  */
@@ -4926,7 +4932,6 @@
 #ifdef CONFIG_PCI
                 case ASC_IS_PCI:
                     shp->irq = asc_dvc_varp->irq_no = pci_devp->irq;
-                    asc_dvc_varp->cfg->pci_dev = pci_devp;
                     asc_dvc_varp->cfg->pci_slot_info =
                         ASC_PCI_MKID(pci_devp->bus->number,
                             PCI_SLOT(pci_devp->devfn),
@@ -4944,13 +4949,13 @@
                     break;
                 }
             } else {
+                adv_dvc_varp->cfg->dev = dev;
                 /*
                  * For Wide boards set PCI information before calling
                  * AdvInitGetConfig().
                  */
 #ifdef CONFIG_PCI
                 shp->irq = adv_dvc_varp->irq_no = pci_devp->irq;
-                adv_dvc_varp->cfg->pci_dev = pci_devp;
                 adv_dvc_varp->cfg->pci_slot_info =
                     ASC_PCI_MKID(pci_devp->bus->number,
                         PCI_SLOT(pci_devp->devfn),
@@ -5880,7 +5885,7 @@
     default:
         done_scp = asc_dequeue_list(&boardp->done, NULL, ASC_TID_ALL);
         /* Interrupts could be enabled here. */
-        asc_scsi_done_list(done_scp, 0);
+        asc_scsi_done_list(done_scp);
         break;
     }
     spin_unlock_irqrestore(&boardp->lock, flags);
@@ -6063,7 +6068,7 @@
      * Complete all the 'done_scp' requests.
      */
     if (done_scp != NULL) {
-        asc_scsi_done_list(done_scp, 0);
+        asc_scsi_done_list(done_scp);
     }
 
     ASC_DBG1(1, "advansys_reset: ret %d\n", ret);
@@ -6328,7 +6333,7 @@
      * Complete all requests on the done list.
      */
 
-    asc_scsi_done_list(done_scp, 1);
+    asc_scsi_done_list(done_scp);
 
     ASC_DBG(1, "advansys_interrupt: end\n");
     return IRQ_HANDLED;
@@ -6374,23 +6379,38 @@
  * Interrupts can be enabled on entry.
  */
 STATIC void
-asc_scsi_done_list(Scsi_Cmnd *scp, int from_isr)
+asc_scsi_done_list(Scsi_Cmnd *scp)
 {
     Scsi_Cmnd    *tscp;
-    ulong	  flags = 0;
 
     ASC_DBG(2, "asc_scsi_done_list: begin\n");
     while (scp != NULL) {
+	asc_board_t *boardp;
+	struct device *dev;
+
         ASC_DBG1(3, "asc_scsi_done_list: scp 0x%lx\n", (ulong) scp);
         tscp = REQPNEXT(scp);
         scp->host_scribble = NULL;
+
+	boardp = ASC_BOARDP(scp->device->host);
+
+	if (ASC_NARROW_BOARD(boardp))
+	    dev = boardp->dvc_cfg.asc_dvc_cfg.dev;
+	else
+	    dev = boardp->dvc_cfg.adv_dvc_cfg.dev;
+
+	if (scp->use_sg)
+	    dma_unmap_sg(dev, (struct scatterlist *)scp->request_buffer,
+			 scp->use_sg, scp->sc_data_direction);
+	else if (scp->request_bufflen)
+	    dma_unmap_single(dev, scp->SCp.dma_handle,
+			     scp->request_bufflen, scp->sc_data_direction);
+
         ASC_STATS(scp->device->host, done);
         ASC_ASSERT(scp->scsi_done != NULL);
-	if (from_isr)
-	    spin_lock_irqsave(scp->device->host->host_lock, flags);
+
         scp->scsi_done(scp);
-	if (from_isr)
-	    spin_unlock_irqrestore(scp->device->host->host_lock, flags);
+
         scp = tscp;
     }
     ASC_DBG(2, "asc_scsi_done_list: done\n");
@@ -6619,6 +6639,8 @@
 STATIC int
 asc_build_req(asc_board_t *boardp, Scsi_Cmnd *scp)
 {
+    struct device *dev = boardp->dvc_cfg.asc_dvc_cfg.dev;
+
     /*
      * Mutually exclusive access is required to 'asc_scsi_q' and
      * 'asc_sg_head' until after the request is started.
@@ -6679,8 +6701,10 @@
          * CDB request of single contiguous buffer.
          */
         ASC_STATS(scp->device->host, cont_cnt);
-        asc_scsi_q.q1.data_addr =
-            cpu_to_le32(virt_to_bus(scp->request_buffer));
+	scp->SCp.dma_handle = scp->request_bufflen ?
+	    dma_map_single(dev, scp->request_buffer,
+			   scp->request_bufflen, scp->sc_data_direction) : 0;
+	asc_scsi_q.q1.data_addr = cpu_to_le32(scp->SCp.dma_handle);
         asc_scsi_q.q1.data_cnt = cpu_to_le32(scp->request_bufflen);
         ASC_STATS_ADD(scp->device->host, cont_xfer,
                       ASC_CEILING(scp->request_bufflen, 512));
@@ -6691,12 +6715,17 @@
          * CDB scatter-gather request list.
          */
         int                     sgcnt;
+	int			use_sg;
         struct scatterlist      *slp;
 
-        if (scp->use_sg > scp->device->host->sg_tablesize) {
+	slp = (struct scatterlist *)scp->request_buffer;
+	use_sg = dma_map_sg(dev, slp, scp->use_sg, scp->sc_data_direction);
+
+	if (use_sg > scp->device->host->sg_tablesize) {
             ASC_PRINT3(
 "asc_build_req: board %d: use_sg %d > sg_tablesize %d\n",
-                boardp->id, scp->use_sg, scp->device->host->sg_tablesize);
+		boardp->id, use_sg, scp->device->host->sg_tablesize);
+	    dma_unmap_sg(dev, slp, scp->use_sg, scp->sc_data_direction);
             scp->result = HOST_BYTE(DID_ERROR);
             asc_enqueue(&boardp->done, scp, ASC_BACK);
             return ASC_ERROR;
@@ -6715,19 +6744,16 @@
         asc_scsi_q.q1.data_cnt = 0;
         asc_scsi_q.q1.data_addr = 0;
         /* This is a byte value, otherwise it would need to be swapped. */
-        asc_sg_head.entry_cnt = asc_scsi_q.q1.sg_queue_cnt = scp->use_sg;
+	asc_sg_head.entry_cnt = asc_scsi_q.q1.sg_queue_cnt = use_sg;
         ASC_STATS_ADD(scp->device->host, sg_elem, asc_sg_head.entry_cnt);
 
         /*
          * Convert scatter-gather list into ASC_SG_HEAD list.
          */
-        slp = (struct scatterlist *) scp->request_buffer;
-        for (sgcnt = 0; sgcnt < scp->use_sg; sgcnt++, slp++) {
-            asc_sg_head.sg_list[sgcnt].addr =
-                cpu_to_le32(virt_to_bus(
-		(unsigned char *)page_address(slp->page) + slp->offset));
-            asc_sg_head.sg_list[sgcnt].bytes = cpu_to_le32(slp->length);
-            ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(slp->length, 512));
+	for (sgcnt = 0; sgcnt < use_sg; sgcnt++, slp++) {
+	    asc_sg_head.sg_list[sgcnt].addr = cpu_to_le32(sg_dma_address(slp));
+	    asc_sg_head.sg_list[sgcnt].bytes = cpu_to_le32(sg_dma_len(slp));
+	    ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(sg_dma_len(slp), 512));
         }
     }
 
@@ -6755,6 +6781,7 @@
     ADV_SCSI_REQ_Q      *scsiqp;
     int                 i;
     int                 ret;
+    struct device	*dev = boardp->dvc_cfg.adv_dvc_cfg.dev;
 
     /*
      * Allocate an adv_req_t structure from the board to execute
@@ -6827,15 +6854,23 @@
      * Build ADV_SCSI_REQ_Q for a contiguous buffer or a scatter-gather
      * buffer command.
      */
-    scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
-    scsiqp->vdata_addr = scp->request_buffer;
-    scsiqp->data_addr = cpu_to_le32(virt_to_bus(scp->request_buffer));
 
     if (scp->use_sg == 0) {
         /*
          * CDB request of single contiguous buffer.
          */
         reqp->sgblkp = NULL;
+	scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
+	if (scp->request_bufflen) {
+	    scsiqp->vdata_addr = scp->request_buffer;
+	    scp->SCp.dma_handle =
+	        dma_map_single(dev, scp->request_buffer,
+			       scp->request_bufflen, scp->sc_data_direction);
+	} else {
+	    scsiqp->vdata_addr = 0;
+	    scp->SCp.dma_handle = 0;
+	}
+	scsiqp->data_addr = cpu_to_le32(scp->SCp.dma_handle);
         scsiqp->sg_list_ptr = NULL;
         scsiqp->sg_real_addr = 0;
         ASC_STATS(scp->device->host, cont_cnt);
@@ -6845,10 +6880,21 @@
         /*
          * CDB scatter-gather request list.
          */
-        if (scp->use_sg > ADV_MAX_SG_LIST) {
+	struct scatterlist *slp;
+	int use_sg;
+
+	scsiqp->data_cnt = 0;
+	scsiqp->vdata_addr = 0;
+	scsiqp->data_addr = 0;
+
+	slp = (struct scatterlist *)scp->request_buffer;
+	use_sg = dma_map_sg(dev, slp, scp->use_sg, scp->sc_data_direction);
+
+	if (use_sg > ADV_MAX_SG_LIST) {
             ASC_PRINT3(
 "adv_build_req: board %d: use_sg %d > ADV_MAX_SG_LIST %d\n",
-                boardp->id, scp->use_sg, scp->device->host->sg_tablesize);
+		boardp->id, use_sg, scp->device->host->sg_tablesize);
+	    dma_unmap_sg(dev, slp, scp->use_sg, scp->sc_data_direction);
             scp->result = HOST_BYTE(DID_ERROR);
             asc_enqueue(&boardp->done, scp, ASC_BACK);
 
@@ -6862,7 +6908,7 @@
             return ASC_ERROR;
         }
 
-        if ((ret = adv_get_sglist(boardp, reqp, scp)) != ADV_SUCCESS) {
+	if ((ret = adv_get_sglist(boardp, reqp, scp, use_sg)) != ADV_SUCCESS) {
             /*
              * Free the adv_req_t structure by adding it back to the
              * board free list.
@@ -6874,7 +6920,7 @@
         }
 
         ASC_STATS(scp->device->host, sg_cnt);
-        ASC_STATS_ADD(scp->device->host, sg_elem, scp->use_sg);
+	ASC_STATS_ADD(scp->device->host, sg_elem, use_sg);
     }
 
     ASC_DBG_PRT_ADV_SCSI_REQ_Q(2, scsiqp);
@@ -6898,7 +6944,7 @@
  *      ADV_ERROR(-1) - SG List creation failed
  */
 STATIC int
-adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, Scsi_Cmnd *scp)
+adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, Scsi_Cmnd *scp, int use_sg)
 {
     adv_sgblk_t         *sgblkp;
     ADV_SCSI_REQ_Q      *scsiqp;
@@ -6910,7 +6956,7 @@
 
     scsiqp = (ADV_SCSI_REQ_Q *) ADV_32BALIGN(&reqp->scsi_req_q);
     slp = (struct scatterlist *) scp->request_buffer;
-    sg_elem_cnt = scp->use_sg;
+    sg_elem_cnt = use_sg;
     prev_sg_block = NULL;
     reqp->sgblkp = NULL;
 
@@ -6982,11 +7028,9 @@
 
         for (i = 0; i < NO_OF_SG_PER_BLOCK; i++)
         {
-            sg_block->sg_list[i].sg_addr =
-                cpu_to_le32(virt_to_bus(
-                   (unsigned char *)page_address(slp->page) + slp->offset));
-            sg_block->sg_list[i].sg_count = cpu_to_le32(slp->length);
-            ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(slp->length, 512));
+	    sg_block->sg_list[i].sg_addr = cpu_to_le32(sg_dma_address(slp));
+	    sg_block->sg_list[i].sg_count = cpu_to_le32(sg_dma_len(slp));
+	    ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(sg_dma_len(slp), 512));
 
             if (--sg_elem_cnt == 0)
             {   /* Last ADV_SG_BLOCK and scatter-gather entry. */
@@ -9011,7 +9055,7 @@
 {
 #ifdef CONFIG_PCI
     uchar byte_data;
-    pci_read_config_byte(asc_dvc->cfg->pci_dev, offset, &byte_data);
+    pci_read_config_byte(to_pci_dev(asc_dvc->cfg->dev), offset, &byte_data);
     return byte_data;
 #else /* !defined(CONFIG_PCI) */
     return 0;
@@ -9030,7 +9074,7 @@
 )
 {
 #ifdef CONFIG_PCI
-    pci_write_config_byte(asc_dvc->cfg->pci_dev, offset, byte_data);
+    pci_write_config_byte(to_pci_dev(asc_dvc->cfg->dev), offset, byte_data);
 #endif /* CONFIG_PCI */
 }
 
@@ -9128,7 +9172,7 @@
 {
 #ifdef CONFIG_PCI
     uchar byte_data;
-    pci_read_config_byte(asc_dvc->cfg->pci_dev, offset, &byte_data);
+    pci_read_config_byte(to_pci_dev(asc_dvc->cfg->dev), offset, &byte_data);
     return byte_data;
 #else /* CONFIG_PCI */
     return 0;
@@ -9147,7 +9191,7 @@
 )
 {
 #ifdef CONFIG_PCI
-    pci_write_config_byte(asc_dvc->cfg->pci_dev, offset, byte_data);
+    pci_write_config_byte(to_pci_dev(asc_dvc->cfg->dev), offset, byte_data);
 #else /* CONFIG_PCI */
     return 0;
 #endif /* CONFIG_PCI */
@@ -9507,7 +9551,8 @@
 
     printk(
 " pci_device_id %d, lib_serial_no %u, lib_version %u, mcode_date 0x%x,\n",
-          h->pci_dev->device, h->lib_serial_no, h->lib_version, h->mcode_date);
+	   to_pci_dev(h->dev)->device, h->lib_serial_no, h->lib_version,
+	   h->mcode_date);
 
     printk(
 " mcode_version %d, overrun_buf 0x%lx\n",
@@ -9632,7 +9677,7 @@
 
     printk(
 "  mcode_version 0x%x, pci_device_id 0x%x, lib_version %u\n",
-       h->mcode_version, h->pci_dev->device, h->lib_version);
+       h->mcode_version, to_pci_dev(h->dev)->device, h->lib_version);
 
     printk(
 "  control_flag 0x%x, pci_slot_info 0x%x\n",
@@ -12301,7 +12346,7 @@
     ushort              pci_device_id;
 
     iop_base = asc_dvc->iop_base;
-    pci_device_id = asc_dvc->cfg->pci_dev->device;
+    pci_device_id = to_pci_dev(asc_dvc->cfg->dev)->device;
     warn_code = 0;
     cfg_msw = AscGetChipCfgMsw(iop_base);
     if ((cfg_msw & ASC_CFG_MSW_CLR_MASK) != 0) {


