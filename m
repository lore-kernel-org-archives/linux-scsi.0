From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 16/24] target: Drop nacl->device_list_lock on core_update_device_list_for_node failure
Date: Sat, 29 Jan 2011 10:36:16 -0800
Message-ID: <1296326184-16664-17-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm5.bullet.mail.ac4.yahoo.com ([98.139.52.202]:28155 "HELO
	nm5.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754780Ab1A2Sg6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:36:58 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Fubo Chen <fubo.chen@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Fubo Chen <fubo.chen@gmail.com>

The struct se_node_acl->device_list_lock needs to be released if either
sanity check for struct se_dev_entry->se_lun_acl or deve->se_lun fails.

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit c0c6417c767e8b1214c5ca5e13fe6d3cf8f6e659)
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
1.7.3.5

