Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CFCC19F2C
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 03:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240297AbiG0DQd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 23:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240308AbiG0DQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 23:16:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2BC3DF12
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 20:16:07 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26R2wcQw009003;
        Wed, 27 Jul 2022 03:16:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=8UYu7Yjk5tnwQAQJ+fXJR9hbvuHhDQfaX6YHBMtjjko=;
 b=ep2HdTInNV5aoB+RiB/vIZnBTvEC2DkcYkVkc4+1zQvek++TgddhRb/sGOO8NazlgjTL
 lfajCSUjJYOCBS7o97GWCXoqW2Fd51Tgx8Vg8UTZuu12pk/zBF7J9jmlGEoyJoxRKUoz
 cbWO0X2yrUkgElfmGAOoyuQGThbZd0gZ0aUTK6zD8IjGyfKpg1XSv4DOvJPCUw7pDRb6
 3oQ0oi7bje9nRU1YfmlsWKk9HhzYXncD2b/K95w3LHaI19A1aGOzp6oBOsS+ds1Oa4f7
 YWdPFpeBAol0bbr0szbAA5IHs/aVcsJBUrKi1m4MyNFiAW1ZTs/J+Kbe0iQiFDKvXMJt ow== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg94gg3rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 03:16:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26R1S2t1034428;
        Wed, 27 Jul 2022 03:16:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh633p3x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 03:16:04 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26R3E0h4008228;
        Wed, 27 Jul 2022 03:16:04 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3hh633p3uc-6;
        Wed, 27 Jul 2022 03:16:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] mpi3mr: Add support for Resource Based Metering
Date:   Tue, 26 Jul 2022 23:15:59 -0400
Message-Id: <165889172880.804.8642287743124952617.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708195020.8323-1-sreekanth.reddy@broadcom.com>
References: <20220708195020.8323-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=862 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207270009
X-Proofpoint-GUID: fh06_UxsfTVYr8q6zGVEeuuTTnULRW9V
X-Proofpoint-ORIG-GUID: fh06_UxsfTVYr8q6zGVEeuuTTnULRW9V
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 9 Jul 2022 01:20:18 +0530, Sreekanth Reddy wrote:

> Enhanced driver to track cumulative pending large data size
> at the controller level and at a throttle group level.
> when one of the value exceeds a firmware determined value
> then divert the future selective I/O to the firmware.
> 
> Sreekanth Reddy (2):
>   mpi3mr: Resource Based Metering
>   mpi3mr: Reduce VD queue depth on detecting the throttling
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/2] mpi3mr: Resource Based Metering
      https://git.kernel.org/mkp/scsi/c/f10af057325c
[2/2] mpi3mr: Reduce VD queue depth on detecting the throttling
      https://git.kernel.org/mkp/scsi/c/cf1ce8b71524

-- 
Martin K. Petersen	Oracle Linux Engineering
