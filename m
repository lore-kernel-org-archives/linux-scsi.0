From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] scsi: megaraid_sas: NULL check before some freeing
 functions is not needed.
Date: Sun, 02 Dec 2018 21:52:11 +0100
Message-ID: <1543760930052-918941928-10-diffsplit-thomas@m3y3r.de>
References: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NULL check before some freeing functions is not needed.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1243,8 +1243,7 @@ megaraid_mbox_teardown_dma_pools(adapter
 		dma_pool_free(raid_dev->sg_pool_handle, sg_pci_blk[i].vaddr,
 			sg_pci_blk[i].dma_addr);
 	}
-	if (raid_dev->sg_pool_handle)
-		dma_pool_destroy(raid_dev->sg_pool_handle);
+	dma_pool_destroy(raid_dev->sg_pool_handle);
 
 
 	epthru_pci_blk = raid_dev->epthru_pool;
@@ -1252,8 +1251,7 @@ megaraid_mbox_teardown_dma_pools(adapter
 		dma_pool_free(raid_dev->epthru_pool_handle,
 			epthru_pci_blk[i].vaddr, epthru_pci_blk[i].dma_addr);
 	}
-	if (raid_dev->epthru_pool_handle)
-		dma_pool_destroy(raid_dev->epthru_pool_handle);
+	dma_pool_destroy(raid_dev->epthru_pool_handle);
 
 
 	mbox_pci_blk = raid_dev->mbox_pool;
@@ -1261,8 +1259,7 @@ megaraid_mbox_teardown_dma_pools(adapter
 		dma_pool_free(raid_dev->mbox_pool_handle,
 			mbox_pci_blk[i].vaddr, mbox_pci_blk[i].dma_addr);
 	}
-	if (raid_dev->mbox_pool_handle)
-		dma_pool_destroy(raid_dev->mbox_pool_handle);
+	dma_pool_destroy(raid_dev->mbox_pool_handle);
 
 	return;
 }
diff -u -p a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -1017,8 +1017,7 @@ memalloc_error:
 	kfree(adapter->kioc_list);
 	kfree(adapter->mbox_list);
 
-	if (adapter->pthru_dma_pool)
-		dma_pool_destroy(adapter->pthru_dma_pool);
+	dma_pool_destroy(adapter->pthru_dma_pool);
 
 	kfree(adapter);
 
diff -u -p a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -807,10 +807,8 @@ megasas_free_rdpq_fusion(struct megasas_
 
 	}
 
-	if (fusion->reply_frames_desc_pool)
-		dma_pool_destroy(fusion->reply_frames_desc_pool);
-	if (fusion->reply_frames_desc_pool_align)
-		dma_pool_destroy(fusion->reply_frames_desc_pool_align);
+	dma_pool_destroy(fusion->reply_frames_desc_pool);
+	dma_pool_destroy(fusion->reply_frames_desc_pool_align);
 
 	if (fusion->rdpq_virt)
 		dma_free_coherent(&instance->pdev->dev,
@@ -830,8 +828,7 @@ megasas_free_reply_fusion(struct megasas
 			fusion->reply_frames_desc[0],
 			fusion->reply_frames_desc_phys[0]);
 
-	if (fusion->reply_frames_desc_pool)
-		dma_pool_destroy(fusion->reply_frames_desc_pool);
+	dma_pool_destroy(fusion->reply_frames_desc_pool);
 
 }
 
@@ -1627,8 +1624,7 @@ static inline void megasas_free_ioc_init
 				  fusion->ioc_init_cmd->frame,
 				  fusion->ioc_init_cmd->frame_phys_addr);
 
-	if (fusion->ioc_init_cmd)
-		kfree(fusion->ioc_init_cmd);
+	kfree(fusion->ioc_init_cmd);
 }
 
 /**
