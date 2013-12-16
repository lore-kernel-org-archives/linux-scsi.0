From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 16/24] qla4xxx: Fix failure of mbox 0x31
Date: Mon, 16 Dec 2013 06:49:46 -0500
Message-ID: <1387194594-29817-17-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:52787 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754321Ab3LPMXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:38 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Issue:
While unloading driver MBOX 0x31 fail as DDB logout (MBOX 0x56)
operation is not completed.

Fix:
Wait for DDB Logout completion before MBOX 0x31

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 54 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a27da31..ce20c75 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -8886,10 +8886,54 @@ static void qla4xxx_prevent_other_port_reinit(struct scsi_qla_host *ha)
 	}
 }
 
+static void qla4xxx_destroy_ddb(struct scsi_qla_host *ha,
+		struct ddb_entry *ddb_entry)
+{
+	struct dev_db_entry *fw_ddb_entry = NULL;
+	dma_addr_t fw_ddb_entry_dma;
+	unsigned long wtime;
+	uint32_t ddb_state;
+	int options;
+	int status;
+
+	options = LOGOUT_OPTION_CLOSE_SESSION;
+	if (qla4xxx_session_logout_ddb(ha, ddb_entry, options) == QLA_ERROR) {
+		ql4_printk(KERN_ERR, ha, "%s: Logout failed\n", __func__);
+		goto clear_ddb;
+	}
+
+	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+					  &fw_ddb_entry_dma, GFP_KERNEL);
+	if (!fw_ddb_entry) {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: Unable to allocate dma buffer\n", __func__);
+		goto clear_ddb;
+	}
+
+	wtime = jiffies + (HZ * LOGOUT_TOV);
+	do {
+		status = qla4xxx_get_fwddb_entry(ha, ddb_entry->fw_ddb_index,
+						 fw_ddb_entry, fw_ddb_entry_dma,
+						 NULL, NULL, &ddb_state, NULL,
+						 NULL, NULL);
+		if (status == QLA_ERROR)
+			goto clear_ddb;
+
+		if ((ddb_state == DDB_DS_NO_CONNECTION_ACTIVE) ||
+		    (ddb_state == DDB_DS_SESSION_FAILED))
+			goto clear_ddb;
+
+		schedule_timeout_uninterruptible(HZ);
+	} while ((time_after(wtime, jiffies)));
+
+clear_ddb:
+	qla4xxx_clear_ddb_entry(ha, ddb_entry->fw_ddb_index);
+	return;
+}
+
 static void qla4xxx_destroy_fw_ddb_session(struct scsi_qla_host *ha)
 {
 	struct ddb_entry *ddb_entry;
-	int options;
 	int idx;
 
 	for (idx = 0; idx < MAX_DDB_ENTRIES; idx++) {
@@ -8898,13 +8942,7 @@ static void qla4xxx_destroy_fw_ddb_session(struct scsi_qla_host *ha)
 		if ((ddb_entry != NULL) &&
 		    (ddb_entry->ddb_type == FLASH_DDB)) {
 
-			options = LOGOUT_OPTION_CLOSE_SESSION;
-			if (qla4xxx_session_logout_ddb(ha, ddb_entry, options)
-			    == QLA_ERROR)
-				ql4_printk(KERN_ERR, ha, "%s: Logout failed\n",
-					   __func__);
-
-			qla4xxx_clear_ddb_entry(ha, ddb_entry->fw_ddb_index);
+			qla4xxx_destroy_ddb(ha, ddb_entry);
 			/*
 			 * we have decremented the reference count of the driver
 			 * when we setup the session to have the driver unload
-- 
1.8.2.GIT

