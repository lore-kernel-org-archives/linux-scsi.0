From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 05/19] aacraid: Remove reset support from check_health
Date: Wed, 10 May 2017 09:39:39 -0700
Message-ID: <1494434393-17261-6-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0040.outbound.protection.outlook.com ([104.47.33.40]:41712
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751585AbdEJGYL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 May 2017 02:24:11 -0400
In-Reply-To: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

Check health does not need to reset the ctrl but just return the
controller health status.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <david.carroll@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/commsup.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 47068b2..3299012 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1775,8 +1775,6 @@ int aac_check_health(struct aac_dev * aac)
 	int BlinkLED;
 	unsigned long time_now, flagv = 0;
 	struct list_head * entry;
-	struct Scsi_Host * host;
-	int bled;
 
 	/* Extending the scope of fib_lock slightly to protect aac->in_reset */
 	if (spin_trylock_irqsave(&aac->fib_lock, flagv) == 0)
@@ -1887,19 +1885,6 @@ int aac_check_health(struct aac_dev * aac)
 
 	printk(KERN_ERR "%s: Host adapter BLINK LED 0x%x\n", aac->name, BlinkLED);
 
-	if (!aac_check_reset || ((aac_check_reset == 1) &&
-		(aac->supplement_adapter_info.supported_options2 &
-			AAC_OPTION_IGNORE_RESET)))
-		goto out;
-	host = aac->scsi_host_ptr;
-	if (aac->thread->pid != current->pid)
-		spin_lock_irqsave(host->host_lock, flagv);
-	bled = aac_check_reset != 1 ? 1 : 0;
-	_aac_reset_adapter(aac, bled, IOP_HWSOFT_RESET);
-	if (aac->thread->pid != current->pid)
-		spin_unlock_irqrestore(host->host_lock, flagv);
-	return BlinkLED;
-
 out:
 	aac->in_reset = 0;
 	return BlinkLED;
-- 
2.7.4
