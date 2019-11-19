Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7BAC432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 04:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55549222DD
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 04:37:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gy4Kg9Hx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfKSEhz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 23:37:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58032 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfKSEhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 23:37:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ4Xfvq083384;
        Tue, 19 Nov 2019 04:37:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=u3YVsD1wkCGiOGWe+S9b9QJmcTwJFEXyOfczc59CBcQ=;
 b=gy4Kg9Hxa8G5FPvXmUfJUReX9MjTRIN7rXb7ez2Xth+xw7Vjw3uI/SB+TRoZ74BW8wnD
 VpJ/N85V8VGDTM5IMNrwSjCI+D2eXacRH0LlP+RxX90kXAR8ZjVcGmOHZ6tDCbSo24VM
 35l5mGoVfCYV+sSmWpKmil9FGxP0DAx1yf0P/4rkPIKx3vMl82Y4HjqqbgoKraed8h2h
 YZwIpLewn3drNbHCyIa41qz6SfnjCedhhYUuT0pLN7Ln1nkgRL4qeRhacNlSzKPU2JfQ
 zkcjA1Y+wdMlfo6V1S1LAlT9n9CRjLewV5di7MTZFyrKAT+jU9IzySnrKqmXmsS/gHiR DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wa92pmbay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 04:37:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ4X8ZX117062;
        Tue, 19 Nov 2019 04:37:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wbxm3m2yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 04:37:04 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAJ4b2eP001299;
        Tue, 19 Nov 2019 04:37:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 20:37:01 -0800
To:     sheebab <sheebab@cadence.com>
Cc:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <vigneshr@ti.com>,
        <linux-block@vger.kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <yuehaibing@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <mparab@cadence.com>
Subject: Re: [PATCH RESEND 0/2] scsi: ufs: hibern8 fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1573815645-11886-1-git-send-email-sheebab@cadence.com>
Date:   Mon, 18 Nov 2019 23:36:58 -0500
In-Reply-To: <1573815645-11886-1-git-send-email-sheebab@cadence.com>
        (sheebab@cadence.com's message of "Fri, 15 Nov 2019 16:30:43 +0530")
Message-ID: <yq1eey4jxcl.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190040
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


sheebab,

> Resending this patch to include 'mailing list' which I missed in first
> release.
>
> This patch set contains following patches for Cadence UFS controller
> driver.
>
> 1. 0001-scsi-ufs-Enable-hibern8-interrupt-only-during-manual.patch
>    This patch is to fix false interrupt assertion during auto hibernation.
>    In this patch, hibern8 interrupt is Disabled during initialization
>    and later the interrupt is Enabled/Disabled during manual hibern8
>    Entry/Exit.
> 2. 0002-scsi-ufs-Update-L4-attributes-on-manual-hibern8-exit.patch
>    This patch is to update L4 attributes during manual hibern8 exit.
>    As per JESD220C spec, L4 attributes will be reset to their reset value 
>    during DME_HIBERNATION_EXIT. This patch will take backup of the L4 
>    parameters before DME_HIBERNATION_ENTER and restores the L4 parameters
>    after DME_HIBERNATION_EXIT

Only the cover letter made it to the list. Please make sure patch
submissions are sent to linux-scsi@vger.kernel.org.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
