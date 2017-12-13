From: Andrei Vagin <avagin@openvz.org>
Subject: [PATCH] target: don't call an unmap callback if a range length is zero
Date: Wed, 13 Dec 2017 13:55:13 -0800
Message-ID: <20171213215513.26416-1-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrei Vagin <avagin@openvz.org>
List-Id: linux-scsi@vger.kernel.org

If a length of a range is zero, it means there is nothing to unmap
and we can skip this range.

Here is one more reason, why we have to skip such ranges.  An unmap
callback calls file_operations->fallocate(), but the man page for the
fallocate syscall says that fallocate(fd, mode, offset, let) returns
EINVAL, if len is zero. It means that file_operations->fallocate() isn't
obligated to handle zero ranges too.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
---
 drivers/target/target_core_sbc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 750a04ed0e93..b054682e974f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1216,9 +1216,11 @@ sbc_execute_unmap(struct se_cmd *cmd)
 			goto err;
 		}
 
-		ret = ops->execute_unmap(cmd, lba, range);
-		if (ret)
-			goto err;
+		if (range) {
+			ret = ops->execute_unmap(cmd, lba, range);
+			if (ret)
+				goto err;
+		}
 
 		ptr += 16;
 		size -= 16;
-- 
2.13.6
