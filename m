From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH 0/3] iscsi bidi & varlen support
Date: Tue, 12 Feb 2008 15:12:39 -0500
Message-ID: <20080212201239.GB12532@osc.edu>
References: <47A20E85.6040906@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:51031 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480AbYBLUMm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 15:12:42 -0500
Content-Disposition: inline
In-Reply-To: <47A20E85.6040906@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, Benny Halevy <bhalevy@panasas.com>, Daniel.E.Messinger@seagate.com, Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>

bharrosh@panasas.com wrote on Thu, 31 Jan 2008 20:08 +0200:
> Cheers after 1.3 years these can go in.
> 
> [PATCH 1/3] iscsi: extended cdb support
>    The varlen support is not yet in mainline for
>   block and scsi-ml. But the API for drivers will
>   not change. All LLD need to do is max_command to
>   the it's maximum and be ready for bigger commands.
>   This is what's done here. Once these commands start
>   coming iscsi will be ready for them.
> 
> [PATCH 2/3] iscsi: bidi support - libiscsi
> [PATCH 3/3] iscsi: bidi support - iscsi_tcp
>   bidirectional commands support in iscsi.
>   iSER is not yet ready, but it will not break.
>   There is already a mechanism in libiscsi that will
>   return error if bidi commands are sent iSER way.
> 
> Pete please send me the iSER bits so we can port them
> to this latest version.
> 
> Mike these patches are ontop of iscs branch of the iscsi
> git tree, they will apply but for compilation you will need
> to sync with Linus mainline. The patches are for the in-tree
> iscsi code. I own you the compat patch for the out-off-tree
> code, but this I will only be Sunday.
> 
> If we do it fast it might get accepted to 2.6.25 merge window
> 
> Everybody is invited to a party at Shila ben-yhuda 52 Tel-Aviv
> 9:45 pm. Drinks and wonderful see-food on us :)

Here's the patch to add bidi support to iSER too.  It works
with my setup, but could use more testing.  Note that this does
rely on the 3 patches quoted above.

		-- Pete


From: Pete Wyckoff <pw@osc.edu>

Support bidirectional SCSI commands in iSCSI iSER.  The handling of
data buffers for each direction was already mostly separated.  It was
necessary to separate the unmapping of data bufs when one was found
to be unaligned.  This was done by adding a "direction" parameter to
iser_dma_unmap_task_data() and calling it appropriately.  Also
iser_ctask_rdma_finalize() used local variables in such a way that
it assumed a unidirectional command; that was split up to make it
cleaner and order the operations correctly for bidi.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    3 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |   79 +++++++++++---------------
 drivers/infiniband/ulp/iser/iser_memory.c    |    9 ++-
 3 files changed, 41 insertions(+), 50 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 66905df..f5497b0 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -356,5 +356,6 @@ int iser_dma_map_task_data(struct iscsi_iser_cmd_task *iser_ctask,
 			    enum   iser_data_dir       iser_dir,
 			    enum   dma_data_direction  dma_dir);
 
-void iser_dma_unmap_task_data(struct iscsi_iser_cmd_task *iser_ctask);
+void iser_dma_unmap_task_data(struct iscsi_iser_cmd_task *iser_ctask,
+			      enum iser_data_dir cmd_dir);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index ea3f5dc..491ffab 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -325,9 +325,8 @@ int iser_send_command(struct iscsi_conn     *conn,
 {
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
 	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
-	struct iser_dto *send_dto = NULL;
-	unsigned long edtl;
-	int err = 0;
+	struct iser_dto *send_dto;
+	int err;
 	struct iser_data_buf *data_buf;
 
 	struct iscsi_cmd *hdr =  ctask->hdr;
@@ -340,37 +339,32 @@ int iser_send_command(struct iscsi_conn     *conn,
 	if (iser_check_xmit(conn, ctask))
 		return -ENOBUFS;
 
-	edtl = ntohl(hdr->data_length);
-
 	/* build the tx desc regd header and add it to the tx desc dto */
 	iser_ctask->desc.type = ISCSI_TX_SCSI_COMMAND;
 	send_dto = &iser_ctask->desc.dto;
 	send_dto->ctask = iser_ctask;
 	iser_create_send_desc(iser_conn, &iser_ctask->desc, ctask->hdr_len);
 
-	if (hdr->flags & ISCSI_FLAG_CMD_READ)
-		data_buf = &iser_ctask->data[ISER_DIR_IN];
-	else
-		data_buf = &iser_ctask->data[ISER_DIR_OUT];
-
-	if (scsi_sg_count(sc)) { /* using a scatter list */
-		data_buf->buf  = scsi_sglist(sc);
-		data_buf->size = scsi_sg_count(sc);
-	}
-
-	data_buf->data_len = scsi_bufflen(sc);
-
 	if (hdr->flags & ISCSI_FLAG_CMD_READ) {
-		err = iser_prepare_read_cmd(ctask, edtl);
+		data_buf = &iser_ctask->data[ISER_DIR_IN];
+		data_buf->buf  = scsi_in(sc)->table.sgl;
+		data_buf->size = scsi_in(sc)->table.nents;
+		data_buf->data_len = scsi_in(sc)->length;
+		err = iser_prepare_read_cmd(ctask, data_buf->data_len);
 		if (err)
 			goto send_command_error;
 	}
+
 	if (hdr->flags & ISCSI_FLAG_CMD_WRITE) {
+		data_buf = &iser_ctask->data[ISER_DIR_OUT];
+		data_buf->buf  = scsi_out(sc)->table.sgl;
+		data_buf->size = scsi_out(sc)->table.nents;
+		data_buf->data_len = scsi_out(sc)->length;
 		err = iser_prepare_write_cmd(ctask,
 					     ctask->imm_count,
 				             ctask->imm_count +
 					     ctask->unsol_count,
-					     edtl);
+					     data_buf->data_len);
 		if (err)
 			goto send_command_error;
 	}
@@ -648,45 +642,40 @@ void iser_ctask_rdma_init(struct iscsi_iser_cmd_task *iser_ctask)
 	       sizeof(struct iser_regd_buf));
 }
 
