From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 045/103] tcm_fc: Convert to wake_up_process and schedule_timeout_interruptible
Date: Thu, 21 Jul 2011 00:07:57 -0700
Message-ID: <1311232135-6653-46-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm4-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.110]:27986
	"HELO nm4-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751468Ab1GUHEJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:04:09 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts ft_queue_cmd() to use wake_up_process() and
ft_thread() to use schedule_timeout_interruptible(MAX_SCHEDULE_TIMEOUT)
instead of wait_event_interruptible().  This fixes a potential race with
the wait_event_interruptible() conditional with qobj->queue_cnt in
ft_thread().

This patch also drops the unnecessary set_user_nice(current, -20) in
ft_thread(), and drops extra () around two if (!(acl)) conditionals in
tfc_conf.c.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_cmd.c  |   17 ++++++++---------
 drivers/target/tcm_fc/tfc_conf.c |    4 ++--
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 6d9553b..9c99402 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -96,15 +96,17 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 
 static void ft_queue_cmd(struct ft_sess *sess, struct ft_cmd *cmd)
 {
-	struct se_queue_obj *qobj;
+	struct ft_tpg *tpg = sess->tport->tpg;
+	struct se_queue_obj *qobj = &tpg->qobj;
 	unsigned long flags;
 
 	qobj = &sess->tport->tpg->qobj;
 	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
 	list_add_tail(&cmd->se_req.qr_list, &qobj->qobj_list);
-	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 	atomic_inc(&qobj->queue_cnt);
-	wake_up_interruptible(&qobj->thread_wq);
+	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
+
+	wake_up_process(tpg->thread);
 }
 
 static struct ft_cmd *ft_dequeue_cmd(struct se_queue_obj *qobj)
@@ -696,15 +698,12 @@ int ft_thread(void *arg)
 	struct ft_tpg *tpg = arg;
 	struct se_queue_obj *qobj = &tpg->qobj;
 	struct ft_cmd *cmd;
-	int ret;
-
-	set_user_nice(current, -20);
 
 	while (!kthread_should_stop()) {
-		ret = wait_event_interruptible(qobj->thread_wq,
-			atomic_read(&qobj->queue_cnt) || kthread_should_stop());
-		if (ret < 0 || kthread_should_stop())
+		schedule_timeout_interruptible(MAX_SCHEDULE_TIMEOUT);
+		if (kthread_should_stop())
 			goto out;
+
 		cmd = ft_dequeue_cmd(qobj);
 		if (cmd)
 			ft_exec_req(cmd);
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 58e4745..e3176f5 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -223,7 +223,7 @@ static struct se_node_acl *ft_add_acl(
 		return ERR_PTR(-EINVAL);
 
 	acl = kzalloc(sizeof(struct ft_node_acl), GFP_KERNEL);
-	if (!(acl))
+	if (!acl)
 		return ERR_PTR(-ENOMEM);
 	acl->node_auth.port_name = wwpn;
 
@@ -280,7 +280,7 @@ struct se_node_acl *ft_tpg_alloc_fabric_acl(struct se_portal_group *se_tpg)
 	struct ft_node_acl *acl;
 
 	acl = kzalloc(sizeof(*acl), GFP_KERNEL);
-	if (!(acl)) {
+	if (!acl) {
 		printk(KERN_ERR "Unable to allocate struct ft_node_acl\n");
 		return NULL;
 	}
-- 
1.7.6

