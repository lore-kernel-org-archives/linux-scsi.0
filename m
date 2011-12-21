From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 12/14] ib_srp: Rework error handling
Date: Wed, 21 Dec 2011 13:26:26 +0000
Message-ID: <CAO+b5-q-71L_xNNL8CHpO4fX8vRp9p4jsaS14jLiLU4ns8eucA@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012010.37276.bvanassche@acm.org>
	<1324265791.17849.92.camel@obelisk.thedillows.org>
	<CAO+b5-q332RKkLrUV7X_D73SHBrLpt=6Xz=W7ZtOwZ+9iSOyDw@mail.gmail.com>
	<1324335083.7043.66.camel@lap75545.ornl.gov>
	<CAO+b5-qF2taG0B4n9SBwqnuh0wajH5fXFLTb-VAaDrfT9TZ6aQ@mail.gmail.com>
	<1324438387.7621.53.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324438387.7621.53.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 21, 2011 at 3:33 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> What keeps the srp_recv_completion() --> srp_handle_recv() -->
> srp_process_rsp() --> etc. call chain from racing with
> srp_reconnect_target()?
>
> It looks like the srp_reset_req() in srp_reconnect_target() could race
> with srp_process_rsp() if receive completions continue to be processed
> after a send failure, but perhaps it is I who is missing something.

In the tests I ran so far no issues came up most likely because the
decision to reconnect is taken a long time after the most recent
response has been received. I'll see what has to change to make this
safe even if there wouldn't be any such delay.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
