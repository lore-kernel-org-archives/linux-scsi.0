From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 2/3] dm mpath: propagate target errors immediately
Date: Fri, 14 Jan 2011 10:58:55 -0500
Message-ID: <1295020736-27699-3-git-send-email-snitzer@redhat.com>
References: <1295020736-27699-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656Ab1ANP7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2011 10:59:16 -0500
In-Reply-To: <1295020736-27699-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, agk@redhat.com, jaxboe@fusionio.com, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu, Mike Snitzer <snitzer@redhat.com>

DM now has more information about the nature of the underlying storage
failure.  Path failure is avoided if a request failed due to a target
error.  Instead the target error is immediately passed up the stack.

Discard requests that fail due to non-target errors may now be retried.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index b82d288..532b845 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1283,16 +1283,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
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
-- 
1.7.3.4

