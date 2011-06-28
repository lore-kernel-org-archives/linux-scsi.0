From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 06/15] target: Rename task_sg_num to task_sg_nents
Date: Tue, 28 Jun 2011 12:29:28 -0700
Message-ID: <1309289377-8029-7-git-send-email-agrover@redhat.com>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1F1T3u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 15:29:50 -0400
In-Reply-To: <1309289377-8029-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_file.c      |   12 ++++++------
 drivers/target/target_core_iblock.c    |    4 ++--
 drivers/target/target_core_pscsi.c     |    8 ++++----
 drivers/target/target_core_transport.c |   18 +++++++++---------
 include/target/target_core_base.h      |    2 +-
 5 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 5c47f42..55c7de6 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -295,20 +295,20 @@ static int fd_do_readv(struct se_task *task)
 		      task->se_dev->se_sub_dev->se_dev_attrib.block_size);
 	int ret = 0, i;
 
-	iov = kzalloc(sizeof(struct iovec) * task->task_sg_num, GFP_KERNEL);
+	iov = kzalloc(sizeof(struct iovec) * task->task_sg_nents, GFP_KERNEL);
 	if (!(iov)) {
 		printk(KERN_ERR "Unable to allocate fd_do_readv iov[]\n");
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < task->task_sg_num; i++) {
+	for (i = 0; i < task->task_sg_nents; i++) {
 		iov[i].iov_len = sg[i].length;
 		iov[i].iov_base = sg_virt(&sg[i]);
 	}
 
 	old_fs = get_fs();
 	set_fs(get_ds());
-	ret = vfs_readv(fd, &iov[0], task->task_sg_num, &pos);
+	ret = vfs_readv(fd, &iov[0], task->task_sg_nents, &pos);
 	set_fs(old_fs);
 
 	kfree(iov);
@@ -346,20 +346,20 @@ static int fd_do_writev(struct se_task *task)
 		      task->se_dev->se_sub_dev->se_dev_attrib.block_size);
 	int ret, i = 0;
 
