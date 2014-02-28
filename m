From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 1/2] megaraid_sas: fix a small problem when reading state value from hw
Date: Fri, 28 Feb 2014 15:54:36 +0100
Message-ID: <1393599277-30904-2-git-send-email-thenzl@redhat.com>
References: <1393599277-30904-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbaB1Ozh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Feb 2014 09:55:37 -0500
In-Reply-To: <1393599277-30904-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Sumit Saxena <sumit.saxena@lsi.com>, Adam Radford <aradford@gmail.com>

When the driver reads state values from the hw it might happen that
different values are read in subsequent reads and this can cause problems,
this may lead to a timeout in this function and a non working adapter.

Cc: Sumit Saxena <sumit.saxena@lsi.com>
Cc: Adam Radford <aradford@gmail.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index dc27598..1153ac4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2626,7 +2626,8 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 	u32 cur_state;
 	u32 abs_state, curr_abs_state;
 
-	fw_state = instance->instancet->read_fw_status_reg(instance->reg_set) & MFI_STATE_MASK;
+	abs_state = instance->instancet->read_fw_status_reg(instance->reg_set);
+	fw_state = abs_state & MFI_STATE_MASK;
 
 	if (fw_state != MFI_STATE_READY)
 		printk(KERN_INFO "megasas: Waiting for FW to come to ready"
@@ -2634,9 +2635,6 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 
 	while (fw_state != MFI_STATE_READY) {
 
-		abs_state =
-		instance->instancet->read_fw_status_reg(instance->reg_set);
-
 		switch (fw_state) {
 
 		case MFI_STATE_FAULT:
@@ -2772,10 +2770,8 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		 * The cur_state should not last for more than max_wait secs
 		 */
 		for (i = 0; i < (max_wait * 1000); i++) {
-			fw_state = instance->instancet->read_fw_status_reg(instance->reg_set) &
-					MFI_STATE_MASK ;
-		curr_abs_state =
-		instance->instancet->read_fw_status_reg(instance->reg_set);
+			curr_abs_state = instance->instancet->
+				read_fw_status_reg(instance->reg_set);
 
 			if (abs_state == curr_abs_state) {
 				msleep(1);
@@ -2791,6 +2787,9 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 			       "in %d secs\n", fw_state, max_wait);
 			return -ENODEV;
 		}
+
+		abs_state = curr_abs_state;
+		fw_state = curr_abs_state & MFI_STATE_MASK;
 	}
 	printk(KERN_INFO "megasas: FW now in Ready state\n");
 
-- 
1.8.3.1

