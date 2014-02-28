From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 2/2] megaraid_sas: remove unused variables
Date: Fri, 28 Feb 2014 15:54:37 +0100
Message-ID: <1393599277-30904-3-git-send-email-thenzl@redhat.com>
References: <1393599277-30904-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbaB1Ozl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Feb 2014 09:55:41 -0500
In-Reply-To: <1393599277-30904-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Sumit Saxena <sumit.saxena@lsi.com>, Adam Radford <aradford@gmail.com>

Some, almost not used variables removed.

Cc: Sumit Saxena <sumit.saxena@lsi.com>
Cc: Adam Radford <aradford@gmail.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 53 +++++++------------------------
 1 file changed, 11 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 1153ac4..806ac60 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2621,10 +2621,7 @@ int
 megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 {
 	int i;
-	u8 max_wait;
-	u32 fw_state;
-	u32 cur_state;
-	u32 abs_state, curr_abs_state;
+	u32 fw_state, abs_state, curr_abs_state;
 
 	abs_state = instance->instancet->read_fw_status_reg(instance->reg_set);
 	fw_state = abs_state & MFI_STATE_MASK;
@@ -2639,11 +2636,9 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 
 		case MFI_STATE_FAULT:
 			printk(KERN_DEBUG "megasas: FW in FAULT state!!\n");
-			if (ocr) {
-				max_wait = MEGASAS_RESET_WAIT_TIME;
-				cur_state = MFI_STATE_FAULT;
+			if (ocr)
 				break;
-			} else
+			else
 				return -ENODEV;
 
 		case MFI_STATE_WAIT_HANDSHAKE:
@@ -2667,8 +2662,6 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 					&instance->reg_set->inbound_doorbell);
 			}
 
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_WAIT_HANDSHAKE;
 			break;
 
 		case MFI_STATE_BOOT_MESSAGE_PENDING:
@@ -2686,8 +2679,6 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 				writel(MFI_INIT_HOTPLUG,
 					&instance->reg_set->inbound_doorbell);
 
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_BOOT_MESSAGE_PENDING;
 			break;
 
 		case MFI_STATE_OPERATIONAL:
@@ -2723,41 +2714,17 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 				writel(MFI_RESET_FLAGS,
 					&instance->reg_set->inbound_doorbell);
 
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_OPERATIONAL;
 			break;
 
 		case MFI_STATE_UNDEFINED:
 			/*
 			 * This state should not last for more than 2 seconds
 			 */
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_UNDEFINED;
-			break;
-
 		case MFI_STATE_BB_INIT:
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_BB_INIT;
-			break;
-
 		case MFI_STATE_FW_INIT:
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_FW_INIT;
-			break;
-
 		case MFI_STATE_FW_INIT_2:
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_FW_INIT_2;
-			break;
-
 		case MFI_STATE_DEVICE_SCAN:
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_DEVICE_SCAN;
-			break;
-
 		case MFI_STATE_FLUSH_CACHE:
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_FLUSH_CACHE;
 			break;
 
 		default:
@@ -2767,24 +2734,26 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		}
 
 		/*
-		 * The cur_state should not last for more than max_wait secs
+		 * The cur_abs_state should not last for more than
+		 * MEGASAS_RESET_WAIT_TIME secs
 		 */
-		for (i = 0; i < (max_wait * 1000); i++) {
+		for (i = 0; i < (MEGASAS_RESET_WAIT_TIME * 1000); i++) {
 			curr_abs_state = instance->instancet->
 				read_fw_status_reg(instance->reg_set);
 
-			if (abs_state == curr_abs_state) {
+			if (abs_state == curr_abs_state)
 				msleep(1);
-			} else
+			else
 				break;
 		}
 
 		/*
-		 * Return error if fw_state hasn't changed after max_wait
+		 * Return error if fw_state hasn't changed
+		 * after MEGASAS_RESET_WAIT_TIME
 		 */
 		if (curr_abs_state == abs_state) {
 			printk(KERN_DEBUG "FW state [%d] hasn't changed "
-			       "in %d secs\n", fw_state, max_wait);
+			       "in %d secs\n", fw_state, MEGASAS_RESET_WAIT_TIME);
 			return -ENODEV;
 		}
 
-- 
1.8.3.1

