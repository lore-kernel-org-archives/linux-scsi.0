From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt - this time with data
Date: Fri, 12 Jun 2009 16:32:55 -0700
Message-ID: <3472FAB3-C668-47C9-A942-ABE1E305DCA1@qlogic.com>
References: <B8134F80-B547-4E04-890A-6B646D2BA3E8@qlogic.com> <20080911201140.GM2772@parisc-linux.org> <20090610183259.GI89096@n6013ncj7y1lh1.qlogic.org> <1244661018.17432.21.camel@mulgrave.site> <alpine.OSX.1.00.0906101349480.5521@ac-mac.local> <D7C42C27E6CB1E4D8CBDF2F81EA92A260354169381@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8323 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZFLXcy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 19:32:54 -0400
In-Reply-To: <D7C42C27E6CB1E4D8CBDF2F81EA92A260354169381@azsmsx501.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Styner, Douglas W" <douglas.w.styner@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, David Wagner <david.wagner@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "Ma, Chinang" <chinang.ma@intel.com>, "Prickett, Terry O" <terry.o.prickett@intel.com>


On Jun 12, 2009, at 3:52 PM, Styner, Douglas W wrote:

> Anirban Chakraborty [mailto:anirban.chakraborty@qlogic.com] writes:
>>
>> This is the updated patch. Please apply.
>
> Performance results from this patch compared to 2.6.30-rc6_scsi-misc.
>
> Linux OLTP Performance summary
> Kernel#            Speedup(x)   Intr/s  CtxSw/s us%    sys%   idle%   
> iowait%
> scsi-misc               1.000   29481   43570   74      25       
> 0       0
> scsi-misc_qla-irqsave   1.004   29471   43290   75      25       
> 0       0
>
> Server configurations:
> Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
> 64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)
>
>
> ======oprofile CPU_CLK_UNHALTED for top 30 functions
> Cycles% 2.6.30-rc6_scsi-misc       Cycles% 2.6.30-rc6_scsi-misc_qla- 
> irqsave
> 67.3266 <database>                 66.6218 <database>
> 1.0062 qla24xx_start_scsi          1.0247 qla24xx_start_scsi
> 0.9246 qla24xx_intr_handler        0.9731 qla24xx_intr_handler
> 0.8158 __schedule                  0.8588 kmem_cache_alloc
> 0.7469 kmem_cache_alloc            0.8515 __schedule
> 0.4188 __blockdev_direct_IO        0.4663 __sigsetjmp
> 0.4097 __sigsetjmp                 0.4331 __blockdev_direct_IO
> 0.3989 scsi_request_fn             0.3852 scsi_request_fn
> 0.3916 __switch_to                 0.3852 task_rq_lock
> 0.3717 __list_add                  0.3612 rb_get_reader_page
> 0.3499 task_rq_lock                0.3336 __switch_to
> 0.3408 try_to_wake_up              0.3336 ring_buffer_consume
> 0.3281 aio_complete                0.3299 copy_user_generic_string
> 0.3281 rb_get_reader_page          0.3262 __list_add
> 0.3227 ring_buffer_consume         0.3262 lock_timer_base
> 0.2901 copy_user_generic_string    0.3225 try_to_wake_up
> 0.2883 <bash>                      0.3059 aio_complete
> 0.2611 blk_queue_end_tag           0.2783 mod_timer
> 0.2611 memset_c                    0.2488 kmem_cache_free
> 0.2448 kmem_cache_free             0.2451 blk_queue_end_tag
> 0.2357 qla2x00_process_completed_re0.2451 tcp_sendmsg
> 0.2321 lock_timer_base             0.2396 <bash>
> 0.2321 mod_timer                   0.2359 kref_get
> 0.2230 kfree                       0.2359 memset_c
> 0.2230 tcp_sendmsg                 0.2304 qla2x00_process_completed_re
> 0.2176 generic_make_request        0.2285 memmove
> 0.2085 scsi_dispatch_cmd           0.2285 mempool_free
> 0.2085 kref_get                    0.2248 generic_make_request
> 0.2085 sched_clock_cpu             0.2156 sched_clock_cpu
> 0.2067 scsi_device_unbusy          0.2119 e1000_xmit_frame

So, the data that you posted validated earlier didn't match with this  
run.
I did a similar testing several times before I posted the patch. Maybe  
I should share that data here.

Sever: Intel Xeon X7350, 4 core, 16GB memory, 2 dual port qla2432 and  
1 single port qla2432 (total 5 controllers).
Target: EMC Clarion (100+ luns per target, total no. of luns 512).
IO pumping tool: Orion with cold cache setting. Two Orion procs  
running each pumping to 256 devices.
Profiling tool: vtune.

And my results are as follows:

2.6.30-rc6 (without the patch)
function                                CPU_CLK_UNHALTED.CORE_P
qla24xx_intr_handler            1.18
qla2x00_process_completed_requ  0.18
qla24xx_start_scsi              0.15
qla24xx_process_response_queue  0.12
qla2xxx_queuecommand            0.06
qla2x00_sp_compl                0.06
qla2x00_status_entry            0.02
qla2x00_async_event             0.01

and 2.6.30-rc6 (with the irqsave patch)
function                        CPU_CLK_UNHALTED.CORE_P
qla24xx_start_scsi              0.11
qla2xxx_queuecommand            0.06
qla24xx_intr_handler            0.01
qla2x00_timer                   0.00

The difference in qla24xx_intr_handler is significant in my setup.

Thanks,
Anirban

