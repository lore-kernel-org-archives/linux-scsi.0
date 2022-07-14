Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D520ACCA487
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 04:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbiGNEXK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 00:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbiGNEWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 00:22:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E6127CC3;
        Wed, 13 Jul 2022 21:22:40 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3nF2v009267;
        Thu, 14 Jul 2022 04:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=6c0WORp1kWFJyOdGYgbP5guV+K75uCzztk+wVlDmxL4=;
 b=BUd6N4FvpmIDkk6TBlv5wlUA99T5xGRB0xVuiYP+JTwL7bh2QqPEWdVxuqYd107J3nXA
 xFoX4WipEqUUQv1iQH2TFoMxEcQjIQKw5jnJYqu5vlUYYx5mRqCC6IfxUKdPKClOmIXk
 bQulIlgHjwKsCi7Iu5JQy9cKRxzijUI0MwFTtRH7erEc/P4ZzEOcw3dyEKdZWemOWTrO
 kQllXm4czch3Mes2WwsdKIyZYVmmYS14QvM7jMeBtm2/DZcwZUgHPRSBwvbwoFjoyuK3
 PDnraZVDDrfCCLHroNti5BkB8E0NnVS2w9942siXoQ8MKB3fANGTzGlerfnCX+2T8ukr tQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71rg3tpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E4ApYl040463;
        Thu, 14 Jul 2022 04:22:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 26E4MWBf023864;
        Thu, 14 Jul 2022 04:22:32 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jnc-1;
        Thu, 14 Jul 2022 04:22:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jiang Jian <jiangjian@cdjrlc.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/2] zfcp changes for v5.20
Date:   Thu, 14 Jul 2022 00:22:21 -0400
Message-Id: <165777182484.7272.9988840297540552966.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657122360.git.bblock@linux.ibm.com>
References: <cover.1657122360.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: PtPfu1ESeFSaHN59s2i81q0AlgzZ_Bf7
X-Proofpoint-ORIG-GUID: PtPfu1ESeFSaHN59s2i81q0AlgzZ_Bf7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 6 Jul 2022 17:59:38 +0200, Benjamin Block wrote:

> here is a (very) small set of changes for the zFCP device driver. The
> change from Jiang Jian came in recently, and Julian's patch has been
> laying around for quite a while now, so I didn't want to let them linger
> any longer in anticipation of any bigger change that might come.
> 
> It would be nice, if you could include them for v5.20.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/2] scsi: zfcp: declare zfcp_sdev_attrs as static
      https://git.kernel.org/mkp/scsi/c/b9787bdfdba5
[2/2] scsi: zfcp: drop unexpected word "the" in the comments
      https://git.kernel.org/mkp/scsi/c/9821106213c8

-- 
Martin K. Petersen	Oracle Linux Engineering
