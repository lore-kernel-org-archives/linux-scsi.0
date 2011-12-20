From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 12/14] ib_srp: Rework error handling
Date: Tue, 20 Dec 2011 09:01:49 +0000
Message-ID: <CAO+b5-qF2taG0B4n9SBwqnuh0wajH5fXFLTb-VAaDrfT9TZ6aQ@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012010.37276.bvanassche@acm.org>
	<1324265791.17849.92.camel@obelisk.thedillows.org>
	<CAO+b5-q332RKkLrUV7X_D73SHBrLpt=6Xz=W7ZtOwZ+9iSOyDw@mail.gmail.com>
	<1324335083.7043.66.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324335083.7043.66.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 19, 2011 at 10:51 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> I haven't parsed it all out from your changes just yet, but I think part
> of the reason you may have had problems with req->scmd being null in
> srp_handle_recv() is due to a new race between the tear down of the
> connection and continuing to process completion notifications.

The resources used by the QP completion handler are the srp_target
port data structure and the QP data structure. And as you can see in
srp_remove_target(), the scsi_host_put() call is invoked after
srp_disconnect_target(). That last function waits for the DREP
notification from the IB CM. That should guarantee that no IB
completions arrive during or after the scsi_host_put() call. Or did I
miss something ?

Note: I haven't observed the req->scmd == NULL condition yet.

> > > You lock and unlock here without doing anything in the critical section.
> >
> > That's on purpose.
>
> I'm assuming you do this to ensure that everyone has seen the
> appropriate state and exited the critical section, then? Best to add a
> comment to that effect.

OK, will do.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
