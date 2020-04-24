Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A802BC54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 17:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B5C220736
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 17:31:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="s4WXIf+A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgDXRbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 13:31:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51850 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgDXRbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 13:31:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OHNJlT086233;
        Fri, 24 Apr 2020 17:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=b63l/bhQnnn4+X9p4WKXJx5KlkkWuUUaaW0oUwuChlk=;
 b=s4WXIf+Av70xx6dMeb2fMORHwquUxIrXzLMXqTOx07nOdnmxRyzbOT6r8wmfcSO8y5y/
 UGyKvhSfU6L8EU49xnJEp9NzFt9CCBGBEf7e2G1buu+exXAPgud2CdnrQOZYvFbRz2o7
 p9nBx/Qc3Cne1aaEE/boO0AFJxRROtzLiMn/KSskdbB1tsRw5wNwUXGwUKvCbelQR5T9
 /ymu4+eF1OU5A0Isll9P5jdm+0ifIMDHuxSPlC6vLacAFKYDQk5l+W9EVmHVTYq7VZig
 U1YMU/zPYvvfXXXNkjTAlYPfd/BjMIvUyyLrxFOgCmPmVpnkpyCsEzDHxq/Tb8jy+bWW tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30ketdnmfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 17:30:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OHLm7r162378;
        Fri, 24 Apr 2020 17:30:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30gb3xrsqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 17:30:58 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03OHUur9026087;
        Fri, 24 Apr 2020 17:30:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 10:30:56 -0700
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <khalid@gonehiking.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <colin.king@canonical.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: BusLogic: remove conversion to bool in blogic_inquiry()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200421034120.28433-1-yanaijie@huawei.com>
Date:   Fri, 24 Apr 2020 13:30:54 -0400
In-Reply-To: <20200421034120.28433-1-yanaijie@huawei.com> (Jason Yan's message
        of "Tue, 21 Apr 2020 11:41:20 +0800")
Message-ID: <yq1v9lodc4x.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=851 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=925 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1011 suspectscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240134
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> The '!=' expression itself is bool, no need to convert it to bool again.
> This fixes the following coccicheck warning:
>
> drivers/scsi/BusLogic.c:2240:46-51: WARNING: conversion to bool not
> needed here

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
