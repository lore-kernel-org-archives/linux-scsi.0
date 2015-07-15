From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-mpath: always return reservation conflict
Date: Wed, 15 Jul 2015 13:23:24 +0200
Message-ID: <1436959404-14035-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbbGOLX3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2015 07:23:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>

If dm-mpath encounters an reservation conflict it should not
fail the path (as communication with the target is not affected)
but should rather retry on another path.
However, in doing so we might be inducing a ping-pong between
paths, with no guarantee of any forward progress.
And arguably a reservation conflict is an unexpected error,
so we should be passing it upwards to allow the application
to take appropriate steps.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5a67671..e65d266 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1269,7 +1269,16 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (noretry_error(error))
 		return error;
 
-	if (mpio->pgpath)
+	/*
+	 * EBADE signals an reservation conflict.
+	 * We shouldn't fail the path here as we can communicate with
+	 * the target. We should failover to the next path, but in
+	 * doing so we might be causing a ping-pong between paths.
+	 * So just return the reservation conflict error.
+	 */
+	if (error == -EBADE)
+		r = error;
+	else if (mpio->pgpath)
 		fail_path(mpio->pgpath);
 
 	spin_lock_irqsave(&m->lock, flags);
@@ -1277,9 +1286,6 @@ static int do_end_io(struct multipath *m, struct request *clone,
 		if (!m->queue_if_no_path) {
 			if (!__must_push_back(m))
 				r = -EIO;
-		} else {
-			if (error == -EBADE)
-				r = error;
 		}
 	}
 	spin_unlock_irqrestore(&m->lock, flags);
-- 
1.8.5.2

