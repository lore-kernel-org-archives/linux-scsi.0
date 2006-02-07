From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 5/6] SCSI Userspace Target: the packet socket interface
 changes
Date: Tue, 07 Feb 2006 21:11:07 +0900
Message-ID: <20060207211107Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:60880 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S965039AbWBGMLJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 07:11:09 -0500
Received: from vcs3.rdh.ecl.ntt.co.jp (vcs3.rdh.ecl.ntt.co.jp [129.60.39.110])
	by tama5.ecl.ntt.co.jp (8.12.11/8.12.11) with ESMTP id k17CB8cg021176
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 21:11:08 +0900 (JST)
Received: from mfs3.rdh.ecl.ntt.co.jp (mfs3.rdh.ecl.ntt.co.jp [129.60.39.112])
	by vcs3.rdh.ecl.ntt.co.jp (8.12.11/8.12.11) with ESMTP id k17CB75m029766
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 21:11:07 +0900 (JST)
Received: from nttmail3.ecl.ntt.co.jp ([129.60.39.100])
	by mfs3.rdh.ecl.ntt.co.jp (8.12.11/8.12.11) with ESMTP id k17CB6H2007455
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 21:11:06 +0900 (JST)
Received: from dmailsv1.y.ecl.ntt.co.jp (dmailsv1.y.ecl.ntt.co.jp [129.60.53.14])
	by nttmail3.ecl.ntt.co.jp (8.12.11/8.12.11) with ESMTP id k17CB6gI014412
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 21:11:06 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Directly access the ring buffer provided by the packet socket mmapped IO.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---

 include/linux/if_packet.h |    2 +-
 include/net/af_packet.h   |    6 ++++++
 net/packet/af_packet.c    |   17 +++++++++++++++++
 3 files changed, 24 insertions(+), 1 deletions(-)
 create mode 100644 include/net/af_packet.h

1d699e6f31ee90015042731e16a7d795ae0d67be
diff --git a/include/linux/if_packet.h b/include/linux/if_packet.h
index b925585..c66d555 100644
--- a/include/linux/if_packet.h
+++ b/include/linux/if_packet.h
@@ -48,7 +48,7 @@ struct tpacket_stats
 
 struct tpacket_hdr
 {
-	unsigned long	tp_status;
+	unsigned int	tp_status;
 #define TP_STATUS_KERNEL	0
 #define TP_STATUS_USER		1
 #define TP_STATUS_COPY		2
diff --git a/include/net/af_packet.h b/include/net/af_packet.h
new file mode 100644
index 0000000..5a75e07
--- /dev/null
+++ b/include/net/af_packet.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_NET_AFPACKET_H
+#define __LINUX_NET_AFPACKET_H
+
+extern struct tpacket_hdr *packet_socket_frame(struct sock *sk);
+
+#endif
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 9db7dbd..b5fbd74 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -562,6 +562,23 @@ drop:
 }
 
 #ifdef CONFIG_PACKET_MMAP
+struct tpacket_hdr *packet_socket_frame(struct sock *sk)
+{
+	struct packet_sock *po;
+	struct tpacket_hdr *h;
+
+	po = pkt_sk(sk);
+	spin_lock(&sk->sk_receive_queue.lock);
+	h = (struct tpacket_hdr *) packet_lookup_frame(po, po->head);
+	if (h->tp_status)
+		h = ERR_PTR(-ENOBUFS);
+	else
+		po->head = po->head != po->frame_max ? po->head+1 : 0;
+	spin_unlock(&sk->sk_receive_queue.lock);
+	return h;
+}
+EXPORT_SYMBOL_GPL(packet_socket_frame);
+
 static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt, struct net_device *orig_dev)
 {
 	struct sock *sk;
-- 
1.1.3
