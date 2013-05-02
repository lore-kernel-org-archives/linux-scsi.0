From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Double completion on retry
Date: Thu,  2 May 2013 10:31:02 +0200
Message-ID: <1367483462-22576-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab3EBIbI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 May 2013 04:31:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>

When blk_end_request() returns 'false' in scsi_end_request the
request is invalid after blk_end_request_all(). So we must not
return the then stale request pointer. Doing so will result
in a potential double completion.
And we should be calling scsi_release_buffers() before
blk_end_request_all().

Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c31187d..8dba66b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -581,9 +581,11 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 	 */
 	if (blk_end_request(req, error, bytes)) {
 		/* kill remainder if no retrys */
-		if (error && scsi_noretry_cmd(cmd))
+		if (error && scsi_noretry_cmd(cmd)) {
+			scsi_release_buffers(cmd);
 			blk_end_request_all(req, error);
-		else {
+			cmd = NULL;
+		} else {
 			if (requeue) {
 				/*
 				 * Bleah.  Leftovers again.  Stick the
