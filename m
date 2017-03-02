From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: qedi: fix build error without DEBUG_FS
Date: Thu,  2 Mar 2017 13:10:39 +0100
Message-ID: <20170302121138.2361420-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Johannes Thumshirn <jthumshirn@suse.de>, Saurav Kashyap <saurav.kashyap@cavium.com>, Nilesh Javali <nilesh.javali@cavium.com>, Chad Dupuis <chad.dupuis@cavium.com>, Manish Rangankar <manish.rangankar@cavium.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>, Arun Easi <arun.easi@cavium.com>, Hannes Reinecke <hare@suse.de>, Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Without CONFIG_DEBUG_FS, we run into a link error:

drivers/scsi/qedi/qedi_iscsi.o: In function `qedi_ep_poll':
qedi_iscsi.c:(.text.qedi_ep_poll+0x134): undefined reference to `do_not_recover'
drivers/scsi/qedi/qedi_iscsi.o: In function `qedi_ep_disconnect':
qedi_iscsi.c:(.text.qedi_ep_disconnect+0x36c): undefined reference to `do_not_recover'
drivers/scsi/qedi/qedi_iscsi.o: In function `qedi_ep_connect':
qedi_iscsi.c:(.text.qedi_ep_connect+0x350): undefined reference to `do_not_recover'
drivers/scsi/qedi/qedi_fw.o: In function `qedi_tmf_work':
qedi_fw.c:(.text.qedi_tmf_work+0x3b4): undefined reference to `do_not_recover'

This defines the symbol as a constant in this case, as there is no way to
set it to anything other than zero without DEBUG_FS. In addition, I'm renaming
it to qedi_do_not_recover in order to put it into a driver specific namespace,
as "do_not_recover" is a really bad name for a kernel-wide global identifier
when it is used only in one driver.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/qedi/qedi_debugfs.c | 22 +++++++++++-----------
 drivers/scsi/qedi/qedi_fw.c      |  4 ++--
 drivers/scsi/qedi/qedi_gbl.h     |  8 +++++++-
 drivers/scsi/qedi/qedi_iscsi.c   |  8 ++++----
 4 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_debugfs.c b/drivers/scsi/qedi/qedi_debugfs.c
index 955936274241..6baf35eefc1c 100644
--- a/drivers/scsi/qedi/qedi_debugfs.c
+++ b/drivers/scsi/qedi/qedi_debugfs.c
@@ -14,7 +14,7 @@
 #include <linux/debugfs.h>
 #include <linux/module.h>
 
-int do_not_recover;
+int qedi_do_not_recover;
 static struct dentry *qedi_dbg_root;
 
 void
@@ -74,22 +74,22 @@ qedi_dbg_exit(void)
 static ssize_t
 qedi_dbg_do_not_recover_enable(struct qedi_dbg_ctx *qedi_dbg)
 {
-	if (!do_not_recover)
-		do_not_recover = 1;
+	if (!qedi_do_not_recover)
+		qedi_do_not_recover = 1;
 
-	QEDI_INFO(qedi_dbg, QEDI_LOG_DEBUGFS, "do_not_recover=%d\n",
-		  do_not_recover);
+	QEDI_INFO(qedi_dbg, QEDI_LOG_DEBUGFS, "qedi_do_not_recover=%d\n",
+		  qedi_do_not_recover);
 	return 0;
 }
 
 static ssize_t
 qedi_dbg_do_not_recover_disable(struct qedi_dbg_ctx *qedi_dbg)
 {
-	if (do_not_recover)
-		do_not_recover = 0;
+	if (qedi_do_not_recover)
+		qedi_do_not_recover = 0;
 
-	QEDI_INFO(qedi_dbg, QEDI_LOG_DEBUGFS, "do_not_recover=%d\n",
-		  do_not_recover);
+	QEDI_INFO(qedi_dbg, QEDI_LOG_DEBUGFS, "qedi_do_not_recover=%d\n",
+		  qedi_do_not_recover);
 	return 0;
 }
 
@@ -101,7 +101,7 @@ static struct qedi_list_of_funcs qedi_dbg_do_not_recover_ops[] = {
 
 struct qedi_debugfs_ops qedi_debugfs_ops[] = {
 	{ "gbl_ctx", NULL },
-	{ "do_not_recover", qedi_dbg_do_not_recover_ops},
+	{ "qedi_do_not_recover", qedi_dbg_do_not_recover_ops},
 	{ "io_trace", NULL },
 	{ NULL, NULL }
 };
@@ -141,7 +141,7 @@ qedi_dbg_do_not_recover_cmd_read(struct file *filp, char __user *buffer,
 	if (*ppos)
 		return 0;
 
-	cnt = sprintf(buffer, "do_not_recover=%d\n", do_not_recover);
+	cnt = sprintf(buffer, "qedi_do_not_recover=%d\n", qedi_do_not_recover);
 	cnt = min_t(int, count, cnt - *ppos);
 	*ppos += cnt;
 	return cnt;
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index c9f0ef4e11b3..2bce3efc66a4 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1461,9 +1461,9 @@ static void qedi_tmf_work(struct work_struct *work)
 		  get_itt(tmf_hdr->rtt), get_itt(ctask->itt), cmd->task_id,
 		  qedi_conn->iscsi_conn_id);
 
-	if (do_not_recover) {
+	if (qedi_do_not_recover) {
 		QEDI_ERR(&qedi->dbg_ctx, "DONT SEND CLEANUP/ABORT %d\n",
-			 do_not_recover);
+			 qedi_do_not_recover);
 		goto abort_ret;
 	}
 
diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 8e488de88ece..63d793f46064 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -12,8 +12,14 @@
 
 #include "qedi_iscsi.h"
 
+#ifdef CONFIG_DEBUG_FS
+extern int qedi_do_not_recover;
+#else
+#define qedi_do_not_recover (0)
+#endif
+
 extern uint qedi_io_tracing;
-extern int do_not_recover;
+
 extern struct scsi_host_template qedi_host_template;
 extern struct iscsi_transport qedi_iscsi_transport;
 extern const struct qed_iscsi_ops *qedi_ops;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index b9f79d36142d..4cc474364c50 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -833,7 +833,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		return ERR_PTR(ret);
 	}
 
-	if (do_not_recover) {
+	if (qedi_do_not_recover) {
 		ret = -ENOMEM;
 		return ERR_PTR(ret);
 	}
@@ -957,7 +957,7 @@ static int qedi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 	struct qedi_endpoint *qedi_ep;
 	int ret = 0;
 
-	if (do_not_recover)
+	if (qedi_do_not_recover)
 		return 1;
 
 	qedi_ep = ep->dd_data;
@@ -1025,7 +1025,7 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		}
 
 		if (test_bit(QEDI_IN_RECOVERY, &qedi->flags)) {
-			if (do_not_recover) {
+			if (qedi_do_not_recover) {
 				QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 					  "Do not recover cid=0x%x\n",
 					  qedi_ep->iscsi_cid);
@@ -1039,7 +1039,7 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		}
 	}
 
-	if (do_not_recover)
+	if (qedi_do_not_recover)
 		goto ep_exit_recover;
 
 	switch (qedi_ep->state) {
-- 
2.9.0
