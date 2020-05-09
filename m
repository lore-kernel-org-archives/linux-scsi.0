Return-Path: <SRS0=PQdO=6X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14321C28CBC
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 10:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBA0320731
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 10:06:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pXpex+iK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgEIKGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 May 2020 06:06:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52614 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgEIKGX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 May 2020 06:06:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049A4FUJ018556;
        Sat, 9 May 2020 10:06:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Li8WtOoONE2Zqju6d8ioZSCnUb4UNyrQss2HdPTl2s8=;
 b=pXpex+iK1wmKYVpSHU3WL6z9ytY7BLYrdQeIWQ1eHdCgwmmedPpTVsVgII+UK/fGFTCY
 tnBG13R03nDEXGU2ws9ynp6Dv40WNLYJZfJTI3+at0muE+o3Waii/x9tA8LvjWxq7y28
 v7WEqpNY73rAwItmxcfDguU3gvu7Kp/y32LcgPM098tExaPo7Tq6uBD+VXCskDYS4T23
 JW9SoFrOVH7tXBm3YO07aXfrJUwkrDaydDLF1dcuyXn7zwCtjb8UTBD8kTBasy6fbkUZ
 iDfi9+j8fiCbRrt3LpYkZ2jdry+9C8JjEP/JspKx4kQdufb7GEdjSosIHjM7bO+YW4nz Sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30wmfm0m55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 10:06:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049A1v2r120408;
        Sat, 9 May 2020 10:04:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30whmrdf1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 10:04:18 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049A4GTn010551;
        Sat, 9 May 2020 10:04:16 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 03:04:15 -0700
Date:   Sat, 9 May 2020 13:04:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: scsi_debug: fix an error handling bug in
 sdeb_zbc_model_str()
Message-ID: <20200509100408.GA5555@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9615 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9615 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1011 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090094
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This test is checking the wrong variable.  It should be testing "ret".
The "sdeb_zbc_model" variable is an enum (unsigned in this situation)
and we never assign negative values to it.

Fixes: 9267e0eb41fe ("scsi: scsi_debug: Add ZBC module parameter")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 105e563d87b4e..73847366dc495 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6460,7 +6460,7 @@ static int sdeb_zbc_model_str(const char *cp)
 		res = sysfs_match_string(zbc_model_strs_b, cp);
 		if (res < 0) {
 			res = sysfs_match_string(zbc_model_strs_c, cp);
-			if (sdeb_zbc_model < 0)
+			if (res < 0)
 				return -EINVAL;
 		}
 	}
-- 
2.26.2

