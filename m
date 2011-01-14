From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 3/3] block: improve detail in I/O error messages
Date: Fri, 14 Jan 2011 10:58:56 -0500
Message-ID: <1295020736-27699-4-git-send-email-snitzer@redhat.com>
References: <1295020736-27699-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1ANP7S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2011 10:59:18 -0500
In-Reply-To: <1295020736-27699-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, agk@redhat.com, jaxboe@fusionio.com, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu, Mike Snitzer <snitzer@redhat.com>

Classify severity of I/O errors for target and transport errors.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -2044,9 +2044,23 @@ bool blk_update_request(struct request *
 
 	if (error && req->cmd_type == REQ_TYPE_FS &&
 	    !(req->cmd_flags & REQ_QUIET)) {
-		printk(KERN_ERR "end_request: I/O error, dev %s, sector %llu\n",
-				req->rq_disk ? req->rq_disk->disk_name : "?",
-				(unsigned long long)blk_rq_pos(req));
+		char *error_type;
+
+		switch (error) {
+		case -ENOLINK:
+			error_type = "recoverable transport";
+			break;
+		case -EREMOTEIO:
+			error_type = "critical target";
+			break;
+		case -EIO:
+		default:
+			error_type = "I/O";
+			break;
+		}
+		printk(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
+		       error_type, req->rq_disk ? req->rq_disk->disk_name : "?",
+		       (unsigned long long)blk_rq_pos(req));
 	}
 
 	blk_account_io_completion(req, nr_bytes);
