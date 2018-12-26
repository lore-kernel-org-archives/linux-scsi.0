From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] target: fix a missing check for match_int
Date: Wed, 26 Dec 2018 00:48:18 -0600
Message-ID: <20181226064818.75984-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When match_int fails, "arg" is left uninitialized and may contain random
value, thus should not be used.
The fix checks if match_int fails, and if so, break.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/target/target_core_rd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index a6e8106abd6f..3138123143e8 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -573,7 +573,8 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 		token = match_token(ptr, tokens, args);
 		switch (token) {
 		case Opt_rd_pages:
-			match_int(args, &arg);
+			if (match_int(args, &arg))
+				break;
 			rd_dev->rd_page_count = arg;
 			pr_debug("RAMDISK: Referencing Page"
 				" Count: %u\n", rd_dev->rd_page_count);
-- 
2.17.2 (Apple Git-113)
