From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v3 07/13] scsi_transport_srp: Add transport layer error
 handling
Date: Wed, 03 Jul 2013 13:27:54 -0400
Message-ID: <1372872474.24238.43.camel@frustration.ornl.gov>
References: <51D41C03.4020607@acm.org> <51D41F13.6060203@acm.org>
	 <1372864458.24238.32.camel@frustration.ornl.gov> <51D44A86.5050000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51D44A86.5050000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-07-03 at 18:00 +0200, Bart Van Assche wrote:
> On 07/03/13 17:14, David Dillow wrote:
> > On Wed, 2013-07-03 at 14:54 +0200, Bart Van Assche wrote:
> >> +int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
> >> +{
> >> +	return (fast_io_fail_tmo < 0 || dev_loss_tmo < 0 ||
> >> +		fast_io_fail_tmo < dev_loss_tmo) &&
> >> +		fast_io_fail_tmo <= SCSI_DEVICE_BLOCK_MAX_TIMEOUT &&
> >> +		dev_loss_tmo < LONG_MAX / HZ ? 0 : -EINVAL;
> >> +}
> >> +EXPORT_SYMBOL_GPL(srp_tmo_valid);
> >
> > This would have been more readable:
> >
> > int srp_tmo_valid(int fast_io_fail_tmp, int dev_loss_tmo)
> > {
> > 	/* Fast IO fail must be off, or no greater than the max timeout */
> > 	if (fast_io_fail_tmo > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
> > 		return -EINVAL;
> >
> > 	/* Device timeout must be off, or fit into jiffies */
> > 	if (dev_loss_tmo >= LONG_MAX / HZ)
> > 		return -EINVAL;
> >
> > 	/* Fast IO must trigger before device loss, or one of the
> > 	 * timeouts must be disabled.
> > 	 */
> > 	if (fast_io_fail_tmo < 0 || dev_loss_tmo < 0)
> > 		return 0;
> > 	if (fast_io_fail < dev_loss_tmo)
> > 		return 0;
> >
> > 	return -EINVAL;	
> > }
> 
> Isn't that a matter of personal taste which of the above two is more 
> clear ?

No, it is quite common in Linux for complicated conditionals to be
broken up into helper functions, and Vu found logic bugs in previous
iterations. After unpacking it, I still found behavior that is
questionable. All of this strongly points to that block being too dense
for its own good.

> It might also depend on the number of mathematics courses in 
> someones educational background :-)

Or the number of logic courses, or their experience with Lisp. :)

> > Though, now that I've unpacked it -- I don't think it is OK for
> > dev_loss_tmo to be off, but fast IO to be on? That drops another
> > conditional.
> 
> The combination of dev_loss_tmo off and reconnect_delay > 0 worked fine 
> in my tests. An I/O failure was detected shortly after the cable to the 
> target was pulled. I/O resumed shortly after the cable to the target was 
> reinserted.

Perhaps I don't understand your answer -- I'm asking about dev_loss_tmo
< 0, and fast_io_fail_tmo >= 0. The other transports do not allow this
scenario, and I'm asking if it makes sense for SRP to allow it.

But now that you mention reconnect_delay, what is the meaning of that
when it is negative? That's not in the documentation. And should it be
considered in srp_tmo_valid() -- are there values of reconnect_delay
that cause problems?

I'm starting to get a bit concerned about this patch -- can you, Vu, and
Sebastian comment on the testing you have done?

> > Also, FC caps dev_loss_tmo at SCSI_DEVICE_BLOCK_MAX_TIMEOUT if
> > fail_io_fast_tmo is off; I agree with your reasoning about leaving it
> > unlimited if fast fail is on, but does that still hold if it is off?
> 
> I think setting dev_loss_tmo to a large value only makes sense if the 
> value of reconnect_delay is not too large. Setting both to a large value 
> would result in slow recovery after a transport layer failure has been 
> corrected.

So you agree it should be capped? I can't tell from your response.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
