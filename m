From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH block:for-3.3/core] cfq: merged request shouldn't jump
 to a different cfqq
Date: Fri, 06 Jan 2012 12:15:49 +0800
Message-ID: <1325823349.22361.523.camel@sli10-conroe>
References: <20120103200906.GG31746@google.com> <4F03631C.8080501@kernel.dk>
	 <20120103221301.GH31746@google.com> <20120103223505.GI31746@google.com>
	 <20120105012445.GP31746@google.com>
	 <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
	 <20120105183842.GF18486@google.com> <20120106021707.GA6276@google.com>
	 <20120106023638.GC6276@google.com>
	 <1325819655.22361.513.camel@sli10-conroe>
	 <20120106030406.GD6276@google.com>
	 <1325820878.22361.518.camel@sli10-conroe>
	 <CAOS58YOcciTFzYU9vsW2pnE=dbNo+rGz2XJ0Qjk4VHriNDw31g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAOS58YOcciTFzYU9vsW2pnE=dbNo+rGz2XJ0Qjk4VHriNDw31g@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-01-05 at 19:22 -0800, Tejun Heo wrote:
> On Thu, Jan 5, 2012 at 7:34 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> >> That's how cfq has behaved before this recent plug merge breakage and
> >> IIRC why the cooperating queue thing is there.  If you want to change
> >> the behavior, that should be an explicit separate patch.
> > My point is both cooperating merge and the plug merge of different cfq
> > are merge, no reason we allow one but disallow the other. plug merge
> > isn't a breakage to me.
> 
> Isolation is pretty big deal for cfq and cross cfqq merging happening
> without cfq noticing it isn't gonna be helpful to the cause.  Why
> don't we merge bio's across different cfqq's then?
don't know. I don't think a tweak for merge impacts isolation so much.
For rotate disk, request size hasn't impact to request cost, so this
doesn't impact isolation. Even for ssd, big size request is more
efficient to dispatch. And we already have breakage of fairness for SSD,
such as no idle.
