From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Mainline kernel OLTP performance update
Date: Wed, 14 Jan 2009 16:35:57 -0800
Message-ID: <20090114163557.11e097f2.akpm@linux-foundation.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	<CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757885AbZAOAgT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2009 19:36:19 -0500
In-Reply-To: <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Cc: chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

On Tue, 13 Jan 2009 15:44:17 -0700
"Wilcox, Matthew R" <matthew.r.wilcox@intel.com> wrote:
>

(top-posting repaired.  That @intel.com address is a bad influence ;))

(cc linux-scsi)

> > -----Original Message-----
> > From: Ma, Chinang
> > Sent: Tuesday, January 13, 2009 1:11 PM
> > To: linux-kernel@vger.kernel.org
> > Cc: Tripathi, Sharad C; arjan@linux.intel.com; Wilcox, Matthew R; Kleen,
> > Andi; Siddha, Suresh B; Chilukuri, Harita; Styner, Douglas W; Wang, Peter
> > Xihong; Nueckel, Hubert; Chris Mason
> > Subject: Mainline kernel OLTP performance update
> > 
> > This is latest 2.6.29-rc1 kernel OLTP performance result. Compare to
> > 2.6.24.2 the regression is around 3.5%.
> > 
> > Linux OLTP Performance summary
> > Kernel#            Speedup(x)   Intr/s  CtxSw/s us%  sys%   idle%  iowait%
> > 2.6.24.2                1.000   21969   43425   76   24     0      0
> > 2.6.27.2                0.973   30402   43523   74   25     0      1
> > 2.6.29-rc1              0.965   30331   41970   74   26     0      0
> > 
> > Server configurations:
> > Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
> > 64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)
>
> 
> One encouraging thing is that we don't see a significant drop-off between 2.6.28 and 2.6.29-rc1, which I think is the first time we've not seen a big problem with -rc1.
> 
> To compare the top 30 functions between 2.6.28 and 2.6.29-rc1:
> 
> 1.4257 qla24xx_start_scsi		1.0691 qla24xx_intr_handler
> 0.8784 kmem_cache_alloc			0.7701 copy_user_generic_string
> 0.6876 qla24xx_intr_handler		0.7339 qla24xx_wrt_req_reg
> 0.5834 copy_user_generic_string	0.6458 kmem_cache_alloc
> 0.4945 scsi_request_fn			0.5794 qla24xx_start_scsi
> 0.4846 __blockdev_direct_IO		0.5505 unmap_vmas
> 0.4187 try_to_wake_up			0.4869 __blockdev_direct_IO
> 0.3518 aio_complete			0.4493 try_to_wake_up
> 0.3513 __end_that_request_first	0.4291 scsi_request_fn
> 0.3483 __switch_to			0.4118 clear_page_c
> 0.3271 memset_c				0.4002 __switch_to
> 0.2976 qla2x00_process_completed_re	0.3381 ring_buffer_consume
> 0.2905 __list_add				0.3366 rb_get_reader_page
> 0.2901 generic_make_request		0.3222 aio_complete
> 0.2755 lock_timer_base			0.3135 memset_c
> 0.2741 blk_queue_end_tag		0.2875 __list_add
> 0.2593 kmem_cache_free			0.2673 task_rq_lock
> 0.2445 disk_map_sector_rcu		0.2658 __end_that_request_first
> 0.2370 pick_next_highest_task_rt	0.2615 qla2x00_process_completed_re
> 0.2323 scsi_device_unbusy		0.2615 lock_timer_base
> 0.2321 task_rq_lock			0.2456 disk_map_sector_rcu
> 0.2316 scsi_dispatch_cmd		0.2427 tcp_sendmsg
> 0.2239 kref_get				0.2413 e1000_xmit_frame
> 0.2237 dio_bio_complete			0.2398 kmem_cache_free
> 0.2194 push_rt_task			0.2384 pick_next_highest_task_rt
> 0.2145 __aio_get_req			0.2225 blk_queue_end_tag
> 0.2143 kfree				0.2211 sd_prep_fn
> 0.2138 __mod_timer			0.2167 qla24xx_queuecommand
> 0.2131 e1000_irq_enable			0.2109 scsi_device_unbusy
> 0.2091 scsi_softirq_done		0.2095 kref_get
> 
> It looks like a number of functions in the qla2x00 driver were split up, so it's probably best to ignore all the changes in qla* functions.
> 
> unmap_vmas is a new hot function.  It's been around since before git history started, and hasn't changed substantially between 2.6.28 and 2.6.29-rc1, so I suspect we're calling it more often.  I don't know why we'd be doing that.
> 
> clear_page_c is also new to the hot list.  I haven't tried to understand why this might be so.
> 
> The ring_buffer_consume() and rb_get_reader_page() functions are part of the oprofile code.  This seems to indicate a bug -- they should not be the #12 and #13 hottest functions in the kernel when monitoring a database run!
> 
> That seems to be about it for regressions.
> 

But the interrupt rate went through the roof.

A 3.5% slowdown in this workload is considered pretty serious, isn't it?
