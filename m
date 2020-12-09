Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDDAC4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 14:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B0A423B40
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 14:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgLIOEL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 09:04:11 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43814 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgLIOEL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 09:04:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9DxhsX022579;
        Wed, 9 Dec 2020 14:03:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=wjXaibiyUyP3RuhV5ySGnBOfVuKv/KKTDQcwJxezvCo=;
 b=wHvIdTVSxEOQHSLBEPv0iZICCe2f1mhch6czjVaV+qJJ4iNTmVcleiF4QxANo7DfdiP0
 Llmxk3G834A6bffvX3Ho/yZOlbb1PKkaBfPu9dC5okGkJJy3WkBK+vSRVo4I1ZmugFOl
 uw1WVw+gMM7t8DplSDHOMV5OohqssgdiIkazIeSf8tvkgOP4o6/L8BGIncyj2i5y24WN
 tWkAk5uPfb1/ejmba3Ax3fbo9Hn45ErRvtD5gRdukILCTLEVymxyVAPTLxqEazuf82D7
 AxJJvvsOkMRLePhFXGJMpS4u2eIsB6Ut9pCAcIVKi0XPMdhPpM29KsM8zgYCFsVx2584 JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35825m892h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 14:03:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9E0i3Q083686;
        Wed, 9 Dec 2020 14:03:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 358kyuqe6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 14:03:21 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9E3KTR019021;
        Wed, 9 Dec 2020 14:03:20 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 06:03:19 -0800
Date:   Wed, 9 Dec 2020 17:03:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Signedness bug in _base_get_diag_triggers()
Message-ID: <X9DZH37bYPHwSQRP@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090100
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The "trigger_flags" variable needs to be signed for the error checking
to work.

Fixes: 5767aaffbb8b ("scsi: mpt3sas: Add persistent trigger pages support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 969baf4cd3f5..6e23dc3209fe 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5034,7 +5034,7 @@ _base_check_for_trigger_pages_support(struct MPT3SAS_ADAPTER *ioc)
 static void
 _base_get_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 {
-	u16 trigger_flags;
+	int trigger_flags;
 
 	/*
 	 * Default setting of master trigger.
-- 
2.29.2

