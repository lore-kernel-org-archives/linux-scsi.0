From: "Styner, Douglas W" <douglas.w.styner@intel.com>
Subject: RE: [PATCH] qla2xxx: Fix a regression due to refactoring in
 interrupt handler code
Date: Tue, 28 Apr 2009 14:31:56 -0700
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F44B4@azsmsx501.amr.corp.intel.com>
References: <alpine.OSX.1.00.0904280916550.25672@ac-mac.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbZD1Vb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2009 17:31:58 -0400
In-Reply-To: <alpine.OSX.1.00.0904280916550.25672@ac-mac.qlogic.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>, "andi@firstfloor.org" <andi@firstfloor.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-driver@qlogic.com" <linux-driver@qlogic.com>, "Ma, Chinang" <chinang.ma@intel.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "willy@linux.intel.com" <willy@linux.intel.com>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>

> Anirban Chakraborty <anirban.chakraborty@qlogic.com> writes:
>
>From: Anirban Chakraborty [mailto:anirban.chakraborty@qlogic.com]
>Sent: Tuesday, April 28, 2009 9:28 AM
>To: Styner, Douglas W; andi@firstfloor.org;
>James.Bottomley@HansenPartnership.com
>Cc: linux-scsi@vger.kernel.org; linux-driver@qlogic.com
>Subject: [PATCH] qla2xxx: Fix a regression due to refactoring in interrupt
>handler code
>
>Remove unnecessary search for a response completion host when driver is
>running
>in single queue mode. This should fix the increased cycles seen in
>qla24xx_intr_handler code.
>
>Please apply.
>Thanks,
>Anirban
>
>Reported-by: Styner, Douglas W <douglas.w.styner@intel.com>
>Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

There is no significant impact from this patch.  The net effect of this patch when using MSI is to replace calls to qla2x00_get_rsp_host(), which calls the in-lined function pci_get_drvdata(), with direct calls to pci_get_drvdata().  qla2x00_get_rsp_host is very inexpensive (~0.0117%), so removing does not have a significant impact.

Linux OLTP Performance summary
Kernel#            Speedup(x)   Intr/s  CtxSw/s us%     sys%    idle%   iowait%
2.6.30-rc3              1.000   30645   43027   75      25      0       0
2.6.30-rc3_qla2xxx      0.999   30737   43256   75      25      0       0

Server configurations:
Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)


======oprofile CPU_CLK_UNHALTED for top 30 functions
Cycles% 2.6.30-rc3                 Cycles% 2.6.30-rc3_qla2xxx
69.1925 <database>                 67.8477 <database>
1.1314 qla24xx_intr_handler        1.2426 qla24xx_start_scsi
1.0031 qla24xx_start_scsi          1.1148 qla24xx_intr_handler
0.8476 __schedule                  0.8508 kmem_cache_alloc
0.6532 kmem_cache_alloc            0.8021 __schedule
0.4490 __blockdev_direct_IO        0.5179 __blockdev_direct_IO
0.4199 __sigsetjmp                 0.4456 __sigsetjmp
0.3946 __switch_to                 0.3952 scsi_request_fn
0.3538 __list_add                  0.3817 __switch_to
0.3499 task_rq_lock                0.3716 task_rq_lock
0.3402 scsi_request_fn             0.3481 __list_add
0.3382 rb_get_reader_page          0.3380 rb_get_reader_page
0.3363 copy_user_generic_string    0.3178 ring_buffer_consume
0.3324 aio_complete                0.2993 aio_complete
0.3110 try_to_wake_up              0.2993 copy_user_generic_string
0.2877 ring_buffer_consume         0.2741 try_to_wake_up
0.2683 mod_timer                   0.2623 blk_queue_end_tag
0.2605 qla2x00_process_completed_re0.2573 lock_timer_base
0.2566 blk_queue_end_tag           0.2522 memset_c
0.2566 generic_make_request        0.2472 memmove
0.2547 tcp_sendmsg                 0.2472 qla2x00_process_completed_re
0.2372 lock_timer_base             0.2270 generic_make_request
0.2333 memmove                     0.2253 mod_timer
0.2294 memset_c                    0.2186 __make_request
0.2080 mempool_free                0.2136 scsi_device_unbusy
0.2022 generic_file_aio_read       0.2136 kmem_cache_free
0.1963 scsi_device_unbusy          0.2119 mempool_free
0.1963 plist_del                   0.2018 kref_get
0.1944 dequeue_rt_stack            0.2018 plist_del
0.1924 e1000_xmit_frame            0.1984 ipc_lock

Doug
