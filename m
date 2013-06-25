From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 01/16] qla2xxx: Clear the MBX_INTR_WAIT flag when the mailbox time-out happens.
Date: Tue, 25 Jun 2013 11:27:16 -0400
Message-ID: <1372174051-4211-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:3544 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab3FYPxv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:51 -0400
Received: from mail145-co9 (localhost [127.0.0.1])	by
 mail145-co9-R.bigfish.com (Postfix) with ESMTP id BBC6C4802DA	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:49 +0000 (UTC)
Received: from CO9EHSMHS023.bigfish.com (unknown [10.236.132.253])	by
 mail145-co9.bigfish.com (Postfix) with ESMTP id 1D1443C005E	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:47 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index cfa2a20..3cc2105 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -12,7 +12,7 @@
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
  * | Module Init and Probe        |       0x014f       | 0x4b,0xba,0xfa |
- * | Mailbox commands             |       0x1179       | 0x111a-0x111b  |
+ * | Mailbox commands             |       0x117a       | 0x111a-0x111b  |
  * |                              |                    | 0x1155-0x1158  |
  * | Device Discovery             |       0x2095       | 0x2020-0x2022, |
  * |                              |                    | 0x2016         |
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3587ec2..144effd 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -177,8 +177,14 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		wait_for_completion_timeout(&ha->mbx_intr_comp, mcp->tov * HZ);
-
+		if (!wait_for_completion_timeout(&ha->mbx_intr_comp,
+		    mcp->tov * HZ)) {
+			ql_dbg(ql_dbg_mbx, vha, 0x117a,
+			    "cmd=%x Timeout.\n", command);
+			spin_lock_irqsave(&ha->hardware_lock, flags);
+			clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		}
 	} else {
 		ql_dbg(ql_dbg_mbx, vha, 0x1011,
 		    "Cmd=%x Polling Mode.\n", command);
-- 
1.7.7


