From: michaelc@cs.wisc.edu
Subject: [PATCH 5/19] iscsi class: add iscsi host set param event
Date: Wed, 30 May 2007 12:57:11 -0500
Message-ID: <11805478511328-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbXE3R5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:44 -0400
In-Reply-To: <1180547849438-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The iscsi class uses the set_param event to set session
and connection params. This patch adds a set_host_param
so we can set host level values.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   29 ++++++++++++++++++++++++++++-
 include/scsi/iscsi_if.h             |    6 ++++++
 include/scsi/scsi_transport_iscsi.h |    3 +++
 3 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 5928760..3fd2da4 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -968,6 +968,30 @@ iscsi_tgt_dscvr(struct iscsi_transport *
 }
 
 static int
+iscsi_set_host_param(struct iscsi_transport *transport,
+		     struct iscsi_uevent *ev)
+{
+	char *data = (char*)ev + sizeof(*ev);
+	struct Scsi_Host *shost;
+	int err;
+
+	if (!transport->set_host_param)
+		return -ENOSYS;
+
+	shost = scsi_host_lookup(ev->u.set_host_param.host_no);
+	if (IS_ERR(shost)) {
+		printk(KERN_ERR "set_host_param could not find host no %u\n",
+		       ev->u.set_host_param.host_no);
+		return -ENODEV;
+	}
+
+	err = transport->set_host_param(shost, ev->u.set_host_param.param,
+					data, ev->u.set_host_param.len);
+	scsi_host_put(shost);
+	return err;
+}
+
+static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	int err = 0;
@@ -1058,8 +1082,11 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 	case ISCSI_UEVENT_TGT_DSCVR:
 		err = iscsi_tgt_dscvr(transport, ev);
 		break;
+	case ISCSI_UEVENT_SET_HOST_PARAM:
+		err = iscsi_set_host_param(transport, ev);
+		break;
 	default:
-		err = -EINVAL;
+		err = -ENOSYS;
 		break;
 	}
 
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index fba2117..3d0372e 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -48,6 +48,7 @@ enum iscsi_uevent_e {
 	ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT	= UEVENT_BASE + 14,
 
 	ISCSI_UEVENT_TGT_DSCVR		= UEVENT_BASE + 15,
+	ISCSI_UEVENT_SET_HOST_PARAM	= UEVENT_BASE + 16,
 
 	/* up events */
 	ISCSI_KEVENT_RECV_PDU		= KEVENT_BASE + 1,
@@ -136,6 +137,11 @@ struct iscsi_uevent {
 			 */
 			uint32_t	enable;
 		} tgt_dscvr;
+		struct msg_set_host_param {
+			uint32_t	host_no;
+			uint32_t	param; /* enum iscsi_host_param */
+			uint32_t	len;
+		} set_host_param;
 	} u;
 	union {
 		/* messages k -> u */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 902e69f..1ac450b 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -108,6 +108,9 @@ struct iscsi_transport {
 				  enum iscsi_param param, char *buf);
 	int (*get_host_param) (struct Scsi_Host *shost,
 				enum iscsi_host_param param, char *buf);
+	int (*set_host_param) (struct Scsi_Host *shost,
+			       enum iscsi_host_param param, char *buf,
+			       int buflen);
 	int (*send_pdu) (struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 			 char *data, uint32_t data_size);
 	void (*get_stats) (struct iscsi_cls_conn *conn,
-- 
1.4.1.1

