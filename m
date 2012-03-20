From: Stanislaw Gruszka <sgruszka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Tue, 20 Mar 2012 15:21:10 +0100
Message-ID: <20120320142109.GA3693@redhat.com>
References: <4F65E09D.6010600@acm.org>
 <20120318155703.GB8045@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F663BE3.4000503@acm.org>
 <20120319072656.GB2251@redhat.com>
 <4F6766F0.1070805@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F6766F0.1070805-HInyCGIudOg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 19, 2012 at 05:03:44PM +0000, Bart Van Assche wrote:
> On 03/19/12 07:26, Stanislaw Gruszka wrote:
> > On Sun, Mar 18, 2012 at 07:47:47PM +0000, Bart Van Assche wrote:
> >> On 03/18/12 15:57, Tejun Heo wrote:
> >>> On Sun, Mar 18, 2012 at 01:18:21PM +0000, Bart Van Assche wrote:
> >>>> All queued requests must be processed eventually. Hence make sure
> >>>> that blk_drain_queue() drains the queue even if the queue is in the
> >>>> stopped state. This patch makes it safe to invoke blk_cleanup_queue()
> >>>> on a stopped queue.
> >>> ...
> >>>> diff --git a/block/blk-core.c b/block/blk-core.c
> >>>> index 3a78b00..bdcec86 100644
> >>>> --- a/block/blk-core.c
> >>>> +++ b/block/blk-core.c
> >>>> @@ -300,10 +300,8 @@ EXPORT_SYMBOL(blk_sync_queue);
> >>>>   */
> >>>>  void __blk_run_queue(struct request_queue *q)
> >>>>  {
> >>>> -	if (unlikely(blk_queue_stopped(q)))
> >>>> -		return;
> >>>> -
> >>>> -	q->request_fn(q);
> >>>> +	if (!blk_queue_stopped(q) || blk_queue_dead(q))
> >>>> +		q->request_fn(q);
> > I'm not sure if that behaviour is correct, i.e. we can call q->request_fn(q)
> > if someone stoped queue, but if it is why not just call q->request_fn(q)
> > from blk_drain_queue() instead?
> 
> As far as I can see invoking q->request_fn(q) directly from
> blk_drain_queue() would be a valid alternative.
> 
> >
> >>> So, this allows calling request_fn for dead && stopped queue.  Have
> >>> you seen something which requires this?
> >> Not servicing queued SCSI requests can e.g. cause user space processes
> >> to hang. See also http://lkml.org/lkml/2011/8/27/6 for an example. Hence
> >> commit 3308511c93e6ad0d3c58984ecd6e5e57f96b12c8 which causes pending
> >> SCSI commands to be killed just before blk_cleanup_queue() is invoked.
> >> However, there is still a tiny race window left by that patch - new
> >> requests can get queued after the SCSI request function has been invoked
> >> by scsi_free_queue() and before blk_cleanup_queue() gets invoked. Hence
> >> the proposal to change the block layer to make sure that all queued
> >> requests get processed eventually.
> > That behaviour I can confirm using this script [1] running with usb
> > dongle. I applied this patch and second one:
> > http://marc.info/?l=linux-scsi&m=133207725114386&w=2
> > (BTW: second one patch is mangled). My impression is, that the script run
> > much longer before it finally hung at infinite loop in blk_drain_queue().
> 
> I'm not an USB expert but I've had a quick look at
> usb_stor_release_resources() in drivers/usb/storage/usb.c. As far as I
> can see that function will only stop the usb_stor_control_thread() if
> that thread has been scheduled after the last complete() call by the USB
> queuecommand() function and before the complete() call in
> usb_stor_release_resources() is executed. That looks like a race
> condition to me.

CCing linux-usb, perhaps usb developers would like to take a look.

Stanislaw
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
