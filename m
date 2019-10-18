Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D55CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 22:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2744B21852
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 22:24:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ptRZ+mlU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405680AbfJRWY6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 18:24:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58752 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728750AbfJRWEs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 18:04:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9IM3uHc093434;
        Fri, 18 Oct 2019 22:04:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=vGDAIs2HHm8/8dMbQ1HmhFNvicQUZlzI7JtzxZuXHw4=;
 b=ptRZ+mlUHUH22LAOP8gCzn3GN9LMnSXKVqzqqeBW2ewqE5SfajDWaqMkc+W08y0nkmI2
 WJoACtCUkNUvyHQEnMYAUCeefjKNZMYUnXE7luptUYznslxuxV4WGNOiurDv9YU6TU6Y
 BSEFZG5BrXIbAi2xxr2VMzuYE7sPISnvocKeKq5ZQCy8xLkrxNbAGPMqzmbOss6fztdd
 BUQQH7BAO7S5ore5Ta/lpC/2uwiw4HIX3s2fwjuTI0N5B8mWtgcjnZlz8m6Dxs3oIFRE
 HqYtEXL7iNo6VgewiYoFA+GP3SxZxDkaCDZ9akHhTGGL+STQMh26gj1hrxXsHElt2gr8 cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vq0q46965-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 22:04:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9IM2jS8115614;
        Fri, 18 Oct 2019 22:04:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vq0eexkc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 22:04:40 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9IM4dYF017814;
        Fri, 18 Oct 2019 22:04:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 22:04:39 +0000
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Alex Lemberg <alex.lemberg@wdc.com>
Subject: Re: [PATCH] scsi: ufs-bsg: Wake the device before sending raw upiu commands
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1570696267-8487-1-git-send-email-avri.altman@wdc.com>
Date:   Fri, 18 Oct 2019 18:04:36 -0400
In-Reply-To: <1570696267-8487-1-git-send-email-avri.altman@wdc.com> (Avri
        Altman's message of "Thu, 10 Oct 2019 11:31:07 +0300")
Message-ID: <yq1eez9hfrf.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=858
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=940 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180194
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> The scsi async probe process is calling blk_pm_runtime_init for each
> lun, and then those request queues are monitored by the block layer pm
> engine (blk-pm.c).  This is however, not the case for scsi-passthrough
> queues, created by bsg_setup_queue().
>
> So the ufs-bsg driver might send various commands, disregarding the pm
> status of the device. This is wrong, regardless if its request queue
> is pm-aware or not.

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
