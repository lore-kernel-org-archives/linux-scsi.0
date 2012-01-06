From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block:for-3.3/core] block: disable ELEVATOR_INSERT_SORT_MERGE
Date: Thu, 5 Jan 2012 20:38:07 -0800
Message-ID: <CAOS58YPUgK4J6j1Gme9O9HeL7GrwnJU8QTVKbVLA9cEXPQ1kag@mail.gmail.com>
References: <20120103221301.GH31746@google.com>
	<20120103223505.GI31746@google.com>
	<20120105012445.GP31746@google.com>
	<alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
	<20120105183842.GF18486@google.com>
	<20120106021707.GA6276@google.com>
	<20120106023638.GC6276@google.com>
	<1325819655.22361.513.camel@sli10-conroe>
	<20120106030406.GD6276@google.com>
	<20120106033012.GE6276@google.com>
	<20120106035247.GF6276@google.com>
	<1325823545.22361.526.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1325823545.22361.526.camel@sli10-conroe>
Sender: linux-next-owner@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Jan 5, 2012 at 8:19 PM, Shaohua Li <shaohua.li@intel.com> wrote=
:
>> For detailed discussion of the bug:
>>
>> =A0http://thread.gmane.org/gmane.linux.kernel.next/20064/focus=3D201=
59
>>
> this is overkill. when plug is added, we found huge performance
> regression, that's why we add INSERT_SORT_MERGE.

With what workload? I suspect most of the improvements is from merging
across different cfqqs, no? The whole recursive thing can't be very
useful if cross-cfqq merging isn't allowed. Maybe there are specific
cases where last_merge hint merging can be specially effective. I
don't know. Regardless, this is an apparent bug and the block tree
will be pushed mainline pretty soon. If necessary, fix it better
later. Doing complex things inside merge window usually isn't a good
idea.

Thanks.

--=20
tejun
