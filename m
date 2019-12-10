Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 132FBC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEAD12073D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:07:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LRawvDfj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfLJAHz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 19:07:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37058 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfLJAHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 19:07:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA049WE027933;
        Tue, 10 Dec 2019 00:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=nfvfiNn59Br0Y5cyzpzvLpjMzzt3WoBA+ysKa3AGrHQ=;
 b=LRawvDfjjAqG41sw3v4EXcKgTYGf7oAy1Yvb+0o419Ix31F1y09h00QCjUqPqA1uzLDR
 ItJHvT+wcUm1NEKFY8iH2ZihpAdsQ4OAbUVxHcwc0eK6R/UZPE9xwsvzo1x4yaeDuH0a
 2YXTudP5nQhfBI7UGsjrRSBfqdZrz6A+DSi4HsyMi4kgQ3XedRtAYzFurFFTWh3bIYlO
 a4a4WLzfjEJlGw4GNE9UelUtgX6/D4jdTa8qF/pcJ69XX+4/Di0inwUKgdU1IaWEdmwl
 Bx16tSNqEh+YYo7bRkkgqGCBB+PJXD9zk4hv4WL5IUyM37rkgctgxH5JYSGccu8dziWa Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wr4qrat7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:07:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA03wRu057735;
        Tue, 10 Dec 2019 00:05:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wsru83qag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:05:18 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBA05FmW015583;
        Tue, 10 Dec 2019 00:05:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 16:05:15 -0800
To:     sheebab <sheebab@cadence.com>
Cc:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <yuehaibing@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vigneshr@ti.com>, <mparab@cadence.com>, <rafalc@cadence.com>
Subject: Re: [PATCH] scsi: ufs: Disable autohibern8 feature in Cadence UFS
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1575367635-22662-1-git-send-email-sheebab@cadence.com>
Date:   Mon, 09 Dec 2019 19:05:12 -0500
In-Reply-To: <1575367635-22662-1-git-send-email-sheebab@cadence.com>
        (sheebab@cadence.com's message of "Tue, 3 Dec 2019 11:07:15 +0100")
Message-ID: <yq1k175oxjb.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=660
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912090190
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=725 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912090191
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


sheebab,

> This patch disables autohibern8 feature in Cadence UFS.  The
> autohibern8 feature has issues due to which unexpected interrupt
> trigger is happening. After the interrupt issue is sorted out
> autohibern8 feature will be re-enabled

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
