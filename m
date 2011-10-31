From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: srp_transport: Fix atttribute registration race
Date: Mon, 31 Oct 2011 13:33:28 +0400
Message-ID: <1320053608.8283.29.camel@dabdike>
References: <201110211857.23622.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201110211857.23622.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-10-21 at 18:57 +0200, Bart Van Assche wrote: 
> Register transport attributes after the attribute array has been
> set up instead of before. The current code is racy because there
> is no guarantee that the CPU examining the attribute container
> will see all values written to the container.

I don't agree with this change log.  As far as the kernel is concerned,
nothing happens until that function returns because the only way to use
anything is to get a match to succeed, and they all check for
->transportt which will be NULL.

I can accept that it's best practise to initialise something before
registering it, because the reverse excites everyone's bogosity sensors,
it's just not a bug in this case.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
