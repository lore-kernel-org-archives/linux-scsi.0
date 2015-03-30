From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 06/15] target: Move cmd->prot_op check into target_check_read_prot
Date: Mon, 30 Mar 2015 03:28:15 +0000
Message-ID: <1427686104-14231-7-git-send-email-nab@daterainc.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35710 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbbC3D3a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Mar 2015 23:29:30 -0400
Received: by obcjt1 with SMTP id jt1so110298951obc.2
        for <linux-scsi@vger.kernel.org>; Sun, 29 Mar 2015 20:29:29 -0700 (PDT)
In-Reply-To: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the existing target_complete_ok_work() check for
cmd->prot_op into it's own function, so it's easier to add future
support for READ INSERT.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 51b62bd..e603e34 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1980,16 +1980,22 @@ static void transport_handle_queue_full(
 	schedule_work(&cmd->se_dev->qf_work_queue);
 }
 
-static bool target_check_read_strip(struct se_cmd *cmd)
+static bool target_check_read_prot(struct se_cmd *cmd)
 {
 	sense_reason_t rc;
 
-	if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_STRIP)) {
-		rc = sbc_dif_read_strip(cmd);
-		if (rc) {
-			cmd->pi_err = rc;
-			return true;
+	switch (cmd->prot_op) {
+	case TARGET_PROT_DIN_STRIP:
+		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_STRIP)) {
+			rc = sbc_dif_read_strip(cmd);
+			if (rc) {
+				cmd->pi_err = rc;
+				return true;
+			}
 		}
+		break;
+	default:
+		break;
 	}
 
 	return false;
@@ -2064,8 +2070,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		 * backend had PI enabled, if the transport will not be
 		 * performing hardware READ_STRIP offload.
 		 */
-		if (cmd->prot_op == TARGET_PROT_DIN_STRIP &&
-		    target_check_read_strip(cmd)) {
+		if (target_check_read_prot(cmd)) {
 			ret = transport_send_check_condition_and_sense(cmd,
 						cmd->pi_err, 0);
 			if (ret == -EAGAIN || ret == -ENOMEM)
-- 
1.9.1

