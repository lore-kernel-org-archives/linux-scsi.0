From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 1/2] arcmsr: Fix hardware wait loops
Date: Fri, 27 Jul 2007 13:00:48 -0400
Message-ID: <20070727170048.GA27353@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:39658 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288AbXG0RAt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 13:00:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, erich@areca.com.tw
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>


IMO this belongs in 2.6.23-rc.

Committed to 'arcmsr' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git


commit f9f7b1384995626e1a80322faef3f7cca97aa7ae
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Jul 27 12:57:38 2007 -0400

    [SCSI] arcmsr: Fix hardware wait loops
    
    Remove _interruptible, since receiving a signal while waiting on a
    hardware condition will simply cause the driver to busy-wait.
    
    Using msleep_interruptible() is rarely the right thing to do, when
    waiting on a hardware condition to change.

    Also, replace msleep with ssleep while doing this, where appropriate.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/scsi/arcmsr/arcmsr_hba.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

f9f7b1384995626e1a80322faef3f7cca97aa7ae
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 0ddfc21..ae26ed4 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -540,7 +540,7 @@ static uint8_t arcmsr_wait_msgint_ready(struct AdapterControlBlock *acb)
 					, &reg->outbound_intstatus);
 				return 0x00;
 			}
-			msleep_interruptible(10);
+			msleep(10);
 		}/*max 1 seconds*/
 	} while (Retries++ < 20);/*max 20 sec*/
 	return 0xff;
@@ -1421,8 +1421,10 @@ static void arcmsr_iop_reset(struct AdapterControlBlock *acb)
 	if (atomic_read(&acb->ccboutstandingcount) != 0) {
 		/* talk to iop 331 outstanding command aborted */
 		arcmsr_abort_allcmd(acb);
+
 		/* wait for 3 sec for all command aborted*/
-		msleep_interruptible(3000);
+		ssleep(3);
+
 		/* disable all outbound interrupt */
 		intmask_org = arcmsr_disable_outbound_ints(acb);
 		/* clear all outbound posted Q */
@@ -1468,7 +1470,7 @@ static void arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,
 	/*
 	** Wait for 3 sec for all command done.
 	*/
-	msleep_interruptible(3000);
+	ssleep(3);
 
 	intmask = arcmsr_disable_outbound_ints(acb);
 	arcmsr_polling_ccbdone(acb, ccb);
