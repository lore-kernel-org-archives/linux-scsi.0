Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDAAC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 06:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94462238D6
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 06:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbhAUGJ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 01:09:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36064 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbhAUGJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2021 01:09:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L63Y2J063401;
        Thu, 21 Jan 2021 06:08:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=BKTmDn4+SGZjxL0GqTs40duq5z1Lf/bxap1CYtFK5mc=;
 b=gVvgPRt0GS+8SQa49uBYs/4XONyXVSoXVEX7e9wbPiK6X49J+Z4apg0wh+X1xPaXl74v
 eiA0JYygHZMEdS2gYL4mYlfl8oWMmU0llUo82BF5NHXreYFVcgrMTm4jqWDuqshMElf9
 RJ3RGVHBB55RJj7CPJdt4ZVGmtO5BqaNcBuyPEj2FZJrcPZQi9RaAhnaGjkekYVrad3J
 irOC5WpnSzMpdC+2YY2jofuG0bmGr5fIB9mgZXIz59cnZlxm1jeAHzaN+C0ACcjbCe3Z
 TuLJEseN5bCdmZh0zm0K8qi5s7zL/4UvTiT+i0EHNbi+HKaAWqWxFa4fRj/9nmg33gp1 dQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3668qadq75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 06:08:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L64g4O012929;
        Thu, 21 Jan 2021 06:08:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3668qwexfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 06:08:49 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10L68mfS017364;
        Thu, 21 Jan 2021 06:08:49 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Jan 2021 22:08:48 -0800
Date:   Thu, 21 Jan 2021 09:08:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: remove unnecessary NULL check
Message-ID: <YAkaaSrhn1mFqyHy@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210031
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The list iterator can't be NULL so this check is not required.  Removing
the check silences a Smatch warning about inconsistent NULL checking.

    drivers/scsi/qla2xxx/qla_dfs.c:371 qla_dfs_tgt_counters_show()
    error: we previously assumed 'fcport' could be null (see line 372)

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index ccce0eab844e..85bd0e468d43 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -369,7 +369,7 @@ qla_dfs_tgt_counters_show(struct seq_file *s, void *unused)
 	seq_puts(s, "\n");
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
-		if (!fcport || !fcport->rport)
+		if (!fcport->rport)
 			continue;
 
 		seq_printf(s, "Target Num = %7d Link Down Count = %14lld\n",
-- 
2.29.2

