From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/4] target: Make target_release_cmd_kref release on empty list
Date: Mon, 13 Feb 2012 11:42:25 +0000
Message-ID: <1329133347-13359-3-git-send-email-nab@linux-iscsi.org>
References: <1329133347-13359-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1329133347-13359-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Madhuranath Iyengar <mni@risingtidesystems.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes target_release_cmd_kref() to make TFO->release_cmd()
call when list_empty(&se_cmd->se_cmd_list) is TRUE.  This is required
for TMR_ABORT_TASK operation where the referenced tag descriptor may
have already been pulled of the session command list.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4a6ece1..17183da 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4056,7 +4056,7 @@ static void target_release_cmd_kref(struct kref *kref)
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 	if (list_empty(&se_cmd->se_cmd_list)) {
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
-		WARN_ON(1);
+		se_cmd->se_tfo->release_cmd(se_cmd);
 		return;
 	}
 	if (se_sess->sess_tearing_down && se_cmd->cmd_wait_set) {
-- 
1.7.2.5
