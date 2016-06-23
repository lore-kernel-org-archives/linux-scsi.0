From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] snic: Fix use-after-free in case of a dma mapping error
Date: Thu, 23 Jun 2016 14:37:20 +0200
Message-ID: <20160623123720.24244-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

If there is a dma mapping error snic kfree()s buf right before printing it.
Change the order to not accidently trip on memory that's not owned by us
anymore.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/snic/snic_disc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
index b0fefd6..b106596 100644
--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -113,11 +113,11 @@ snic_queue_report_tgt_req(struct snic *snic)
 
 	pa = pci_map_single(snic->pdev, buf, buf_len, PCI_DMA_FROMDEVICE);
 	if (pci_dma_mapping_error(snic->pdev, pa)) {
-		kfree(buf);
-		snic_req_free(snic, rqi);
 		SNIC_HOST_ERR(snic->shost,
 			      "Rpt-tgt rspbuf %p: PCI DMA Mapping Failed\n",
 			      buf);
+		kfree(buf);
+		snic_req_free(snic, rqi);
 		ret = -EINVAL;
 
 		goto error;
-- 
2.8.4
