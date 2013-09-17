From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 5/7] scsi_transport_iscsi: Add support to set CHAP entries
Date: Tue, 17 Sep 2013 07:54:48 -0400
Message-ID: <1379418890-1141-6-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:64288 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752450Ab3IQMZS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 08:25:18 -0400
In-Reply-To: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

For offload iSCSI like qla4xxx, CHAP entries are stored in adapter's
flash.
This patch adds support to add/update CHAP entries in adapter's flash
using iscsi tools, like Open-iSCSI.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |   26 ++++++++++++++++++++++++++
 include/scsi/iscsi_if.h             |   17 +++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |    1 +
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index e4a989f..63a6ca4 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2744,6 +2744,28 @@ exit_get_chap:
 	return err;
 }
 
+static int iscsi_set_chap(struct iscsi_transport *transport,
+			  struct iscsi_uevent *ev, uint32_t len)
+{
+	char *data = (char *)ev + sizeof(*ev);
+	struct Scsi_Host *shost;
+	int err = 0;
+
+	if (!transport->set_chap)
+		return -ENOSYS;
+
+	shost = scsi_host_lookup(ev->u.set_path.host_no);
+	if (!shost) {
+		pr_err("%s could not find host no %u\n",
+		       __func__, ev->u.set_path.host_no);
+		return -ENODEV;
+	}
+
+	err = transport->set_chap(shost, data, len);
+	scsi_host_put(shost);
+	return err;
+}
+
 static int iscsi_delete_chap(struct iscsi_transport *transport,
 			     struct iscsi_uevent *ev)
 {
@@ -3234,6 +3256,10 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 	case ISCSI_UEVENT_LOGOUT_FLASHNODE_SID:
 		err = iscsi_logout_flashnode_sid(transport, ev);
 		break;
+	case ISCSI_UEVENT_SET_CHAP:
+		err = iscsi_set_chap(transport, ev,
+				     nlmsg_attrlen(nlh, sizeof(*ev)));
+		break;
 	default:
 		err = -ENOSYS;
 		break;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 13d81c5..5d6ed6c 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -69,6 +69,7 @@ enum iscsi_uevent_e {
 	ISCSI_UEVENT_LOGIN_FLASHNODE	= UEVENT_BASE + 28,
 	ISCSI_UEVENT_LOGOUT_FLASHNODE	= UEVENT_BASE + 29,
 	ISCSI_UEVENT_LOGOUT_FLASHNODE_SID	= UEVENT_BASE + 30,
+	ISCSI_UEVENT_SET_CHAP		= UEVENT_BASE + 31,
 
 	/* up events */
 	ISCSI_KEVENT_RECV_PDU		= KEVENT_BASE + 1,
@@ -309,8 +310,16 @@ enum iscsi_param_type {
 	ISCSI_HOST_PARAM,	/* iscsi_host_param */
 	ISCSI_NET_PARAM,	/* iscsi_net_param */
 	ISCSI_FLASHNODE_PARAM,	/* iscsi_flashnode_param */
+	ISCSI_CHAP_PARAM,	/* iscsi_chap_param */
 };
 
+/* structure for minimalist usecase */
+struct iscsi_param_info {
+	uint32_t len;		/* Actual length of the param value */
+	uint16_t param;		/* iscsi param */
+	uint8_t value[0];	/* length sized value follows */
+} __packed;
+
 struct iscsi_iface_param_info {
 	uint32_t iface_num;	/* iface number, 0 - n */
 	uint32_t len;		/* Actual length of the param */
@@ -739,6 +748,14 @@ enum chap_type_e {
 	CHAP_TYPE_IN,
 };
 
+enum iscsi_chap_param {
+	ISCSI_CHAP_PARAM_INDEX,
+	ISCSI_CHAP_PARAM_CHAP_TYPE,
+	ISCSI_CHAP_PARAM_USERNAME,
+	ISCSI_CHAP_PARAM_PASSWORD,
+	ISCSI_CHAP_PARAM_PASSWORD_LEN
+};
+
 #define ISCSI_CHAP_AUTH_NAME_MAX_LEN	256
 #define ISCSI_CHAP_AUTH_SECRET_MAX_LEN	256
 struct iscsi_chap_rec {
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index d0f1602..fe7c8f3 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -152,6 +152,7 @@ struct iscsi_transport {
 	int (*get_chap) (struct Scsi_Host *shost, uint16_t chap_tbl_idx,
 			 uint32_t *num_entries, char *buf);
 	int (*delete_chap) (struct Scsi_Host *shost, uint16_t chap_tbl_idx);
+	int (*set_chap) (struct Scsi_Host *shost, void *data, int len);
 	int (*get_flashnode_param) (struct iscsi_bus_flash_session *fnode_sess,
 				    int param, char *buf);
 	int (*set_flashnode_param) (struct iscsi_bus_flash_session *fnode_sess,
-- 
1.7.1

