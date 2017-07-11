From: lixiubo@cmss.chinamobile.com
Subject: [PATCH] tcmu: clean up the code and with one small fix
Date: Tue, 11 Jul 2017 18:06:41 +0800
Message-ID: <1499767601-18328-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: bryantly@linux.vnet.ibm.com, damien.lemoal@wdc.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Xiubo Li <lixiubo@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

Remove useless blank line and code and at the same time add one error
path to catch the errors.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 3b25ef3..80ee130 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -342,7 +342,6 @@ static inline bool tcmu_get_empty_block(struct tcmu_dev *udev,
 
 	page = radix_tree_lookup(&udev->data_blocks, dbi);
 	if (!page) {
-
 		if (atomic_add_return(1, &global_db_count) >
 					TCMU_GLOBAL_MAX_BLOCKS) {
 			atomic_dec(&global_db_count);
@@ -352,14 +351,11 @@ static inline bool tcmu_get_empty_block(struct tcmu_dev *udev,
 		/* try to get new page from the mm */
 		page = alloc_page(GFP_KERNEL);
 		if (!page)
-			return false;
+			goto err_alloc;
 
 		ret = radix_tree_insert(&udev->data_blocks, dbi, page);
-		if (ret) {
-			__free_page(page);
-			return false;
-		}
-
+		if (ret)
+			goto err_insert;
 	}
 
 	if (dbi > udev->dbi_max)
@@ -369,6 +365,11 @@ static inline bool tcmu_get_empty_block(struct tcmu_dev *udev,
 	tcmu_cmd_set_dbi(tcmu_cmd, dbi);
 
 	return true;
+err_insert:
+	__free_page(page);
+err_alloc:
+	atomic_dec(&global_db_count);
+	return false;
 }
 
 static bool tcmu_get_empty_blocks(struct tcmu_dev *udev,
@@ -527,7 +528,7 @@ static inline size_t get_block_offset_user(struct tcmu_dev *dev,
 		DATA_BLOCK_SIZE - remaining;
 }
 
-static inline size_t iov_tail(struct tcmu_dev *udev, struct iovec *iov)
+static inline size_t iov_tail(struct iovec *iov)
 {
 	return (size_t)iov->iov_base + iov->iov_len;
 }
@@ -566,7 +567,7 @@ static int scatter_data_area(struct tcmu_dev *udev,
 			to += offset;
 
 			if (*iov_cnt != 0 &&
-			    to_offset == iov_tail(udev, *iov)) {
+			    to_offset == iov_tail(*iov)) {
 				(*iov)->iov_len += copy_bytes;
 			} else {
 				new_iov(iov, iov_cnt, udev);
@@ -722,10 +723,7 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 		}
 	}
 
-	if (!tcmu_get_empty_blocks(udev, cmd))
-		return false;
-
-	return true;
+	return tcmu_get_empty_blocks(udev, cmd);
 }
 
 static inline size_t tcmu_cmd_get_base_cmd_size(size_t iov_cnt)
-- 
1.8.3.1
