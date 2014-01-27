From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Warn on invalid command completion
Date: Mon, 27 Jan 2014 09:34:34 +0100
Message-ID: <1390811674-53490-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaA0Ieg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jan 2014 03:34:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Whenever a command is issued via ->queuecommand() the completion
is expected to be done via 'scsi_done'. Any completion _not_
initiated via 'scsi_done' is invalid.
Most drivers use the 'host_scribble' pointer to link back to the
(driver-specific) command structure, which will be freed prior
to the call to 'scsi_done'. So if we zero out the host_scribble
pointer in scsi_done() we can use this as a marker that
scsi_done() has been called.
Hence we can easily check for invalid command completion by
just checking for a non-zero value for host_scribble in
scsi_put_command().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c       | 3 +++
 drivers/scsi/scsi_error.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d8afec8..c041fe3 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -356,6 +356,8 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 
 	cancel_delayed_work(&cmd->abort_work);
 
+	WARN_ON(cmd->host_scribble);
+
 	__scsi_put_command(cmd->device->host, cmd, &sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_put_command);
@@ -757,6 +759,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
  */
 static void scsi_done(struct scsi_cmnd *cmd)
 {
+	cmd->host_scribble = NULL;
 	trace_scsi_dispatch_cmd_done(cmd);
 	blk_complete_request(cmd->request);
 }
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5141235..4790967 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2052,6 +2052,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
+		scmd->host_scribble = NULL;
 		if (scsi_device_online(scmd->device) &&
 		    !scsi_noretry_cmd(scmd) &&
 		    (++scmd->retries <= scmd->allowed)) {
-- 
1.7.12.4

