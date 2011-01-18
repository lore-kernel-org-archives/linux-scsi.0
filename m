From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH v4 3/3] block: improve detail in I/O error messages
Date: Tue, 18 Jan 2011 10:13:13 +0100
Message-ID: <5acf8e401e40afb1bb7250bb37598c6e49dc830a.1295340405.git.hare@suse.de>
References: <cover.1295340405.git.hare@suse.de>
 <b6ba7efc491aec18cd501f73e2e6bbebc2e0727a.1295340405.git.hare@suse.de>
 <fecf8512b216779a43fd02d739e85be4023c2328.1295340405.git.hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab1ARJNO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 04:13:14 -0500
In-Reply-To: <fecf8512b216779a43fd02d739e85be4023c2328.1295340405.git.hare@suse.de>
In-Reply-To: <cover.1295340405.git.hare@suse.de>
References: <cover.1295340405.git.hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, jaxboe@fusionio.com, michaelc@cs.wisc.edu, agk@redhat.com, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>

Classify severity of I/O errors for target, nexus, and
transport errors.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4ce953f..3380a49 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2028,9 +2028,26 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 
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
+		case -EBADE:
+			error_type = "critical nexus";
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
-- 
1.6.0.2

