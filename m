From: Julia Lawall <julia@diku.dk>
Subject: [PATCH] drivers/scsi/ipr.c: reorder error handling code to include iounmap
Date: Tue, 31 May 2011 16:16:49 +0200
Message-ID: <1306851409-14963-1-git-send-email-julia@diku.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The out_msi_disable label should be before cleanup_nomem to additionally
benefit from the call to iounmap.  Subsequent gotos are adjusted to go to
out_msi_disable instead of cleanup_nomem, which now follows it.  This is
safe because pci_disable_msi does nothing if pci_enable_msi was not called.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression e1,e2;
statement S;
@@

e1 = pci_ioremap_bar(...);
... when != e1 = e2
    when != iounmap(e1)
    when any
(
 if (<+...e1...+>) S
|
 if(...) { ... return 0; }
|
 if (...) { ... when != iounmap(e1)
                when != if (...) { ... iounmap(e1) ... }
* return ...;
 } else S
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/ipr.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 888086c..8d63630 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -8778,14 +8778,14 @@ static int __devinit ipr_probe_ioa(struct pci_dev *pdev,
 	if (rc != PCIBIOS_SUCCESSFUL) {
 		dev_err(&pdev->dev, "Failed to save PCI config space\n");
 		rc = -EIO;
-		goto cleanup_nomem;
+		goto out_msi_disable;
 	}
 
 	if ((rc = ipr_save_pcix_cmd_reg(ioa_cfg)))
-		goto cleanup_nomem;
+		goto out_msi_disable;
 
 	if ((rc = ipr_set_pcix_cmd_reg(ioa_cfg)))
-		goto cleanup_nomem;
+		goto out_msi_disable;
 
 	if (ioa_cfg->sis64)
 		ioa_cfg->cfg_table_size = (sizeof(struct ipr_config_table_hdr64)
@@ -8800,7 +8800,7 @@ static int __devinit ipr_probe_ioa(struct pci_dev *pdev,
 	if (rc < 0) {
 		dev_err(&pdev->dev,
 			"Couldn't allocate enough memory for device driver!\n");
-		goto cleanup_nomem;
+		goto out_msi_disable;
 	}
 
 	/*
@@ -8845,10 +8845,10 @@ out:
 
 cleanup_nolog:
 	ipr_free_mem(ioa_cfg);
-cleanup_nomem:
-	iounmap(ipr_regs);
 out_msi_disable:
 	pci_disable_msi(pdev);
+cleanup_nomem:
+	iounmap(ipr_regs);
 out_release_regions:
 	pci_release_regions(pdev);
 out_scsi_host_put:
