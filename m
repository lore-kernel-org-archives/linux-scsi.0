From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi_sysfs: restore prep_fn when ULD is removed
Date: Wed, 02 Jan 2008 11:14:30 -0600
Message-ID: <1199294070.3258.37.camel@localhost.localdomain>
References: <bug-9674-10286@http.bugzilla.kernel.org/>
	 <20080101181026.38298e13.akpm@linux-foundation.org>
	 <1199244283.3252.13.camel@localhost.localdomain>
	 <20080102154951.GA8976@osc.edu>
	 <1199291625.3258.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52834 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbYABROj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jan 2008 12:14:39 -0500
In-Reply-To: <1199291625.3258.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus@drzeus.cx>, Jens Axboe <jens.axboe@oracle.com>, bugme-daemon@bugzilla.kernel.org, gentuu@gmail.com, linux-scsi <linux-scsi@vger.kernel.org>

A recent bug report:

http://bugzilla.kernel.org/show_bug.cgi?id=9674

Was caused because the ULDs now set their own prep functions, but don't
necessarily reset the prep function back to the SCSI default when they
are removed.  This leads to panics if commands are sent to the device
after the module is removed because the prep_fn is still pointing to the
old module code.  The fix for this is to implement a bus remove method
that resets the prep_fn pointer correctly before calling the driver
specific prep_fn.

James

----

P.S. The patch in the bug report is slightly wrong.  It doesn't include
the piece to call the ULD specific remove function.

Index: BUILD-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_lib.c	2008-01-01 10:13:33.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi_lib.c	2008-01-02 10:17:51.000000000 -0600
@@ -1324,7 +1324,7 @@ int scsi_prep_return(struct request_queu
 }
 EXPORT_SYMBOL(scsi_prep_return);
 
-static int scsi_prep_fn(struct request_queue *q, struct request *req)
+int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct scsi_device *sdev = q->queuedata;
 	int ret = BLKPREP_KILL;
Index: BUILD-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_priv.h	2007-11-03 09:08:46.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_priv.h	2008-01-02 10:20:09.000000000 -0600
@@ -74,6 +74,9 @@ extern struct request_queue *scsi_alloc_
 extern void scsi_free_queue(struct request_queue *q);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
+struct request_queue;
+struct request;
+extern int scsi_prep_fn(struct request_queue *, struct request *);
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
Index: BUILD-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_sysfs.c	2007-11-03 10:08:02.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_sysfs.c	2008-01-02 10:58:17.000000000 -0600
@@ -373,12 +373,29 @@ static int scsi_bus_resume(struct device
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


