From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] target: Drop nacl->device_list_lock on core_update_device_list_for_node failure
Date: Mon, 24 Jan 2011 12:37:24 -0800
Message-ID: <1295901446-17089-2-git-send-email-nab@linux-iscsi.org>
References: <1295901446-17089-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.205]:24272 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750712Ab1AXUhP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2011 15:37:15 -0500
In-Reply-To: <1295901446-17089-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Fubo Chen <fubo.chen@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Fubo Chen <fubo.chen@gmail.com>

The struct se_node_acl->device_list_lock needs to be released if either
sanity check for struct se_dev_entry->se_lun_acl or deve->se_lun fails.

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 4c2bd9c..95dfe3a 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -391,12 +391,14 @@ int core_update_device_list_for_node(
 				printk(KERN_ERR "struct se_dev_entry->se_lun_acl"
 					" already set for demo mode -> explict"
 					" LUN ACL transition\n");
+				spin_unlock_irq(&nacl->device_list_lock);
 				return -1;
 			}
 			if (deve->se_lun != lun) {
 				printk(KERN_ERR "struct se_dev_entry->se_lun does"
 					" match passed struct se_lun for demo mode"
 					" -> explict LUN ACL transition\n");
+				spin_unlock_irq(&nacl->device_list_lock);
 				return -1;
 			}
 			deve->se_lun_acl = lun_acl;
-- 
1.5.6.5

