From: vikas.chaudhary@qlogic.com
Subject: [PATCH 01/10] qla4xxx: update function qla4xxx_isr_decode_mailbox()
Date: Tue, 17 May 2011 23:17:03 -0700
Message-ID: <1305699432-13225-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50944 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754541Ab1ERGXr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 02:23:47 -0400
In-Reply-To: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Prasanna Mumbai <prasanna.mumbai@qlogic.com>

From: Prasanna Mumbai <prasanna.mumbai@qlogic.com>

- Added MBOX_ASTS_DUPLICATE_IP AEN handling.
- Update MBOX_AEN_REG_COUNT to 8 so that driver will save status
  of all mbox registers in aen_q

Signed-off-by: Prasanna Mumbai <prasanna.mumbai@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c |   13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 4757878..75edfba 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -115,7 +115,7 @@
 #define INVALID_ENTRY		0xFFFF
 #define MAX_CMDS_TO_RISC	1024
 #define MAX_SRBS		MAX_CMDS_TO_RISC
-#define MBOX_AEN_REG_COUNT	5
+#define MBOX_AEN_REG_COUNT	8
 #define MAX_INIT_RETRIES	5
 
 /*
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 2f40ac7..67d6651 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -541,6 +541,7 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 		case MBOX_ASTS_UNSOLICITED_PDU_RECEIVED:  /* Connection mode */
 		case MBOX_ASTS_IPSEC_SYSTEM_FATAL_ERROR:
 		case MBOX_ASTS_SUBNET_STATE_CHANGE:
+		case MBOX_ASTS_DUPLICATE_IP:
 			/* No action */
 			DEBUG2(printk("scsi%ld: AEN %04x\n", ha->host_no,
 				      mbox_status));
@@ -593,11 +594,13 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 					    mbox_sts[i];
 
 				/* print debug message */
-				DEBUG2(printk("scsi%ld: AEN[%d] %04x queued"
-				    " mb1:0x%x mb2:0x%x mb3:0x%x mb4:0x%x\n",
-				    ha->host_no, ha->aen_in, mbox_sts[0],
-				    mbox_sts[1], mbox_sts[2],  mbox_sts[3],
-				    mbox_sts[4]));
+				DEBUG2(printk("scsi%ld: AEN[%d] %04x queued "
+					      "mb1:0x%x mb2:0x%x mb3:0x%x "
+					      "mb4:0x%x mb5:0x%x\n",
+					      ha->host_no, ha->aen_in,
+					      mbox_sts[0], mbox_sts[1],
+					      mbox_sts[2], mbox_sts[3],
+					      mbox_sts[4], mbox_sts[5]));
 
 				/* advance pointer */
 				ha->aen_in++;
-- 
1.7.3.2

