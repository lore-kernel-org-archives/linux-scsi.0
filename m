From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] target: remove dead code
Date: Tue, 9 May 2017 16:46:04 -0500
Message-ID: <20170509214604.GA7643@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Local variable _ret_ is assigned to a constant value and it is never
updated again. Remove this variable and the dead code it guards.

Addresses-Coverity-ID: 140761
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/target/target_core_rd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index ddc216c..6e8ef23 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -568,7 +568,7 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 	struct rd_dev *rd_dev = RD_DEV(dev);
 	char *orig, *ptr, *opts;
 	substring_t args[MAX_OPT_ARGS];
-	int ret = 0, arg, token;
+	int arg, token;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -603,7 +603,7 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 	}
 
 	kfree(orig);
-	return (!ret) ? count : ret;
+	return count;
 }
 
 static ssize_t rd_show_configfs_dev_params(struct se_device *dev, char *b)
-- 
2.5.0
