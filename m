From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 23/27] drbd: make intelligent use of
	blkdev_issue_zeroout
Date: Mon, 15 Jan 2018 10:07:38 -0500
Message-ID: <20180115150738.GA20967@redhat.com>
References: <20170405172125.22600-1-hch@lst.de>
	<20170405172125.22600-24-hch@lst.de>
	<alpine.LRH.2.11.1801130035010.13147@mail.ewheeler.net>
	<20180115124635.GA4107@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180115124635.GA4107-w1SgEEioFePxa46PmUWvFg@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Eric Wheeler <drbd-dev-Himy5ogN2wUERf3Jot9Y56xOck334EZe@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Cc: ejt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 15 2018 at  7:46am -0500,
Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org> wrote:
 
> As I understood it,
> blkdev_issue_zeroout() was supposed to "always try to unmap",
> deprovision, the relevant region, and zero-out any unaligned
> head or tail, just like my work around above was doing.
> 
> And that device mapper thin was "about to" learn this, "soon",
> or maybe block core would do the equivalent of my workaround
> described above.
> 
> But it then did not.
> 
> See also:
> https://www.redhat.com/archives/dm-devel/2017-March/msg00213.html
> https://www.redhat.com/archives/dm-devel/2017-March/msg00226.html

Right, now that you mention it it is starting to ring a bell (especially
after I read your 2nd dm-devel archive url above).

> I then did not follow this closely enough anymore,
> and I missed that with recent enough kernel,
> discard on DRBD on dm-thin would fully allocate.
> 
> In our out-of-tree module, we had to keep the older code for
> compat reasons, anyways. I will just re-enable our zeroout
> workaround there again.
> 
> In tree, either dm-thin learns to do REQ_OP_WRITE_ZEROES "properly",
> so the result in this scenario is what we expect:
> 
>   _: unprovisioned, not allocated, returns zero on read anyways
>   *: provisioned, some arbitrary data
>   0: explicitly zeroed:
> 
>   |gran|ular|ity |    |    |    |
>   |****|****|____|****|
>      to|-be-|zero|ed
>   |**00|____|____|00**|
> 
> (leave unallocated blocks alone,
>  de-allocate full blocks just like with discard,
>  explicitly zero unaligned head and tail)

"de-allocate full blocks just like with discard" is an interesting take
what it means for dm-thin to handle REQ_OP_WRITE_ZEROES "properly".

> Or DRBD will have to resurrect that reinvented zeroout again,
> with exactly those semantics. I did reinvent it for a reason ;)

Yeah, I now recall dropping that line of development because it
became "hard" (or at least harder than originally thought).

Don't people use REQ_OP_WRITE_ZEROES to initialize a portion of the
disk?  E.g. zeroing superblocks, metadata areas, or whatever?

If we just discarded the logical extent and then a user did a partial
write to the block, areas that a user might expect to be zeroed wouldn't
be (at least in the case of dm-thinp if "skip_block_zeroing" is
enabled).  And yes if discard passdown is enabled and the device's
discard implementation does "discard_zeroes_data" then it'd be
fine.. but there are a lot of things that need to line up for drbd's
REQ_OP_WRITE_ZEROES to "just work" (as it expects).

(now I'm just echoing the kinds of concerns I had in that 2nd dm-devel
post above).

This post from mkp is interesting:
https://www.redhat.com/archives/dm-devel/2017-March/msg00228.html

Specifically:
"You don't have a way to mark those blocks as being full of zeroes
without actually writing them?

Note that the fallback to a zeroout command is to do a regular write. So
if DM doesn't zero the blocks, the block layer is going to it."

No, dm-thinp doesn't have an easy way to mark an allocated block as
containing zeroes (without actually zeroing).  I toyed with adding that
but then realized that even if we had it it'd still require block
zeroing be enabled.  But block zeroing is done at allocation time.  So
we'd need to interpret the "this block is zeroes" flag to mean "on first
write or read to this block it needs to first zero it".  Fugly to say
the least...

I've been quite busy with other things but I can revisit all this with
Joe Thornber and see what we come up with after a 2nd discussion.

But sadly, in general, this is a low priority for me, so you might do
well to reintroduce your drbd workaround.. sorry about that :(

Mike
