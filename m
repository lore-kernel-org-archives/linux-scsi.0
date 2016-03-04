From: Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend 2/2] mpt3sas: Remove unnecessary synchronize_irq() before free_irq()
Date: Fri,  4 Mar 2016 11:15:07 +0100
Message-ID: <1457086507-5937-2-git-send-email-lars@metafoo.de>
References: <1457086507-5937-1-git-send-email-lars@metafoo.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out-012.synserver.de ([212.40.185.12]:1090 "EHLO
	smtp-out-012.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbcCDKP3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2016 05:15:29 -0500
In-Reply-To: <1457086507-5937-1-git-send-email-lars@metafoo.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, Lars-Peter Clausen <lars@metafoo.de>

Calling synchronize_irq() right before free_irq() is quite useless. On one
hand the IRQ can easily fire again before free_irq() is entered, on the
other hand free_irq() itself calls synchronize_irq() internally (in a race
condition free way), before any state associated with the IRQ is freed.

Patch was generated using the following semantic patch:
// <smpl>
@@
expression irq;
@@
-synchronize_irq(irq);
 free_irq(irq, ...);
// </smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 5bbbbf2..e4db5fb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1820,7 +1820,6 @@ _base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 			irq_set_affinity_hint(reply_q->vector, NULL);
 			free_cpumask_var(reply_q->affinity_hint);
 		}
-		synchronize_irq(reply_q->vector);
 		free_irq(reply_q->vector, reply_q);
 		kfree(reply_q);
 	}
-- 
2.1.4

