From: vikas.chaudhary@qlogic.com
Subject: [PATCH 3/5] qla4xxx: Fix smatch warnings
Date: Wed, 17 Apr 2013 05:15:28 -0400
Message-ID: <1366190130-16556-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1366190130-16556-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:58295 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754644Ab3DQJjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Apr 2013 05:39:14 -0400
In-Reply-To: <1366190130-16556-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Fix following smatch warnings:-
drivers/scsi/qla4xxx/ql4_os.c:6573
qla4xxx_sysfs_ddb_set_param() warn: possible memory leak of 'fw_ddb_entry'
drivers/scsi/qla4xxx/ql4_os.c:6596
qla4xxx_sysfs_ddb_delete() warn: variable dereferenced before check 'fnode_sess'
(see line 6584)
drivers/scsi/qla4xxx/ql4_os.c:6632
qla4xxx_sysfs_ddb_delete() error: potential NULL dereference 'fw_ddb_entry'.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3682fbd..7f13caa 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6366,20 +6366,11 @@ qla4xxx_sysfs_ddb_set_param(struct iscsi_bus_flash_session *fnode_sess,
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
-	struct dev_db_entry *fw_ddb_entry = NULL;
 	struct iscsi_flashnode_param_info *fnode_param;
 	struct nlattr *attr;
 	int rc = QLA_ERROR;
 	uint32_t rem = len;
 
-	fw_ddb_entry = kzalloc(sizeof(*fw_ddb_entry), GFP_KERNEL);
-	if (!fw_ddb_entry) {
-		DEBUG2(ql4_printk(KERN_ERR, ha,
-				  "%s: Unable to allocate ddb buffer\n",
-				  __func__));
-		return -ENOMEM;
-	}
-
 	nla_for_each_attr(attr, data, len, rem) {
 		fnode_param = nla_data(attr);
 
@@ -6593,11 +6584,6 @@ static int qla4xxx_sysfs_ddb_delete(struct iscsi_bus_flash_session *fnode_sess)
 	int target_id;
 	int rc = 0;
 
-	if (!fnode_sess) {
-		rc = -EINVAL;
-		goto exit_ddb_del;
-	}
-
 	if (fnode_sess->is_boot_target) {
 		rc = -EPERM;
 		DEBUG2(ql4_printk(KERN_ERR, ha,
@@ -6629,8 +6615,7 @@ static int qla4xxx_sysfs_ddb_delete(struct iscsi_bus_flash_session *fnode_sess)
 
 		dev_db_start_offset += (fnode_sess->target_id *
 				       sizeof(*fw_ddb_entry));
-		dev_db_start_offset += (void *)&(fw_ddb_entry->cookie) -
-				       (void *)fw_ddb_entry;
+		dev_db_start_offset += offsetof(struct dev_db_entry, cookie);
 
 		ddb_size = sizeof(*ddb_cookie);
 	}
-- 
1.8.2.GIT

