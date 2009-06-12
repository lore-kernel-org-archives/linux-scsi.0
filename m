From: "Styner, Douglas W" <douglas.w.styner@intel.com>
Subject: RE: [PATCH] qla2xxx: Resolved a performance issue in interrupt -
 this time with data
Date: Fri, 12 Jun 2009 15:52:04 -0700
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A260354169381@azsmsx501.amr.corp.intel.com>
References: <B8134F80-B547-4E04-890A-6B646D2BA3E8@qlogic.com>
  <20080911201140.GM2772@parisc-linux.org>
  <20090610183259.GI89096@n6013ncj7y1lh1.qlogic.org>
 <1244661018.17432.21.camel@mulgrave.site>
 <alpine.OSX.1.00.0906101349480.5521@ac-mac.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12728 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764390AbZFLWwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 18:52:06 -0400
In-Reply-To: <alpine.OSX.1.00.0906101349480.5521@ac-mac.local>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, David Wagner <david.wagner@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "Ma, Chinang" <chinang.ma@intel.com>, "Prickett, Terry O" <terry.o.prickett@intel.com>

Anirban Chakraborty [mailto:anirban.chakraborty@qlogic.com] writes:
>
>This is the updated patch. Please apply.

Performance results from this patch compared to 2.6.30-rc6_scsi-misc.

Linux OLTP Performance summary
Kernel#            Speedup(x)   Intr/s  CtxSw/s us%    sys%   idle%  iowait%
scsi-misc               1.000   29481   43570   74      25      0       0
scsi-misc_qla-irqsave   1.004   29471   43290   75      25      0       0

Server configurations:
Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)


======oprofile CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.30-rc6_scsi-misc       Cycles% 2.6.30-rc6_scsi-misc_qla-irqsave
67.3266 <database>                 66.6218 <database>
1.0062 qla24xx_start_scsi          1.0247 qla24xx_start_scsi
0.9246 qla24xx_intr_handler        0.9731 qla24xx_intr_handler
0.8158 __schedule                  0.8588 kmem_cache_alloc
0.7469 kmem_cache_alloc            0.8515 __schedule
0.4188 __blockdev_direct_IO        0.4663 __sigsetjmp
0.4097 __sigsetjmp                 0.4331 __blockdev_direct_IO
0.3989 scsi_request_fn             0.3852 scsi_request_fn
0.3916 __switch_to                 0.3852 task_rq_lock
0.3717 __list_add                  0.3612 rb_get_reader_page
0.3499 task_rq_lock                0.3336 __switch_to
0.3408 try_to_wake_up              0.3336 ring_buffer_consume
0.3281 aio_complete                0.3299 copy_user_generic_string
0.3281 rb_get_reader_page          0.3262 __list_add
0.3227 ring_buffer_consume         0.3262 lock_timer_base
0.2901 copy_user_generic_string    0.3225 try_to_wake_up
0.2883 <bash>                      0.3059 aio_complete
0.2611 blk_queue_end_tag           0.2783 mod_timer
0.2611 memset_c                    0.2488 kmem_cache_free
0.2448 kmem_cache_free             0.2451 blk_queue_end_tag
0.2357 qla2x00_process_completed_re0.2451 tcp_sendmsg
0.2321 lock_timer_base             0.2396 <bash>
0.2321 mod_timer                   0.2359 kref_get
0.2230 kfree                       0.2359 memset_c
0.2230 tcp_sendmsg                 0.2304 qla2x00_process_completed_re
0.2176 generic_make_request        0.2285 memmove
0.2085 scsi_dispatch_cmd           0.2285 mempool_free
0.2085 kref_get                    0.2248 generic_make_request
0.2085 sched_clock_cpu             0.2156 sched_clock_cpu
0.2067 scsi_device_unbusy          0.2119 e1000_xmit_frame
