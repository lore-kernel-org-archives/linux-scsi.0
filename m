From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/8] iscsi_transport: Add support to display CHAP list and delete CHAP entry
Date: Mon, 27 Feb 2012 03:08:51 -0800
Message-ID: <1330340938-12893-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:56107
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516Ab2B0LWb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2012 06:22:31 -0500
In-Reply-To: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

For offload iSCSI like qla4xxx CHAP entries are stored in FLASH.
This patch adds support to list CHAP entries stored in FLASH and
delete specified CHAP entry from FLASH using iscsi tools.

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |  101 ++++++++++++++++++++++++++++++++++-
 include/scsi/iscsi_if.h             |   29 ++++++++++
 include/scsi/scsi_transport_iscsi.h |    4 ++
 3 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index a20f181..7bf0dec 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -727,10 +727,11 @@ static void iscsi_session_release(struct device *dev)
 	kfree(session);
 }
 
-static int iscsi_is_session_dev(const struct device *dev)
+int iscsi_is_session_dev(const struct device *dev)
 {
 	return dev->release == iscsi_session_release;
 }
+EXPORT_SYMBOL_GPL(iscsi_is_session_dev);
 
 static int iscsi_iter_session_fn(struct device *dev, void *data)
 {
@@ -2002,6 +2003,96 @@ iscsi_send_ping(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 }
 
 static int
+iscsi_get_chap(struct iscsi_transport *transport, struct nlmsghdr *nlh)
+{
+	struct iscsi_uevent *ev = NLMSG_DATA(nlh);
+	struct Scsi_Host *shost = NULL;
+	struct iscsi_chap_rec *chap_rec;
+	struct iscsi_internal *priv;
+	struct sk_buff *skbchap;
+	struct nlmsghdr *nlhchap;
+	struct iscsi_uevent *evchap;
+	uint32_t chap_buf_size;
+	int len, err = 0;
+	char *buf;
+
+	if (!transport->get_chap)
+		return -EINVAL;
+
+	priv = iscsi_if_transport_lookup(transport);
+	if (!priv)
+		return -EINVAL;
+
+	chap_buf_size = (ev->u.get_chap.num_entries * sizeof(*chap_rec));
+	len = NLMSG_SPACE(sizeof(*ev) + chap_buf_size);
+
+	shost = scsi_host_lookup(ev->u.get_chap.host_no);
+	if (!shost) {
+		printk(KERN_ERR "%s: failed. Cound not find host no %u\n",
+		       __func__, ev->u.get_chap.host_no);
+		return -ENODEV;
+	}
+
+	do {
+		int actual_size;
+
+		skbchap = alloc_skb(len, GFP_KERNEL);
+		if (!skbchap) {
+			printk(KERN_ERR "can not deliver chap: OOM\n");
+			err = -ENOMEM;
+			goto exit_get_chap;
+		}
+
+		nlhchap = __nlmsg_put(skbchap, 0, 0, 0,
+				      (len - sizeof(*nlhchap)), 0);
+		evchap = NLMSG_DATA(nlhchap);
+		memset(evchap, 0, sizeof(*evchap));
+		evchap->transport_handle = iscsi_handle(transport);
+		evchap->type = nlh->nlmsg_type;
+		evchap->u.get_chap.host_no = ev->u.get_chap.host_no;
+		evchap->u.get_chap.chap_tbl_idx = ev->u.get_chap.chap_tbl_idx;
+		evchap->u.get_chap.num_entries = ev->u.get_chap.num_entries;
+		buf = (char *) ((char *)evchap + sizeof(*evchap));
+		memset(buf, 0, chap_buf_size);
+
+		err = transport->get_chap(shost, ev->u.get_chap.chap_tbl_idx,
+				    &evchap->u.get_chap.num_entries, buf);
+
+		actual_size = NLMSG_SPACE(sizeof(*ev) + chap_buf_size);
+		skb_trim(skbchap, NLMSG_ALIGN(actual_size));
+		nlhchap->nlmsg_len = actual_size;
+
+		err = iscsi_multicast_skb(skbchap, ISCSI_NL_GRP_ISCSID,
+					  GFP_KERNEL);
+	} while (err < 0 && err != -ECONNREFUSED);
+
+exit_get_chap:
+	scsi_host_put(shost);
+	return err;
+}
+
+static int iscsi_delete_chap(struct iscsi_transport *transport,
+			     struct iscsi_uevent *ev)
+{
+	struct Scsi_Host *shost;
+	int err = 0;
+
+	if (!transport->delete_chap)
+		return -ENOSYS;
+
+	shost = scsi_host_lookup(ev->u.delete_chap.host_no);
+	if (!shost) {
+		printk(KERN_ERR "%s could not find host no %u\n",
+		       __func__, ev->u.delete_chap.host_no);
+		return -ENODEV;
+	}
+
+	err = transport->delete_chap(shost, ev->u.delete_chap.chap_tbl_idx);
+	scsi_host_put(shost);
+	return err;
+}
+
+static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 {
 	int err = 0;
@@ -2149,6 +2240,12 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 	case ISCSI_UEVENT_PING:
 		err = iscsi_send_ping(transport, ev);
 		break;
+	case ISCSI_UEVENT_GET_CHAP:
+		err = iscsi_get_chap(transport, nlh);
+		break;
+	case ISCSI_UEVENT_DELETE_CHAP:
+		err = iscsi_delete_chap(transport, ev);
+		break;
 	default:
 		err = -ENOSYS;
 		break;
@@ -2198,6 +2295,8 @@ iscsi_if_rx(struct sk_buff *skb)
 			 */
 			if (ev->type == ISCSI_UEVENT_GET_STATS && !err)
 				break;
+			if (ev->type == ISCSI_UEVENT_GET_CHAP && !err)
+				break;
 			err = iscsi_if_send_reply(group, nlh->nlmsg_seq,
 				nlh->nlmsg_type, 0, 0, ev, sizeof(*ev));
 		} while (err < 0 && err != -ECONNREFUSED && err != -ESRCH);
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 7ff9678..228a8af 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -61,6 +61,8 @@ enum iscsi_uevent_e {
 	ISCSI_UEVENT_PATH_UPDATE	= UEVENT_BASE + 20,
 	ISCSI_UEVENT_SET_IFACE_PARAMS	= UEVENT_BASE + 21,
 	ISCSI_UEVENT_PING		= UEVENT_BASE + 22,
+	ISCSI_UEVENT_GET_CHAP		= UEVENT_BASE + 23,
+	ISCSI_UEVENT_DELETE_CHAP	= UEVENT_BASE + 24,
 
 	/* up events */
 	ISCSI_KEVENT_RECV_PDU		= KEVENT_BASE + 1,
@@ -196,6 +198,18 @@ struct iscsi_uevent {
 			uint32_t	pid;	/* unique ping id associated
 						   with each ping request */
 		} iscsi_ping;
+		struct msg_get_chap {
+			uint32_t	host_no;
+			uint32_t	num_entries; /* number of CHAP entries
+						      * on request, number of
+						      * valid CHAP entries on
+						      * response */
+			uint16_t	chap_tbl_idx;
+		} get_chap;
+		struct msg_delete_chap {
+		       uint32_t        host_no;
+		       uint16_t        chap_tbl_idx;
+		} delete_chap;
 	} u;
 	union {
 		/* messages k -> u */
@@ -548,4 +562,19 @@ struct iscsi_stats {
 		__attribute__ ((aligned (sizeof(uint64_t))));
 };
 
+enum chap_type_e {
+	CHAP_TYPE_OUT,
+	CHAP_TYPE_IN,
+};
+
+#define ISCSI_CHAP_AUTH_NAME_MAX_LEN	256
+#define ISCSI_CHAP_AUTH_SECRET_MAX_LEN	256
+struct iscsi_chap_rec {
+	uint16_t chap_tbl_idx;
+	enum chap_type_e chap_type;
+	char username[ISCSI_CHAP_AUTH_NAME_MAX_LEN];
+	uint8_t password[ISCSI_CHAP_AUTH_SECRET_MAX_LEN];
+	uint8_t password_length;
+} __packed;
+
 #endif
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index aede513..53f0b36 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -147,6 +147,9 @@ struct iscsi_transport {
 	int (*send_ping) (struct Scsi_Host *shost, uint32_t iface_num,
 			  uint32_t iface_type, uint32_t payload_size,
 			  uint32_t pid, struct sockaddr *dst_addr);
+	int (*get_chap) (struct Scsi_Host *shost, uint16_t chap_tbl_idx,
+			 uint32_t *num_entries, char *buf);
+	int (*delete_chap) (struct Scsi_Host *shost, uint16_t chap_tbl_idx);
 };
 
 /*
@@ -325,5 +328,6 @@ extern void iscsi_destroy_iface(struct iscsi_iface *iface);
 extern struct iscsi_iface *iscsi_lookup_iface(int handle);
 extern char *iscsi_get_port_speed_name(struct Scsi_Host *shost);
 extern char *iscsi_get_port_state_name(struct Scsi_Host *shost);
+extern int iscsi_is_session_dev(const struct device *dev);
 
 #endif
-- 
1.7.9.1.265.gb3a76


