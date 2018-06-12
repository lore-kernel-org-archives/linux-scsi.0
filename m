From: Zhouyang Jia <jiazhouyang09@gmail.com>
Subject: [PATCH] scsi: qla4xxx: add error handling for try_module_get
Date: Tue, 12 Jun 2018 12:48:29 +0800
Message-ID: <1528778910-42113-1-git-send-email-jiazhouyang09@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>, QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When try_module_get fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling try_module_get.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 0e13349..6b677ab 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -7687,7 +7687,10 @@ static int qla4xxx_sysfs_ddb_logout_sid(struct iscsi_cls_session *cls_sess)
 	 * to be seamless without actually destroying the
 	 * session
 	 **/
-	try_module_get(qla4xxx_iscsi_transport.owner);
+	if (!try_module_get(qla4xxx_iscsi_transport.owner))
+		ql4_printk(KERN_WARNING, ha,
+			"%s: cannot get module.\n", __func__);
+
 	iscsi_destroy_endpoint(ddb_entry->conn->ep);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -8970,7 +8973,9 @@ static void qla4xxx_destroy_fw_ddb_session(struct scsi_qla_host *ha)
 			 * to be seamless without actually destroying the
 			 * session
 			 **/
-			try_module_get(qla4xxx_iscsi_transport.owner);
+			if (!try_module_get(qla4xxx_iscsi_transport.owner))
+				ql4_printk(KERN_WARNING, ha,
+					"%s: cannot get module.\n", __func__);
 			iscsi_destroy_endpoint(ddb_entry->conn->ep);
 			qla4xxx_free_ddb(ha, ddb_entry);
 			iscsi_session_teardown(ddb_entry->sess);
-- 
2.7.4
