Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409E9C38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 03:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E6CB206EC
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 03:38:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hkHRS/QO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgDVDiX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 23:38:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42550 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgDVDiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 23:38:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M3IcbP023189;
        Wed, 22 Apr 2020 03:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=OUNRaT883mHWBshcINZzDXxtsxgUZwB4HI8HSd4a760=;
 b=hkHRS/QOw/cXCC4dXeNj8qNLwE129zEhWSxHVaPE/KFA2xuf9/SXjhvuHTUJr8ArQBAK
 XJiGWa8zmyY4pvQi1WzfQ7E1ssJTgwwcv2WqKbF4pt0vySZHs6ZGgCoiPvbbvhKwqrGJ
 M8v9G62Gw0hPiPcopOVWKHRMwq5WsKPfjcEulUsFfv09kIQBPVMHBmpkO9k4/ecBTxxL
 NR7w+EgjU3aeBiuZWOWLbd+IM3T900i0Oxx+IfXiwZmLVGaVn5UgYVQnk0cTN8oN2pfS
 oSQ/qG2sDAMEJgq61/4fbPZ96UjnpkTmGXwFwSgXn0R8OGw+YuxcpouIAjVrHjxQASM5 rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30fsgm09vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 03:38:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M3IIuO059094;
        Wed, 22 Apr 2020 03:36:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30gb1hfynv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 03:36:06 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03M3a4W4016309;
        Wed, 22 Apr 2020 03:36:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 20:36:04 -0700
To:     hch@infradead.org
Cc:     linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: Re: [v1 0/5] mpt3sas: Fix changing coherent mask after allocation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Date:   Tue, 21 Apr 2020 23:36:02 -0400
In-Reply-To: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu's message of "Wed, 15 Apr 2020 09:25:20 -0400")
Message-ID: <yq1pnc0i44d.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1 spamscore=0
 mlxlogscore=602 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=663 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=1 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220026
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

Please review, thanks!

> * Set the coherent dma mask to 64 bit and then allocate RDPQ pools,
> make sure that each of the RDPQ pools satisfies the 4gb boundary
> restriction. if any of the RDPQ pool doesn't satisfies this
> restriction then deallocate the pools and reallocate them after
> changing the coherent dma mask to 32 bit.
> * With this there is no need to change DMA coherent
> mask when there are outstanding allocations in mpt3sas.
> * Code-Refactoring
>
> Suganath Prabu S (5):
>   mpt3sas: Don't change the dma coherent mask after      allocations
>   mpt3sas: Rename function name is_MSB_are_same
>   mpt3sas: Separate out RDPQ allocation to new function.
>   mpt3sas: Handle RDPQ DMA allocation in same 4G region
>   mpt3sas: Update mpt3sas version to 33.101.00.00
>
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 279 +++++++++++++++++++++---------------
>  drivers/scsi/mpt3sas/mpt3sas_base.h |   9 +-
>  2 files changed, 171 insertions(+), 117 deletions(-)

-- 
Martin K. Petersen	Oracle Linux Engineering
