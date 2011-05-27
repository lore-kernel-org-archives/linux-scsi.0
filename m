From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] tcm_fc: Convert to wake_up_process and schedule_timeout_interruptible
Date: Fri, 27 May 2011 14:41:02 -0700
Message-ID: <1306532463-28193-3-git-send-email-nab@linux-iscsi.org>
References: <1306532463-28193-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm26-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.225]:44632
	"HELO nm26-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752499Ab1E0VlN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2011 17:41:13 -0400
In-Reply-To: <1306532463-28193-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kiran Patil <kiran.patil@intel.com>, Open-FCoE devel <devel@open-fcoe.org>, Nicholas Bellinger <nab@linux-iscsi.org>

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
index c056a11..b8345cc 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -119,15 +119,17 @@ static int ft_get_lun_for_cmd(struct ft_cmd *cmd, u8 *lunp)
 
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
@@ -695,15 +697,12 @@ int ft_thread(void *arg)
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
index 84e868c..aa2f33f 100644
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
1.7.5.3

