From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] [SCSI] lpfc 8.3.36: fix potential NULL pointer
 dereference in lpfc_sli4_rq_put()
Date: Sun, 2 Dec 2012 08:33:24 -0500
Message-ID: <CAPgLHd8VqtYG2cS3627WtxizaNugb9x=85+cZiQEgQc3Fp_kjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43682 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2LBNdY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:33:24 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so1057316qcr.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:33:24 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference to 'put_index' should be moved below the NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/lpfc/lpfc_sli.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 624eab3..a9a7fd7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -431,11 +431,12 @@ lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
 	struct lpfc_rqe *temp_hrqe;
 	struct lpfc_rqe *temp_drqe;
 	struct lpfc_register doorbell;
-	int put_index = hq->host_index;
+	int put_index;
 
 	/* sanity check on queue memory */
 	if (unlikely(!hq) || unlikely(!dq))
 		return -ENOMEM;
+	put_index = hq->host_index;
 	temp_hrqe = hq->qe[hq->host_index].rqe;
 	temp_drqe = dq->qe[dq->host_index].rqe;
 


