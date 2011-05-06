From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] SCSI fixes for 2.6.39-rc6
Date: Fri, 06 May 2011 11:41:25 -0500
Message-ID: <1304700085.12427.10.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Actually, it's just one fix ... another oops triggered by a previous
fix.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

James Bottomley (1):
      fix oops in scsi_run_queue()

The diffstat is:

 drivers/scsi/scsi_lib.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

And the full diff below.

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9901b8..0bac91e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -400,10 +400,15 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
 static void scsi_run_queue(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
-	struct Scsi_Host *shost = sdev->host;
+	struct Scsi_Host *shost;
 	LIST_HEAD(starved_list);
 	unsigned long flags;
 
+	/* if the device is dead, sdev will be NULL, so no queue to run */
+	if (!sdev)
+		return;
+
+	shost = sdev->host;
 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
 
