From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] aha152x: delete pointless test in irq handler
Date: Fri, 19 Oct 2007 03:33:54 -0400
Message-ID: <20071019073354.GA5766@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934301AbXJSHeW@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org


commit c8f14a99beb85918935334a8374e47db12608d8e
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 03:17:14 2007 -0400

    [SCSI] aha152x: delete pointless test in irq handler
    
    Remove always-false test in interrupt handler.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/scsi/aha152x.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

c8f14a99beb85918935334a8374e47db12608d8e
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f08e71e..973778a 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1439,15 +1439,10 @@ static void run(struct work_struct *work)
  */
 static irqreturn_t intr(int irqno, void *dev_id)
 {
-	struct Scsi_Host *shpnt = (struct Scsi_Host *)dev_id;
+	struct Scsi_Host *shpnt = dev_id;
 	unsigned long flags;
 	unsigned char rev, dmacntrl0;
 
-	if (!shpnt) {
-		printk(KERN_ERR "aha152x: catched interrupt %d for unknown controller.\n", irqno);
-		return IRQ_NONE;
-	}
-
 	/*
 	 * Read a couple of registers that are known to not be all 1's. If
 	 * we read all 1's (-1), that means that either:
