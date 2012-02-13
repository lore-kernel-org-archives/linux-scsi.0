From: vikas.chaudhary@qlogic.com
Subject: [PATCH 06/11] qla4xxx: Proper detection of firmware abort error code for ISP82xx
Date: Mon, 13 Feb 2012 18:30:45 +0530
Message-ID: <1329138050-1042-7-git-send-email-vikas.chaudhary@qlogic.com>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:11557
	"HELO magana.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751333Ab2BMNJl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 08:09:41 -0500
In-Reply-To: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    2 --
 drivers/scsi/qla4xxx/ql4_nx.h  |    1 +
 drivers/scsi/qla4xxx/ql4_os.c  |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index bfe6854..ec48dc3 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -150,8 +150,6 @@
 #define QL4_SESS_RECOVERY_TMO		120	/* iSCSI session */
 						/* recovery timeout */
 
-#define MSB(x) ((uint8_t)((uint16_t)(x) >> 8))
-#define LSW(x) ((uint16_t)(x))
 #define LSDW(x) ((u32)((u64)(x)))
 #define MSDW(x) ((u32)((((u64)(x)) >> 16) >> 16))
 
diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
index dc45ac9..dc7500e 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.h
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -623,6 +623,7 @@ struct crb_addr_pair {
 
 #define ADDR_ERROR	((unsigned long) 0xffffffff)
 #define MAX_CTL_CHECK	1000
+#define QLA82XX_FWERROR_CODE(code)	((code >> 8) & 0x1fffff)
 
 /***************************************************************************
  *		PCI related defines.
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3339cc1..2cd2077 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2165,7 +2165,7 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 				halt_status = qla4_8xxx_rd_32(ha,
 						QLA82XX_PEG_HALT_STATUS1);
 
-				if (LSW(MSB(halt_status)) == 0x67)
+				if (QLA82XX_FWERROR_CODE(halt_status) == 0x67)
 					ql4_printk(KERN_ERR, ha, "%s:"
 						   " Firmware aborted with"
 						   " error code 0x00006700."
-- 
1.7.8.247.g10f4e

