Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B7BC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90E7C2311B
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:26:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fuF14IE7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732628AbgFTD0w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 23:26:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58646 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732271AbgFTD0v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 23:26:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3IkYC195227;
        Sat, 20 Jun 2020 03:26:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=YozYC7BX+b5ExGj9hLTTKU0a2NKjB7YUbKixGCpRWsg=;
 b=fuF14IE7rNtDhQNd0Xj+Qxv5QuA7jX1zWzSJYvJWo+1Vep5pnTRi9URjMSSctizqjNSC
 GtJZJoWqjhvoCLBmGrZjnCm3eDEinH+dwqy765fXqDIDCdbumZpmQTd8MfmhEQbuWrNe
 nQqfRhT9IMDjBVCaDHzynL3ZYpxkuaX/u/Afpi7S1QcWNhqPAeqNdPbYrPAydDyClblV
 JNXRSk9LtcXamVjp1TTBGtUktE66SXQ11C0kzwjMoErmteTyvL2Ihv+DOdb2Pwo4mulo
 b6N4GpUxO7kk2b7r+z9aol7yEWmv4Mxf3YLBN83df62sRozVtS9LBdQPKYTL0b5p0i+5 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31s9vqr1vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 20 Jun 2020 03:26:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3HtB0104127;
        Sat, 20 Jun 2020 03:26:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31s9sg9qtb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Jun 2020 03:26:42 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05K3Qf6G011087;
        Sat, 20 Jun 2020 03:26:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 20:26:41 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>
Subject: Re: [PATCH v2 0/2] scsi: target: tcmu: fix crashes on ARM
Date:   Fri, 19 Jun 2020 23:26:35 -0400
Message-Id: <159262354735.7800.15424809109743064228.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
References: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006200022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 malwarescore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 phishscore=0 cotscore=-2147483648 spamscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006200022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Jun 2020 15:16:30 +0200, Bodo Stroesser wrote:

> This small series of patches consists of:
>    [PATCH 1/2 v2] scsi: target: tcmu: Optimize use of flush_dcache_page
>    [PATCH 2/2 v2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range
> 
> Together with commit
>    8c4e0f212398 scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
> these patches fix crashes in tcmu on ARM.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: target: tcmu: Optimize use of flush_dcache_page
      https://git.kernel.org/mkp/scsi/c/3c58f737231e
[2/2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM
      https://git.kernel.org/mkp/scsi/c/3145550a7f8b

-- 
Martin K. Petersen	Oracle Linux Engineering
