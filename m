From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block:for-3.3/core] cfq: merged request shouldn't jump
 to a different cfqq
Date: Thu, 5 Jan 2012 19:30:12 -0800
Message-ID: <20120106033012.GE6276@google.com>
References: <4F03631C.8080501@kernel.dk>
 <20120103221301.GH31746@google.com>
 <20120103223505.GI31746@google.com>
 <20120105012445.GP31746@google.com>
 <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
 <20120105183842.GF18486@google.com>
 <20120106021707.GA6276@google.com>
 <20120106023638.GC6276@google.com>
 <1325819655.22361.513.camel@sli10-conroe>
 <20120106030406.GD6276@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120106030406.GD6276@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>, Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

Ummmm... I've been looking at the code and currently I think the best
option is yank out plug merging for this merge window.

Bypassing rqhash for request merging doesn't seem like a good idea.
rqhash itself is, at this point, redundant and the limitation that it
can only find requests by the ending sectors lead to weird designs.
The single ->last_merge was okay but the recursive back merging is
just ugly.  What it should be doing is trying back merge and then
front merge once for each request insertion as the usual merge path
does.

We can't do attempt_back/front_merge() for INSERT_MERGE at this point
because elv_latter/former_request() only works for requests which are
already on elevator and, unfortunately, putting a request onto cfq may
kick the queue directly and the request might already be gone by the
time we try to merge it.

For this merge window, I think we better just disable INSERT_MERGE.

A mid-term solution could be changing elevator interface such that
elevator_add_req_fn() doesn't kick the queue directly but notify
elevator core that the queue needs kicking via return value, so that
merging can happen before kicking the queue.  Note that there's a
caveat here.  Merging might make kicking unnecessary or wrong.

Better solution would be changing elevator merge logic so that it has
"give me request closest to this offset" interface and then use
prev/next from there to find out merge candidates for both bio-rq and
rq-rq merges and just kill rqhash.

Thanks.

-- 
tejun
