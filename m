From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH block:for-3.3/core] block: disable
 ELEVATOR_INSERT_SORT_MERGE
Date: Fri, 06 Jan 2012 16:15:57 +0800
Message-ID: <1325837757.22361.538.camel@sli10-conroe>
References: <20120103221301.GH31746@google.com>
	 <20120103223505.GI31746@google.com> <20120105012445.GP31746@google.com>
	 <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
	 <20120105183842.GF18486@google.com> <20120106021707.GA6276@google.com>
	 <20120106023638.GC6276@google.com>
	 <1325819655.22361.513.camel@sli10-conroe>
	 <20120106030406.GD6276@google.com> <20120106033012.GE6276@google.com>
	 <20120106035247.GF6276@google.com>
	 <1325823545.22361.526.camel@sli10-conroe>
	 <CAOS58YPUgK4J6j1Gme9O9HeL7GrwnJU8QTVKbVLA9cEXPQ1kag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAOS58YPUgK4J6j1Gme9O9HeL7GrwnJU8QTVKbVLA9cEXPQ1kag@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-01-05 at 20:38 -0800, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jan 5, 2012 at 8:19 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> >> For detailed discussion of the bug:
> >>
> >>  http://thread.gmane.org/gmane.linux.kernel.next/20064/focus=20159
> >>
> > this is overkill. when plug is added, we found huge performance
> > regression, that's why we add INSERT_SORT_MERGE.
> 
> With what workload? I suspect most of the improvements is from merging
> across different cfqqs, no? The whole recursive thing can't be very
> useful if cross-cfqq merging isn't allowed. Maybe there are specific
> cases where last_merge hint merging can be specially effective. I
> don't know. Regardless, this is an apparent bug and the block tree
> will be pushed mainline pretty soon. If necessary, fix it better
> later. Doing complex things inside merge window usually isn't a good
> idea.
it's not related to the recursive merge. I forgot the detail of the
workload why we add INSERT_SORT_MERGE, it's added several months ago
anyway.
Obviously we shouldn't do complex things inside the merge window. I just
didn't agree to disable INSERT_SORT_MERGE, which will bring performance
regression for sure. Can we just change CFQ like your first path?

Thanks,
Shaohua

