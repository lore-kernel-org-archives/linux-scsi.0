From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Serious regression caused by fix for [BUG 1/3] bsg queue oops with
	iscsi logout
Date: Sat, 22 Mar 2008 11:06:00 -0500
Message-ID: <1206201960.4393.8.camel@localhost.localdomain>
References: <20080309165359.GA24388@osc.edu> <47D5766C.3020206@cs.wisc.edu>
	 <47D61A73.3000803@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56527 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbYCVQGH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Mar 2008 12:06:07 -0400
In-Reply-To: <47D61A73.3000803@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Pete Wyckoff <pw@osc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, Erez Zilber <erezz@voltaire.com>, Jens Axboe <Jens.Axboe@oracle.com>

On Tue, 2008-03-11 at 00:36 -0500, Mike Christie wrote:
> Mike Christie wrote:
> > Pete Wyckoff wrote:
> >> I think this used not to happen; not sure.  But I changed two things
> > 
> > This most likely did not happen before 2.6.25-rc* or it broke in 
> > slightly different ways, because iscsi used to try and do
> > 
> > echo 1 > /sys/block/sdX/device/delete
> > 
> > from userspace instead of calling scsi_remove_target from the kernel.
> > 
> > As you know around 2.6.21, the behavior of doing the echo to the delete 
> > file changed due to a driver model and scsi change and that broke the 
> > iscsi tools. The iscsi tools userspace removal was sort of hack in the 
> > first place and was racey, so we switched to removing devices/target 
> > like the FC class.
> > 
> > 
> >> lately.  2.6.25-rc1 to -rc4 and fedora 8 iscsi-initiator-utils (865) to
> >> fedora devel (868).  Bidi and varlen patches always too.
> >>
> >> I'll follow with some more variations on this theme.  Looks like bsg
> >> needs to protect more carefully against the device going away.  Any
> >> ideas how best to do this?  What was the approach in sg?
> >>
> > 
> > I think sg is broken in similar ways. The iser guys have some tests 
> > cases that have broken sg while IO is outstanding. I am ccing Erez.
> 
> Actually one of the problems looks a little different than some of the 
> problems hit with sg and are caused because we remove the bsg device too 
> soon. I think we want to wait until all the references from the 
> commands/requests are released. The attached patch (untested) moves the 
> bsg unreg call to the scsi device release fn.

Well, this fix is now upstream.  However, it's causing all our
scsi_devices never to get released, which is a serious regression.
We're also doing spurious bsg_unregister_queue() for things that never
actually registered one (all scan devices that return DID_NO_CONNECT),
but bsg doesn't seem to be complaining about this.

The essence of the problem is that bsg_register_queue() takes a ref to
the sdev_gendev, so you can't move bsg_unregister_queue() into the
release function because nothing ever puts bsg's device ref and so
release is never called.

Options for fixing this before 2.6.25 are

     1. revert the patch
     2. Do an additional put for the bsg reference in
        __scsi_remove_device (patch below).  It's nasty but it preserves
        the semantics and does what you want
     3. Modify bsg_register_queue not to take a device reference on the
        grounds that the queue lifetime is *always* shorter than the
        generic device lifetime.  This sounds the most plausible, but
        it's unsafe ... if the device gets released first the queue is
        left holding a freed area of memory.  Jens, can we make this
        work?

James

---

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b9b09a7..9037b34 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -294,6 +294,20 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	}
 
 	if (sdev->request_queue) {
+		/*
+		 * FIXME: bsg_unregister_queue() is going to drop a
+		 * reference to the device.  This actually causes the
+		 * references to go negative (yuk).  We have to do
+		 * this because we're trying to do the queue
+		 * unregister in the device release routine, so we
+		 * already released the reference taken by bsg in
+		 * __scsi_remove_device().
+		 *
+		 * We're also calling bsg_unregister_queue in here on
+		 * things we never registered (scanned devices that
+		 * return DID_NO_CONNECT) if bsg ever starts squawking
+		 * about this, it needs fixing here.
+		 */
 		bsg_unregister_queue(sdev->request_queue);
 		sdev->request_queue->queuedata = NULL;
 		/* user context needed to free queue */
@@ -866,6 +880,13 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
 	put_device(dev);
+	/*
+	 *  FIXME: This is an extra put because bsg_register_queue()
+	 * takes a reference to the device.  We do it here to allow
+	 * bsg_unregister_queue() to be called from the release method
+	 * of the device.
+	 */
+	put_device(dev);
 }
 
 /**


