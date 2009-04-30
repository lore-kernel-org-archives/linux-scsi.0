From: "Styner, Douglas W" <douglas.w.styner@intel.com>
Subject: RE: [PATCH] qla2xxx: Fix a regression due to refactoring in
 interrupt handler code
Date: Thu, 30 Apr 2009 12:22:13 -0700
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345AD5C03@azsmsx501.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F44B4@azsmsx501.amr.corp.intel.com>
 <C61D3444.E384%anirban.chakraborty@qlogic.com>
 <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A63FE0@azsmsx501.amr.corp.intel.com>
 <C03D50D6-2441-4AE3-9AD2-24037612BF1C@qlogic.com>
 <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A643F9@azsmsx501.amr.corp.intel.com>
 <453B218D-08A2-4C95-8799-46B9B88A6373@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55056 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbZD3TWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2009 15:22:15 -0400
In-Reply-To: <453B218D-08A2-4C95-8799-46B9B88A6373@qlogic.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: "andi@firstfloor.org" <andi@firstfloor.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Driver <Linux-Driver@qlogic.com>, "Ma, Chinang" <chinang.ma@intel.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "willy@linux.intel.com" <willy@linux.intel.com>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>

Anirban Chakraborty <anirban.chakraborty@qlogic.com> writes:
> Can you please try the attached patch? 
Yes, results below.

> Also, what f/w version are you running with? 
[root@linux-srv2 ~]# cat /sys/class/scsi_host/host23/fw_version
4.00.27 (82)

> What tool are you using to generate the load?
Industry-standard OLTP benchmark from tpc.org (vendor proprietary database).
-----------------
Summary: Measured performance impact of perf.patch

No impact on throughput, interrupts or cpu usage.  Take oprofile data with a grain of sand; notice 3% drop in cycles for <database> with no change in vmstat cpu utilization (oprofile accuracy is the subject of another thread). 

Linux OLTP Performance summary
Kernel#            Speedup(x)   Intr/s  CtxSw/s us%     sys%    idle%   iowait%
2.6.30-rc3              1.000   30645   43027   75      25      0       0
2.6.30-rc3_qla2xxx_p    1.000   30612   43178   75      25      0       0

Server configurations:
Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)


======oprofile CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.30-rc3                 Cycles% 2.6.30-rc3_qla2xxx
69.1925 <database>                 66.1187 <database>
1.1314 qla24xx_intr_handler        1.2120 qla24xx_start_scsi
1.0031 qla24xx_start_scsi          1.0710 qla24xx_intr_handler
0.8476 __schedule                  0.9050 kmem_cache_alloc
0.6532 kmem_cache_alloc            0.8729 __schedule
0.4490 __blockdev_direct_IO        0.4659 __blockdev_direct_IO
0.4199 __sigsetjmp                 0.4284 __sigsetjmp
0.3946 __switch_to                 0.4123 __switch_to
0.3538 __list_add                  0.3856 kstat_irqs_cpu
0.3499 task_rq_lock                0.3802 scsi_request_fn
0.3402 scsi_request_fn             0.3749 task_rq_lock
0.3382 rb_get_reader_page          0.3552 __list_add
0.3363 copy_user_generic_string    0.3516 rb_get_reader_page
0.3324 aio_complete                0.3481 aio_complete
0.3110 try_to_wake_up              0.3124 ring_buffer_consume
0.2877 ring_buffer_consume         0.3052 try_to_wake_up
0.2683 mod_timer                   0.2874 memset_c
0.2605 qla2x00_process_completed_re0.2802 tcp_sendmsg
0.2566 blk_queue_end_tag           0.2624 copy_user_generic_string
0.2566 generic_make_request        0.2570 kfree
0.2547 tcp_sendmsg                 0.2570 lock_timer_base
0.2372 lock_timer_base             0.2553 blk_queue_end_tag
0.2333 memmove                     0.2535 qla2x00_process_completed_re
0.2294 memset_c                    0.2463 mod_timer
0.2080 mempool_free                0.2392 generic_make_request
0.2022 generic_file_aio_read       0.2267 scsi_device_unbusy
0.1963 scsi_device_unbusy          0.2213 mempool_free
0.1963 plist_del                   0.2160 kref_get
0.1944 dequeue_rt_stack            0.2088 memmove
0.1924 e1000_xmit_frame            0.2017 kmem_cache_free


