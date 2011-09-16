From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/5] tcm_fc: Work queue based approach instead of managing own thread and event based mechanism
Date: Fri, 16 Sep 2011 10:38:24 +0000
Message-ID: <1316169506-4441-4-git-send-email-nab@linux-iscsi.org>
References: <1316169506-4441-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54909 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab1IPLEv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2011 07:04:51 -0400
In-Reply-To: <1316169506-4441-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>

From: Christoph Hellwig <hch@lst.de>

Problem: Changed from wake_up_interruptible -> wake_up_process and
wait_event_interruptible-> schedule_timeout_interruptible broke the FCoE
target.  Earlier approach of wake_up_interruptible was also looking at
'queue_cnt' which is not necessary, because it increment of 'queue_cnt'
with wake_up_inetrriptible / waker_up_process introduces race condition.

Fix: Instead of fixing the code which used wake_up_process and remove
'queue_cnt', using work_queue based approach is cleaner and acheives
same result. As well, work queue based approach has less programming
overhead and OS manages threads which processes work queues.

This patch is developed by Christoph Hellwig and reviwed+validated by
Kiran Patil.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Cc: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tcm_fc.h   |   12 +----
 drivers/target/tcm_fc/tfc_cmd.c  |   90 +++++---------------------------------
 drivers/target/tcm_fc/tfc_conf.c |    7 +--
 3 files changed, 16 insertions(+), 93 deletions(-)

diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index bd4fe21..3749d8b 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -98,8 +98,7 @@ struct ft_tpg {
 	struct list_head list;		/* linkage in ft_lport_acl tpg_list */
 	struct list_head lun_list;	/* head of LUNs */
 	struct se_portal_group se_tpg;
-	struct task_struct *thread;	/* processing thread */
-	struct se_queue_obj qobj;	/* queue for processing thread */
+	struct workqueue_struct *workqueue;
 };
 
 struct ft_lport_acl {
@@ -110,16 +109,10 @@ struct ft_lport_acl {
 	struct se_wwn fc_lport_wwn;
 };
 
-enum ft_cmd_state {
-	FC_CMD_ST_NEW = 0,
-	FC_CMD_ST_REJ
-};
-
 /*
  * Commands
  */
 struct ft_cmd {
-	enum ft_cmd_state state;
 	u32 lun;                        /* LUN from request */
 	struct ft_sess *sess;		/* session held for cmd */
 	struct fc_seq *seq;		/* sequence in exchange mgr */
@@ -127,7 +120,7 @@ struct ft_cmd {
 	struct fc_frame *req_frame;
 	unsigned char *cdb;		/* pointer to CDB inside frame */
 	u32 write_data_len;		/* data received on writes */
-	struct se_queue_req se_req;
+	struct work_struct work;
 	/* Local sense buffer */
 	unsigned char ft_sense_buffer[TRANSPORT_SENSE_BUFFER];
 	u32 was_ddp_setup:1;		/* Set only if ddp is setup */
@@ -177,7 +170,6 @@ int ft_is_state_remove(struct se_cmd *);
 /*
  * other internal functions.
  */
-int ft_thread(void *);
 void ft_recv_req(struct ft_sess *, struct fc_frame *);
 struct ft_tpg *ft_lport_find_tpg(struct fc_lport *);
 struct ft_node_acl *ft_acl_get(struct ft_tpg *, struct fc_rport_priv *);
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 5654dc2..80fbcde 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -62,8 +62,8 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 	int count;
 
 	se_cmd = &cmd->se_cmd;
-	pr_debug("%s: cmd %p state %d sess %p seq %p se_cmd %p\n",
-		caller, cmd, cmd->state, cmd->sess, cmd->seq, se_cmd);
+	pr_debug("%s: cmd %p sess %p seq %p se_cmd %p\n",
+		caller, cmd, cmd->sess, cmd->seq, se_cmd);
 	pr_debug("%s: cmd %p cdb %p\n",
 		caller, cmd, cmd->cdb);
 	pr_debug("%s: cmd %p lun %d\n", caller, cmd, cmd->lun);
@@ -90,38 +90,6 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 		16, 4, cmd->cdb, MAX_COMMAND_SIZE, 0);
 }
 
-static void ft_queue_cmd(struct ft_sess *sess, struct ft_cmd *cmd)
-{
-	struct ft_tpg *tpg = sess->tport->tpg;
-	struct se_queue_obj *qobj = &tpg->qobj;
-	unsigned long flags;
-
-	qobj = &sess->tport->tpg->qobj;
-	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
-	list_add_tail(&cmd->se_req.qr_list, &qobj->qobj_list);
-	atomic_inc(&qobj->queue_cnt);
-	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
-
-	wake_up_process(tpg->thread);
-}
-
-static struct ft_cmd *ft_dequeue_cmd(struct se_queue_obj *qobj)
-{
-	unsigned long flags;
-	struct se_queue_req *qr;
-
-	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
-	if (list_empty(&qobj->qobj_list)) {
-		spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
-		return NULL;
-	}
-	qr = list_first_entry(&qobj->qobj_list, struct se_queue_req, qr_list);
-	list_del(&qr->qr_list);
-	atomic_dec(&qobj->queue_cnt);
-	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
-	return container_of(qr, struct ft_cmd, se_req);
-}
-
 static void ft_free_cmd(struct ft_cmd *cmd)
 {
 	struct fc_frame *fp;
@@ -282,9 +250,7 @@ u32 ft_get_task_tag(struct se_cmd *se_cmd)
 
 int ft_get_cmd_state(struct se_cmd *se_cmd)
 {
-	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
-
-	return cmd->state;
+	return 0;
 }
 
 int ft_is_state_remove(struct se_cmd *se_cmd)
@@ -505,6 +471,8 @@ int ft_queue_tm_resp(struct se_cmd *se_cmd)
 	return 0;
 }
 
+static void ft_send_work(struct work_struct *work);
+
 /*
  * Handle incoming FCP command.
  */
@@ -523,7 +491,9 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 		goto busy;
 	}
 	cmd->req_frame = fp;		/* hold frame during cmd */
