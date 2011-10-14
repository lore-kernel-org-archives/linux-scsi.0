From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 34/37] target: pack struct se_task more tightly
Date: Fri, 14 Oct 2011 00:42:06 +0000
Message-ID: <1318552929-13341-35-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Rearrange the fields in se_task to avoid holes.  Also increase the
flags field to 16 bits as we have the space for it, and this makes
adding new flags safer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/target/target_core_base.h |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 45291b2..a6c2348 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -402,24 +402,24 @@ struct se_queue_obj {
 } ____cacheline_aligned;
 
 struct se_task {
-	unsigned char	task_sense;
-	struct scatterlist *task_sg;
-	u32		task_sg_nents;
-	struct scatterlist *task_sg_bidi;
-	u8		task_scsi_status;
-	u8		task_flags;
-	int		task_error_status;
 	unsigned long long	task_lba;
-	u32		task_sectors;
-	u32		task_size;
+	u32			task_sectors;
+	u32			task_size;
+	struct se_cmd		*task_se_cmd;
+	struct scatterlist	*task_sg;
+	struct scatterlist	*task_sg_bidi;
+	u32			task_sg_nents;
+	u16			task_flags;
+	u8			task_sense;
+	u8			task_scsi_status;
+	int			task_error_status;
 	enum dma_data_direction	task_data_direction;
-	struct se_cmd *task_se_cmd;
-	struct completion	task_stop_comp;
-	atomic_t	task_state_active;
+	atomic_t		task_state_active;
 	struct timer_list	task_timer;
-	struct list_head t_list;
-	struct list_head t_execute_list;
-	struct list_head t_state_list;
+	struct list_head	t_list;
+	struct list_head	t_execute_list;
+	struct list_head	t_state_list;
+	struct completion	task_stop_comp;
 } ____cacheline_aligned;
 
 struct se_cmd {
-- 
1.5.6.5
