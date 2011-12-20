From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 13/14] ib_srp: Implement transport layer ping
Date: Tue, 20 Dec 2011 10:27:23 +0000
Message-ID: <CAO+b5-r4AZymMkVyFSXbBzpcc86hL0RJm2j3FnT3=uXSLUkj9A@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012011.45444.bvanassche@acm.org>
	<1324255806.17849.68.camel@obelisk.thedillows.org>
	<CAO+b5-o+-JF61a+8vFWj1rxMuVWuG-CVLQKorr5cKzi-Kc44Ag@mail.gmail.com>
	<1324333931.7043.52.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324333931.7043.52.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 19, 2011 at 10:32 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> Part of the problem is introduced by allowing for permanent connections
> rather than using the familiar dev_loss_tmo and fast_io_fail_tmo
> parameters from other SCSI transports. For instance, in the FC
> transport, rports are allowed to disappear for up to dev_loss_tmo
> seconds before being removed from the SCSI device tree. Until they have
> been gone for fast_fail_io_tmo seconds, they are blocked (as is error
> handling to prevent offlining devices). Once they have been gone longer
> that fast_fail_io_tmo, they become unblocked and new IO will be failed.

I'm not convinced an equivalent of fast_fail_io_tmo is necessary for
the SRP transport. If a target disappears briefly from the IB fabric
what will happen with the posted patch series is that the initiator is
blocked during one ping interval and also that a reconnect is
triggered. Also, some SCSI commands may be reissued after
reconnecting. But that shouldn't have any adverse consequences, isn't
it ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
