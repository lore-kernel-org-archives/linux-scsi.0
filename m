From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] target: Fix incorrect unmap_zeroes_data_store return
Date: Thu, 11 Feb 2016 07:02:26 +0000
Message-ID: <1455174146-29700-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jamie Pocas <jamie.pocas@emc.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes an incorrect return of zero from the new
unmap_zeroes_data_store() configfs store attribute handler
introduced in v4.5-rc1, to use the correct 'count' bytes
return value.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3327c49..713c63d9 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -898,7 +898,7 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 	da->unmap_zeroes_data = flag;
 	pr_debug("dev[%p]: SE Device Thin Provisioning LBPRZ bit: %d\n",
 		 da->da_dev, flag);
-	return 0;
+	return count;
 }
 
 /*
-- 
1.9.1
