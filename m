From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 015/103] target: Make struct se_queue_req.cmd type struct se_cmd *
Date: Thu, 21 Jul 2011 00:04:51 -0700
Message-ID: <1311231979-6631-16-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm18.bullet.mail.bf1.yahoo.com ([98.139.212.177]:35522 "HELO
	nm18.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751445Ab1GUHAc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:00:32 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Grover <agrover@redhat.com>

Doesn't appear to ever be used as anything but a se_cmd*, so
it's safer to make it a pointer to a type.

Simplifies a few functions.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   30 ++++++++++++------------------
 include/target/target_core_base.h      |    2 +-
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fffa905..002ea6f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -817,7 +817,7 @@ static int transport_add_cmd_to_queue(
 	}
 	INIT_LIST_HEAD(&qr->qr_list);
 
-	qr->cmd = (void *)cmd;
+	qr->cmd = cmd;
 	qr->state = t_state;
 
 	if (t_state) {
@@ -843,7 +843,6 @@ static int transport_add_cmd_to_queue(
 static struct se_queue_req *
 __transport_get_qr_from_queue(struct se_queue_obj *qobj)
 {
-	struct se_cmd *cmd;
 	struct se_queue_req *qr = NULL;
 
 	if (list_empty(&qobj->qobj_list))
@@ -852,10 +851,9 @@ __transport_get_qr_from_queue(struct se_queue_obj *qobj)
 	list_for_each_entry(qr, &qobj->qobj_list, qr_list)
 		break;
 
-	if (qr->cmd) {
-		cmd = (struct se_cmd *)qr->cmd;
-		atomic_dec(&T_TASK(cmd)->t_transport_queue_active);
-	}
+	if (qr->cmd)
+		atomic_dec(&T_TASK(qr->cmd)->t_transport_queue_active);
+
 	list_del(&qr->qr_list);
 	atomic_dec(&qobj->queue_cnt);
 
@@ -865,7 +863,6 @@ __transport_get_qr_from_queue(struct se_queue_obj *qobj)
 static struct se_queue_req *
 transport_get_qr_from_queue(struct se_queue_obj *qobj)
 {
-	struct se_cmd *cmd;
 	struct se_queue_req *qr;
 	unsigned long flags;
 
@@ -878,10 +875,9 @@ transport_get_qr_from_queue(struct se_queue_obj *qobj)
 	list_for_each_entry(qr, &qobj->qobj_list, qr_list)
 		break;
 
-	if (qr->cmd) {
-		cmd = (struct se_cmd *)qr->cmd;
-		atomic_dec(&T_TASK(cmd)->t_transport_queue_active);
-	}
+	if (qr->cmd)
+		atomic_dec(&T_TASK(qr->cmd)->t_transport_queue_active);
+
 	list_del(&qr->qr_list);
 	atomic_dec(&qobj->queue_cnt);
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
@@ -892,7 +888,6 @@ transport_get_qr_from_queue(struct se_queue_obj *qobj)
 static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 		struct se_queue_obj *qobj)
 {
-	struct se_cmd *q_cmd;
 	struct se_queue_req *qr = NULL, *qr_p = NULL;
 	unsigned long flags;
 
@@ -903,11 +898,10 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 	}
 
 	list_for_each_entry_safe(qr, qr_p, &qobj->qobj_list, qr_list) {
-		q_cmd = (struct se_cmd *)qr->cmd;
-		if (q_cmd != cmd)
+		if (qr->cmd != cmd)
 			continue;
 
-		atomic_dec(&T_TASK(q_cmd)->t_transport_queue_active);
+		atomic_dec(&T_TASK(qr->cmd)->t_transport_queue_active);
 		atomic_dec(&qobj->queue_cnt);
 		list_del(&qr->qr_list);
 		kfree(qr);
@@ -1287,7 +1281,7 @@ static void transport_release_all_cmds(struct se_device *dev)
 	list_for_each_entry_safe(qr, qr_p, &dev->dev_queue_obj->qobj_list,
 				qr_list) {
 
-		cmd = (struct se_cmd *)qr->cmd;
+		cmd = qr->cmd;
 		t_state = qr->state;
 		list_del(&qr->qr_list);
 		kfree(qr);
@@ -6023,7 +6017,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 	while ((qr = __transport_get_qr_from_queue(dev->dev_queue_obj))) {
 		spin_unlock_irqrestore(
 				&dev->dev_queue_obj->cmd_queue_lock, flags);
-		cmd = (struct se_cmd *)qr->cmd;
+		cmd = qr->cmd;
 		state = qr->state;
 		kfree(qr);
 
@@ -6081,7 +6075,7 @@ get_cmd:
 		if (!(qr))
 			continue;
 
-		cmd = (struct se_cmd *)qr->cmd;
+		cmd = qr->cmd;
 		t_state = qr->state;
 		kfree(qr);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b2b4cf9..e35338d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -397,7 +397,7 @@ struct t10_reservation_template {
 
 struct se_queue_req {
 	int			state;
-	void			*cmd;
+	struct se_cmd		*cmd;
 	struct list_head	qr_list;
 } ____cacheline_aligned;
 
-- 
1.7.6

