From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH block:for-3.3/core] cfq: merged request shouldn't jump
 to a different cfqq
Date: Fri, 06 Jan 2012 11:14:15 +0800
Message-ID: <1325819655.22361.513.camel@sli10-conroe>
References: <20120103173500.GB31746@google.com>
	 <20120103175922.GC31746@google.com> <20120103200906.GG31746@google.com>
	 <4F03631C.8080501@kernel.dk> <20120103221301.GH31746@google.com>
	 <20120103223505.GI31746@google.com> <20120105012445.GP31746@google.com>
	 <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
	 <20120105183842.GF18486@google.com> <20120106021707.GA6276@google.com>
	 <20120106023638.GC6276@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120106023638.GC6276@google.com>
Sender: linux-next-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-01-05 at 18:36 -0800, Tejun Heo wrote:
> Hello, again.
> 
> On Thu, Jan 05, 2012 at 06:17:07PM -0800, Tejun Heo wrote:
> > When two requests are merged, if the absorbed request is older than
> > the absorbing one, cfq_merged_requests() tries to reposition it in the
> > cfqq->fifo list by list_move()'ing the absorbing request to the
> > absorbed one before removing it.
> > 
> > This works if both requests are on the same cfqq but nothing
> > guarantees that and the code ends up moving the merged request to a
> > different cfqq's fifo list without adjusting the rest.  This leads to
> > the following failures.
> > 
> > * A request may be on the fifo list of a cfqq without holding
> >   reference to it and the cfqq can be freed before requst is finished.
> >   Among other things, this triggers list debug warning and slab debug
> >   use-after-free warning.
> > 
> > * As a request can be on the wrong fifo queue, it may be issued and
> >   completed before its cfqq is scheduled.  If the cfqq didn't have
> >   other requests on it, it would be empty by the time it's dispatched
> >   triggering BUG_ON() in cfq_dispatch_request().
> > 
> > Fix it by making cfq_merged_requests() scan the absorbing request's
> > fifo list for the correct slot and move there instead.
> 
> Hmmm... while the patch would fix the problem.  It isn't entirely
> correct.  The root cause is,
> 
> 1. q->last_merge and rqhash used to be used only for merging bios into
>    requests and that queries elevator whether the merge should be
>    allowed.  cfq disallows merging if they belong to different cfqqs.
> 
> 2. request-request merging didn't use to use q->last_merge or rqhash to
>    find request candidates.  It used elv_former/latter_request() and
>    cfq never returned request from a different cfqq.
> 
> 3. Plug merging started using q->last_merge and rqhash and now
>    elevator can't prevent cross cfqq merges.
> 
> So, yeah, the right fix would be using elv_former/latter_request()
> instead.  Maybe we should strip out rqhash altogether and change
> elevator handle everything?  I don't know.  I'll prepare a different
> fix patch soon.
So not allow merge from two cfq queues strictly? This will impact
performance. I don't know how important the strict isolation is. we even
allow two cfq queues merge to improve performance.
