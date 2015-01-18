From: Tina Johnson <tinajohnson.1234@gmail.com>
Subject: [PATCH 2/2] drivers: scsi: mpt2sas: Clean up error handling for calls to pci_map_single
Date: Sun, 18 Jan 2015 12:11:03 +0530
Message-ID: <88d75f3ab255a7f0d485544adb81d6e0d35d6f7c.1421489699.git.tinajohnson.1234@gmail.com>
References: <cover.1421489699.git.tinajohnson.1234@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1421489699.git.tinajohnson.1234@gmail.com>
In-Reply-To: <cover.1421489699.git.tinajohnson.1234@gmail.com>
References: <cover.1421489699.git.tinajohnson.1234@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com, julia.lawall@lip6.fr, abhijit.mahajan@avagotech.com, nagalakshmi.nandigama@avagotech.com, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tina Johnson <tinajohnson.1234@gmail.com>
List-Id: linux-scsi@vger.kernel.org

*Currently, the error handling code is organized to free dma_addr_out,
 dma_addr_in and then pci_addr_out, pci_addr_in. Since dma_addr_out and
 pci_addr_out are allocated first and then dma_addr_in and  pci_addr_in,
 the error handling code is reorganized to free the in variables first and
 then the out variables. Labels were renamed and gotos altered accordingly.

*At the point of the goto free_pci, neither the in nor the out variables
 are allocated and hence no freeing required. The free_pci label is removed
 and the goto free_pci is replaced with goto out.

Signed-off-by: Tina Johnson <tinajohnson.1234@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/scsi/mpt2sas/mpt2sas_transport.c |   31 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index b283140..1740506 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1966,7 +1966,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 			printk(MPT2SAS_INFO_FMT "%s(): DMA Addr out = NULL\n",
 			    ioc->name, __func__);
 			rc = -ENOMEM;
-			goto free_pci;
+			goto out;
 		}
 	}
 
@@ -1979,7 +1979,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 			printk(MPT2SAS_INFO_FMT "%s(): PCI Addr in = NULL\n",
 			    ioc->name, __func__);
 			rc = -ENOMEM;
-			goto unmap;
+			goto release_out;
 		}
 	} else {
 		dma_addr_in =  pci_map_single(ioc->pdev, bio_data(rsp->bio),
@@ -1988,7 +1988,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 			printk(MPT2SAS_INFO_FMT "%s(): DMA Addr in = NULL\n",
 			    ioc->name, __func__);
 			rc = -ENOMEM;
-			goto unmap;
+			goto release_out;
 		}
 	}
 
@@ -2000,7 +2000,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 			    "%s: failed due to ioc not operational\n",
 			    ioc->name, __func__);
 			rc = -EFAULT;
-			goto unmap;
+			goto release_in;
 		}
 		ssleep(1);
 		ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
@@ -2017,7 +2017,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
 		rc = -EAGAIN;
-		goto unmap;
+		goto release_in;
 	}
 
 	rc = 0;
@@ -2132,22 +2132,21 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		rc = -ETIMEDOUT;
 	}
 
- unmap:
-	if (dma_addr_out)
-		pci_unmap_single(ioc->pdev, dma_addr_out, blk_rq_bytes(req),
-		    PCI_DMA_BIDIRECTIONAL);
+ release_in:
 	if (dma_addr_in)
 		pci_unmap_single(ioc->pdev, dma_addr_in, blk_rq_bytes(rsp),
-		    PCI_DMA_BIDIRECTIONAL);
+				 PCI_DMA_BIDIRECTIONAL);
+	if (pci_addr_in)
+		pci_free_consistent(ioc->pdev, blk_rq_bytes(rsp), pci_addr_in,
+				    pci_dma_in);
 
- free_pci:
+ release_out:
+	if (dma_addr_out)
+		pci_unmap_single(ioc->pdev, dma_addr_out, blk_rq_bytes(req),
+				 PCI_DMA_BIDIRECTIONAL);
 	if (pci_addr_out)
 		pci_free_consistent(ioc->pdev, blk_rq_bytes(req), pci_addr_out,
-		    pci_dma_out);
-
-	if (pci_addr_in)
-		pci_free_consistent(ioc->pdev, blk_rq_bytes(rsp), pci_addr_in,
-		    pci_dma_in);
+				    pci_dma_out);
 
  out:
 	ioc->transport_cmds.status = MPT2_CMD_NOT_USED;
-- 
1.7.10.4
