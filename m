From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/9] iscsi: add target discvery event to transport class
Date: Wed, 28 Jun 2006 12:00:22 -0500
Message-ID: <1151514022.11553.45.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:27059 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932856AbWF1RBt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 13:01:49 -0400
Received: from [192.168.0.7] (c-69-180-139-167.hsd1.mn.comcast.net [69.180.139.167])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k5SH1SLE019919
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 12:01:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Patch from david.somayajulu@qlogic.com:

Add target discovery event. We may have a setup where the iscsi traffic
is on a different netowrk than the other network traffic. In this case
we will want to do discovery though the iscsi card. This patch adds
a event to the transport class that can be used by hw iscsi cards that
support this.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 5569fdc..99e76d4 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -978,6 +978,21 @@ iscsi_if_transport_ep(struct iscsi_trans
 }
 
 static int
+iscsi_tgt_dscvr(struct iscsi_transport *transport,
+		struct iscsi_uevent *ev)
+{
+	struct sockaddr *dst_addr;
+
+	if (!transport->tgt_dscvr)
+		return -EINVAL;
+
+	dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
+	return transport->tgt_dscvr(ev->u.tgt_dscvr.type,
+				    ev->u.tgt_dscvr.host_no,
+				    ev->u.tgt_dscvr.enable, dst_addr);
+}
+
+static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	int err = 0;
@@ -1065,6 +1080,9 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		err = iscsi_if_transport_ep(transport, ev, nlh->nlmsg_type);
 		break;
+	case ISCSI_UEVENT_TGT_DSCVR:
+		err = iscsi_tgt_dscvr(transport, ev);
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 253797c..8813f0f 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -47,12 +47,20 @@ enum iscsi_uevent_e {
 	ISCSI_UEVENT_TRANSPORT_EP_POLL		= UEVENT_BASE + 13,
 	ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT	= UEVENT_BASE + 14,
 
+	ISCSI_UEVENT_TGT_DSCVR		= UEVENT_BASE + 15,
+
 	/* up events */
 	ISCSI_KEVENT_RECV_PDU		= KEVENT_BASE + 1,
 	ISCSI_KEVENT_CONN_ERROR		= KEVENT_BASE + 2,
 	ISCSI_KEVENT_IF_ERROR		= KEVENT_BASE + 3,
 };
 
+enum iscsi_tgt_dscvr {
+	ISCSI_TGT_DSCVR_SEND_TARGETS	= 1,
+	ISCSI_TGT_DSCVR_ISNS		= 2,
+	ISCSI_TGT_DSCVR_SLP		= 3,
+};
+
 struct iscsi_uevent {
 	uint32_t type; /* k/u events type */
 	uint32_t iferror; /* carries interface or resource errors */
@@ -116,6 +124,17 @@ struct iscsi_uevent {
 		struct msg_transport_disconnect {
 			uint64_t	ep_handle;
 		} ep_disconnect;
+		struct msg_tgt_dscvr {
+			enum iscsi_tgt_dscvr	type;
+			uint32_t	host_no;
+			/*
+ 			 * enable = 1 to establish a new connection
+			 * with the server. enable = 0 to disconnect
+			 * from the server. Used primarily to switch
+			 * from one iSNS server to another.
+			 */
+			uint32_t	enable;
+		} tgt_dscvr;
 	} u;
 	union {
 		/* messages k -> u */
@@ -141,6 +160,24 @@ struct iscsi_uevent {
 		struct msg_transport_connect_ret {
 			uint64_t	handle;
 		} ep_connect_ret;
+		struct msg_tgt_dscvr_ret {
+			/*
+			 * session/connection pair used to reference
+			 * the connection to server
+			 */
+			uint32_t	sid;
+			uint32_t	cid;
+			union {
+				struct isns {
+					/* port # for conn to iSNS server */
+					uint16_t isns_port;
+					/* listening port to receive SCNs */
+					uint16_t scn_port;
+					/* listening port to receive ESIs */
+					uint16_t esi_port;
+				} isns_attrib;
+			} u;
+		} tgt_dscvr_ret;
 	} r;
 } __attribute__ ((aligned (sizeof(uint64_t))));
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index b684426..b95151a 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -127,6 +127,8 @@ struct iscsi_transport {
 			   uint64_t *ep_handle);
 	int (*ep_poll) (uint64_t ep_handle, int timeout_ms);
 	void (*ep_disconnect) (uint64_t ep_handle);
+	int (*tgt_dscvr) (enum iscsi_tgt_dscvr type, uint32_t host_no,
+			  uint32_t enable, struct sockaddr *dst_addr);
 };
 
 /*


