Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D453DCA90AF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 09:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABAFB20769
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 09:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BZ2Ylcx0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgEMJh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 05:37:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36574 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbgEMJh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 05:37:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04D9bJes016181;
        Wed, 13 May 2020 09:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=MeY7UEwws+nUZj742E+tUlYvuDD2IWvPTxv7x8obghM=;
 b=BZ2Ylcx0kRlpFyOp8yUqzU5ER0xZTdv8ZQINuwUBZkD4KnrWEu6dX+A4036fXEi60nTO
 XwVdW18VJQvCbogQ8neEWysCo7Hd/d38UWCKpJXYyiboAZB2UYeDMyEDkI00LjKqYyCo
 r/QoA+T17WT4OaQ4LEvyVJPxqxINyD2tT5v9omF2vJ6dcpRSKUeM+PHKosNFsdRLdWku
 5PKLuazmvt8Ko+txka/TAjYY0xwG8gjQRRDZ2xZln9Se0dTDfHPj0cQ+mcYyaLZ4FrKG
 QhtBN8eRmGM5CK6WU8vgjWgwnQxRphTwL8v/+nEyT9jSqryeICnSrd8NPRp2yCO6q9Jk hA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3100xwk4um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 09:37:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04D9IaXc041860;
        Wed, 13 May 2020 09:37:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3100yr0j1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 09:37:11 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04D9b9nV020973;
        Wed, 13 May 2020 09:37:09 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 May 2020 02:37:09 -0700
Date:   Wed, 13 May 2020 12:37:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Zou Wei <zou_wei@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: aacraid: Fix an Oops in error handling
Message-ID: <20200513093703.GB347693@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005130086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130087
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the memdup_user() function fails then it results in an Oops in the
error handling code when we try to kfree() and error pointer.

Fixes: 8d925b1f00e6 ("scsi: aacraid: Use memdup_user() as a cleanup")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/aacraid/commctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 102658bdc15a..34e65dea992e 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -516,6 +516,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	user_srbcmd = memdup_user(user_srb, fibsize);
 	if (IS_ERR(user_srbcmd)) {
 		rcode = PTR_ERR(user_srbcmd);
+		user_srbcmd = NULL;
 		goto cleanup;
 	}
 
-- 
2.26.2

