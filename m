From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] [bs_sg]: Add bs_sg_init() for STGT LUN passthrough
Date: Tue,  1 Jun 2010 01:50:52 -0700
Message-ID: <1275382252-17689-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:35598 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753411Ab0FAItq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2010 04:49:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharr>
Cc: James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds bs_sg_init() that is called from existing usr/target.c:tgt_device_create()
code via struct backingstore_template->bs_init() in order to setup the passthrough specific
queue and completion handlers for struct scsi_lu->cmd_perform() and ->cmd_done().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 usr/bs_sg.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/usr/bs_sg.c b/usr/bs_sg.c
index 8baa480..2fcb0d2 100644
--- a/usr/bs_sg.c
+++ b/usr/bs_sg.c
@@ -192,6 +192,25 @@ static int init_sg_device(int fd)
 	return 0;
 }
 
+static int bs_sg_init(struct scsi_lu *lu)
+{
+	/*
+	 * Setup struct scsi_lu->cmd_perform() passthrough pointer
+	 * (if available) for the underlying device type.
+	 */
+	lu->cmd_perform = &target_cmd_perform_passthrough;
+	if (!(lu->cmd_perform)) {
+		eprintf("Unable to locate lu->cmd_perform() for bs_sg\n");
+		return -1;
+	}
+	/*
+	 * Setup struct scsi_lu->cmd_done() passthrough pointer using
+	 * usr/target.c:__cmd_done_passthrough().
+	 */
+	lu->cmd_done = &__cmd_done_passthrough;
+	return 0;
+}
+
 static int bs_sg_open(struct scsi_lu *lu, char *path, int *fd, uint64_t *size)
 {
 	int sg_fd, err;
@@ -238,6 +257,7 @@ static int bs_sg_cmd_done(struct scsi_cmd *cmd)
 static struct backingstore_template sg_bst = {
 	.bs_name		= "sg",
 	.bs_datasize		= 0,
+	.bs_init		= bs_sg_init,
 	.bs_open		= bs_sg_open,
 	.bs_close		= bs_sg_close,
 	.bs_cmd_submit		= bs_sg_cmd_submit,
-- 
1.5.6.5

