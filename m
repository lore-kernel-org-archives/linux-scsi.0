Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE21C48BD1
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A36816124B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbhFIJ2Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 05:28:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40646 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237844AbhFIJ2O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 05:28:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1599FHD1193957;
        Wed, 9 Jun 2021 09:26:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=6S6WmF1RHkA6lwvFt9GfzxcKo7EcUbACQoyh5cO86RU=;
 b=hAc0xeaqrhz9SntQjWxIyQtEdB/7q8vMmeLDZlyakUA0c/FJTyFnec9bxxLXOXXth3Si
 fPWfV3Ggcte8GfBfLZsHpw5aek6TIefbHtu5IhhbswRzq6OZEAkffO2TCzqrtb/iuiTw
 CMug6RZE+QG3ccUkyqtDbZNX7Txq787FkC7Md/h2OzAN0uQ3Emti6F+zS8EcPrhfkSaJ
 GWjrm+TFBVKlI7ltCFbJLnofrMjUhqXUriPHodKmrfQORuL9UIQ4cps788xoZ1c1zM88
 qqHB3fq1DBmaKGgDEdh6IX/KRBOJYdwCpqy3WWcLTZnmZAqW7EW39qQWy5qqKvOrHQPS fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3900ps8kch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:26:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1599P48Z128246;
        Wed, 9 Jun 2021 09:26:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 390k1rs72q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:26:12 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1599QCmb129998;
        Wed, 9 Jun 2021 09:26:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 390k1rs72a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:26:12 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1599QAWG005757;
        Wed, 9 Jun 2021 09:26:11 GMT
Received: from mwanda (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jun 2021 09:26:10 +0000
Date:   Wed, 9 Jun 2021 12:26:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Tomas Henzl <thenzl@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] scsi: mpi3mr: delete unnecessary NULL check
Message-ID: <YMCJKgykDYtyvY44@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: 6U61dNLuiHdyJTxWQ3MlWxuCzS5JlmF8
X-Proofpoint-ORIG-GUID: 6U61dNLuiHdyJTxWQ3MlWxuCzS5JlmF8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1011
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090042
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The "mrioc->intr_info" pointer can't be NULL, but if it could then the
second iteration through the loop would Oops.  Let's delete the
confusing and impossible NULL check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index acb2be62080a..40696b75345d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3583,8 +3583,7 @@ static void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 
 	for (i = 0; i < mrioc->intr_info_count; i++) {
 		intr_info = mrioc->intr_info + i;
-		if (intr_info)
-			intr_info->op_reply_q = NULL;
+		intr_info->op_reply_q = NULL;
 	}
 
 	kfree(mrioc->req_qinfo);
-- 
2.30.2

