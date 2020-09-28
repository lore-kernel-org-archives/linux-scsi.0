Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757D7C4727F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 09:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19A4721D95
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 09:13:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yfIqhgkD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgI1JNP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 05:13:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47812 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgI1JNP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 05:13:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S98xjn021122;
        Mon, 28 Sep 2020 09:13:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=onqFxvuNgmSWxb5TyttFFh60aQyyoipjjSNj0YfQXFk=;
 b=yfIqhgkDTFTf+awz5zS7P76xGfYWPpWuEvoSzoKf4BTDGR+JRR5e2DrXvSPVmJyvJn5f
 flj8gl2lBcthRxySyQLW6edl37FyZ9IBK5N9QFlaMp+aSoM8XeLS7IrD/o2x2enKp2oU
 2SOepugO+XxQVA5sTO0C4tXFnE1F2zr+SvW/pHgVKxPAF/R1PegCK5J1bQhNAJtP3qbQ
 mFcqFFmBNZ3sOxi3Um/nqpBj1xNEKjvkvFTzB7vUXmKutGsLHndmf93mSReZLrRdXZa9
 lm6aw7dXnQRhDNlCtWD60ZQFcZ+wA7/k67YANPJPCGFYIJx/jqix41fx1IwQuju+TfWL vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33sx9muvuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 09:13:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S9AekY176903;
        Mon, 28 Sep 2020 09:13:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33tfdprgmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 09:13:09 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08S9D8n4030911;
        Mon, 28 Sep 2020 09:13:08 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 02:13:07 -0700
Date:   Mon, 28 Sep 2020 12:13:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc:     Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Jayamohan Kallickal 
        <jayamohank@HDRedirect-LB5-1afb6e2973825a56.elb.us-east-1.amazonaws.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: be2iscsi: Fix a theoretical leak in
 beiscsi_create_eqs()
Message-ID: <20200928091300.GD377727@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280077
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The be_fill_queue() function can only fail when "eq_vaddress" is NULL
and since it's non-NULL here that means the function call can't fail.
But imagine if it could, then in that situation we would want to store
the "paddr" so that dma memory can be released.

Fixes: bfead3b2cb46 ("[SCSI] be2iscsi: Adding msix and mcc_rings V3")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 5c3513a4b450..202ba925c494 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3020,6 +3020,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 			goto create_eq_error;
 		}
 
+		mem->dma = paddr;
 		mem->va = eq_vaddress;
 		ret = be_fill_queue(eq, phba->params.num_eq_entries,
 				    sizeof(struct be_eq_entry), eq_vaddress);
@@ -3029,7 +3030,6 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 			goto create_eq_error;
 		}
 
-		mem->dma = paddr;
 		ret = beiscsi_cmd_eq_create(&phba->ctrl, eq,
 					    BEISCSI_EQ_DELAY_DEF);
 		if (ret) {
@@ -3086,6 +3086,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 			goto create_cq_error;
 		}
 
+		mem->dma = paddr;
 		ret = be_fill_queue(cq, phba->params.num_cq_entries,
 				    sizeof(struct sol_cqe), cq_vaddress);
 		if (ret) {
@@ -3095,7 +3096,6 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 			goto create_cq_error;
 		}
 
-		mem->dma = paddr;
 		ret = beiscsi_cmd_cq_create(&phba->ctrl, cq, eq, false,
 					    false, 0);
 		if (ret) {
-- 
2.28.0

