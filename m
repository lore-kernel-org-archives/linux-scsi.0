From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] dm-mpath: always return reservation conflict
Date: Tue,  2 Aug 2016 14:36:32 +0200
Message-ID: <1470141392-25479-2-git-send-email-hch@lst.de>
References: <1470141392-25479-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40259 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934219AbcHBMgk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2016 08:36:40 -0400
In-Reply-To: <1470141392-25479-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: hare@suse.com, Hannes Reinecke <hare@suse.de>

From: Hannes Reinecke <hare@suse.de>

If dm-mpath encounters an reservation conflict it should not fail the
path (as communication with the target is not affected) but should
rather retry on another path. However, in doing so we might be inducing
a ping-pong between paths, with no guarantee of any forward progress.

And arguably a reservation conflict is an unexpected error, so we should
be passing it upwards to allow the application to take appropriate steps.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Tested-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 7eac080..8d2f916 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1555,16 +1555,22 @@ static int do_end_io(struct multipath *m, struct request *clone,
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
 
 	if (!atomic_read(&m->nr_valid_paths)) {
 		if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
 			if (!must_push_back_rq(m))
 				r = -EIO;
-		} else {
-			if (error == -EBADE)
-				r = error;
 		}
 	}
 
-- 
2.1.4

