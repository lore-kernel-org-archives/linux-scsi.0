From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH v4 2/3] dm mpath: propagate target errors immediately
Date: Tue, 18 Jan 2011 10:13:12 +0100
Message-ID: <fecf8512b216779a43fd02d739e85be4023c2328.1295340405.git.hare@suse.de>
References: <cover.1295340405.git.hare@suse.de>
 <b6ba7efc491aec18cd501f73e2e6bbebc2e0727a.1295340405.git.hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab1ARJNO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 04:13:14 -0500
In-Reply-To: <b6ba7efc491aec18cd501f73e2e6bbebc2e0727a.1295340405.git.hare@suse.de>
In-Reply-To: <cover.1295340405.git.hare@suse.de>
References: <cover.1295340405.git.hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, jaxboe@fusionio.com, michaelc@cs.wisc.edu, agk@redhat.com, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>

DM now has more information about the nature of the underlying storage
failure.  Path failure is avoided if a request failed due to a target
error.  Instead the target error is immediately passed up the stack.

Discard requests that fail due to non-target errors may now be retried.

Errors restricted to the path will be retried or returned if no
paths are available, irregarding the no_path_retry setting.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 487ecda..0781683 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1270,24 +1270,22 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if (error == -EOPNOTSUPP)
-		return error;
-
-	if (clone->cmd_flags & REQ_DISCARD)
-		/*
-		 * Pass all discard request failures up.
-		 * FIXME: only fail_path if the discard failed due to a
-		 * transport problem.  This requires precise understanding
-		 * of the underlying failure (e.g. the SCSI sense).
-		 */
+	if (error == -EOPNOTSUPP || error == -EREMOTEIO)
 		return error;
 
 	if (mpio->pgpath)
 		fail_path(mpio->pgpath);
 
 	spin_lock_irqsave(&m->lock, flags);
-	if (!m->nr_valid_paths && !m->queue_if_no_path && !__must_push_back(m))
-		r = -EIO;
+	if (!m->nr_valid_paths) {
+		if (!m->queue_if_no_path) {
+			if (!__must_push_back(m))
+				r = -EIO;
+		} else {
+			if (error == -EBADE)
+				r = error;
+		}
+	}
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	return r;
-- 
1.6.0.2

