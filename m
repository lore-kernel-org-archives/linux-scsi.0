From: dongsu.park@profitbricks.com
Subject: [PATCH 4/5] ib_srp: check if rport->lld_data is NULL before removing rport
Date: Fri, 31 Aug 2012 22:00:40 +0200
Message-ID: <1346443241-24844-5-git-send-email-dongsu.park@profitbricks.com>
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bvanassche@acm.org
Cc: dillowda@ornl.gov, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, JBottomley@parallels.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Dongsu Park <dongsu.park@profitbricks.com>
List-Id: linux-scsi@vger.kernel.org

From: Dongsu Park <dongsu.park@profitbricks.com>

After removing rport_delete(), rport->lld_data has to be set to NULL.
In addition to that, both srp_rport_delete() and
rport_dev_loss_timedout() must check if rport->lld_data is NULL,
before accessing to rport->lld_data or any rport's target area.

Without this patch, the initiator's kernel could crash with the
following call trace, especially deleting remote ports as well as
IB link down cases.

How to reproduce:
1. Configure 500+ vdisks on target, and get initiator connected.
2. Exchange data intensively, which works well.
3. (On initiator) delete SRP remote port occasionally, e.g.
   # echo "1" > /sys/class/srp_remote_ports/port-6\:1/delete
   And configure again the SRP target.
4. (On target) disable Infiniband interface, and enable it again.
5. Repeat 3 and 4.

Then the initiator's kernel suddenly crashes. (but not always)

Kernel Call Trace:

