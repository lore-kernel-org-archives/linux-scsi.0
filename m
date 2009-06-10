From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt
	handler
Date: Wed, 10 Jun 2009 10:18:28 -0600
Message-ID: <20090610161828.GT3274@parisc-linux.org>
References: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local> <1244575944.12321.58.camel@mulgrave.site> <19C9538E-B7B2-4924-859F-37E56660D95E@qlogic.com> <1244580029.12321.138.camel@mulgrave.site> <alpine.OSX.1.00.0906091436120.4405@ac-mac.local> <D7C42C27E6CB1E4D8CBDF2F81EA92A26035402EBA0@azsmsx501.amr.corp.intel.com> <2796FDDF-31EA-44E2-8856-84A22F31A01F@qlogic.com> <D7C42C27E6CB1E4D8CBDF2F81EA92A26035402F1C0@azsmsx501.amr.corp.intel.com> <38D5FA1B-4CCC-46FB-8793-4131AF6AAD05@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39652 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZFJQS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 12:18:26 -0400
Content-Disposition: inline
In-Reply-To: <38D5FA1B-4CCC-46FB-8793-4131AF6AAD05@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: "Styner, Douglas W" <douglas.w.styner@intel.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "Ma, Chinang" <chinang.ma@intel.com>, "Prickett, Terry O" <terry.o.prickett@intel.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>

On Wed, Jun 10, 2009 at 09:09:14AM -0700, Anirban Chakraborty wrote:
>
> On Jun 10, 2009, at 8:52 AM, Styner, Douglas W wrote:
>
>>
>> Anirban Chakraborty [mailto:anirban.chakraborty@qlogic.com] write:
>>>
>>> You got it right. Basically we are doing:
>>> 1. baseline scsi-misc + earlier patch
>>> 2. baseline scsi-misc + this patch
>>> And then compare 1 and 2.
>>
>> Results are as follows:
>> Total interrupts are down slightly (-0.8%), QLA interrupts are flat  
>> (-0.1%) Cycles for qla2xxx_intr_handler up from .77% to .92%.
>
> So, it looks like using spin_lock_irqsave is doing a better job than  
> globally disabling the sharing of the interrupt via IRQF_DISABLED.

The margin of error for this setup is about 0.3% for the performance
as a whole.  I don't know what the margin of error is for the number
of cycles consumed by a given function, but I would suspect it's
significantly higher than the 0.15% difference seen.

>> ======oprofile CPU_CLK_UNHALTED for top 30 functions
>> Cycles% 2.6.30-rc6_scsi-misc_0001   Cycles% 2.6.30-rc6_scsi-misc_irqf-d
>> 68.1402 <database>                  66.1875 <database>
>> 0.9125 qla24xx_start_scsi            0.9552 qla24xx_start_scsi
>> 0.8729 __schedule                    0.9272 __schedule
>> 0.7739 qla24xx_intr_handler          0.9178 qla24xx_intr_handler
>> 0.7161 kmem_cache_alloc              0.7963 kmem_cache_alloc
>> 0.4686 __sigsetjmp                   0.4580 __sigsetjmp
>> 0.4043 __blockdev_direct_IO          0.4206 __switch_to
>> 0.3894 __switch_to                   0.4169 __blockdev_direct_IO
>> 0.3878 rb_get_reader_page            0.3907 scsi_request_fn
>> 0.3762 task_rq_lock                  0.3776 task_rq_lock
>> 0.3729 scsi_request_fn               0.3701 rb_get_reader_page
>> 0.3696 __list_add                    0.3664 __list_add
>> 0.3168 <bash>                        0.3664 copy_user_generic_string
>> 0.3135 try_to_wake_up                0.3122 lock_timer_base
>> 0.2921 ring_buffer_consume           0.2972 ring_buffer_consume
>> 0.2822 lock_timer_base               0.2879 <bash>
>> 0.2624 memset_c                      0.2785 aio_complete
>> 0.2607 aio_complete                  0.2524 blk_queue_end_tag
>> 0.2508 copy_user_generic_string      0.2468 try_to_wake_up
>> 0.2294 qla2x00_process_completed_re  0.2430 tcp_sendmsg
>> 0.2294 tcp_sendmsg                   0.2393 mod_timer
>> 0.2211 kfree                         0.2374 qla2x00_process_completed_re
>> 0.2195 memmove                       0.2355 memset_c
>> 0.2195 blk_queue_end_tag             0.2225 e1000_xmit_frame
>> 0.2145 scsi_softirq_done             0.2094 generic_make_request
>> 0.2145 mod_timer                     0.2075 scsi_device_unbusy
>> 0.2129 generic_file_aio_read         0.2056 kref_get
>> 0.2096 kref_get                      0.2056 mempool_free
>> 0.1997 e1000_xmit_frame              0.2038 qla2xxx_queuecommand
>> 0.1997 scsi_device_unbusy            0.2000 kfree
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
