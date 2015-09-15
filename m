From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 11/17] Update the rtsx multifunction driver to use idr helper functions.
Date: Tue, 15 Sep 2015 09:46:11 -0700
Message-ID: <07029fe6d1206aa0e6aa0e539173bf3289920ca8.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Lee Duncan <lduncan@suse.com>, Samuel Ortiz <sameo@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/mfd/rtsx_pcr.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index a66540a49079..8ddefb8c5e64 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1191,15 +1191,10 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 	}
 	handle->pcr = pcr;
 
-	idr_preload(GFP_KERNEL);
-	spin_lock(&rtsx_pci_lock);
-	ret = idr_alloc(&rtsx_pci_idr, pcr, 0, 0, GFP_NOWAIT);
-	if (ret >= 0)
-		pcr->id = ret;
-	spin_unlock(&rtsx_pci_lock);
-	idr_preload_end();
+	ret = idr_get_index(&rtsx_pci_idr, &rtsc_pci_lock, pcr);
 	if (ret < 0)
 		goto free_handle;
+	pcr->id = ret;
 
 	pcr->pci = pcidev;
 	dev_set_drvdata(&pcidev->dev, handle);
@@ -1311,9 +1306,7 @@ static void rtsx_pci_remove(struct pci_dev *pcidev)
 	pci_release_regions(pcidev);
 	pci_disable_device(pcidev);
 
-	spin_lock(&rtsx_pci_lock);
-	idr_remove(&rtsx_pci_idr, pcr->id);
-	spin_unlock(&rtsx_pci_lock);
+	idr_put_index(&rtsx_pci_idr, &rtsx_pci_lock, pcr->id);
 
 	kfree(pcr->slots);
 	kfree(pcr);
-- 
2.1.4
