From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Remove unnecessary hba_dev_list walk + release from core_delete_hba
Date: Mon, 24 Jan 2011 21:13:33 -0800
Message-ID: <1295932414-19434-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm4-vm0.bullet.mail.ne1.yahoo.com ([98.138.90.253]:25649 "HELO
	nm4-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751281Ab1AYFTn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2011 00:19:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes a legacy struct se_hba->hba_dev_list -> se_release_device_for_hba()
list walk in core_delete_hba(), which is no longer required while using configfs
VFS level parent/child struct config_group dependency referencing.  The reason
is because any struct se_hba->hba_dev_list-> struct se_device members are going
to have to be released via:

	rmdir /sys/kernel/config/target/core/$HBA/*

before rmdir release of struct se_hba via target_core_configfs.c:
target_core_call_delhbafromtarget() -> core_delete_hba()

	rmdir /sys/kernel/config/target/core/$HBA

to release struct se_hba in core_delete_hba().

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_hba.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index a99760a..1f44cd2 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -153,19 +153,8 @@ out_free_hba:
 int
 core_delete_hba(struct se_hba *hba)
 {
-	struct se_device *dev, *dev_tmp;
-
-	spin_lock(&hba->device_lock);
-	list_for_each_entry_safe(dev, dev_tmp, &hba->hba_dev_list, dev_list) {
-
-		se_clear_dev_ports(dev);
-		spin_unlock(&hba->device_lock);
-
-		se_release_device_for_hba(dev);
-
-		spin_lock(&hba->device_lock);
-	}
-	spin_unlock(&hba->device_lock);
+	if (!list_empty(&hba->hba_dev_list))
+		dump_stack();
 
 	hba->transport->detach_hba(hba);
 
-- 
1.5.6.5

