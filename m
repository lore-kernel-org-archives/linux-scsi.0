From: akpm@osdl.org
Subject: [patch 20/24] scsi: limit recursion when flushing shost->starved_list
Date: Mon, 14 Aug 2006 23:09:36 -0700
Message-ID: <200608150609.k7F69b5C013267@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:2198 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965188AbWHOGJt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 02:09:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, aherrman@de.ibm.com, axboe@suse.de

From: Andreas Herrmann <aherrman@de.ibm.com>

This should limit a possible recursion that can lead to a stack overflow
like follows:

Kernel stack overflow.
CPU:    3    Not tainted
Process zfcperp0.0.d819
(pid: 13897, task: 000000003e0d8cc8, ksp: 000000003499dbb8)
Krnl PSW : 0404000180000000 000000000030f8b2 (get_device+0x12/0x48)
Krnl GPRS: 00000000135a1980 000000000030f758 000000003ed6c1e8 0000000000000005
           0000000000000000 000000000044a780 000000003dbf7000 0000000034e15800
           000000003621c048 070000003499c108 000000003499c1a0 000000003ed6c000
           0000000040895000 00000000408ab630 000000003499c0a0 000000003499c0a0
Krnl Code: a7 fb ff e8 a7 19 00 00 b9 02 00 22 e3 e0 f0 98 00 24 a7 84
Call Trace:
([<000000004089edc2>] scsi_request_fn+0x13e/0x650 [scsi_mod])
 [<00000000002c5ff4>] blk_run_queue+0xd4/0x1a4
 [<000000004089ff8c>] scsi_queue_insert+0x22c/0x2a4 [scsi_mod]
 [<000000004089779a>] scsi_dispatch_cmd+0x8a/0x3d0 [scsi_mod]
 [<000000004089f1ec>] scsi_request_fn+0x568/0x650 [scsi_mod]
...
 [<000000004089f1ec>] scsi_request_fn+0x568/0x650 [scsi_mod]
 [<00000000002c5ff4>] blk_run_queue+0xd4/0x1a4
 [<000000004089ff8c>] scsi_queue_insert+0x22c/0x2a4 [scsi_mod]
 [<000000004089779a>] scsi_dispatch_cmd+0x8a/0x3d0 [scsi_mod]
 [<000000004089f1ec>] scsi_request_fn+0x568/0x650 [scsi_mod]
 [<00000000002c5ff4>] blk_run_queue+0xd4/0x1a4
 [<000000004089fa9e>] scsi_run_host_queues+0x196/0x230 [scsi_mod]
 [<00000000409eba28>] zfcp_erp_thread+0x2638/0x3080 [zfcp]
 [<0000000000107462>] kernel_thread_starter+0x6/0xc
 [<000000000010745c>] kernel_thread_starter+0x0/0xc
<0>Kernel panic - not syncing: Corrupt kernel stack, can't continue.

This stack overflow occurred during tests on s390 using zfcp.
Recursion depth for this panic was 19.

Usually recursion between blk_run_queue and a request_fn is avoided
using QUEUE_FLAG_REENTER. But this does not help if the scsi stack
tries to flush the starved_list of a scsi_host.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <axboe@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/scsi_lib.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~scsi-limit-recursion-when-flushing-shost-starved_list drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi-limit-recursion-when-flushing-shost-starved_list
+++ a/drivers/scsi/scsi_lib.c
@@ -553,7 +553,15 @@ static void scsi_run_queue(struct reques
 		list_del_init(&sdev->starved_entry);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 
-		blk_run_queue(sdev->request_queue);
+
+		if (test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
+		    !test_and_set_bit(QUEUE_FLAG_REENTER,
+				      &sdev->request_queue->queue_flags)) {
+			blk_run_queue(sdev->request_queue);
+			clear_bit(QUEUE_FLAG_REENTER,
+				  &sdev->request_queue->queue_flags);
+		} else
+			blk_run_queue(sdev->request_queue);
 
 		spin_lock_irqsave(shost->host_lock, flags);
 		if (unlikely(!list_empty(&sdev->starved_entry)))
_
