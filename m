Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D082C001DE
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 02:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjGZCGE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 22:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGZCGC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 22:06:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775F22109;
        Tue, 25 Jul 2023 19:06:01 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJIxSH010918;
        Wed, 26 Jul 2023 02:05:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=JrohrvYFYBpyLFEvX7bSzr05sbQmVxirNILK7N6puiU=;
 b=nxse6/bLr/dKig4AUNGK/YMBSYfiDXMPZH9UaRNRTn0Dv8ytQfA3h5fA1jitIu5faTs0
 ONGSqIDxx/viooBqDwfjQjesQN0FsB54ty/POek+wNq1tG8HZVFyoB1OKBDqfllWFGYb
 44xLwIyHNnzQ6eJAgh3TbQAUeWBBSOugr/j+Hi9Mq3Vreop+UWUmBp1aWSFXHuP5ZwlV
 3D99bUdp9tlRtpey2TTsmftNs5rNktc8Ev7hGKJ1hTOrBAM9cxzQGj1FmvEXSgwbtIe+
 JJI0w1whjpA1mc7/4iy501x3vEKWGXA4EEYqBNH+71tLq3RIMjNdXpVg+1kfQJs5WRs1 HQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s07nupcga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PNhxij022977;
        Wed, 26 Jul 2023 02:05:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5jd5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:18 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36Q253Nj038905;
        Wed, 26 Jul 2023 02:05:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s05j5jcwf-10;
        Wed, 26 Jul 2023 02:05:17 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Rob Herring <robh@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Explicitly include correct DT includes
Date:   Tue, 25 Jul 2023 22:04:55 -0400
Message-Id: <169033702311.2256288.16269260976024277897.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230714175052.4066150-1-robh@kernel.org>
References: <20230714175052.4066150-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=688
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260016
X-Proofpoint-ORIG-GUID: atNirJIwQ5ZFNvcUEPATVJk0CYIXmNYh
X-Proofpoint-GUID: atNirJIwQ5ZFNvcUEPATVJk0CYIXmNYh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 14 Jul 2023 11:50:52 -0600, Rob Herring wrote:

> The DT of_device.h and of_platform.h date back to the separate
> of_platform_bus_type before it as merged into the regular platform bus.
> As part of that merge prepping Arm DT support 13 years ago, they
> "temporarily" include each other. They also include platform_device.h
> and of.h. As a result, there's a pretty much random mix of those include
> files used throughout the tree. In order to detangle these headers and
> replace the implicit includes with struct declarations, users need to
> explicitly include the correct includes.
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: Explicitly include correct DT includes
      https://git.kernel.org/mkp/scsi/c/109a2a48fc3d

-- 
Martin K. Petersen	Oracle Linux Engineering
