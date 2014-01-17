From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 3/9] ipr: Get rid of superfluous call to pci_disable_msi/msix()
Date: Fri, 17 Jan 2014 17:02:17 +0100
Message-ID: <458b5ff1d1edeaba52cad80a671721c39de01338.1389904166.git.agordeev@redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1389904166.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is no need to call pci_disable_msi() or pci_disable_msix()
in case the call to pci_enable_msi() or pci_enable_msix() failed.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/ipr.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 36ac1c3..fb57e21 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9255,10 +9255,8 @@ static int ipr_enable_msix(struct ipr_ioa_cfg *ioa_cfg)
 	while ((err = pci_enable_msix(ioa_cfg->pdev, entries, vectors)) > 0)
 			vectors = err;
 
-	if (err < 0) {
-		pci_disable_msix(ioa_cfg->pdev);
+	if (err < 0)
 		return err;
-	}
 
 	if (!err) {
 		for (i = 0; i < vectors; i++)
@@ -9278,10 +9276,8 @@ static int ipr_enable_msi(struct ipr_ioa_cfg *ioa_cfg)
 	while ((err = pci_enable_msi_block(ioa_cfg->pdev, vectors)) > 0)
 			vectors = err;
 
-	if (err < 0) {
-		pci_disable_msi(ioa_cfg->pdev);
+	if (err < 0)
 		return err;
-	}
 
 	if (!err) {
 		for (i = 0; i < vectors; i++)
-- 
1.7.7.6
