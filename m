From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
Date: Tue, 13 Jun 2006 21:43:49 -0500
Message-ID: <1150253029.22961.4.camel@mulgrave.il.steeleye.com>
References: <20060603112610.GB17018@lst.de> <20060610160815.GA12034@lst.de>
	 <20060612191948.GA8926@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:34978 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964953AbWFNCoh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 22:44:37 -0400
In-Reply-To: <20060612191948.GA8926@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-06-12 at 21:19 +0200, Christoph Hellwig wrote:
> looks like no one but James looked at it as I attached a completely
> different patch that has been merged long ago.  Here's the real one:

And finally, the scsi-target-2.6 tree likewise needs converting.  This
one I'm not sure about, since they appear to need the copy from
cmnd_data to cmnd which I just killed.  Can someone who knows this tree
look this over?

Thanks,

James

Index: BUILD-2.6/drivers/scsi/libsrp.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsrp.c	2006-06-13 15:54:32.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsrp.c	2006-06-13 15:54:35.000000000 -0500
@@ -434,7 +434,7 @@
 	scmd = scsi_host_get_command(shost, data_dir, GFP_KERNEL);
 	BUG_ON(!scmd);
 	scmd->SCp.ptr = (char *) iue;
-	memcpy(scmd->data_cmnd, cmd->cdb, MAX_COMMAND_SIZE);
+	memcpy(scmd->cmnd, cmd->cdb, MAX_COMMAND_SIZE);
 	scmd->request_bufflen = len;
 	scmd->tag = tag;
 	iue->scmd = scmd;
Index: BUILD-2.6/drivers/scsi/scsi_tgt_if.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_tgt_if.c	2006-06-13 15:54:32.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_tgt_if.c	2006-06-13 15:54:35.000000000 -0500
@@ -65,9 +65,6 @@
 	struct tgt_event *ev;
 	int err, len;
 
-	/* FIXME: we need scsi core to do that. */
-	memcpy(cmd->cmnd, cmd->data_cmnd, MAX_COMMAND_SIZE);
-
 	len = NLMSG_SPACE(sizeof(*ev));
 	/*
 	 * TODO: add MAX_COMMAND_SIZE to ev and add mempool
@@ -122,7 +119,7 @@
 	ev.k.tsk_mgmt_req.function = function;
 	ev.k.tsk_mgmt_req.tag = tag;
 	memcpy(ev.k.tsk_mgmt_req.lun, scsilun, sizeof(ev.k.tsk_mgmt_req.lun));
-	ev.k.tsk_mgmt_req.mid = (u64) data;
+	ev.k.tsk_mgmt_req.mid = (u64)(unsigned long)data;
 
 	dprintk("%d %x %llx %llx\n", host_no, function, (unsigned long long) tag,
 		(unsigned long long) ev.k.tsk_mgmt_req.mid);
Index: BUILD-2.6/drivers/scsi/scsi_tgt_lib.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_tgt_lib.c	2006-06-13 15:54:33.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_tgt_lib.c	2006-06-13 15:54:35.000000000 -0500
@@ -337,7 +337,7 @@
 
 	cmd->request_bufflen = rq->data_len;
 
-	dprintk("cmd %p addr %p cnt %d %lu\n", cmd, cmd->buffer, cmd->use_sg,
+	dprintk("cmd %p addr %p cnt %d %lu\n", cmd, cmd->request_buffer, cmd->use_sg,
 		rq_data_dir(rq));
 	count = blk_rq_map_sg(rq->q, rq, cmd->request_buffer);
 	if (likely(count <= cmd->use_sg)) {
@@ -345,7 +345,7 @@
 		return 0;
 	}
 
-	eprintk("cmd %p addr %p cnt %d\n", cmd, cmd->buffer, cmd->use_sg);
+	eprintk("cmd %p addr %p cnt %d\n", cmd, cmd->request_buffer, cmd->use_sg);
 	scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
 	return -EINVAL;
 }
@@ -356,8 +356,8 @@
 {
 	struct request_queue *q = cmd->request->q;
 	struct request *rq = cmd->request;
-	void *uaddr = cmd->buffer;
-	unsigned int len = cmd->bufflen;
+	void *uaddr = cmd->request_buffer;
+	unsigned int len = cmd->request_bufflen;
 	struct bio *bio;
 	int err;
 
@@ -425,12 +425,12 @@
 	}
 
 	dprintk("cmd %p request_bufflen %u bufflen %u\n",
-		cmd, cmd->request_bufflen, cmd->bufflen);
+		cmd, cmd->request_bufflen, cmd->request_bufflen);
 
 	scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
 	bio_list_add(&tcmd->xfer_done_list, cmd->request->bio);
 
-	cmd->buffer += cmd->request_bufflen;
+	cmd->request_buffer += cmd->request_bufflen;
 	cmd->offset += cmd->request_bufflen;
 
 	if (!tcmd->xfer_list.head) {
@@ -439,7 +439,7 @@
 	}
 
 	dprintk("cmd2 %p request_bufflen %u bufflen %u\n",
-		cmd, cmd->request_bufflen, cmd->bufflen);
+		cmd, cmd->request_bufflen, cmd->request_bufflen);
 
 	bio = bio_list_pop(&tcmd->xfer_list);
 	BUG_ON(!bio);
@@ -556,12 +556,12 @@
 	 * store the userspace values here, the working values are
 	 * in the request_* values
 	 */
-	cmd->buffer = (void *)uaddr;
+	cmd->request_buffer = (void *)uaddr;
 	if (len)
-		cmd->bufflen = len;
+		cmd->request_bufflen = len;
 	cmd->result = result;
 
-	if (!cmd->bufflen) {
+	if (!cmd->request_bufflen) {
 		err = __scsi_tgt_transfer_response(cmd);
 		goto done;
 	}


