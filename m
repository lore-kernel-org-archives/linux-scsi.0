Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743B6C3DA78
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Jan 2023 03:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjANDTh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjANDTf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 22:19:35 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124C488DEA
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 19:19:35 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30E1vdZm023241;
        Sat, 14 Jan 2023 03:19:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=hv3FSE9JZD44qVZScbhICXzAShqUY9qs5x8MSCcKjDw=;
 b=zTKH0SoVG8mJk2dp7quLtZY1s8ae+HRcV5Yl8njTCjhGbkTzgRkSSRGvO5iQ9SoIuaG9
 bf1tSZpECY0S3ZeEPHbATi2Ns8yjv7CQT41qkq0KSrkbHdy4+V/j7MT2BB/U2XJTy8as
 ymdFeLEsT/dXSFqT0sCsH3JfVPmiMZ6l9iZumATqg7uD//d1sH0JcJyMSKs3krrbqv+L
 XpR+aJyTQs8vBjuJoCif35aCLoHjgm2AzB9msuStjFpaRGFIWZ5FZMsbuVuKZZxmu7wh
 +wPVs9pJbglsOhU2RdRf+3+FdspEPRANZAWP5It3pVXrqAM3RlDgrWk4BWH5zG3hX19P Ww== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3k6c01bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 03:19:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30E2mekF005656;
        Sat, 14 Jan 2023 03:19:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n3kxgrjv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 03:19:33 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30E3JVot032298;
        Sat, 14 Jan 2023 03:19:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3n3kxgrjun-3;
        Sat, 14 Jan 2023 03:19:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        bhazarika@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com
Subject: Re: [PATCH v2 00/11] Misc. qla2xxx driver bug fixes
Date:   Fri, 13 Jan 2023 22:19:27 -0500
Message-Id: <167366567314.3069740.9144617147876623251.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221219110748.7039-1-njavali@marvell.com>
References: <20221219110748.7039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_12,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=837 phishscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301140021
X-Proofpoint-GUID: _DK2mi-8c83YJPIFulsT8E_0PfSFwm-F
X-Proofpoint-ORIG-GUID: _DK2mi-8c83YJPIFulsT8E_0PfSFwm-F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 19 Dec 2022 03:07:37 -0800, Nilesh Javali wrote:

> Martin,
> 
> Please apply the miscellaneous qla2xxx driver bug fixes to the scsi tree
> at your earliest convenience.
> 
> v2:
> - Fix prototype warning reported by kernel test robot
> - Add Reviewed-by tag
> 
> [...]

Applied to 6.3/scsi-queue, thanks!

[01/11] qla2xxx: Check if port is online before sending ELS
	https://git.kernel.org/mkp/scsi/c/0c227dc22ca1
[02/11] qla2xxx: Fix link failure in NPIV environment
	https://git.kernel.org/mkp/scsi/c/b1ae65c082f7
[03/11] qla2xxx: Fix DMA-API call trace on NVME LS requests
	https://git.kernel.org/mkp/scsi/c/c75e6aef5039
[04/11] qla2xxx: Fix exchange over subscription
	https://git.kernel.org/mkp/scsi/c/41e5afe51f75
[05/11] qla2xxx: Fix exchange over subscription for mgt cmd
	https://git.kernel.org/mkp/scsi/c/5f63a163ed2f
[06/11] qla2xxx: Fix stalled login
	https://git.kernel.org/mkp/scsi/c/40f5b1b9a4af
[07/11] qla2xxx: Remove unintended flag clearing
	https://git.kernel.org/mkp/scsi/c/7e8a936a2d0f
[08/11] qla2xxx: Fix erroneous link down
	https://git.kernel.org/mkp/scsi/c/3fbc74feb642
[09/11] qla2xxx: Remove increment of interface err cnt
	https://git.kernel.org/mkp/scsi/c/d676a9e3d9ef
[10/11] qla2xxx: fix iocb resource check warning
	https://git.kernel.org/mkp/scsi/c/1e27648c8482
[11/11] qla2xxx: Update version to 10.02.08.100-k
	https://git.kernel.org/mkp/scsi/c/f590c2554c77

-- 
Martin K. Petersen	Oracle Linux Engineering
