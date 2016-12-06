From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 07/22] qla2xxx: Fix crash due to null pointer access.
Date: Tue, 6 Dec 2016 12:30:36 -0800
Message-ID: <1481056251-2310-8-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0054.outbound.protection.outlook.com ([104.47.38.54]:62528
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752185AbcLFUbL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 15:31:11 -0500
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

This patch fixes crash due to Null pointer access.

Following stack trace will be seen.

[1469877.797315] Call Trace:
[1469877.799940]  [<ffffffffa03ab6e9>] qla2x00_mem_alloc+0xb09/0x10c0 [qla2xxx]
[1469877.806980]  [<ffffffffa03ac50a>] qla2x00_probe_one+0x86a/0x1b50 [qla2xxx]
[1469877.814013]  [<ffffffff813b6d01>] ? __pm_runtime_resume+0x51/0xa0
[1469877.820265]  [<ffffffff8157c1f5>] ? _raw_spin_lock_irqsave+0x25/0x90
[1469877.826776]  [<ffffffff8157cd2d>] ? _raw_spin_unlock_irqrestore+0x6d/0x80
[1469877.833720]  [<ffffffff810741d1>] ? preempt_count_sub+0xb1/0x100
[1469877.839885]  [<ffffffff8157cd0c>] ? _raw_spin_unlock_irqrestore+0x4c/0x80
[1469877.846830]  [<ffffffff81319b9c>] local_pci_probe+0x4c/0xb0
[1469877.852562]  [<ffffffff810741d1>] ? preempt_count_sub+0xb1/0x100
[1469877.858727]  [<ffffffff81319c89>] pci_call_probe+0x89/0xb0

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 544f957..ce8c1dd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3681,7 +3681,7 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 				sizeof(struct ct6_dsd), 0,
 				SLAB_HWCACHE_ALIGN, NULL);
 			if (!ctx_cachep)
-				goto fail_free_gid_list;
+				goto fail_free_srb_mempool;
 		}
 		ha->ctx_mempool = mempool_create_slab_pool(SRB_MIN_REQ,
 			ctx_cachep);
@@ -3834,7 +3834,7 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 	ha->loop_id_map = kzalloc(BITS_TO_LONGS(LOOPID_MAP_SIZE) * sizeof(long),
 	    GFP_KERNEL);
 	if (!ha->loop_id_map)
-		goto fail_async_pd;
+		goto fail_loop_id_map;
 	else {
 		qla2x00_set_reserved_loop_ids(ha);
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0123,
@@ -3843,10 +3843,15 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 
 	return 0;
 
+fail_loop_id_map:
+	dma_pool_free(ha->s_dma_pool, ha->async_pd, ha->async_pd_dma);
+	ha->async_pd = NULL;
 fail_async_pd:
 	dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);
+	ha->ex_init_cb = NULL;
 fail_ex_init_cb:
 	kfree(ha->npiv_info);
+	ha->npiv_info = NULL;
 fail_npiv_info:
 	dma_free_coherent(&ha->pdev->dev, ((*rsp)->length + 1) *
 		sizeof(response_t), (*rsp)->ring, (*rsp)->dma);
@@ -3870,6 +3875,14 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 	dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);
 	ha->ms_iocb = NULL;
 	ha->ms_iocb_dma = 0;
+
+	if (ha->sns_cmd) {
+		dma_free_coherent(&ha->pdev->dev, sizeof(struct sns_cmd_pkt),
+		    ha->sns_cmd, ha->sns_cmd_dma);
+		ha->sns_cmd_dma = 0;
+		ha->sns_cmd = NULL;
+	}
+
 fail_dma_pool:
 	if (IS_QLA82XX(ha) || ql2xenabledif) {
 		dma_pool_destroy(ha->fcp_cmnd_dma_pool);
@@ -3887,10 +3900,12 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 	kfree(ha->nvram);
 	ha->nvram = NULL;
 fail_free_ctx_mempool:
-	mempool_destroy(ha->ctx_mempool);
+	if (ha->ctx_mempool)
+		mempool_destroy(ha->ctx_mempool);
 	ha->ctx_mempool = NULL;
 fail_free_srb_mempool:
-	mempool_destroy(ha->srb_mempool);
+	if (ha->srb_mempool)
+		mempool_destroy(ha->srb_mempool);
 	ha->srb_mempool = NULL;
 fail_free_gid_list:
 	dma_free_coherent(&ha->pdev->dev, qla2x00_gid_list_size(ha),
-- 
1.8.3.1

