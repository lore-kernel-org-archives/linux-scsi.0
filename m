From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/7] qla4xxx: Disable generating pause frames in case of FW hung
Date: Wed, 11 Jan 2012 02:44:16 -0800
Message-ID: <1326278661-16368-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:45874 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516Ab2AKK7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2012 05:59:22 -0500
In-Reply-To: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Giridhar Malavali <giridhar.malavali@qlogic.com>

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

In case of FW hung  ISP82xx generates continuous pause frames
which causes switch to disable port.
Added fix to disable generating pause frames in case of
FW hung

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |    7 +++++++
 drivers/scsi/qla4xxx/ql4_nx.h  |    3 +++
 drivers/scsi/qla4xxx/ql4_os.c  |   10 ++++++++++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index c259378..e1e66a4 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -219,6 +219,13 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		ha->mailbox_timeout_count++;
 		mbx_sts[0] = (-1);
 		set_bit(DPC_RESET_HA, &ha->dpc_flags);
+		if (is_qla8022(ha)) {
+			ql4_printk(KERN_INFO, ha,
+				   "disabling pause transmit on port 0 & 1.\n");
+			qla4_8xxx_wr_32(ha, QLA82XX_CRB_NIU + 0x98,
+					CRB_NIU_XG_PAUSE_CTL_P0 |
+					CRB_NIU_XG_PAUSE_CTL_P1);
+		}
 		goto mbox_exit;
 	}
 
diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
index cfb2f2e..dc45ac9 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.h
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -39,6 +39,9 @@ enum {
 	QLA82XX_TEMP_PANIC	/* Fatal error, hardware has shut down. */
 };
 
+#define CRB_NIU_XG_PAUSE_CTL_P0		0x1
+#define CRB_NIU_XG_PAUSE_CTL_P1		0x8
+
 #define QLA82XX_HW_H0_CH_HUB_ADR	0x05
 #define QLA82XX_HW_H1_CH_HUB_ADR	0x0E
 #define QLA82XX_HW_H2_CH_HUB_ADR	0x03
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d816229..f47a337 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2080,6 +2080,11 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 		dev_state = qla4_8xxx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
 
 		if (qla4_8xxx_check_temp(ha)) {
+			ql4_printk(KERN_INFO, ha, "disabling pause"
+				   " transmit on port 0 & 1.\n");
+			qla4_8xxx_wr_32(ha, QLA82XX_CRB_NIU + 0x98,
+					CRB_NIU_XG_PAUSE_CTL_P0 |
+					CRB_NIU_XG_PAUSE_CTL_P1);
 			set_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags);
 			qla4xxx_wake_dpc(ha);
 		} else if (dev_state == QLA82XX_DEV_NEED_RESET &&
@@ -2099,6 +2104,11 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 		} else  {
 			/* Check firmware health */
 			if (qla4_8xxx_check_fw_alive(ha)) {
+				ql4_printk(KERN_INFO, ha, "disabling pause"
+					   " transmit on port 0 & 1.\n");
+				qla4_8xxx_wr_32(ha, QLA82XX_CRB_NIU + 0x98,
+						CRB_NIU_XG_PAUSE_CTL_P0 |
+						CRB_NIU_XG_PAUSE_CTL_P1);
 				halt_status = qla4_8xxx_rd_32(ha,
 						QLA82XX_PEG_HALT_STATUS1);
 
-- 
1.7.8.rc2.3.g0911


