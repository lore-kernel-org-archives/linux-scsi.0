From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 18/20] [SCSI] mpt3sas: Call dma_mapping_error() API after mapping an address with dma_map_single() API
Date: Mon, 30 Mar 2015 19:25:21 +0530
Message-ID: <1427723723-12676-19-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Added dma_mapping_error() API after mapping an address with dma_map_single() API. Otherwise when CONFIG_DMA_API_DEBUG is enabled in the kernel, then it complains about mpt3sas driver not calling dma_mapping_error after mapping an address with dma_map_single

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 1695f0f..52bfc78 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1960,7 +1960,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	} else {
 		dma_addr_out = pci_map_single(ioc->pdev, bio_data(req->bio),
 		    blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
-		if (!dma_addr_out) {
+		if (pci_dma_mapping_error(ioc->pdev, dma_addr_out)) {
 			pr_info(MPT3SAS_FMT "%s(): DMA Addr out = NULL\n",
 			    ioc->name, __func__);
 			rc = -ENOMEM;
@@ -1982,7 +1982,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	} else {
 		dma_addr_in =  pci_map_single(ioc->pdev, bio_data(rsp->bio),
 		    blk_rq_bytes(rsp), PCI_DMA_BIDIRECTIONAL);
-		if (!dma_addr_in) {
+		if (pci_dma_mapping_error(ioc->pdev, dma_addr_in)) {
 			pr_info(MPT3SAS_FMT "%s(): DMA Addr in = NULL\n",
 			    ioc->name, __func__);
 			rc = -ENOMEM;
-- 
2.0.2
