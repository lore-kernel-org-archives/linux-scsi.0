From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 18/29] qla2xxx: Add new message when a new loopid is assigned.
Date: Thu, 9 Feb 2012 11:15:50 -0800
Message-ID: <1328814961-21866-19-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:3906
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758438Ab2BITcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:11 -0500
Received: from mail157-ch1 (localhost [127.0.0.1])	by
 mail157-ch1-R.bigfish.com (Postfix) with ESMTP id C88143404B3	for
 <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2012 19:32:10 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index e915310..c28309b 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -14,7 +14,7 @@
  * | Module Init and Probe        |       0x0120       | 0x4b,0xba,0xfa |
  * | Mailbox commands             |       0x113e       | 0x112c-0x112e  |
  * |                              |                    | 0x113a         |
- * | Device Discovery             |       0x2085       | 0x2020-0x2022  |
+ * | Device Discovery             |       0x2086       | 0x2020-0x2022  |
  * | Queue Command and IO tracing |       0x302f       | 0x3006,0x3008  |
  * |                              |                    | 0x302d-0x302e  |
  * | DPC Thread                   |       0x401c       |		|
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index abd095c..b28eb40 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3421,6 +3421,9 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 
 		/* If not in use then it is free to use. */
 		if (!found) {
+			ql_dbg(ql_dbg_disc, dev->vha, 0x2086,
+			    "Assigning new loopid=%x, portid=%x.\n",
+			    dev->loop_id, dev->d_id.b24);
 			break;
 		}
 
-- 
1.6.0.2


