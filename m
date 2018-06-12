From: Zhouyang Jia <jiazhouyang09@gmail.com>
Subject: [PATCH] target: add error handling for match_int
Date: Tue, 12 Jun 2018 12:52:28 +0800
Message-ID: <1528779148-42485-1-git-send-email-jiazhouyang09@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When match_int fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling match_int.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
 drivers/target/target_core_rd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index a6e8106..7bc89ff 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -573,14 +573,16 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 		token = match_token(ptr, tokens, args);
 		switch (token) {
 		case Opt_rd_pages:
-			match_int(args, &arg);
+			if (match_int(args, &arg))
+				return -EINVAL;
 			rd_dev->rd_page_count = arg;
 			pr_debug("RAMDISK: Referencing Page"
 				" Count: %u\n", rd_dev->rd_page_count);
 			rd_dev->rd_flags |= RDF_HAS_PAGE_COUNT;
 			break;
 		case Opt_rd_nullio:
-			match_int(args, &arg);
+			if (match_int(args, &arg))
+				return -EINVAL;
 			if (arg != 1)
 				break;
 
-- 
2.7.4
