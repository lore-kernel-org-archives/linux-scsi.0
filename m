From: giridhar.malavali@qlogic.com
Subject: [PATCH 3/5] qla2xxx: Free DMA memory only if it is allocated in vendor specific BSG command
Date: Fri, 19 Mar 2010 17:04:00 -0700
Message-ID: <1269043442-2306-4-git-send-email-giridhar.malavali@qlogic.com>
References: <1269043442-2306-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36579 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752323Ab0CTAEF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 20:04:05 -0400
In-Reply-To: <1269043442-2306-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

The qla84xx_mgmt_cmd function supports multiple subcommands.
Some subcommands require DMA memory and some do not.
Therefore check before freeing DMA memory whether it is allocated or not.

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 239d37b..dc8bf10 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -804,7 +804,7 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 	int rval = 0;
 	struct qla_bsg_a84_mgmt *ql84_mgmt;
 	uint32_t sg_cnt;
-	uint32_t data_len;
+	uint32_t data_len = 0;
 	uint32_t dma_direction = DMA_NONE;
 
 	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
@@ -980,9 +980,11 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 	}
 
 	bsg_job->job_done(bsg_job);
-	dma_free_coherent(&ha->pdev->dev, data_len, mgmt_b, mgmt_dma);
 
 done_unmap_sg:
+	if (mgmt_b)
+		dma_free_coherent(&ha->pdev->dev, data_len, mgmt_b, mgmt_dma);
+
 	if (dma_direction == DMA_TO_DEVICE)
 		dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 			bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
-- 
1.6.2.rc1.30.gd43c

