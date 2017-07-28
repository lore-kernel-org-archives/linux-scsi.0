From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 01/22] zfcp: replace zfcp_qdio_sbale_count by sg_nents
Date: Fri, 28 Jul 2017 12:30:47 +0200
Message-ID: <40f8ed99ea59fb87b9a434867527c2a3ec290d4f.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751898AbdG1KbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:14 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SASt9l055972
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:14 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bywagyb4a-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:14 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:12 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAV9T338010882
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECFD9A40A3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:13 +0100 (BST)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D00ECA40A5
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:13 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.213])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:13 +0100 (BST)
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

From: LABBE Corentin <clabbe.montjoie@gmail.com>

The zfcp_qdio_sbale_count function do the same work than sg_nents().
So replace it by sg_nents() for removing duplicate code.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c  |  3 +--
 drivers/s390/scsi/zfcp_qdio.h | 15 ---------------
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 27ff38f839fc..3b69ec5e69ed 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -991,8 +991,7 @@ static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
 		qtcb->bottom.support.resp_buf_length =
 			zfcp_qdio_real_bytes(sg_resp);
 
-		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
-					zfcp_qdio_sbale_count(sg_req));
+		zfcp_qdio_set_data_div(qdio, &req->qdio_req, sg_nents(sg_req));
 		zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 		zfcp_qdio_set_scount(qdio, &req->qdio_req);
 		return 0;
diff --git a/drivers/s390/scsi/zfcp_qdio.h b/drivers/s390/scsi/zfcp_qdio.h
index 497cd379b0d1..85cdb82127e8 100644
--- a/drivers/s390/scsi/zfcp_qdio.h
+++ b/drivers/s390/scsi/zfcp_qdio.h
@@ -225,21 +225,6 @@ void zfcp_qdio_set_data_div(struct zfcp_qdio *qdio,
 }
 
 /**
- * zfcp_qdio_sbale_count - count sbale used
- * @sg: pointer to struct scatterlist
- */
-static inline
-unsigned int zfcp_qdio_sbale_count(struct scatterlist *sg)
-{
-	unsigned int count = 0;
-
-	for (; sg; sg = sg_next(sg))
-		count++;
-
-	return count;
-}
-
-/**
  * zfcp_qdio_real_bytes - count bytes used
  * @sg: pointer to struct scatterlist
  */
-- 
2.11.2
