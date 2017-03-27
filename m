From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: RFC: always use REQ_OP_WRITE_ZEROES for zeroing
	offload
Date: Mon, 27 Mar 2017 10:03:07 -0400
Message-ID: <20170327140307.GA13020@redhat.com>
References: <20170323143341.31549-1-hch@lst.de>
	<20170323155410.GD1138@soda.linbit>
	<20170327091056.GB6879@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170327091056.GB6879-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 27 2017 at  5:10am -0400,
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> It sounds like you don't want to support traditional discard at all,
> but only WRITE ZEROES.  So in many ways this series is the right way
> forward.  It would be nice if we could do a full blown
> REQ_OP_WRITE_ZEROES for dm_think that zeroes out partial blocks,
> similar to what hardware that implements WRITE SAME of zeroes
> or WRITE ZEROES would do.  I'll see if I could include that in my
> series.

By "you" I assume you're referring to Lars?  Lars' approach for discard,
when drbd is layered on dm-thinp, feels over-engineered.  Not his fault,
the way discard and zeroing got conflated certainly lends itself to
these ugly hacks.  SO I do appreciate that for anything to leverage
discard_zeroes_data it needs to be reliable.  Which runs counter to how
discard was implemented (discard may get silently dropped!)  But that is
why dm-thinp doesn't advertise dzd.  Anyway...

As for the blkdev_issue_zeroout() resorting to manually zeroing the
range, if the discard fails or dzd not supported, that certainly
requires DM thinp to implement manual zeroing of the head and tail of
the range if partial blocks are being zeroed.  So I welcome any advances
there.  It is probably something that is best left to Joe or myself to
tackle.  But I'll gladly accept patches ;)
