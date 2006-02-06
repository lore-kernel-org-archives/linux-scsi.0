From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH RFC 0/3] SCSI Userspace Target
Date: Mon, 06 Feb 2006 11:54:39 +0900
Message-ID: <20060206115439G.fujita.tomonori@lab.ntt.co.jp>
References: <1138157882.11692.31.camel@max>
	<20060125174649.GH14225@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:56213 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1750832AbWBFCzC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Feb 2006 21:55:02 -0500
In-Reply-To: <20060125174649.GH14225@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH RFC 0/3] SCSI Userspace Target
Date: Wed, 25 Jan 2006 12:46:49 -0500

> > As the email subject hints, the goal of the project is to push most of
> > the target code to userspace. The only parts we kept in the kernel were
> > for transferring data between the LLD and userpsace and the netlink
> > interface. We included the relevant parts of a software iscsi target as
> > an example.

(snip)

> One random comment:  Take a look at the mmap'd ring buffer interface
> provided by mmap'ing the packet socket.  That's the ideal async
> interface, since that's fully async, very close to hardware reality.

Thanks a lot. Yes, that's really nice. We've replaced some of our
netlink code with the packet socket interface.

We just access the ring buffer directly with the following changes to
the packet socket code. Is it OK?

One more question. Is there any interface like mmap'ing the packet
socket that can be used for user -> kernel communication?


diff --git a/include/net/af_packet.h b/include/net/af_packet.h
new file mode 100644
index 0000000..e280e7c
--- /dev/null
+++ b/include/net/af_packet.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_NET_AFPACKET_H
+#define __LINUX_NET_AFPACKET_H
+
+extern void *packet_frame(struct sock *sk);
+
+#endif
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 9db7dbd..aee86cd 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -562,6 +562,24 @@ drop:
 }
 
 #ifdef CONFIG_PACKET_MMAP
+void *packet_frame(struct sock *sk)
+{
+	struct packet_sock *po;
+	struct tpacket_hdr *h;
+	int err;
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
+EXPORT_SYMBOL_GPL(packet_frame);
+
 static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt, struct net_device *orig_dev)
 {
 	struct sock *sk;
