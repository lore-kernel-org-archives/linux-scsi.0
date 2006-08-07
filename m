From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 02/10] qla4xxx: move qla4xxx_reset_target defn before call
Date: Mon, 07 Aug 2006 10:37:03 -0500
Message-ID: <20060807153703.31019.77749.stgit@bebe.enoyolf.org>
References: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:46498 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932180AbWHGPks
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 11:40:48 -0400
In-Reply-To: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

- move the defn to before the call.
- make defn static.

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 087944a..6ae7079 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1645,6 +1645,22 @@ eh_dev_reset_done:
 }
 
 /**
+ * qla4xxx_reset_target - performs target reset
+ * @ha: Pointer to host adapter structure.
+ * @ddb_entry: Pointer to device database entry
+ *
+ * This routine issues either a warm or cold target reset to the
+ * specified device. The caller must ensure that the ddb_entry pointer
+ * is valid before calling this routine.
+ *
+ **/
+static int qla4xxx_reset_target(struct scsi_qla_host *ha,
+				struct ddb_entry *ddb_entry)
+{
+	return QLA_SUCCESS;
+}
+
+/**
  * qla4xxx_eh_bus_reset - callback to issue bus reset.
  * @cmd: Pointer to Linux's SCSI command structure
  *
@@ -1692,21 +1708,6 @@ static int qla4xxx_eh_bus_reset(struct s
 }
 
 /**
- * qla4xxx_reset_target - performs target reset
- * @ha: Pointer to host adapter structure.
- * @ddb_entry: Pointer to device database entry
- *
- * This routine issues either a warm or cold target reset to the
- * specified device. The caller must ensure that the ddb_entry pointer
- * is valid before calling this routine.
- *
- **/
-int qla4xxx_reset_target(struct scsi_qla_host *ha, struct ddb_entry *ddb_entry)
-{
-	return QLA_SUCCESS;
-}
-
-/**
  * qla4xxx_flush_active_srbs - returns all outstanding i/o requests to O.S.
  * @ha: Pointer to host adapter structure.
  *
