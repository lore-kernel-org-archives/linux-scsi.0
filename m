From: Robert Love <robert.w.love@intel.com>
Subject: [Resend PATCH v2] scsi_lib: rate-limit the error message from failing
 commands
Date: Fri, 25 May 2012 14:29:34 -0700
Message-ID: <20120525212933.3366.51338.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39661 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab2EYVae (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2012 17:30:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-scsi@vger.kernel.org
Cc: Tomas Henzl <thenzl@redhat.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

When performing a cable pull test w/ active stress I/O using fio over
a dual port Intel 82599 FCoE CNA, w/ 256LUNs on one port and about 32LUNs
on the other, it is observed that the system becomes not usable due to
scsi-ml being busy printing the error messages for all the failing commands.
I don't believe this problem is specific to FCoE and these commands are
anyway failing due to link being down (DID_NO_CONNECT), just rate-limit
the messages here to solve this issue.

v2->v1: use __ratelimit() as Tomas Henzl mentioned as the proper way for
rate-limit per function. However, in this case, the failed i/o gets to
blk_end_request_err() and then blk_update_request(), which also has to
be rate-limited, as added in the v2 of this patch.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Acked-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 block/blk-core.c        |    8 +++++---
 drivers/scsi/scsi_lib.c |    5 ++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1f61b74..c1f1c3a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -29,6 +29,7 @@
 #include <linux/fault-inject.h>
 #include <linux/list_sort.h>
 #include <linux/delay.h>
+#include <linux/ratelimit.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/block.h>
@@ -2133,9 +2134,10 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 			error_type = "I/O";
 			break;
 		}
-		printk(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
-		       error_type, req->rq_disk ? req->rq_disk->disk_name : "?",
-		       (unsigned long long)blk_rq_pos(req));
+		printk_ratelimited(KERN_ERR "end_request: %s error, dev %s, "
+				   "sector %llu\n", error_type, req->rq_disk ?
+				   req->rq_disk->disk_name : "?",
+				   (unsigned long long)blk_rq_pos(req));
 	}
 
 	blk_account_io_completion(req, nr_bytes);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5dfd749..48ef90c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -20,6 +20,7 @@
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/scatterlist.h>
+#include <linux/ratelimit.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -745,6 +746,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
 	      ACTION_DELAYED_RETRY} action;
 	char *description = NULL;
+	static DEFINE_RATELIMIT_STATE(rs,  DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
@@ -935,7 +938,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
 		scsi_release_buffers(cmd);
-		if (!(req->cmd_flags & REQ_QUIET)) {
+		if (!(req->cmd_flags & REQ_QUIET) && __ratelimit(&rs)) {
 			if (description)
 				scmd_printk(KERN_INFO, cmd, "%s\n",
 					    description);

