From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-2.6 PATCH 4/6] net: fix nlmsg len size for skb when error bit is
	set.
Date: Thu, 17 Sep 2009 17:58:11 -0700
Message-ID: <20090918005811.25594.48046.stgit@localhost.localdomain>
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

Currently, the nlmsg->len field is not set correctly in  netlink_ack()
for ack messages that include the nlmsg of the error frame.  This
corrects the length field passed to __nlmsg_put to use the correct
payload size.

Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 net/netlink/af_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 9934847..aa74011 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1788,7 +1788,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err)
 	}
 
 	rep = __nlmsg_put(skb, NETLINK_CB(in_skb).pid, nlh->nlmsg_seq,
-			  NLMSG_ERROR, sizeof(struct nlmsgerr), 0);
+			  NLMSG_ERROR, payload, 0);
 	errmsg = nlmsg_data(rep);
 	errmsg->error = err;
 	memcpy(&errmsg->msg, nlh, err ? nlh->nlmsg_len : sizeof(*nlh));

