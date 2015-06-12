From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 18/20] [SCSI] mpt3sas: Call dma_mapping_error() API after mapping an address with dma_map_single() API
Date: Fri, 12 Jun 2015 15:12:30 +0530
Message-ID: <1434102153-38581-19-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:35557 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720AbbFLJoU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2015 05:44:20 -0400
Received: by qgg3 with SMTP id 3so9783661qgg.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2015 02:44:19 -0700 (PDT)
In-Reply-To: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Added dma_mapping_error() API after mapping an address with dma_map_single() API.
Otherwise when CONFIG_DMA_API_DEBUG is enabled in the kernel, then it complains
about mpt3sas driver not calling dma_mapping_error after mapping an address with
dma_map_single

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 7a7aa68..70fd019 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1964,7 +1964,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	} else {
 		dma_addr_out = pci_map_single(ioc->pdev, bio_data(req->bio),
 		    blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
-		if (!dma_addr_out) {
+		if (pci_dma_mapping_error(ioc->pdev, dma_addr_out)) {
 			pr_info(MPT3SAS_FMT "%s(): DMA Addr out = NULL\n",
 			    ioc->name, __func__);
 			rc = -ENOMEM;
@@ -1986,7 +1986,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
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

