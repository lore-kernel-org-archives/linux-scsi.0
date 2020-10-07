Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EEFC46466
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64D3620B1F
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y6Hn3qMX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgJGDs2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36262 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727153AbgJGDsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973iMdN044901;
        Wed, 7 Oct 2020 03:48:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+FFn10ujS8xQluWQ3SyPXQO7sbDfyWYJj4kfmQe/Qjo=;
 b=Y6Hn3qMXrPtXhFhiahN7863w6N7jAKChv1tv8JaOUni1Gj27eBFWbn42TGbgHMweIuRY
 Ic/FrGs5b3j2sg/EqEkIeDthPhPH71kmu9W+nfro003plrqNo0RmE/qyDFYK/HQzKBjb
 W9+oL4OY747SkFlIPfiT7uaYDcTnIrNvfak9kPz0V7IwEgMwSX9VyETPu8D+TP4l3I1G
 4PULQMmfY0STZh8z/8a6nnhK7D6SqZw/ViDVf+K+a+IS9RGH2pInQgya2rphNxD28QkT
 knaOey6XVJFi47Qv7ZUorCORWsQ3CF8nXaTpuLHEefztYVw0MkesmNSWMxWYF9nyx7xQ Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33ym34mjxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973jAo3041333;
        Wed, 7 Oct 2020 03:48:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33yyjgm84u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:13 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0973mCKH012424;
        Wed, 7 Oct 2020 03:48:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:12 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: mvumi: Fix error return in mvumi_io_attach()
Date:   Tue,  6 Oct 2020 23:47:51 -0400
Message-Id: <160204240579.16940.2442955908417562654.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910123848.93649-1-jingxiangfeng@huawei.com>
References: <20200910123848.93649-1-jingxiangfeng@huawei.com>
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

On Thu, 10 Sep 2020 20:38:48 +0800, Jing Xiangfeng wrote:

> Fix to return error code PTR_ERR() from the error handling case instead
> of 0.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: mvumi: Fix error return in mvumi_io_attach()
      https://git.kernel.org/mkp/scsi/c/055f15ab2cb4

-- 
Martin K. Petersen	Oracle Linux Engineering
