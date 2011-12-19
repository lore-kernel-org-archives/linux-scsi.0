From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 14/14] ib_srp: Allow SRP disconnect through sysfs
Date: Mon, 19 Dec 2011 09:04:24 +0000
Message-ID: <CAO+b5-q3mhV7zbn61qqpvZf86K0d5SpUOnL7Lw5saRyNJ2YFLQ@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012013.33246.bvanassche@acm.org>
	<1324267414.17849.98.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324267414.17849.98.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 19, 2011 at 4:03 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> On Thu, 2011-12-01 at 20:13 +0100, Bart Van Assche wrote:
>> Make it possible to disconnect via sysfs the IB RC connection used by the
>> SRP protocol to communicate with a target.
>>
>> Let the SRP transport layer create a sysfs "delete" attribute for
>> initiator drivers that support this functionality.
>
> This will be a nice feature to have, but I wonder about the proper
> behavior. I had thought about having a 'drain' state, where we wouldn't
> start new commands and would let existing ones complete or timeout
> before killing the connection. That may be in addition to a 'kill it
> now' variant.
>
> Though perhaps my gentler delete is best done by having a user script
> walk all of the devices under the host and set them to offline, wait for
> scsi_host/hostX/host_busy to drop to zero, then hit the SRP delete attr.

Sorry, but I disagree. One of the goals of this patch set is to make
fast fail-over possible. Waiting for an error completion or time out
contradicts with that goal.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
