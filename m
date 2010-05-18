From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] [tgt]: Add support for SG_IO CDB passthrough in scsi_cmd_perform()
Date: Mon, 17 May 2010 22:13:09 -0700
Message-ID: <1274159589-6095-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:33320 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754109Ab0ERC1y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 May 2010 22:27:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes usr/scsi.c:scsi_cmd_perform() to first check to see if
the struct backingstore_template->bs_passthrough=1 for SG_IO, then
check for a valid struct device_type_template->cmd_passthrough()
function pointer to determine if the device supports SG_IO.

This patch then updates the device_type in usr/sb.c to enable the functionality
for TYPE_DISK.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 usr/sbc.c  |    1 +
 usr/scsi.c |   11 +++++++++++
 usr/tgtd.h |    1 +
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/usr/sbc.c b/usr/sbc.c
index a048d53..d53f7f9 100644
--- a/usr/sbc.c
+++ b/usr/sbc.c
@@ -269,6 +269,7 @@ static struct device_type_template sbc_template = {
 	.lu_online	= spc_lu_online,
 	.lu_offline	= spc_lu_offline,
 	.lu_exit	= spc_lu_exit,
+	.cmd_passthrough = sbc_rw,
 	.ops		= {
 		{spc_test_unit,},
 		{spc_illegal_op,},
diff --git a/usr/scsi.c b/usr/scsi.c
index cef231b..1db786e 100644
--- a/usr/scsi.c
+++ b/usr/scsi.c
@@ -242,6 +242,17 @@ int scsi_cmd_perform(int host_no, struct scsi_cmd *cmd)
 
 	if (spc_access_check(cmd))
 		return SAM_STAT_RESERVATION_CONFLICT;
+	/* 
+	 * Use dev_type_template->cmd_passthrough() for usr/bs_sg.c devices
+	 */
+	if (cmd->dev->bst->bs_passthrough) {
+		if (!(cmd->dev->dev_type_template.cmd_passthrough)) {
+			eprintf("cmd->dev->dev_type_template.cmd_passthrough()"
+				" is NULL!\n");
+			return SAM_STAT_CHECK_CONDITION;
+		}
+		return cmd->dev->dev_type_template.cmd_passthrough(host_no, cmd);
+	}
 
 	return cmd->dev->dev_type_template.ops[op].cmd_perform(host_no, cmd);
 }
diff --git a/usr/tgtd.h b/usr/tgtd.h
index 4f26a29..f8ee47f 100644
--- a/usr/tgtd.h
+++ b/usr/tgtd.h
@@ -108,6 +108,7 @@ struct device_type_template {
 	int (*lu_config)(struct scsi_lu *lu, char *args);
 	int (*lu_online)(struct scsi_lu *lu);
 	int (*lu_offline)(struct scsi_lu *lu);
+	int (*cmd_passthrough)(int, struct scsi_cmd *);
 
 	struct device_type_operations ops[256];
 
-- 
1.5.6.5

