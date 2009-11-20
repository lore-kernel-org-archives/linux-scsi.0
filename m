From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/4 ver 3] SCSI: add construction flags to scsi_device
 structure
Date: Fri, 20 Nov 2009 17:03:12 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0911201643290.2903-100000@iolanthe.rowland.org>
References: <1258752058.2889.303.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48554 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754242AbZKTWDH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2009 17:03:07 -0500
In-Reply-To: <1258752058.2889.303.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 20 Nov 2009, James Bottomley wrote:

> >      3. transport_setup_device() and adding sdev to the host's and 
> > 	target's lists don't have anything to do with sysfs.  Hence
> > 	they don't really belong in scsi_sysfs_device_initialize().
> > 	Is there any reason not to move them up into scsi_alloc_lun()?
> 
> For a patch that needs to fix a bug, yes ... it needs to be the minimum
> change.  But on the broader principle, no, it doesn't matter.  The
> scsi_alloc_sdev() must contain the list adds because at some point if
> the scan mutex is removed, the act of checking the lists and allocating
> and adding them will have to become atomic so they have to be somwhere
> in scsi_alloc_sdev() ... but it might not matter where.
> 
> >      4. bsg_register_queue() comes before transport_add_device() but
> > 	bug_unregister_queue() doesn't come after
> > 	transport_remove_device().  Maybe the order doesn't matter and
> > 	maybe it does; but it isn't commented and it looks unclean.
> > 	Should the second pair be reversed?
> 
> The ordering shouldn't matter.  The bsg registration is an independent
> operation.
> 
> >      5. scsi_sysfs_device_initialize() can't fail.  Hence it should
> > 	come after the slave_alloc() call, which can, in order to
> > 	simplify unwinding.  Unless there is an ordering restriction
> > 	which prevents this?
> 
> Well, we'd have to unwind what was done on slave alloc failure if you do
> that ... so it just adds more to the unwind path.

You misunderstood...  In what I'm suggesting, if the slave_alloc fails
there will be less to unwind, because scsi_sysfs_device_initialize()
won't have run yet.  See the patch below, which applies on top of
yours.

> > Would it be okay to take your patch and modify it in accordance with
> > points 3 - 5?
> 
> I really just need the minimum patch that can be backported, so if you
> can shorten it, go for it.

Tell you what: Go ahead and merge your patch.  Add in the one below if
you want, but it isn't necessary.  Then I'll write the suggested
changes and submit them for 2.6.33-rc1.

Alan Stern


Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -286,19 +286,12 @@ static struct scsi_device *scsi_alloc_sd
 	sdev->borken = 1;
 
 	sdev->request_queue = scsi_alloc_queue(sdev);
-	if (!sdev->request_queue) {
-		/* release fn is set up in scsi_sysfs_device_initialise, so
-		 * have to free and put manually here */
-		put_device(&starget->dev);
-		kfree(sdev);
-		goto out;
-	}
+	if (!sdev->request_queue)
+		goto out_put_target;
 
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
-	scsi_sysfs_device_initialize(sdev);
-
 	if (shost->hostt->slave_alloc) {
 		ret = shost->hostt->slave_alloc(sdev);
 		if (ret) {
@@ -308,18 +301,19 @@ static struct scsi_device *scsi_alloc_sd
 			 */
 			if (ret == -ENXIO)
 				display_failure_msg = 0;
-			goto out_device_destroy;
+			goto out_free_queue;
 		}
 	}
 
+	scsi_sysfs_device_initialize(sdev);
 	return sdev;
 
-out_device_destroy:
-	scsi_device_set_state(sdev, SDEV_DEL);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_dev);
-	put_device(&sdev->sdev_gendev);
-out:
+ out_free_queue:
+	scsi_free_queue(sdev->request_queue);
+ out_put_target:
+	put_device(&starget->dev);
+	kfree(sdev);
+ out:
 	if (display_failure_msg)
 		printk(ALLOC_FAILURE_MSG, __func__);
 	return NULL;

