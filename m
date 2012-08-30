From: Yi Zou <yi.zou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3] scsi_lib: rate-limit the error message from
 failing commands
Date: Thu, 30 Aug 2012 14:06:07 -0700
Message-ID: <20120830210607.28119.96438.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: Tomas Henzl <thenzl-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "www.Open-FCoE.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

[
Jens/James,

This is a rather old rate limt patch but never gets picked up in upstream, so I
am resending it here as v3, with some minor changes so it is directly applicable
to the current linux-2.6.git tree. I don't have that many LUNs that the original
issue was reported but the patch was already reviewed and acked in the past,
I did retest w/ stress I/O on 4 LUNs I have right now.

Original thread can be found at:
http://comments.gmane.org/gmane.linux.scsi/73497
http://www.open-fcoe.org/patchwork/patch/2436/

Can you please pull this patch in? it's been hanging there for a long time.
Original patch description is below.

thanks,
yi
]

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

v3-v2: resolved conflict to apply on current 3.6-rc3 upstream tip.

Signed-off-by: Yi Zou <yi.zou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: www.Open-FCoE.org <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Cc: Tomas Henzl <thenzl-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---

 block/blk-core.c        |    8 +++++---
 drivers/scsi/scsi_lib.c |    5 ++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..ee3cb3a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2254,9 +2254,11 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 			error_type = "I/O";
 			break;
 		}
-		printk(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
-		       error_type, req->rq_disk ? req->rq_disk->disk_name : "?",
-		       (unsigned long long)blk_rq_pos(req));
+		printk_ratelimited(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
+				   error_type, req->rq_disk ?
+				   req->rq_disk->disk_name : "?",
+				   (unsigned long long)blk_rq_pos(req));
+
 	}
 
 	blk_account_io_completion(req, nr_bytes);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ffd7773..d784e68 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -20,6 +20,7 @@
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/scatterlist.h>
+#include <linux/ratelimit.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -768,6 +769,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
 	      ACTION_DELAYED_RETRY} action;
 	char *description = NULL;
+	static DEFINE_RATELIMIT_STATE(rs,  DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
@@ -958,7 +961,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
 		scsi_release_buffers(cmd);
-		if (!(req->cmd_flags & REQ_QUIET)) {
+		if (!(req->cmd_flags & REQ_QUIET) && __ratelimit(&rs)) {
 			if (description)
 				scmd_printk(KERN_INFO, cmd, "%s\n",
 					    description);
