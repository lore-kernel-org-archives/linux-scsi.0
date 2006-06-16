From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
Date: Fri, 16 Jun 2006 15:31:47 +0900
Message-ID: <20060616153147I.fujita.tomonori@lab.ntt.co.jp>
References: <20060612191948.GA8926@lst.de>
	<1150253029.22961.4.camel@mulgrave.il.steeleye.com>
	<200606141843.k5EIhVks023235@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:52360 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1751086AbWFPGcA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jun 2006 02:32:00 -0400
In-Reply-To: <200606141843.k5EIhVks023235@r-dd.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
Date: Thu, 15 Jun 2006 03:43:26 +0900

> From: James Bottomley <James.Bottomley@SteelEye.com>
> Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
> Date: Tue, 13 Jun 2006 21:43:49 -0500
> 
> > On Mon, 2006-06-12 at 21:19 +0200, Christoph Hellwig wrote:
> > > looks like no one but James looked at it as I attached a completely
> > > different patch that has been merged long ago.  Here's the real one:
> > 
> > And finally, the scsi-target-2.6 tree likewise needs converting.  This
> > one I'm not sure about, since they appear to need the copy from
> > cmnd_data to cmnd which I just killed.  Can someone who knows this tree
> > look this over?
> 
> Thanks for the patch.
> 
> tgt uses request_bufflen, bufflen, request_buffer, buffer to handle
> very large requests (that involves multiple bios). We can add
> substitutes into tgt specific data structure (scsi_tgt_cmd structure).
> 
> I sent a patch related with scsi_tgt_cmd structure last week.
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114960851929878&w=2
> 
> Will this patch be merged? I like to send a new patch on the top of
> it.

Kill the tgt code touching data_cmnd, sc->buffer, and sc->bufflen.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

---

 drivers/scsi/libsrp.c       |    2 +-
 drivers/scsi/scsi_tgt_if.c  |    5 +----
 drivers/scsi/scsi_tgt_lib.c |   27 ++++++++++++++++-----------
 3 files changed, 18 insertions(+), 16 deletions(-)

