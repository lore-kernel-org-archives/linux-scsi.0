From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 05/11] qla2xxx: Cleanse memory allocation logic during probe.
Date: Thu, 31 Jan 2008 12:33:48 -0800
Message-ID: <1201811634-19865-5-git-send-email-andrew.vasquez@qlogic.com>
References: <20080131203216.GB19014@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8353 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759696AbYAaUeI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 15:34:08 -0500
In-Reply-To: <20080131203216.GB19014@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

- Drop loop-till-allocated structure of code within
  qla2x00_mem_alloc().
- Properly unwind deallcations of memory during failures.
- Drop qla2x00_allocate_sp_pool() and qla2x00_free_sp_pool()
  functions as their implementations can easily be collapsed into
  the callers.
- Defer DMA pool allocation of SFP data until requested.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   13 ++
 drivers/scsi/qla2xxx/qla_os.c   |  330 ++++++++++++---------------------------
 2 files changed, 112 insertions(+), 231 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index adf9732..1dd8591 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -428,6 +428,19 @@ qla2x00_sysfs_read_sfp(struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != SFP_DEV_SIZE * 2)
 		return 0;
 
+	if (ha->sfp_data)
+		goto do_read;
+
+	ha->sfp_data = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
+	    &ha->sfp_data_dma);
+	if (!ha->sfp_data) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to allocate memory for SFP read-data.\n");
+		return 0;
+	}
+
+do_read:
+	memset(ha->sfp_data, 0, SFP_BLOCK_SIZE);
 	addr = 0xa0;
 	for (iter = 0, offset = 0; iter < (SFP_DEV_SIZE * 2) / SFP_BLOCK_SIZE;
 	    iter++, offset += SFP_BLOCK_SIZE) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e2adfce..1249545 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -204,10 +204,8 @@ static int qla2x00_do_dpc(void *data);
 
 static void qla2x00_rst_aen(scsi_qla_host_t *);
 
-static uint8_t qla2x00_mem_alloc(scsi_qla_host_t *);
+static int qla2x00_mem_alloc(scsi_qla_host_t *);
 static void qla2x00_mem_free(scsi_qla_host_t *ha);
-static int qla2x00_allocate_sp_pool( scsi_qla_host_t *ha);
-static void qla2x00_free_sp_pool(scsi_qla_host_t *ha);
 static void qla2x00_sp_free_dma(scsi_qla_host_t *, srb_t *);
 
 /* -------------------------------------------------------------------------- */
@@ -2025,196 +2023,109 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha, int defer)
 *
 * Returns:
 *      0  = success.
-*      1  = failure.
+*      !0  = failure.
 */
