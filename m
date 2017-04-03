From: Kyle Fortin <kyle.fortin@oracle.com>
Subject: [PATCH] libiscsi: use vzalloc for large allocations in iscsi_pool_init
Date: Mon,  3 Apr 2017 06:30:21 -0700
Message-ID: <1491226221-24621-1-git-send-email-kyle.fortin@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48199 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753004AbdDCNab (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2017 09:30:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lduncan@suse.com, cleech@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: Kyle Fortin <kyle.fortin@oracle.com>

iscsiadm session login can fail with the following error:

iscsiadm: Could not login to [iface: default, target: iqn.1986-03.com...
iscsiadm: initiator reported error (9 - internal error)

When /etc/iscsi/iscsid.conf sets node.session.cmds_max = 4096, it results
in 64K-sized kmallocs per session.  A system under fragmented slab
pressure may not have any 64K objects available and fail iscsiadm session
login. Even though memory objects of a smaller size are available, the
large order allocation ends up failing.

The kernel will print a warning and dump_stack, like below:

iscsid: page allocation failure: order:4, mode:0xc0d0
CPU: 0 PID: 2456 Comm: iscsid Not tainted 4.1.12-61.1.28.el6uek.x86_64 #2
Call Trace:
 [<ffffffff816c6e40>] dump_stack+0x63/0x83
 [<ffffffff8118e58a>] warn_alloc_failed+0xea/0x140
 [<ffffffff81191df9>] __alloc_pages_slowpath+0x409/0x760
 [<ffffffff81192401>] __alloc_pages_nodemask+0x2b1/0x2d0
 [<ffffffffa048f6c0>] ? dev_attr_host_ipaddress+0x20/0xffffffffffffc722
 [<ffffffff811dc38f>] alloc_pages_current+0xaf/0x170
 [<ffffffff81192581>] alloc_kmem_pages+0x31/0xd0
 [<ffffffffa048f600>] ? iscsi_transport_group+0x20/0xffffffffffffc7e2
 [<ffffffff811ad738>] kmalloc_order+0x18/0x50
 [<ffffffff811ad7a4>] kmalloc_order_trace+0x34/0xe0
 [<ffffffff8146ee30>] ? transport_remove_classdev+0x70/0x70
 [<ffffffff811e843d>] __kmalloc+0x27d/0x2a0
 [<ffffffff810c8cbd>] ? complete_all+0x4d/0x60
 [<ffffffffa04af299>] iscsi_pool_init+0x69/0x160 [libiscsi]
 [<ffffffff81465d90>] ? device_initialize+0xb0/0xd0
 [<ffffffffa04af510>] iscsi_session_setup+0x180/0x2f4 [libiscsi]
 [<ffffffffa04c5a60>] ? iscsi_max_lun+0x20/0xfffffffffffffa9e [iscsi_tcp]
 [<ffffffffa04c531f>] iscsi_sw_tcp_session_create+0xcf/0x150 [iscsi_tcp]
 [<ffffffffa04c5a60>] ? iscsi_max_lun+0x20/0xfffffffffffffa9e [iscsi_tcp]
 [<ffffffffa048a633>] iscsi_if_create_session+0x33/0xd0
 [<ffffffffa04c5a60>] ? iscsi_max_lun+0x20/0xfffffffffffffa9e [iscsi_tcp]
 [<ffffffffa048abd8>] iscsi_if_recv_msg+0x508/0x8c0 [scsi_transport_iscsi]
 [<ffffffff811922eb>] ? __alloc_pages_nodemask+0x19b/0x2d0
 [<ffffffff811e6d69>] ? __kmalloc_node_track_caller+0x209/0x2c0
 [<ffffffffa048b00c>] iscsi_if_rx+0x7c/0x200 [scsi_transport_iscsi]
 [<ffffffff81623dc6>] netlink_unicast+0x126/0x1c0
 [<ffffffff8162468c>] netlink_sendmsg+0x36c/0x400
 [<ffffffff815d2fed>] sock_sendmsg+0x4d/0x60
 [<ffffffff815d596a>] ___sys_sendmsg+0x30a/0x330
 [<ffffffff811bc72c>] ? handle_pte_fault+0x20c/0x230
 [<ffffffff811bc90c>] ? __handle_mm_fault+0x1bc/0x330
 [<ffffffff811bcb32>] ? handle_mm_fault+0xb2/0x1a0
 [<ffffffff815d5b99>] __sys_sendmsg+0x49/0x90
 [<ffffffff815d5bf9>] SyS_sendmsg+0x19/0x20
 [<ffffffff816cbb2e>] system_call_fastpath+0x12/0x71

Use vzalloc for iscsi_pool allocations larger than PAGE_SIZE.  This only
affects hosts using a non-standard larger /etc/iscsi/iscsid.conf
node.session.cmds_max value. Since iscsi_pool_init is also called to
allocate very small pools per cmd for r2t handling, it is best to retain
using kzalloc for those allocations.

Signed-off-by: Kyle Fortin <kyle.fortin@oracle.com>
Tested-by: Kyle Fortin <kyle.fortin@oracle.com>
Reviewed-by: Joseph Slember <joe.slember@oracle.com>
Reviewed-by: Lance Hartmann <lance.hartmann@oracle.com>
---
 drivers/scsi/libiscsi.c | 15 +++++++++++++--
 include/scsi/libiscsi.h |  1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 3fca34a675af..5a622ba2f10d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -27,6 +27,7 @@
 #include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/vmalloc.h>
 #include <asm/unaligned.h>
 #include <net/tcp.h>
 #include <scsi/scsi_cmnd.h>
@@ -2546,6 +2547,7 @@ int iscsi_eh_recover_target(struct scsi_cmnd *sc)
 iscsi_pool_init(struct iscsi_pool *q, int max, void ***items, int item_size)
 {
 	int i, num_arrays = 1;
+	int alloc_size;
 
 	memset(q, 0, sizeof(*q));
 
@@ -2555,7 +2557,13 @@ int iscsi_eh_recover_target(struct scsi_cmnd *sc)
 	 * the array. */
 	if (items)
 		num_arrays++;
-	q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
+
+	alloc_size = num_arrays * max * sizeof(void *);
+	if (alloc_size > PAGE_SIZE) {
+		q->pool = vzalloc(alloc_size);
+		q->is_pool_vmalloc = true;
+	} else
+		q->pool = kzalloc(alloc_size, GFP_KERNEL);
 	if (q->pool == NULL)
 		return -ENOMEM;
 
@@ -2589,7 +2597,10 @@ void iscsi_pool_free(struct iscsi_pool *q)
 
 	for (i = 0; i < q->max; i++)
 		kfree(q->pool[i]);
-	kfree(q->pool);
+	if (q->is_pool_vmalloc)
+		vfree(q->pool);
+	else
+		kfree(q->pool);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 583875ea136a..e3421e527559 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -258,6 +258,7 @@ struct iscsi_pool {
 	struct kfifo		queue;		/* FIFO Queue */
 	void			**pool;		/* Pool of elements */
 	int			max;		/* Max number of elements */
+	bool			is_pool_vmalloc;
 };
 
 /* Session's states */
-- 
1.8.3.1
