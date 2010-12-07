From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 3/3] block: improve detail in I/O error messages
Date: Tue,  7 Dec 2010 18:16:42 -0500
Message-ID: <1291763802-8251-4-git-send-email-snitzer@redhat.com>
References: <1291763802-8251-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1291763802-8251-1-git-send-email-snitzer@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu, tytso@mit.edu, sshtylyov@mvista.com, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, j-nomura@ce.jp.nec.com, vst@vlnb.net, rwheeler@redhat.com, hch@lst.de, chris.mason@oracle.com, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

Classify severity of I/O errors for target and transport errors.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4ce953f..ab8c776 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2028,9 +2028,15 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 
 	if (error && req->cmd_type == REQ_TYPE_FS &&
 	    !(req->cmd_flags & REQ_QUIET)) {
-		printk(KERN_ERR "end_request: I/O error, dev %s, sector %llu\n",
-				req->rq_disk ? req->rq_disk->disk_name : "?",
-				(unsigned long long)blk_rq_pos(req));
+		char *error_type = "I/O";
+
+		if (error == -ENOLINK)
+			error_type = "recoverable transport";
+		else if (error == -EREMOTEIO)
+			error_type = "critical target";
+		printk(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
+		       error_type, req->rq_disk ? req->rq_disk->disk_name : "?",
+		       (unsigned long long)blk_rq_pos(req));
 	}
 
 	blk_account_io_completion(req, nr_bytes);
-- 
1.7.2.3

