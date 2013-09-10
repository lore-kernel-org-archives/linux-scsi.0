From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] block: fix race between request completion and timeout handling
Date: Tue, 10 Sep 2013 14:01:49 -0400
Message-ID: <x4961u8eesy.fsf@segfault.boston.devel.redhat.com>
References: <x49k3j4s41j.fsf@segfault.boston.devel.redhat.com>
	<1378834539.3872.6443.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378834539.3872.6443.camel@localhost.localdomain> (Ewan Milne's
	message of "Tue, 10 Sep 2013 13:35:39 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: emilne@redhat.com
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Ewan Milne <emilne@redhat.com> writes:

> If the request completes after blk_mark_rq_complete() is called but
> before blk_clear_req_complete() is called, the completion will not be
> processed, and we will have to wait for the request to timeout again.
> Maybe this is not so bad, as it should be extremely rare, but if the
> timeout were a large value for some reason, that could be a problem.
>
> It seems to me that the issue is really that there are 2 state variables
> (the REQ_ATOM_COMPLETE flag and the req->timeout_list) for the same
> state, and so manipulating both of these without a lock will always have
> a window.

Agreed.  Do you see a clean way of fixing that?

> Clearly it would be better to avoid a panic, so Jeff's fix would help.
>
> I'm not sure I follow how the issue Jeff is fixing caused this
> particular crash, though.  How did the request get back on the queue?
> The crash occurred when the SCSI EH was flushing the done_q requests.

Right, sorry.  I wrote that after having been away from the problem for
too long.  I left out an important part:

This would only actually explain the coredumps *IF* the request
structure was freed, reallocated *and* queued before the error handler
thread had a chance to process it.  That is possible, but it may make
sense to keep digging for another race.  I think that if this is what
was happening, we would see other instances of this problem showing up
as null pointer or garbage pointer dereferences, for example when the
request structure was not re-used.  It looks like we actually do run
into that situation in other reports.

I don't think this is a smoking gun, but I think the patch should go in
so we can further narrow down the search.

Thanks for looking at it, Ewan.

Cheers,
Jeff
