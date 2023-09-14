Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD4DEE0216
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 01:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbjINBk6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 21:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbjINBk4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 21:40:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7041BD2
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 18:40:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DJG01l015364;
        Thu, 14 Sep 2023 01:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=x1hAZS/7FRM9/5q4DWtXmON1ahgTg+Uu1JCeXcGz5Rw=;
 b=Mjc/WDOyTANFceoP8DHj7J7LzALjkXDpxBPzoBLvD8M3pBUqodMiHI9gTvijs9+K78pL
 zAUjWb8MOwvsQX0hHPjaISNbKgz62lit7z2ltzZS+xim3gPezFQ6Voww4eQtR6qDuTzM
 kz4qXw7bKTug1mIqu7rOoyZ0PdSgTUc1VTLaRCfpU2dRDs8itC+yjPWbaEtuHYqHQ4D6
 99U42M1ETZzpKWXmzqq9nq63HY1f7bFfwvhUIJOsVZBunGIFPubxiXgkVeTt6nl/1qPb
 pKYPuMqvfviNADVOToNsH80lxRGOioNW+gu4hyVeI3NNtjGtrEVEI2s84Y807hEdphc8 yw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t37jr30at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38E0H26H007580;
        Thu, 14 Sep 2023 01:40:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f581r1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:45 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38E1efpT038417;
        Thu, 14 Sep 2023 01:40:44 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t0f581qyy-4;
        Thu, 14 Sep 2023 01:40:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>
Subject: Re: [PATCH v2 00/10] scsi: pm8001: Bug fix and cleanup
Date:   Wed, 13 Sep 2023 21:40:27 -0400
Message-Id: <169465549440.730690.17779482069613065814.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911232745.325149-1-dlemoal@kernel.org>
References: <20230911232745.325149-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=299 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140013
X-Proofpoint-ORIG-GUID: 1xEI8Q7nB6o7OO6jyzwflQFrxvc_wFRY
X-Proofpoint-GUID: 1xEI8Q7nB6o7OO6jyzwflQFrxvc_wFRY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Sep 2023 08:27:35 +0900, Damien Le Moal wrote:

> The first patch of this series fixes an issue with IRQ setup which
> prevents the controller from resuming after a system suspend.
> The following patches are code cleanup without any functional changes.
> 
> Changes from v1:
>  * Added Acked-by tag from Jack
>  * Fixed patch 10 to avoid a sparse warning
> 
> [...]

Applied to 6.6/scsi-fixes, thanks!

[01/10] scsi: pm8001: Setup IRQs on resume
        https://git.kernel.org/mkp/scsi/c/c91774818b04

-- 
Martin K. Petersen	Oracle Linux Engineering
