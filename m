From: lixiubo@cmss.chinamobile.com
Subject: [PATCH] tcmu: clean up the scatter helper
Date: Thu, 13 Jul 2017 14:33:50 +0800
Message-ID: <1499927630-19785-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:19281 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbdGMGd5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2017 02:33:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: bryantly@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Xiubo Li <lixiubo@cmss.chinamobile.com>

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

Add some comments to make the scatter code to be more readable.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9030c2a..4f529ed3 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -532,8 +532,7 @@ static inline size_t head_to_end(size_t head, size_t size)
 	return size - head;
 }
 
-static inline void new_iov(struct iovec **iov, int *iov_cnt,
-			   struct tcmu_dev *udev)
+static inline void new_iov(struct iovec **iov, int *iov_cnt)
 {
 	struct iovec *iovec;
 
@@ -586,19 +585,38 @@ static int scatter_data_area(struct tcmu_dev *udev,
 				to = kmap_atomic(page);
 			}
 
-			copy_bytes = min_t(size_t, sg_remaining,
-					block_remaining);
+			/*
+			 * Covert to virtual offset of the ring data area.
+			 */
 			to_offset = get_block_offset_user(udev, dbi,
 					block_remaining);
 
+			/*
+			 * The following code will gather and map the blocks
+			 * to the same iovec when the blocks are all next to
+			 * each other.
+			 */
+			copy_bytes = min_t(size_t, sg_remaining,
+					block_remaining);
 			if (*iov_cnt != 0 &&
 			    to_offset == iov_tail(*iov)) {
+				/*
+				 * Will append to the current iovec, because
+				 * the current block page is next to the
+				 * previous one.
+				 */
 				(*iov)->iov_len += copy_bytes;
 			} else {
-				new_iov(iov, iov_cnt, udev);
+				/*
+				 * Will allocate a new iovec because we are
+				 * first time here or the current block page
+				 * is not next to the previous one.
+				 */
+				new_iov(iov, iov_cnt);
 				(*iov)->iov_base = (void __user *)to_offset;
 				(*iov)->iov_len = copy_bytes;
 			}
+
 			if (copy_data) {
 				offset = DATA_BLOCK_SIZE - block_remaining;
 				memcpy(to + offset,
@@ -606,11 +624,13 @@ static int scatter_data_area(struct tcmu_dev *udev,
 				       copy_bytes);
 				tcmu_flush_dcache_range(to, copy_bytes);
 			}
+
 			sg_remaining -= copy_bytes;
 			block_remaining -= copy_bytes;
 		}
 		kunmap_atomic(from - sg->offset);
 	}
+
 	if (to)
 		kunmap_atomic(to);
 
-- 
1.8.3.1
