From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 5/9] qla2xxx: Double check for command completion if abort mailbox command fails.
Date: Tue, 16 Aug 2011 11:29:26 -0700
Message-ID: <1313519370-22963-6-git-send-email-chad.dupuis@qlogic.com>
References: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:26888 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1HPSjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2011 14:39:33 -0400
In-Reply-To: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Close a small window where we could falsely fail an abort request if the mailbox
command fails but the command was returned during interrupt context.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2caab83..4cace3f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -918,6 +918,10 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	qla2x00_sp_compl(ha, sp);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
+	/* Did the command return during mailbox execution? */
+	if (ret == FAILED && !CMD_SP(cmd))
+		ret = SUCCESS;
+
 	/* Wait for the command to be returned. */
 	if (wait) {
 		if (qla2x00_eh_wait_on_command(cmd) != QLA_SUCCESS) {
-- 
1.6.0.2


