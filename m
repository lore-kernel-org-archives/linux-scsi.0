From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [0/22] Advansys updates 2007-09-09
Date: Tue, 11 Sep 2007 05:00:27 +0900
Message-ID: <20070910051232R.tomof@acm.org>
References: <20070909145358.GG6809@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60354 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbXIJUBI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Sep 2007 16:01:08 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sun, 9 Sep 2007 08:53:58 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> Here's another mammoth patch series for the advansys driver against
> scsi-misc.  I've tested that it compiles at each stage and that the
> final result works.
> 
> Some important parts to note:
> 
> 1/22 Essential bugfix.  Please apply ASAP.
> 4/22 Reformat microcode.  Boring and large.
> 6,7,8,9/22 Remove internal queueing from driver
> 11/22 Allow advansys to accept 16-byte commands for wide boards
> 13/22 Remove some custom wrappers
> 15/22 Add DRV_NAME
> 16/22 Eliminate prototypes.  Boring and large.
> 19/22 Fix simultaneous calls to ->queuecommand

This is on the top of the patchset. Can I get your ACK on it?

This depends on scsi-misc, the patchset, and sg chaining stuff.

--
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] advansys: convert to use the data buffer accessors

- remove the unnecessary map_single path.

- convert to use the new accessors for the sg lists and the
parameters.

- add sg chaining support

Jens Axboe <jens.axboe@oracle.com> added sg chaining support.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/advansys.c |   93 +++++++++++++++--------------------------------
 1 files changed, 29 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index abad6d1..62b58a7 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4499,15 +4499,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 
 static void asc_scsi_done(struct scsi_cmnd *scp)
 {
-	struct asc_board *boardp = ASC_BOARDP(scp->device->host);
-
-	if (scp->use_sg)
-		dma_unmap_sg(boardp->dev,
-			     (struct scatterlist *)scp->request_buffer,
-			     scp->use_sg, scp->sc_data_direction);
-	else if (scp->request_bufflen)
-		dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
-				 scp->request_bufflen, scp->sc_data_direction);
+	scsi_dma_unmap(scp);
 
 	ASC_STATS(scp->device->host, done);
 
@@ -8460,12 +8452,12 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 		 * then return the number of underrun bytes.
 		 */
 		resid_cnt = le32_to_cpu(scsiqp->data_cnt);
