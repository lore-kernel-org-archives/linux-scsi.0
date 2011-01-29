From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 22/24] target: Remove unnecessary container_of() pointer check
Date: Sat, 29 Jan 2011 10:36:22 -0800
Message-ID: <1296326184-16664-23-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm7.bullet.mail.ac4.yahoo.com ([98.139.52.204]:25864 "HELO
	nm7.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754830Ab1A2ShQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:37:16 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Dan Carpenter <error27@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Dan Carpenter <error27@gmail.com>

As the struct configfs_item_operations target_core_dev_item_ops->release()
callback will never be null from fs/configfs/item.c:config_item_cleanup(),
this NULL pointer check is unnecessary.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit 6e9af570076fb3ad4fb7442a8243271f08779c45)
---
 drivers/target/target_core_configfs.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 99e07ba..30ae3af 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2003,12 +2003,8 @@ static void target_core_dev_release(struct config_item *item)
 {
 	struct se_subsystem_dev *se_dev = container_of(to_config_group(item),
 				struct se_subsystem_dev, se_dev_group);
-	struct config_group *dev_cg;
+	struct config_group *dev_cg = &se_dev->se_dev_group;
 
-	if (!(se_dev))
-		return;
-
-	dev_cg = &se_dev->se_dev_group;
 	kfree(dev_cg->default_groups);
 }
 
-- 
1.7.3.5

