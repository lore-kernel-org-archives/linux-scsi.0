From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.0-rc1
Date: Sat, 04 Jun 2011 10:41:28 +0900
Message-ID: <1307151688.2771.26.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a single fix for the queue refcounting oops we were debugging
just before 3.0-rc1 was released.  Jens is still working on the DEAD
queue guard bit.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

James Bottomley (1):
      Fix oops caused by queue refcounting failure

The diffstat is:

 drivers/scsi/scsi_scan.c  |    2 +-
 drivers/scsi/scsi_sysfs.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

And the full patch is below.

James

---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 58584dc..44e8ca3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -297,7 +297,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 		kfree(sdev);
 		goto out;
 	}
-
+	blk_get_queue(sdev->request_queue);
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e639125..e0bd3f7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -322,6 +322,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree(evt);
 	}
 
+	blk_put_queue(sdev->request_queue);
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
