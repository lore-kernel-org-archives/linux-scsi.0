From: vikas.chaudhary@qlogic.com
Subject: [PATCH 09/11] iscsi_transport: Added Ping support
Date: Mon, 13 Feb 2012 18:30:48 +0530
Message-ID: <1329138050-1042-10-git-send-email-vikas.chaudhary@qlogic.com>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:5487
	"HELO magana.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1756574Ab2BMNJl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 08:09:41 -0500
In-Reply-To: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Added ping support for iscsi adapter, application can use this
interface for diagnostic network connection.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |   59 +++++++++++++++++++++++++++++++++++
 include/scsi/iscsi_if.h             |   17 ++++++++++
 include/scsi/scsi_transport_iscsi.h |    8 +++++
 3 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 1ad5860..c5f1581 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1507,6 +1507,35 @@ void iscsi_post_host_event(uint32_t host_no, struct iscsi_transport *transport,
 }
 EXPORT_SYMBOL_GPL(iscsi_post_host_event);
 
+void iscsi_ping_comp_event(uint32_t host_no, struct iscsi_transport *transport,
+			   uint32_t status, uint32_t pid, uint32_t data_size,
+			   uint8_t *data)
+{
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+	struct iscsi_uevent *ev;
+	int len = NLMSG_SPACE(sizeof(*ev) + data_size);
+
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (!skb) {
+		printk(KERN_ERR "gracefully ignored ping comp: OOM\n");
+		return;
+	}
+
+	nlh = __nlmsg_put(skb, 0, 0, 0, (len - sizeof(*nlh)), 0);
+	ev = NLMSG_DATA(nlh);
+	ev->transport_handle = iscsi_handle(transport);
+	ev->type = ISCSI_KEVENT_PING_COMP;
+	ev->r.ping_comp.host_no = host_no;
+	ev->r.ping_comp.status = status;
+	ev->r.ping_comp.pid = pid;
+	ev->r.ping_comp.data_size = data_size;
+	memcpy((char *)ev + sizeof(*ev), data, data_size);
+
+	iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(iscsi_ping_comp_event);
+
 static int
 iscsi_if_send_reply(uint32_t group, int seq, int type, int done, int multi,
 		    void *payload, int size)
@@ -1946,6 +1975,33 @@ iscsi_set_iface_params(struct iscsi_transport *transport,
 }
 
 static int
+iscsi_send_ping(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+{
+	struct Scsi_Host *shost;
+	struct sockaddr *dst_addr;
+	int err;
+
+	if (!transport->send_ping)
+		return -ENOSYS;
+
+	shost = scsi_host_lookup(ev->u.iscsi_ping.host_no);
+	if (!shost) {
+		printk(KERN_ERR "iscsi_ping could not find host no %u\n",
+		       ev->u.iscsi_ping.host_no);
+		return -ENODEV;
+	}
+
+	dst_addr = (struct sockaddr *)((char *)ev + sizeof(*ev));
+	err = transport->send_ping(shost, ev->u.iscsi_ping.iface_num,
+				   ev->u.iscsi_ping.iface_type,
+				   ev->u.iscsi_ping.payload_size,
+				   ev->u.iscsi_ping.pid,
+				   dst_addr);
+	scsi_host_put(shost);
+	return err;
+}
+
+static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 {
 	int err = 0;
@@ -2090,6 +2146,9 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		err = iscsi_set_iface_params(transport, ev,
 					     nlmsg_attrlen(nlh, sizeof(*ev)));
 		break;
+	case ISCSI_UEVENT_PING:
+		err = iscsi_send_ping(transport, ev);
+		break;
 	default:
 		err = -ENOSYS;
 		break;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 3aac991..7ff9678 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -60,6 +60,7 @@ enum iscsi_uevent_e {
 
 	ISCSI_UEVENT_PATH_UPDATE	= UEVENT_BASE + 20,
 	ISCSI_UEVENT_SET_IFACE_PARAMS	= UEVENT_BASE + 21,
+	ISCSI_UEVENT_PING		= UEVENT_BASE + 22,
 
 	/* up events */
 	ISCSI_KEVENT_RECV_PDU		= KEVENT_BASE + 1,
@@ -73,6 +74,7 @@ enum iscsi_uevent_e {
 	ISCSI_KEVENT_IF_DOWN		= KEVENT_BASE + 8,
 	ISCSI_KEVENT_CONN_LOGIN_STATE   = KEVENT_BASE + 9,
 	ISCSI_KEVENT_HOST_EVENT		= KEVENT_BASE + 10,
+	ISCSI_KEVENT_PING_COMP		= KEVENT_BASE + 11,
 };
 
 enum iscsi_tgt_dscvr {
@@ -186,6 +188,14 @@ struct iscsi_uevent {
 			uint32_t	host_no;
 			uint32_t	count;
 		} set_iface_params;
+		struct msg_iscsi_ping {
+			uint32_t        host_no;
+			uint32_t        iface_num;
+			uint32_t        iface_type;
+			uint32_t        payload_size;
+			uint32_t	pid;	/* unique ping id associated
+						   with each ping request */
+		} iscsi_ping;
 	} u;
 	union {
 		/* messages k -> u */
@@ -235,6 +245,13 @@ struct iscsi_uevent {
 			uint32_t	data_size;
 			enum iscsi_host_event_code code;
 		} host_event;
+		struct msg_ping_comp {
+			uint32_t        host_no;
+			uint32_t        status;
+			uint32_t	pid;	/* unique ping id associated
+						   with each ping request */
+			uint32_t        data_size;
+		} ping_comp;
 	} r;
 } __attribute__ ((aligned (sizeof(uint64_t))));
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 7f04731..aede513 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -144,6 +144,9 @@ struct iscsi_transport {
 				int param, char *buf);
 	umode_t (*attr_is_visible)(int param_type, int param);
 	int (*bsg_request)(struct bsg_job *job);
+	int (*send_ping) (struct Scsi_Host *shost, uint32_t iface_num,
+			  uint32_t iface_type, uint32_t payload_size,
+			  uint32_t pid, struct sockaddr *dst_addr);
 };
 
 /*
@@ -172,6 +175,11 @@ extern void iscsi_post_host_event(uint32_t host_no,
 				  uint32_t data_size,
 				  uint8_t *data);
 
+extern void iscsi_ping_comp_event(uint32_t host_no,
+				  struct iscsi_transport *transport,
+				  uint32_t status, uint32_t pid,
+				  uint32_t data_size, uint8_t *data);
+
 struct iscsi_cls_conn {
 	struct list_head conn_list;	/* item in connlist */
 	void *dd_data;			/* LLD private data */
-- 
1.7.8.247.g10f4e

