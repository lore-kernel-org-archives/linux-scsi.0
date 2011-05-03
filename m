From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/16] hpsa: factor out cmd pool allocation functions
Date: Tue, 03 May 2011 14:59:20 -0500
Message-ID: <20110503195920.5478.66719.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   66 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2aeb210..7336f3c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3847,6 +3847,40 @@ static __devinit int hpsa_init_reset_devices(struct pci_dev *pdev)
 	return 0;
 }
 
+static __devinit int hpsa_allocate_cmd_pool(struct ctlr_info *h)
+{
+	h->cmd_pool_bits = kzalloc(
+		DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG) *
+		sizeof(unsigned long), GFP_KERNEL);
+	h->cmd_pool = pci_alloc_consistent(h->pdev,
+		    h->nr_cmds * sizeof(*h->cmd_pool),
+		    &(h->cmd_pool_dhandle));
+	h->errinfo_pool = pci_alloc_consistent(h->pdev,
+		    h->nr_cmds * sizeof(*h->errinfo_pool),
+		    &(h->errinfo_pool_dhandle));
+	if ((h->cmd_pool_bits == NULL)
+	    || (h->cmd_pool == NULL)
+	    || (h->errinfo_pool == NULL)) {
+		dev_err(&h->pdev->dev, "out of memory in %s", __func__);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void hpsa_free_cmd_pool(struct ctlr_info *h)
+{
+	kfree(h->cmd_pool_bits);
+	if (h->cmd_pool)
+		pci_free_consistent(h->pdev,
+			    h->nr_cmds * sizeof(struct CommandList),
+			    h->cmd_pool, h->cmd_pool_dhandle);
+	if (h->errinfo_pool)
+		pci_free_consistent(h->pdev,
+			    h->nr_cmds * sizeof(struct ErrorInfo),
+			    h->errinfo_pool,
+			    h->errinfo_pool_dhandle);
+}
+
 static int __devinit hpsa_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *ent)
 {
@@ -3917,33 +3951,14 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	dev_info(&pdev->dev, "%s: <0x%x> at IRQ %d%s using DAC\n",
 	       h->devname, pdev->device,
 	       h->intr[h->intr_mode], dac ? "" : " not");
-
-	h->cmd_pool_bits =
-	    kmalloc(((h->nr_cmds + BITS_PER_LONG -
-		      1) / BITS_PER_LONG) * sizeof(unsigned long), GFP_KERNEL);
-	h->cmd_pool = pci_alloc_consistent(h->pdev,
-		    h->nr_cmds * sizeof(*h->cmd_pool),
-		    &(h->cmd_pool_dhandle));
-	h->errinfo_pool = pci_alloc_consistent(h->pdev,
-		    h->nr_cmds * sizeof(*h->errinfo_pool),
-		    &(h->errinfo_pool_dhandle));
-	if ((h->cmd_pool_bits == NULL)
-	    || (h->cmd_pool == NULL)
-	    || (h->errinfo_pool == NULL)) {
-		dev_err(&pdev->dev, "out of memory");
-		rc = -ENOMEM;
+	if (hpsa_allocate_cmd_pool(h))
 		goto clean4;
-	}
 	if (hpsa_allocate_sg_chain_blocks(h))
 		goto clean4;
 	init_waitqueue_head(&h->scan_wait_queue);
 	h->scan_finished = 1; /* no scan currently in progress */
 
 	pci_set_drvdata(pdev, h);
-	memset(h->cmd_pool_bits, 0,
-	       ((h->nr_cmds + BITS_PER_LONG -
-		 1) / BITS_PER_LONG) * sizeof(unsigned long));
-
 	hpsa_scsi_setup(h);
 
 	/* Turn the interrupts on so we can service requests */
@@ -3957,16 +3972,7 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 
 clean4:
 	hpsa_free_sg_chain_blocks(h);
-	kfree(h->cmd_pool_bits);
-	if (h->cmd_pool)
-		pci_free_consistent(h->pdev,
-			    h->nr_cmds * sizeof(struct CommandList),
-			    h->cmd_pool, h->cmd_pool_dhandle);
-	if (h->errinfo_pool)
-		pci_free_consistent(h->pdev,
-			    h->nr_cmds * sizeof(struct ErrorInfo),
-			    h->errinfo_pool,
-			    h->errinfo_pool_dhandle);
+	hpsa_free_cmd_pool(h);
 	free_irq(h->intr[h->intr_mode], h);
 clean2:
 clean1:
