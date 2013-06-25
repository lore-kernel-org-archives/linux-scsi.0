From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 07/16] qla2xxx: Clean up qla24xx_iidma()
Date: Tue, 25 Jun 2013 11:27:22 -0400
Message-ID: <1372174051-4211-8-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:44009
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977Ab3FYPxx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:53 -0400
Received: from mail190-co9 (localhost [127.0.0.1])	by
 mail190-co9-R.bigfish.com (Postfix) with ESMTP id D534DC402CE	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:52 +0000 (UTC)
Received: from CO9EHSMHS026.bigfish.com (unknown [10.236.132.231])	by
 mail190-co9.bigfish.com (Postfix) with ESMTP id 95994740053	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:50 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Remove dead code and simplify a pointer computation.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    9 +--------
 drivers/scsi/qla2xxx/qla_dbg.c |    3 ++-
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 5ba0cc1..9a30b69 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1282,14 +1282,7 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
-	port_param = (struct qla_port_param *)((char *)bsg_job->request +
-		sizeof(struct fc_bsg_request));
-	if (!port_param) {
-		ql_log(ql_log_warn, vha, 0x7047,
-		    "port_param header not provided.\n");
-		return -EINVAL;
-	}
-
+	port_param = (void *)bsg_job->request + sizeof(struct fc_bsg_request);
 	if (port_param->fc_scsi_addr.dest_type != EXT_DEF_TYPE_WWPN) {
 		ql_log(ql_log_warn, vha, 0x7048,
 		    "Invalid destination type.\n");
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 3cc2105..91a1166 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -35,7 +35,8 @@
  * |                              |                    | 0x70a5,0x70a6, |
  * |                              |                    | 0x70a8,0x70ab, |
  * |                              |                    | 0x70ad-0x70ae, |
- * |                              |                    | 0x70d1-0x70da  |
+ * |                              |                    | 0x70d1-0x70da, |
+ * |                              |                    | 0x7047		|
  * | Task Management              |       0x803c       | 0x8025-0x8026  |
  * |                              |                    | 0x800b,0x8039  |
  * | AER/EEH                      |       0x9011       |		|
-- 
1.7.7


