From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: Serious regression caused by fix for [BUG 1/3] bsg queue oops
 with	iscsi logout
Date: Thu, 27 Mar 2008 20:11:50 +0900
Message-ID: <20080327195106U.tomof@acm.org>
References: <1206542186.3019.5.camel@localhost.localdomain>
	<20080326235900H.tomof@acm.org>
	<47EAF91D.3000505@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:38417 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbYC0LNI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 07:13:08 -0400
In-Reply-To: <47EAF91D.3000505@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: tomof@acm.org, James.Bottomley@HansenPartnership.com, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, erezz@voltaire.com, Jens.Axboe@oracle.comfujita.tomonori@lab.ntt.co.jp

On Wed, 26 Mar 2008 20:32:13 -0500
Mike Christie <michaelc@cs.wisc.edu> wrote:

> FUJITA Tomonori wrote:
> > On Wed, 26 Mar 2008 07:36:26 -0700
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> >> On Wed, 2008-03-26 at 23:22 +0900, FUJITA Tomonori wrote:
> >>> On Sat, 22 Mar 2008 11:06:00 -0500
> >>> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >>>
> >>>> On Tue, 2008-03-11 at 00:36 -0500, Mike Christie wrote:
> >>>>> Mike Christie wrote:
> >>>>>> Pete Wyckoff wrote:
> >>>>>>> I think this used not to happen; not sure.  But I changed two things
> >>>>>> This most likely did not happen before 2.6.25-rc* or it broke in 
> >>>>>> slightly different ways, because iscsi used to try and do
> >>>>>>
> >>>>>> echo 1 > /sys/block/sdX/device/delete
> >>>>>>
> >>>>>> from userspace instead of calling scsi_remove_target from the kernel.
> >>>>>>
> >>>>>> As you know around 2.6.21, the behavior of doing the echo to the delete 
> >>>>>> file changed due to a driver model and scsi change and that broke the 
> >>>>>> iscsi tools. The iscsi tools userspace removal was sort of hack in the 
> >>>>>> first place and was racey, so we switched to removing devices/target 
> >>>>>> like the FC class.
> >>>>>>
> >>>>>>
> >>>>>>> lately.  2.6.25-rc1 to -rc4 and fedora 8 iscsi-initiator-utils (865) to
> >>>>>>> fedora devel (868).  Bidi and varlen patches always too.
> >>>>>>>
> >>>>>>> I'll follow with some more variations on this theme.  Looks like bsg
> >>>>>>> needs to protect more carefully against the device going away.  Any
> >>>>>>> ideas how best to do this?  What was the approach in sg?
> >>>>>>>
> >>>>>> I think sg is broken in similar ways. The iser guys have some tests 
> >>>>>> cases that have broken sg while IO is outstanding. I am ccing Erez.
> >>>>> Actually one of the problems looks a little different than some of the 
> >>>>> problems hit with sg and are caused because we remove the bsg device too 
> >>>>> soon. I think we want to wait until all the references from the 
> >>>>> commands/requests are released. The attached patch (untested) moves the 
> >>>>> bsg unreg call to the scsi device release fn.
> >>>> Well, this fix is now upstream.  However, it's causing all our
> >>>> scsi_devices never to get released, which is a serious regression.
> >>>> We're also doing spurious bsg_unregister_queue() for things that never
> >>>> actually registered one (all scan devices that return DID_NO_CONNECT),
> >>>> but bsg doesn't seem to be complaining about this.
> >>>>
> >>>> The essence of the problem is that bsg_register_queue() takes a ref to
> >>>> the sdev_gendev, so you can't move bsg_unregister_queue() into the
> >>>> release function because nothing ever puts bsg's device ref and so
> >>>> release is never called.
> >>>>
> >>>> Options for fixing this before 2.6.25 are
> >>>>
> >>>>      1. revert the patch
> >>>>      2. Do an additional put for the bsg reference in
> >>>>         __scsi_remove_device (patch below).  It's nasty but it preserves
> >>>>         the semantics and does what you want
> >>> After some investigation, this patch doesn't fix the bug that Pete
> >>> reported (I'll send a new patch shortly).
> >>>
> >>> Can you revert the commit 4b6f5b3a993cbe34b4280f252bccc76967c185c8
> >>> instead of merging this?
> >> Sure ... I didn't like the hack either.  As long as iSCSI is fine with
> >> the reversion it's the quickest way to fix the problem.
> > 
> > How about this? With the commit reversion, I confirmed that this patch
> > fixes the first bug that Pete reported:
> > 
> > http://marc.info/?l=linux-scsi&m=120508166505141&w=2
> > 
> > I suspect that this could fix the rest too.
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] bsg: takes a ref to struct device in fops->open
> > 
> > bsg_register_queue() takes a ref to struct device that a caller
> > passes. For example, it takes a ref to the sdev_gendev with scsi
> > devices. However, bsg doesn't takes a ref to it in fops->open. So
> > while an application opens a bsg device, the scsi device that the bsg
> > device holds can go away (bsg also takes a ref to a queue, but it
> > doesn't prevent the device from going away).
> > 
> > With this, bsg takes a ref to struct device in fops->open and frees it
> > in fops->release.
> > 
> 
> It looks like it fixes the life time problem.

With the reverting and my patch, seems that all the problems (#1, #2,
and #3) has gone for me.


> My patch was actually supposed to fix #3 and fixing #1 was a side 
> affect. Will bsg_release still be called when the device is closed. If 
> so then it may not fix #3 because the bsg_release function still needs 
> to grab the mutex. Maybe bsg_complete_all_commands just needs to drop 
> the mutex while it waits for IO to complete.

I don't hit #3 problem. A process holds the mutex and waiting for I/O
completion. But fail_all_commands() makes all the commands fail, the
process releases the mutex and then bsg_unregister_queue is called.

But yeah, I think that we don't need to hold the mutex during waiting
for I/O completion here.
