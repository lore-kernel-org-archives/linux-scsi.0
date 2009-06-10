From: "Styner, Douglas W" <douglas.w.styner@intel.com>
Subject: RE: [PATCH] qla2xxx: Resolved a performance issue in interrupt
 handler
Date: Wed, 10 Jun 2009 08:52:36 -0700
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A26035402F1C0@azsmsx501.amr.corp.intel.com>
References: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local>
 <1244575944.12321.58.camel@mulgrave.site>
 <19C9538E-B7B2-4924-859F-37E56660D95E@qlogic.com>
 <1244580029.12321.138.camel@mulgrave.site>
 <alpine.OSX.1.00.0906091436120.4405@ac-mac.local>
 <D7C42C27E6CB1E4D8CBDF2F81EA92A26035402EBA0@azsmsx501.amr.corp.intel.com>
 <2796FDDF-31EA-44E2-8856-84A22F31A01F@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55673 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759429AbZFJPwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 11:52:37 -0400
In-Reply-To: <2796FDDF-31EA-44E2-8856-84A22F31A01F@qlogic.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "Ma, Chinang" <chinang.ma@intel.com>, "Prickett, Terry O" <terry.o.prickett@intel.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>


Anirban Chakraborty [mailto:anirban.chakraborty@qlogic.com] write:
>
>You got it right. Basically we are doing:
>1. baseline scsi-misc + earlier patch
>2. baseline scsi-misc + this patch
>And then compare 1 and 2.

Results are as follows:
Total interrupts are down slightly (-0.8%), QLA interrupts are flat (-0.1%) Cycles for qla2xxx_intr_handler up from .77% to .92%.

Linux OLTP Performance summary
Kernel#                   Speedup(x)   Intr/s  CtxSw/s us%   sy%   id%  wa%
2.6.30-rc6_scsi-misc_0001      1.000   29538   43374   75    25     0    0
2.6.30-rc6_scsi-misc_irqf-d    1.000   29286   43125   74    25     0    1

Server configurations:
Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)


======oprofile CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.30-rc6_scsi-misc_0001   Cycles% 2.6.30-rc6_scsi-misc_irqf-d
68.1402 <database>                  66.1875 <database>
0.9125 qla24xx_start_scsi            0.9552 qla24xx_start_scsi
0.8729 __schedule                    0.9272 __schedule
0.7739 qla24xx_intr_handler          0.9178 qla24xx_intr_handler
0.7161 kmem_cache_alloc              0.7963 kmem_cache_alloc
0.4686 __sigsetjmp                   0.4580 __sigsetjmp
0.4043 __blockdev_direct_IO          0.4206 __switch_to
0.3894 __switch_to                   0.4169 __blockdev_direct_IO
0.3878 rb_get_reader_page            0.3907 scsi_request_fn
0.3762 task_rq_lock                  0.3776 task_rq_lock
0.3729 scsi_request_fn               0.3701 rb_get_reader_page
0.3696 __list_add                    0.3664 __list_add
0.3168 <bash>                        0.3664 copy_user_generic_string
0.3135 try_to_wake_up                0.3122 lock_timer_base
0.2921 ring_buffer_consume           0.2972 ring_buffer_consume
0.2822 lock_timer_base               0.2879 <bash>
0.2624 memset_c                      0.2785 aio_complete
0.2607 aio_complete                  0.2524 blk_queue_end_tag
0.2508 copy_user_generic_string      0.2468 try_to_wake_up
0.2294 qla2x00_process_completed_re  0.2430 tcp_sendmsg
0.2294 tcp_sendmsg                   0.2393 mod_timer
0.2211 kfree                         0.2374 qla2x00_process_completed_re
0.2195 memmove                       0.2355 memset_c
0.2195 blk_queue_end_tag             0.2225 e1000_xmit_frame
0.2145 scsi_softirq_done             0.2094 generic_make_request
0.2145 mod_timer                     0.2075 scsi_device_unbusy
0.2129 generic_file_aio_read         0.2056 kref_get
0.2096 kref_get                      0.2056 mempool_free
0.1997 e1000_xmit_frame              0.2038 qla2xxx_queuecommand
0.1997 scsi_device_unbusy            0.2000 kfree
