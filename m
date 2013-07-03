From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v3 07/13] scsi_transport_srp: Add transport layer error
 handling
Date: Wed, 03 Jul 2013 20:24:20 +0200
Message-ID: <51D46C54.8060101@acm.org>
References: <51D41C03.4020607@acm.org> <51D41F13.6060203@acm.org>  <1372864458.24238.32.camel@frustration.ornl.gov> <51D44A86.5050000@acm.org> <1372872474.24238.43.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372872474.24238.43.camel-zHLflQxYYDO4Hhoo1DtQwJ9G+ZOsUmrO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 07/03/13 19:27, David Dillow wrote:
> On Wed, 2013-07-03 at 18:00 +0200, Bart Van Assche wrote:
>> The combination of dev_loss_tmo off and reconnect_delay > 0 worked fine
>> in my tests. An I/O failure was detected shortly after the cable to the
>> target was pulled. I/O resumed shortly after the cable to the target was
>> reinserted.
>
> Perhaps I don't understand your answer -- I'm asking about dev_loss_tmo
> < 0, and fast_io_fail_tmo >= 0. The other transports do not allow this
> scenario, and I'm asking if it makes sense for SRP to allow it.
>
> But now that you mention reconnect_delay, what is the meaning of that
> when it is negative? That's not in the documentation. And should it be
> considered in srp_tmo_valid() -- are there values of reconnect_delay
> that cause problems?

None of the combinations that can be configured from user space can 
bring the kernel in trouble. If reconnect_delay <= 0 that means that the 
time-based reconnect mechanism is disabled.

> I'm starting to get a bit concerned about this patch -- can you, Vu, and
> Sebastian comment on the testing you have done?

All combinations of reconnect_delay, fast_io_fail_tmo and dev_loss_tmo 
that result in different behavior have been tested.

>>> Also, FC caps dev_loss_tmo at SCSI_DEVICE_BLOCK_MAX_TIMEOUT if
>>> fail_io_fast_tmo is off; I agree with your reasoning about leaving it
>>> unlimited if fast fail is on, but does that still hold if it is off?
>>
>> I think setting dev_loss_tmo to a large value only makes sense if the
>> value of reconnect_delay is not too large. Setting both to a large value
>> would result in slow recovery after a transport layer failure has been
>> corrected.
>
> So you agree it should be capped? I can't tell from your response.

Not all combinations of reconnect_delay / fail_io_fast_tmo / 
dev_loss_tmo result in useful behavior. It is up to the user to choose a 
meaningful combination.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
