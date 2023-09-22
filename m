Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB37E7D0BA
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 01:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjIVBGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjIVBGW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 21:06:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C831A102
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 18:06:16 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIsM1D011449;
        Fri, 22 Sep 2023 01:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=s3KgDwHMli+dUflNPh7Rdv8VVA8qPCrqJhxTI0w7iUI=;
 b=bxTM9lNh92PCCtTjKCXEG04bC/u8Aiangol4Jvs7KpYt1I2RJRKzcEqARf1Z3jRxYm/O
 t91f+V685E89Gb5ENM/0PUd9C51J78lbwUg7/w1Wg3qiZiTbzu6344qtkiBwv/H9Kuxb
 e3khqvDqFWGx3QC7cP6eMOPC7y7+pEifa9tp2BV5i1WCzGgdqcZ0ag55rPJ1iDmXox5B
 8Tf4TKD4LKnAv8oMo/TLAXeclYl3IV6BShy+9za12t5IZadP4S8IiUZlt3c4xhbp45/m
 DdLBuRN6x+KrGQ1JgKN04LKUubf3Ln68DEa1MAcNyBeFAky8nbhE40k5KdVTrT/MpOyo fA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsvrkaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:06:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMdUv9040557;
        Fri, 22 Sep 2023 01:06:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t8u19bn3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:06:07 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38M164st032168;
        Fri, 22 Sep 2023 01:06:06 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t8u19bn0m-3;
        Fri, 22 Sep 2023 01:06:06 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/3] Minor cleanups
Date:   Thu, 21 Sep 2023 21:05:53 -0400
Message-Id: <169534443608.456601.1123273812993742673.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230912230551.454357-1-dlemoal@kernel.org>
References: <20230912230551.454357-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_01,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=524 phishscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309220008
X-Proofpoint-GUID: sQuqJFvmt9IpKp4lLjNcr3pNoH0l7fMr
X-Proofpoint-ORIG-GUID: sQuqJFvmt9IpKp4lLjNcr3pNoH0l7fMr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Sep 2023 08:05:48 +0900, Damien Le Moal wrote:

> 3 patches to cleanup libsas functions declarations. No functional
> changes.
> 
> Changes from v2:
>  * Added argument name to sas_discover_event() in patch 1
>  * Removed repeated word "used" from commit message of patch 3
>  * Added Johannes' review tag
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/3] scsi: libsas: Move local functions declarations to sas_internal.h
      https://git.kernel.org/mkp/scsi/c/d10b11dcb08f
[2/3] scsi: libsas: Declare sas_set_phy_speed() static
      https://git.kernel.org/mkp/scsi/c/9b52c1c6cafd
[3/3] scsi: libsas: Declare sas_discover_end_dev() static
      https://git.kernel.org/mkp/scsi/c/1345a7d909a3

-- 
Martin K. Petersen	Oracle Linux Engineering
