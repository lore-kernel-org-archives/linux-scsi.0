From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH 2/4] scsi: mpt3sas: try 64 bit DMA when 32 bit DMA fails
Date: Wed,  4 Nov 2015 23:46:27 -0500
Message-ID: <1446698789-19308-2-git-send-email-okaya@codeaurora.org>
References: <1446698789-19308-1-git-send-email-okaya@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446698789-19308-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com
Cc: Sinan Kaya <okaya@codeaurora.org>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, MPT-FusionLinux.pdl@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Current code gives up when 32 bit DMA is not supported.
This patch tests 64 bit support before bailing out in
such conditions.

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index d4f1dcd..6dc391c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1535,9 +1535,29 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 		ioc->base_add_sg_single = &_base_add_sg_single_32;
 		ioc->sge_size = sizeof(Mpi2SGESimple32_t);
 		ioc->dma_mask = 32;
-	} else
+	} else {
+		/* Try 64 bit, 32 bit failed */
+		consistent_dma_mask = DMA_BIT_MASK(64);
+		if (sizeof(dma_addr_t) > 4) {
+			const uint64_t required_mask =
+				dma_get_required_mask(&pdev->dev);
+			int consistent_mask =
+				pci_set_consistent_dma_mask(pdev,
+							consistent_dma_mask);
+
+			if ((required_mask > DMA_BIT_MASK(32)) &&
+				!pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) &&
+				!consistent_mask) {
+				ioc->base_add_sg_single =
+					&_base_add_sg_single_64;
+				ioc->sge_size = sizeof(Mpi2SGESimple64_t);
+				ioc->dma_mask = 64;
+				goto out;
+			}
+		}
 		return -ENODEV;
 
+	}
  out:
 	si_meminfo(&s);
 	pr_info(MPT3SAS_FMT
-- 
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
