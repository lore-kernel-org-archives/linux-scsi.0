From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 4/5] qla2xxx: Free rsp_data even on error in qla2x00_process_loopback()
Date: Wed, 21 Nov 2012 02:39:56 -0500
Message-ID: <1353483597-17206-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483597-17206-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:8964 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753338Ab2KUH6H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:07 -0500
In-Reply-To: <1353483597-17206-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Steve Hodgson <steve@purestorage.com>

Signed-off-by: Steve Hodgson <steve@purestorage.com>
Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 05520be..9f34ded 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -743,7 +743,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 				ql_log(ql_log_warn, vha, 0x701f,
 				    "Get port config failed.\n");
 				rval = -EPERM;
-				goto done_free_dma_req;
+				goto done_free_dma_rsp;
 			}
 
 			ql_dbg(ql_dbg_user, vha, 0x70c0,
@@ -762,7 +762,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 
 			if (rval) {
 				rval = -EPERM;
-				goto done_free_dma_req;
+				goto done_free_dma_rsp;
 			}
 
 			type = "FC_BSG_HST_VENDOR_LOOPBACK";
@@ -795,7 +795,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 				}
 
 				rval = -EIO;
-				goto done_free_dma_req;
+				goto done_free_dma_rsp;
 			}
 		} else {
 			type = "FC_BSG_HST_VENDOR_LOOPBACK";
@@ -830,6 +830,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 	fw_sts_ptr += sizeof(response);
 	*fw_sts_ptr = command_sent;
 
+done_free_dma_rsp:
 	dma_free_coherent(&ha->pdev->dev, rsp_data_len,
 		rsp_data, rsp_data_dma);
 done_free_dma_req:
-- 
1.7.7

