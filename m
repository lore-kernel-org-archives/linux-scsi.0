From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 14/20] target: Further simplify transport_free_pages
Date: Fri,  8 Jul 2011 18:18:43 -0700
Message-ID: <1310174329-22228-15-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1GIBTC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2011 21:19:02 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Create helper function for freeing sgls and only call it if needed.

Based on suggestion from hch.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_transport.c |   37 ++++++++++---------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9e23dd7..60ca81c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3729,40 +3729,27 @@ static void transport_free_dev_tasks(struct se_cmd *cmd)
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
1.7.1

