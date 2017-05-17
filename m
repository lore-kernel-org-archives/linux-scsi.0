From: Kyle Fortin <kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] scsi: libiscsi: use kvzalloc for iscsi_pool_init
Date: Wed, 17 May 2017 16:21:54 -0400
Message-ID: <1495052514-3327-1-git-send-email-kyle.fortin@oracle.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBDQYRBHCWYHBB3MF6PEAKGQESNDPSIQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: lduncan-IBi9RG/b67k@public.gmane.org, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: joe.slember-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, lance.hartmann-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Kyle Fortin <kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

iscsiadm session login can fail with the following error:

iscsiadm: Could not login to [iface: default, target: iqn.1986-03.com...
iscsiadm: initiator reported error (9 - internal error)

When /etc/iscsi/iscsid.conf sets node.session.cmds_max = 4096, it results
in 64K-sized kmallocs per session.  A system under fragmented slab
pressure may not have any 64K objects available and fail iscsiadm session
login. Even though memory objects of a smaller size are available, the
large order allocation ends up failing.

The kernel prints a warning and does dump_stack, like below:

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

Use kvzalloc for iscsi_pool in iscsi_pool_init.

Signed-off-by: Kyle Fortin <kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Kyle Fortin <kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Joseph Slember <joe.slember-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Lance Hartmann <lance.hartmann-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/libiscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index dd6828f..42381ad 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2556,7 +2556,7 @@ int iscsi_eh_recover_target(struct scsi_cmnd *sc)
 	 * the array. */
 	if (items)
 		num_arrays++;
-	q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
+	q->pool = kvzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
 	if (q->pool == NULL)
 		return -ENOMEM;
 
@@ -2590,7 +2590,7 @@ void iscsi_pool_free(struct iscsi_pool *q)
 
 	for (i = 0; i < q->max; i++)
 		kfree(q->pool[i]);
-	kfree(q->pool);
+	kvfree(q->pool);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
-- 
1.7.1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
