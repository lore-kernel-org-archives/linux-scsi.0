Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C011C2BA2B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 17:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E161F20692
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 17:30:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NzuAhNnN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732798AbgDMRaA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 13:30:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44490 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732781AbgDMR37 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 13:29:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DHSdR2169183;
        Mon, 13 Apr 2020 17:28:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=VpPjezWpp2fBFTqgtsqL0SE6+xEpZn+3Xh+uCrF62mM=;
 b=NzuAhNnNqhibFcFoUT9UGE4LtMix29o8B4Yr7517akm0XQyxEERazgy9AUiEXuB4DWYF
 VK7c4rlCgFMDS+35naW/MEsUdhnpU8PKH8GXmX2+qmm9GwrLQ3K6KLwnmfm6OCnTEuti
 hwBQlgmiKDebzrr24HO/vbETeAcG7Ls2msx0Q+lr1Sb1lkvw68bphC+mMF0moq3tQWRB
 i2EfttRo8LLbr0lPp7ceeKcYY3qZwVJFnCApqMYw8JCrjbnAmIB8R6TFDhh1113ahTsM
 mnQ3qhrg3J2SjJhLuvfvJsaNI04UJHh/QD1rJMwqmNOgcwC/1a1YBiM1Oahhu4b0DfD+ Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30b5aqyveh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 17:28:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DHRhOM100879;
        Mon, 13 Apr 2020 17:28:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30bqceq8bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 17:28:50 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03DHSmb1020744;
        Mon, 13 Apr 2020 17:28:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 10:28:48 -0700
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <chenxiang66@hisilicon.com>,
        <b.zolnierkie@samsung.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: hisi_sas: Fix build error without SATA_HOST
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200402063021.34672-1-yuehaibing@huawei.com>
        <20200402085812.32948-1-yuehaibing@huawei.com>
Date:   Mon, 13 Apr 2020 13:28:45 -0400
In-Reply-To: <20200402085812.32948-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Thu, 2 Apr 2020 16:58:12 +0800")
Message-ID: <yq1wo6jxpki.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1011 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130133
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yue Haibing,

> If SATA_HOST is n, build fails:
>
> drivers/scsi/hisi_sas/hisi_sas_main.o: In function
> `hisi_sas_fill_ata_reset_cmd': hisi_sas_main.c:(.text+0x2500):
> undefined reference to `ata_tf_to_fis'
>
> Select SATA_HOST to fix this.

Applied to 5.7/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
