From: vikas.chaudhary@qlogic.com
Subject: [PATCH 07/11] scsi_transport_iscsi: added support for host event
Date: Mon, 13 Feb 2012 18:30:46 +0530
Message-ID: <1329138050-1042-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:49168
	"HELO magana.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1756609Ab2BMNJy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 08:09:54 -0500
In-Reply-To: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Added support to post kernel host event to application using
netlink interface.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |   31 +++++++++++++++++++++++++++++++
 include/scsi/iscsi_if.h             |   13 +++++++++++++
 include/scsi/scsi_transport_iscsi.h |    6 ++++++
 3 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 97832a2..1ad5860 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1476,6 +1476,37 @@ void iscsi_conn_login_event(struct iscsi_cls_conn *conn,
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_login_event);
 
+void iscsi_post_host_event(uint32_t host_no, struct iscsi_transport *transport,
+			   enum iscsi_host_event_code code, uint32_t data_size,
+			   uint8_t *data)
+{
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+	struct iscsi_uevent *ev;
+	int len = NLMSG_SPACE(sizeof(*ev) + data_size);
+
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (!skb) {
+		printk(KERN_ERR "gracefully ignored host event (%d):%d OOM\n",
+		       host_no, code);
+		return;
+	}
+
+	nlh = __nlmsg_put(skb, 0, 0, 0, (len - sizeof(*nlh)), 0);
+	ev = NLMSG_DATA(nlh);
+	ev->transport_handle = iscsi_handle(transport);
+	ev->type = ISCSI_KEVENT_HOST_EVENT;
+	ev->r.host_event.host_no = host_no;
+	ev->r.host_event.code = code;
+	ev->r.host_event.data_size = data_size;
+
+	if (data_size)
+		memcpy((char *)ev + sizeof(*ev), data, data_size);
+
+	iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(iscsi_post_host_event);
+
 static int
 iscsi_if_send_reply(uint32_t group, int seq, int type, int done, int multi,
 		    void *payload, int size)
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index e49b7c8..3aac991 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -72,6 +72,7 @@ enum iscsi_uevent_e {
 	ISCSI_KEVENT_PATH_REQ		= KEVENT_BASE + 7,
 	ISCSI_KEVENT_IF_DOWN		= KEVENT_BASE + 8,
 	ISCSI_KEVENT_CONN_LOGIN_STATE   = KEVENT_BASE + 9,
+	ISCSI_KEVENT_HOST_EVENT		= KEVENT_BASE + 10,
 };
 
 enum iscsi_tgt_dscvr {
@@ -80,6 +81,13 @@ enum iscsi_tgt_dscvr {
 	ISCSI_TGT_DSCVR_SLP		= 3,
 };
 
+enum iscsi_host_event_code {
+	ISCSI_EVENT_LINKUP		= 1,
+	ISCSI_EVENT_LINKDOWN,
+	/* must always be last */
+	ISCSI_EVENT_MAX,
+};
+
 struct iscsi_uevent {
 	uint32_t type; /* k/u events type */
 	uint32_t iferror; /* carries interface or resource errors */
@@ -222,6 +230,11 @@ struct iscsi_uevent {
 		struct msg_notify_if_down {
 			uint32_t	host_no;
 		} notify_if_down;
+		struct msg_host_event {
+			uint32_t	host_no;
+			uint32_t	data_size;
+			enum iscsi_host_event_code code;
+		} host_event;
 	} r;
 } __attribute__ ((aligned (sizeof(uint64_t))));
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index fa7ca4e..7f04731 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -166,6 +166,12 @@ extern int iscsi_offload_mesg(struct Scsi_Host *shost,
 			      struct iscsi_transport *transport, uint32_t type,
 			      char *data, uint16_t data_size);
 
+extern void iscsi_post_host_event(uint32_t host_no,
+				  struct iscsi_transport *transport,
+				  enum iscsi_host_event_code code,
+				  uint32_t data_size,
+				  uint8_t *data);
+
 struct iscsi_cls_conn {
 	struct list_head conn_list;	/* item in connlist */
 	void *dd_data;			/* LLD private data */
-- 
1.7.8.247.g10f4e

