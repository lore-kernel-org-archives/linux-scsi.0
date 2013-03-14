From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/3] ipr: fix addition of abort command to HRRQ free queue
Date: Thu, 14 Mar 2013 13:52:23 -0500
Message-ID: <20130314185803.296328943@linux.vnet.ibm.com>
References: <20130314185222.994529433@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:27380 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751214Ab3CNTAa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Mar 2013 15:00:30 -0400
Content-Disposition: inline; filename=ipr_fix_hrrq_free_queue
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

The abort command issued by ipr_cancel_op() is being added to the wrong
HRRQ free queue after the command returns. Fix it by using the HRRQ
pointer in the ipr command struct itself.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-03-14 11:49:29.819030052 -0500
+++ b/drivers/scsi/ipr.c	2013-03-14 13:15:46.289276262 -0500
@@ -5148,7 +5148,7 @@ static int ipr_cancel_op(struct scsi_cmn
 		ipr_trace;
 	}
 
-	list_add_tail(&ipr_cmd->queue, &hrrq->hrrq_free_q);
+	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 	if (!ipr_is_naca_model(res))
 		res->needs_sync_complete = 1;
 

-- 
