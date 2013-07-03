From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 07/13] scsi_transport_srp: Add transport layer error
 handling
Date: Wed, 3 Jul 2013 16:41:07 -0700
Message-ID: <51D4B693.7070200@mellanox.com>
References: <51D41C03.4020607@acm.org> <51D41F13.6060203@acm.org>	  <1372864458.24238.32.camel@frustration.ornl.gov>	 <51D44A86.5050000@acm.org> <1372872474.24238.43.camel@frustration.ornl.gov>	 <51D46C54.8060101@acm.org> <1372877861.24238.64.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372877861.24238.64.camel-zHLflQxYYDO4Hhoo1DtQwJ9G+ZOsUmrO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

David Dillow wrote:
> On Wed, 2013-07-03 at 20:24 +0200, Bart Van Assche wrote:
>   
>> On 07/03/13 19:27, David Dillow wrote:
>>     
>>> On Wed, 2013-07-03 at 18:00 +0200, Bart Van Assche wrote:
>>>       
>>>> The combination of dev_loss_tmo off and reconnect_delay > 0 worked fine
>>>> in my tests. An I/O failure was detected shortly after the cable to the
>>>> target was pulled. I/O resumed shortly after the cable to the target was
>>>> reinserted.
>>>>         
>>> Perhaps I don't understand your answer -- I'm asking about dev_loss_tmo
>>> < 0, and fast_io_fail_tmo >= 0. The other transports do not allow this
>>> scenario, and I'm asking if it makes sense for SRP to allow it.
>>>
>>> But now that you mention reconnect_delay, what is the meaning of that
>>> when it is negative? That's not in the documentation. And should it be
>>> considered in srp_tmo_valid() -- are there values of reconnect_delay
>>> that cause problems?
>>>       
>> None of the combinations that can be configured from user space can 
>> bring the kernel in trouble. If reconnect_delay <= 0 that means that the 
>> time-based reconnect mechanism is disabled.
>>     
>
> Then it should use the same semantics as the other attributes, and have
> the user store "off" to turn it off.
>
> And I'm getting the strong sense that the answer to my question about
> fast_io_fail_tmo >= 0 when dev_loss_tmo is that we should not allow that
> combination, even if it doesn't break the kernel. If it doesn't make
> sense, there is no reason to create an opportunity for user confusion.
>   
Hello Dave,

when dev_loss_tmo expired, srp not only removes the rport but also 
removes the associated scsi_host.
One may wish to set fast_io_fail_tmo >=0 for I/Os to fail-over fast to 
other paths, and dev_loss_tmo off to keep the scsi_host around until the 
target coming back.

-vu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
