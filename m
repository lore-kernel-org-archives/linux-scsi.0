From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: Serious regression caused by fix for [BUG 1/3] bsg queue oops
	with	iscsi logout
Date: Wed, 26 Mar 2008 23:59:08 +0900
Message-ID: <20080326235900H.tomof@acm.org>
References: <1206201960.4393.8.camel@localhost.localdomain>
	<20080326232226X.tomof@acm.org>
	<1206542186.3019.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:57829 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbYCZPAR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Mar 2008 11:00:17 -0400
In-Reply-To: <1206542186.3019.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: tomof@acm.org, michaelc@cs.wisc.edu, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, erezz@voltaire.com, Jens.Axboe@oracle.com

On Wed, 26 Mar 2008 07:36:26 -0700
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2008-03-26 at 23:22 +0900, FUJITA Tomonori wrote:
> > On Sat, 22 Mar 2008 11:06:00 -0500
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > On Tue, 2008-03-11 at 00:36 -0500, Mike Christie wrote:
> > > > Mike Christie wrote:
> > > > > Pete Wyckoff wrote:
> > > > >> I think this used not to happen; not sure.  But I changed two things
> > > > > 
> > > > > This most likely did not happen before 2.6.25-rc* or it broke in 
> > > > > slightly different ways, because iscsi used to try and do
> > > > > 
> > > > > echo 1 > /sys/block/sdX/device/delete
> > > > > 
> > > > > from userspace instead of calling scsi_remove_target from the kernel.
> > > > > 
> > > > > As you know around 2.6.21, the behavior of doing the echo to the delete 
> > > > > file changed due to a driver model and scsi change and that broke the 
> > > > > iscsi tools. The iscsi tools userspace removal was sort of hack in the 
> > > > > first place and was racey, so we switched to removing devices/target 
> > > > > like the FC class.
> > > > > 
> > > > > 
> > > > >> lately.  2.6.25-rc1 to -rc4 and fedora 8 iscsi-initiator-utils (865) to
> > > > >> fedora devel (868).  Bidi and varlen patches always too.
> > > > >>
> > > > >> I'll follow with some more variations on this theme.  Looks like bsg
> > > > >> needs to protect more carefully against the device going away.  Any
> > > > >> ideas how best to do this?  What was the approach in sg?
> > > > >>
> > > > > 
> > > > > I think sg is broken in similar ways. The iser guys have some tests 
> > > > > cases that have broken sg while IO is outstanding. I am ccing Erez.
> > > > 
> > > > Actually one of the problems looks a little different than some of the 
> > > > problems hit with sg and are caused because we remove the bsg device too 
> > > > soon. I think we want to wait until all the references from the 
> > > > commands/requests are released. The attached patch (untested) moves the 
> > > > bsg unreg call to the scsi device release fn.
> > > 
> > > Well, this fix is now upstream.  However, it's causing all our
> > > scsi_devices never to get released, which is a serious regression.
> > > We're also doing spurious bsg_unregister_queue() for things that never
> > > actually registered one (all scan devices that return DID_NO_CONNECT),
> > > but bsg doesn't seem to be complaining about this.
> > > 
> > > The essence of the problem is that bsg_register_queue() takes a ref to
> > > the sdev_gendev, so you can't move bsg_unregister_queue() into the
> > > release function because nothing ever puts bsg's device ref and so
> > > release is never called.
> > > 
> > > Options for fixing this before 2.6.25 are
> > > 
> > >      1. revert the patch
> > >      2. Do an additional put for the bsg reference in
> > >         __scsi_remove_device (patch below).  It's nasty but it preserves
> > >         the semantics and does what you want
> > 
> > After some investigation, this patch doesn't fix the bug that Pete
> > reported (I'll send a new patch shortly).
> > 
> > Can you revert the commit 4b6f5b3a993cbe34b4280f252bccc76967c185c8
> > instead of merging this?
> 
> Sure ... I didn't like the hack either.  As long as iSCSI is fine with
> the reversion it's the quickest way to fix the problem.

How about this? With the commit reversion, I confirmed that this patch
fixes the first bug that Pete reported:

http://marc.info/?l=linux-scsi&m=120508166505141&w=2

I suspect that this could fix the rest too.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] bsg: takes a ref to struct device in fops->open

bsg_register_queue() takes a ref to struct device that a caller
passes. For example, it takes a ref to the sdev_gendev with scsi
devices. However, bsg doesn't takes a ref to it in fops->open. So
while an application opens a bsg device, the scsi device that the bsg
device holds can go away (bsg also takes a ref to a queue, but it
doesn't prevent the device from going away).

With this, bsg takes a ref to struct device in fops->open and frees it
in fops->release.

Note that bsg doesn't need to takes a ref to a queue for SCSI devices
at least. I think that it would be better to remove the code but I let
it alone for now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/bsg.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 8917c51..28f0d1e 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -705,6 +705,7 @@ static struct bsg_device *bsg_alloc_device(void)
 static int bsg_put_device(struct bsg_device *bd)
 {
 	int ret = 0;
+	struct device *dev = bd->queue->bsg_dev.dev;
 
 	mutex_lock(&bsg_mutex);
 
@@ -730,6 +731,7 @@ static int bsg_put_device(struct bsg_device *bd)
 	kfree(bd);
 out:
 	mutex_unlock(&bsg_mutex);
+	put_device(dev);
 	return ret;
 }
 
@@ -789,21 +791,27 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 	struct bsg_device *bd;
 	struct bsg_class_device *bcd;
 
-	bd = __bsg_get_device(iminor(inode));
-	if (bd)
-		return bd;
-
 	/*
 	 * find the class device
 	 */
 	mutex_lock(&bsg_mutex);
 	bcd = idr_find(&bsg_minor_idr, iminor(inode));
+	if (bcd)
+		get_device(bcd->dev);
 	mutex_unlock(&bsg_mutex);
 
 	if (!bcd)
 		return ERR_PTR(-ENODEV);
 
-	return bsg_add_device(inode, bcd->queue, file);
+	bd = __bsg_get_device(iminor(inode));
+	if (bd)
+		return bd;
+
+	bd = bsg_add_device(inode, bcd->queue, file);
+	if (!bd)
+		put_device(bcd->dev);
+
+	return bd;
 }
 
 static int bsg_open(struct inode *inode, struct file *file)
@@ -942,7 +950,6 @@ void bsg_unregister_queue(struct request_queue *q)
 	class_device_unregister(bcd->class_dev);
 	put_device(bcd->dev);
 	bcd->class_dev = NULL;
-	bcd->dev = NULL;
 	mutex_unlock(&bsg_mutex);
 }
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
-- 
1.5.3.7

