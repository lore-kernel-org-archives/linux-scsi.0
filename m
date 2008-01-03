From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fix for 2.6.24-rc6
Date: Wed, 02 Jan 2008 19:55:05 -0600
Message-ID: <1199325305.3258.103.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58088 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378AbYACBzR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jan 2008 20:55:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the bug fix for

http://bugzilla.kernel.org/show_bug.cgi?id=9674

It's available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

I've just attached it below as well.

James

---

>From 751bf4d7865e4ced406be93b04c7436d866d3684 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 2 Jan 2008 11:14:30 -0600
Subject: [SCSI] scsi_sysfs: restore prep_fn when ULD is removed

A recent bug report:

http://bugzilla.kernel.org/show_bug.cgi?id=9674

Was caused because the ULDs now set their own prep functions, but
don't necessarily reset the prep function back to the SCSI default
when they are removed.  This leads to panics if commands are sent to
the device after the module is removed because the prep_fn is still
pointing to the old module code.  The fix for this is to implement a
bus remove method that resets the prep_fn pointer correctly before
calling the ULD specific driver remove method.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_lib.c   |    2 +-
 drivers/scsi/scsi_priv.h  |    3 +++
 drivers/scsi/scsi_sysfs.c |   17 +++++++++++++++++
 3 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0e81e4c..a9ac5b1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1332,7 +1332,7 @@ int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 }
 EXPORT_SYMBOL(scsi_prep_return);
 
-static int scsi_prep_fn(struct request_queue *q, struct request *req)
+int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct scsi_device *sdev = q->queuedata;
 	int ret = BLKPREP_KILL;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index eff0059..3f34e93 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -74,6 +74,9 @@ extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
 extern void scsi_free_queue(struct request_queue *q);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
+struct request_queue;
+struct request;
+extern int scsi_prep_fn(struct request_queue *, struct request *);
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f374fdc..00b3866 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -373,12 +373,29 @@ static int scsi_bus_resume(struct device * dev)
 	return err;
 }
 
+static int scsi_bus_remove(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int err = 0;
+
+	/* reset the prep_fn back to the default since the
+	 * driver may have altered it and it's being removed */
+	blk_queue_prep_rq(sdev->request_queue, scsi_prep_fn);
+
+	if (drv && drv->remove)
+		err = drv->remove(dev);
+
+	return 0;
+}
+
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
 	.uevent		= scsi_bus_uevent,
 	.suspend	= scsi_bus_suspend,
 	.resume		= scsi_bus_resume,
+	.remove		= scsi_bus_remove,
 };
 
 int scsi_sysfs_register(void)
-- 
1.5.3.6



