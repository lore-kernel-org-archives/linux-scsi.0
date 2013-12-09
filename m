From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] [SCSI] aacraid: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 10:51:14 +0100
Message-ID: <1386582674-4826-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381036825-10585-1-git-send-email-michael.opdenacker@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1381036825-10585-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: aacraid@adaptec.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Opdenacker <michael.opdenacker@free-electrons.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/aacraid/rx.c  | 2 +-
 drivers/scsi/aacraid/sa.c  | 3 +--
 drivers/scsi/aacraid/src.c | 4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index dada38aeacc0..bf077ce95bfe 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -646,7 +646,7 @@ int _aac_rx_init(struct aac_dev *dev)
 	dev->sync_mode = 0;	/* sync. mode not supported */
 	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-			IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {
+			IRQF_SHARED, "aacraid", dev) < 0) {
 		if (dev->msi)
 			pci_disable_msi(dev->pdev);
 		printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
index 2244f315f33b..e66477c98240 100644
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -387,8 +387,7 @@ int aac_sa_init(struct aac_dev *dev)
 		goto error_irq;
 	dev->sync_mode = 0;	/* sync. mode not supported */
 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-			IRQF_SHARED|IRQF_DISABLED,
-			"aacraid", (void *)dev ) < 0) {
+			IRQF_SHARED, "aacraid", (void *)dev) < 0) {
 		printk(KERN_WARNING "%s%d: Interrupt unavailable.\n",
 			name, instance);
 		goto error_iounmap;
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 7e17107643d4..9c65aed26212 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -647,7 +647,7 @@ int aac_src_init(struct aac_dev *dev)
 	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
 
 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-			IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {
+			IRQF_SHARED, "aacraid", dev) < 0) {
 
 		if (dev->msi)
 			pci_disable_msi(dev->pdev);
@@ -804,7 +804,7 @@ int aac_srcv_init(struct aac_dev *dev)
 		goto error_iounmap;
 	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-		IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {
+		IRQF_SHARED, "aacraid", dev) < 0) {
 		if (dev->msi)
 			pci_disable_msi(dev->pdev);
 		printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
-- 
1.8.3.2
