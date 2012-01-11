From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/7] qla4xxx: Added error logging for firmware abort
Date: Wed, 11 Jan 2012 02:44:17 -0800
Message-ID: <1326278661-16368-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:35537 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886Ab2AKK7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2012 05:59:22 -0500
In-Reply-To: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

Added debug print with error code in case of firmware error.

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    2 ++
 drivers/scsi/qla4xxx/ql4_os.c  |    7 +++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index ec48dc3..bfe6854 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -150,6 +150,8 @@
 #define QL4_SESS_RECOVERY_TMO		120	/* iSCSI session */
 						/* recovery timeout */
 
+#define MSB(x) ((uint8_t)((uint16_t)(x) >> 8))
+#define LSW(x) ((uint16_t)(x))
 #define LSDW(x) ((u32)((u64)(x)))
 #define MSDW(x) ((u32)((((u64)(x)) >> 16) >> 16))
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f47a337..cb9dcd8 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2112,6 +2112,13 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 				halt_status = qla4_8xxx_rd_32(ha,
 						QLA82XX_PEG_HALT_STATUS1);
 
+				if (LSW(MSB(halt_status)) == 0x67)
+					ql4_printk(KERN_ERR, ha, "%s:"
+						   " Firmware aborted with"
+						   " error code 0x00006700."
+						   " Device is being reset\n",
+						   __func__);
+
 				/* Since we cannot change dev_state in interrupt
 				 * context, set appropriate DPC flag then wakeup
 				 * DPC */
-- 
1.7.8.rc2.3.g0911


