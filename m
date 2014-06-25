From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: sd_setup_discard_cmnd: BUG: unable to handle kernel NULL pointer
 dereference at (null)
Date: Wed, 25 Jun 2014 12:14:21 +0200
Message-ID: <20140625101421.GE17123@soda.linbit>
References: <53A28B21.7070500@profihost.ag>
 <yq1ionwjn15.fsf@sermon.lab.mkp.net>
 <20140620155321.GA24389@soda.linbit>
 <yq1wqcbil0c.fsf@sermon.lab.mkp.net>
 <20140620182956.GB24389@soda.linbit>
 <yq1vbrrh0yo.fsf@sermon.lab.mkp.net>
 <20140624115324.GB17123@soda.linbit>
 <yq1simtgax8.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zimbra13.linbit.com ([212.69.166.240]:36282 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaFYKOY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 06:14:24 -0400
Content-Disposition: inline
In-Reply-To: <yq1simtgax8.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, konrad.wilk@oracle.com, elder@linaro.org, Josh Durgin <josh.durgin@inktank.com>, Greg KH <gregkh@linuxfoundation.org>

On Tue, Jun 24, 2014 at 07:11:47PM -0400, Martin K. Petersen wrote:
> >>>>> "Lars" == Lars Ellenberg <lars.ellenberg@linbit.com> writes:
> 
> Lars> We are receiving (from network) and submitting (to lower level IO
> Lars> stack) in the same context and would like the submit to be async.
> 
> Lars> Do you intend to provide an asynchronous interface?
> 
> I guess we can look into that if there is a need.
> 
> Do different clients share that context? I.e. does a synchronous discard
> block other clients from accessing the drbd server?

Uhm, it's not like exactly like that, really.

Because the way we do some internal bookkeeping,
we announce a max discard of 4 MiB.
So if some user on the "active" (Primary) DRBD
does large discards, you will end up submitting
lots of bios, and these are async.

Bios are the entry point to DRBD.
So DRBD ships these discard-bios over to the peer,
which then right now submits them as bios, again async.
So we do some pipelining, may have a number of discard bios in flight,
and effectively the latency will be increased by something in the order
of the network rtt.

If we now have to use the synchronous interface on the peer
for each discard bio, there is no longer any pipelining,
and the overall latency of a single "user" level discard
(that ends up doing many discard bios) will noticeably increase.

Also, since the "receiver" is blocked in "submit",
we cannot meanwhile interleave other, "normal" BIOs,
so a larger discard will block all write (and depending on configuration
and current state, also read) within that DRBD resource (which again may
be one or more DRBD minor devices or "volumes").

I don't have real-life numbers on how much that may hurt.

Similar for the WRITE_SAME interface (which we do not properly support
on the DRBD protocol level yet -- backward compatibility concerns -- but
intend to support "soon").

If we only have a synchronous interface,
we will probably have to either add some "async wrapper",
or defer such submissions to worker threads.
I'd prefer to have an async submit path.

	Lars

