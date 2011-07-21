From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 011/103] target: Make two runtime checks into WARN_ONs
Date: Thu, 21 Jul 2011 00:04:47 -0700
Message-ID: <1311231979-6631-12-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm25-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.156]:28869 "HELO
	nm25-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752120Ab1GUHGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:09 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Grover <agrover@redhat.com>

The params are checked in the calling functions, so these ones in
transport_get_sense_data and transport_map_sg_to_mem should be unnecessary,
unless calling code becomes buggy.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index edf24b4..99b9e33 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2997,10 +2997,8 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 	unsigned long flags;
 	u32 offset = 0;
 
-	if (!SE_LUN(cmd)) {
-		printk(KERN_ERR "SE_LUN(cmd) is NULL\n");
-		return -1;
-	}
+	WARN_ON(!SE_LUN(cmd));
+
 	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
 	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
 		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
@@ -4595,10 +4593,8 @@ static int transport_map_sg_to_mem(
 	struct scatterlist *sg;
 	u32 sg_count = 1, cmd_size = cmd->data_length;
 
-	if (!in_mem) {
-		printk(KERN_ERR "No source scatterlist\n");
-		return -1;
-	}
+	WARN_ON(!in_mem);
+
 	sg = (struct scatterlist *)in_mem;
 
 	while (cmd_size) {
-- 
1.7.6

