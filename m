From: vikas.chaudhary@qlogic.com
Subject: [PATCH 4/5] qla4xxx: Added print statements to display AENs
Date: Fri,  5 Apr 2013 07:06:09 -0400
Message-ID: <1365159970-17672-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:24413 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751780Ab3DEL3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Apr 2013 07:29:40 -0400
In-Reply-To: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Added print statements for following AENs:
1. MBOX_ASTS_INITIALIZATION_FAILED
2. MBOX_ASTS_SYSTEM_WARNING_EVENT
3. MBOX_ASTS_DCBX_CONF_CHANGE
4. MBOX_ASTS_IPV6_DEFAULT_ROUTER_CHANGED

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h  |  4 ++++
 drivers/scsi/qla4xxx/ql4_isr.c | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 5945829..c7b8892 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -493,12 +493,16 @@ struct qla_flt_region {
 #define MBOX_ASTS_SUBNET_STATE_CHANGE		0x8027
 #define MBOX_ASTS_RESPONSE_QUEUE_FULL		0x8028
 #define MBOX_ASTS_IP_ADDR_STATE_CHANGED		0x8029
+#define MBOX_ASTS_IPV6_DEFAULT_ROUTER_CHANGED	0x802A
 #define MBOX_ASTS_IPV6_PREFIX_EXPIRED		0x802B
 #define MBOX_ASTS_IPV6_ND_PREFIX_IGNORED	0x802C
 #define MBOX_ASTS_IPV6_LCL_PREFIX_IGNORED	0x802D
 #define MBOX_ASTS_ICMPV6_ERROR_MSG_RCVD		0x802E
+#define MBOX_ASTS_INITIALIZATION_FAILED		0x8031
+#define MBOX_ASTS_SYSTEM_WARNING_EVENT		0x8036
 #define MBOX_ASTS_IDC_COMPLETE			0x8100
 #define MBOX_ASTS_IDC_REQUEST_NOTIFICATION	0x8101
+#define MBOX_ASTS_DCBX_CONF_CHANGE		0x8110
 #define MBOX_ASTS_TXSCVR_INSERTED		0x8130
 #define MBOX_ASTS_TXSCVR_REMOVED		0x8131
 
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 7bef448..482287f 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -875,6 +875,43 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			}
 			break;
 
+		case MBOX_ASTS_IPV6_DEFAULT_ROUTER_CHANGED:
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "scsi%ld: AEN %04x, mbox_sts[1]=%08x, mbox_sts[2]=%08x, mbox_sts[3]=%08x, mbox_sts[4]=%08x mbox_sts[5]=%08x\n",
+					  ha->host_no, mbox_sts[0], mbox_sts[1],
+					  mbox_sts[2], mbox_sts[3], mbox_sts[4],
+					  mbox_sts[5]));
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "scsi%ld: AEN %04x Received IPv6 default router changed notification\n",
+					  ha->host_no, mbox_sts[0]));
+			break;
+
+		case MBOX_ASTS_INITIALIZATION_FAILED:
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "scsi%ld: AEN %04x, mbox_sts[3]=%08x\n",
+					  ha->host_no, mbox_sts[0],
+					  mbox_sts[3]));
+			break;
+
+		case MBOX_ASTS_SYSTEM_WARNING_EVENT:
+			DEBUG2(ql4_printk(KERN_WARNING, ha,
+					  "scsi%ld: AEN %04x, mbox_sts[1]=%08x, mbox_sts[2]=%08x, mbox_sts[3]=%08x, mbox_sts[4]=%08x mbox_sts[5]=%08x\n",
+					  ha->host_no, mbox_sts[0], mbox_sts[1],
+					  mbox_sts[2], mbox_sts[3], mbox_sts[4],
+					  mbox_sts[5]));
+			break;
+
+		case MBOX_ASTS_DCBX_CONF_CHANGE:
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "scsi%ld: AEN %04x, mbox_sts[1]=%08x, mbox_sts[2]=%08x, mbox_sts[3]=%08x, mbox_sts[4]=%08x mbox_sts[5]=%08x\n",
+					  ha->host_no, mbox_sts[0], mbox_sts[1],
+					  mbox_sts[2], mbox_sts[3], mbox_sts[4],
+					  mbox_sts[5]));
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "scsi%ld: AEN %04x Received DCBX configuration changed notification\n",
+					  ha->host_no, mbox_sts[0]));
+			break;
+
 		default:
 			DEBUG2(printk(KERN_WARNING
 				      "scsi%ld: AEN %04x UNKNOWN\n",
-- 
1.8.2.GIT

