From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [ADVANSYS] Add basic highmem/DMA support
Date: Sat, 8 May 2004 10:39:06 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040508003906.GA26338@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from arnor.apana.org.au ([203.14.152.115]:23059 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S263944AbUEHAj2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 20:39:28 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, support@connectcom.net


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi:

This patch adds basic support for highmem on i386 to the advansys driver.

Cheers,
-- 
Debian GNU/Linux 3.0 is out! ( http://www.debian.org/ )
Email:  Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=p

Index: drivers/scsi/advansys.c
===================================================================
RCS file: /home/gondolin/herbert/src/CVS/debian/kernel-source-2.5/drivers/scsi/advansys.c,v
retrieving revision 1.9
diff -u -r1.9 advansys.c
--- a/drivers/scsi/advansys.c	19 Feb 2004 09:55:53 -0000	1.9
+++ b/drivers/scsi/advansys.c	7 May 2004 22:30:16 -0000
@@ -801,6 +801,7 @@
 #include <linux/blkdev.h>
 #include <linux/stat.h>
 #include <linux/spinlock.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
@@ -4214,7 +4215,7 @@
 STATIC int        asc_execute_scsi_cmnd(Scsi_Cmnd *);
 STATIC int        asc_build_req(asc_board_t *, Scsi_Cmnd *);
 STATIC int        adv_build_req(asc_board_t *, Scsi_Cmnd *, ADV_SCSI_REQ_Q **);
-STATIC int        adv_get_sglist(asc_board_t *, adv_req_t *, Scsi_Cmnd *);
+STATIC int        adv_get_sglist(asc_board_t *, adv_req_t *, Scsi_Cmnd *, int);
 STATIC void       asc_isr_callback(ASC_DVC_VAR *, ASC_QDONE_INFO *);
 STATIC void       adv_isr_callback(ADV_DVC_VAR *, ADV_SCSI_REQ_Q *);
 STATIC void       adv_async_callback(ADV_DVC_VAR *, uchar);
@@ -6381,9 +6382,30 @@
 
     ASC_DBG(2, "asc_scsi_done_list: begin\n");
     while (scp != NULL) {
+	asc_board_t *boardp;
+	struct pci_dev *pci_dev;
+	int dir;
+
         ASC_DBG1(3, "asc_scsi_done_list: scp 0x%lx\n", (ulong) scp);
         tscp = REQPNEXT(scp);
         scp->host_scribble = NULL;
+
+	boardp = ASC_BOARDP(scp->device->host);
+
+	if (ASC_NARROW_BOARD(boardp))
+	    pci_dev = boardp->dvc_cfg.asc_dvc_cfg.pci_dev;
+	else
+	    pci_dev = boardp->dvc_cfg.adv_dvc_cfg.pci_dev;
+
+	dir = scsi_to_pci_dma_dir(scp->sc_data_direction);
+
+	if (scp->use_sg)
+	    pci_unmap_sg(pci_dev, (struct scatterlist *)scp->request_buffer,
+			 scp->use_sg, dir);
+	else if (scp->request_bufflen)
+	    pci_unmap_single(pci_dev, scp->SCp.dma_handle,
+			     scp->request_bufflen, dir);
+
         ASC_STATS(scp->device->host, done);
         ASC_ASSERT(scp->scsi_done != NULL);
 	if (from_isr)
@@ -6619,6 +6641,9 @@
 STATIC int
 asc_build_req(asc_board_t *boardp, Scsi_Cmnd *scp)
 {
+    struct pci_dev *pci_dev = boardp->dvc_cfg.asc_dvc_cfg.pci_dev;
+    int dir = scsi_to_pci_dma_dir(scp->sc_data_direction);
+
     /*
      * Mutually exclusive access is required to 'asc_scsi_q' and
      * 'asc_sg_head' until after the request is started.
@@ -6679,8 +6704,10 @@
          * CDB request of single contiguous buffer.
          */
         ASC_STATS(scp->device->host, cont_cnt);
-        asc_scsi_q.q1.data_addr =
-            cpu_to_le32(virt_to_bus(scp->request_buffer));
+	scp->SCp.dma_handle = scp->request_bufflen ?
+	    pci_map_single(pci_dev, scp->request_buffer,
+			   scp->request_bufflen, dir) : 0;
+	asc_scsi_q.q1.data_addr = cpu_to_le32(scp->SCp.dma_handle);
         asc_scsi_q.q1.data_cnt = cpu_to_le32(scp->request_bufflen);
         ASC_STATS_ADD(scp->device->host, cont_xfer,
                       ASC_CEILING(scp->request_bufflen, 512));
@@ -6691,12 +6718,17 @@
          * CDB scatter-gather request list.
          */
         int                     sgcnt;
+	int			use_sg;
         struct scatterlist      *slp;
 
-        if (scp->use_sg > scp->device->host->sg_tablesize) {
+	slp = (struct scatterlist *)scp->request_buffer;
+	use_sg = pci_map_sg(pci_dev, slp, scp->use_sg, dir);
+
+	if (use_sg > scp->device->host->sg_tablesize) {
             ASC_PRINT3(
 "asc_build_req: board %d: use_sg %d > sg_tablesize %d\n",
-                boardp->id, scp->use_sg, scp->device->host->sg_tablesize);
+		boardp->id, use_sg, scp->device->host->sg_tablesize);
+	    pci_unmap_sg(pci_dev, slp, scp->use_sg, dir);
             scp->result = HOST_BYTE(DID_ERROR);
             asc_enqueue(&boardp->done, scp, ASC_BACK);
             return ASC_ERROR;
@@ -6715,19 +6747,16 @@
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
 
@@ -6755,6 +6784,8 @@
     ADV_SCSI_REQ_Q      *scsiqp;
     int                 i;
     int                 ret;
+    struct pci_dev	*pci_dev = boardp->dvc_cfg.adv_dvc_cfg.pci_dev;
+    int			dir = scsi_to_pci_dma_dir(scp->sc_data_direction);
 
     /*
      * Allocate an adv_req_t structure from the board to execute
@@ -6827,15 +6858,23 @@
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
+	        pci_map_single(pci_dev, scp->request_buffer,
+			       scp->request_bufflen, dir);
+	} else {
+	    scsiqp->vdata_addr = 0;
+	    scp->SCp.dma_handle = 0;
+	}
+	scsiqp->data_addr = cpu_to_le32(scp->SCp.dma_handle);
         scsiqp->sg_list_ptr = NULL;
         scsiqp->sg_real_addr = 0;
         ASC_STATS(scp->device->host, cont_cnt);
@@ -6845,10 +6884,21 @@
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
+	use_sg = pci_map_sg(pci_dev, slp, scp->use_sg, dir);
+
+	if (use_sg > ADV_MAX_SG_LIST) {
             ASC_PRINT3(
 "adv_build_req: board %d: use_sg %d > ADV_MAX_SG_LIST %d\n",
-                boardp->id, scp->use_sg, scp->device->host->sg_tablesize);
+		boardp->id, use_sg, scp->device->host->sg_tablesize);
+	    pci_unmap_sg(pci_dev, slp, scp->use_sg, dir);
             scp->result = HOST_BYTE(DID_ERROR);
             asc_enqueue(&boardp->done, scp, ASC_BACK);
 
@@ -6862,7 +6912,7 @@
             return ASC_ERROR;
         }
 
-        if ((ret = adv_get_sglist(boardp, reqp, scp)) != ADV_SUCCESS) {
+	if ((ret = adv_get_sglist(boardp, reqp, scp, use_sg)) != ADV_SUCCESS) {
             /*
              * Free the adv_req_t structure by adding it back to the
              * board free list.
@@ -6874,7 +6924,7 @@
         }
 
         ASC_STATS(scp->device->host, sg_cnt);
-        ASC_STATS_ADD(scp->device->host, sg_elem, scp->use_sg);
+	ASC_STATS_ADD(scp->device->host, sg_elem, use_sg);
     }
 
     ASC_DBG_PRT_ADV_SCSI_REQ_Q(2, scsiqp);
@@ -6898,7 +6948,7 @@
  *      ADV_ERROR(-1) - SG List creation failed
  */
 STATIC int
-adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, Scsi_Cmnd *scp)
+adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, Scsi_Cmnd *scp, int use_sg)
 {
     adv_sgblk_t         *sgblkp;
     ADV_SCSI_REQ_Q      *scsiqp;
@@ -6910,7 +6960,7 @@
 
     scsiqp = (ADV_SCSI_REQ_Q *) ADV_32BALIGN(&reqp->scsi_req_q);
     slp = (struct scatterlist *) scp->request_buffer;
-    sg_elem_cnt = scp->use_sg;
+    sg_elem_cnt = use_sg;
     prev_sg_block = NULL;
     reqp->sgblkp = NULL;
 
@@ -6982,11 +7032,9 @@
 
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

--G4iJoqBmSsgzjUCe--
