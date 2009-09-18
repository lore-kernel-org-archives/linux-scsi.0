From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-2.6 PATCH 2/6] net: remove kfree_skb on a NULL pointer in
	af_netlink.c
Date: Thu, 17 Sep 2009 17:57:29 -0700
Message-ID: <20090918005729.25594.14261.stgit@localhost.localdomain>
References: <20090918005708.25594.52575.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090918005708.25594.52575.stgit@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, gospo@redhat.com, linux-scsi@vger.kernel.org, John Fastabend <john.r.fastabend@intel.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
List-Id: linux-scsi@vger.kernel.org

From: John Fastabend <john.r.fastabend@intel.com>

This removes a kfree_skb that is being called on a NULL pointer when
do_one_broadcast() is sucessful.  And moves the kfree_skb into
do_one_broadcast() for the error case.

Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 net/netlink/af_netlink.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4e673d2..9934847 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1021,6 +1021,8 @@ static inline int do_one_broadcast(struct sock *sk,
 		netlink_overrun(sk);
 		if (nlk->flags & NETLINK_BROADCAST_SEND_ERROR)
 			p->delivery_failure = 1;
+		kfree_skb(p->skb2);
+		p->skb2 = NULL;
 	} else {
 		p->congested |= val;
 		p->delivered = 1;
@@ -1065,8 +1067,6 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 pid,
 
 	netlink_unlock_table();
 
-	kfree_skb(info.skb2);
-
 	if (info.delivery_failure)
 		return -ENOBUFS;
 

