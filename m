From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] scsi tgt: add task management function support
Date: Thu, 16 Mar 2006 09:07:33 +0900
Message-ID: <20060316090733J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:40670 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S932615AbWCPAHi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Mar 2006 19:07:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This patch addes task management function support to tgt. This
assumes that all the previous patchsets are applied.


- add callback to task management function to scsi_host_template
structure. It is used notify LLDs of the completion of a TMF request.

- this patch doesn't use a single queue for TMF requests and SCSI
commands yet. We'll work on it later on.

- when LLDs queue scsi commands to tgt (scsi_tgt_queue_command), they
need to specify unique 'tag' for each command for ABORT_TASK. We use
64-bit tag because of SRP though 32-bit works for FCP and iSCSI. There
is no room for it in scsi_cmnd structure so this patch abuses
sense_buffer. Better solution?

- when tgt aborts a command, it calls eh_abort_handler in
scsi_host_template structure. Would be better to add
tgt_eh_abort_handler for LLDs support target and initiator modes at
the same time?


tgt TMF works in the followings:

- When LLDs queue scsi commands to tgt (scsi_tgt_queue_command), they
need to specify unique 'tag' for each command.

- LLDs call 'int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *host, int,
u64 tag, struct scsi_lun *lun, void *data)'.

- int (* tsk_mgmt_response)(u64 data, int result) is added to
scsi_host_template.

When an initiator sends a task management request, the LLD calls
scsi_tgt_tsk_mgmt_request. the LLD can use whatever it wants for the
data arg. The data arg is used later as the arg in the
tsk_mgmt_response callback.

tgt core just sends the task management request to user space
(by using TGT_KEVENT_TSK_MGMT_REQ).

In the case of ABORT_TASK, tgtd finds a single command to abort and
sends TGT_UEVENT_CMD_RSP and TGT_UEVENT_TSK_MGMT_RSP events.

tgt core calls eh_abort_handler for TGT_UEVENT_CMD_RSP and then
tsk_mgmt_response for TGT_UEVENT_TSK_MGMT_RSP.

If tgtd fails to find a command to abort, it sends only
TGT_UEVENT_TSK_MGMT_RSP event (no TGT_UEVENT_CMD_RSP event).

In the case of the rests task management function (like
ABORT_TASK_SET), tgt needs to abort multiple commands. Thus, tgtd
finds multiple commands to abort and sends multiple TGT_UEVENT_CMD_RSP
events and a single TGT_UEVENT_TSK_MGMT_RSP event. tgt core calls
eh_abort_handler multiple times and tsk_mgmt_response once.

eh_abort_handler enables LLDs to safely free resource related with a
command to abort.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

---

 drivers/scsi/scsi_tgt_if.c   |   38 +++++++++++++++++++++++----
 drivers/scsi/scsi_tgt_lib.c  |   60 ++++++++++++++++++++++++++++++++++++------
 drivers/scsi/scsi_tgt_priv.h |    4 ++-
 include/scsi/scsi_host.h     |    3 ++
 include/scsi/scsi_tgt.h      |    4 ++-
 include/scsi/scsi_tgt_if.h   |    7 +++--
 6 files changed, 98 insertions(+), 18 deletions(-)

