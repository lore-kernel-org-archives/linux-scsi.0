From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] fnic: pci_dma_mapping_error() doesn't return an error code
Date: Thu, 7 Jul 2016 11:23:59 +0300
Message-ID: <20160707082359.GD16742@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Hiral Patel <hiralpat@cisco.com>, Maurizio Lombardi <mlombard@redhat.com>
Cc: Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_dma_mapping_error() returns true on error and false on success.

Fixes: fd6ddfa4c1dd ('fnic: check pci_map_single() return value')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 67669a9..f3a3331 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -954,8 +954,8 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 	skb_put(skb, len);
 	pa = pci_map_single(fnic->pdev, skb->data, len, PCI_DMA_FROMDEVICE);
 
-	r = pci_dma_mapping_error(fnic->pdev, pa);
-	if (r) {
+	if (pci_dma_mapping_error(fnic->pdev, pa)) {
+		r = -ENOMEM;
 		printk(KERN_ERR "PCI mapping failed with error %d\n", r);
 		goto free_skb;
 	}
@@ -1093,8 +1093,8 @@ static int fnic_send_frame(struct fnic *fnic, struct fc_frame *fp)
 
 	pa = pci_map_single(fnic->pdev, eth_hdr, tot_len, PCI_DMA_TODEVICE);
 
-	ret = pci_dma_mapping_error(fnic->pdev, pa);
-	if (ret) {
+	if (pci_dma_mapping_error(fnic->pdev, pa)) {
+		ret = -ENOMEM;
 		printk(KERN_ERR "DMA map failed with error %d\n", ret);
 		goto free_skb_on_err;
 	}
