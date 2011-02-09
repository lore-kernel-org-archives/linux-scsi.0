From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 13/31] target: Drop nacl->device_list_lock on core_update_device_list_for_node failure
Date: Wed,  9 Feb 2011 15:34:48 -0800
Message-ID: <1297294506-23579-14-git-send-email-nab@linux-iscsi.org>
References: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm30-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.69]:34766 "HELO
	nm30-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755755Ab1BIXfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:35:31 -0500
In-Reply-To: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Fubo Chen <fubo.chen@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Fubo Chen <fubo.chen@gmail.com>

The struct se_node_acl->device_list_lock needs to be released if either
sanity check for struct se_dev_entry->se_lun_acl or deve->se_lun fails.

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 969d727..9551ab5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -395,12 +395,14 @@ int core_update_device_list_for_node(
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
1.7.4

