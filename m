From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: qla2xxx: remove some redundant pointer assignments
Date: Thu,  6 Apr 2017 12:19:57 +0100
Message-ID: <20170406111957.17250-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55615 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754268AbdDFLUC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 07:20:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are several local or function parameter pointers that are
being assigned NULL after a kfree where and these have no effect
and hence can be removed.

Fixes various cppcheck warnings:

"Assignment of function parameter has no effect outside the
function. Did you forget dereferencing it"

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 83d61d2142e9..1c7957903283 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -423,7 +423,6 @@ static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
 		kfree(req->outstanding_cmds);
 
 	kfree(req);
-	req = NULL;
 }
 
 static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
@@ -439,7 +438,6 @@ static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
 		rsp->ring, rsp->dma);
 	}
 	kfree(rsp);
-	rsp = NULL;
 }
 
 static void qla2x00_free_queues(struct qla_hw_data *ha)
@@ -653,7 +651,6 @@ qla2x00_sp_free_dma(void *ptr)
 		ha->gbl_dsd_inuse -= ctx1->dsd_use_cnt;
 		ha->gbl_dsd_avail += ctx1->dsd_use_cnt;
 		mempool_free(ctx1, ha->ctx_mempool);
-		ctx1 = NULL;
 	}
 
 	CMD_SP(cmd) = NULL;
@@ -3256,7 +3253,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	pci_release_selected_regions(ha->pdev, ha->bars);
 	kfree(ha);
-	ha = NULL;
 
 probe_out:
 	pci_disable_device(pdev);
@@ -3504,7 +3500,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	pci_release_selected_regions(ha->pdev, ha->bars);
 	kfree(ha);
-	ha = NULL;
 
 	pci_disable_pcie_error_reporting(pdev);
 
@@ -3568,7 +3563,6 @@ void qla2x00_free_fcports(struct scsi_qla_host *vha)
 		list_del(&fcport->list);
 		qla2x00_clear_loop_id(fcport);
 		kfree(fcport);
-		fcport = NULL;
 	}
 }
 
-- 
2.11.0
