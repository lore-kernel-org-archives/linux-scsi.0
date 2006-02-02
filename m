From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/9] iscsi update: pass correct skb to skb_trim
Date: Wed, 01 Feb 2006 21:06:56 -0600
Message-ID: <1138849616.3456.34.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:29108 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423068AbWBBDHK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 22:07:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

>From da-x@monatomic.org:

Wrong skb is passed to skb_trim in iscsi_if_get_stats.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>


diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b618685..79ca29e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -680,8 +680,7 @@ iscsi_if_send_reply(int pid, int seq, in
 }
 
 static int
-iscsi_if_get_stats(struct iscsi_transport *transport, struct sk_buff *skb,
-		   struct nlmsghdr *nlh)
+iscsi_if_get_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 {
 	struct iscsi_uevent *ev = NLMSG_DATA(nlh);
 	struct iscsi_stats *stats;
@@ -732,7 +731,7 @@ iscsi_if_get_stats(struct iscsi_transpor
 					  stats->custom_length);
 		actual_size -= sizeof(*nlhstat);
 		actual_size = NLMSG_LENGTH(actual_size);
-		skb_trim(skb, NLMSG_ALIGN(actual_size));
+		skb_trim(skbstat, NLMSG_ALIGN(actual_size));
 		nlhstat->nlmsg_len = actual_size;
 
 		err = iscsi_unicast_skb(conn->z_pdu, skbstat);
@@ -923,7 +922,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_GET_STATS:
-		err = iscsi_if_get_stats(transport, skb, nlh);
+		err = iscsi_if_get_stats(transport, nlh);
 		break;
 	default:
 		err = -EINVAL;


