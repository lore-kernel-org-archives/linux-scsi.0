From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: scsi: killing requests for dead queue
Date: Fri, 4 Nov 2011 18:38:45 +0100
Message-ID: <201111041838.46062.bvanassche@acm.org>
References: <4eb3064c133909be1c@agluck-desktop.sc.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <4eb3064c133909be1c@agluck-desktop.sc.intel.com>
Sender: linux-next-owner@vger.kernel.org
To: Tony Luck <tony.luck@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-next@vger.kernel.org, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Thursday 03 November 2011 22:23:24 you wrote:
> First saw these messages on next-20111102 (but my previous build from linux-next
> was next-20111017 ... so a big gap).  Still there today in next-20111103. Not seeing
> these messages from Linus 3.2 merge window builds.
> 
> scsi: killing requests for dead queue

Does the patch below help ?

[PATCH] [SCSI] Silence queue cleanup code

Commit 3308511 causes the SCSI queue cleanup code to be invoked
for every killed queue. Since the SCSI scanning code can create
and destroy SCSI queues repeatedly while probing LUNs, the
following message can be printed several times during boot:

    scsi: killing requests for dead queue

This confuses users, so change the severity of that message to
KERN_DEBUG.

See also http://marc.info/?l=linux-scsi&m=132035543616061.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reported-by: Tony Luck <tony.luck@intel.com>
Cc: <stable@kernel.org>
Cc: James Bottomley <JBottomley@Parallels.com>
---
 drivers/scsi/scsi_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b4d43ae..79ce802 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1489,7 +1489,7 @@ static void scsi_request_fn(struct request_queue *q)
 	struct request *req;
 
 	if (!sdev) {
-		printk("scsi: killing requests for dead queue\n");
+		pr_debug("scsi: killing requests for dead queue\n");
 		while ((req = blk_peek_request(q)) != NULL)
 			scsi_kill_request(req, q);
 		return;
-- 
1.7.3.4
