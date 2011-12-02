From: michaelc@cs.wisc.edu
Subject: [PATCH 3/3] qla4xxx: check for failed conn setup
Date: Thu,  1 Dec 2011 21:38:43 -0600
Message-ID: <1322797123-5299-4-git-send-email-michaelc@cs.wisc.edu>
References: <1322797123-5299-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab1LBDcJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2011 22:32:09 -0500
In-Reply-To: <1322797123-5299-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iscsi_conn_setup can fail so we must check for NULL being
returned.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 95910c9..4169c8b 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1207,6 +1207,9 @@ qla4xxx_conn_create(struct iscsi_cls_session *cls_sess, uint32_t conn_idx)
 	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
 	cls_conn = iscsi_conn_setup(cls_sess, sizeof(struct qla_conn),
 				    conn_idx);
+	if (!cls_conn)
+		return NULL;
+
 	sess = cls_sess->dd_data;
 	ddb_entry = sess->dd_data;
 	ddb_entry->conn = cls_conn;
-- 
1.7.6

