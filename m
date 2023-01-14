Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B960BC46467
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Jan 2023 03:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjANDTj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjANDTg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 22:19:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5189E88DEA
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 19:19:36 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30E3Bfk8008561;
        Sat, 14 Jan 2023 03:19:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=ljW/eRIXR9s6eaujZFS+EGnD+JtZRNkM3JsRsg17xkc=;
 b=d+cq+8o92WYfTSXcwQbugH2UHPmyR8O7xn0Cfjbtd/t50JHK/RPL/Usmtnk69mklcHLg
 tuCAzT058VDNwOSprFYgCQJpX18lYrkEMbvFCrCmqHowwJy3qKt9MteAWh5ZygpVoylA
 rV76H2c7t/IV6ZWgRgc95bU+1fV52QfEunBiawZRbZWtGMsgYoLzfotTZ6CrzsZxrRsB
 p0rFdG0El+08/RY3CXZRsReCpoZe241+yZJyBVPMuNNFLp6po4Bhk1gxF2Pc0iuAPX6u
 hQ0DaF113dO7qXxvsYxpi++1m9HDYbhv1hlnJS2svNy4u8DP7+GisitcpweAzcjXSxWC Dg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3m998046-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 03:19:34 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30E2mkmh005925;
        Sat, 14 Jan 2023 03:19:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n3kxgrjv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 03:19:32 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30E3JVor032298;
        Sat, 14 Jan 2023 03:19:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3n3kxgrjun-2;
        Sat, 14 Jan 2023 03:19:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        bhazarika@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com
Subject: Re: [PATCH 00/10] qla2xxx driver enhancements
Date:   Fri, 13 Jan 2023 22:19:26 -0500
Message-Id: <167366567314.3069740.6813421771139280513.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221222043933.2825-1-njavali@marvell.com>
References: <20221222043933.2825-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_12,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=774 phishscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301140021
X-Proofpoint-GUID: u5gTeWKUDu25_s44HhP-MfAM8Ezj6Ks6
X-Proofpoint-ORIG-GUID: u5gTeWKUDu25_s44HhP-MfAM8Ezj6Ks6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Dec 2022 20:39:23 -0800, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver enhancements to the scsi tree
> at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> [...]

Applied to 6.3/scsi-queue, thanks!

[01/10] qla2xxx: Remove dead code
	https://git.kernel.org/mkp/scsi/c/efd1bd12a04d
[02/10] qla2xxx: Remove dead code (GPNID)
	https://git.kernel.org/mkp/scsi/c/b9d87b60aaeb
[03/10] qla2xxx: Remove dead code (GNN ID)
	https://git.kernel.org/mkp/scsi/c/87f6dafd50fb
[04/10] qla2xxx: relocate/rename vp map
	https://git.kernel.org/mkp/scsi/c/430eef03a763
[05/10] qla2xxx: edif - Fix performance dip due to lock contention
	https://git.kernel.org/mkp/scsi/c/82d8dfd2a238
[06/10] qla2xxx: edif - Fix stall session after app start
	https://git.kernel.org/mkp/scsi/c/129a7c40294f
[07/10] qla2xxx: edif - Reduce memory usage during low IO
	https://git.kernel.org/mkp/scsi/c/1f8f9c34127e
[08/10] qla2xxx: edif - fix clang warning
	https://git.kernel.org/mkp/scsi/c/2f5fab1b6c3a
[09/10] qla2xxx: Select qpair depending on which CPU post_cmd() gets called
	https://git.kernel.org/mkp/scsi/c/1d201c81d4cc
[10/10] qla2xxx: Update version to 10.02.08.200-k
	https://git.kernel.org/mkp/scsi/c/f7d1ba350fb3

-- 
Martin K. Petersen	Oracle Linux Engineering
