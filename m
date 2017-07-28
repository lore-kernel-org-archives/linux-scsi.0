From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 20/22] zfcp: clean up a member of struct zfcp_qdio that was assigned but never used
Date: Fri, 28 Jul 2017 12:31:06 +0200
Message-ID: <7f893474194435f0fe38553e6825611b179ddaf6.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751943AbdG1KbS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:18 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SASbpZ094792
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:18 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2byw11r66v-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:17 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:14 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAVAYH65142874
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0BFAAE0A2
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:27:28 +0100 (BST)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7905AE0A0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:27:28 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.213])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:27:28 +0100 (BST)
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Martin Peschke <mpeschke@linux.vnet.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

v2.6.38 commit a54ca0f62f95 ("[SCSI] zfcp: Redesign of the debug tracing
for HBA records.")
dropped trace information previously introduced with
v2.6.27 commit c3baa9a26c5a ("[SCSI] zfcp: Add information about interrupt
to trace.")
but kept and needlessly assigned a now no longer used struct field.

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
[maier@linux.vnet.ibm.com: reword, added git history]
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c  | 1 -
 drivers/s390/scsi/zfcp_qdio.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index eefb474a9e42..69d1dc3ec79d 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2394,7 +2394,6 @@ void zfcp_fsf_reqid_check(struct zfcp_qdio *qdio, int sbal_idx)
 			      req_id, dev_name(&adapter->ccw_device->dev));
 		}
 
-		fsf_req->qdio_req.sbal_response = sbal_idx;
 		zfcp_fsf_req_complete(fsf_req);
 
 		if (likely(sbale->eflags & SBAL_EFLAGS_LAST_ENTRY))
diff --git a/drivers/s390/scsi/zfcp_qdio.h b/drivers/s390/scsi/zfcp_qdio.h
index 85cdb82127e8..7f647a90c750 100644
--- a/drivers/s390/scsi/zfcp_qdio.h
+++ b/drivers/s390/scsi/zfcp_qdio.h
@@ -54,7 +54,6 @@ struct zfcp_qdio {
  * @sbal_last: last sbal for this request
  * @sbal_limit: last possible sbal for this request
  * @sbale_curr: current sbale at creation of this request
- * @sbal_response: sbal used in interrupt
  * @qdio_outb_usage: usage of outbound queue
  */
 struct zfcp_qdio_req {
@@ -64,7 +63,6 @@ struct zfcp_qdio_req {
 	u8	sbal_last;
 	u8	sbal_limit;
 	u8	sbale_curr;
-	u8	sbal_response;
 	u16	qdio_outb_usage;
 };
 
-- 
2.11.2