ec93e261d7a627b743377c6d47deead88332f16d
diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index a31c8d5..9fc2d37 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -85,9 +85,11 @@ int scsi_tgt_uspace_send(struct scsi_cmn
 	memcpy(ev->k.cmd_req.scb, cmd->cmnd, sizeof(ev->k.cmd_req.scb));
 	memcpy(ev->k.cmd_req.lun, lun, sizeof(ev->k.cmd_req.lun));
 	ev->k.cmd_req.attribute = cmd->tag;
+	ev->k.cmd_req.tag = *((u64 *) (cmd->sense_buffer));
 
-	dprintk("%d %u %u\n", ev->k.cmd_req.host_no, ev->k.cmd_req.cid,
-		ev->k.cmd_req.data_len);
+	dprintk("%p %d %u %u %x %llx\n", cmd, shost->host_no, ev->k.cmd_req.cid,
+		ev->k.cmd_req.data_len, cmd->tag,
+		(unsigned long long) ev->k.cmd_req.tag);
 
 	err = netlink_unicast(nl_sk, skb, tgtd_pid, 0);
 	if (err < 0)
@@ -109,6 +111,24 @@ int scsi_tgt_uspace_send_status(struct s
 	return send_event_rsp(TGT_KEVENT_CMD_DONE, &ev, gfp_mask, tgtd_pid);
 }
 
+int scsi_tgt_uspace_send_tsk_mgmt(int host_no, int function, u64 tag,
+				  struct scsi_lun *scsilun, void *data)
+{
+	struct tgt_event ev;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.k.tsk_mgmt_req.host_no = host_no;
+	ev.k.tsk_mgmt_req.function = function;
+	ev.k.tsk_mgmt_req.tag = tag;
+	memcpy(ev.k.tsk_mgmt_req.lun, scsilun, sizeof(ev.k.tsk_mgmt_req.lun));
+	ev.k.tsk_mgmt_req.mid = (u64) data;
+
+	dprintk("%d %x %llx %llx\n", host_no, function, (unsigned long long) tag,
+		(unsigned long long) ev.k.tsk_mgmt_req.mid);
+
+	return send_event_rsp(TGT_KEVENT_TSK_MGMT_REQ, &ev, GFP_KERNEL, tgtd_pid);
+}
+
 static int event_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	struct tgt_event *ev = NLMSG_DATA(nlh);
@@ -130,6 +150,11 @@ static int event_recv_msg(struct sk_buff
 					   ev->u.cmd_rsp.uaddr,
 					   ev->u.cmd_rsp.rw);
 		break;
+	case TGT_UEVENT_TSK_MGMT_RSP:
+		err = scsi_tgt_kspace_tsk_mgmt(ev->u.tsk_mgmt_rsp.host_no,
+					       ev->u.tsk_mgmt_rsp.mid,
+					       ev->u.tsk_mgmt_rsp.result);
+		break;
 	default:
 		eprintk("unknown type %d\n", nlh->nlmsg_type);
 		err = -EINVAL;
@@ -143,6 +168,7 @@ static int event_recv_skb(struct sk_buff
 	int err;
 	uint32_t rlen;
 	struct nlmsghdr	*nlh;
+	struct tgt_event ev;
 
 	while (skb->len >= NLMSG_SPACE(0)) {
 		nlh = (struct nlmsghdr *) skb->data;
@@ -158,9 +184,11 @@ static int event_recv_skb(struct sk_buff
 		 * TODO for passthru commands the lower level should
 		 * probably handle the result or we should modify this
 		 */
-		if (nlh->nlmsg_type != TGT_UEVENT_CMD_RSP) {
-			struct tgt_event ev;
-
+		switch (nlh->nlmsg_type) {
+		case TGT_UEVENT_CMD_RSP:
+		case TGT_UEVENT_TSK_MGMT_RSP:
+			break;
+		default:
 			memset(&ev, 0, sizeof(ev));
 			ev.k.event_rsp.err = err;
 			send_event_rsp(TGT_KEVENT_RSP, &ev,
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 2cbc749..593bfe9 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -106,7 +106,6 @@ static void scsi_tgt_cmd_destroy(void *d
 		cmd->request->flags &= ~1UL;
 
 	scsi_unmap_user_pages(tcmd);
-	scsi_tgt_uspace_send_status(cmd, GFP_KERNEL);
 	kmem_cache_free(scsi_tgt_cmd_cache, tcmd);
 	scsi_host_put_command(scsi_tgt_cmd_to_host(cmd), cmd);
 }
@@ -267,13 +266,15 @@ EXPORT_SYMBOL_GPL(scsi_tgt_cmd_to_host);
  * @noblock:	set to nonzero if the command should be queued
  **/
 void scsi_tgt_queue_command(struct scsi_cmnd *cmd, struct scsi_lun *scsilun,
-			    int noblock)
+			    u64 tag)
 {
 	struct request_queue *q = cmd->request->q;
 	struct scsi_tgt_queuedata *qdata = q->queuedata;
 	unsigned long flags;
 
 	cmd->request->end_io_data = scsilun;
+	/* FIXME */
+	*((u64 *) (cmd->sense_buffer)) = tag;
 
 	spin_lock_irqsave(&qdata->cmd_req_lock, flags);
 	list_add_tail(&cmd->request->queuelist, &qdata->cmd_req);
@@ -293,12 +294,7 @@ static void scsi_tgt_cmd_done(struct scs
 
 	dprintk("cmd %p %lu\n", cmd, rq_data_dir(cmd->request));
 
-	/* don't we have to call this if result is set or not */
-	if (cmd->result) {
-		scsi_tgt_uspace_send_status(cmd, GFP_ATOMIC);
-		return;
-	}
-
+	scsi_tgt_uspace_send_status(cmd, GFP_ATOMIC);
 	INIT_WORK(&tcmd->work, scsi_tgt_cmd_destroy, cmd);
 	queue_work(scsi_tgtd, &tcmd->work);
 }
@@ -495,6 +491,18 @@ static int scsi_tgt_copy_sense(struct sc
 	return 0;
 }
 
+static int scsi_tgt_abort_cmd(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+{
+	int err;
+
+	err = host->hostt->eh_abort_handler(cmd);
+	if (err)
+		eprintk("fail to abort %p\n", cmd);
+
+	scsi_tgt_cmd_destroy(cmd);
+	return err;
+}
+
 static struct request *tgt_cmd_hash_lookup(struct request_queue *q, u32 cid)
 {
 	struct scsi_tgt_queuedata *qdata = q->queuedata;
@@ -545,6 +553,10 @@ int scsi_tgt_kspace_exec(int host_no, u3
 	dprintk("cmd %p result %d len %d bufflen %u %lu %x\n", cmd,
 		result, len, cmd->request_bufflen, rq_data_dir(rq), cmd->cmnd[0]);
 
+	if (result == TASK_ABORTED) {
+		scsi_tgt_abort_cmd(shost, cmd);
+		goto done;
+	}
 	/*
 	 * store the userspace values here, the working values are
 	 * in the request_* values
@@ -585,6 +597,38 @@ done:
 	return err;
 }
 
+int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *shost, int function, u64 tag,
+			      struct scsi_lun *scsilun, void *data)
+{
+	int err;
+
+	/* TODO: need to retry if this fails. */
+	err = scsi_tgt_uspace_send_tsk_mgmt(shost->host_no, function,
+					    tag, scsilun, data);
+	if (err < 0)
+		eprintk("The task management request lost!\n");
+	return err;
+}
+EXPORT_SYMBOL_GPL(scsi_tgt_tsk_mgmt_request);
+
+int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 mid, int result)
+{
+	struct Scsi_Host *shost;
+	int err;
+
+	dprintk("%d %d %llx\n", host_no, result, (unsigned long long) mid);
+
+	shost = scsi_host_lookup(host_no);
+	if (IS_ERR(shost)) {
+		printk(KERN_ERR "Could not find host no %d\n", host_no);
+		return -EINVAL;
+	}
+	err = shost->hostt->tsk_mgmt_response(mid, result);
+	scsi_host_put(shost);
+
+	return err;
+}
+
 static int __init scsi_tgt_init(void)
 {
 	int err;
diff --git a/drivers/scsi/scsi_tgt_priv.h b/drivers/scsi/scsi_tgt_priv.h
index 6fedcec..c518e0e 100644
--- a/drivers/scsi/scsi_tgt_priv.h
+++ b/drivers/scsi/scsi_tgt_priv.h
@@ -18,4 +18,6 @@ extern int scsi_tgt_uspace_send(struct s
 extern int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, gfp_t flags);
 extern int scsi_tgt_kspace_exec(int host_no, u32 cid, int result, u32 len,
 				unsigned long uaddr, u8 rw);
-
+extern int scsi_tgt_uspace_send_tsk_mgmt(int host_no, int function, u64 tag,
+					 struct scsi_lun *scsilun, void *data);
+extern int scsi_tgt_kspace_tsk_mgmt(int host_no, u64 mid, int result);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 8b799db..eca5721 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -153,6 +153,9 @@ struct scsi_host_template {
 	int (* transfer_data)(struct scsi_cmnd *,
 			      void (*done)(struct scsi_cmnd *));
 
+	/* Used as callback for the completion of task management request. */
+	int (* tsk_mgmt_response)(u64 mid, int result);
+
 	/*
 	 * This is an error handling strategy routine.  You don't need to
 	 * define one of these if you don't want to - there is a default
diff --git a/include/scsi/scsi_tgt.h b/include/scsi/scsi_tgt.h
index 91ad6bc..3d09a1a 100644
--- a/include/scsi/scsi_tgt.h
+++ b/include/scsi/scsi_tgt.h
@@ -8,4 +8,6 @@ struct scsi_lun;
 
 extern struct Scsi_Host *scsi_tgt_cmd_to_host(struct scsi_cmnd *cmd);
 extern int scsi_tgt_alloc_queue(struct Scsi_Host *);
-extern void scsi_tgt_queue_command(struct scsi_cmnd *, struct scsi_lun *, int);
+extern void scsi_tgt_queue_command(struct scsi_cmnd *, struct scsi_lun *, u64);
+extern int scsi_tgt_tsk_mgmt_request(struct Scsi_Host *, int, u64, struct scsi_lun *,
+				     void *);
diff --git a/include/scsi/scsi_tgt_if.h b/include/scsi/scsi_tgt_if.h
index ebca452..63b2e3a 100644
--- a/include/scsi/scsi_tgt_if.h
+++ b/include/scsi/scsi_tgt_if.h
@@ -52,7 +52,7 @@ struct tgt_event {
 		} cmd_rsp;
 		struct {
 			int host_no;
-			int mid;
+			uint64_t mid;
 			int result;
 		} tsk_mgmt_rsp;
 	} u;
@@ -69,6 +69,7 @@ struct tgt_event {
 			uint8_t scb[16];
 			uint8_t lun[8];
 			int attribute;
+			uint64_t tag;
 		} cmd_req;
 		struct {
 			int host_no;
@@ -77,10 +78,10 @@ struct tgt_event {
 		} cmd_done;
 		struct {
 			int host_no;
-			int mid;
+			int function;
 			uint64_t tag;
 			uint8_t lun[8];
-			int function;
+			uint64_t mid;
 		} tsk_mgmt_req;
 	} k;
 
-- 
1.1.3
