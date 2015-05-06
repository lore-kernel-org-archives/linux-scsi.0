From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 04/12] IB/srp: Fix connection state tracking
Date: Wed, 6 May 2015 11:29:16 +0200
Message-ID: <5549DEEC.9050501@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EE9F.8090605@sandisk.com>
	 <1430410094.102408.71.camel@redhat.com> <55488BAE.7070006@sandisk.com>
	 <1430835029.2407.187.camel@redhat.com> <5548D2FF.7030501@sandisk.com>
	 <1430838637.2407.209.camel@redhat.com> <5548E155.70007@sandisk.com>
 <1430842201.2407.226.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430842201.2407.226.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello Doug,

On 05/05/15 18:10, Doug Ledford wrote:
> Be that as it may, that doesn't change what I said about posting a
> command to a known disconnected QP.  You could just fail immediately.
> Something like:
>
> if (!ch->connected) {
> 	scmnd->result = DID_NO_CONNECT;
> 	goto err;
> }
>
> right after getting the channel in queuecommand would work.  That would
> save a couple spinlocks, several DMA mappings, a call into the low level
> driver, and a few other things.  (And I only left requeue on the table
> because I wasn't sure how the blk_mq dealt with just a single channel
> being down versus all of them being down)

What you wrote above looks correct to me. However, it is intentional 
that such a check is not present in srp_queuecommand(). The intention 
was to optimize the hot path of that driver as much as possible. Hence 
the choice to post a work request on the QP even after it has been 
disconnected and to let the HCA generate an error completion.

> But my point in all of this is that if you have a single qp between
> yourself and the target, then any error including a qp resource error ==
> path error since you only have one path.  When you have a multi queue
> device, that's no longer true.  A transient resource problem on one qp
> does not mean a path event (at least not necessarily, although your
> statement below converts a QP event into a path event by virtue
> disconnecting and reconnecting all of the QPs).  My curiosity is now
> moot given what you wrote about tearing everything down and reconnecting
> (unless the error handling is modified to be more subtle in its
> workings), but the original question in my mind was what happens at the
> blk_mq level if you did have a single queue drop but not all of them and
> you weren't using multipath.

If we want to support this without adding similar code to handle this in 
every SCSI LLD I think we need to change first how blk-mq and 
dm-multipath interact. Today dm-multipath is a layer on top of blk-mq. 
Supporting the above scenario properly is possible e.g. by integrating 
multipath support in the blk-mq layer. I think Hannes and Christoph have 
already started to work on this.

>> If only one channel fails all other channels are disconnected and the
>> transport layer error handling mechanism is started.
>
> I missed that.  I assume it's done in srp_start_tl_fail_timers()?

Yes, that's correct. Both QP errors and reception of a DREQ trigger a 
call of srp_tl_err_work(). That last function calls 
srp_start_tl_fail_timers() which starts the reconnection mechanism, at 
least if the reconnect_delay parameter has a positive value (> 0).

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
