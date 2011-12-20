From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 10/14] srp_transport: Simplify attribute initialization code
Date: Tue, 20 Dec 2011 10:21:22 +0000
Message-ID: <CAO+b5-q7mBJ-K48Oyeh5jzRmiXAx7nnAhG97PpfSp8ESVC6tJQ@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012008.00502.bvanassche@acm.org>
	<1324253243.17849.45.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324253243.17849.45.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 19, 2011 at 12:07 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> On Thu, 2011-12-01 at 20:08 +0100, Bart Van Assche wrote:
>> Eliminate the private_rport_attrs[] array and the SETUP_*() macros
>> used to set up that array since the information in that array
>> duplicates the information in the static device attributes. Also,
>> trigger a kernel warning if SRP_RPORT_ATTRS is not large enough
>> since it is easy to forget to update that macro when adding new
>> attributes.
>
> Not sure I care one way or the other, but it looks to have been written
> the way it was to share a common code structure with the FC, SAS, and
> other SCSI transport code.

My opinion about the SETUP_*() macros is that - at least in the SRP
transport code - they make the code harder to read without having any
real value and hence should be removed.

> They use a BUG_ON instead of WARN_ON, which
> seems more appropriate, since we just overran a buffer...

Sorry, but I disagree. The guideline for Linux kernel code is to use
BUG_ON() only if a crash can't be avoided. With SLUB red zoning
enabled it is still possible to unload kernel modules after a (mild)
buffer overrun. And if you have a look at mm/slub.c, you will see that
slab_err() is invoked in case padding has been overwritten. That last
function does something similar to WARN_ON().

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
