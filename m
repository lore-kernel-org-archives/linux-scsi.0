From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 13/30] hpsa: fix some debug printks to use dev_dbg instead
Date: Thu, 04 Feb 2010 08:42:30 -0600
Message-ID: <20100204144230.10406.73079.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: fix some debug printks to use dev_dbg instead

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.h |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index da8dd3e..cdac95b 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -173,10 +173,7 @@ struct ctlr_info {
 static void SA5_submit_command(struct ctlr_info *h,
 	struct CommandList *c)
 {
-#ifdef HPSA_DEBUG
-	 printk(KERN_WARNING "hpsa: Sending %x - down to controller\n",
-		c->busaddr);
-#endif /* HPSA_DEBUG */
+	dev_dbg(&h->pdev->dev, "Sending %x\n", c->busaddr);
 	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
 	h->commands_outstanding++;
 	if (h->commands_outstanding > h->max_outstanding)
@@ -225,10 +222,10 @@ static unsigned long SA5_completed(struct ctlr_info *h)
 
 #ifdef HPSA_DEBUG
 	if (register_value != FIFO_EMPTY)
-		printk(KERN_INFO "hpsa:  Read %lx back from board\n",
+		dev_dbg(&h->pdev->dev, "Read %lx back from board\n",
 			register_value);
 	else
-		printk(KERN_INFO "hpsa:  FIFO Empty read\n");
+		dev_dbg(&h->pdev->dev, "hpsa: FIFO Empty read\n");
 #endif
 
 	return register_value;
@@ -240,9 +237,7 @@ static unsigned long SA5_intr_pending(struct ctlr_info *h)
 {
 	unsigned long register_value  =
 		readl(h->vaddr + SA5_INTR_STATUS);
-#ifdef HPSA_DEBUG
-	printk(KERN_INFO "hpsa: intr_pending %lx\n", register_value);
-#endif  /* HPSA_DEBUG */
+	dev_dbg(&h->pdev->dev, "intr_pending %lx\n", register_value);
 	if (register_value &  SA5_INTR_PENDING)
 		return  1;
 	return 0 ;
