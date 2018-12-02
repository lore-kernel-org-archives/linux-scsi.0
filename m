From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] scsi: qla2xxx: NULL check before some freeing functions is
 not needed.
Date: Sun, 02 Dec 2018 21:52:11 +0100
Message-ID: <1543760930052-275330559-13-diffsplit-thomas@m3y3r.de>
References: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NULL check before some freeing functions is not needed.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4191,12 +4191,10 @@ fail_free_nvram:
 	kfree(ha->nvram);
 	ha->nvram = NULL;
 fail_free_ctx_mempool:
-	if (ha->ctx_mempool)
-		mempool_destroy(ha->ctx_mempool);
+	mempool_destroy(ha->ctx_mempool);
 	ha->ctx_mempool = NULL;
 fail_free_srb_mempool:
-	if (ha->srb_mempool)
-		mempool_destroy(ha->srb_mempool);
+	mempool_destroy(ha->srb_mempool);
 	ha->srb_mempool = NULL;
 fail_free_gid_list:
 	dma_free_coherent(&ha->pdev->dev, qla2x00_gid_list_size(ha),
@@ -4498,8 +4496,7 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 		dma_free_coherent(&ha->pdev->dev, MCTP_DUMP_SIZE, ha->mctp_dump,
 		    ha->mctp_dump_dma);
 
-	if (ha->srb_mempool)
-		mempool_destroy(ha->srb_mempool);
+	mempool_destroy(ha->srb_mempool);
 
 	if (ha->dcbx_tlv)
 		dma_free_coherent(&ha->pdev->dev, DCBX_TLV_DATA_SIZE,
@@ -4531,8 +4528,7 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	if (ha->async_pd)
 		dma_pool_free(ha->s_dma_pool, ha->async_pd, ha->async_pd_dma);
 
-	if (ha->s_dma_pool)
-		dma_pool_destroy(ha->s_dma_pool);
+	dma_pool_destroy(ha->s_dma_pool);
 
 	if (ha->gid_list)
 		dma_free_coherent(&ha->pdev->dev, qla2x00_gid_list_size(ha),
@@ -4553,14 +4549,11 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 		}
 	}
 
-	if (ha->dl_dma_pool)
-		dma_pool_destroy(ha->dl_dma_pool);
+	dma_pool_destroy(ha->dl_dma_pool);
 
-	if (ha->fcp_cmnd_dma_pool)
-		dma_pool_destroy(ha->fcp_cmnd_dma_pool);
+	dma_pool_destroy(ha->fcp_cmnd_dma_pool);
 
-	if (ha->ctx_mempool)
-		mempool_destroy(ha->ctx_mempool);
+	mempool_destroy(ha->ctx_mempool);
 
 	qlt_mem_free(ha);
 
@@ -7106,8 +7099,7 @@ qla2x00_module_exit(void)
 	qla2x00_release_firmware();
 	kmem_cache_destroy(srb_cachep);
 	qlt_exit();
-	if (ctx_cachep)
-		kmem_cache_destroy(ctx_cachep);
+	kmem_cache_destroy(ctx_cachep);
 	fc_release_transport(qla2xxx_transport_template);
 	fc_release_transport(qla2xxx_transport_vport_template);
 }
