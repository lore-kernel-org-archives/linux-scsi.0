From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 06/22] csiostor: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:16:52 +0100
Message-ID: <69eff1cf2298be42528554f6169c038dd3707349.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Naresh Kumar Inna <naresh@chelsio.com>, Arvind Bhushan <arvindb@chelsio.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Naresh Kumar Inna <naresh@chelsio.com>
Cc: Arvind Bhushan <arvindb@chelsio.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/csiostor/csio_hw.h  |    2 +-
 drivers/scsi/csiostor/csio_isr.c |   24 ++++++++++--------------
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
index 49b1daa..5db2d85 100644
--- a/drivers/scsi/csiostor/csio_hw.h
+++ b/drivers/scsi/csiostor/csio_hw.h
@@ -94,7 +94,7 @@ enum {
 };
 
 struct csio_msix_entries {
-	unsigned short	vector;		/* Vector assigned by pci_enable_msix */
+	unsigned short	vector;		/* Assigned MSI-X vector */
 	void		*dev_id;	/* Priv object associated w/ this msix*/
 	char		desc[24];	/* Description of this vector */
 };
diff --git a/drivers/scsi/csiostor/csio_isr.c b/drivers/scsi/csiostor/csio_isr.c
index 91ba91d..06f283f 100644
--- a/drivers/scsi/csiostor/csio_isr.c
+++ b/drivers/scsi/csiostor/csio_isr.c
@@ -499,7 +499,7 @@ csio_reduce_sqsets(struct csio_hw *hw, int cnt)
 static int
 csio_enable_msix(struct csio_hw *hw)
 {
-	int rv, i, j, k, n, min, cnt;
+	int i, j, k, n, min, cnt;
 	struct csio_msix_entries *entryp;
 	struct msix_entry *entries;
 	int extra = CSIO_EXTRA_VECS;
@@ -521,19 +521,15 @@ csio_enable_msix(struct csio_hw *hw)
 
 	csio_dbg(hw, "FW supp #niq:%d, trying %d msix's\n", hw->cfg_niq, cnt);
 
-	while ((rv = pci_enable_msix(hw->pdev, entries, cnt)) >= min)
-		cnt = rv;
-	if (!rv) {
-		if (cnt < (hw->num_sqsets + extra)) {
-			csio_dbg(hw, "Reducing sqsets to %d\n", cnt - extra);
-			csio_reduce_sqsets(hw, cnt - extra);
-		}
-	} else {
-		if (rv > 0)
-			csio_info(hw, "Not using MSI-X, remainder:%d\n", rv);
-
+	cnt = pci_enable_msix_range(hw->pdev, entries, min, cnt);
+	if (cnt < 0) {
 		kfree(entries);
-		return -ENOMEM;
+		return cnt;
+	}
+
+	if (cnt < (hw->num_sqsets + extra)) {
+		csio_dbg(hw, "Reducing sqsets to %d\n", cnt - extra);
+		csio_reduce_sqsets(hw, cnt - extra);
 	}
 
 	/* Save off vectors */
@@ -585,7 +581,7 @@ csio_intr_enable(struct csio_hw *hw)
 			}
 		}
 
-		if ((csio_msi == 1) && !pci_enable_msi(hw->pdev))
+		if ((csio_msi == 1) && pci_enable_msi_range(hw->pdev, 1, 1) > 0)
 			hw->intr_mode = CSIO_IM_MSI;
 		else
 			hw->intr_mode = CSIO_IM_INTX;
-- 
1.7.7.6
