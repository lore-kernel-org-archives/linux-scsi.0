From: Dan Carpenter <error27@gmail.com>
Subject: [patch] target: precedence error in __transport_stop_task_timer()
Date: Tue, 9 Aug 2011 00:45:37 +0300
Message-ID: <20110808214537.GD7659@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60285 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1HHVrn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2011 17:47:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, kernel-janitors@vger.kernel.org

'!' has higher precedence than '&' so the original check only returns
if no ->task_flags are set.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8976032..048779c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2250,7 +2250,7 @@ void __transport_stop_task_timer(struct se_task *task, unsigned long *flags)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
 
-	if (!task->task_flags & TF_RUNNING)
+	if (!(task->task_flags & TF_RUNNING))
 		return;
 
 	task->task_flags |= TF_STOP;
