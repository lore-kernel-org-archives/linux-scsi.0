From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/22 DESC UPDATED] libata-sff: clear IRQ from ata_sff_error_handler()
 only when necessary
Date: Tue, 28 Oct 2008 13:31:01 +0900
Message-ID: <49069585.7060900@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:44606 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYJ1EbL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2008 00:31:11 -0400
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>

Clearing IRQ from ata_sff_error_handler() is necessary only when the
port is gonna be thawed before performing EH actions and some
controllers don't like being accessed after certain fail modes until
they're reset.  Clear IRQ iff the port is being thawed.  Also, remove
unnecessary ata_sff_sync() while at it.

Note that the original reason why IRQ was cleared unconditonally was
to help screaming IRQ cases; however, it didn't make any difference as
to screaming IRQs because...

1. If the port is already frozen && IRQ is screaming && EH is not
   gonna thaw until reset is complete, it doesn't matter.

2. If IRQ is screaming && the port is not frozen or freezing doesn't
   work, the IRQ will get killed way before it reaches EH.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-sff.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 4b47394..b9fb068 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2119,11 +2119,13 @@ void ata_sff_error_handler(struct ata_port *ap)
 		}

 		ap->ops->bmdma_stop(qc);
-	}

-	ata_sff_sync(ap);		/* FIXME: We don't need this */
-	ap->ops->sff_check_status(ap);
-	ap->ops->sff_irq_clear(ap);
+		/* if we're gonna thaw, make sure IRQ is clear */
+		if (thaw) {
+			ap->ops->sff_check_status(ap);
+			ap->ops->sff_irq_clear(ap);
+		}
+	}

 	spin_unlock_irqrestore(ap->lock, flags);

-- 
1.5.4.5