-void iser_ctask_rdma_finalize(struct iscsi_iser_cmd_task *iser_ctask)
+static void iser_ctask_rdma_finalize_dir(struct iscsi_iser_cmd_task *iser_ctask,
+				         enum iser_data_dir cmd_dir)
 {
 	int deferred;
 	int is_rdma_aligned = 1;
 	struct iser_regd_buf *regd;
 
-	/* if we were reading, copy back to unaligned sglist,
-	 * anyway dma_unmap and free the copy
+	/*
+	 * If we were reading, copy back to unaligned sglist,
+	 * anyway dma_unmap and free the copy.
 	 */
-	if (iser_ctask->data_copy[ISER_DIR_IN].copy_buf != NULL) {
-		is_rdma_aligned = 0;
-		iser_finalize_rdma_unaligned_sg(iser_ctask, ISER_DIR_IN);
-	}
-	if (iser_ctask->data_copy[ISER_DIR_OUT].copy_buf != NULL) {
+	if (iser_ctask->data_copy[cmd_dir].copy_buf != NULL) {
 		is_rdma_aligned = 0;
-		iser_finalize_rdma_unaligned_sg(iser_ctask, ISER_DIR_OUT);
+		iser_finalize_rdma_unaligned_sg(iser_ctask, cmd_dir);
 	}
 
-	if (iser_ctask->dir[ISER_DIR_IN]) {
-		regd = &iser_ctask->rdma_regd[ISER_DIR_IN];
+	if (iser_ctask->dir[cmd_dir]) {
+		regd = &iser_ctask->rdma_regd[cmd_dir];
 		deferred = iser_regd_buff_release(regd);
-		if (deferred) {
-			iser_err("%d references remain for BUF-IN rdma reg\n",
-				 atomic_read(&regd->ref_count));
-		}
+		if (deferred)
+			iser_err("%d references remain for %s rdma reg\n",
+				 atomic_read(&regd->ref_count),
+				 cmd_dir == ISER_DIR_IN ? "IN" : "OUT");
 	}
 
-	if (iser_ctask->dir[ISER_DIR_OUT]) {
-		regd = &iser_ctask->rdma_regd[ISER_DIR_OUT];
-		deferred = iser_regd_buff_release(regd);
-		if (deferred) {
-			iser_err("%d references remain for BUF-OUT rdma reg\n",
-				 atomic_read(&regd->ref_count));
-		}
-	}
+	/* if the data was unaligned, it was already unmapped and then copied */
+	if (is_rdma_aligned)
+		iser_dma_unmap_task_data(iser_ctask, cmd_dir);
+}
 
-       /* if the data was unaligned, it was already unmapped and then copied */
-       if (is_rdma_aligned)
-		iser_dma_unmap_task_data(iser_ctask);
+void iser_ctask_rdma_finalize(struct iscsi_iser_cmd_task *iser_ctask)
+{
+	iser_ctask_rdma_finalize_dir(iser_ctask, ISER_DIR_IN);
+	iser_ctask_rdma_finalize_dir(iser_ctask, ISER_DIR_OUT);
 }
 
 void iser_dto_buffs_release(struct iser_dto *dto)
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 4a17743..aa3f299 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -393,19 +393,20 @@ int iser_dma_map_task_data(struct iscsi_iser_cmd_task *iser_ctask,
 	return 0;
 }
 
-void iser_dma_unmap_task_data(struct iscsi_iser_cmd_task *iser_ctask)
+void iser_dma_unmap_task_data(struct iscsi_iser_cmd_task *iser_ctask,
+			      enum iser_data_dir cmd_dir)
 {
 	struct ib_device *dev;
 	struct iser_data_buf *data;
 
 	dev = iser_ctask->iser_conn->ib_conn->device->ib_device;
 
-	if (iser_ctask->dir[ISER_DIR_IN]) {
+	if (cmd_dir == ISER_DIR_IN && iser_ctask->dir[ISER_DIR_IN]) {
 		data = &iser_ctask->data[ISER_DIR_IN];
 		ib_dma_unmap_sg(dev, data->buf, data->size, DMA_FROM_DEVICE);
 	}
 
-	if (iser_ctask->dir[ISER_DIR_OUT]) {
+	if (cmd_dir == ISER_DIR_OUT && iser_ctask->dir[ISER_DIR_OUT]) {
 		data = &iser_ctask->data[ISER_DIR_OUT];
 		ib_dma_unmap_sg(dev, data->buf, data->size, DMA_TO_DEVICE);
 	}
@@ -439,7 +440,7 @@ int iser_reg_rdma_mem(struct iscsi_iser_cmd_task *iser_ctask,
 		iser_data_buf_dump(mem, ibdev);
 
 		/* unmap the command data before accessing it */
-		iser_dma_unmap_task_data(iser_ctask);
+		iser_dma_unmap_task_data(iser_ctask, cmd_dir);
 
 		/* allocate copy buf, if we are writing, copy the */
 		/* unaligned scatterlist, dma map the copy        */
-- 
1.5.3.8

