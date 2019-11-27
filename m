Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CD2C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24041206CC
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KyMt+feO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfK0Cj6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 21:39:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39940 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfK0Cj6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 21:39:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR2dMG2016000;
        Wed, 27 Nov 2019 02:39:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=+TjL8MynPiN2l0ad968n419qHgrnc7TPSnKf2zjCgQ4=;
 b=KyMt+feOuyE7lkmVPZY0FWcJT3Z7Ds9JD8gRPnLVpNUvHzAfx59aCnF1wkkuc7hADG2Y
 qavK7jrwsjbU5xurELrbKKESAF1losTJBqzvnpL48C3zG9FT2sWDj2qXZ4kkduJDzi31
 eDiQpJM71RYDWtjjT9kxMU7SMTF8YeYWCeErjFdZ7BkgIKYe9yYCe6d2bG7CW6eFknxT
 aObFdNT1HnRWO/PoylGeKzgQr0aO62c9W/jB6LcY4/q3Zco5oXOhmYKYCaQxWzrBH4l1
 SyG679MOPZIxay27aKkOzDFFKr3CjsZieyraEbU0OjAdjIwPLvqP/cULMWTGTTj2gFSl zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wewdracy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 02:39:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR2dD9n154453;
        Wed, 27 Nov 2019 02:39:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wgwutq5cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 02:39:47 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAR2dj1C013580;
        Wed, 27 Nov 2019 02:39:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 18:39:44 -0800
To:     Huacai Chen <chenhc@lemote.com>
Cc:     hmadhani@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Fuxin Zhang <zhangfx@lemote.com>, linux-scsi@vger.kernel.org,
        Michael Hernandez <michael.hernandez@cavium.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix qla2x00_request_irqs() for MSI
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1574314847-14280-1-git-send-email-chenhc@lemote.com>
Date:   Tue, 26 Nov 2019 21:39:41 -0500
In-Reply-To: <1574314847-14280-1-git-send-email-chenhc@lemote.com> (Huacai
        Chen's message of "Thu, 21 Nov 2019 13:40:47 +0800")
Message-ID: <yq1pnhe82ky.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=875
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=941 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Huacai,

> Commit 4fa183455988adaa ("scsi: qla2xxx: Utilize pci_alloc_irq_vectors
> /pci_free_irq_vectors calls.") use pci_alloc_irq_vectors() to replace
> pci_enable_msi() but it didn't handle the return value correctly. This
> bug make qla2x00 always fail to setup MSI if MSI-X fail, so fix it.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
