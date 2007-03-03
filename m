From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] tgt: fix sesnse buffer problems
Date: Sat, 3 Mar 2007 09:55:54 +0900 (JST)
Message-ID: <20070303001748R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:38789 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992822AbXCCA4E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Mar 2007 19:56:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This patch simplify the way to notify LLDs of the command completion
and addresses the following sense buffer problems:

- can't handle both data and sense.
- forces user-space to use aligned sense buffer

tgt copies sense_data from userspace to cmnd->sense_buffer (if
necessary), maps user-space pages (if necessary) and then calls
host->transfer_response (host->transfer_data is removed).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |   21 ++-----
 drivers/scsi/scsi_tgt_if.c       |    6 +-
 drivers/scsi/scsi_tgt_lib.c      |  120 +++++++------------------------------
 drivers/scsi/scsi_tgt_priv.h     |    5 +-
 include/scsi/scsi_host.h         |   19 ++-----
 include/scsi/scsi_tgt_if.h       |    6 +-
 6 files changed, 44 insertions(+), 133 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index e28260f..07e5cbe 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -273,23 +273,9 @@ static int ibmvstgt_rdma(struct scsi_cmn
 		rest -= mlen;
 	}
 out:
-
 	return 0;
 }
 
-static int ibmvstgt_transfer_data(struct scsi_cmnd *sc,
-				  void (*done)(struct scsi_cmnd *))
-{
-	struct iu_entry	*iue = (struct iu_entry *) sc->SCp.ptr;
-	int err;
-
-	err = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvstgt_rdma, 1, 1);
-
-	done(sc);
-
-	return err;
-}
-
 static int ibmvstgt_cmd_done(struct scsi_cmnd *sc,
 			     void (*done)(struct scsi_cmnd *))
 {
@@ -297,7 +283,11 @@ static int ibmvstgt_cmd_done(struct scsi
 	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
 	struct srp_target *target = iue->target;
 
-	dprintk("%p %p %x\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0]);
+	dprintk("%p %p %x %u\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0],
+		cmd->usg_sg);
+
+	if (sc->use_sg)
+		srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvstgt_rdma, 1, 1);
 
 	spin_lock_irqsave(&target->lock, flags);
 	list_del(&iue->ilist);
@@ -794,7 +784,6 @@ static struct scsi_host_template ibmvstg
 	.use_clustering		= DISABLE_CLUSTERING,
 	.max_sectors		= DEFAULT_MAX_SECTORS,
 	.transfer_response	= ibmvstgt_cmd_done,
-	.transfer_data		= ibmvstgt_transfer_data,
 	.eh_abort_handler	= ibmvstgt_eh_abort_handler,
 	.tsk_mgmt_response	= ibmvstgt_tsk_mgmt_response,
 	.shost_attrs		= ibmvstgt_attrs,
diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index f5d4412..7e18310 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -179,10 +179,12 @@ static int event_recv_msg(struct tgt_eve
 	switch (ev->hdr.type) {
 	case TGT_UEVENT_CMD_RSP:
 		err = scsi_tgt_kspace_exec(ev->p.cmd_rsp.host_no,
-					   ev->p.cmd_rsp.tag,
 					   ev->p.cmd_rsp.result,
-					   ev->p.cmd_rsp.len,
+					   ev->p.cmd_rsp.tag,
 					   ev->p.cmd_rsp.uaddr,
+					   ev->p.cmd_rsp.len,
+					   ev->p.cmd_rsp.sense_uaddr,
+					   ev->p.cmd_rsp.sense_len,
 					   ev->p.cmd_rsp.rw);
 		break;
 	case TGT_UEVENT_TSK_MGMT_RSP:
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 47c29a9..dc8781a 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -47,9 +47,6 @@ struct scsi_tgt_cmd {
 	struct list_head hash_list;
 	struct request *rq;
 	u64 tag;
-
-	void *buffer;
-	unsigned bufflen;
 };
 
 #define TGT_HASH_ORDER	4
@@ -330,10 +327,14 @@ static void scsi_tgt_cmd_done(struct scs
 	dprintk("cmd %p %lu\n", cmd, rq_data_dir(cmd->request));
 
 	scsi_tgt_uspace_send_status(cmd, tcmd->tag);
+
+	if (cmd->request_buffer)
+		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+
 	queue_work(scsi_tgtd, &tcmd->work);
 }
 
-static int __scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
+static int scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *shost = scsi_tgt_cmd_to_host(cmd);
 	int err;
@@ -346,30 +347,12 @@ static int __scsi_tgt_transfer_response(
 	case SCSI_MLQUEUE_DEVICE_BUSY:
 		return -EAGAIN;
 	}
-
 	return 0;
 }
 
-static void scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
-{
-	struct scsi_tgt_cmd *tcmd = cmd->request->end_io_data;
-	int err;
-
-	err = __scsi_tgt_transfer_response(cmd);
-	if (!err)
-		return;
-
-	cmd->result = DID_BUS_BUSY << 16;
-	err = scsi_tgt_uspace_send_status(cmd, tcmd->tag);
-	if (err <= 0)
-		/* the eh will have to pick this up */
-		printk(KERN_ERR "Could not send cmd %p status\n", cmd);
-}
-
 static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	struct request *rq = cmd->request;
-	struct scsi_tgt_cmd *tcmd = rq->end_io_data;
 	int count;
 
 	cmd->use_sg = rq->nr_phys_segments;
@@ -379,31 +362,28 @@ static int scsi_tgt_init_cmd(struct scsi
 
 	cmd->request_bufflen = rq->data_len;
 
-	dprintk("cmd %p addr %p cnt %d %lu\n", cmd, tcmd->buffer, cmd->use_sg,
-		rq_data_dir(rq));
+	dprintk("cmd %p cnt %d %lu\n", cmd, cmd->use_sg, rq_data_dir(rq));
 	count = blk_rq_map_sg(rq->q, rq, cmd->request_buffer);
 	if (likely(count <= cmd->use_sg)) {
 		cmd->use_sg = count;
 		return 0;
 	}
 
-	eprintk("cmd %p addr %p cnt %d\n", cmd, tcmd->buffer, cmd->use_sg);
+	eprintk("cmd %p cnt %d\n", cmd, cmd->use_sg);
 	scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
 	return -EINVAL;
 }
 
 /* TODO: test this crap and replace bio_map_user with new interface maybe */
 static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
-			       int rw)
+			       unsigned long uaddr, unsigned int len, int rw)
 {
 	struct request_queue *q = cmd->request->q;
 	struct request *rq = cmd->request;
-	void *uaddr = tcmd->buffer;
-	unsigned int len = tcmd->bufflen;
 	int err;
 
-	dprintk("%lx %u\n", (unsigned long) uaddr, len);
-	err = blk_rq_map_user(q, rq, uaddr, len);
+	dprintk("%lx %u\n", uaddr, len);
+	err = blk_rq_map_user(q, rq, (void *)uaddr, len);
 	if (err) {
 		/*
 		 * TODO: need to fixup sg_tablesize, max_segment_size,
@@ -430,45 +410,6 @@ unmap_rq:
 	return err;
 }
 
-static int scsi_tgt_transfer_data(struct scsi_cmnd *);
-
-static void scsi_tgt_data_transfer_done(struct scsi_cmnd *cmd)
-{
-	struct scsi_tgt_cmd *tcmd = cmd->request->end_io_data;
-	int err;
-
-	/* should we free resources here on error ? */
-	if (cmd->result) {
-		err = scsi_tgt_uspace_send_status(cmd, tcmd->tag);
-		if (err <= 0)
-			/* the tgt uspace eh will have to pick this up */
-			printk(KERN_ERR "Could not send cmd %p status\n", cmd);
-		return;
-	}
-
-	dprintk("cmd %p request_bufflen %u bufflen %u\n",
-		cmd, cmd->request_bufflen, tcmd->bufflen);
-
-	scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
-	tcmd->buffer += cmd->request_bufflen;
-	scsi_tgt_transfer_response(cmd);
-}
-
-static int scsi_tgt_transfer_data(struct scsi_cmnd *cmd)
-{
-	int err;
-	struct Scsi_Host *host = scsi_tgt_cmd_to_host(cmd);
-
-	err = host->hostt->transfer_data(cmd, scsi_tgt_data_transfer_done);
-	switch (err) {
-		case SCSI_MLQUEUE_HOST_BUSY:
-		case SCSI_MLQUEUE_DEVICE_BUSY:
-			return -EAGAIN;
-	default:
-		return 0;
-	}
-}
-
 static int scsi_tgt_copy_sense(struct scsi_cmnd *cmd, unsigned long uaddr,
 				unsigned len)
 {
@@ -518,8 +459,9 @@ static struct request *tgt_cmd_hash_look
 	return rq;
 }
 
-int scsi_tgt_kspace_exec(int host_no, u64 tag, int result, u32 len,
-			 unsigned long uaddr, u8 rw)
+int scsi_tgt_kspace_exec(int host_no, int result, u64 tag,
+			 unsigned long uaddr, u32 len, unsigned long sense_uaddr,
+			 u32 sense_len, u8 rw)
 {
 	struct Scsi_Host *shost;
 	struct scsi_cmnd *cmd;
@@ -564,36 +506,20 @@ int scsi_tgt_kspace_exec(int host_no, u6
 	 * in the request_* values
 	 */
 	tcmd = cmd->request->end_io_data;
-	tcmd->buffer = (void *)uaddr;
-	tcmd->bufflen = len;
 	cmd->result = result;
 
-	if (!tcmd->bufflen || cmd->request_buffer) {
-		err = __scsi_tgt_transfer_response(cmd);
-		goto done;
-	}
-
-	/*
-	 * TODO: Do we need to handle case where request does not
-	 * align with LLD.
-	 */
-	err = scsi_map_user_pages(rq->end_io_data, cmd, rw);
-	if (err) {
-		eprintk("%p %d\n", cmd, err);
-		err = -EAGAIN;
-		goto done;
-	}
+	if (cmd->result == SAM_STAT_CHECK_CONDITION)
+		scsi_tgt_copy_sense(cmd, sense_uaddr, sense_len);
 
-	/* userspace failure */
-	if (cmd->result) {
-		if (status_byte(cmd->result) == CHECK_CONDITION)
-			scsi_tgt_copy_sense(cmd, uaddr, len);
-		err = __scsi_tgt_transfer_response(cmd);
-		goto done;
+	if (len) {
+		err = scsi_map_user_pages(rq->end_io_data, cmd, uaddr, len, rw);
+		if (err) {
+			eprintk("%p %d\n", cmd, err);
+			err = -EAGAIN;
+			goto done;
+		}
 	}
-	/* ask the target LLD to transfer the data to the buffer */
-	err = scsi_tgt_transfer_data(cmd);
-
+	err = scsi_tgt_transfer_response(cmd);
 done:
 	scsi_host_put(shost);
 	return err;
diff --git a/drivers/scsi/scsi_tgt_priv.h b/drivers/scsi/scsi_tgt_priv.h
index 84488c5..e9e6db1 100644
--- a/drivers/scsi/scsi_tgt_priv.h
+++ b/drivers/scsi/scsi_tgt_priv.h
@@ -18,8 +18,9 @@ extern int scsi_tgt_if_init(void);
 extern int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, struct scsi_lun *lun,
 				    u64 tag);
 extern int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, u64 tag);
-extern int scsi_tgt_kspace_exec(int host_no, u64 tag, int result, u32 len,
-				unsigned long uaddr, u8 rw);
+extern int scsi_tgt_kspace_exec(int host_no, int result, u64 tag,
+				unsigned long uaddr, u32 len, unsigned long sense_uaddr,
+				u32 sense_len, u8 rw);
 extern int scsi_tgt_uspace_send_tsk_mgmt(int host_no, int function, u64 tag,
 					 struct scsi_lun *scsilun, void *data);
 extern int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 mid, int result);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7f1f411..965b6b8 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -129,6 +129,11 @@ #endif
 	 * the LLD. When the driver is finished processing the command
 	 * the done callback is invoked.
 	 *
+	 * This is called to inform the LLD to transfer
+	 * cmd->request_bufflen bytes. The cmd->use_sg speciefies the
+	 * number of scatterlist entried in the command and
+	 * cmd->request_buffer contains the scatterlist.
+	 *
 	 * return values: see queuecommand
 	 *
 	 * If the LLD accepts the cmd, it should set the result to an
@@ -139,20 +144,6 @@ #endif
 	/* TODO: rename */
 	int (* transfer_response)(struct scsi_cmnd *,
 				  void (*done)(struct scsi_cmnd *));
-	/*
-	 * This is called to inform the LLD to transfer cmd->request_bufflen
-	 * bytes of the cmd at cmd->offset in the cmd. The cmd->use_sg
-	 * speciefies the number of scatterlist entried in the command
-	 * and cmd->request_buffer contains the scatterlist.
-	 *
-	 * If the command cannot be processed in one transfer_data call
-	 * becuase a scatterlist within the LLD's limits cannot be
-	 * created then transfer_data will be called multiple times.
-	 * It is initially called from process context, and later
-	 * calls are from the interrup context.
-	 */
-	int (* transfer_data)(struct scsi_cmnd *,
-			      void (*done)(struct scsi_cmnd *));
 
 	/* Used as callback for the completion of task management request. */
 	int (* tsk_mgmt_response)(u64 mid, int result);
diff --git a/include/scsi/scsi_tgt_if.h b/include/scsi/scsi_tgt_if.h
index 07d6e77..4cf9dff 100644
--- a/include/scsi/scsi_tgt_if.h
+++ b/include/scsi/scsi_tgt_if.h
@@ -45,11 +45,13 @@ struct tgt_event {
 		/* user-> kernel */
 		struct {
 			int host_no;
-			uint32_t len;
 			int result;
+			aligned_u64 tag;
 			aligned_u64 uaddr;
+			aligned_u64 sense_uaddr;
+			uint32_t len;
+			uint32_t sense_len;
 			uint8_t rw;
-			aligned_u64 tag;
 		} cmd_rsp;
 		struct {
 			int host_no;
-- 
1.4.3.2

