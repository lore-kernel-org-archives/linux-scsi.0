From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 096/103] target: Further simplify transport_free_pages
Date: Thu, 21 Jul 2011 07:05:28 +0000
Message-ID: <1311231935-24635-97-git-send-email-nab@linux-iscsi.org>
References: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51683 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1GUH3a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2011 03:29:30 -0400
In-Reply-To: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Create helper function for freeing sgls and only call it if needed.

Based on suggestion from hch.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   37 ++++++++++---------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ceb7ee7..9cefdf4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3723,40 +3723,27 @@ static void transport_free_dev_tasks(struct se_cmd *cmd)
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 
-static inline void transport_free_pages(struct se_cmd *cmd)
+static inline void transport_free_sgl(struct scatterlist *sgl, int nents)
 {
 	struct scatterlist *sg;
-	int free_page = 1;
 	int count;
 
-	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)
-		free_page = 0;
+	for_each_sg(sgl, sg, nents, count)
+		__free_page(sg_page(sg));
 
-	for_each_sg(cmd->t_data_sg, sg, cmd->t_data_nents, count) {
-		/*
-		 * Only called if
-		 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
-		 */
-		if (free_page)
-			__free_page(sg_page(sg));
+	kfree(sgl);
+}
 
-	}
-	if (free_page)
-		kfree(cmd->t_data_sg);
+static inline void transport_free_pages(struct se_cmd *cmd)
+{
+	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)
+		return;
+
+	transport_free_sgl(cmd->t_data_sg, cmd->t_data_nents);
 	cmd->t_data_sg = NULL;
 	cmd->t_data_nents = 0;
 
-	for_each_sg(cmd->t_bidi_data_sg, sg, cmd->t_bidi_data_nents, count) {
-		/*
-		 * Only called if
-		 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
-		 */
-		if (free_page)
-			__free_page(sg_page(sg));
-
-	}
-	if (free_page)
-		kfree(cmd->t_bidi_data_sg);
+	transport_free_sgl(cmd->t_bidi_data_sg, cmd->t_bidi_data_nents);
 	cmd->t_bidi_data_sg = NULL;
 	cmd->t_bidi_data_nents = 0;
 }
-- 
1.7.6

