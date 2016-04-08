From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] mpt3sas: fix possible NULL dereference
Date: Fri,  8 Apr 2016 21:12:42 +0530
Message-ID: <1460130162-30011-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: linux-scsi@vger.kernel.org

We are dereferencing ioc->sense_dma_pool in pci_pool_free() and after
that we are checking if it is NULL, before calling pci_pool_destroy().
Lets check if it is NULL before calling both pci_pool_free() and
pci_pool_destroy().

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8c44b9c..778c2ec 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3087,9 +3087,11 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	if (ioc->sense) {
-		pci_pool_free(ioc->sense_dma_pool, ioc->sense, ioc->sense_dma);
-		if (ioc->sense_dma_pool)
+		if (ioc->sense_dma_pool) {
+			pci_pool_free(ioc->sense_dma_pool, ioc->sense,
+				      ioc->sense_dma);
 			pci_pool_destroy(ioc->sense_dma_pool);
+		}
 		dexitprintk(ioc, pr_info(MPT3SAS_FMT
 			"sense_pool(0x%p): free\n",
 			ioc->name, ioc->sense));
-- 
1.9.1
