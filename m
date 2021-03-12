Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B8AC433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 07:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CA5C64F85
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 07:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCLHoU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 02:44:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40502 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhCLHoD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 02:44:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12C7eJMw112996;
        Fri, 12 Mar 2021 07:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=x7/XZdway8tgcNq4aGiDhubXVJpHeywX62/iMwMuNN4=;
 b=SYqe5tYmZt1U6Xkd4fky9p2d5osxD9Ie21bR5m7N+PXWqFgMckAmZn3M0zL2lv+Pnc8N
 oQ0RRk7KeOH54AjeV7hnf9eaVTZegbo2iKYRzjTSfxaFmSy4kHMzP8E1Q4m1npQbTzB4
 gdNgVtNXMvnhtyTiXPI8gWwxOptBBGqzQxeMp2hKPEvk6OO6wNiKXz35nt7LWkhlCWO5
 MSbZS3shMNSpe+mFypbcTSerscTlCDH/QQiEEeOfdeoi58x0G67qB5DtqrPJ/tuGHhCP
 VFHah8Wb/toEsfkieGYMb+S9mRRHEhXJakGEzkDVQtOAdwc/syYcB406+spmOyx5H+iU RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37415rh3ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 07:43:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12C7dYfX095626;
        Fri, 12 Mar 2021 07:43:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 374kasx9bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 07:43:54 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12C7hqsa017552;
        Fri, 12 Mar 2021 07:43:52 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Mar 2021 23:43:51 -0800
Date:   Fri, 12 Mar 2021 10:43:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Doug Gilbert <dgilbert@interlog.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: sg: Fix a use after free on error in sg_add_sfp()
Message-ID: <YEsbsPDfYSWbUaqJ@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120051
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120051
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SG_LOG() error message dereferences "sfp" so move the kfree down a
couple lines.

Fixes: af1fc95db445 ("scsi: sg: Replace rq array with xarray")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2d4bbc1a1727..79f05afa4407 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -3799,10 +3799,10 @@ sg_add_sfp(struct sg_device *sdp)
 	if (rbuf_len > 0) {
 		srp = sg_build_reserve(sfp, rbuf_len);
 		if (IS_ERR(srp)) {
-			kfree(sfp);
 			err = PTR_ERR(srp);
 			SG_LOG(1, sfp, "%s: build reserve err=%ld\n", __func__,
 			       -err);
+			kfree(sfp);
 			return ERR_PTR(err);
 		}
 		if (srp->sgat_h.buflen < rbuf_len) {
-- 
2.30.1

