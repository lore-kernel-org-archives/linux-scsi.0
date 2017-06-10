From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: aacraid: Fix some error code
Date: Sat, 10 Jun 2017 15:14:13 +0200
Message-ID: <20170610131413.26666-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: aacraid@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

If 'scsi_host_alloc', 'kzalloc' or '(*aac_drivers[index].init)' fail, the
function will return 0, because 'error' is known to be 0 at this point.

Return -ENOMEM in the 2 first cases and -ENODEV in the third one.

This patch also removes a useless 'error = -ENODEV'.


Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/aacraid/linit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 0f277df73af0..43691d6febc2 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1473,7 +1473,6 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	error = pci_enable_device(pdev);
 	if (error)
 		goto out;
-	error = -ENODEV;
 
 	if (!(aac_drivers[index].quirks & AAC_QUIRK_SRC)) {
 		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
@@ -1505,6 +1504,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_master(pdev);
 
 	shost = scsi_host_alloc(&aac_driver_template, sizeof(struct aac_dev));
+	error = -ENOMEM;
 	if (!shost)
 		goto out_disable_pdev;
 
@@ -1526,6 +1526,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&aac->entry);
 
 	aac->fibs = kzalloc(sizeof(struct fib) * (shost->can_queue + AAC_NUM_MGT_FIB), GFP_KERNEL);
+	error = -ENOMEM;
 	if (!aac->fibs)
 		goto out_free_host;
 	spin_lock_init(&aac->fib_lock);
@@ -1535,6 +1536,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	 *	Map in the registers from the adapter.
 	 */
 	aac->base_size = AAC_MIN_FOOTPRINT_SIZE;
+	error = -ENODEV;
 	if ((*aac_drivers[index].init)(aac))
 		goto out_unmap;
 
-- 
2.11.0