-	iov = kzalloc(sizeof(struct iovec) * task->task_sg_num, GFP_KERNEL);
+	iov = kzalloc(sizeof(struct iovec) * task->task_sg_nents, GFP_KERNEL);
 	if (!(iov)) {
 		printk(KERN_ERR "Unable to allocate fd_do_writev iov[]\n");
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < task->task_sg_num; i++) {
+	for (i = 0; i < task->task_sg_nents; i++) {
 		iov[i].iov_len = sg[i].length;
 		iov[i].iov_base = sg_virt(&sg[i]);
 	}
 
 	old_fs = get_fs();
 	set_fs(get_ds());
-	ret = vfs_writev(fd, &iov[0], task->task_sg_num, &pos);
+	ret = vfs_writev(fd, &iov[0], task->task_sg_nents, &pos);
 	set_fs(old_fs);
 
 	kfree(iov);
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c65a83a..86d2601 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -614,7 +614,7 @@ static int iblock_map_task_SG(struct se_task *task)
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
 	struct scatterlist *sg;
 	int ret = 0;
-	u32 i, sg_num = task->task_sg_num;
+	u32 i, sg_num = task->task_sg_nents;
 	sector_t block_lba;
 	/*
 	 * Do starting conversion up from non 512-byte blocksize with
@@ -644,7 +644,7 @@ static int iblock_map_task_SG(struct se_task *task)
 	 * Use fs/bio.c:bio_add_pages() to setup the bio_vec maplist
 	 * from task->task_sg -> struct scatterlist memory.
 	 */
-	for_each_sg(task->task_sg, sg, task->task_sg_num, i) {
+	for_each_sg(task->task_sg, sg, task->task_sg_nents, i) {
 		DEBUG_IBLOCK("task: %p bio: %p Calling bio_add_page(): page:"
 			" %p len: %u offset: %u\n", task, bio, sg_page(sg),
 				sg->length, sg->offset);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 318ef14..2c82b0a 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1200,7 +1200,7 @@ static int __pscsi_map_task_SG(
 		 */
 		pscsi_blk_init_request(task, pt, pt->pscsi_req, 0);
 
-		return task->task_sg_num;
+		return task->task_sg_nents;
 	}
 	/*
 	 * Setup the secondary pt->pscsi_req->next_rq used for the extra BIDI-COMMAND
@@ -1214,7 +1214,7 @@ static int __pscsi_map_task_SG(
 	}
 	pscsi_blk_init_request(task, pt, pt->pscsi_req->next_rq, 1);
 
-	return task->task_sg_num;
+	return task->task_sg_nents;
 fail:
 	while (hbio) {
 		bio = hbio;
@@ -1233,14 +1233,14 @@ static int pscsi_map_task_SG(struct se_task *task)
 	 * Setup the main struct request for the task->task_sg[] payload
 	 */
 
-	ret = __pscsi_map_task_SG(task, task->task_sg, task->task_sg_num, 0);
+	ret = __pscsi_map_task_SG(task, task->task_sg, task->task_sg_nents, 0);
 	if (ret >= 0 && task->task_sg_bidi) {
 		/*
 		 * If present, set up the extra BIDI-COMMAND SCSI READ
 		 * struct request and payload.
 		 */
 		ret = __pscsi_map_task_SG(task, task->task_sg_bidi,
-					task->task_sg_num, 1);
+					task->task_sg_nents, 1);
 	}
 
 	if (ret < 0)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 536b679..bf3039d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4165,14 +4165,14 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 
 		if (!sg_first) {
 			sg_first = task->task_sg;
-			chained_nents = task->task_sg_num;
+			chained_nents = task->task_sg_nents;
 		} else {
 			sg_chain(sg_prev, sg_prev_nents, task->task_sg);
-			chained_nents += task->task_sg_num;
+			chained_nents += task->task_sg_nents;
 		}
 
 		sg_prev = task->task_sg;
-		sg_prev_nents = task->task_sg_num;
+		sg_prev_nents = task->task_sg_nents;
 	}
 	/*
 	 * Setup the starting pointer and total t_tasks_sg_linked_no including
@@ -4255,25 +4255,25 @@ static int transport_allocate_data_tasks(
 		 * It's so much easier and only a waste when task_count > 1.
 		 * That is extremely rare.
 		 */
-		task->task_sg_num = sgl_nents;
+		task->task_sg_nents = sgl_nents;
 		if (cmd->se_tfo->task_sg_chaining) {
-			task->task_sg_num++;
+			task->task_sg_nents++;
 			task->task_padded_sg = 1;
 		}
 
 		task->task_sg = kmalloc(sizeof(struct scatterlist) * \
-					task->task_sg_num, GFP_KERNEL);
+					task->task_sg_nents, GFP_KERNEL);
 		if (!task->task_sg) {
 			cmd->se_dev->transport->free_task(task);
 			return -ENOMEM;
 		}
 
-		sg_init_table(task->task_sg, task->task_sg_num);
+		sg_init_table(task->task_sg, task->task_sg_nents);
 
 		task_size = task->task_size;
 
 		/* Build new sgl, only up to task_size */
-		for_each_sg(task->task_sg, sg, task->task_sg_num, count) {
+		for_each_sg(task->task_sg, sg, task->task_sg_nents, count) {
 			if (cmd_sg->length > task_size)
 				break;
 
@@ -4320,7 +4320,7 @@ transport_allocate_control_task(struct se_cmd *cmd)
 	memcpy(task->task_sg, cmd->t_data_sg,
 	       sizeof(struct scatterlist) * cmd->t_data_nents);
 	task->task_size = cmd->data_length;
-	task->task_sg_num = cmd->t_data_nents;
+	task->task_sg_nents = cmd->t_data_nents;
 
 	atomic_inc(&cmd->t_fe_count);
 	atomic_inc(&cmd->t_se_count);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b483591..2c5a748 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -403,7 +403,7 @@ struct se_queue_obj {
 struct se_task {
 	unsigned char	task_sense;
 	struct scatterlist *task_sg;
-	u32		task_sg_num;
+	u32		task_sg_nents;
 	struct scatterlist *task_sg_bidi;
 	u8		task_scsi_status;
 	u8		task_flags;
-- 
1.7.1

