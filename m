From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Sat, 19 Aug 2006 21:00:41 -0400
Message-ID: <44E7B439.2070602@torque.net>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com> <44E6388D.1000206@torque.net> <44E68F76.4010702@torque.net> <20060819172024.GS4340@parisc-linux.org> <44E74C21.8040108@torque.net> <20060819104109.588604bd.akpm@osdl.org> <20060819202323.GT4340@parisc-linux.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53636 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751024AbWHTBA5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 21:00:57 -0400
In-Reply-To: <20060819202323.GT4340@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@osdl.org>, Fajun Chen <fajunchen@gmail.com>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Matthew Wilcox wrote:
> On Sat, Aug 19, 2006 at 10:41:09AM -0700, Andrew Morton wrote:
>> ow, GFP_ATOMIC is bad.  Can we avoid that?
> 
> I believe all the GFP_ATOMIC calls in sg.c can be downgraded to
> GFP_KERNEL.

Well, if memory serves, we have been around this loop
before. The GFP_ATOMIC flags were removed, users
complained about unexplained, unbounded waits unrelated
to the SCSI transport or device. So the GFP_ATOMIC
flags were put back again. The semantics of the
function that calls alloc_pages() is to cope with a
(fast) failure, and if it is an ambit claim (e.g. the
reserve buffer allocation on open() ) then lower the
order by 1 (halve the requested allocation) then try again.

The semantics of SCSI command injection in the sg driver
have been to fetch the resources needed and inject the
command to the mid level as quickly as possible.
If there is a resource problem, exit and tell the user
space promptly.

So the action required seems to be __GFP_NORETRY if that
works as its name suggests.

> sg_add_sfp is only called from sg_open(), so the GFP_ATOMIC there can
> be downgraded to GFP_KERNEL.

That is called on open() so GFP_KERNEL | __GFP_NORETRY
should be ok.

> There's one in sg_common_write that can be downgraded. It's called
> from sg_write and sg_ioctl (via sg_new_write).  No locks are held at
> those points.

That one is the last argument to scsi_execute_async().
I didn't add that and don't know what it is for.
Perhaps James could comment.

> st_map_user_pages uses GFP_ATOMIC.  It's only called from
> sg_build_direct, which is only called from sg_start_req, which is only
> called from sg_new_write, which is safe per above.

GFP_KERNEL | __GFP_NORETRY

> sg_page_malloc uses GFP_ATOMIC.  It's only called from sg_build_indirect.
> sg_build_indirect is called from sg_start_req (previously shown safe),
> and sg_build_reserve.  sg_build_reserve is safe as it's only called from
> sg_ioctl and sg_add_sfp (previously shown safe).
> 
> sg_build_sgat is called from sg_build_direct and sg_build_indirect,
> both of which have previously been shown safe.
> 
> Please check my reasoning, but I'm pretty confident that none of these
> paths are called with any locks held.

None of the kmalloc()s or alloc_pages() are called
from softirq callback ( sg_cmd_done() in sg's case) that
I can see. I don't think locks taken by the sg driver
should be a problem.


BTW I'm initially trying to fix a bug added by someone
else into the sg driver in lk 2.6.16 . The code I'm
proposing isn't optimal but, by reverting the code (more
or less) to what it was, at least I know it was well
tested :-) Thus I was hoping to get the fix into
lk 2.6.18 . The other changes being discussed could go
into the lk 2.6.19 cycle.

Doug Gilbert

