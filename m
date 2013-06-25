From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 09/16] qla2xxx: Remove dead code in qla2x00_configure_hba()
Date: Tue, 25 Jun 2013 11:27:24 -0400
Message-ID: <1372174051-4211-10-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19902 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab3FYPxz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:55 -0400
Received: from mail208-tx2 (localhost [127.0.0.1])	by
 mail208-tx2-R.bigfish.com (Postfix) with ESMTP id 1A36DB40212	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:52 +0000 (UTC)
Received: from TX2EHSMHS009.bigfish.com (unknown [10.9.14.254])	by
 mail208-tx2.bigfish.com (Postfix) with ESMTP id A765038003F	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:49 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

At the end of qla2x00_configure_hba() we know that rval == QLA_SUCCESS.
Hence remove the dead code.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    8 --------
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 74a2121..91dbd81 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -15,6 +15,7 @@
  * | Mailbox commands             |       0x117a       | 0x111a-0x111b  |
  * |                              |                    | 0x1155-0x1158  |
  * | Device Discovery             |       0x2095       | 0x2020-0x2022, |
+ * |                              |                    | 0x2011-0x2012, |
  * |                              |                    | 0x2016         |
  * | Queue Command and IO tracing |       0x3058       | 0x3006-0x300b  |
  * |                              |                    | 0x3027-0x3028  |
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3565dfd..f2216ed 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2309,14 +2309,6 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 		    "Topology - %s, Host Loop address 0x%x.\n",
 		    connect_type, vha->loop_id);
 
-	if (rval) {
-		ql_log(ql_log_warn, vha, 0x2011,
-		    "%s FAILED\n", __func__);
-	} else {
-		ql_dbg(ql_dbg_disc, vha, 0x2012,
-		    "%s success\n", __func__);
-	}
-
 	return(rval);
 }
 
-- 
1.7.7


