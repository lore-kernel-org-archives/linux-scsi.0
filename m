From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 14/17] hpsa: use new IS_ENABLED macro
Date: Fri, 20 Apr 2012 10:07:32 -0500
Message-ID: <20120420150732.10596.9085.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2e01583..67a0ad0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -139,7 +139,7 @@ static irqreturn_t do_hpsa_intr_msi(int irq, void *dev_id);
 static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg);
 static void start_io(struct ctlr_info *h);
 
-#ifdef CONFIG_COMPAT
+#if IS_ENABLED(COMPAT)
 static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg);
 #endif
 
@@ -513,7 +513,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.ioctl			= hpsa_ioctl,
 	.slave_alloc		= hpsa_slave_alloc,
 	.slave_destroy		= hpsa_slave_destroy,
-#ifdef CONFIG_COMPAT
+#if IS_ENABLED(COMPAT)
 	.compat_ioctl		= hpsa_compat_ioctl,
 #endif
 	.sdev_attrs = hpsa_sdev_attrs,
@@ -2721,7 +2721,7 @@ static void cmd_special_free(struct ctlr_info *h, struct CommandList *c)
 			    c, (dma_addr_t) (c->busaddr & DIRECT_LOOKUP_MASK));
 }
 
-#ifdef CONFIG_COMPAT
+#if IS_ENABLED(COMPAT)
 
 static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg)
 {
@@ -3972,7 +3972,7 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
 
 static void __devinit hpsa_interrupt_mode(struct ctlr_info *h)
 {
-#ifdef CONFIG_PCI_MSI
+#if IS_ENABLED(PCI_MSI)
 	int err, i;
 	struct msix_entry hpsa_msix_entries[MAX_REPLY_QUEUES];
 
@@ -4013,7 +4013,7 @@ static void __devinit hpsa_interrupt_mode(struct ctlr_info *h)
 			dev_warn(&h->pdev->dev, "MSI init failed\n");
 	}
 default_int_mode:
-#endif				/* CONFIG_PCI_MSI */
+#endif /* PCI_MSI enabled */
 	/* if we get here we're going to use the default interrupt mode */
 	h->intr[h->intr_mode] = h->pdev->irq;
 }
@@ -4187,7 +4187,7 @@ static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)
 /* Need to enable prefetch in the SCSI core for 6400 in x86 */
 static inline void hpsa_enable_scsi_prefetch(struct ctlr_info *h)
 {
-#ifdef CONFIG_X86
+#if IS_ENABLED(X86)
 	u32 prefetch;
 
 	prefetch = readl(&(h->cfgtable->SCSI_Prefetch));
