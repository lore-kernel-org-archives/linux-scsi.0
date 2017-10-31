From: Chris Leech <cleech@redhat.com>
Subject: [PATCH 1/9] iscsi: create per-net iscsi netlink kernel sockets
Date: Tue, 31 Oct 2017 15:40:56 -0700
Message-ID: <20171031224104.17735-2-cleech@redhat.com>
References: <20171031224104.17735-1-cleech@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933078AbdJaWla (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Oct 2017 18:41:30 -0400
In-Reply-To: <20171031224104.17735-1-cleech@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, open list <linux-kernel@vger.kernel.org>

Prepare iSCSI netlink to operate in multiple namespaces.

Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 67 +++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 7404d26895f5..0b23ba346cbe 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -26,6 +26,8 @@
 #include <linux/bsg-lib.h>
 #include <linux/idr.h>
 #include <net/tcp.h>
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
@@ -1601,7 +1603,11 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
 			       NULL,
 			       NULL);
 
-static struct sock *nls;
+struct iscsi_net {
+	struct sock *nls;
+};
+
+static int iscsi_net_id __read_mostly;
 static DEFINE_MUTEX(rx_queue_mutex);
 
 static LIST_HEAD(sesslist);
@@ -2317,11 +2323,23 @@ iscsi_if_transport_lookup(struct iscsi_transport *tt)
 }
 
 static int
-iscsi_multicast_skb(struct sk_buff *skb, uint32_t group, gfp_t gfp)
+iscsi_multicast_netns(struct net *net, struct sk_buff *skb,
+		      uint32_t group, gfp_t gfp)
 {
+	struct sock *nls;
+	struct iscsi_net *isn;
+
+	isn = net_generic(net, iscsi_net_id);
+	nls = isn->nls;
 	return nlmsg_multicast(nls, skb, 0, group, gfp);
 }
 
+static int
+iscsi_multicast_skb(struct sk_buff *skb, uint32_t group, gfp_t gfp)
+{
+	return iscsi_multicast_netns(&init_net, skb, group, gfp);
+}
+
 int iscsi_recv_pdu(struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 		   char *data, uint32_t data_size)
 {
@@ -4490,13 +4508,42 @@ int iscsi_unregister_transport(struct iscsi_transport *tt)
 }
 EXPORT_SYMBOL_GPL(iscsi_unregister_transport);
 
-static __init int iscsi_transport_init(void)
+static int __net_init iscsi_net_init(struct net *net)
 {
-	int err;
+	struct sock *nls;
+	struct iscsi_net *isn;
 	struct netlink_kernel_cfg cfg = {
 		.groups	= 1,
 		.input	= iscsi_if_rx,
 	};
+
+	nls = netlink_kernel_create(net, NETLINK_ISCSI, &cfg);
+	if (!nls)
+		return -ENOMEM;
+	isn = net_generic(net, iscsi_net_id);
+	isn->nls = nls;
+	return 0;
+}
+
+static void __net_exit iscsi_net_exit(struct net *net)
+{
+	struct iscsi_net *isn;
+
+	isn = net_generic(net, iscsi_net_id);
+	netlink_kernel_release(isn->nls);
+	isn->nls = NULL;
+}
+
+static struct pernet_operations iscsi_net_ops = {
+	.init = iscsi_net_init,
+	.exit = iscsi_net_exit,
+	.id   = &iscsi_net_id,
+	.size = sizeof(struct iscsi_net),
+};
+
+static __init int iscsi_transport_init(void)
+{
+	int err;
 	printk(KERN_INFO "Loading iSCSI transport class v%s.\n",
 		ISCSI_TRANSPORT_VERSION);
 
@@ -4530,8 +4577,8 @@ static __init int iscsi_transport_init(void)
 	if (err)
 		goto unregister_session_class;
 
-	nls = netlink_kernel_create(&init_net, NETLINK_ISCSI, &cfg);
-	if (!nls) {
+	err = register_pernet_subsys(&iscsi_net_ops);
+	if (err) {
 		err = -ENOBUFS;
 		goto unregister_flashnode_bus;
 	}
@@ -4539,13 +4586,13 @@ static __init int iscsi_transport_init(void)
 	iscsi_eh_timer_workq = create_singlethread_workqueue("iscsi_eh");
 	if (!iscsi_eh_timer_workq) {
 		err = -ENOMEM;
-		goto release_nls;
+		goto unregister_pernet_subsys;
 	}
 
 	return 0;
 
-release_nls:
-	netlink_kernel_release(nls);
+unregister_pernet_subsys:
+	unregister_pernet_subsys(&iscsi_net_ops);
 unregister_flashnode_bus:
 	bus_unregister(&iscsi_flashnode_bus);
 unregister_session_class:
@@ -4566,7 +4613,7 @@ static __init int iscsi_transport_init(void)
 static void __exit iscsi_transport_exit(void)
 {
 	destroy_workqueue(iscsi_eh_timer_workq);
-	netlink_kernel_release(nls);
+	unregister_pernet_subsys(&iscsi_net_ops);
 	bus_unregister(&iscsi_flashnode_bus);
 	transport_class_unregister(&iscsi_connection_class);
 	transport_class_unregister(&iscsi_session_class);
-- 
2.9.5
