From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 22/24] qla4xxx: Handle IPv6 AEN notifications
Date: Mon, 16 Dec 2013 06:49:52 -0500
Message-ID: <1387194594-29817-23-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:5075 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328Ab3LPMXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:39 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h  |  6 +++---
 drivers/scsi/qla4xxx/ql4_isr.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index a94593a..209853c 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -506,9 +506,9 @@ struct qla_flt_region {
 #define MBOX_ASTS_RESPONSE_QUEUE_FULL		0x8028
 #define MBOX_ASTS_IP_ADDR_STATE_CHANGED		0x8029
 #define MBOX_ASTS_IPV6_DEFAULT_ROUTER_CHANGED	0x802A
-#define MBOX_ASTS_IPV6_PREFIX_EXPIRED		0x802B
-#define MBOX_ASTS_IPV6_ND_PREFIX_IGNORED	0x802C
-#define MBOX_ASTS_IPV6_LCL_PREFIX_IGNORED	0x802D
+#define MBOX_ASTS_IPV6_LINK_MTU_CHANGE		0x802B
+#define MBOX_ASTS_IPV6_AUTO_PREFIX_IGNORED	0x802C
+#define MBOX_ASTS_IPV6_ND_LOCAL_PREFIX_IGNORED	0x802D
 #define MBOX_ASTS_ICMPV6_ERROR_MSG_RCVD		0x802E
 #define MBOX_ASTS_INITIALIZATION_FAILED		0x8031
 #define MBOX_ASTS_SYSTEM_WARNING_EVENT		0x8036
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index df3fd9b..bb34ef8 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -635,6 +635,18 @@ static void qla4xxx_update_ipaddr_state(struct scsi_qla_host *ha,
 	}
 }
 
+static void qla4xxx_default_router_changed(struct scsi_qla_host *ha,
+					   uint32_t *mbox_sts)
+{
+	memcpy(&ha->ip_config.ipv6_default_router_addr.s6_addr32[0],
+	       &mbox_sts[2], sizeof(uint32_t));
+	memcpy(&ha->ip_config.ipv6_default_router_addr.s6_addr32[1],
+	       &mbox_sts[3], sizeof(uint32_t));
+	memcpy(&ha->ip_config.ipv6_default_router_addr.s6_addr32[2],
+	       &mbox_sts[4], sizeof(uint32_t));
+	memcpy(&ha->ip_config.ipv6_default_router_addr.s6_addr32[3],
+	       &mbox_sts[5], sizeof(uint32_t));
+}
 
 /**
  * qla4xxx_isr_decode_mailbox - decodes mailbox status
@@ -802,6 +814,23 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			}
 			break;
 
+		case MBOX_ASTS_IPV6_LINK_MTU_CHANGE:
+		case MBOX_ASTS_IPV6_AUTO_PREFIX_IGNORED:
+		case MBOX_ASTS_IPV6_ND_LOCAL_PREFIX_IGNORED:
+			/* No action */
+			DEBUG2(ql4_printk(KERN_INFO, ha, "scsi%ld: AEN %04x\n",
+					  ha->host_no, mbox_status));
+			break;
+
+		case MBOX_ASTS_ICMPV6_ERROR_MSG_RCVD:
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "scsi%ld: AEN %04x, IPv6 ERROR, "
+					  "mbox_sts[1]=%08x, mbox_sts[2]=%08x, mbox_sts[3}=%08x, mbox_sts[4]=%08x mbox_sts[5]=%08x\n",
+					  ha->host_no, mbox_sts[0], mbox_sts[1],
+					  mbox_sts[2], mbox_sts[3], mbox_sts[4],
+					  mbox_sts[5]));
+			break;
+
 		case MBOX_ASTS_MAC_ADDRESS_CHANGED:
 		case MBOX_ASTS_DNS:
 			/* No action */
@@ -939,6 +968,7 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			DEBUG2(ql4_printk(KERN_INFO, ha,
 					  "scsi%ld: AEN %04x Received IPv6 default router changed notification\n",
 					  ha->host_no, mbox_sts[0]));
+			qla4xxx_default_router_changed(ha, mbox_sts);
 			break;
 
 		case MBOX_ASTS_IDC_TIME_EXTEND_NOTIFICATION:
-- 
1.8.2.GIT

