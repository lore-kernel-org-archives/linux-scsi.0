From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be
 allowed to create io_context
Date: Thu, 5 Jan 2012 10:36:21 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
References: <20111228164836.GP17712@google.com> <alpine.LSU.2.00.1112280939390.3320@eggly.anvils> <CAOS58YOzUcZz41+H+7dk5FteHy+Ufrtpk9dvdPqX6eie-GHi0Q@mail.gmail.com> <20111228211918.GA3516@google.com> <20120103173500.GB31746@google.com> <20120103175922.GC31746@google.com>
 <20120103200906.GG31746@google.com> <4F03631C.8080501@kernel.dk> <20120103221301.GH31746@google.com> <20120103223505.GI31746@google.com> <20120105012445.GP31746@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120105012445.GP31746@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 4 Jan 2012, Tejun Heo wrote:
> On Tue, Jan 03, 2012 at 02:35:05PM -0800, Tejun Heo wrote:
> > > Hmmm... I disabled cfqq merge logic (commented out
> > > cfq_close_cooperator() and the following cfq_setup_merge() calls) in
> > > cfq_select_queue() and neither is triggering for quite a while now.
> > > Maybe cfqq refcnt is getting borked over cfqq merging / splitting?  It
> > > would also explain the low frequency of the issue too.  I'll try to
> > > further isolate it but It would be awesome if someone more familiar
> > > with the logic can go over that part.
> > 
> > Scrap that.  It triggered and yeah cfq_get_next_queue() is retrieving
> > empty cfqq from the service tree.
> 
> Update: I've been running with ELEVATOR_INSERT_SORT_MERGE disabled and
> none of the issues triggered for about three hours now.  It usually
> triggers under an hour.
> 
> Hugh, can you please verify whether the patch appended at the end
> makes the problem go away?

I can vouch that it makes the list_debug.c:53 warnings go away: they
used to come in half an hour, but I've run on two machines for 10
hours so far without seeing any.

And I've not yet seen a cfq-iosched.c:2585 with that patch in; but
those were more elusive - we'll have to run until tomorrow night
before concluding that it makes those go away too.

Or if you understand the connection between these, and would prefer
to assume that it fixes them both, and want me to try another patch
instead (I assume the one I'm running with is a workaround to narrow
down the issue, rather than an intended fix?), let me know and I'll
switch over.

Hugh

> 
> Thanks.
> 
> diff --git a/block/elevator.c b/block/elevator.c
> index 99838f4..2e172d2 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -644,6 +644,9 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
>  
>  	rq->q = q;
>  
> +	if (where == ELEVATOR_INSERT_SORT_MERGE)
> +		where = ELEVATOR_INSERT_SORT;
> +
>  	if (rq->cmd_flags & REQ_SOFTBARRIER) {
>  		/* barriers are scheduling boundary, update end_sector */
>  		if (rq->cmd_type == REQ_TYPE_FS ||
> 
