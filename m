From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 009/103] target: Fix leak in error path in transport_init_task_sg
Date: Thu, 21 Jul 2011 00:04:45 -0700
Message-ID: <1311231979-6631-10-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm25.bullet.mail.bf1.yahoo.com ([98.139.212.184]:29788 "HELO
	nm25.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752030Ab1GUHGr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:47 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Grover <agrover@redhat.com>

If the function fails to allocate mem for task_sg_bidi, it would
return with an error, and the task_sg would be allocated but only
partially initialized. This patch frees the task_sg in that scenario.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index bae584d..edf24b4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4499,6 +4499,8 @@ next:
 		task->task_sg_bidi = kzalloc(task_sg_num_padded *
 				sizeof(struct scatterlist), GFP_KERNEL);
 		if (!(task->task_sg_bidi)) {
+			kfree(task->task_sg);
+			task->task_sg = NULL;
 			printk(KERN_ERR "Unable to allocate memory for"
 				" task->task_sg_bidi\n");
 			return -ENOMEM;
-- 
1.7.6

