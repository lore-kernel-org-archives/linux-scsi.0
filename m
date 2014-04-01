From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH RESEND] megaraid_sas: fix a small problem when reading state
 value from hw
Date: Tue, 01 Apr 2014 13:59:50 +0200
Message-ID: <533AAA36.6090208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbaDAL76 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Apr 2014 07:59:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: fj3207hq@aa.jp.fujitsu.com, "Saxena, Sumit" <Sumit.Saxena@lsi.com>, adam radford <aradford@gmail.com>, James Bottomley <jbottomley@parallels.com>

When the driver reads state values from the hw it might happen that
different values are read in subsequent reads and this can cause problems,
this may lead to a timeout in this function and a non working adapter.

Cc: Adam Radford <aradford@gmail.com>

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Shintaro Minemoto <fj3207hq@aa.jp.fujitsu.com>
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>
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

