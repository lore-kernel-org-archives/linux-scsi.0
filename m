Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B35AC83F14
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345646AbjHaBtV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345639AbjHaBtK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:49:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFF7CD7
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:49:07 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0DwCP025907;
        Thu, 31 Aug 2023 01:49:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=u8rEVPmCWAbojjMJmAnlxhs576PCUa08U8dTBb4J2NY=;
 b=xtF8LYSrH97WLWbHITf+Zys/cH0knJZJA17p4oJXFNVbdhBfig2nnFnvMPKVz7/0kyf6
 zKdApeAqjSJeV2yws65dUQ04FkF9p3a85RHCfO7bdIFE05v8BPvO/bphgeYk3uIvRZ50
 Ku2ulR0gzQgP/BjqGPRbOl/u1Y3xjGyo0UG8CjLf2+Bg6WDjJN6bJ1M2xnx2IQu5l1X9
 Sf4hPWlekGYxe0EJzmjKV04G5pKOYXCAtbgFh9THcNADAYohhVj+rNKgpEJ0NGMpRdMe
 +IE59UVYTnIlyPXMsEp6jb4Nu8knExMG34x4b0K9NqaBvZQFhkLoRf/W3ql796TvbEUi 1A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9k68se3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:49:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0piGV032782;
        Thu, 31 Aug 2023 01:49:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6dqtxp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:49:03 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37V1mnL3000352;
        Thu, 31 Aug 2023 01:49:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3sr6dqtxfw-10;
        Thu, 31 Aug 2023 01:49:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, loberman@redhat.com
Subject: Re: [PATCH v2 0/2] qla2xxx: allow 32 bytes CDB
Date:   Wed, 30 Aug 2023 21:48:37 -0400
Message-Id: <169344360089.1293881.17749457045038669167.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817063132.21900-1-njavali@marvell.com>
References: <20230817063132.21900-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_01,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=567 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308310014
X-Proofpoint-GUID: huwGG7_kdtSsf5i3Ok0DPzXIFrkTI_2q
X-Proofpoint-ORIG-GUID: huwGG7_kdtSsf5i3Ok0DPzXIFrkTI_2q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 17 Aug 2023 12:01:30 +0530, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver bug fix, allowing 32 bytes
> CDB, to the scsi tree at your earliest convenience.
> 
> v2:
> - remove extra lines and fix comments format
> - Add Reviewed-by tag
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/2] qla2xxx: Move resource to allow code reuse
      https://git.kernel.org/mkp/scsi/c/efeda3bf912f
[2/2] qla2xxx: allow 32 bytes CDB
      https://git.kernel.org/mkp/scsi/c/ae25f65a351c

-- 
Martin K. Petersen	Oracle Linux Engineering
