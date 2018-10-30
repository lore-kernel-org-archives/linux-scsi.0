From: Christoph Hellwig <hch@lst.de>
Subject: Re: remove exofs and the T10 OSD code V2
Date: Tue, 30 Oct 2018 08:45:42 +0100
Message-ID: <20181030074542.GB24697@lst.de>
References: <20181027082019.20838-1-hch@lst.de> <f9423180-e0fc-efba-e759-dfa4725953ad@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f9423180-e0fc-efba-e759-dfa4725953ad@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, ooo@electrozaur.com, martin.petersen@oracle.com, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 29, 2018 at 02:42:12PM -0600, Jens Axboe wrote:
> LGTM, for both:

I also have this one on top as requested by Martin.  The core block
bidi support is unfortunately also used by bsg-lib, although it is
not anywhere near as invasive.  But that is another argument for
looking into moving bsg-lib away from using block queues..

---
>From d6dd4f32798edd425a4df72f6125dba03e19d8c7 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sat, 27 Oct 2018 15:49:13 +0200
Subject: scsi: remove bidirectional command support

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/cxgbi/libcxgbi.c      | 13 ++---
 drivers/scsi/iscsi_tcp.c           |  9 +---
 drivers/scsi/libiscsi.c            | 64 +++---------------------
 drivers/scsi/libiscsi_tcp.c        |  8 +--
 drivers/scsi/scsi_debug.c          | 51 ++++---------------
 drivers/scsi/scsi_error.c          |  3 --
 drivers/scsi/scsi_lib.c            | 80 ++----------------------------
 drivers/scsi/virtio_scsi.c         | 14 ++----
 drivers/target/loopback/tcm_loop.c | 15 ------
 drivers/usb/storage/uas.c          | 11 +---
 include/scsi/scsi_cmnd.h           | 19 +------
 include/scsi/scsi_eh.h             |  1 -
 12 files changed, 35 insertions(+), 253 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 75f876409fb9..4466ae5c9a74 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1211,7 +1211,7 @@ scmd_get_params(struct scsi_cmnd *sc, struct scatterlist **sgl,
 		unsigned int *sgcnt, unsigned int *dlen,
 		unsigned int prot)
 {
-	struct scsi_data_buffer *sdb = prot ? scsi_prot(sc) : scsi_out(sc);
+	struct scsi_data_buffer *sdb = prot ? scsi_prot(sc) : &sc->sdb;
 
 	*sgl = sdb->table.sgl;
 	*sgcnt = sdb->table.nents;
@@ -1427,8 +1427,7 @@ static void task_release_itt(struct iscsi_task *task, itt_t hdr_itt)
 	log_debug(1 << CXGBI_DBG_DDP,
 		  "cdev 0x%p, task 0x%p, release tag 0x%x.\n",
 		  cdev, task, tag);
-	if (sc &&
-	    (scsi_bidi_cmnd(sc) || sc->sc_data_direction == DMA_FROM_DEVICE) &&
+	if (sc && sc->sc_data_direction == DMA_FROM_DEVICE &&
 	    cxgbi_ppm_is_ddp_tag(ppm, tag)) {
 		struct cxgbi_task_data *tdata = iscsi_task_cxgbi_data(task);
 		struct cxgbi_task_tag_info *ttinfo = &tdata->ttinfo;
@@ -1460,9 +1459,7 @@ static int task_reserve_itt(struct iscsi_task *task, itt_t *hdr_itt)
 	u32 tag = 0;
 	int err = -EINVAL;
 
-	if (sc &&
-	    (scsi_bidi_cmnd(sc) || sc->sc_data_direction == DMA_FROM_DEVICE)
-	) {
+	if (sc && sc->sc_data_direction == DMA_FROM_DEVICE) {
 		struct cxgbi_task_data *tdata = iscsi_task_cxgbi_data(task);
 		struct cxgbi_task_tag_info *ttinfo = &tdata->ttinfo;
 
@@ -1896,7 +1893,7 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 	if (SKB_MAX_HEAD(cdev->skb_tx_rsvd) > (512 * MAX_SKB_FRAGS) &&
 	    (opcode == ISCSI_OP_SCSI_DATA_OUT ||
 	     (opcode == ISCSI_OP_SCSI_CMD &&
-	      (scsi_bidi_cmnd(sc) || sc->sc_data_direction == DMA_TO_DEVICE))))
+	      sc->sc_data_direction == DMA_TO_DEVICE)))
 		/* data could goes into skb head */
 		headroom += min_t(unsigned int,
 				SKB_MAX_HEAD(cdev->skb_tx_rsvd),
@@ -1971,7 +1968,7 @@ int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 		return 0;
 
 	if (task->sc) {
-		struct scsi_data_buffer *sdb = scsi_out(task->sc);
+		struct scsi_data_buffer *sdb = &task->sc->sdb;
 		struct scatterlist *sg = NULL;
 		int err;
 
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 23354f206533..a78b46bb2b71 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -514,7 +514,7 @@ static int iscsi_sw_tcp_pdu_init(struct iscsi_task *task,
 	if (!task->sc)
 		iscsi_sw_tcp_send_linear_data_prep(conn, task->data, count);
 	else {
-		struct scsi_data_buffer *sdb = scsi_out(task->sc);
+		struct scsi_data_buffer *sdb = &task->sc->sdb;
 
 		err = iscsi_sw_tcp_send_data_prep(conn, sdb->table.sgl,
 						  sdb->table.nents, offset,
@@ -948,12 +948,6 @@ static umode_t iscsi_sw_tcp_attr_is_visible(int param_type, int param)
 	return 0;
 }
 
-static int iscsi_sw_tcp_slave_alloc(struct scsi_device *sdev)
-{
-	blk_queue_flag_set(QUEUE_FLAG_BIDI, sdev->request_queue);
-	return 0;
-}
-
 static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 {
 	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(sdev->host);
@@ -981,7 +975,6 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.use_clustering         = DISABLE_CLUSTERING,
-	.slave_alloc            = iscsi_sw_tcp_slave_alloc,
 	.slave_configure        = iscsi_sw_tcp_slave_configure,
 	.target_alloc		= iscsi_target_alloc,
 	.proc_name		= "iscsi_tcp",
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 93c66ebad907..a6dec983c30e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -218,32 +218,6 @@ static int iscsi_prep_ecdb_ahs(struct iscsi_task *task)
 	return 0;
 }
 
-static int iscsi_prep_bidi_ahs(struct iscsi_task *task)
-{
-	struct scsi_cmnd *sc = task->sc;
-	struct iscsi_rlength_ahdr *rlen_ahdr;
-	int rc;
-
-	rlen_ahdr = iscsi_next_hdr(task);
-	rc = iscsi_add_hdr(task, sizeof(*rlen_ahdr));
-	if (rc)
-		return rc;
-
-	rlen_ahdr->ahslength =
-		cpu_to_be16(sizeof(rlen_ahdr->read_length) +
-						  sizeof(rlen_ahdr->reserved));
-	rlen_ahdr->ahstype = ISCSI_AHSTYPE_RLENGTH;
-	rlen_ahdr->reserved = 0;
-	rlen_ahdr->read_length = cpu_to_be32(scsi_in(sc)->length);
-
-	ISCSI_DBG_SESSION(task->conn->session,
-			  "bidi-in rlen_ahdr->read_length(%d) "
-		          "rlen_ahdr->ahslength(%d)\n",
-		          be32_to_cpu(rlen_ahdr->read_length),
-		          be16_to_cpu(rlen_ahdr->ahslength));
-	return 0;
-}
-
 /**
  * iscsi_check_tmf_restrictions - check if a task is affected by TMF
  * @task: iscsi task
@@ -382,13 +356,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	memcpy(hdr->cdb, sc->cmnd, cmd_len);
 
 	task->imm_count = 0;
-	if (scsi_bidi_cmnd(sc)) {
-		hdr->flags |= ISCSI_FLAG_CMD_READ;
-		rc = iscsi_prep_bidi_ahs(task);
-		if (rc)
-			return rc;
-	}
-
 	if (scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
 		task->protected = true;
 
@@ -463,12 +430,10 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 
 	conn->scsicmd_pdus_cnt++;
 	ISCSI_DBG_SESSION(session, "iscsi prep [%s cid %d sc %p cdb 0x%x "
-			  "itt 0x%x len %d bidi_len %d cmdsn %d win %d]\n",
-			  scsi_bidi_cmnd(sc) ? "bidirectional" :
+			  "itt 0x%x len %d cmdsn %d win %d]\n",
 			  sc->sc_data_direction == DMA_TO_DEVICE ?
 			  "write" : "read", conn->id, sc, sc->cmnd[0],
 			  task->itt, transfer_length,
-			  scsi_bidi_cmnd(sc) ? scsi_in(sc)->length : 0,
 			  session->cmdsn,
 			  session->max_cmdsn - session->exp_cmdsn + 1);
 	return 0;
@@ -637,12 +602,7 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 		state = ISCSI_TASK_ABRT_TMF;
 
 	sc->result = err << 16;
-	if (!scsi_bidi_cmnd(sc))
-		scsi_set_resid(sc, scsi_bufflen(sc));
-	else {
-		scsi_out(sc)->resid = scsi_out(sc)->length;
-		scsi_in(sc)->resid = scsi_in(sc)->length;
-	}
+	scsi_set_resid(sc, scsi_bufflen(sc));
 
 	/* regular RX path uses back_lock */
 	spin_lock_bh(&conn->session->back_lock);
@@ -897,14 +857,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 	if (rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
 			   ISCSI_FLAG_CMD_BIDI_OVERFLOW)) {
-		int res_count = be32_to_cpu(rhdr->bi_residual_count);
-
-		if (scsi_bidi_cmnd(sc) && res_count > 0 &&
-				(rhdr->flags & ISCSI_FLAG_CMD_BIDI_OVERFLOW ||
-				 res_count <= scsi_in(sc)->length))
-			scsi_in(sc)->resid = res_count;
-		else
-			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
+		sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
 	}
 
 	if (rhdr->flags & (ISCSI_FLAG_CMD_UNDERFLOW |
@@ -951,8 +904,8 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 		if (res_count > 0 &&
 		    (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
-		     res_count <= scsi_in(sc)->length))
-			scsi_in(sc)->resid = res_count;
+		     res_count <= sc->sdb.length))
+			sc->sdb.resid = res_count;
 		else
 			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
 	}
@@ -1794,12 +1747,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
 			  sc->cmnd[0], reason);
-	if (!scsi_bidi_cmnd(sc))
-		scsi_set_resid(sc, scsi_bufflen(sc));
-	else {
-		scsi_out(sc)->resid = scsi_out(sc)->length;
-		scsi_in(sc)->resid = scsi_in(sc)->length;
-	}
+	scsi_set_resid(sc, scsi_bufflen(sc));
 	sc->scsi_done(sc);
 	return 0;
 }
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 4fcb9e65be57..1ec8332df515 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -491,7 +491,7 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct iscsi_data_rsp *rhdr = (struct iscsi_data_rsp *)tcp_conn->in.hdr;
 	int datasn = be32_to_cpu(rhdr->datasn);
-	unsigned total_in_length = scsi_in(task->sc)->length;
+	unsigned total_in_length = task->sc->sdb.length;
 
 	/*
 	 * lib iscsi will update this in the completion handling if there
@@ -576,11 +576,11 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 			      data_length, session->max_burst);
 
 	data_offset = be32_to_cpu(rhdr->data_offset);
-	if (data_offset + data_length > scsi_out(task->sc)->length) {
+	if (data_offset + data_length > task->sc->sdb.length) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", data_length,
-				  data_offset, scsi_out(task->sc)->length);
+				  data_offset, task->sc->sdb.length);
 		return ISCSI_ERR_DATALEN;
 	}
 
@@ -692,7 +692,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		if (tcp_conn->in.datalen) {
 			struct iscsi_tcp_task *tcp_task = task->dd_data;
 			struct ahash_request *rx_hash = NULL;
-			struct scsi_data_buffer *sdb = scsi_in(task->sc);
+			struct scsi_data_buffer *sdb = &task->sc->sdb;
 
 			/*
 			 * Setup copy of Data-In into the struct scsi_cmnd
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 60bcc6df97a9..98b212ec6240 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -430,7 +430,6 @@ static int resp_rsup_opcodes(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_rsup_tmfs(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_same_10(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_same_16(struct scsi_cmnd *, struct sdebug_dev_info *);
-static int resp_xdwriteread_10(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_comp_write(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_buffer(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_sync_cache(struct scsi_cmnd *, struct sdebug_dev_info *);
@@ -600,9 +599,6 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	{0, 0x42, 0, F_D_OUT | FF_MEDIA_IO, resp_unmap, NULL, /* UNMAP */
 	    {10,  0x1, 0, 0, 0, 0, 0x3f, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0} },
 /* 25 */
-	{0, 0x53, 0, F_D_IN | F_D_OUT | FF_MEDIA_IO, resp_xdwriteread_10,
-	    NULL, {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7,
-		   0, 0, 0, 0, 0, 0} },		/* XDWRITEREAD(10) */
 	{0, 0x3b, 0, F_D_OUT_MAYBE, resp_write_buffer, NULL,
 	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },			/* WRITE_BUFFER */
@@ -1010,11 +1006,11 @@ static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 				int arr_len)
 {
 	int act_len;
-	struct scsi_data_buffer *sdb = scsi_in(scp);
+	struct scsi_data_buffer *sdb = &scp->sdb;
 
 	if (!sdb->length)
 		return 0;
-	if (!(scsi_bidi_cmnd(scp) || scp->sc_data_direction == DMA_FROM_DEVICE))
+	if (scp->sc_data_direction != DMA_FROM_DEVICE)
 		return DID_ERROR << 16;
 
 	act_len = sg_copy_from_buffer(sdb->table.sgl, sdb->table.nents,
@@ -1033,12 +1029,12 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 				  int arr_len, unsigned int off_dst)
 {
 	int act_len, n;
-	struct scsi_data_buffer *sdb = scsi_in(scp);
+	struct scsi_data_buffer *sdb = &scp->sdb;
 	off_t skip = off_dst;
 
 	if (sdb->length <= off_dst)
 		return 0;
-	if (!(scsi_bidi_cmnd(scp) || scp->sc_data_direction == DMA_FROM_DEVICE))
+	if (scp->sc_data_direction != DMA_FROM_DEVICE)
 		return DID_ERROR << 16;
 
 	act_len = sg_pcopy_from_buffer(sdb->table.sgl, sdb->table.nents,
@@ -1058,7 +1054,7 @@ static int fetch_to_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 {
 	if (!scsi_bufflen(scp))
 		return 0;
-	if (!(scsi_bidi_cmnd(scp) || scp->sc_data_direction == DMA_TO_DEVICE))
+	if (scp->sc_data_direction != DMA_TO_DEVICE)
 		return -1;
 
 	return scsi_sg_copy_to_buffer(scp, arr, arr_len);
@@ -2477,21 +2473,19 @@ static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
 {
 	int ret;
 	u64 block, rest = 0;
-	struct scsi_data_buffer *sdb;
+	struct scsi_data_buffer *sdb = &scmd->sdb;
 	enum dma_data_direction dir;
 
 	if (do_write) {
-		sdb = scsi_out(scmd);
 		dir = DMA_TO_DEVICE;
 		write_since_sync = true;
 	} else {
-		sdb = scsi_in(scmd);
 		dir = DMA_FROM_DEVICE;
 	}
 
 	if (!sdb->length)
 		return 0;
-	if (!(scsi_bidi_cmnd(scmd) || scmd->sc_data_direction == dir))
+	if (scmd->sc_data_direction != dir)
 		return -1;
 
 	block = do_div(lba, sdebug_store_sectors);
@@ -2774,7 +2768,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 
-	scsi_in(scp)->resid = scsi_bufflen(scp) - ret;
+	scp->sdb.resid = scsi_bufflen(scp) - ret;
 
 	if (unlikely(sqcp)) {
 		if (sqcp->inj_recovered) {
@@ -3724,7 +3718,7 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 	int j;
 	unsigned char *kaddr, *buf;
 	unsigned int offset;
-	struct scsi_data_buffer *sdb = scsi_in(scp);
+	struct scsi_data_buffer *sdb = &scp->sdb;
 	struct sg_mapping_iter miter;
 
 	/* better not to use temporary buffer. */
@@ -3754,32 +3748,6 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 	return 0;
 }
 
-static int resp_xdwriteread_10(struct scsi_cmnd *scp,
-			       struct sdebug_dev_info *devip)
-{
-	u8 *cmd = scp->cmnd;
-	u64 lba;
-	u32 num;
-	int errsts;
-
-	if (!scsi_bidi_cmnd(scp)) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
-				INSUFF_RES_ASCQ);
-		return check_condition_result;
-	}
-	errsts = resp_read_dt0(scp, devip);
-	if (errsts)
-		return errsts;
-	if (!(cmd[1] & 0x4)) {		/* DISABLE_WRITE is not set */
-		errsts = resp_write_dt0(scp, devip);
-		if (errsts)
-			return errsts;
-	}
-	lba = get_unaligned_be32(cmd + 2);
-	num = get_unaligned_be16(cmd + 7);
-	return resp_xdwriteread(scp, lba, num, devip);
-}
-
 static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
 {
 	u32 tag = blk_mq_unique_tag(cmnd->request);
@@ -3953,7 +3921,6 @@ static int scsi_debug_slave_alloc(struct scsi_device *sdp)
 	if (sdebug_verbose)
 		pr_info("slave_alloc <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
-	blk_queue_flag_set(QUEUE_FLAG_BIDI, sdp->request_queue);
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c736d61b1648..42dd49961ca5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -965,7 +965,6 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->cmnd = scmd->cmnd;
 	ses->data_direction = scmd->sc_data_direction;
 	ses->sdb = scmd->sdb;
-	ses->next_rq = scmd->request->next_rq;
 	ses->result = scmd->result;
 	ses->underflow = scmd->underflow;
 	ses->prot_op = scmd->prot_op;
@@ -976,7 +975,6 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	scmd->cmnd = ses->eh_cmnd;
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
-	scmd->request->next_rq = NULL;
 	scmd->result = 0;
 
 	if (sense_bytes) {
@@ -1029,7 +1027,6 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->cmnd = ses->cmnd;
 	scmd->sc_data_direction = ses->data_direction;
 	scmd->sdb = ses->sdb;
-	scmd->request->next_rq = ses->next_rq;
 	scmd->result = ses->result;
 	scmd->underflow = ses->underflow;
 	scmd->prot_op = ses->prot_op;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c7fccbb8f554..cae0a5f7539d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -610,11 +610,6 @@ static void scsi_mq_free_sgtables(struct scsi_cmnd *cmd)
 
 	if (cmd->sdb.table.nents)
 		sg_free_table_chained(&cmd->sdb.table, true);
-	if (cmd->request->next_rq) {
-		sdb = cmd->request->next_rq->special;
-		if (sdb)
-			sg_free_table_chained(&sdb->table, true);
-	}
 	if (scsi_prot_sg_count(cmd))
 		sg_free_table_chained(&cmd->prot_sdb->table, true);
 }
@@ -653,18 +648,9 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 		sg_free_table_chained(&cmd->prot_sdb->table, false);
 }
 
-static void scsi_release_bidi_buffers(struct scsi_cmnd *cmd)
-{
-	struct scsi_data_buffer *bidi_sdb = cmd->request->next_rq->special;
-
-	sg_free_table_chained(&bidi_sdb->table, false);
-	kmem_cache_free(scsi_sdb_cache, bidi_sdb);
-	cmd->request->next_rq->special = NULL;
-}
-
 /* Returns false when no more bytes to process, true if there are more */
 static bool scsi_end_request(struct request *req, blk_status_t error,
-		unsigned int bytes, unsigned int bidi_bytes)
+		unsigned int bytes)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 	struct scsi_device *sdev = cmd->device;
@@ -673,11 +659,6 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	if (blk_update_request(req, error, bytes))
 		return true;
 
-	/* Bidi request must be completed as a whole */
-	if (unlikely(bidi_bytes) &&
-	    blk_update_request(req->next_rq, error, bidi_bytes))
-		return true;
-
 	if (blk_queue_add_random(q))
 		add_disk_randomness(req->rq_disk);
 
@@ -707,8 +688,6 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	} else {
 		unsigned long flags;
 
-		if (bidi_bytes)
-			scsi_release_bidi_buffers(cmd);
 		scsi_release_buffers(cmd);
 		scsi_put_command(cmd);
 
@@ -916,7 +895,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 				scsi_print_command(cmd);
 			}
 		}
-		if (!scsi_end_request(req, blk_stat, blk_rq_err_bytes(req), 0))
+		if (!scsi_end_request(req, blk_stat, blk_rq_err_bytes(req)))
 			return;
 		/*FALLTHRU*/
 	case ACTION_REPREP:
@@ -1051,29 +1030,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		 */
 		scsi_req(req)->result = cmd->result;
 		scsi_req(req)->resid_len = scsi_get_resid(cmd);
-
-		if (unlikely(scsi_bidi_cmnd(cmd))) {
-			/*
-			 * Bidi commands Must be complete as a whole,
-			 * both sides at once.
-			 */
-			scsi_req(req->next_rq)->resid_len = scsi_in(cmd)->resid;
-			if (scsi_end_request(req, BLK_STS_OK, blk_rq_bytes(req),
-					blk_rq_bytes(req->next_rq)))
-				WARN_ONCE(true,
-					  "Bidi command with remaining bytes");
-			return;
-		}
-	}
-
-	/* no bidi support yet, other than in pass-through */
-	if (unlikely(blk_bidi_rq(req))) {
-		WARN_ONCE(true, "Only support bidi command in passthrough");
-		scmd_printk(KERN_ERR, cmd, "Killing bidi command\n");
-		if (scsi_end_request(req, BLK_STS_IOERR, blk_rq_bytes(req),
-				     blk_rq_bytes(req->next_rq)))
-			WARN_ONCE(true, "Bidi command with remaining bytes");
-		return;
 	}
 
 	/*
@@ -1090,13 +1046,13 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 * to retry code. Fast path should return in this block.
 	 */
 	if (likely(blk_rq_bytes(req) > 0 || blk_stat == BLK_STS_OK)) {
-		if (likely(!scsi_end_request(req, blk_stat, good_bytes, 0)))
+		if (likely(!scsi_end_request(req, blk_stat, good_bytes)))
 			return; /* no bytes remaining */
 	}
 
 	/* Kill remainder if no retries. */
 	if (unlikely(blk_stat && scsi_noretry_cmd(cmd))) {
-		if (scsi_end_request(req, blk_stat, blk_rq_bytes(req), 0))
+		if (scsi_end_request(req, blk_stat, blk_rq_bytes(req)))
 			WARN_ONCE(true,
 			    "Bytes remaining after failed, no-retry command");
 		return;
@@ -1159,23 +1115,6 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 	if (error)
 		goto err_exit;
 
-	if (blk_bidi_rq(rq)) {
-		if (!rq->q->mq_ops) {
-			struct scsi_data_buffer *bidi_sdb =
-				kmem_cache_zalloc(scsi_sdb_cache, GFP_ATOMIC);
-			if (!bidi_sdb) {
-				error = BLKPREP_DEFER;
-				goto err_exit;
-			}
-
-			rq->next_rq->special = bidi_sdb;
-		}
-
-		error = scsi_init_sgtable(rq->next_rq, rq->next_rq->special);
-		if (error)
-			goto err_exit;
-	}
-
 	if (blk_integrity_rq(rq)) {
 		struct scsi_data_buffer *prot_sdb = cmd->prot_sdb;
 		int ivecs, count;
@@ -2026,17 +1965,6 @@ static int scsi_mq_prep_fn(struct request *req)
 			(struct scatterlist *)(cmd->prot_sdb + 1);
 	}
 
-	if (blk_bidi_rq(req)) {
-		struct request *next_rq = req->next_rq;
-		struct scsi_data_buffer *bidi_sdb = blk_mq_rq_to_pdu(next_rq);
-
-		memset(bidi_sdb, 0, sizeof(struct scsi_data_buffer));
-		bidi_sdb->table.sgl =
-			(struct scatterlist *)(bidi_sdb + 1);
-
-		next_rq->special = bidi_sdb;
-	}
-
 	blk_mq_start_request(req);
 
 	return scsi_setup_cmnd(sdev, req);
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 1c72db94270e..fd54c12a5ed3 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -127,16 +127,8 @@ static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
 
 static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
 {
-	if (!resid)
-		return;
-
-	if (!scsi_bidi_cmnd(sc)) {
+	if (resid)
 		scsi_set_resid(sc, resid);
-		return;
-	}
-
-	scsi_in(sc)->resid = min(resid, scsi_in(sc)->length);
-	scsi_out(sc)->resid = resid - scsi_in(sc)->resid;
 }
 
 /**
@@ -430,9 +422,9 @@ static int virtscsi_add_cmd(struct virtqueue *vq,
 
 	if (sc && sc->sc_data_direction != DMA_NONE) {
 		if (sc->sc_data_direction != DMA_FROM_DEVICE)
-			out = &scsi_out(sc)->table;
+			out = &sc->sdb.table;
 		if (sc->sc_data_direction != DMA_TO_DEVICE)
-			in = &scsi_in(sc)->table;
+			in = &sc->sdb.table;
 	}
 
 	/* Request header.  */
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index bc8918f382e4..a43bb76cccf6 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -128,14 +128,6 @@ static void tcm_loop_submission_work(struct work_struct *work)
 		set_host_byte(sc, DID_ERROR);
 		goto out_done;
 	}
-	if (scsi_bidi_cmnd(sc)) {
-		struct scsi_data_buffer *sdb = scsi_in(sc);
-
-		sgl_bidi = sdb->table.sgl;
-		sgl_bidi_count = sdb->table.nents;
-		se_cmd->se_cmd_flags |= SCF_BIDI;
-
-	}
 
 	transfer_length = scsi_transfer_length(sc);
 	if (!scsi_prot_sg_count(sc) &&
@@ -304,12 +296,6 @@ static int tcm_loop_target_reset(struct scsi_cmnd *sc)
 	return FAILED;
 }
 
-static int tcm_loop_slave_alloc(struct scsi_device *sd)
-{
-	blk_queue_flag_set(QUEUE_FLAG_BIDI, sd->request_queue);
-	return 0;
-}
-
 static struct scsi_host_template tcm_loop_driver_template = {
 	.show_info		= tcm_loop_show_info,
 	.proc_name		= "tcm_loopback",
@@ -325,7 +311,6 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.cmd_per_lun		= 1024,
 	.max_sectors		= 0xFFFF,
 	.use_clustering		= DISABLE_CLUSTERING,
-	.slave_alloc		= tcm_loop_slave_alloc,
 	.module			= THIS_MODULE,
 	.track_queue_depth	= 1,
 };
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 1f7b401c4d04..1c3bff3d57b0 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -368,25 +368,19 @@ static void uas_data_cmplt(struct urb *urb)
 	struct scsi_cmnd *cmnd = urb->context;
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
-	struct scsi_data_buffer *sdb = NULL;
+	struct scsi_data_buffer *sdb = &cmnd->sdb;
 	unsigned long flags;
 	int status = urb->status;
 
 	spin_lock_irqsave(&devinfo->lock, flags);
 
 	if (cmdinfo->data_in_urb == urb) {
-		sdb = scsi_in(cmnd);
 		cmdinfo->state &= ~DATA_IN_URB_INFLIGHT;
 		cmdinfo->data_in_urb = NULL;
 	} else if (cmdinfo->data_out_urb == urb) {
-		sdb = scsi_out(cmnd);
 		cmdinfo->state &= ~DATA_OUT_URB_INFLIGHT;
 		cmdinfo->data_out_urb = NULL;
 	}
-	if (sdb == NULL) {
-		WARN_ON_ONCE(1);
-		goto out;
-	}
 
 	if (devinfo->resetting)
 		goto out;
@@ -426,8 +420,7 @@ static struct urb *uas_alloc_data_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	struct usb_device *udev = devinfo->udev;
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	struct urb *urb = usb_alloc_urb(0, gfp);
-	struct scsi_data_buffer *sdb = (dir == DMA_FROM_DEVICE)
-		? scsi_in(cmnd) : scsi_out(cmnd);
+	struct scsi_data_buffer *sdb = &cmnd->sdb;
 	unsigned int pipe = (dir == DMA_FROM_DEVICE)
 		? devinfo->data_in_pipe : devinfo->data_out_pipe;
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index c891ada3c5c2..681f0ca808d7 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -209,23 +209,6 @@ static inline int scsi_get_resid(struct scsi_cmnd *cmd)
 #define scsi_for_each_sg(cmd, sg, nseg, __i)			\
 	for_each_sg(scsi_sglist(cmd), sg, nseg, __i)
 
-static inline int scsi_bidi_cmnd(struct scsi_cmnd *cmd)
-{
-	return blk_bidi_rq(cmd->request) &&
-		(cmd->request->next_rq->special != NULL);
-}
-
-static inline struct scsi_data_buffer *scsi_in(struct scsi_cmnd *cmd)
-{
-	return scsi_bidi_cmnd(cmd) ?
-		cmd->request->next_rq->special : &cmd->sdb;
-}
-
-static inline struct scsi_data_buffer *scsi_out(struct scsi_cmnd *cmd)
-{
-	return &cmd->sdb;
-}
-
 static inline int scsi_sg_copy_from_buffer(struct scsi_cmnd *cmd,
 					   void *buf, int buflen)
 {
@@ -347,7 +330,7 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
 
 static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 {
-	unsigned int xfer_len = scsi_out(scmd)->length;
+	unsigned int xfer_len = scmd->sdb.length;
 	unsigned int prot_interval = scsi_prot_interval(scmd);
 
 	if (scmd->prot_flags & SCSI_PROT_TRANSFER_PI)
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 2b7e227960e1..3810b340551c 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -39,7 +39,6 @@ struct scsi_eh_save {
 	unsigned char prot_op;
 	unsigned char *cmnd;
 	struct scsi_data_buffer sdb;
-	struct request *next_rq;
 	/* new command support */
 	unsigned char eh_cmnd[BLK_MAX_CDB];
 	struct scatterlist sense_sgl;
-- 
2.19.1
