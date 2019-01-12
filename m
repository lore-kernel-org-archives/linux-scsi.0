From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH v2] target: fix a missing check of match_int
Date: Fri, 11 Jan 2019 23:31:59 -0600
Message-ID: <20190112053159.99406-1-kjlu@umn.edu>
References: <5C38F72B.5000203@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5C38F72B.5000203@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When match_int fails, "arg" is left uninitialized and may contain random
value, thus should not be used.
The fix checks if match_int fails, and if so, returns its error code.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/target/target_core_rd.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index a6e8106abd6f..3b7657b2f2f1 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -559,6 +559,7 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 	char *orig, *ptr, *opts;
 	substring_t args[MAX_OPT_ARGS];
 	int arg, token;
+	int ret;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -573,14 +574,24 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 		token = match_token(ptr, tokens, args);
 		switch (token) {
 		case Opt_rd_pages:
-			match_int(args, &arg);
+			ret = match_int(args, &arg);
+			if (ret) {
+				kfree(orig);
+				return ret;
+			}
+
 			rd_dev->rd_page_count = arg;
 			pr_debug("RAMDISK: Referencing Page"
 				" Count: %u\n", rd_dev->rd_page_count);
 			rd_dev->rd_flags |= RDF_HAS_PAGE_COUNT;
 			break;
 		case Opt_rd_nullio:
-			match_int(args, &arg);
+			ret = match_int(args, &arg);
+			if (ret) {
+				kfree(orig);
+				return ret;
+			}
+
 			if (arg != 1)
 				break;
 
-- 
2.17.2 (Apple Git-113)
