From: Yi Zou <yi.zou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4] scsi_lib: rate-limit the error message from
	failing	commands
Date: Mon, 24 Sep 2012 12:57:10 -0700
Message-ID: <20120924195709.18104.65833.stg.yi.zou@intel.com>
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
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tomas Henzl <thenzl-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "www.Open-FCoE.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

[
James,

Not sure why you could not see the original v3 on the list as the block part
was pulled ok by Jens. Anyway, I have diffsplitted the v3 and v4 below is
the scsi_lib part only, hopefully this works for you, pls let me know. Below
is directly applicable against the current upstream 3.6-rc7 tip.

]

Resending as v4 for the change on scsi_lib part, where the corresponding block
part is at commit 37d7b34. Threads related to this can be found at:

http://marc.info/?l=linux-scsi&m=134830150821548&w=2
http://comments.gmane.org/gmane.linux.scsi/73497
http://www.open-fcoe.org/patchwork/patch/2436/

Signed-off-by: Yi Zou <yi.zou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: www.Open-FCoE.org <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Cc: Tomas Henzl <thenzl-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
---

 drivers/scsi/scsi_lib.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index faa790f..daa72ef 100644
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
@@ -961,7 +964,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
 		scsi_release_buffers(cmd);
-		if (!(req->cmd_flags & REQ_QUIET)) {
+		if (!(req->cmd_flags & REQ_QUIET) && __ratelimit(&rs)) {
 			if (description)
 				scmd_printk(KERN_INFO, cmd, "%s\n",
 					    description);
