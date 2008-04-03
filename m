From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 12/21] qla2xxx: Check alternate 'reason' code during GPSC status handling.
Date: Thu,  3 Apr 2008 13:13:23 -0700
Message-ID: <1207253612-15538-12-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbYDCUNz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:55 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Some switches return 0x09 (Command not supported) as the reason
code for GPSC failure.  Check for this code, and disable
additional GPSC queries if found.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_gs.c  |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7e6b6da..3843eaa 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1611,6 +1611,7 @@ typedef struct fc_port {
 #define CT_ACCEPT_RESPONSE	0x8002
 #define CT_REASON_INVALID_COMMAND_CODE	0x01
 #define CT_REASON_CANNOT_PERFORM	0x09
+#define CT_REASON_COMMAND_UNSUPPORTED	0x0b
 #define CT_EXPL_ALREADY_REGISTERED	0x10
 
 #define NS_N_PORT_TYPE	0x01
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index e6578ce..980ccb3 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1841,8 +1841,10 @@ qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
 		    "GPSC")) != QLA_SUCCESS) {
 			/* FM command unsupported? */
 			if (rval == QLA_INVALID_COMMAND &&
-			    ct_rsp->header.reason_code ==
-			    CT_REASON_INVALID_COMMAND_CODE) {
+			    (ct_rsp->header.reason_code ==
+				CT_REASON_INVALID_COMMAND_CODE ||
+			     ct_rsp->header.reason_code ==
+				CT_REASON_COMMAND_UNSUPPORTED)) {
 				DEBUG2(printk("scsi(%ld): GPSC command "
 				    "unsupported, disabling query...\n",
 				    ha->host_no));
-- 
1.5.5.rc2

