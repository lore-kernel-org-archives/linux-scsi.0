Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C27C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B21B20776
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:00:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L6U9bq7c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgFPEAW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 00:00:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41350 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgFPEAV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 00:00:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3x7Hi195261;
        Tue, 16 Jun 2020 04:00:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=T5hzYSYN442W0oxO94O6+jqYL1uhUUuRzzGEF6WRSQw=;
 b=L6U9bq7cvcWI6FLElD8kvQ1wAC4PgP2vRofm4rLHKdQsyx/8XhKKIUDXzk5iJ3Ro4P0Y
 gapWdkaOdpILgnmmcJo+QkHx20IzPYNlSJD0T6wJDfD5u4H8oaVmvD7aDAOFfp1PIFie
 +qy7mqTCWRv3HMnCqrmxjtHwEuX4ojXcBWp3ylsHKWaivkZeAviC/4Fay+fzximQYhzP
 gfyqUSgt+wvkkdAAKLnzknkUpP93ka4/VBQ6EKV3PBEC4m0VZZmknQ1xJ+hC87xnd1zJ
 IsjrpbGt9wDIkFErpL/y/yOvxzuv+FoYnbTqs3FZd2n6diQq52dV6cdfdH6K34NZ4rtz pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31p6e5vd9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 04:00:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3w841171561;
        Tue, 16 Jun 2020 04:00:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31p6s6mhgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 04:00:05 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05G403rQ023145;
        Tue, 16 Jun 2020 04:00:03 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 21:00:03 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     beanhuo@micron.com, stanley.chu@mediatek.com, jejb@linux.ibm.com,
        bvanassche@acm.org, ebiggers@kernel.org, cang@codeaurora.org,
        avri.altman@wdc.com, asutoshd@codeaurora.org,
        tomas.winkler@intel.com, Bean Huo <huobean@gmail.com>,
        alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] scsi: ufs: cleanup UFS driver
Date:   Mon, 15 Jun 2020 23:59:53 -0400
Message-Id: <159227986422.24883.17586255504955251143.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200605200520.20831-1-huobean@gmail.com>
References: <20200605200520.20831-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=917 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 mlxscore=0 phishscore=0 mlxlogscore=947 lowpriorityscore=0 clxscore=1011
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 5 Jun 2020 22:05:18 +0200, Bean Huo wrote:

> Cleanup, no functional change
> 
> Changelog:
> 
> v2 -v3:
>     1. Change SPDX-License-Identifier: GPL-2.0 to
>        SPDX-License-Identifier: GPL-2.0-or-later (Eric Biggers)
> v1 - v2:
>     1. Split patch (Tomas Winkler)
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2 boilerplate
      https://git.kernel.org/mkp/scsi/c/673511199ac9

-- 
Martin K. Petersen	Oracle Linux Engineering
