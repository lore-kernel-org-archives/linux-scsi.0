From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA fails
Date: Sun,  8 Nov 2015 20:57:44 -0500
Message-ID: <1447034266-28003-2-git-send-email-okaya@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com
Cc: agross@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, MPT-FusionLinux.pdl@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Current code gives up when 32 bit DMA is not supported.
This problem has been observed on systems without any
memory below 4 gig.

This patch tests 64 bit support before bailing out to find
a working combination.

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 21 ++++++++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.c | 22 +++++++++++++++++++++-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index c167911..c61c82a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1217,8 +1217,27 @@ _base_config_dma_addressing(struct MPT2SAS_ADAPTER *ioc, struct pci_dev *pdev)
 		ioc->base_add_sg_single = &_base_add_sg_single_32;
 		ioc->sge_size = sizeof(Mpi2SGESimple32_t);
 		ioc->dma_mask = 32;
-	} else
+	} else {
+		/* Try 64 bit, 32 bit failed */
+		consistent_dma_mask = DMA_BIT_MASK(64);
+
+		if (sizeof(dma_addr_t) > 4) {
+			const uint64_t required_mask =
+				dma_get_required_mask(&pdev->dev);
+			if ((required_mask > DMA_BIT_MASK(32)) &&
+				!pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) &&
+				!pci_set_consistent_dma_mask(pdev,
+							consistent_dma_mask)) {
+				ioc->base_add_sg_single =
+					&_base_add_sg_single_64;
+				ioc->sge_size = sizeof(Mpi2SGESimple64_t);
+				ioc->dma_mask = 64;
+				goto out;
+			}
+		}
+
 		return -ENODEV;
+	}
 
  out:
 	si_meminfo(&s);
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
