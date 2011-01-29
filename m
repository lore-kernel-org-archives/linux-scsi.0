From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 17/24] target: Remove unnecessary hba_dev_list walk + release from core_delete_hba
Date: Sat, 29 Jan 2011 10:36:17 -0800
Message-ID: <1296326184-16664-18-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm22.bullet.mail.ac4.yahoo.com ([98.139.52.219]:20286 "HELO
	nm22.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754780Ab1A2ShC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:37:02 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Fubo Chen <fubo.chen@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Fubo Chen <fubo.chen@gmail.com>

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
Reported-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    2 ++
 drivers/target/target_core_hba.c    |   15 ++-------------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 95dfe3a..02b835f 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -796,6 +796,8 @@ void se_clear_dev_ports(struct se_device *dev)
 		spin_lock(&lun->lun_sep_lock);
 		if (lun->lun_se_dev == NULL) {
 			spin_unlock(&lun->lun_sep_lock);
+			spin_lock(&hba->device_lock);
+			spin_lock(&dev->se_port_lock);
 			continue;
 		}
 		spin_unlock(&lun->lun_sep_lock);
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 29dc3fa..cc8fa05 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -154,19 +154,8 @@ out_free_hba:
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
1.7.3.5

