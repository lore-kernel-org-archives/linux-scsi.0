From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 16/22] advansys: Eliminate prototypes
Date: Mon, 17 Sep 2007 08:17:21 +0900
Message-ID: <20070915231931B.tomof@acm.org>
References: <20070916153134.GA28350@parisc-linux.org>
	<20070915224331U.tomof@acm.org>
	<20070916230349.GE28350@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:45790 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbXIPXRb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Sep 2007 19:17:31 -0400
In-Reply-To: <20070916230349.GE28350@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: tomof@acm.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sun, 16 Sep 2007 17:03:50 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Mon, Sep 17, 2007 at 07:41:06AM +0900, FUJITA Tomonori wrote:
> > On Sun, 16 Sep 2007 09:31:34 -0600
> > Matthew Wilcox <matthew@wil.cx> wrote:
> > 
> > > On Sat, Sep 15, 2007 at 09:39:05AM -0500, James Bottomley wrote:
> > > > I get a compile failure at this point in your patch sequence:
> > > 
> > > Thanks.  I'd been compiling with CONFIG_ISA=n, so hadn't spotted these
> > > two problems.  I've set it back to Y now.
> > 
> > If I compile your latest patchset with CONFIG_ISA=n, I got:
> > 
> > drivers/built-in.o: In function `advansys_init':
> > advansys.c:(.init.text+0x3efb): undefined reference to `isa_register_driver'
> > advansys.c:(.init.text+0x3f22): undefined reference to `isa_unregister_driver'
> 
> Fixed by http://marc.info/?l=linux-kernel&m=118780055118323&w=2 which I
> thought was in -mm, but I can't find it.  I've just reset it to Linus &
> Andrew.  Thanks for mentioning it.

Oh, I see.


> Now I'm back home, I'll add your sg patch to my tree.  I'd forgotten
> about it ...

I updated the previous patch for your latest patchset. I removed the
sg chaining support so you can send it to scsi-misc now.

Just a one-line patch is necessary for the sg chaining support. It'll
be push to mainline via Jens' tree.


From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] advansys: convert to use the data buffer accessors

- remove the unnecessary map_single path.

- convert to use the new accessors for the sg lists and the
parameters.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/advansys.c |   83 +++++++++++++---------------------------------
 1 files changed, 24 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index bd5bbc9..bc24f74 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4301,15 +4301,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 
 static void asc_scsi_done(struct scsi_cmnd *scp)
 {
-	struct asc_board *boardp = shost_priv(scp->device->host);
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
 
@@ -8210,11 +8202,11 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 		 * then return the number of underrun bytes.
 		 */
 		resid_cnt = le32_to_cpu(scsiqp->data_cnt);
-		if (scp->request_bufflen != 0 && resid_cnt != 0 &&
-		    resid_cnt <= scp->request_bufflen) {
+		if (scsi_bufflen(scp) != 0 && resid_cnt != 0 &&
+		    resid_cnt <= scsi_bufflen(scp)) {
 			ASC_DBG(1, "underrun condition %lu bytes\n",
 				 (ulong)resid_cnt);
-			scp->resid = resid_cnt;
+			scsi_set_resid(scp, resid_cnt);
 		}
 		break;
 
@@ -9877,6 +9869,7 @@ static int advansys_slave_configure(struct scsi_device *sdev)
 static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 			struct asc_scsi_q *asc_scsi_q)
 {
+	int use_sg;
 	memset(asc_scsi_q, 0, sizeof(*asc_scsi_q));
 
 	/*
@@ -9919,40 +9912,28 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
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
+		scp->SCp.dma_handle = 0;
 		ASC_STATS_ADD(scp->device->host, cont_xfer,
 			      ASC_CEILING(scp->request_bufflen, 512));
-		asc_scsi_q->q1.sg_queue_cnt = 0;
-		asc_scsi_q->sg_head = NULL;
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
 			scmd_printk(KERN_ERR, scp, "use_sg %d > "
 				"sg_tablesize %d\n", use_sg,
 				scp->device->host->sg_tablesize);
-			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
-				     scp->sc_data_direction);
+			scsi_dma_unmap(scp);
 			scp->result = HOST_BYTE(DID_ERROR);
 			return ASC_ERROR;
 		}
@@ -9962,8 +9943,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 		asc_sg_head = kzalloc(sizeof(asc_scsi_q->sg_head) +
 			use_sg * sizeof(struct asc_sg_list), GFP_ATOMIC);
 		if (!asc_sg_head) {
-			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
-				     scp->sc_data_direction);
+			scsi_dma_unmap(scp);
 			scp->result = HOST_BYTE(DID_SOFT_ERROR);
 			return ASC_ERROR;
 		}
@@ -9980,7 +9960,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 		/*
 		 * Convert scatter-gather list into ASC_SG_HEAD list.
 		 */
-		for (sgcnt = 0; sgcnt < use_sg; sgcnt++, slp++) {
+		scsi_for_each_sg(scp, slp, use_sg, sgcnt) {
 			asc_sg_head->sg_list[sgcnt].addr =
 			    cpu_to_le32(sg_dma_address(slp));
 			asc_sg_head->sg_list[sgcnt].bytes =
@@ -10021,7 +10001,7 @@ adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 	int i;
 
 	scsiqp = (ADV_SCSI_REQ_Q *)ADV_32BALIGN(&reqp->scsi_req_q);
-	slp = (struct scatterlist *)scp->request_buffer;
+	slp = scsi_sglist(scp);
 	sg_elem_cnt = use_sg;
 	prev_sg_block = NULL;
 	reqp->sgblkp = NULL;
@@ -10126,6 +10106,7 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	ADV_SCSI_REQ_Q *scsiqp;
 	int i;
 	int ret;
+	int use_sg;
 
 	/*
 	 * Allocate an adv_req_t structure from the board to execute
@@ -10187,49 +10168,33 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	 * buffer command.
 	 */
 
-	scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
-	scsiqp->vdata_addr = scp->request_buffer;
-	scsiqp->data_addr = cpu_to_le32(virt_to_bus(scp->request_buffer));
-
-	if (scp->use_sg == 0) {
+	scsiqp->data_cnt = cpu_to_le32(scsi_bufflen(scp));
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
+
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
 			scmd_printk(KERN_ERR, scp, "use_sg %d > "
 				   "ADV_MAX_SG_LIST %d\n", use_sg,
 				   scp->device->host->sg_tablesize);
-			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
-				     scp->sc_data_direction);
+			scsi_dma_unmap(scp);
 			scp->result = HOST_BYTE(DID_ERROR);
 
 			/*
-- 
1.5.2.4

