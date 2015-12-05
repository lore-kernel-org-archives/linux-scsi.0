From: Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] mpt3sas: Remove unnecessary synchronize_irq() before free_irq()
Date: Sat,  5 Dec 2015 11:53:48 +0100
Message-ID: <1449312828-24539-2-git-send-email-lars@metafoo.de>
References: <1449312828-24539-1-git-send-email-lars@metafoo.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out-198.synserver.de ([212.40.185.198]:1192 "EHLO
	smtp-out-188.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753901AbbLELAn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Dec 2015 06:00:43 -0500
In-Reply-To: <1449312828-24539-1-git-send-email-lars@metafoo.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@avagotech.com, Lars-Peter Clausen <lars@metafoo.de>

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
index 11393eb..943fbfd 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1799,7 +1799,6 @@ _base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 		list_del(&reply_q->list);
 		irq_set_affinity_hint(reply_q->vector, NULL);
 		free_cpumask_var(reply_q->affinity_hint);
-		synchronize_irq(reply_q->vector);
 		free_irq(reply_q->vector, reply_q);
 		kfree(reply_q);
 	}
-- 
2.1.4

