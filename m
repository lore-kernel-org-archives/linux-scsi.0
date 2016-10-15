From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] target: Re-add missing SCF_ACK_KREF assignment in v4.1.y
Date: Sat, 15 Oct 2016 05:34:30 +0000
Message-ID: <1476509672-27182-2-git-send-email-nab@linux-iscsi.org>
References: <1476509672-27182-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34542 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbcJOFlJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Oct 2016 01:41:09 -0400
In-Reply-To: <1476509672-27182-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Vaibhav Tandon <vst@datera.io>, Dinesh Israni <ddi@datera.io>, Nixon Vincent <nixon.vincent@calsoftinc.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a regression in >= v4.1.y code where the original
SCF_ACK_KREF assignment in target_get_sess_cmd() was dropped upstream
in commit 054922bb, but the series for addressing TMR ABORT_TASK +
LUN_RESET with fabric session reinstatement in commit febe562c20 still
depends on this code in transport_cmd_finish_abort().

The regression manifests itself as a se_cmd->cmd_kref +1 leak, where
ABORT_TASK + LUN_RESET can hang indefinately for a specific I_T session
for drivers using SCF_ACK_KREF, resulting in hung kthreads.

This patch has been verified with v4.1.y code.

Reported-by: Vaibhav Tandon <vst@datera.io>
Tested-by: Vaibhav Tandon <vst@datera.io>
Cc: Vaibhav Tandon <vst@datera.io>
Cc: stable@vger.kernel.org # 4.1+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6094a6b..00ec464 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2547,8 +2547,10 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 	 * fabric acknowledgement that requires two target_put_sess_cmd()
 	 * invocations before se_cmd descriptor release.
 	 */
-	if (ack_kref)
+	if (ack_kref) {
 		kref_get(&se_cmd->cmd_kref);
+		se_cmd->se_cmd_flags |= SCF_ACK_KREF;
+	}
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 	if (se_sess->sess_tearing_down) {
-- 
1.9.1

