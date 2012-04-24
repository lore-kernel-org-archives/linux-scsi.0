From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/6] qla4xxx: Fix clear ddb mbx command failure issue.
Date: Mon, 23 Apr 2012 22:32:34 -0700
Message-ID: <1335245557-17169-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1335245557-17169-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:35334
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939Ab2DXFsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2012 01:48:09 -0400
In-Reply-To: <1335245557-17169-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

Allow ddb state to change to DDB_DS_NO_CONNECTION_ACTIVE or
DDB_DS_SESSION_FAILED before issuing clear ddb mailbox cmd,
because clear ddb mailbox cmd fails if the ddb state is not
equal to DDB_DS_NO_CONNECTION_ACTIVE or DDB_DS_SESSION_FAILED.

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ee47820..45144aa 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1555,19 +1555,53 @@ static void qla4xxx_session_destroy(struct iscsi_cls_session *cls_sess)
 	struct iscsi_session *sess;
 	struct ddb_entry *ddb_entry;
 	struct scsi_qla_host *ha;
-	unsigned long flags;
+	unsigned long flags, wtime;
+	struct dev_db_entry *fw_ddb_entry = NULL;
+	dma_addr_t fw_ddb_entry_dma;
+	uint32_t ddb_state;
+	int ret;
 
 	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
 	sess = cls_sess->dd_data;
 	ddb_entry = sess->dd_data;
 	ha = ddb_entry->ha;
 
+	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+					  &fw_ddb_entry_dma, GFP_KERNEL);
+	if (!fw_ddb_entry) {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: Unable to allocate dma buffer\n", __func__);
+		goto destroy_session;
+	}
+
+	wtime = jiffies + (HZ * LOGOUT_TOV);
+	do {
+		ret = qla4xxx_get_fwddb_entry(ha, ddb_entry->fw_ddb_index,
+					      fw_ddb_entry, fw_ddb_entry_dma,
+					      NULL, NULL, &ddb_state, NULL,
+					      NULL, NULL);
+		if (ret == QLA_ERROR)
+			goto destroy_session;
+
+		if ((ddb_state == DDB_DS_NO_CONNECTION_ACTIVE) ||
+		    (ddb_state == DDB_DS_SESSION_FAILED))
+			goto destroy_session;
+
+		schedule_timeout_uninterruptible(HZ);
+	} while ((time_after(wtime, jiffies)));
+
+destroy_session:
 	qla4xxx_clear_ddb_entry(ha, ddb_entry->fw_ddb_index);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qla4xxx_free_ddb(ha, ddb_entry);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	iscsi_session_teardown(cls_sess);
+
+	if (fw_ddb_entry)
+		dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+				  fw_ddb_entry, fw_ddb_entry_dma);
 }
 
 static struct iscsi_cls_conn *
-- 
1.7.9.1.265.gb3a76


