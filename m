From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Silencing 'killing requests for dead queue'
Date: Wed,  9 Nov 2011 08:39:24 +0100
Message-ID: <1320824364-8510-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab1KIHjb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Nov 2011 02:39:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When we tear down a device we try to flush all outstanding
commands in scsi_free_queue(). However the check in
scsi_request_fn() is imperfect as it only signals that
we _might start_ aborting commands, not that we've actually
aborted some.
So move the printk inside the scsi_kill_request function,
this will also give us a hint about which commands are aborted.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 06bc265..f85cfa6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1409,6 +1409,8 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 
 	blk_start_request(req);
 
+	scmd_printk(KERN_INFO, cmd, "killing request\n");
+
 	sdev = cmd->device;
 	starget = scsi_target(sdev);
 	shost = sdev->host;
@@ -1490,7 +1492,6 @@ static void scsi_request_fn(struct request_queue *q)
 	struct request *req;
 
 	if (!sdev) {
-		printk("scsi: killing requests for dead queue\n");
 		while ((req = blk_peek_request(q)) != NULL)
 			scsi_kill_request(req, q);
 		return;
