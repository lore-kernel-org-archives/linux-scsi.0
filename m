From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 4/5] qla4xxx: Added support to show port_state and port_speed in sysfs
Date: Thu, 19 Jan 2012 03:06:56 -0800
Message-ID: <1326971217-14323-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1326971217-14323-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:15938 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab2ASLWl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2012 06:22:41 -0500
In-Reply-To: <1326971217-14323-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h |    4 +++
 drivers/scsi/qla4xxx/ql4_os.c |   47 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 7825c14..5f82b5d 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -396,6 +396,10 @@ struct qla_flt_region {
 #define FW_ADDSTATE_DHCPv4_LEASE_EXPIRED	0x0008
 #define FW_ADDSTATE_LINK_UP			0x0010
 #define FW_ADDSTATE_ISNS_SVC_ENABLED		0x0020
+#define FW_ADDSTATE_LINK_SPEED_10MBPS		0x0100
+#define FW_ADDSTATE_LINK_SPEED_100MBPS		0x0200
+#define FW_ADDSTATE_LINK_SPEED_1GBPS		0x0400
+#define FW_ADDSTATE_LINK_SPEED_10GBPS		0x0800
 
 #define MBOX_CMD_GET_DATABASE_ENTRY_DEFAULTS	0x006B
 #define IPV6_DEFAULT_DDB_ENTRY			0x0001
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2bd9f1d..c1189e5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -206,6 +206,8 @@ static umode_t ql4_attr_is_visible(int param_type, int param)
 		case ISCSI_HOST_PARAM_HWADDRESS:
 		case ISCSI_HOST_PARAM_IPADDRESS:
 		case ISCSI_HOST_PARAM_INITIATOR_NAME:
+		case ISCSI_HOST_PARAM_PORT_STATE:
+		case ISCSI_HOST_PARAM_PORT_SPEED:
 			return S_IRUGO;
 		default:
 			return 0;
@@ -548,6 +550,43 @@ static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	return ret;
 }
 
+static void qla4xxx_set_port_speed(struct Scsi_Host *shost)
+{
+	struct scsi_qla_host *ha = to_qla_host(shost);
+	struct iscsi_cls_host *ihost = shost_priv(shost);
+	uint32_t speed = ISCSI_PORT_SPEED_UNKNOWN;
+
+	qla4xxx_get_firmware_state(ha);
+
+	switch (ha->addl_fw_state & 0x0F00) {
+	case FW_ADDSTATE_LINK_SPEED_10MBPS:
+		speed = ISCSI_PORT_SPEED_10MBPS;
+		break;
+	case FW_ADDSTATE_LINK_SPEED_100MBPS:
+		speed = ISCSI_PORT_SPEED_100MBPS;
+		break;
+	case FW_ADDSTATE_LINK_SPEED_1GBPS:
+		speed = ISCSI_PORT_SPEED_1GBPS;
+		break;
+	case FW_ADDSTATE_LINK_SPEED_10GBPS:
+		speed = ISCSI_PORT_SPEED_10GBPS;
+		break;
+	}
+	ihost->port_speed = speed;
+}
+
+static void qla4xxx_set_port_state(struct Scsi_Host *shost)
+{
+	struct scsi_qla_host *ha = to_qla_host(shost);
+	struct iscsi_cls_host *ihost = shost_priv(shost);
+	uint32_t state = ISCSI_PORT_STATE_DOWN;
+
+	if (test_bit(AF_LINK_UP, &ha->flags))
+		state = ISCSI_PORT_STATE_UP;
+
+	ihost->port_state = state;
+}
+
 static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 				  enum iscsi_host_param param, char *buf)
 {
@@ -564,6 +603,14 @@ static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
 		len = sprintf(buf, "%s\n", ha->name_string);
 		break;
+	case ISCSI_HOST_PARAM_PORT_STATE:
+		qla4xxx_set_port_state(shost);
+		len = sprintf(buf, "%s\n", iscsi_get_port_state_name(shost));
+		break;
+	case ISCSI_HOST_PARAM_PORT_SPEED:
+		qla4xxx_set_port_speed(shost);
+		len = sprintf(buf, "%s\n", iscsi_get_port_speed_name(shost));
+		break;
 	default:
 		return -ENOSYS;
 	}
-- 
1.7.8.rc2.3.g0911


