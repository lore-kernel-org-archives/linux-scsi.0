From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 7/9] target: Add transport_reset_sgl_orig() for COMPARE_AND_WRITE
Date: Tue, 20 Aug 2013 20:07:58 +0000
Message-ID: <1377029280-19144-8-git-send-email-nab@daterainc.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39557 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3HTUYH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 16:24:07 -0400
Received: by mail-oa0-f46.google.com with SMTP id j10so245529oah.5
        for <linux-scsi@vger.kernel.org>; Tue, 20 Aug 2013 13:24:07 -0700 (PDT)
In-Reply-To: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>

From: Nicholas Bellinger <nab@daterainc.com>

After COMPARE_AND_WRITE completes it's comparision, the WRITE
payload SGLs head expect to be updated to point from the verify
instance of user data, to the write instance of user data.

So for this special case, add transport_reset_sgl_orig() usage
within transport_free_pages() and add se_cmd->t_data_[sg,nents]_orig
members to save the original assignments.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_transport.c |   21 ++++++++++++++++++++-
 include/target/target_core_base.h      |    2 ++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 60d1336..bb98684 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1994,10 +1994,29 @@ static inline void transport_free_sgl(struct scatterlist *sgl, int nents)
 	kfree(sgl);
 }
 
+static inline void transport_reset_sgl_orig(struct se_cmd *cmd)
+{
+	/*
+	 * Check for saved t_data_sg that may be used for COMPARE_AND_WRITE
+	 * emulation, and free + reset pointers if necessary..
+	 */
+	if (!cmd->t_data_sg_orig)
+		return;
+
+	kfree(cmd->t_data_sg);
+	cmd->t_data_sg = cmd->t_data_sg_orig;
+	cmd->t_data_sg_orig = NULL;
+	cmd->t_data_nents = cmd->t_data_nents_orig;
+	cmd->t_data_nents_orig = 0;
+}
+
 static inline void transport_free_pages(struct se_cmd *cmd)
 {
-	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)
+	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) {
+		transport_reset_sgl_orig(cmd);
 		return;
+	}
+	transport_reset_sgl_orig(cmd);
 
 	transport_free_sgl(cmd->t_data_sg, cmd->t_data_nents);
 	cmd->t_data_sg = NULL;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e1e0843..2f9a438 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -476,7 +476,9 @@ struct se_cmd {
 	struct work_struct	work;
 
 	struct scatterlist	*t_data_sg;
+	struct scatterlist	*t_data_sg_orig;
 	unsigned int		t_data_nents;
+	unsigned int		t_data_nents_orig;
 	void			*t_data_vmap;
 	struct scatterlist	*t_bidi_data_sg;
 	unsigned int		t_bidi_data_nents;
-- 
1.7.10.4

