From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] dm-mpath: Allow 'default' hardware handler
Date: Mon,  2 Apr 2012 18:43:55 +0200
Message-ID: <1333385035-6663-3-git-send-email-hare@suse.de>
References: <1333385035-6663-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab2DBQoH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Apr 2012 12:44:07 -0400
In-Reply-To: <1333385035-6663-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>

This patch introduces a 'default' hardware handler for dm-mpath.
When specifying '1 default' dm-multipath will be using the currently
attached hardware handler.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 922a338..bbf950f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -586,15 +586,19 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 
 	if (m->hw_handler_name) {
 		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+		char *hw_handler = NULL;
 
-		r = scsi_dh_attach(q, m->hw_handler_name);
+		if (strncmp(m->hw_handler_name, "default", 6))
+			hw_handler = m->hw_handler_name;
+		
+		r = scsi_dh_attach(q, hw_handler);
 		if (r == -EBUSY) {
 			/*
 			 * Already attached to different hw_handler,
 			 * try to reattach with correct one.
 			 */
 			scsi_dh_detach(q);
-			r = scsi_dh_attach(q, m->hw_handler_name);
+			r = scsi_dh_attach(q, hw_handler);
 		}
 
 		if (r < 0) {
-- 
1.7.7

