From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Serious regression caused by fix for [BUG 1/3] bsg queue oops
 with	iscsi logout
Date: Mon, 24 Mar 2008 18:23:23 +0900
Message-ID: <20080324182323W.fujita.tomonori@lab.ntt.co.jp>
References: <47D5766C.3020206@cs.wisc.edu>
	<47D61A73.3000803@cs.wisc.edu>
	<1206201960.4393.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:54283 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbYCXJYb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Mar 2008 05:24:31 -0400
In-Reply-To: <1206201960.4393.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: michaelc@cs.wisc.edu, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, erezz@voltaire.com, Jens.Axboe@oracle.com

On Sat, 22 Mar 2008 11:06:00 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2008-03-11 at 00:36 -0500, Mike Christie wrote:
> > Mike Christie wrote:
> > > Pete Wyckoff wrote:
> > >> I think this used not to happen; not sure.  But I changed two things
> > > 
> > > This most likely did not happen before 2.6.25-rc* or it broke in 
> > > slightly different ways, because iscsi used to try and do
> > > 
> > > echo 1 > /sys/block/sdX/device/delete
> > > 
> > > from userspace instead of calling scsi_remove_target from the kernel.
> > > 
> > > As you know around 2.6.21, the behavior of doing the echo to the delete 
> > > file changed due to a driver model and scsi change and that broke the 
> > > iscsi tools. The iscsi tools userspace removal was sort of hack in the 
> > > first place and was racey, so we switched to removing devices/target 
> > > like the FC class.
> > > 
> > > 
> > >> lately.  2.6.25-rc1 to -rc4 and fedora 8 iscsi-initiator-utils (865) to
> > >> fedora devel (868).  Bidi and varlen patches always too.
> > >>
> > >> I'll follow with some more variations on this theme.  Looks like bsg
> > >> needs to protect more carefully against the device going away.  Any
> > >> ideas how best to do this?  What was the approach in sg?
> > >>
> > > 
> > > I think sg is broken in similar ways. The iser guys have some tests 
> > > cases that have broken sg while IO is outstanding. I am ccing Erez.
> > 
> > Actually one of the problems looks a little different than some of the 
> > problems hit with sg and are caused because we remove the bsg device too 
> > soon. I think we want to wait until all the references from the 
> > commands/requests are released. The attached patch (untested) moves the 
> > bsg unreg call to the scsi device release fn.
> 
> Well, this fix is now upstream.  However, it's causing all our
> scsi_devices never to get released, which is a serious regression.

This is extremely bad. Really sorry about it.


> We're also doing spurious bsg_unregister_queue() for things that never
> actually registered one (all scan devices that return DID_NO_CONNECT),
> but bsg doesn't seem to be complaining about this.

bsg_unregister_queue checks that queues are registered. scsi_sysfs and
sas_transport ignore the failure of bsg_register_queue so bsg needs to
do that.


> The essence of the problem is that bsg_register_queue() takes a ref to
> the sdev_gendev, so you can't move bsg_unregister_queue() into the
> release function because nothing ever puts bsg's device ref and so
> release is never called.
> 
> Options for fixing this before 2.6.25 are
> 
>      1. revert the patch
>      2. Do an additional put for the bsg reference in
>         __scsi_remove_device (patch below).  It's nasty but it preserves
>         the semantics and does what you want
>      3. Modify bsg_register_queue not to take a device reference on the
>         grounds that the queue lifetime is *always* shorter than the
>         generic device lifetime.  This sounds the most plausible, but
>         it's unsafe ... if the device gets released first the queue is
>         left holding a freed area of memory.  Jens, can we make this
>         work?

If the third option doesn't work, bsg_unregister_queue needs to clean
up active commands properly instead of just freeing the stuff when
it's called from __scsi_remove_device. I think that sg driver does the
similar thing (if the third option works, we can remove the code in sg
too). I'll fix this for 2.6.26.
