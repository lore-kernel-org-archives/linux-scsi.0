From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/3] block: Deletion of checks before the function call "iounmap"
Date: Sun, 18 Jan 2015 15:43:01 +0100
Message-ID: <54BBC675.2030205@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net> <54BBC3AB.6040207@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54BBC3AB.6040207@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 18 Jan 2015 13:33:25 +0100

The iounmap() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/block/cciss.c    | 18 ++++++------------
 drivers/block/mg_disk.c  |  3 +--
 drivers/block/skd_main.c |  6 ++----
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ff20f19..d13ef0f 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4382,12 +4382,9 @@ err_out_free_res:
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
-	if (h->transtable)
-		iounmap(h->transtable);
-	if (h->cfgtable)
-		iounmap(h->cfgtable);
-	if (h->vaddr)
-		iounmap(h->vaddr);
+	iounmap(h->transtable);
+	iounmap(h->cfgtable);
+	iounmap(h->vaddr);
 	pci_release_regions(h->pdev);
 	return err;
 }
@@ -4939,12 +4936,9 @@ static void cciss_undo_allocations_after_kdump_soft_reset(ctlr_info_t *h)
 	if (h->reply_pool)
 		pci_free_consistent(h->pdev, h->max_commands * sizeof(__u64),
 				h->reply_pool, h->reply_pool_dhandle);
-	if (h->transtable)
-		iounmap(h->transtable);
-	if (h->cfgtable)
-		iounmap(h->cfgtable);
-	if (h->vaddr)
-		iounmap(h->vaddr);
+	iounmap(h->transtable);
+	iounmap(h->cfgtable);
+	iounmap(h->vaddr);
 	unregister_blkdev(h->major, h->devname);
 	cciss_destroy_hba_sysfs_entry(h);
 	pci_release_regions(h->pdev);
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 145ce2a..9f738ee 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -1068,8 +1068,7 @@ static int mg_remove(struct platform_device *plat_dev)
 		gpio_free(host->rst);
 
 	/* unmap io */
-	if (host->dev_base)
-		iounmap(host->dev_base);
+	iounmap(host->dev_base);
 
 	/* free mg_host */
 	kfree(host);
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 1e46eb2..d4c7c4b 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4944,8 +4944,7 @@ err_out_timer:
 
 err_out_iounmap:
 	for (i = 0; i < SKD_MAX_BARS; i++)
-		if (skdev->mem_map[i])
-			iounmap(skdev->mem_map[i]);
+		iounmap(skdev->mem_map[i]);
 
 	if (skdev->pcie_error_reporting_is_enabled)
 		pci_disable_pcie_error_reporting(pdev);
@@ -5108,8 +5107,7 @@ err_out_timer:
 
 err_out_iounmap:
 	for (i = 0; i < SKD_MAX_BARS; i++)
-		if (skdev->mem_map[i])
-			iounmap(skdev->mem_map[i]);
+		iounmap(skdev->mem_map[i]);
 
 	if (skdev->pcie_error_reporting_is_enabled)
 		pci_disable_pcie_error_reporting(pdev);
-- 
2.2.2
