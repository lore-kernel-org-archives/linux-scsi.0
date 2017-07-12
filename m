From: lixiubo@cmss.chinamobile.com
Subject: [PATCH] tcmu: Fix possible to/from address overflow when doing the memcpy
Date: Wed, 12 Jul 2017 15:51:17 +0800
Message-ID: <1499845877-18931-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:58498 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756753AbdGLHvY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2017 03:51:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: bryantly@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Xiubo Li <lixiubo@cmss.chinamobile.com>

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

For most case the sg->length equals to PAGE_SIZE, so this bug won't
be triggered. Otherwise this will crash the kernel, for example when
all segments' sg->length equal to 1K.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 8bf0823..9030c2a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -590,8 +590,6 @@ static int scatter_data_area(struct tcmu_dev *udev,
 					block_remaining);
 			to_offset = get_block_offset_user(udev, dbi,
 					block_remaining);
-			offset = DATA_BLOCK_SIZE - block_remaining;
-			to += offset;
 
 			if (*iov_cnt != 0 &&
 			    to_offset == iov_tail(*iov)) {
@@ -602,8 +600,10 @@ static int scatter_data_area(struct tcmu_dev *udev,
 				(*iov)->iov_len = copy_bytes;
 			}
 			if (copy_data) {
-				memcpy(to, from + sg->length - sg_remaining,
-					copy_bytes);
+				offset = DATA_BLOCK_SIZE - block_remaining;
+				memcpy(to + offset,
+				       from + sg->length - sg_remaining,
+				       copy_bytes);
 				tcmu_flush_dcache_range(to, copy_bytes);
 			}
 			sg_remaining -= copy_bytes;
@@ -664,9 +664,8 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
 			offset = DATA_BLOCK_SIZE - block_remaining;
-			from += offset;
 			tcmu_flush_dcache_range(from, copy_bytes);
-			memcpy(to + sg->length - sg_remaining, from,
+			memcpy(to + sg->length - sg_remaining, from + offset,
 					copy_bytes);
 
 			sg_remaining -= copy_bytes;
-- 
1.8.3.1
