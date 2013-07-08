From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 1/7] qla4xxx: Allow removal of failed session using logout.
Date: Mon, 8 Jul 2013 08:33:05 -0400
Message-ID: <1373286791-29659-2-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:5508 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216Ab3GHNAs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jul 2013 09:00:48 -0400
Received: from mail60-co9 (localhost [127.0.0.1])	by mail60-co9-R.bigfish.com
 (Postfix) with ESMTP id 548DC2C02DD	for <linux-scsi@vger.kernel.org>; Mon,  8
 Jul 2013 13:00:47 +0000 (UTC)
Received: from CO9EHSMHS017.bigfish.com (unknown [10.236.132.228])	by
 mail60-co9.bigfish.com (Postfix) with ESMTP id 47CD358004B	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:00:44 +0000 (UTC)
In-Reply-To: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

If logout is performed on a failed session entry then that session
should be gracefully removed.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    1 +
 drivers/scsi/qla4xxx/ql4_os.c  |   48 +++++++++++++++++++++++++++++++++------
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index ddf16a8..50dc0c7 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -335,6 +335,7 @@ struct ql4_tuple_ddb {
 #define DF_BOOT_TGT		1	/* Boot target entry */
 #define DF_ISNS_DISCOVERED	2	/* Device was discovered via iSNS */
 #define DF_FO_MASKED		3
+#define DF_DISABLE_RELOGIN		4	/* Disable relogin to device */
 
 enum qla4_work_type {
 	QLA4_EVENT_AEN,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 84d9361..ee2f903 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3583,7 +3583,9 @@ static void qla4xxx_relogin_devices(struct iscsi_cls_session *cls_session)
 		} else {
 			/* Trigger relogin */
 			if (ddb_entry->ddb_type == FLASH_DDB) {
-				if (!test_bit(DF_RELOGIN, &ddb_entry->flags))
+				if (!(test_bit(DF_RELOGIN, &ddb_entry->flags) ||
+				      test_bit(DF_DISABLE_RELOGIN,
+					       &ddb_entry->flags)))
 					qla4xxx_arm_relogin_timer(ddb_entry);
 			} else
 				iscsi_session_failure(cls_session->dd_data,
@@ -3686,6 +3688,9 @@ static void qla4xxx_dpc_relogin(struct iscsi_cls_session *cls_sess)
 	if (!(ddb_entry->ddb_type == FLASH_DDB))
 		return;
 
+	if (test_bit(DF_DISABLE_RELOGIN, &ddb_entry->flags))
+		return;
+
 	if (test_and_clear_bit(DF_RELOGIN, &ddb_entry->flags) &&
 	    !iscsi_is_session_online(cls_sess)) {
 		DEBUG2(ql4_printk(KERN_INFO, ha,
@@ -6014,13 +6019,6 @@ static int qla4xxx_sysfs_ddb_logout_sid(struct iscsi_cls_session *cls_sess)
 		goto exit_ddb_logout;
 	}
 
-	options = LOGOUT_OPTION_CLOSE_SESSION;
-	if (qla4xxx_session_logout_ddb(ha, ddb_entry, options) == QLA_ERROR) {
-		ql4_printk(KERN_ERR, ha, "%s: Logout failed\n", __func__);
-		ret = -EIO;
-		goto exit_ddb_logout;
-	}
-
 	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
 					  &fw_ddb_entry_dma, GFP_KERNEL);
 	if (!fw_ddb_entry) {
@@ -6030,6 +6028,38 @@ static int qla4xxx_sysfs_ddb_logout_sid(struct iscsi_cls_session *cls_sess)
 		goto exit_ddb_logout;
 	}
 
+	if (test_and_set_bit(DF_DISABLE_RELOGIN, &ddb_entry->flags))
+		goto ddb_logout_init;
+
+	ret = qla4xxx_get_fwddb_entry(ha, ddb_entry->fw_ddb_index,
+				      fw_ddb_entry, fw_ddb_entry_dma,
+				      NULL, NULL, &ddb_state, NULL,
+				      NULL, NULL);
+	if (ret == QLA_ERROR)
+		goto ddb_logout_init;
+
+	if (ddb_state == DDB_DS_SESSION_ACTIVE)
+		goto ddb_logout_init;
+
+	/* wait until next relogin is triggered using DF_RELOGIN and
+	 * clear DF_RELOGIN to avoid invocation of further relogin
+	 */
+	wtime = jiffies + (HZ * RELOGIN_TOV);
+	do {
+		if (test_and_clear_bit(DF_RELOGIN, &ddb_entry->flags))
+			goto ddb_logout_init;
+
+		schedule_timeout_uninterruptible(HZ);
+	} while ((time_after(wtime, jiffies)));
+
+ddb_logout_init:
+	atomic_set(&ddb_entry->retry_relogin_timer, INVALID_ENTRY);
+	atomic_set(&ddb_entry->relogin_timer, 0);
+
+	options = LOGOUT_OPTION_CLOSE_SESSION;
+	qla4xxx_session_logout_ddb(ha, ddb_entry, options);
+
+	memset(fw_ddb_entry, 0, sizeof(*fw_ddb_entry));
 	wtime = jiffies + (HZ * LOGOUT_TOV);
 	do {
 		ret = qla4xxx_get_fwddb_entry(ha, ddb_entry->fw_ddb_index,
@@ -6059,10 +6089,12 @@ ddb_logout_clr_sess:
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qla4xxx_free_ddb(ha, ddb_entry);
+	clear_bit(ddb_entry->fw_ddb_index, ha->ddb_idx_map);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	iscsi_session_teardown(ddb_entry->sess);
 
+	clear_bit(DF_DISABLE_RELOGIN, &ddb_entry->flags);
 	ret = QLA_SUCCESS;
 
 exit_ddb_logout:
-- 
1.7.1


