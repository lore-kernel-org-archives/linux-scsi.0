From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 14/22] zfcp: clarify that we don't need "link" test on failed open port
Date: Fri, 28 Jul 2017 12:31:00 +0200
Message-ID: <04e5a8789513584a0d4d870b07ec82b9d1ede9d7.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42360 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751879AbdG1KbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:14 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SASfea009404
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:13 -0400
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2c02qcaut8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:13 -0400
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:12 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAVAlC19857898
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F1B8AE0A2
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:27:28 +0100 (BST)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F76AAE0A1
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
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

From: Steffen Maier <maier@linux.vnet.ibm.com>

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index c10b4b9f1574..9f73b8fc7f3b 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -3,7 +3,7 @@
  *
  * Implementation of FSF commands.
  *
- * Copyright IBM Corp. 2002, 2015
+ * Copyright IBM Corp. 2002, 2017
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -1393,6 +1393,8 @@ static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
+			/* no zfcp_fc_test_link() with failed open port */
+			/* fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 		case FSF_SQ_NO_RETRY_POSSIBLE:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-- 
2.11.2
