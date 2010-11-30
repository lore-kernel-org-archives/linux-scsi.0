From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/9] scsi: megaraid_sas - Change the time format during
 the driver online controller reset
Date: Tue, 30 Nov 2010 16:21:58 +0100
Message-ID: <4CF51696.4070102@redhat.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab0K3PWG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 10:22:06 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>

On 11/19/2010 05:33 PM, Yang, Bo wrote:
> Change the 30 seconds wait in OCR routine to ssleep and give more time to FW come out from failed status
>
> Signed-off-by Bo Yang<bo.yang@lsi.com>
>
> ---
> drivers/scsi/megaraid/megaraid_sas.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>   
> diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c
> new/drivers/scsi/megaraid/megaraid_sas.c ---
> old/drivers/scsi/megaraid/megaraid_sas.c 2010-11-10 04:39:48.000000000
> -0500 +++ new/drivers/scsi/megaraid/megaraid_sas.c 2010-11-14
> 15:32:31.000000000 -0500 @@ -2294,7 +2294,6 @@
> process_fw_state_change_wq(struct work_s { struct megasas_instance
> *instance = container_of(work, struct megasas_instance, work_init); -
> u32 wait; unsigned long flags; if (instance->adprecovery !=
> MEGASAS_ADPRESET_SM_INFAULT) { @@ -2320,10 +2319,8 @@
> process_fw_state_change_wq(struct work_s printk(KERN_NOTICE
> "megaraid_sas: HBA recovery state machine," "state 2 starting...\n");
> - /*waitting for about 20 second before start the second init*/ - for
> (wait = 0; wait < 30; wait++) { - msleep(1000); - } + /*waitting for
> about 30 second before start the second init*/ + ssleep(30); if
> (megasas_transition_to_ready(instance)) { printk(KERN_NOTICE
> "megaraid_sas:adapter not ready\n"); 
> @@ -2487,7 +2484,9 @@ megasas_transition_to_ready(struct megas case
> MFI_STATE_FAULT: printk(KERN_DEBUG "megasas: FW in FAULT state!!\n");
> - return -ENODEV; + max_wait = MEGASAS_RESET_WAIT_TIME; + cur_state =
> MFI_STATE_FAULT; + break; case MFI_STATE_WAIT_HANDSHAKE: /* 
the line 'max_wait = MEGASAS_RESET_WAIT_TIME;' is in every 'case' statement
the same, I'd suggest to remove it to save some lines, I hope also
this improves readability.
The change to ssleep is OK, I'd suggest to do the same in other cases too.
See an untested patch below (no functional change I hope).

Tomas

Signed-off-by Tomas Henzl<thenzl@redhat.com>

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index eb29d50..9dc5ff0 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -264,12 +264,10 @@ static int
 megasas_adp_reset_xscale(struct megasas_instance *instance,
 	struct megasas_register_set __iomem *regs)
 {
-	u32 i;
 	u32 pcidata;
-	writel(MFI_ADP_RESET, &regs->inbound_doorbell);
 
-	for (i = 0; i < 3; i++)
-		msleep(1000); /* sleep for 3 secs */
+	writel(MFI_ADP_RESET, &regs->inbound_doorbell);
+	ssleep(3); /* sleep for 3 secs */
 	pcidata  = 0;
 	pci_read_config_dword(instance->pdev, MFI_1068_PCSR_OFFSET, &pcidata);
 	printk(KERN_NOTICE "pcidata = %x\n", pcidata);
@@ -279,9 +277,7 @@ megasas_adp_reset_xscale(struct megasas_instance *instance,
 		pci_write_config_dword(instance->pdev,
 				MFI_1068_PCSR_OFFSET, pcidata);
 
-		for (i = 0; i < 2; i++)
-			msleep(1000); /* need to wait 2 secs again */
-
+		ssleep(2); /* need to wait 2 secs again */
 		pcidata  = 0;
 		pci_read_config_dword(instance->pdev,
 				MFI_1068_FW_HANDSHAKE_OFFSET, &pcidata);
@@ -2294,7 +2290,6 @@ process_fw_state_change_wq(struct work_struct *work)
 {
 	struct megasas_instance *instance =
 		container_of(work, struct megasas_instance, work_init);
-	u32 wait;
 	unsigned long flags;
 
 	if (instance->adprecovery != MEGASAS_ADPRESET_SM_INFAULT) {
@@ -2320,10 +2315,8 @@ process_fw_state_change_wq(struct work_struct *work)
 		printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine,"
 					"state 2 starting...\n");
 
-		/*waitting for about 20 second before start the second init*/
-		for (wait = 0; wait < 30; wait++) {
-			msleep(1000);
-		}
+		/* wait for about 30 second before the second init start */
+		ssleep(30);
 
 		if (megasas_transition_to_ready(instance)) {
 			printk(KERN_NOTICE "megaraid_sas:adapter not ready\n");
@@ -2466,7 +2459,6 @@ static int
 megasas_transition_to_ready(struct megasas_instance* instance)
 {
 	int i;
-	u8 max_wait;
 	u32 fw_state;
 	u32 cur_state;
 	u32 abs_state, curr_abs_state;
@@ -2487,7 +2479,8 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 		case MFI_STATE_FAULT:
 
 			printk(KERN_DEBUG "megasas: FW in FAULT state!!\n");
-			return -ENODEV;
+			cur_state = MFI_STATE_FAULT;
+			break;
 
 		case MFI_STATE_WAIT_HANDSHAKE:
 			/*
@@ -2507,7 +2500,6 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 					&instance->reg_set->inbound_doorbell);
 			}
 
-			max_wait = MEGASAS_RESET_WAIT_TIME;
 			cur_state = MFI_STATE_WAIT_HANDSHAKE;
 			break;
 
@@ -2522,7 +2514,6 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 				writel(MFI_INIT_HOTPLUG,
 					&instance->reg_set->inbound_doorbell);
 
-			max_wait = MEGASAS_RESET_WAIT_TIME;
 			cur_state = MFI_STATE_BOOT_MESSAGE_PENDING;
 			break;
 
@@ -2541,7 +2532,6 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 				writel(MFI_RESET_FLAGS,
 					&instance->reg_set->inbound_doorbell);
 
-			max_wait = MEGASAS_RESET_WAIT_TIME;
 			cur_state = MFI_STATE_OPERATIONAL;
 			break;
 
@@ -2549,32 +2539,26 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 			/*
 			 * This state should not last for more than 2 seconds
 			 */
-			max_wait = MEGASAS_RESET_WAIT_TIME;
 			cur_state = MFI_STATE_UNDEFINED;
 			break;
 
 		case MFI_STATE_BB_INIT:
-			max_wait = MEGASAS_RESET_WAIT_TIME;
 			cur_state = MFI_STATE_BB_INIT;
 			break;
 
 		case MFI_STATE_FW_INIT:
-			max_wait = MEGASAS_RESET_WAIT_TIME;
 			cur_state = MFI_STATE_FW_INIT;
 			break;
 
 		case MFI_STATE_FW_INIT_2:
-			max_wait = MEGASAS_RESET_WAIT_TIME;
 			cur_state = MFI_STATE_FW_INIT_2;
 			break;
 
 		case MFI_STATE_DEVICE_SCAN:
-			max_wait = MEGASAS_RESET_WAIT_TIME;
 			cur_state = MFI_STATE_DEVICE_SCAN;
 			break;
 
 		case MFI_STATE_FLUSH_CACHE:
-			max_wait = MEGASAS_RESET_WAIT_TIME;
 			cur_state = MFI_STATE_FLUSH_CACHE;
 			break;
 
@@ -2585,9 +2569,10 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 		}
 
 		/*
-		 * The cur_state should not last for more than max_wait secs
+		 * The cur_state should not last for more than
+		 * MEGASAS_RESET_WAIT_TIME secs
 		 */
-		for (i = 0; i < (max_wait * 1000); i++) {
+		for (i = 0; i < (MEGASAS_RESET_WAIT_TIME*1000); i++) {
 			fw_state = instance->instancet->read_fw_status_reg(instance->reg_set) &  
 					MFI_STATE_MASK ;
 		curr_abs_state =
@@ -2600,11 +2585,13 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 		}
 
 		/*
-		 * Return error if fw_state hasn't changed after max_wait
+		 * Return error if fw_state hasn't changed
+		 * after MEGASAS_RESET_WAIT_TIME
 		 */
 		if (curr_abs_state == abs_state) {
 			printk(KERN_DEBUG "FW state [%d] hasn't changed "
-			       "in %d secs\n", fw_state, max_wait);
+			       "in %d secs\n", fw_state,
+			       MEGASAS_RESET_WAIT_TIME);
 			return -ENODEV;
 		}
 	}