35dcdd1d8ccb54502129abae619c58b4b3ab6eaf
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 8a4534c..b8a7c3d 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -434,7 +434,7 @@ int srp_cmd_perform(struct iu_entry *iue
 	scmd = scsi_host_get_command(shost, data_dir, GFP_KERNEL);
 	BUG_ON(!scmd);
 	scmd->SCp.ptr = (char *) iue;
-	memcpy(scmd->data_cmnd, cmd->cdb, MAX_COMMAND_SIZE);
+	memcpy(scmd->cmnd, cmd->cdb, MAX_COMMAND_SIZE);
 	scmd->request_bufflen = len;
 	scmd->tag = tag;
 	iue->scmd = scmd;
diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index ba1b75b..37e0feb 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -65,9 +65,6 @@ int scsi_tgt_uspace_send(struct scsi_cmn
 	struct tgt_event *ev;
 	int err, len;
 
-	/* FIXME: we need scsi core to do that. */
-	memcpy(cmd->cmnd, cmd->data_cmnd, MAX_COMMAND_SIZE);
-
 	len = NLMSG_SPACE(sizeof(*ev));
 	/*
 	 * TODO: add MAX_COMMAND_SIZE to ev and add mempool
@@ -122,7 +119,7 @@ int scsi_tgt_uspace_send_tsk_mgmt(int ho
 	ev.k.tsk_mgmt_req.function = function;
 	ev.k.tsk_mgmt_req.tag = tag;
 	memcpy(ev.k.tsk_mgmt_req.lun, scsilun, sizeof(ev.k.tsk_mgmt_req.lun));
-	ev.k.tsk_mgmt_req.mid = (u64) data;
+	ev.k.tsk_mgmt_req.mid = (u64) (unsigned long) data;
 
 	dprintk("%d %x %llx %llx\n", host_no, function, (unsigned long long) tag,
 		(unsigned long long) ev.k.tsk_mgmt_req.mid);
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 2385db0..e82340c 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -50,6 +50,9 @@ struct scsi_tgt_cmd {
 	struct list_head hash_list;
 	struct request *rq;
 	u64 tag;
+
+	void *buffer;
+	unsigned bufflen;
 };
 
 #define TGT_HASH_ORDER	4
@@ -407,6 +410,7 @@ static void scsi_tgt_transfer_response(s
 static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	struct request *rq = cmd->request;
+	struct scsi_tgt_cmd *tcmd = rq->end_io_data;
 	int count;
 
 	cmd->use_sg = rq->nr_phys_segments;
@@ -416,7 +420,7 @@ static int scsi_tgt_init_cmd(struct scsi
 
 	cmd->request_bufflen = rq->data_len;
 
-	dprintk("cmd %p addr %p cnt %d %lu\n", cmd, cmd->buffer, cmd->use_sg,
+	dprintk("cmd %p addr %p cnt %d %lu\n", cmd, tcmd->buffer, cmd->use_sg,
 		rq_data_dir(rq));
 	count = blk_rq_map_sg(rq->q, rq, cmd->request_buffer);
 	if (likely(count <= cmd->use_sg)) {
@@ -424,7 +428,7 @@ static int scsi_tgt_init_cmd(struct scsi
 		return 0;
 	}
 
-	eprintk("cmd %p addr %p cnt %d\n", cmd, cmd->buffer, cmd->use_sg);
+	eprintk("cmd %p addr %p cnt %d\n", cmd, tcmd->buffer, cmd->use_sg);
 	scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
 	return -EINVAL;
 }
@@ -435,8 +439,8 @@ static int scsi_map_user_pages(struct sc
 {
 	struct request_queue *q = cmd->request->q;
 	struct request *rq = cmd->request;
-	void *uaddr = cmd->buffer;
-	unsigned int len = cmd->bufflen;
+	void *uaddr = tcmd->buffer;
+	unsigned int len = tcmd->bufflen;
 	struct bio *bio;
 	int err;
 
@@ -504,12 +508,12 @@ send_uspace_err:
 	}
 
 	dprintk("cmd %p request_bufflen %u bufflen %u\n",
-		cmd, cmd->request_bufflen, cmd->bufflen);
+		cmd, cmd->request_bufflen, tcmd->bufflen);
 
 	scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
 	bio_list_add(&tcmd->xfer_done_list, cmd->request->bio);
 
-	cmd->buffer += cmd->request_bufflen;
+	tcmd->buffer += cmd->request_bufflen;
 	cmd->offset += cmd->request_bufflen;
 
 	if (!tcmd->xfer_list.head) {
@@ -518,7 +522,7 @@ send_uspace_err:
 	}
 
 	dprintk("cmd2 %p request_bufflen %u bufflen %u\n",
-		cmd, cmd->request_bufflen, cmd->bufflen);
+		cmd, cmd->request_bufflen, tcmd->bufflen);
 
 	bio = bio_list_pop(&tcmd->xfer_list);
 	BUG_ON(!bio);
@@ -604,6 +608,7 @@ int scsi_tgt_kspace_exec(int host_no, u3
 	struct Scsi_Host *shost;
 	struct scsi_cmnd *cmd;
 	struct request *rq;
+	struct scsi_tgt_cmd *tcmd;
 	int err = 0;
 
 	dprintk("%d %u %d %u %lx %u\n", host_no, cid, result,
@@ -635,12 +640,12 @@ int scsi_tgt_kspace_exec(int host_no, u3
 	 * store the userspace values here, the working values are
 	 * in the request_* values
 	 */
-	cmd->buffer = (void *)uaddr;
-	if (len)
-		cmd->bufflen = len;
+	tcmd = cmd->request->end_io_data;
+	tcmd->buffer = (void *)uaddr;
+	tcmd->bufflen = len;
 	cmd->result = result;
 
-	if (!cmd->bufflen) {
+	if (!tcmd->bufflen) {
 		err = __scsi_tgt_transfer_response(cmd);
 		goto done;
 	}
-- 
1.1.3