-static uint8_t
+static int
 qla2x00_mem_alloc(scsi_qla_host_t *ha)
 {
 	char	name[16];
-	uint8_t   status = 1;
-	int	retry= 10;
-
-	do {
-		/*
-		 * This will loop only once if everything goes well, else some
-		 * number of retries will be performed to get around a kernel
-		 * bug where available mem is not allocated until after a
-		 * little delay and a retry.
-		 */
-		ha->request_ring = dma_alloc_coherent(&ha->pdev->dev,
-		    (ha->request_q_length + 1) * sizeof(request_t),
-		    &ha->request_dma, GFP_KERNEL);
-		if (ha->request_ring == NULL) {
-			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - request_ring\n");
-
-			qla2x00_mem_free(ha);
-			msleep(100);
-
-			continue;
-		}
-
-		ha->response_ring = dma_alloc_coherent(&ha->pdev->dev,
-		    (ha->response_q_length + 1) * sizeof(response_t),
-		    &ha->response_dma, GFP_KERNEL);
-		if (ha->response_ring == NULL) {
-			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - response_ring\n");
-
-			qla2x00_mem_free(ha);
-			msleep(100);
-
-			continue;
-		}
-
-		ha->gid_list = dma_alloc_coherent(&ha->pdev->dev, GID_LIST_SIZE,
-		    &ha->gid_list_dma, GFP_KERNEL);
-		if (ha->gid_list == NULL) {
-			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - gid_list\n");
-
-			qla2x00_mem_free(ha);
-			msleep(100);
-
-			continue;
-		}
-
-		/* get consistent memory allocated for init control block */
-		ha->init_cb = dma_alloc_coherent(&ha->pdev->dev,
-		    ha->init_cb_size, &ha->init_cb_dma, GFP_KERNEL);
-		if (ha->init_cb == NULL) {
-			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - init_cb\n");
-
-			qla2x00_mem_free(ha);
-			msleep(100);
-
-			continue;
-		}
-		memset(ha->init_cb, 0, ha->init_cb_size);
-
-		snprintf(name, sizeof(name), "%s_%ld", QLA2XXX_DRIVER_NAME,
-		    ha->host_no);
-		ha->s_dma_pool = dma_pool_create(name, &ha->pdev->dev,
-		    DMA_POOL_SIZE, 8, 0);
-		if (ha->s_dma_pool == NULL) {
-			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - s_dma_pool\n");
-
-			qla2x00_mem_free(ha);
-			msleep(100);
-
-			continue;
-		}
-
-		if (qla2x00_allocate_sp_pool(ha)) {
-			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - "
-			    "qla2x00_allocate_sp_pool()\n");
-
-			qla2x00_mem_free(ha);
-			msleep(100);
-
-			continue;
-		}
-
-		/* Allocate memory for SNS commands */
-		if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-			/* Get consistent memory allocated for SNS commands */
-			ha->sns_cmd = dma_alloc_coherent(&ha->pdev->dev,
-			    sizeof(struct sns_cmd_pkt), &ha->sns_cmd_dma,
-			    GFP_KERNEL);
-			if (ha->sns_cmd == NULL) {
-				/* error */
-				qla_printk(KERN_WARNING, ha,
-				    "Memory Allocation failed - sns_cmd\n");
-
-				qla2x00_mem_free(ha);
-				msleep(100);
-
-				continue;
-			}
-			memset(ha->sns_cmd, 0, sizeof(struct sns_cmd_pkt));
-		} else {
-			/* Get consistent memory allocated for MS IOCB */
-			ha->ms_iocb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
-			    &ha->ms_iocb_dma);
-			if (ha->ms_iocb == NULL) {
-				/* error */
-				qla_printk(KERN_WARNING, ha,
-				    "Memory Allocation failed - ms_iocb\n");
-
-				qla2x00_mem_free(ha);
-				msleep(100);
-
-				continue;
-			}
-			memset(ha->ms_iocb, 0, sizeof(ms_iocb_entry_t));
-
-			/*
-			 * Get consistent memory allocated for CT SNS
-			 * commands
-			 */
-			ha->ct_sns = dma_alloc_coherent(&ha->pdev->dev,
-			    sizeof(struct ct_sns_pkt), &ha->ct_sns_dma,
-			    GFP_KERNEL);
-			if (ha->ct_sns == NULL) {
-				/* error */
-				qla_printk(KERN_WARNING, ha,
-				    "Memory Allocation failed - ct_sns\n");
-
-				qla2x00_mem_free(ha);
-				msleep(100);
-
-				continue;
-			}
-			memset(ha->ct_sns, 0, sizeof(struct ct_sns_pkt));
-
-			if (IS_FWI2_CAPABLE(ha)) {
-				/*
-				 * Get consistent memory allocated for SFP
-				 * block.
-				 */
-				ha->sfp_data = dma_pool_alloc(ha->s_dma_pool,
-				    GFP_KERNEL, &ha->sfp_data_dma);
-				if (ha->sfp_data == NULL) {
-					qla_printk(KERN_WARNING, ha,
-					    "Memory Allocation failed - "
-					    "sfp_data\n");
-
-					qla2x00_mem_free(ha);
-					msleep(100);
-
-					continue;
-				}
-				memset(ha->sfp_data, 0, SFP_BLOCK_SIZE);
-			}
-		}
-
-		/* Get memory for cached NVRAM */
-		ha->nvram = kzalloc(MAX_NVRAM_SIZE, GFP_KERNEL);
-		if (ha->nvram == NULL) {
-			/* error */
-			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - nvram cache\n");
-
-			qla2x00_mem_free(ha);
-			msleep(100);
-
-			continue;
-		}
 
-		/* Done all allocations without any error. */
-		status = 0;
+	ha->request_ring = dma_alloc_coherent(&ha->pdev->dev,
+	    (ha->request_q_length + 1) * sizeof(request_t), &ha->request_dma,
+	    GFP_KERNEL);
+	if (!ha->request_ring)
+		goto fail;
+
+	ha->response_ring = dma_alloc_coherent(&ha->pdev->dev,
+	    (ha->response_q_length + 1) * sizeof(response_t),
+	    &ha->response_dma, GFP_KERNEL);
+	if (!ha->response_ring)
+		goto fail_free_request_ring;
+
+	ha->gid_list = dma_alloc_coherent(&ha->pdev->dev, GID_LIST_SIZE,
+	    &ha->gid_list_dma, GFP_KERNEL);
+	if (!ha->gid_list)
+		goto fail_free_response_ring;
+
+	ha->init_cb = dma_alloc_coherent(&ha->pdev->dev, ha->init_cb_size,
+	    &ha->init_cb_dma, GFP_KERNEL);
+	if (!ha->init_cb)
+		goto fail_free_gid_list;
+
+	snprintf(name, sizeof(name), "%s_%ld", QLA2XXX_DRIVER_NAME,
+	    ha->host_no);
+	ha->s_dma_pool = dma_pool_create(name, &ha->pdev->dev,
+	    DMA_POOL_SIZE, 8, 0);
+	if (!ha->s_dma_pool)
+		goto fail_free_init_cb;
 
