Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134EAC46466
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2E3C208C3
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VC/ZwVXt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgJGDs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36258 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbgJGDsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973huqX044764;
        Wed, 7 Oct 2020 03:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9UW3Bx/86TTM/WE08JRgSz9+jvQmbOXKD+uQ+dgzFNo=;
 b=VC/ZwVXtV5hrt+uGOJ4I8Rk4XEW+aszbmdcrNZWXUSKR8H73jrudaVew1Z4V0fqjR/5S
 0kWc7HYL58BjEKu3wJ03inAHdYiGeIqcZJCnKWTvPxyFWH7mlxvsV65WMfjOUHraI0WK
 bgjQq8a5wf/5zrp9xNhqhzDGktboqKRrckhB/9/OrJZGH5EPr9AVtBZID9f/Cmbm2TKa
 IU8igypMhfi94L8JvSYXosZKyco10bkE56w00lHud9HR8ZVAs5P8Hrc9VW+l1Xhkbt85
 CUZkO8s6qiStv2Ndb0NyFdm5DJ+OkNxl869u3xIYFAbuv30Y7VTwdgWpYLWMKJB2GWgN lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33ym34mjy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973j9K2041272;
        Wed, 7 Oct 2020 03:48:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33yyjgm85r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:15 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0973mE4j012434;
        Wed, 7 Oct 2020 03:48:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:14 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>, jejb@linux.ibm.com,
        kartilak@cisco.com, sebaddel@cisco.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: Remove unnecessary condition to simplify the code
Date:   Tue,  6 Oct 2020 23:47:53 -0400
Message-Id: <160204240576.16940.2447210843012383567.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925060754.156599-1-jingxiangfeng@huawei.com>
References: <20200925060754.156599-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 25 Sep 2020 14:07:54 +0800, Jing Xiangfeng wrote:

> ret is always zero or an error in this code path. So the assignment to
> ret is redundant, and the code jumping to a label is unneed.
> Let's remove them to simplify the code. No functional changes.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: snic: Remove unnecessary condition
      https://git.kernel.org/mkp/scsi/c/2a7869d6c9a1

-- 
Martin K. Petersen	Oracle Linux Engineering
