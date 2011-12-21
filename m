From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 13/14] ib_srp: Implement transport layer ping
Date: Wed, 21 Dec 2011 14:07:25 +0000
Message-ID: <CAO+b5-p=01KyDv7swOP_K39+i1rSMDsd_VVvSi5rBWveMaov1Q@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012011.45444.bvanassche@acm.org>
	<1324255806.17849.68.camel@obelisk.thedillows.org>
	<CAO+b5-o+-JF61a+8vFWj1rxMuVWuG-CVLQKorr5cKzi-Kc44Ag@mail.gmail.com>
	<1324333931.7043.52.camel@lap75545.ornl.gov>
	<CAO+b5-r4AZymMkVyFSXbBzpcc86hL0RJm2j3FnT3=uXSLUkj9A@mail.gmail.com>
	<1324436736.7621.38.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324436736.7621.38.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 21, 2011 at 3:05 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> We don't want to leave a target blocked indefinitely -- commands caught
> in the blocked queue won't be reissued until the queue is unblocked --
> but we may want to keep the sdX mappings around for a long time.
> fast_io_fail_tmo gives us the ability to do that -- the expiration of
> fast_io_fail_tmo unblocks the queue and allows commands to be failed due
> to the transport error. See commit f2818663.

Our opinions may differ here. My opinion is that for some use cases it
is crucial to be able to block a target indefinitely, e.g. when there
is only a single path between initiator and target and when the user
prefers that I/O blocks instead of encountering I/O errors. See e.g.
the "iSCSI settings for iSCSI root" section in the iSCSI README
(http://www.open-iscsi.org/docs/README).

Regarding commit f2818663: as far as I can see what that commit does
is to make it impossible for a user to set fast_io_fail_tmo == -1
together with dev_loss_tmo > SCSI_DEVICE_BLOCK_MAX_TIMEOUT. That
change is specific to the FC code - only the FC transport code limits
the blocked state time to the SCSI_DEVICE_BLOCK_MAX_TIMEOUT limit.

> Also, these settings can be used to help tune multipath failover for
> devices with relatively long LUN transfer times (say with RDAC) vs short
> ones (ALUA). You still don't want the mappings to go away, but you want
> to move data to the other paths in a reasonably quick fashion.
> http://lkml.org/lkml/2008/1/7/244 talks about this a bit.

In a multipath setup the ping_interval, ping_timeout, recovery_tmo and
max_reconnects parameters (all added via this patch series) should be
sufficient to allow control over how quickly multipath failover
happens.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
