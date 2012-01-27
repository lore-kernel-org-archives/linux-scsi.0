From: michaelc@cs.wisc.edu
Subject: [PATCH 1/3] iscsi: fix setting of pid from netlink skb
Date: Thu, 26 Jan 2012 21:13:09 -0600
Message-ID: <1327633991-2615-2-git-send-email-michaelc@cs.wisc.edu>
References: <1327633991-2615-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab2A0DEo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2012 22:04:44 -0500
In-Reply-To: <1327633991-2615-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

NETLINK_CREDS's pid now returns 0, so I guess we are supposed to
be using NETLINK_CB. This changed while the patch to export the
pid was getting merged upstream, so it was not noticed until both
the network and iscsi changes were in the same tree.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index cfd4914..e3e3c7d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1941,7 +1941,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_CREATE_SESSION:
 		err = iscsi_if_create_session(priv, ep, ev,
-					      NETLINK_CREDS(skb)->pid,
+					      NETLINK_CB(skb).pid,
 					      ev->u.c_session.initial_cmdsn,
 					      ev->u.c_session.cmds_max,
 					      ev->u.c_session.queue_depth);
@@ -1954,7 +1954,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		}
 
 		err = iscsi_if_create_session(priv, ep, ev,
-					NETLINK_CREDS(skb)->pid,
+					NETLINK_CB(skb).pid,
 					ev->u.c_bound_session.initial_cmdsn,
 					ev->u.c_bound_session.cmds_max,
 					ev->u.c_bound_session.queue_depth);
-- 
1.7.6

