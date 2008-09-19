From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] lld busy status exporting interface
Date: Fri, 19 Sep 2008 16:45:24 -0700
Message-ID: <20080919164524.295e1f9a.akpm@linux-foundation.org>
References: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>
	<20080919.104854.71084447.k-ueda@ct.jp.nec.com>
	<20080919143344.44d1a83e.akpm@linux-foundation.org>
	<20080919.191122.102582872.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbYISXpt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2008 19:45:49 -0400
In-Reply-To: <20080919.191122.102582872.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

On Fri, 19 Sep 2008 19:11:22 -0400 (EDT)
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> > Back in the days when we first did the backing_dev_info.congested_fn()
> > logic it was decided that there basically was no single place in which
> > the congested state could be stored.
> > 
> > So we ended up deciding that whenever a caller wants to know a
> > backing_dev's congested status, it has to call in to the
> > ->congested_fn() and that congested_fn would then call down into all
> > the constituent low-level drivers/queues/etc asking each one if it is
> > congested.
> 
> bdi_lld_congested() also does that using bdi_congested(), which calls
> ->congested_fn().
> And only real device drivers (e.g. scsi, ide) set/clear the flag.
> Stacking drivers like request-based dm don't.

umm, OK, that should work.

> So stacking drivers always check the BDI_lld_congested flag of
> the bottom device of the device stack.

How does a stacking driver know that the backing_device which it is
looking at is a "lowest level" device?

I don't think it does - only the code which implements that device
knows this, so the stacking driver has to call into that device's
congested_fn(), yes?

In which case one wonders why the state was stored in the
backing_dev_info at all.  Why not store it in the device-private data
to avoid confusion and abuse?

> BDI_[write|read]_congested flags have been using for queue's
> congestion, so that I/O queueing/merging can be proceeded even if
> the lld is congested.  So I added a new flag.

iirc, BDI_read/write_congested predated the introduction of the
congested_fn() and perhaps should have been removed once we went to the
congested_fn approach.  But it's been a while since I spent a lot of
time looking in there.

> 
> > I mean, as a simple example which is probably wrong - what happens if a
> > single backing_dev is implemented via two different disks and
> > controllers, and they both become congested and then one of them comes
> > uncongested.  Is there no way in which the above implemention can
> > incorrectly flag the backing_dev as being uncongested?
> 
> Do you mean that "a single backing_dev via two disks/controllers" is
> a dm device (e.g. a dm-multipath device having 2 paths, a dm-mirror
> device having 2 disks)?

Something along those lines, sure.

> If so, dm doesn't set/clear the flag, and the decision, whether
> the dm device itself is congested or not, depends on dm's target driver.
> 
> For example of dm-multipath,
>   o call bdi_lld_congested() for each path.
>   o if one of the paths are uncongested, dm-multipath will decide
>     the dm device is uncongested and dispatch incoming I/Os to
>     the uncongested path.

hm, OK.

> For example of dm-mirror,
>   o call bdi_lld_congested() for each disk.
>   o if the incoming I/O is READ, same logic as dm-multipath above.
>     if the incoming I/O is WRITE, dm-mirror will decide the dm device
>     is uncongested only when all disks are uncongested.
> 
> Thanks,
> Kiyoshi Ueda
