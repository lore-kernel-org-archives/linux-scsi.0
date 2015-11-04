From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 13/27] hpsa: correct ioaccel2 sg chain len
Date: Wed, 04 Nov 2015 15:51:14 -0600
Message-ID: <20151104215114.15472.22167.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60834 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030782AbbKDVzH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:55:07 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9cf551b..61992c0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1983,7 +1983,7 @@ static int hpsa_map_ioaccel2_sg_chain_block(struct ctlr_info *h,
 	u32 chain_size;
 
 	chain_block = h->ioaccel2_cmd_sg_list[c->cmdindex];
-	chain_size = le32_to_cpu(cp->data_len);
+	chain_size = le32_to_cpu(cp->sg[0].length);
 	temp64 = pci_map_single(h->pdev, chain_block, chain_size,
 				PCI_DMA_TODEVICE);
 	if (dma_mapping_error(&h->pdev->dev, temp64)) {
@@ -2004,7 +2004,7 @@ static void hpsa_unmap_ioaccel2_sg_chain_block(struct ctlr_info *h,
 
 	chain_sg = cp->sg;
 	temp64 = le64_to_cpu(chain_sg->address);
-	chain_size = le32_to_cpu(cp->data_len);
+	chain_size = le32_to_cpu(cp->sg[0].length);
 	pci_unmap_single(h->pdev, temp64, chain_size, PCI_DMA_TODEVICE);
 }
 
@@ -4315,6 +4315,7 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 	/* fill in sg elements */
 	if (use_sg > h->ioaccel_maxsg) {
 		cp->sg_count = 1;
+		cp->sg[0].length = cpu_to_le32(use_sg * sizeof(cp->sg[0]));
 		if (hpsa_map_ioaccel2_sg_chain_block(h, cp, c)) {
 			atomic_dec(&phys_disk->ioaccel_cmds_out);
 			scsi_dma_unmap(cmd);

