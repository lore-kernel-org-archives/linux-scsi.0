From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] megaraid_sas: some corrections in megasas_transition_to_ready
Date: Mon, 28 Feb 2011 15:15:22 +0100
Message-ID: <4D6BADFA.8050005@redhat.com>
References: <4D67D739.3020002@redhat.com> <AANLkTikfiYnzUJ3w89KyVShWRNKR6gb0G7g240g=GGSP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab1B1OP1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2011 09:15:27 -0500
In-Reply-To: <AANLkTikfiYnzUJ3w89KyVShWRNKR6gb0G7g240g=GGSP@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Yang, Bo" <Bo.Yang@lsi.com>

On 02/25/2011 11:37 PM, adam radford wrote:
> On Fri, Feb 25, 2011 at 8:22 AM, Tomas Henzl <thenzl@redhat.com> wrote:
>   
>> Hi,
>>
>> megasas_transition_to_ready seems to use some code which isn't needed.
>> I removed some variables, I hope this makes the code easier thus better readable.
>> max_wait - the assigned value is the same in al cases
>>     
> Tomas,
>
> Your patch removes the ability to easily assign different wait times
> for each controller state.  Although we are currently using a maximum
> of 180 seconds for all states, there is talk within LSI (at this very
> moment) about altering how long we wait in each state.
>   
I added the max_wait back for you, if you decide to differentiate the wait times
you can simply add a corresponding line to a case statement :)
If you wanted to say that you are going to rewrite this function, it's OK
for me to drop this patch.
In your original code you read the value of read_fw_status_reg every time twice and assign
it to different variables - I think that when the hw state changes in between that it will
_not_ cause problems in this function, but it looks strange.
...
megasas_transition_to_ready seems to use some code which isn't needed.
I removed some variables, I hope this makes the code easier thus better readable.
max_wait - the assigned value is the same in al cases, the value is now assigned outside the switch
cur_state - values are assigned but never used 
also removed some extensive calls to read_fw_status_reg - it seems useless.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 07254aa..14e6f33 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1830,13 +1830,12 @@ static irqreturn_t megasas_isr(int irq, void *devp)
 static int
 megasas_transition_to_ready(struct megasas_instance* instance)
 {
-	int i;
-	u8 max_wait;
+	int i, max_wait;
 	u32 fw_state;
-	u32 cur_state;
 	u32 abs_state, curr_abs_state;
 
-	fw_state = instance->instancet->read_fw_status_reg(instance->reg_set) & MFI_STATE_MASK;
+	abs_state = instance->instancet->read_fw_status_reg(instance->reg_set);
+	fw_state = abs_state & MFI_STATE_MASK;
 
 	if (fw_state != MFI_STATE_READY)
  		printk(KERN_INFO "megasas: Waiting for FW to come to ready"
@@ -1844,16 +1843,12 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 
 	while (fw_state != MFI_STATE_READY) {
 
-		abs_state =
-		instance->instancet->read_fw_status_reg(instance->reg_set);
+		max_wait = MEGASAS_RESET_WAIT_TIME;
 
 		switch (fw_state) {
 
 		case MFI_STATE_FAULT:
-
 			printk(KERN_DEBUG "megasas: FW in FAULT state!!\n");
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_FAULT;
 			break;
 
 		case MFI_STATE_WAIT_HANDSHAKE:
@@ -1873,9 +1868,6 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 				    MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
 					&instance->reg_set->inbound_doorbell);
 			}
-
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_WAIT_HANDSHAKE;
 			break;
 
 		case MFI_STATE_BOOT_MESSAGE_PENDING:
@@ -1888,9 +1880,6 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 			} else
 				writel(MFI_INIT_HOTPLUG,
 					&instance->reg_set->inbound_doorbell);
-
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_BOOT_MESSAGE_PENDING;
 			break;
 
 		case MFI_STATE_OPERATIONAL:
@@ -1907,42 +1896,14 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 			} else
 				writel(MFI_RESET_FLAGS,
 					&instance->reg_set->inbound_doorbell);
-
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_OPERATIONAL;
 			break;
 
 		case MFI_STATE_UNDEFINED:
-			/*
-			 * This state should not last for more than 2 seconds
-			 */
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
@@ -1954,29 +1915,29 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 		/*
 		 * The cur_state should not last for more than max_wait secs
 		 */
-		for (i = 0; i < (max_wait * 1000); i++) {
-			fw_state = instance->instancet->read_fw_status_reg(instance->reg_set) &  
-					MFI_STATE_MASK ;
-		curr_abs_state =
-		instance->instancet->read_fw_status_reg(instance->reg_set);
+		for (i = 0; i < max_wait * 1000; i++) {
+			curr_abs_state =
+				instance->instancet->read_fw_status_reg(instance->reg_set);
 
-			if (abs_state == curr_abs_state) {
+			if (abs_state == curr_abs_state)
 				msleep(1);
-			} else
+			else
 				break;
 		}
-
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
-	};
- 	printk(KERN_INFO "megasas: FW now in Ready state\n");
+		abs_state = curr_abs_state;
+		fw_state = abs_state & MFI_STATE_MASK;
+	}
 
+ 	printk(KERN_INFO "megasas: FW now in Ready state\n");
 	return 0;
 }
 






