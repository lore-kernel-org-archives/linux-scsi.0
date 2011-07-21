From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 016/103] target: Remove __transport_get_qr_from_queue()
Date: Thu, 21 Jul 2011 00:04:52 -0700
Message-ID: <1311231979-6631-17-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm30-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.126]:26461 "HELO
	nm30-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752290Ab1GUHHM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:12 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Grover <agrover@redhat.com>

The only use of it seems to be wrapped by a lock, so it should just use
the locked version.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   27 +--------------------------
 1 files changed, 1 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 002ea6f..56249cf 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -841,26 +841,6 @@ static int transport_add_cmd_to_queue(
  * Called with struct se_queue_obj->cmd_queue_lock held.
  */
 static struct se_queue_req *
-__transport_get_qr_from_queue(struct se_queue_obj *qobj)
-{
-	struct se_queue_req *qr = NULL;
-
-	if (list_empty(&qobj->qobj_list))
-		return NULL;
-
-	list_for_each_entry(qr, &qobj->qobj_list, qr_list)
-		break;
-
-	if (qr->cmd)
-		atomic_dec(&T_TASK(qr->cmd)->t_transport_queue_active);
-
-	list_del(&qr->qr_list);
-	atomic_dec(&qobj->queue_cnt);
-
-	return qr;
-}
-
-static struct se_queue_req *
 transport_get_qr_from_queue(struct se_queue_obj *qobj)
 {
 	struct se_queue_req *qr;
@@ -6013,10 +5993,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 	/*
 	 * Empty the struct se_device's struct se_cmd list.
 	 */
-	spin_lock_irqsave(&dev->dev_queue_obj->cmd_queue_lock, flags);
-	while ((qr = __transport_get_qr_from_queue(dev->dev_queue_obj))) {
-		spin_unlock_irqrestore(
-				&dev->dev_queue_obj->cmd_queue_lock, flags);
+	while ((qr = transport_get_qr_from_queue(dev->dev_queue_obj))) {
 		cmd = qr->cmd;
 		state = qr->state;
 		kfree(qr);
@@ -6035,9 +6012,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 			if (transport_cmd_check_stop(cmd, 1, 0))
 				transport_generic_remove(cmd, 0, 0);
 		}
-		spin_lock_irqsave(&dev->dev_queue_obj->cmd_queue_lock, flags);
 	}
-	spin_unlock_irqrestore(&dev->dev_queue_obj->cmd_queue_lock, flags);
 }
 
 /*	transport_processing_thread():
-- 
1.7.6

