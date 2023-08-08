Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4510AC001DB
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 02:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjHHCun (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 22:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjHHCul (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 22:50:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF08119F
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 19:50:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3781jD6H011184;
        Tue, 8 Aug 2023 02:50:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=oJw77j/flRVAReyEUT7yQXoaLaQyqE/hvULa4VTV2dM=;
 b=BPjvl6O0UVnjRdLbAT7lzZ4ecWvFHOgTkIQPH2DAaG8ef9kYsTItoWlLWbsCdkVHVKBN
 FwceDYyiG/5zdWo9/8w89vQVx3x3i5pSdz20RqeOz1EnldtvXglezh2uvj3xN0mDPhQA
 Iia0jrt5+UYGRcYHxu1p+9cZavNSYzwTf/fH+t690OemKnBNsXzvQllyUwMg8Q+MtROn
 WKGDmdv+FZJ43CCvIR/+1o0BsNUtaHlCRp7mSLLoL5TFP8mQoMqTFPfTjXcAC+wmqoeS
 yjjX68R3J8TeXr5xmpNRr1mN1eZU8FF00Ht/5Z1bf0XCExOmmLUrcfpKOQ9j6U9+PC5a CA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9eyuc490-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:50:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3782hWWT027803;
        Tue, 8 Aug 2023 02:50:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cv561n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:50:36 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3782oada010815;
        Tue, 8 Aug 2023 02:50:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3s9cv561mp-1;
        Tue, 08 Aug 2023 02:50:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v2 00/12] Multiple cleanup patches for the UFS driver
Date:   Mon,  7 Aug 2023 22:50:26 -0400
Message-Id: <169146270860.4040832.11156188064366347681.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230727194457.3152309-1-bvanassche@acm.org>
References: <20230727194457.3152309-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_28,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=650 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308080023
X-Proofpoint-GUID: 31vzhjuKMNIIGX-65heB1Q__yNjUfWLY
X-Proofpoint-ORIG-GUID: 31vzhjuKMNIIGX-65heB1Q__yNjUfWLY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 27 Jul 2023 12:41:12 -0700, Bart Van Assche wrote:

> This patch includes the following changes, none of which should change the
> functionality of the UFS host controller driver:
> - Improve the kernel-doc headers further.
> - Fix multiple W=2 compiler warnings.
> - Simplify ufshcd_abort_all().
> - Simplify the code for creating and parsing UFS Transport Protocol (UTP)
>   headers.
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[01/12] scsi: ufs: Follow the kernel-doc syntax for documenting return values
	https://git.kernel.org/mkp/scsi/c/3a17fefe0f19
[02/12] scsi: ufs: Document all return values
        https://git.kernel.org/mkp/scsi/c/fd4bffb54dc0
[03/12] scsi: ufs: Fix kernel-doc headers
        https://git.kernel.org/mkp/scsi/c/8d8af294ce03
[04/12] scsi: ufs: Rename a function argument
        https://git.kernel.org/mkp/scsi/c/f08191520614
[05/12] scsi: ufs: Minimize #include directives
        https://git.kernel.org/mkp/scsi/c/cce9fd602ca0
[06/12] scsi: ufs: Simplify zero-initialization
        https://git.kernel.org/mkp/scsi/c/f99533bd7e3d
[07/12] scsi: ufs: Improve type safety
        https://git.kernel.org/mkp/scsi/c/08108d31129a
[08/12] scsi: ufs: Remove a local variable from ufshcd_abort_all()
        https://git.kernel.org/mkp/scsi/c/e8b0234f8458
[09/12] scsi: ufs: Simplify ufshcd_abort_all()
        https://git.kernel.org/mkp/scsi/c/f9c028e7415a
[10/12] scsi: ufs: Remove a member variable
        https://git.kernel.org/mkp/scsi/c/e2566e0b7937
[11/12] scsi: ufs: Simplify transfer request header initialization
        https://git.kernel.org/mkp/scsi/c/67a2a8973832
[12/12] scsi: ufs: Simplify response header parsing
        https://git.kernel.org/mkp/scsi/c/617bfaa8dd50

-- 
Martin K. Petersen	Oracle Linux Engineering
