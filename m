From: michaelc@cs.wisc.edu
Subject: [PATCH 4/7] qla4xxx: Removed residual from overrun debug print
Date: Thu, 20 Aug 2009 15:11:00 -0500
Message-ID: <1250799063-1843-5-git-send-email-michaelc@cs.wisc.edu>
References: <1250799063-1843-1-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-2-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-3-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbZHTULL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 16:11:11 -0400
In-Reply-To: <1250799063-1843-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Karen Higgins <karen.higgins@qlogic.com>

From: Mike Christie <michaelc@cs.wisc.edu>

The residual variable is only valid for udnerrun so do
not print it out for the overrun case.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
[Mike Christie: Fix coding style issues in patch]
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_isr.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 799120f..87ced2e 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -153,11 +153,11 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 	case SCS_DATA_UNDERRUN:
 	case SCS_DATA_OVERRUN:
 		if ((sts_entry->iscsiFlags & ISCSI_FLAG_RESIDUAL_OVER) ||
-			(sts_entry->completionStatus == SCS_DATA_OVERRUN)) {
-			DEBUG2(printk("scsi%ld:%d:%d:%d: %s: " "Data overrun, "
-				      "residual = 0x%x\n", ha->host_no,
+		     (sts_entry->completionStatus == SCS_DATA_OVERRUN)) {
+			DEBUG2(printk("scsi%ld:%d:%d:%d: %s: " "Data overrun\n",
+				      ha->host_no,
 				      cmd->device->channel, cmd->device->id,
-				      cmd->device->lun, __func__, residual));
+				      cmd->device->lun, __func__));
 
 			cmd->result = DID_ERROR << 16;
 			break;
-- 
1.6.2.2

