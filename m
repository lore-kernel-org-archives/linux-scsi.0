From: Vikram Auradkar <auradkar@google.com>
Subject: [RFC] [PATCH] Do not start queue from interrupt context
Date: Mon, 30 Apr 2018 14:21:27 -0700
Message-ID: <20180430212127.54865-1-auradkar@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Vikram Auradkar <auradkar@google.com>
List-Id: linux-scsi@vger.kernel.org

Lockdep warning is seen when driver is handling a topology change
event after drive removal.
Starting queue eventually enables irq, which throws lockdep warning in
scsi_request_fn. This change makes starting queues async.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel/lockdep.c:2593 trace_hardirqs_on_caller+0x1bc/0x1d0()
DEBUG_LOCKS_WARN_ON(current->hardirq_context)
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O  3.11.10-dbg-DEV #1
Hardware name: Intel Grantley,Wellsburg/Ixion_QC_15, BIOS 2.50.0 01/21/2016
 0000000000000000 ffff881fff803b28 ffffffffa4ea1bd5 ffff881fff803b78
 ffffffffa491bdcc ffff881fff803b68 ffffffffa48ae464 00000000cc6405a0
 0000000000000000 ffffffffa4805a50 ffff881f9b3ae000 0000000000000000
Call Trace:
 <IRQ>  [<ffffffffa4ea1bd5>] dump_stack+0x68/0x91
 [<ffffffffa491bdcc>] ? trace_hardirqs_on_caller+0x1bc/0x1d0
 [<ffffffffa48ae464>] warn_slowpath_common+0x94/0xc0
 [<ffffffffa4805a50>] ? _raw_spin_unlock_irq+0x30/0x50
 [<ffffffffa48ae546>] warn_slowpath_fmt+0x46/0x50
 [<ffffffffa491bdcc>] trace_hardirqs_on_caller+0x1bc/0x1d0
 [<ffffffffa491bded>] trace_hardirqs_on+0xd/0x10
 [<ffffffffa4805a50>] _raw_spin_unlock_irq+0x30/0x50
 [<ffffffffa4c5398f>] scsi_request_fn+0xaf/0x720
 [<ffffffffa4b66907>] __blk_run_queue+0x37/0x50
 [<ffffffffa4b66f1e>] blk_start_queue+0x3e/0x80
 [<ffffffffa4c52d7f>] scsi_internal_device_unblock+0x3f/0x90
 [<ffffffffc0358357>] _scsih_ublock_io_device+0x87/0xd0 [mpt2sas]
 [<ffffffffc035c105>] _scsih_tm_tr_send+0x185/0x340 [mpt2sas]
 [<ffffffffc0362e10>] mpt2sas_scsih_event_callback+0x3e0/0x840 [mpt2sas]
 [<ffffffffc034e0ba>] _base_interrupt+0x2fa/0x950 [mpt2sas]
 [<ffffffffa491bcbb>] ? trace_hardirqs_on_caller+0xab/0x1d0
 [<ffffffffa491bded>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa4950784>] handle_irq_event_percpu+0x74/0x230
 [<ffffffffa4950988>] handle_irq_event+0x48/0x70
 [<ffffffffa495315e>] ? handle_edge_irq+0x1e/0x110
 [<ffffffffa49531b7>] handle_edge_irq+0x77/0x110
 [<ffffffffa4857d82>] handle_irq+0x22/0x40
 [<ffffffffa4805e9f>] do_IRQ+0x7f/0x110
 [<ffffffffa4ea3f2f>] common_interrupt+0x6f/0x6f
 <EOI>  [<ffffffffa4d3fe8c>] ? __cpuidle_enter_state+0x7c/0x120
 [<ffffffffa4d3fe87>] ? __cpuidle_enter_state+0x77/0x120
 [<ffffffffa4d40105>] cpuidle_enter_state+0xd5/0x250
 [<ffffffffa4909aa8>] cpu_startup_entry+0xb8/0x1e0
 [<ffffffffa4e98536>] rest_init+0xd6/0xe0
 [<ffffffffa4e98465>] ? rest_init+0x5/0xe0
 [<ffffffffa5874ec1>] start_kernel+0x3ed/0x3fa
 [<ffffffffa58748d0>] ? repair_env_string+0x5e/0x5e
 [<ffffffffa58745a5>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffffa58746b0>] x86_64_start_kernel+0x109/0x10d
---[ end trace 46d48ef4760a5d9c ]--

Signed-off-by: Vikram Auradkar <auradkar@google.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9b4f279d29c..72c90233f261 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3178,7 +3178,7 @@ void scsi_start_queue(struct scsi_device *sdev)
 		blk_mq_unquiesce_queue(q);
 	} else {
 		spin_lock_irqsave(q->queue_lock, flags);
-		blk_start_queue(q);
+		blk_start_queue_async(q);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 }
-- 
2.17.0.441.gb46fe60e1d-goog
