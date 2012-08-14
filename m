From: steve@purestorage.com
Subject: [PATCH 1/2] qla2xxx: Fix use after free in qla2x000_process_loopback.
Date: Tue, 14 Aug 2012 16:48:54 +0100
Message-ID: <502a7371.21d4320a.4e09.44d2@mx.google.com>
References: <1344959335-10845-1-git-send-email-y>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:43477 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751604Ab2HNPyZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2012 11:54:25 -0400
Received: by ghbg16 with SMTP id g16so682168ghb.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2012 08:54:23 -0700 (PDT)
In-Reply-To: <1344959335-10845-1-git-send-email-y>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Steve Hodgson <steve@purestorage.com>

From: Steve Hodgson <steve@purestorage.com>

Don't touch fc_bsg_job after calling job_done() which completes the bio
freeing the memory. Whilst here fix a few other intsances of this error.

Signed-off-by: Steve Hodgson <steve@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index c688838..765be8e 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -827,7 +827,6 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 			bsg_job->reply_payload.sg_cnt, rsp_data,
 			rsp_data_len);
 	}
-	bsg_job->job_done(bsg_job);
 
 	dma_free_coherent(&ha->pdev->dev, rsp_data_len,
 		rsp_data, rsp_data_dma);
@@ -842,6 +841,7 @@ done_unmap_req_sg:
 	dma_unmap_sg(&ha->pdev->dev,
 	    bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	bsg_job->job_done(bsg_job);
 	return rval;
 }
 
@@ -975,7 +975,6 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 		bsg_job->reply->result = DID_OK;
 	}
 
-	bsg_job->job_done(bsg_job);
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
 
 done_free_fw_buf:
@@ -985,6 +984,7 @@ done_unmap_sg:
 	dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 
+	bsg_job->job_done(bsg_job);
 	return rval;
 }
 
@@ -1173,8 +1173,6 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 		}
 	}
 
-	bsg_job->job_done(bsg_job);
-
 done_unmap_sg:
 	if (mgmt_b)
 		dma_free_coherent(&ha->pdev->dev, data_len, mgmt_b, mgmt_dma);
@@ -1189,6 +1187,8 @@ done_unmap_sg:
 exit_mgmt:
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
 
+	bsg_job->job_done(bsg_job);
+
 	return rval;
 }
 
-- 
1.7.9.5

