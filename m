From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 01/12] blk-mq: Use all available hardware queues
Date: Tue, 07 Oct 2014 15:02:43 +0200
Message-ID: <5433E473.4020102@acm.org>
References: <5433E43D.3010107@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5433E43D.3010107-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Suppose that a system has two CPU sockets, three cores per socket,
that it does not support hyperthreading and that four hardware
queues are provided by a block driver. With the current algorithm
this will lead to the following assignment of CPU cores to hardware
queues:

  HWQ 0: 0 1
  HWQ 1: 2 3
  HWQ 2: 4 5
  HWQ 3: (none)

This patch changes the queue assignment into:

  HWQ 0: 0 1
  HWQ 1: 2
  HWQ 2: 3 4
  HWQ 3: 5

In other words, this patch has the following three effects:
- All four hardware queues are used instead of only three.
- CPU cores are spread more evenly over hardware queues. For the
  above example the range of the number of CPU cores associated
  with a single HWQ is reduced from [0..2] to [1..2].
- If the number of HWQ's is a multiple of the number of CPU sockets
  it is now guaranteed that all CPU cores associated with a single
  HWQ reside on the same CPU socket.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 block/blk-mq-cpumap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 1065d7c..8e56455 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -17,7 +17,7 @@
 static int cpu_to_queue_index(unsigned int nr_cpus, unsigned int nr_queues,
 			      const int cpu)
 {
-	return cpu / ((nr_cpus + nr_queues - 1) / nr_queues);
+	return cpu * nr_queues / nr_cpus;
 }
 
 static int get_first_sibling(unsigned int cpu)
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
