From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 12/14] ib_srp: Rework error handling
Date: Tue, 20 Dec 2011 22:33:07 -0500
Message-ID: <1324438387.7621.53.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012010.37276.bvanassche@acm.org>
	 <1324265791.17849.92.camel@obelisk.thedillows.org>
	 <CAO+b5-q332RKkLrUV7X_D73SHBrLpt=6Xz=W7ZtOwZ+9iSOyDw@mail.gmail.com>
	 <1324335083.7043.66.camel@lap75545.ornl.gov>
	 <CAO+b5-qF2taG0B4n9SBwqnuh0wajH5fXFLTb-VAaDrfT9TZ6aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-qF2taG0B4n9SBwqnuh0wajH5fXFLTb-VAaDrfT9TZ6aQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-12-20 at 09:01 +0000, Bart Van Assche wrote:
> On Mon, Dec 19, 2011 at 10:51 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > I haven't parsed it all out from your changes just yet, but I think part
> > of the reason you may have had problems with req->scmd being null in
> > srp_handle_recv() is due to a new race between the tear down of the
> > connection and continuing to process completion notifications.
> 
> The resources used by the QP completion handler are the srp_target
> port data structure and the QP data structure. And as you can see in
> srp_remove_target(), the scsi_host_put() call is invoked after
> srp_disconnect_target(). That last function waits for the DREP
> notification from the IB CM. That should guarantee that no IB
> completions arrive during or after the scsi_host_put() call. Or did I
> miss something ?

What keeps the srp_recv_completion() --> srp_handle_recv() -->
srp_process_rsp() --> etc. call chain from racing with
srp_reconnect_target()?

It looks like the srp_reset_req() in srp_reconnect_tartget() could race
with srp_process_rsp() if receive completions continue to be processed
after a send failure, but perhaps it is I who is missing something.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
