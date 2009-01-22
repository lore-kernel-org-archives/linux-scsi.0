From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Mainline kernel OLTP performance update
Date: Thu, 22 Jan 2009 12:29:55 +0100
Message-ID: <20090122112955.GH30821@kernel.dk>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com> <20090114163557.11e097f2.akpm@linux-foundation.org> <20090115012147.GW29283@parisc-linux.org> <20090114180431.f4a96543.akpm@linux-foundation.org> <874p01fg3a.fsf@basil.nowhere.org> <20090115024740.GX29283@parisc-linux.org> <20090120132703.GJ30821@kernel.dk> <588992150B702C48B3312184F1B810AD03A497632C@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:2823 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbZAVLba (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2009 06:31:30 -0500
Content-Disposition: inline
In-Reply-To: <588992150B702C48B3312184F1B810AD03A497632C@azsmsx501.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chilukuri, Harita" <harita.chilukuri@intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>, Andrew Morton <akpm@linux-foundation.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "Ma, Chinang" <chinang.ma@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>, "Styner, Douglas W" <douglas.w.styner@intel.com>, "Wang, Peter Xihong" <peter.xihong.wang@intel.com>, "Nueckel, Hubert" <hubert.nueckel@intel.com>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "srostedt@redhat.com" <srostedt@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

On Wed, Jan 21 2009, Chilukuri, Harita wrote:
> Jen, we work with Matthew on the OLTP workload and have tested the part_stats patch on 2.6.29-rc2. Below are the details:
> 
> Disabling the part_stats has positive impact on the OLTP workload.
> 
> Linux OLTP Performance summary
> Kernel#                           Speedup(x) Intr/s  CtxSw/s us%  sys% idle% iowait%
> 2.6.29-rc2-part_stats                1.000   30329   41716   74    26   0       0
> 2.6.29-rc2-disable-part_stats        1.006   30413   42582   74    25   0       0
> 
> Server configurations:
> Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
> 64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)
> 
> 
> ======oprofile CPU_CLK_UNHALTED for top 30 functions
> Cycles% 2.6.29-rc2-part_stats      Cycles% 2.6.29-rc2-disable-part_stats
> 0.9634 qla24xx_intr_handler        1.0372 qla24xx_intr_handler
> 0.9057 copy_user_generic_string    0.7461 qla24xx_wrt_req_reg
> 0.7583 unmap_vmas                  0.7130 kmem_cache_alloc
> 0.6280 qla24xx_wrt_req_reg         0.6876 copy_user_generic_string
> 0.6088 kmem_cache_alloc            0.5656 qla24xx_start_scsi
> 0.5468 clear_page_c                0.4881 __blockdev_direct_IO
> 0.5191 qla24xx_start_scsi          0.4728 try_to_wake_up
> 0.4892 try_to_wake_up              0.4588 unmap_vmas
> 0.4870 __blockdev_direct_IO        0.4360 scsi_request_fn
> 0.4187 scsi_request_fn             0.3711 __switch_to
> 0.3717 __switch_to                 0.3699 aio_complete
> 0.3567 rb_get_reader_page          0.3648 rb_get_reader_page
> 0.3396 aio_complete                0.3597 ring_buffer_consume
> 0.3012 __end_that_request_first    0.3292 memset_c
> 0.2926 memset_c                    0.3076 __list_add
> 0.2926 ring_buffer_consume         0.2771 clear_page_c
> 0.2884 page_remove_rmap            0.2745 task_rq_lock
> 0.2691 disk_map_sector_rcu         0.2733 generic_make_request
> 0.2670 copy_page_c                 0.2555 tcp_sendmsg
> 0.2670 lock_timer_base             0.2529 qla2x00_process_completed_re
> 0.2606 qla2x00_process_completed_re0.2440 e1000_xmit_frame
> 0.2521 task_rq_lock                0.2390 lock_timer_base
> 0.2328 __list_add                  0.2364 qla24xx_queuecommand
> 0.2286 generic_make_request        0.2301 kmem_cache_free
> 0.2286 pick_next_highest_task_rt   0.2262 blk_queue_end_tag
> 0.2136 push_rt_task                0.2262 kref_get
> 0.2115 blk_queue_end_tag           0.2250 push_rt_task
> 0.2115 kmem_cache_free             0.2135 scsi_dispatch_cmd
> 0.2051 e1000_xmit_frame            0.2084 sd_prep_fn
> 0.2051 scsi_device_unbusy          0.2059 kfree

