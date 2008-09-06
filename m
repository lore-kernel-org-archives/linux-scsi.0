From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] block: set req->timeout in blk_add_timer
Date: Sat,  6 Sep 2008 00:50:40 -0500
Message-ID: <1220680240-27724-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51840 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYIFFxB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Sep 2008 01:53:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com
Cc: Mike Christie <mchristi@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <mchristi@redhat.com>

To prevent a reques from running forever, scsi-ml checks if
a command has been running req->timeout * cmd->allowed + 1 seconds.
If it has, scsi-ml will fail the request. From what I can tell
it looks like in Jen's tree that the block layer is not setting
this value, so a command is failed right away a lot of times because
wait_for in scsi_softirq_done is zero seconds. It is only set by ioctls
and passthrough.

This patch just copies the q timeout that is used, so any one
checking it will still be able to see it.

For the scsi-ml req->timeout usage, I think we can move the retries and
the infinite retry check from the scsi layer to the block layer. I was
not sure if we should do that in this patch or a separate one. I can
cook up another patch if people want. If it would be possible to do
that after MikeA's patches it would probably be best though since
he is working on that code too.

This patch was made over James's scsi post tree.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/blk-timeout.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 779f439..6e7778d 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -132,9 +132,14 @@ void blk_add_timer(struct request *req)
 
 	if (req->timeout)
 		req->deadline = jiffies + req->timeout;
-	else
+	else {
 		req->deadline = jiffies + q->rq_timeout;
-
+		/*
+		 * Some LLDs, like scsi, peek at the timeout to prevent
+		 * a command from being retried forever.
+		 */
+		req->timeout = q->rq_timeout;
+	}
 	list_add_tail(&req->timeout_list, &q->timeout_list);
 
 	/*
-- 
1.5.5.1