BUG: unable to handle kernel paging request at 0000000000010001
IP: [<ffffffff8139ec55>] strnlen+0x5/0x40 PGD 212fea067 PUD 2162f8067 PMD 0
Oops: 0000 [#1] SMP CPU 0
Pid: 2311, comm: kworker/0:2 Not tainted 3.2.8 #1 Supermicro H8DGU/H8DGU
RIP: 0010:[<ffffffff8139ec55>]  [<ffffffff8139ec55>] strnlen+0x5/0x40
Process kworker/0:2 (pid: 2311, threadinfo ffff880215fe2000, task
ffff88020f2ce540)
Call Trace:
 [<ffffffff813a023c>] ? string+0x4c/0xe0
 [<ffffffff813a142d>] ? vsnprintf+0x1ed/0x5b0
 [<ffffffffa0131900>] ? do_srp_rport_del+0x30/0x30 [scsi_transport_srp]
 [<ffffffff813a18a9>] ? vscnprintf+0x9/0x20
 [<ffffffff81049b7f>] ? vprintk+0xaf/0x440
 [<ffffffff810f3cc0>] ? next_online_pgdat+0x20/0x50
 [<ffffffff810f3d20>] ? next_zone+0x30/0x40
 [<ffffffff810f4c60>] ? refresh_cpu_vm_stats+0xf0/0x160
 [<ffffffffa0131900>] ? do_srp_rport_del+0x30/0x30 [scsi_transport_srp]
 [<ffffffff816533b6>] ? printk+0x40/0x4a
 [<ffffffffa013192d>] ? rport_dev_loss_timedout+0x2d/0xa0 [scsi_transport_srp]
 [<ffffffff81063383>] ? process_one_work+0x113/0x470
 [<ffffffff81065c73>] ? worker_thread+0x163/0x3e0
 [<ffffffff81065b10>] ? manage_workers+0x200/0x200
 [<ffffffff81065b10>] ? manage_workers+0x200/0x200
 [<ffffffff8106a126>] ? kthread+0x96/0xa0
 [<ffffffff8165f674>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8106a090>] ? kthread_worker_fn+0x180/0x180
 [<ffffffff8165f670>] ? gs_change+0x13/0x13
RIP  [<ffffffff8139ec55>] strnlen+0x5/0x40
RSP <ffff880215fe3c28>
CR2: 0000000000010001
---[ end trace d55b61cd78c54a0a ]---
IP: [<ffffffff81069cb7>] kthread_data+0x7/0x10
Oops: 0000 [#2] SMP
CPU 3
Pid: 16745, comm: kworker/3:4 Tainted: G      D    O 3.2.8-pserver+
 #51 System manufacturer System Product Name/M4A89GTD-PRO
RIP: 0010:[<ffffffff81069cb7>]  [<ffffffff81069cb7>] kthread_data+0x7/0x10
Process kworker/3:4 (pid: 16745, threadinfo ffff8801f8162000, task
ffff88020ff91440)
Call Trace:
 [<ffffffff81062fc8>] ? wq_worker_sleeping+0x8/0x90
 [<ffffffff81653ca2>] ? __schedule+0x432/0x7e0
 [<ffffffff8104ce54>] ? do_exit+0x5d4/0x8a0
 [<ffffffff816533b6>] ? printk+0x40/0x4a
 [<ffffffff81656d13>] ? oops_end+0xa3/0xf0
 [<ffffffff8102b33d>] ? no_context+0xfd/0x270
 [<ffffffff8103dd55>] ? check_preempt_wakeup+0x155/0x1d0
 [<ffffffff8165951a>] ? do_page_fault+0x31a/0x440
 [<ffffffff810406d2>] ? select_task_rq_fair+0x432/0x9d0
 [<ffffffff81396b32>] ? cpumask_next_and+0x22/0x40
 [<ffffffff810391f3>] ? find_busiest_group+0x1f3/0xb30
 [<ffffffff81656285>] ? page_fault+0x25/0x30
 [<ffffffff8139ec55>] ? strnlen+0x5/0x40
 [<ffffffff813a023c>] ? string+0x4c/0xe0
 [<ffffffff813a142d>] ? vsnprintf+0x1ed/0x5b0
 [<ffffffffa0121900>] ? do_srp_rport_del+0x30/0x30 [scsi_transport_srp]
 [<ffffffff813a18a9>] ? vscnprintf+0x9/0x20
 [<ffffffff81049b7f>] ? vprintk+0xaf/0x440
 [<ffffffff8104e429>] ? ns_to_timeval+0x9/0x40
 [<ffffffff81062f87>] ? queue_delayed_work_on+0x157/0x170
 [<ffffffffa0121900>] ? do_srp_rport_del+0x30/0x30 [scsi_transport_srp]
 [<ffffffff816533b6>] ? printk+0x40/0x4a
 [<ffffffffa012192d>] ? rport_dev_loss_timedout+0x2d/0xa0 [scsi_transport_srp]
 [<ffffffff814f43f0>] ? cpufreq_governor_dbs+0x4b0/0x4b0
 [<ffffffff81063383>] ? process_one_work+0x113/0x470
 [<ffffffff81065c73>] ? worker_thread+0x163/0x3e0
 [<ffffffff81065b10>] ? manage_workers+0x200/0x200
 [<ffffffff81065b10>] ? manage_workers+0x200/0x200
 [<ffffffff8106a126>] ? kthread+0x96/0xa0
 [<ffffffff8165f674>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8106a090>] ? kthread_worker_fn+0x180/0x180
 [<ffffffff8165f670>] ? gs_change+0x13/0x13
RIP  [<ffffffff81069cb7>] kthread_data+0x7/0x10
RSP <ffff8801f81638d0>
CR2: fffffffffffffff8
---[ end trace cab7f2c38a7f7ba9 ]---

Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 12 +++++++++++-
 drivers/scsi/scsi_transport_srp.c   |  6 ++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1b274484..ba7bbfd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -647,9 +647,19 @@ static void srp_remove_work(struct work_struct *work)
 
 static void srp_rport_delete(struct srp_rport *rport)
 {
-	struct srp_target_port *target = rport->lld_data;
+	struct srp_target_port *target;
+
+	if (!rport->lld_data) {
+		pr_warn("skipping srp_rport_delete. rport->lld_data=%p\n",
+			rport->lld_data);
+		return;
+	}
+
+	target = rport->lld_data;
 
 	srp_queue_remove_work(target);
+
+	rport->lld_data = NULL;
 }
 
 /**
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index af3cb56..915b355 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -272,6 +272,12 @@ static void rport_dev_loss_timedout(struct work_struct *work)
 	struct Scsi_Host *shost;
 	struct srp_internal *i;
 
+	if (!rport->lld_data) {
+		pr_warn("skipping rport_delete, rport->lld_data=%p\n",
+			rport->lld_data);
+		return;
+	}
+
 	pr_err("SRP transport: dev_loss_tmo (%ds) expired - removing %s.\n",
 	       rport->dev_loss_tmo, dev_name(&rport->dev));
 
-- 
1.7.11.1
