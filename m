From: akpm@linux-foundation.org
Subject: [patch for 3.0 2/3] drivers/scsi/ipr.c: reorder error handling code to include iounmap
Date: Mon, 11 Jul 2011 14:08:25 -0700
Message-ID: <201107112108.p6BL8PhX003563@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab1GKVJM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2011 17:09:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk, brking@linux.vnet.ibm.com

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
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ipr.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/ipr.c~drivers-scsi-iprc-reorder-error-handling-code-to-include-iounmap drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~drivers-scsi-iprc-reorder-error-handling-code-to-include-iounmap
+++ a/drivers/scsi/ipr.c
@@ -8778,14 +8778,14 @@ static int __devinit ipr_probe_ioa(struc
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
@@ -8800,7 +8800,7 @@ static int __devinit ipr_probe_ioa(struc
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
_
