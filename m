From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/22, UPDATED] libata-sff: clear IRQ from ata_sff_error_handler()
 only when necessary
Date: Tue, 21 Oct 2008 20:45:59 +0900
Message-ID: <48FDC0F7.5010403@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org> <1224580680-13698-5-git-send-email-tj@kernel.org> <48FDA682.2020301@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48FDA682.2020301@ru.mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Clearing IRQ from ata_sff_error_handler() is necessary only when the
port is gonna be thawed before performing EH actions and some
controllers don't like being accessed after certain fail modes until
they're reset.  Clear IRQ iff the port is being thawed.  Also, remove
unnecessary ata_sff_sync() while at it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
s/clear/cleared/.  git tree is updated too.  Thanks.

 drivers/ata/libata-sff.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: work/drivers/ata/libata-sff.c
===================================================================
--- work.orig/drivers/ata/libata-sff.c
+++ work/drivers/ata/libata-sff.c
@@ -2119,11 +2119,13 @@ void ata_sff_error_handler(struct ata_po
 		}
 
 		ap->ops->bmdma_stop(qc);
-	}
 
-	ata_sff_sync(ap);		/* FIXME: We don't need this */
-	ap->ops->sff_check_status(ap);
-	ap->ops->sff_irq_clear(ap);
+		/* if we're gonna thaw, make sure IRQ is cleared */
+		if (thaw) {
+			ap->ops->sff_check_status(ap);
+			ap->ops->sff_irq_clear(ap);
+		}
+	}
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
