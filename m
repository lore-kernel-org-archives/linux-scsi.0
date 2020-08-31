Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1354C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7428720EDD
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hzhZP2Ld"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgHaRlo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 13:41:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728714AbgHaRlj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 13:41:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHU4Ka143362;
        Mon, 31 Aug 2020 17:41:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=mhh/T34Id/oeXjQSAiOVdcnRXbX/mYkee2zkYNz1iJs=;
 b=hzhZP2LdQxOqNhHkm7XQzWTWxHqcdtpJz037mHIOO64p9SaZ9xzbWazTdidJ7L64UuG/
 HzVeeJiXm+anU86h+4gGRhbuj2o7np9irYHTOHkuUiSWv/ggWJRogzLyhCaf7Ld1+kAQ
 fJ94GHmGm7UFKQfRtTruwr8zA8S9PQToDeDDOndldZ5EQ/mK8XhmFTSgXWftEol/v5Tz
 M8f/09++IVB6eBvqv5pnNnHGpPmcpticttZyywqiXrNv7JXzdmcpBxrkctNN06GnexYh
 FV1k4UalYCcUgxKezETaynrZCMY56SxffJTZf/ZuT8CDNhIqj6wmeVaJdrVn34M2FMH4 kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eykyjgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 17:41:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHeu14029445;
        Mon, 31 Aug 2020 17:41:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3380sqbrvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 17:41:26 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VHfP4l007603;
        Mon, 31 Aug 2020 17:41:25 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 10:41:25 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, himanshu.madhani@cavium.com,
        njavali@marvell.com, quinn.tran@cavium.com,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        tianjia.zhang@alibaba.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix wrong return value in qlt_chk_unresolv_exchg()
Date:   Mon, 31 Aug 2020 13:41:11 -0400
Message-Id: <159889566024.22322.12842973873807379058.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200802111528.4974-1-tianjia.zhang@linux.alibaba.com>
References: <20200802111528.4974-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2 Aug 2020 19:15:28 +0800, Tianjia Zhang wrote:

> In the case of a failed retry, a positive value EIO is returned here.
> I think this is a typo error. It is necessary to return an error value.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Fix wrong return value in qlt_chk_unresolv_exchg()
      https://git.kernel.org/mkp/scsi/c/bbf2d06a9d76

-- 
Martin K. Petersen	Oracle Linux Engineering
