From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 13/14] ib_srp: Implement transport layer ping
Date: Tue, 20 Dec 2011 21:32:06 -0500
Message-ID: <1324434727.7621.19.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012011.45444.bvanassche@acm.org>
	 <1324255806.17849.68.camel@obelisk.thedillows.org>
	 <CAO+b5-o+-JF61a+8vFWj1rxMuVWuG-CVLQKorr5cKzi-Kc44Ag@mail.gmail.com>
	 <1324333931.7043.52.camel@lap75545.ornl.gov>
	 <CAO+b5-qLxmcXCCxA8+bPYsinjr1eqCDO2JUJbjgVr59N55CU1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-qLxmcXCCxA8+bPYsinjr1eqCDO2JUJbjgVr59N55CU1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-12-20 at 10:13 +0000, Bart Van Assche wrote:
> On Mon, Dec 19, 2011 at 10:32 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > I still think this is already solved in user space, but the new
> > reconnect model you've implemented doesn't match up with the expected
> > semantics. It'd be better to match the rest of the SCSI stack for this.
> 
> Sorry, but I'm afraid there is no "rest of the SCSI stack
> [semantics]". I've been following the semantics implemented in
> open-iscsi. If the semantics implemented for FC differ of those
> proposed in this patch set, then that means that the semantics
> implemented for FC differ of those for open-iscsi.

FC, SAS, SPI, (current) SRP, and FCoE currently use the same semantic to
check if the transport is still alive -- user space initiates activity,
usually via multipathd. You are changing SRP to match the iSCSI stack,
and because SRP does not have a NOP command, you have to fake one up
using Test Unit Ready to the first LUN to come through slave_alloc().
You kill the entire connection if that LUN has issues and causes a
timeout, though the rest of the LUNs may be fine and able to
communicate.

This is all handled properly by existing user space code; there's no
need for it to be in kernel, especially if you have to fake it while
going against the grain.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
