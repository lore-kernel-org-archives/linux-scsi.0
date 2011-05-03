From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 08/16] hpsa: factor out irq request code
Date: Tue, 03 May 2011 14:59:25 -0500
Message-ID: <20110503195925.5478.17662.stgit@beardog.cce.hp.com>
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
 drivers/scsi/hpsa.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7336f3c..97db2e5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3881,6 +3881,26 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h)
 			    h->errinfo_pool_dhandle);
 }
 
+static int hpsa_request_irq(struct ctlr_info *h,
+	irqreturn_t (*msixhandler)(int, void *),
+	irqreturn_t (*intxhandler)(int, void *))
+{
+	int rc;
+
+	if (h->msix_vector || h->msi_vector)
+		rc = request_irq(h->intr[h->intr_mode], msixhandler,
+				IRQF_DISABLED, h->devname, h);
+	else
+		rc = request_irq(h->intr[h->intr_mode], intxhandler,
+				IRQF_DISABLED, h->devname, h);
+	if (rc) {
+		dev_err(&h->pdev->dev, "unable to get irq %d for %s\n",
+		       h->intr[h->intr_mode], h->devname);
+		return -ENODEV;
+	}
+	return 0;
+}
+
 static int __devinit hpsa_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *ent)
 {
@@ -3936,18 +3956,8 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	/* make sure the board interrupts are off */
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
 
-	if (h->msix_vector || h->msi_vector)
-		rc = request_irq(h->intr[h->intr_mode], do_hpsa_intr_msi,
-				IRQF_DISABLED, h->devname, h);
-	else
-		rc = request_irq(h->intr[h->intr_mode], do_hpsa_intr_intx,
-				IRQF_DISABLED, h->devname, h);
-	if (rc) {
-		dev_err(&pdev->dev, "unable to get irq %d for %s\n",
-		       h->intr[h->intr_mode], h->devname);
+	if (hpsa_request_irq(h, do_hpsa_intr_msi, do_hpsa_intr_intx))
 		goto clean2;
-	}
-
 	dev_info(&pdev->dev, "%s: <0x%x> at IRQ %d%s using DAC\n",
 	       h->devname, pdev->device,
 	       h->intr[h->intr_mode], dac ? "" : " not");
