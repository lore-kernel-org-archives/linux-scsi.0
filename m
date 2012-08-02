From: Chanho Min <chanho0207@gmail.com>
Subject: [PATCH] fix NULL-pointer dereference on scsi_run_queue
Date: Thu, 2 Aug 2012 17:41:39 +0900
Message-ID: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch is to fix a oops from a torn down device. When
scsi_run_queue process starved queues, scsi_request_fn can race with
scsi_remove_device. In this case, rarely, scsi_request_fn release the
last reference and set sdev->request_queue to NULL. It result in
NULL-pointer dereference when spin_unlock is tried with (NULL)->
queue_lock. We need to add an extra reference to the device on both
sides of the __blk_run_queue to hold reference until scsi_request_fn
is finished.

[    8.042972] Unable to handle kernel NULL pointer dereference at
virtual address 00000240
[    8.051061] pgd = 80004000
[    8.053762] [00000240] *pgd=00000000
[    8.057342] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[    8.062736] Modules linked in:
[    8.065793] CPU: 0    Not tainted  (3.4.2+ #313)
[    8.070418] PC is at scsi_run_queue+0x19c/0x2b8
[    8.074947] LR is at scsi_run_queue+0x198/0x2b8
[    8.079476] pc : [<802569a0>]    lr : [<8025699c>]    psr: 20000193
[    8.079481] sp : 9f915f10  ip : 00000f01  fp : 00000001
[    8.090953] r10: 9f09d424  r9 : 8055294c  r8 : 9f915f20
[    8.096172] r7 : 9f914000  r6 : 00000000  r5 : 9f09e000  r4 : 9f09d400
[    8.102694] r3 : 00000000  r2 : 80504a14  r1 : 60000193  r0 : 00000043
[    8.109219] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[    8.116612] Control: 10c53c7d  Table: 1f1f804a  DAC: 00000015
[    8.122355] Process kworker/0:1 (pid: 312, stack limit = 0x9f9142f0)
[    8.128705] Stack: (0x9f915f10 to 0x9f916000)
[    8.133059] 5f00:                                     00000000
00000000 9f1e8000 60000113
[    8.141236] 5f20: 9f915f20 9f915f20 00000001 9f9be1c0 8095f480
80963100 9f914000 00000000
[    8.149414] 5f40: 80963105 80258304 9f09da70 80034858 9f9fb6c0
00000000 00000001 9f9be1c0
[    8.157591] 5f60: 8095f480 8095f488 9f9be1d0 9f914000 804edf80
804fff08 00000009 80037044
[    8.165767] 5f80: 804edfc0 804edfc0 804edfc0 804edf80 804edf80
804edf80 00000001 9f859ee8
[    8.173943] 5fa0: 9f915fcc 9f9be1c0 80036ed4 00000000 00000000
00000000 00000000 8003ac64
[    8.182119] 5fc0: 9f859ee8 00000000 9f9be1c0 00000000 00000000
00000000 9f915fd8 9f915fd8
[    8.190296] 5fe0: 00000000 9f859ee8 8003abd8 80014c0c 00000013
80014c0c ffffffff ffffffff
[    8.198494] [<802569a0>] (scsi_run_queue+0x19c/0x2b8) from
[<80034858>] (process_one_work+0x118/0x39c)
[    8.207812] [<80034858>] (process_one_work+0x118/0x39c) from
[<80037044>] (worker_thread+0x170/0x368)
[    8.217047] [<80037044>] (worker_thread+0x170/0x368) from
[<8003ac64>] (kthread+0x8c/0x98)
[    8.225337] [<8003ac64>] (kthread+0x8c/0x98) from [<80014c0c>]
(kernel_thread_exit+0x0/0x8)
[    8.233692] Code: e59f011c e58dc000 eb05457e e5953004 (e5930240)
[    8.240026] __scsi_remove_device:962 9f1e8000
[    8.240140] ---[ end trace 1ec4a0217c9f24f3 ]---

Signed-off-by: Chanho Min <chanho.min@lge.com>

---
 drivers/scsi/scsi_lib.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b583277..1868c35 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -436,9 +436,13 @@ static void scsi_run_queue(struct request_queue *q)
 		}

 		spin_unlock(shost->host_lock);
+		/* hold a reference on the device so it doesn't release device */
+		get_device(&sdev->sdev_gendev);
 		spin_lock(sdev->request_queue->queue_lock);
 		__blk_run_queue(sdev->request_queue);
 		spin_unlock(sdev->request_queue->queue_lock);
+		/* ok to remove device now */
+		put_device(&sdev->sdev_gendev);
 		spin_lock(shost->host_lock);
 	}
 	/* put any unprocessed entries back */
-- 
1.7.0.4
