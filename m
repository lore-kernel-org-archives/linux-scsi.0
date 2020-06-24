Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C932EC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 04:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4A932084D
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 04:32:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kg1ATaqE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgFXEck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 00:32:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44822 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgFXEcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 00:32:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4VmLx056468;
        Wed, 24 Jun 2020 04:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=hmxHtDEf8qggH1BduO5jZy4v/XbgLVGXSCs2Wh5L5WY=;
 b=Kg1ATaqERtKV/g0RAuNfW4LT1IUolaAnx5AXCRpVoAjPJkt2uYue29ba96/mMvD92YV1
 Cn+H/viIDNGAbMs4nQb4tiYh2i849bvUunhNk/Qvy4TQIPvdh9/J289z2DQ8PH4Q9VmC
 zCQMe6MGpQNnO7Bmq3RGK3wpUzXJUtb/GLaCSSb5avKdJwQdSpmy+zzawk7WrNI+G3Uo
 sQyJhxu2MYVUj6IIPVbgjqEcvovFA4CHOkiHWmFvgPuFjjZfUmxb+smyXrLZ0DwQU60H
 DzdWKJAwABfVc51vdJW+09EesCTAocrB1ocB4be+BwiqhKCx7LQhqSlSUfLyp3ERrkYT Ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31uustgm4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Jun 2020 04:32:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4Nq3S086453;
        Wed, 24 Jun 2020 04:30:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31uuqy7efd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jun 2020 04:30:26 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05O4UODs011448;
        Wed, 24 Jun 2020 04:30:24 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jun 2020 04:30:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, cang@codeaurora.org,
        stanley.chu@mediatek.com, kwmad.kim@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com
Subject: Re: [PATCH -next] scsi: ufs: allow exynos ufs driver to build as module
Date:   Wed, 24 Jun 2020 00:30:21 -0400
Message-Id: <159297300656.9917.9729755942442191014.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200620173232.52521-1-alim.akhtar@samsung.com>
References: <CGME20200620175104epcas5p25068bb07029c9d6aff56623e4ecb0a26@epcas5p2.samsung.com> <20200620173232.52521-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006240031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006240032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 20 Jun 2020 23:02:32 +0530, Alim Akhtar wrote:

> Allow Exynos UFS driver to build as a module.
> This patch fix the below build issue reported by
> kernel build robot.
> 
> drivers/scsi/ufs/ufs-exynos.o: in function `exynos_ufs_probe':
> drivers/scsi/ufs/ufs-exynos.c:1231: undefined reference to `ufshcd_pltfrm_init'
> drivers/scsi/ufs/ufs-exynos.o: in function `exynos_ufs_pre_pwr_mode':
> drivers/scsi/ufs/ufs-exynos.c:635: undefined reference to `ufshcd_get_pwr_dev_param'
> drivers/scsi/ufs/ufs-exynos.o:undefined reference to `ufshcd_pltfrm_shutdown'
> drivers/scsi/ufs/ufs-exynos.o:undefined reference to `ufshcd_pltfrm_suspend'
> drivers/scsi/ufs/ufs-exynos.o:undefined reference to `ufshcd_pltfrm_resume'
> drivers/scsi/ufs/ufs-exynos.o:undefined reference to `ufshcd_pltfrm_runtime_suspend'
> drivers/scsi/ufs/ufs-exynos.o:undefined reference to `ufshcd_pltfrm_runtime_resume'
> drivers/scsi/ufs/ufs-exynos.o:undefined reference to `ufshcd_pltfrm_runtime_idle'

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: ufs: Allow exynos ufs driver to build as module
      https://git.kernel.org/mkp/scsi/c/d31503fe395d

-- 
Martin K. Petersen	Oracle Linux Engineering
