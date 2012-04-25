From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 3/5] qla2xxx: Proper completion to scsi-ml for scsi status task_set_full and busy.
Date: Wed, 25 Apr 2012 07:26:15 -0700
Message-ID: <1335363977-6816-4-git-send-email-chad.dupuis@qlogic.com>
References: <1335363977-6816-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:25652
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab2DYOl5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Apr 2012 10:41:57 -0400
Received: from mail81-db3 (localhost [127.0.0.1])	by mail81-db3-R.bigfish.com
 (Postfix) with ESMTP id 5A4C33E027A	for <linux-scsi@vger.kernel.org>; Wed, 25
 Apr 2012 14:41:56 +0000 (UTC)
In-Reply-To: <1335363977-6816-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

In case of firmmware detected under-run condition and scsi status of task_set_full
or busy_condition, DID_OK is returned to scsi-ml for faster recovery.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c |   15 +++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 897731b..62324a1 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -15,7 +15,7 @@
  * | Mailbox commands             |       0x113e       | 0x112c-0x112e  |
  * |                              |                    | 0x113a         |
  * | Device Discovery             |       0x2086       | 0x2020-0x2022  |
- * | Queue Command and IO tracing |       0x302f       | 0x3006,0x3008  |
+ * | Queue Command and IO tracing |       0x3030       | 0x3006,0x3008  |
  * |                              |                    | 0x302d-0x302e  |
  * | DPC Thread                   |       0x401c       |		|
  * | Async Events                 |       0x505d       | 0x502b-0x502f  |
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f79844c..ce42288 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1715,13 +1715,24 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				res = DID_ERROR << 16;
 				break;
 			}
-		} else {
+		} else if (lscsi_status != SAM_STAT_TASK_SET_FULL &&
+			    lscsi_status != SAM_STAT_BUSY) {
+			/*
+			 * scsi status of task set and busy are considered to be
+			 * task not completed.
+			 */
+
 			ql_dbg(ql_dbg_io, fcport->vha, 0x301f,
 			    "Dropped frame(s) detected (0x%x "
-			    "of 0x%x bytes).\n", resid, scsi_bufflen(cp));
+			    "of 0x%x bytes).\n", resid,
+			    scsi_bufflen(cp));
 
 			res = DID_ERROR << 16 | lscsi_status;
 			goto check_scsi_status;
+		} else {
+			ql_dbg(ql_dbg_io, fcport->vha, 0x3030,
+			    "scsi_status: 0x%x, lscsi_status: 0x%x\n",
+			    scsi_status, lscsi_status);
 		}
 
 		res = DID_OK << 16 | lscsi_status;
-- 
1.6.0.2


