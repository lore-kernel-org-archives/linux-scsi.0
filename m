From: steve@purestorage.com
Subject: [PATCH 2/2] qla2xxx: Free rsp_data even on error in qla2x00_process_loopback()
Date: Tue, 14 Aug 2012 16:48:55 +0100
Message-ID: <502a7373.21d4320a.4e09.44d6@mx.google.com>
References: <1344959335-10845-1-git-send-email-y>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog103.obsmtp.com ([74.125.245.74]:51435 "HELO
	na3sys010aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751604Ab2HNPzF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2012 11:55:05 -0400
Received: by ggni2 with SMTP id i2so651634ggn.24
        for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2012 08:55:03 -0700 (PDT)
In-Reply-To: <1344959335-10845-1-git-send-email-y>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Steve Hodgson <steve@purestorage.com>

From: Steve Hodgson <steve@purestorage.com>

Signed-off-by: Steve Hodgson <steve@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 765be8e..f465c3e 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -726,7 +726,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 				    "Get port config failed.\n");
 				bsg_job->reply->result = (DID_ERROR << 16);
 				rval = -EPERM;
-				goto done_free_dma_req;
+				goto done_free_dma_rsp;
 			}
 
 			if (elreq.options != EXTERNAL_LOOPBACK) {
@@ -740,7 +740,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 					bsg_job->reply->result =
 						(DID_ERROR << 16);
 					rval = -EPERM;
-					goto done_free_dma_req;
+					goto done_free_dma_rsp;
 				}
 			} else {
 				/* For external loopback to work
@@ -751,7 +751,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 					bsg_job->reply->result =
 						(DID_ERROR << 16);
 					rval = -EPERM;
-					goto done_free_dma_req;
+					goto done_free_dma_rsp;
 				}
 			}
 
@@ -786,7 +786,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 
 				bsg_job->reply->result = (DID_ERROR << 16);
 				rval = -EIO;
-				goto done_free_dma_req;
+				goto done_free_dma_rsp;
 			}
 		} else {
 			type = "FC_BSG_HST_VENDOR_LOOPBACK";
@@ -828,6 +828,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 			rsp_data_len);
 	}
 
+done_free_dma_rsp:
 	dma_free_coherent(&ha->pdev->dev, rsp_data_len,
 		rsp_data, rsp_data_dma);
 done_free_dma_req:
-- 
1.7.9.5