-	} while (retry-- && status != 0);
+	ha->srb_mempool = mempool_create_slab_pool(SRB_MIN_REQ, srb_cachep);
+	if (!ha->srb_mempool)
+		goto fail_free_s_dma_pool;
+
+	/* Get memory for cached NVRAM */
+	ha->nvram = kzalloc(MAX_NVRAM_SIZE, GFP_KERNEL);
+	if (!ha->nvram)
+		goto fail_free_srb_mempool;
+
+	/* Allocate memory for SNS commands */
+	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
+		/* Get consistent memory allocated for SNS commands */
+		ha->sns_cmd = dma_alloc_coherent(&ha->pdev->dev,
+		    sizeof(struct sns_cmd_pkt), &ha->sns_cmd_dma, GFP_KERNEL);
+		if (!ha->sns_cmd)
+			goto fail_free_nvram;
+	} else {
+		/* Get consistent memory allocated for MS IOCB */
+		ha->ms_iocb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
+		    &ha->ms_iocb_dma);
+		if (!ha->ms_iocb)
+			goto fail_free_nvram;
 
-	if (status) {
-		printk(KERN_WARNING
-			"%s(): **** FAILED ****\n", __func__);
+		/* Get consistent memory allocated for CT SNS commands */
+		ha->ct_sns = dma_alloc_coherent(&ha->pdev->dev,
+		    sizeof(struct ct_sns_pkt), &ha->ct_sns_dma, GFP_KERNEL);
+		if (!ha->ct_sns)
+			goto fail_free_ms_iocb;
 	}
 
-	return(status);
+	return 0;
+
+fail_free_ms_iocb:
+	dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);
+	ha->ms_iocb = NULL;
+	ha->ms_iocb_dma = 0;
+fail_free_nvram:
+	kfree(ha->nvram);
+	ha->nvram = NULL;
+fail_free_srb_mempool:
+	mempool_destroy(ha->srb_mempool);
+	ha->srb_mempool = NULL;
+fail_free_s_dma_pool:
+	dma_pool_destroy(ha->s_dma_pool);
+	ha->s_dma_pool = NULL;
+fail_free_init_cb:
+	dma_free_coherent(&ha->pdev->dev, ha->init_cb_size, ha->init_cb,
+	    ha->init_cb_dma);
+	ha->init_cb = NULL;
+	ha->init_cb_dma = 0;
+fail_free_gid_list:
+	dma_free_coherent(&ha->pdev->dev, GID_LIST_SIZE, ha->gid_list,
+	    ha->gid_list_dma);
+	ha->gid_list = NULL;
+	ha->gid_list_dma = 0;
+fail_free_response_ring:
+	dma_free_coherent(&ha->pdev->dev, (ha->response_q_length + 1) *
+	    sizeof(response_t), ha->response_ring, ha->response_dma);
+	ha->response_ring = NULL;
+	ha->response_dma = 0;
+fail_free_request_ring:
+	dma_free_coherent(&ha->pdev->dev, (ha->request_q_length + 1) *
+	    sizeof(request_t), ha->request_ring, ha->request_dma);
+	ha->request_ring = NULL;
+	ha->request_dma = 0;
+fail:
+	return -ENOMEM;
 }
 
 /*
@@ -2230,14 +2141,8 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	struct list_head	*fcpl, *fcptemp;
 	fc_port_t	*fcport;
 
-	if (ha == NULL) {
-		/* error */
-		DEBUG2(printk("%s(): ERROR invalid ha pointer.\n", __func__));
-		return;
-	}
-
-	/* free sp pool */
-	qla2x00_free_sp_pool(ha);
+	if (ha->srb_mempool)
+		mempool_destroy(ha->srb_mempool);
 
 	if (ha->fce)
 		dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce,
@@ -2285,6 +2190,7 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 		    (ha->request_q_length + 1) * sizeof(request_t),
 		    ha->request_ring, ha->request_dma);
 
+	ha->srb_mempool = NULL;
 	ha->eft = NULL;
 	ha->eft_dma = 0;
 	ha->sns_cmd = NULL;
@@ -2323,44 +2229,6 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	kfree(ha->nvram);
 }
 
-/*
- * qla2x00_allocate_sp_pool
- * 	 This routine is called during initialization to allocate
- *  	 memory for local srb_t.
- *
- * Input:
- *	 ha   = adapter block pointer.
- *
- * Context:
- *      Kernel context.
- */
-static int
-qla2x00_allocate_sp_pool(scsi_qla_host_t *ha)
-{
-	int      rval;
-
-	rval = QLA_SUCCESS;
-	ha->srb_mempool = mempool_create_slab_pool(SRB_MIN_REQ, srb_cachep);
-	if (ha->srb_mempool == NULL) {
-		qla_printk(KERN_INFO, ha, "Unable to allocate SRB mempool.\n");
-		rval = QLA_FUNCTION_FAILED;
-	}
-	return (rval);
-}
-
-/*
- *  This routine frees all adapter allocated memory.
- *
- */
-static void
-qla2x00_free_sp_pool( scsi_qla_host_t *ha)
-{
-	if (ha->srb_mempool) {
-		mempool_destroy(ha->srb_mempool);
-		ha->srb_mempool = NULL;
-	}
-}
-
 /**************************************************************************
 * qla2x00_do_dpc
 *   This kernel thread is a task that is schedule by the interrupt handler
-- 
1.5.4.rc5.5.gab98

