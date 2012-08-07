From: vikas.chaudhary@qlogic.com
Subject: [PATCH 1/5] qla4xxx: Fix memory corruption issue in qla4xxx_ep_connect.
Date: Tue,  7 Aug 2012 07:57:13 -0400
Message-ID: <1344340637-25526-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1344340637-25526-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:14381 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754508Ab2HGMPO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2012 08:15:14 -0400
In-Reply-To: <1344340637-25526-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

In qla4xxx_ep_connect(), qla_ep->dst_addr and dst_addr are type
struct sockaddr. We are copying sizeof(struct sockaddr_in6) bytes
from dst_addr to qla_ep->dst_addr which is 12 bytes larger. This
will cause memory corruption. So we change qla_ep->dst_addr to
struct sockaddr_storage which is of 128 byte, large enough to
hold sizeof(struct sockaddr_in6).

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 7fdba7f..c298ee9 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -752,7 +752,7 @@ struct ql4_task_data {
 
 struct qla_endpoint {
 	struct Scsi_Host *host;
-	struct sockaddr dst_addr;
+	struct sockaddr_storage dst_addr;
 };
 
 struct qla_conn {
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index cab8f66..23a10ea 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1695,7 +1695,7 @@ int qla4xxx_set_param_ddbentry(struct scsi_qla_host *ha,
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
 	sess = conn->session;
-	dst_addr = &qla_conn->qla_ep->dst_addr;
+	dst_addr = (struct sockaddr *)&qla_conn->qla_ep->dst_addr;
 
 	if (dst_addr->sa_family == AF_INET6)
 		options |= IPV6_DEFAULT_DDB_ENTRY;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9da4266..77a969a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1366,7 +1366,7 @@ static int qla4xxx_conn_get_param(struct iscsi_cls_conn *cls_conn,
 
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
-	dst_addr = &qla_conn->qla_ep->dst_addr;
+	dst_addr = (struct sockaddr *)&qla_conn->qla_ep->dst_addr;
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
-- 
1.7.8.GIT