Alright, so that 0.6%. IIRC, 0.1% (or there abouts) is significant with
this benchmark, correct? To get a feel for the rest of the accounting
overhead, could you try with this patch that just disables the whole
thing?

diff --git a/block/blk-core.c b/block/blk-core.c
index a824e49..eec9126 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -64,6 +64,7 @@ static struct workqueue_struct *kblockd_workqueue;
 
 static void drive_stat_acct(struct request *rq, int new_io)
 {
+#if 0
 	struct hd_struct *part;
 	int rw = rq_data_dir(rq);
 	int cpu;
@@ -82,6 +83,7 @@ static void drive_stat_acct(struct request *rq, int new_io)
 	}
 
 	part_stat_unlock();
+#endif
 }
 
 void blk_queue_congestion_threshold(struct request_queue *q)
@@ -1014,6 +1017,7 @@ static inline void add_request(struct request_queue *q, struct request *req)
 	__elv_add_request(q, req, ELEVATOR_INSERT_SORT, 0);
 }
 
+#if 0
 static void part_round_stats_single(int cpu, struct hd_struct *part,
 				    unsigned long now)
 {
@@ -1027,6 +1031,7 @@ static void part_round_stats_single(int cpu, struct hd_struct *part,
 	}
 	part->stamp = now;
 }
+#endif
 
 /**
  * part_round_stats() - Round off the performance stats on a struct disk_stats.
@@ -1046,11 +1051,13 @@ static void part_round_stats_single(int cpu, struct hd_struct *part,
  */
 void part_round_stats(int cpu, struct hd_struct *part)
 {
+#if 0
 	unsigned long now = jiffies;
 
 	if (part->partno)
 		part_round_stats_single(cpu, &part_to_disk(part)->part0, now);
 	part_round_stats_single(cpu, part, now);
+#endif
 }
 EXPORT_SYMBOL_GPL(part_round_stats);
 
@@ -1690,6 +1697,7 @@ static int __end_that_request_first(struct request *req, int error,
 				(unsigned long long)req->sector);
 	}
 
+#if 0
 	if (blk_fs_request(req) && req->rq_disk) {
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part;
@@ -1700,6 +1708,7 @@ static int __end_that_request_first(struct request *req, int error,
 		part_stat_add(cpu, part, sectors[rw], nr_bytes >> 9);
 		part_stat_unlock();
 	}
+#endif
 
 	total_bytes = bio_nbytes = 0;
 	while ((bio = req->bio) != NULL) {
@@ -1779,7 +1788,9 @@ static int __end_that_request_first(struct request *req, int error,
  */
 static void end_that_request_last(struct request *req, int error)
 {
+#if 0
 	struct gendisk *disk = req->rq_disk;
+#endif
 
 	if (blk_rq_tagged(req))
 		blk_queue_end_tag(req->q, req);
@@ -1797,6 +1808,7 @@ static void end_that_request_last(struct request *req, int error)
 	 * IO on queueing nor completion.  Accounting the containing
 	 * request is enough.
 	 */
+#if 0
 	if (disk && blk_fs_request(req) && req != &req->q->bar_rq) {
 		unsigned long duration = jiffies - req->start_time;
 		const int rw = rq_data_dir(req);
@@ -1813,6 +1825,7 @@ static void end_that_request_last(struct request *req, int error)
 
 		part_stat_unlock();
 	}
+#endif
 
 	if (req->end_io)
 		req->end_io(req, error);

-- 
Jens Axboe

