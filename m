From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH V2] scsi: aacraid: Fix some error code
Date: Tue, 24 Oct 2017 04:29:46 +0200
Message-ID: <20171024022946.30223-1-christophe.jaillet@wanadoo.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: aacraid@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

If 'scsi_host_alloc', 'kzalloc' or '(*aac_drivers[index].init)' fail, the
function will return 0, because 'error' is known to be 0 at this point.

Return -ENOMEM in the 2 first cases and -ENODEV in the third one.

This patch also removes a useless 'error = -ENODEV'.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
V2: rebase against latest -next (20171019)
---
 drivers/scsi/aacraid/linit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index c9252b138c1f..7e7d9bfd2b9e 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1628,7 +1628,6 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	error = pci_enable_device(pdev);
 	if (error)
 		goto out;
-	error = -ENODEV;
 
 	if (!(aac_drivers[index].quirks & AAC_QUIRK_SRC)) {
 		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
@@ -1660,6 +1659,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_master(pdev);
 
 	shost = scsi_host_alloc(&aac_driver_template, sizeof(struct aac_dev));
+	error = -ENOMEM;
 	if (!shost)
 		goto out_disable_pdev;
 
@@ -1681,6 +1681,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&aac->entry);
 
 	aac->fibs = kzalloc(sizeof(struct fib) * (shost->can_queue + AAC_NUM_MGT_FIB), GFP_KERNEL);
+	error = -ENOMEM;
 	if (!aac->fibs)
 		goto out_free_host;
 	spin_lock_init(&aac->fib_lock);
@@ -1690,6 +1691,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	 *	Map in the registers from the adapter.
 	 */
 	aac->base_size = AAC_MIN_FOOTPRINT_SIZE;
+	error = -ENODEV;
 	if ((*aac_drivers[index].init)(aac))
 		goto out_unmap;
 
-- 
2.14.1

