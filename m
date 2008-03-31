From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Serious regression caused by fix for [BUG 1/3] bsg queue oops
	with	iscsi logout
Date: Mon, 31 Mar 2008 09:20:20 +0900
Message-ID: <20080331092020R.fujita.tomonori@lab.ntt.co.jp>
References: <20080327200827V.tomof@acm.org>
	<20080327211842X.tomof@acm.org>
	<1206898777.4224.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:61627 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbYCaAVZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Mar 2008 20:21:25 -0400
In-Reply-To: <1206898777.4224.64.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: tomof@acm.org, michaelc@cs.wisc.edu, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, erezz@voltaire.com, Jens.Axboe@oracle.com

On Sun, 30 Mar 2008 12:39:36 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> 
> On Thu, 2008-03-27 at 21:18 +0900, FUJITA Tomonori wrote:
> > On Thu, 27 Mar 2008 20:11:52 +0900
> > FUJITA Tomonori <tomof@acm.org> wrote:
> > 
> > > On Wed, 26 Mar 2008 20:51:44 -0500
> > > Mike Christie <michaelc@cs.wisc.edu> wrote:
> > > 
> > > > FUJITA Tomonori wrote:
> > > > > On Wed, 26 Mar 2008 07:36:26 -0700
> > > > > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > > > 
> > > > >> On Wed, 2008-03-26 at 23:22 +0900, FUJITA Tomonori wrote:
> > > > >>> On Sat, 22 Mar 2008 11:06:00 -0500
> > > > >>> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > > >>>
> > > > >>>> On Tue, 2008-03-11 at 00:36 -0500, Mike Christie wrote:
> > > > >>>>> Mike Christie wrote:
> > > > >>>>>> Pete Wyckoff wrote:
> > > > >>>>>>> I think this used not to happen; not sure.  But I changed two things
> > > > >>>>>> This most likely did not happen before 2.6.25-rc* or it broke in 
> > > > >>>>>> slightly different ways, because iscsi used to try and do
> > > > >>>>>>
> > > > >>>>>> echo 1 > /sys/block/sdX/device/delete
> > > > >>>>>>
> > > > >>>>>> from userspace instead of calling scsi_remove_target from the kernel.
> > > > >>>>>>
> > > > >>>>>> As you know around 2.6.21, the behavior of doing the echo to the delete 
> > > > >>>>>> file changed due to a driver model and scsi change and that broke the 
> > > > >>>>>> iscsi tools. The iscsi tools userspace removal was sort of hack in the 
> > > > >>>>>> first place and was racey, so we switched to removing devices/target 
> > > > >>>>>> like the FC class.
> > > > >>>>>>
> > > > >>>>>>
> > > > >>>>>>> lately.  2.6.25-rc1 to -rc4 and fedora 8 iscsi-initiator-utils (865) to
> > > > >>>>>>> fedora devel (868).  Bidi and varlen patches always too.
> > > > >>>>>>>
> > > > >>>>>>> I'll follow with some more variations on this theme.  Looks like bsg
> > > > >>>>>>> needs to protect more carefully against the device going away.  Any
> > > > >>>>>>> ideas how best to do this?  What was the approach in sg?
> > > > >>>>>>>
> > > > >>>>>> I think sg is broken in similar ways. The iser guys have some tests 
> > > > >>>>>> cases that have broken sg while IO is outstanding. I am ccing Erez.
> > > > >>>>> Actually one of the problems looks a little different than some of the 
> > > > >>>>> problems hit with sg and are caused because we remove the bsg device too 
> > > > >>>>> soon. I think we want to wait until all the references from the 
> > > > >>>>> commands/requests are released. The attached patch (untested) moves the 
> > > > >>>>> bsg unreg call to the scsi device release fn.
> > > > >>>> Well, this fix is now upstream.  However, it's causing all our
> > > > >>>> scsi_devices never to get released, which is a serious regression.
> > > > >>>> We're also doing spurious bsg_unregister_queue() for things that never
> > > > >>>> actually registered one (all scan devices that return DID_NO_CONNECT),
> > > > >>>> but bsg doesn't seem to be complaining about this.
> > > > >>>>
> > > > >>>> The essence of the problem is that bsg_register_queue() takes a ref to
> > > > >>>> the sdev_gendev, so you can't move bsg_unregister_queue() into the
> > > > >>>> release function because nothing ever puts bsg's device ref and so
> > > > >>>> release is never called.
> > > > >>>>
> > > > >>>> Options for fixing this before 2.6.25 are
> > > > >>>>
> > > > >>>>      1. revert the patch
> > > > >>>>      2. Do an additional put for the bsg reference in
> > > > >>>>         __scsi_remove_device (patch below).  It's nasty but it preserves
> > > > >>>>         the semantics and does what you want
> > > > >>> After some investigation, this patch doesn't fix the bug that Pete
> > > > >>> reported (I'll send a new patch shortly).
> > > > >>>
> > > > >>> Can you revert the commit 4b6f5b3a993cbe34b4280f252bccc76967c185c8
> > > > >>> instead of merging this?
> > > > >> Sure ... I didn't like the hack either.  As long as iSCSI is fine with
> > > > >> the reversion it's the quickest way to fix the problem.
> > > > > 
> > > > > How about this? With the commit reversion, I confirmed that this patch
> > > > > fixes the first bug that Pete reported:
> > > > > 
> > > > > http://marc.info/?l=linux-scsi&m=120508166505141&w=2
> > > > > 
> > > > > I suspect that this could fix the rest too.
> > > > > 
> > > > > =
> > > > > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > > Subject: [PATCH] bsg: takes a ref to struct device in fops->open
> > > > > 
> > > > > bsg_register_queue() takes a ref to struct device that a caller
> > > > > passes. For example, it takes a ref to the sdev_gendev with scsi
> > > > > devices. However, bsg doesn't takes a ref to it in fops->open. So
> > > > > while an application opens a bsg device, the scsi device that the bsg
> > > > > device holds can go away (bsg also takes a ref to a queue, but it
> > > > > doesn't prevent the device from going away).
> > > > > 
> > > > > With this, bsg takes a ref to struct device in fops->open and frees it
> > > > > in fops->release.
> > > > > 
> > > > > Note that bsg doesn't need to takes a ref to a queue for SCSI devices
> > > > > at least. I think that it would be better to remove the code but I let
> > > > > it alone for now.
> > > > > 
> > > > 
> > > > Why does bsg_add_device do kobject_get instead of blk_get_queue?
> > > 
> > > I think that it's a bug. But both takes a ref to a queue (though
> > > kobject_get doesn't see QUEUE_FLAG_DEAD), so I think that it's not
> > > related with the current problems.
> > > 
> > > 
> > > > It seems like if we added a blk_qet_queue when we opened the device and 
> > > > a blk_put_queue when bsg_release is called we could remove the 
> > > > get/put_device calls. I am not sure if that is cleaner or not. I was 
> > > > just thinking that bsg goes from bsg->request_queue->scsi_device so 
> > > > maybe it should not worry about the device.
> > > 
> > > kobject_get takes a ref to a queue. If we don't take a ref to a
> > > device, the scsi device has gone though the queue is still there
> > > because the queue release is done from the device release. If the scsi
> > > device has gone, we are dead, right?
> > > 
> > > 
> > > Anyway, here's a patch to replace kobject_get with blk_get_queue.
> > > 
> > > James, please apply this patch too.
> > > 
> > > =
> > > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > Subject: [PATCH] bsg: replace kobject_get with blk_get_queue
> > 
> > Really sorry, please apply this one.
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] bsg: replace kobject_get with blk_get_queue
> > 
> > Both takes a ref to a queue. But blk_get_queue checks QUEUE_FLAG_DEAD
> > and is more appropriate interface here.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> 
> This looks reasonable to me.  It's probably a rc-fixes patch, so could I
> get Jen's ack and some evidence of testing (and that it actually fixes
> the bug).

Do you mean that the patch to take a ref to strutc device
(e.g. sdev_gendev for scsi devices) in fops->open is a reasonable fix?

http://marc.info/?l=linux-scsi&m=120654365424916&w=2

The patch with the commit reversion fixes all the problems for me that
Pete reported. Pete, can you test the patch?


It's a rc-fixes patch, but I'm fine with applying it to scsi-misc
(I'll send it to the stable tree later on).

The patch has one bug in an error handling path (I should have used
IS_ERR there). So I'll send an updated version shortly.
