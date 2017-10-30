From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 13/19] tcmu: clean up the scatter helper
Date: Sun, 29 Oct 2017 22:44:33 -0500
Message-ID: <1509335079-5276-14-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Xiubo Li <lixiubo@cmss.chinamobile.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

Add some comments to make the scatter code to be more readable,
and drop unused arg to new_iov.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index b7eeb25..91e0601 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -491,8 +491,7 @@ static inline size_t head_to_end(size_t head, size_t size)
 	return size - head;
 }
 
-static inline void new_iov(struct iovec **iov, int *iov_cnt,
-			   struct tcmu_dev *udev)
+static inline void new_iov(struct iovec **iov, int *iov_cnt)
 {
 	struct iovec *iovec;
 
@@ -545,19 +544,38 @@ static void scatter_data_area(struct tcmu_dev *udev,
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
@@ -565,11 +583,13 @@ static void scatter_data_area(struct tcmu_dev *udev,
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
 }
-- 
1.8.3.1
