From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 07/12] target: Add transport_reset_sgl_orig() for COMPARE_AND_WRITE
Date: Thu, 22 Aug 2013 04:54:05 +0000
Message-ID: <1377147250-10125-8-git-send-email-nab@daterainc.com>
References: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

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
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 967dac7..5236a80 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1992,10 +1992,29 @@ static inline void transport_free_sgl(struct scatterlist *sgl, int nents)
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
index 0c3f47f..eb439e7 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -478,7 +478,9 @@ struct se_cmd {
 	struct work_struct	work;
 
 	struct scatterlist	*t_data_sg;
+	struct scatterlist	*t_data_sg_orig;
 	unsigned int		t_data_nents;
+	unsigned int		t_data_nents_orig;
 	void			*t_data_vmap;
 	struct scatterlist	*t_bidi_data_sg;
 	unsigned int		t_bidi_data_nents;
-- 
1.7.2.5