-	ft_queue_cmd(sess, cmd);
+
+	INIT_WORK(&cmd->work, ft_send_work);
+	queue_work(sess->tport->tpg->workqueue, &cmd->work);
 	return;
 
 busy:
@@ -563,12 +533,13 @@ void ft_recv_req(struct ft_sess *sess, struct fc_frame *fp)
 /*
  * Send new command to target.
  */
-static void ft_send_cmd(struct ft_cmd *cmd)
+static void ft_send_work(struct work_struct *work)
 {
+	struct ft_cmd *cmd = container_of(work, struct ft_cmd, work);
 	struct fc_frame_header *fh = fc_frame_header_get(cmd->req_frame);
 	struct se_cmd *se_cmd;
 	struct fcp_cmnd *fcp;
-	int data_dir;
+	int data_dir = 0;
 	u32 data_len;
 	int task_attr;
 	int ret;
@@ -675,42 +646,3 @@ static void ft_send_cmd(struct ft_cmd *cmd)
 err:
 	ft_send_resp_code_and_free(cmd, FCP_CMND_FIELDS_INVALID);
 }
-
-/*
- * Handle request in the command thread.
- */
-static void ft_exec_req(struct ft_cmd *cmd)
-{
-	pr_debug("cmd state %x\n", cmd->state);
-	switch (cmd->state) {
-	case FC_CMD_ST_NEW:
-		ft_send_cmd(cmd);
-		break;
-	default:
-		break;
-	}
-}
-
-/*
- * Processing thread.
- * Currently one thread per tpg.
- */
-int ft_thread(void *arg)
-{
-	struct ft_tpg *tpg = arg;
-	struct se_queue_obj *qobj = &tpg->qobj;
-	struct ft_cmd *cmd;
-
-	while (!kthread_should_stop()) {
-		schedule_timeout_interruptible(MAX_SCHEDULE_TIMEOUT);
-		if (kthread_should_stop())
-			goto out;
-
-		cmd = ft_dequeue_cmd(qobj);
-		if (cmd)
-			ft_exec_req(cmd);
-	}
-
-out:
-	return 0;
-}
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index b15879d..8fa39b7 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -327,7 +327,6 @@ static struct se_portal_group *ft_add_tpg(
 	tpg->index = index;
 	tpg->lport_acl = lacl;
 	INIT_LIST_HEAD(&tpg->lun_list);
-	transport_init_queue_obj(&tpg->qobj);
 
 	ret = core_tpg_register(&ft_configfs->tf_ops, wwn, &tpg->se_tpg,
 				tpg, TRANSPORT_TPG_TYPE_NORMAL);
@@ -336,8 +335,8 @@ static struct se_portal_group *ft_add_tpg(
 		return NULL;
 	}
 
-	tpg->thread = kthread_run(ft_thread, tpg, "ft_tpg%lu", index);
-	if (IS_ERR(tpg->thread)) {
+	tpg->workqueue = alloc_workqueue("tcm_fc", 0, 1);
+	if (!tpg->workqueue) {
 		kfree(tpg);
 		return NULL;
 	}
@@ -356,7 +355,7 @@ static void ft_del_tpg(struct se_portal_group *se_tpg)
 	pr_debug("del tpg %s\n",
 		    config_item_name(&tpg->se_tpg.tpg_group.cg_item));
 
-	kthread_stop(tpg->thread);
+	destroy_workqueue(tpg->workqueue);
 
 	/* Wait for sessions to be freed thru RCU, for BUG_ON below */
 	synchronize_rcu();
-- 
1.5.6.5

