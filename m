From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH] qla4xxx: Fix underrun/overrun conditions
Date: Wed, 06 Jun 2007 11:55:24 -0700
Message-ID: <1181156124.5728.4.camel@q-iscsi-upstream.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:48793 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbXFFS42 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2007 14:56:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

This patch fixes the code handling underrun and overrun conditions.

Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>

 drivers/scsi/qla4xxx/ql4_isr.c     |   57 ++++++++++++++++++++----------------
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index b47bd85..fa8a477 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -93,9 +93,29 @@ static void qla4xxx_status_entry(struct
 			break;
 		}
 
-		if (sts_entry->iscsiFlags &
-		    (ISCSI_FLAG_RESIDUAL_OVER|ISCSI_FLAG_RESIDUAL_UNDER))
+		if (sts_entry->iscsiFlags & ISCSI_FLAG_RESIDUAL_OVER) {
+			cmd->result = DID_ERROR << 16;
+			break;
+		}
+
+		if (sts_entry->iscsiFlags &ISCSI_FLAG_RESIDUAL_UNDER) {
 			scsi_set_resid(cmd, residual);
+			if (!scsi_status && ((scsi_bufflen(cmd) - residual)
+				< cmd->underflow)) {
+
+				cmd->result = DID_ERROR << 16;
+
+				DEBUG2(printk("scsi%ld:%d:%d:%d: %s: "
+					"Mid-layer Data underrun0, "
+					"xferlen = 0x%x, "
+					"residual = 0x%x\n", ha->host_no,
+					cmd->device->channel,
+					cmd->device->id,
+					cmd->device->lun, __func__,
+					scsi_bufflen(cmd), residual));
+				break;
+			}
+		}
 
 		cmd->result = DID_OK << 16 | scsi_status;
 
@@ -164,7 +184,8 @@ static void qla4xxx_status_entry(struct
 
 	case SCS_DATA_UNDERRUN:
 	case SCS_DATA_OVERRUN:
-		if (sts_entry->iscsiFlags & ISCSI_FLAG_RESIDUAL_OVER) {
+		if ((sts_entry->iscsiFlags & ISCSI_FLAG_RESIDUAL_OVER) ||
+			(sts_entry->completionStatus == SCS_DATA_OVERRUN)) {
 			DEBUG2(printk("scsi%ld:%d:%d:%d: %s: " "Data overrun, "
 				      "residual = 0x%x\n", ha->host_no,
 				      cmd->device->channel, cmd->device->id,
@@ -174,21 +195,7 @@ static void qla4xxx_status_entry(struct
 			break;
 		}
 
-		if ((sts_entry->iscsiFlags & ISCSI_FLAG_RESIDUAL_UNDER) == 0) {
-			/*
-			 * Firmware detected a SCSI transport underrun
-			 * condition
-			 */
-			scsi_set_resid(cmd, residual);
-			DEBUG2(printk("scsi%ld:%d:%d:%d: %s: UNDERRUN status "
-				      "detected, xferlen = 0x%x, residual = "
-				      "0x%x\n",
-				      ha->host_no, cmd->device->channel,
-				      cmd->device->id,
-				      cmd->device->lun, __func__,
-				      scsi_bufflen(cmd),
-				      residual));
-		}
+		scsi_set_resid(cmd, residual);
 
 		/*
 		 * If there is scsi_status, it takes precedense over
@@ -245,13 +252,13 @@ static void qla4xxx_status_entry(struct
 				 * will return DID_ERROR.
 				 */
 				DEBUG2(printk("scsi%ld:%d:%d:%d: %s: "
-					      "Mid-layer Data underrun, "
-					      "xferlen = 0x%x, "
-					      "residual = 0x%x\n", ha->host_no,
-					      cmd->device->channel,
-					      cmd->device->id,
-					      cmd->device->lun, __func__,
-					      scsi_bufflen(cmd), residual));
+					"Mid-layer Data underrun1, "
+					"xferlen = 0x%x, "
+					"residual = 0x%x\n", ha->host_no,
+					cmd->device->channel,
+					cmd->device->id,
+					cmd->device->lun, __func__,
+					scsi_bufflen(cmd), residual));
 
 				cmd->result = DID_ERROR << 16;
 			} else {
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index 2149069..ab984cb 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,5 +5,5 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.01.00-k7"
+#define QLA4XXX_DRIVER_VERSION	"5.01.00-k8"
 

