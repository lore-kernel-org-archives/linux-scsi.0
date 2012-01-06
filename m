From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH block:for-3.3/core] block: disable
 ELEVATOR_INSERT_SORT_MERGE
Date: Fri, 06 Jan 2012 12:19:05 +0800
Message-ID: <1325823545.22361.526.camel@sli10-conroe>
References: <20120103221301.GH31746@google.com>
	 <20120103223505.GI31746@google.com> <20120105012445.GP31746@google.com>
	 <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
	 <20120105183842.GF18486@google.com> <20120106021707.GA6276@google.com>
	 <20120106023638.GC6276@google.com>
	 <1325819655.22361.513.camel@sli10-conroe>
	 <20120106030406.GD6276@google.com> <20120106033012.GE6276@google.com>
	 <20120106035247.GF6276@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120106035247.GF6276@google.com>
Sender: linux-next-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-01-05 at 19:52 -0800, Tejun Heo wrote:
> 5e84ea3a9c "block: attempt to merge with existing requests on plug
> flush" added support for merging requests on plug flush and 274193224c
> "block: recursive merge requests" added recursive merging.
> 
> Because these mergings happen before the request is inserted on the
> elevator, the usual elv_latter/former_request() can't be used to
> locate merge candidates.  It instead used bio merging mechanism -
> last_merge hint and rqhash; unfortunately, this means that the
> elevator doesn't have a say in which are allowed to merge and which
> aren't.
> 
> For cfq, this resulted in merges across different cfqq's which led to
> crashes as requests jump between different cfqq's unexpectedly.
> 
> Proper solution would be improving merge mechanism such that we can
> always query elevator to find out merge candidates and remove rqhash;
> however, the merge window is already upon us.  Disable
> INSERT_SORT_MERGE for now.
> 
> For detailed discussion of the bug:
> 
>  http://thread.gmane.org/gmane.linux.kernel.next/20064/focus=20159
> 
this is overkill. when plug is added, we found huge performance
regression, that's why we add INSERT_SORT_MERGE.

Thanks,
Shaohua
