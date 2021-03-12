Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B96C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 07:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B735664F77
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 07:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhCLHox (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 02:44:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58464 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhCLHoY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 02:44:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12C7cweJ099022;
        Fri, 12 Mar 2021 07:44:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=UrF5Wu2v6ZmzUalazIBf+NIOF3QlofixQDihZKeBXm0=;
 b=WfpqwymqhRIUsw6dmPh36xHRa0E8+wOilkBQ2hMq+dxQQSm21yzbtYa3Bs7VkDf76uuf
 K9EdKPyTlxRWkiv9zRh35gfMx6TMwgP7EhD6Z8IKzKGWnNJllgoDH4HC351kRoP03TUp
 CwUwQGhEJZdi6B+7dd8F9mFZTCYIJMpnaT47DSIRF712WzWtrUTvdGgKOo1gtfvppS8O
 alkYsf8LfLNpv0E6VLUrom4RAC5ocmbI7WXAOfCxGbYz9RlWKzKnzQlX8w9f+HuI0DVr
 CbRxuq9HGuEoJTKgancvA/N0lqsftRu/kc9fWelpvsKAqqfeqEgCfoqEU/HBV37Iwpwn 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3741pms38p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 07:44:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12C7fAgp131547;
        Fri, 12 Mar 2021 07:44:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 374kgw5q42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 07:44:17 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12C7iGnS017913;
        Fri, 12 Mar 2021 07:44:16 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Mar 2021 07:44:16 +0000
Date:   Fri, 12 Mar 2021 10:44:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Doug Gilbert <dgilbert@interlog.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: sg: Fix a warning message
Message-ID: <YEsbyEf3/+AunY34@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120051
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120051
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The WARN_ONCE() macro takes a condition and a warning message as
parameters.  This code accidentally left out the condition so it
doesn't print a warning (just a stack trace).

Fixes: ddfb8cbdf699 ("scsi: sg: Rework scatter-gather handling")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 79f05afa4407..e261260c1b8b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2525,7 +2525,7 @@ sg_rq_end_io_usercontext(struct work_struct *work)
 	struct sg_fd *sfp;
 
 	if (!srp) {
-		WARN_ONCE("%s: srp unexpectedly NULL\n", __func__);
+		WARN_ONCE(1, "%s: srp unexpectedly NULL\n", __func__);
 		return;
 	}
 	sfp = srp->parentfp;
-- 
2.30.1

