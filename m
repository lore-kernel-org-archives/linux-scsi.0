From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/7] iscsi-target: Handle transport_generic_new_cmd failure
Date: Fri,  3 Jun 2011 18:18:15 -0700
Message-ID: <1307150298-23921-5-git-send-email-nab@linux-iscsi.org>
References: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm12.access.bullet.mail.mud.yahoo.com ([66.94.237.213]:28418
	"HELO nm12.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752110Ab1FDBTE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 21:19:04 -0400
In-Reply-To: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates iscsit_handle_scsi_cmd() to handle transport_generic_new_cmd()
failures using iscsit_add_reject_from_cmd(), and updates the comment.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 8dedfbf..6ebc247 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1162,13 +1162,11 @@ attach_cmd:
 		goto after_immediate_data;
 	}
 	/*
-	 * Call into transport_generic_handle_cdb() that now translates
-	 * into a direct transport_generic_new_cmd() call with a NULL
-	 * se_cmd->se_tfo->new_cmd_map() pointer.
+	 * Call directly into transport_generic_new_cmd() to perform
+	 * the backend memory allocation.
 	 */
-	transport_generic_new_cmd(SE_CMD(cmd));
-
-	if (SE_CMD(cmd)->se_cmd_flags & SCF_SE_CMD_FAILED) {
+	ret = transport_generic_new_cmd(&cmd->se_cmd);
+	if ((ret < 0) || (SE_CMD(cmd)->se_cmd_flags & SCF_SE_CMD_FAILED)) {
 		immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
 		dump_immediate_data = 1;
 		goto after_immediate_data;
-- 
1.7.2.5