-		if (scp->request_bufflen != 0 && resid_cnt != 0 &&
-		    resid_cnt <= scp->request_bufflen) {
+		if (scsi_bufflen(scp) != 0 && resid_cnt != 0 &&
+		    resid_cnt <= scsi_bufflen(scp)) {
 			ASC_DBG1(1,
 				 "adv_isr_callback: underrun condition %lu bytes\n",
 				 (ulong)resid_cnt);
-			scp->resid = resid_cnt;
+			scsi_set_resid(scp, resid_cnt);
 		}
 		break;
 
@@ -9410,12 +9402,12 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 		 * If there was no error and an underrun condition, then
 		 * return the number of underrun bytes.
 		 */
-		if (scp->request_bufflen != 0 && qdonep->remain_bytes != 0 &&
-		    qdonep->remain_bytes <= scp->request_bufflen) {
+		if (scsi_bufflen(scp) != 0 && qdonep->remain_bytes != 0 &&
+		    qdonep->remain_bytes <= scsi_bufflen(scp)) {
 			ASC_DBG1(1,
 				 "asc_isr_callback: underrun condition %u bytes\n",
 				 (unsigned)qdonep->remain_bytes);
-			scp->resid = qdonep->remain_bytes;
+			scsi_set_resid(scp, qdonep->remain_bytes);
 		}
 		break;
 
@@ -10147,6 +10139,8 @@ static int advansys_slave_configure(struct scsi_device *sdev)
 static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 			struct asc_scsi_q *asc_scsi_q)
 {
+	int use_sg;
+
 	memset(asc_scsi_q, 0, sizeof(*asc_scsi_q));
 
 	/*
@@ -10189,40 +10183,27 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 	 * Build ASC_SCSI_Q for a contiguous buffer or a scatter-gather
 	 * buffer command.
 	 */
-	if (scp->use_sg == 0) {
+	use_sg = scsi_dma_map(scp);
+	if (use_sg == 0) {
 		/*
 		 * CDB request of single contiguous buffer.
 		 */
 		ASC_STATS(scp->device->host, cont_cnt);
-		scp->SCp.dma_handle = scp->request_bufflen ?
-		    dma_map_single(boardp->dev, scp->request_buffer,
-				   scp->request_bufflen,
-				   scp->sc_data_direction) : 0;
-		asc_scsi_q->q1.data_addr = cpu_to_le32(scp->SCp.dma_handle);
-		asc_scsi_q->q1.data_cnt = cpu_to_le32(scp->request_bufflen);
-		ASC_STATS_ADD(scp->device->host, cont_xfer,
-			      ASC_CEILING(scp->request_bufflen, 512));
-		asc_scsi_q->q1.sg_queue_cnt = 0;
-		asc_scsi_q->sg_head = NULL;
+		scp->SCp.dma_handle = 0;
+		ASC_STATS_ADD(scp->device->host, cont_xfer, 0);
 	} else {
 		/*
 		 * CDB scatter-gather request list.
 		 */
 		int sgcnt;
-		int use_sg;
 		struct scatterlist *slp;
 		struct asc_sg_head *asc_sg_head;
 
-		slp = (struct scatterlist *)scp->request_buffer;
-		use_sg = dma_map_sg(boardp->dev, slp, scp->use_sg,
-				    scp->sc_data_direction);
-
 		if (use_sg > scp->device->host->sg_tablesize) {
 			ASC_PRINT3("asc_build_req: board %d: use_sg %d > "
 				   "sg_tablesize %d\n", boardp->id, use_sg,
 				   scp->device->host->sg_tablesize);
-			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
-				     scp->sc_data_direction);
+			scsi_dma_unmap(scp);
 			scp->result = HOST_BYTE(DID_ERROR);
 			return ASC_ERROR;
 		}
@@ -10232,8 +10213,7 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 		asc_sg_head = kzalloc(sizeof(asc_scsi_q->sg_head) +
 			use_sg * sizeof(struct asc_sg_list), GFP_ATOMIC);
 		if (!asc_sg_head) {
-			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
-				     scp->sc_data_direction);
+			scsi_dma_unmap(scp);
 			scp->result = HOST_BYTE(DID_SOFT_ERROR);
 			return ASC_ERROR;
 		}
@@ -10250,7 +10230,7 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 		/*
 		 * Convert scatter-gather list into ASC_SG_HEAD list.
 		 */
-		for (sgcnt = 0; sgcnt < use_sg; sgcnt++, slp++) {
+		scsi_for_each_sg(scp, slp, use_sg, sgcnt) {
 			asc_sg_head->sg_list[sgcnt].addr =
 			    cpu_to_le32(sg_dma_address(slp));
 			asc_sg_head->sg_list[sgcnt].bytes =
@@ -10291,7 +10271,7 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 	int i;
 
 	scsiqp = (ADV_SCSI_REQ_Q *)ADV_32BALIGN(&reqp->scsi_req_q);
-	slp = (struct scatterlist *)scp->request_buffer;
+	slp = scsi_sglist(scp);
 	sg_elem_cnt = use_sg;
 	prev_sg_block = NULL;
 	reqp->sgblkp = NULL;
@@ -10371,7 +10351,7 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 				sg_block->sg_ptr = 0L;	/* Last ADV_SG_BLOCK in list. */
 				return ADV_SUCCESS;
 			}
-			slp++;
+			slp = sg_next(slp);
 		}
 		sg_block->sg_cnt = NO_OF_SG_PER_BLOCK;
 		prev_sg_block = sg_block;
@@ -10396,6 +10376,7 @@ adv_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 	ADV_SCSI_REQ_Q *scsiqp;
 	int i;
 	int ret;
+	int use_sg;
 
 	/*
 	 * Allocate an adv_req_t structure from the board to execute
@@ -10457,49 +10438,33 @@ adv_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 	 * buffer command.
 	 */
 
-	scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
-	scsiqp->vdata_addr = scp->request_buffer;
-	scsiqp->data_addr = cpu_to_le32(virt_to_bus(scp->request_buffer));
+	scsiqp->data_cnt = cpu_to_le32(scsi_bufflen(scp));
 
-	if (scp->use_sg == 0) {
+	use_sg = scsi_dma_map(scp);
+	if (use_sg == 0) {
 		/*
 		 * CDB request of single contiguous buffer.
 		 */
 		reqp->sgblkp = NULL;
-		scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
-		if (scp->request_bufflen) {
-			scsiqp->vdata_addr = scp->request_buffer;
-			scp->SCp.dma_handle =
-			    dma_map_single(boardp->dev, scp->request_buffer,
-					   scp->request_bufflen,
-					   scp->sc_data_direction);
-		} else {
-			scsiqp->vdata_addr = NULL;
-			scp->SCp.dma_handle = 0;
-		}
-		scsiqp->data_addr = cpu_to_le32(scp->SCp.dma_handle);
+		scsiqp->data_cnt = 0;
+		scsiqp->vdata_addr = NULL;
+		scp->SCp.dma_handle = 0;
+
+		scsiqp->data_addr = 0;
 		scsiqp->sg_list_ptr = NULL;
 		scsiqp->sg_real_addr = 0;
 		ASC_STATS(scp->device->host, cont_cnt);
-		ASC_STATS_ADD(scp->device->host, cont_xfer,
-			      ASC_CEILING(scp->request_bufflen, 512));
+		ASC_STATS_ADD(scp->device->host, cont_xfer, 0);
 	} else {
 		/*
 		 * CDB scatter-gather request list.
 		 */
-		struct scatterlist *slp;
-		int use_sg;
-
-		slp = (struct scatterlist *)scp->request_buffer;
-		use_sg = dma_map_sg(boardp->dev, slp, scp->use_sg,
-				    scp->sc_data_direction);
 
 		if (use_sg > ADV_MAX_SG_LIST) {
 			ASC_PRINT3("adv_build_req: board %d: use_sg %d > "
 				   "ADV_MAX_SG_LIST %d\n", boardp->id, use_sg,
 				   scp->device->host->sg_tablesize);
-			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
-				     scp->sc_data_direction);
+			scsi_dma_unmap(scp);
 			scp->result = HOST_BYTE(DID_ERROR);
 
 			/*
-- 
1.5.2.4

