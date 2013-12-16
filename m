From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 06/24] qla4xxx: Rename ACB_STATE macros with IP_ADDRSTATE macros
Date: Mon, 16 Dec 2013 06:49:36 -0500
Message-ID: <1387194594-29817-7-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:25682 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387Ab3LPMYD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:24:03 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h  | 24 ++++++++----------------
 drivers/scsi/qla4xxx/ql4_isr.c | 14 +++++++-------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 8d4092b..e3242df 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -528,14 +528,14 @@ struct qla_flt_region {
 #define ACB_CONFIG_DISABLE		0x00
 #define ACB_CONFIG_SET			0x01
 
-/* ACB State Defines */
-#define ACB_STATE_UNCONFIGURED	0x00
-#define ACB_STATE_INVALID	0x01
-#define ACB_STATE_ACQUIRING	0x02
-#define ACB_STATE_TENTATIVE	0x03
-#define ACB_STATE_DEPRICATED	0x04
-#define ACB_STATE_VALID		0x05
-#define ACB_STATE_DISABLING	0x06
+/* ACB/IP Address State Defines */
+#define IP_ADDRSTATE_UNCONFIGURED	0
+#define IP_ADDRSTATE_INVALID		1
+#define IP_ADDRSTATE_ACQUIRING		2
+#define IP_ADDRSTATE_TENTATIVE		3
+#define IP_ADDRSTATE_DEPRICATED		4
+#define IP_ADDRSTATE_PREFERRED		5
+#define IP_ADDRSTATE_DISABLING		6
 
 /* FLASH offsets */
 #define FLASH_SEGMENT_IFCB	0x04000000
@@ -698,14 +698,6 @@ struct addr_ctrl_blk {
 	uint8_t ipv6_lnk_lcl_addr_state;/* 222 */
 	uint8_t ipv6_addr0_state;	/* 223 */
 	uint8_t ipv6_addr1_state;	/* 224 */
-#define IP_ADDRSTATE_UNCONFIGURED	0
-#define IP_ADDRSTATE_INVALID		1
-#define IP_ADDRSTATE_ACQUIRING		2
-#define IP_ADDRSTATE_TENTATIVE		3
-#define IP_ADDRSTATE_DEPRICATED		4
-#define IP_ADDRSTATE_PREFERRED		5
-#define IP_ADDRSTATE_DISABLING		6
-
 	uint8_t ipv6_dflt_rtr_state;    /* 225 */
 #define IPV6_RTRSTATE_UNKNOWN                   0
 #define IPV6_RTRSTATE_MANUAL                    1
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index a3c8bc7..e56c6b4 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -781,21 +781,21 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 						    mbox_sts[3]);
 			/* mbox_sts[2] = Old ACB state
 			 * mbox_sts[3] = new ACB state */
-			if ((mbox_sts[3] == ACB_STATE_VALID) &&
-			    ((mbox_sts[2] == ACB_STATE_TENTATIVE) ||
-			    (mbox_sts[2] == ACB_STATE_ACQUIRING))) {
+			if ((mbox_sts[3] == IP_ADDRSTATE_PREFERRED) &&
+			    ((mbox_sts[2] == IP_ADDRSTATE_TENTATIVE) ||
+			     (mbox_sts[2] == IP_ADDRSTATE_ACQUIRING))) {
 				set_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags);
-			} else if ((mbox_sts[3] == ACB_STATE_ACQUIRING) &&
-				   (mbox_sts[2] == ACB_STATE_VALID)) {
+			} else if ((mbox_sts[3] == IP_ADDRSTATE_ACQUIRING) &&
+				   (mbox_sts[2] == IP_ADDRSTATE_PREFERRED)) {
 				if (is_qla80XX(ha))
 					set_bit(DPC_RESET_HA_FW_CONTEXT,
 						&ha->dpc_flags);
 				else
 					set_bit(DPC_RESET_HA, &ha->dpc_flags);
-			} else if (mbox_sts[3] == ACB_STATE_DISABLING) {
+			} else if (mbox_sts[3] == IP_ADDRSTATE_DISABLING) {
 				ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ACB in disabling state\n",
 					   ha->host_no, __func__);
-			} else if ((mbox_sts[3] == ACB_STATE_UNCONFIGURED)) {
+			} else if (mbox_sts[3] == IP_ADDRSTATE_UNCONFIGURED) {
 				complete(&ha->disable_acb_comp);
 				ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ACB state unconfigured\n",
 					   ha->host_no, __func__);
-- 
1.8.2.GIT

