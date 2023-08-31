Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B6CC83F15
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345633AbjHaBtT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345640AbjHaBtK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:49:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AB7CD6
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:49:06 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0EFBl004218;
        Thu, 31 Aug 2023 01:49:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=a6KJ0iObrohgZq7z6ERaoYNjmy1shJV875REbNiOK3E=;
 b=iW7YwA1AziJ44WNpRDlC8QMWKVBGFpVWBxpKOwSCqMS6i7CtXfenj+7rjbWzDCVGrssE
 hHcq65NDPWiKIW+Q5PbTnrO60nQWGhdtHxgWYMBu1BQ8cokDSp5QVHLdjqJKjSiUSds2
 epSGVAbX/LMOVUO2BJbM3QyH/Y5yQ62opJ9f8H1Kq2B2OfIiWVbcpXOASl96ZsP7anQO
 HKDo9qlhx4LVMh2RjIjYxKa9DKi8F3hxFdm2qSPgVHU4y4oFOqaGU2AGIqMvQ8QpiORc
 KqtKna2TTEXudhAGz+ERe0NPO0sbUyaVL64/LSRTLHovG56MyB+F/BYg1a8vZIuiod1y kw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9mcrr8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:49:05 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0oxJe032763;
        Thu, 31 Aug 2023 01:49:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6dqtxph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:49:04 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37V1mnL5000352;
        Thu, 31 Aug 2023 01:49:04 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3sr6dqtxfw-11;
        Thu, 31 Aug 2023 01:49:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH v3 0/9] qla2xxx driver misc features
Date:   Wed, 30 Aug 2023 21:48:38 -0400
Message-Id: <169344360089.1293881.2495965876365066945.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230821130045.34850-1-njavali@marvell.com>
References: <20230821130045.34850-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_01,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=995 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308310014
X-Proofpoint-ORIG-GUID: OCGjreEsjUru3uNce4Z_43zdubqTIVLf
X-Proofpoint-GUID: OCGjreEsjUru3uNce4Z_43zdubqTIVLf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Aug 2023 18:30:36 +0530, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver miscellaneous features and
> bug fixes to the scsi tree at your earliest convenience.
> 
> v3:
> - Skip patch "qla2xxx: Observed call trace in smp_processor_id()"
> - Change description of patch 1/9
> v2:
> - Remove extra line from qla_iocb.c
> - Fix comment style for qla2xxx_process_purls_pkt()
> - Add Reviewed-by tag
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/9] qla2xxx: Add Unsolicited LS Request and Response Support for NVMe
      https://git.kernel.org/mkp/scsi/c/875386b98857
[2/9] qla2xxx: Flush mailbox commands on chip reset
      https://git.kernel.org/mkp/scsi/c/6d0b65569c0a
[3/9] qla2xxx: Fix fw resource tracking
      https://git.kernel.org/mkp/scsi/c/e370b64c7db9
[4/9] qla2xxx: Add logs for SFP temperature monitoring
      https://git.kernel.org/mkp/scsi/c/cd248a95f86d
[5/9] qla2xxx: Error code did not return to upper layer
      https://git.kernel.org/mkp/scsi/c/0ba0b018f945
[6/9] qla2xxx: Remove unsupported ql2xenabledif option.
      https://git.kernel.org/mkp/scsi/c/e9105c4b7a92
[7/9] qla2xxx: fix smatch warn for qla_init_iocb_limit
      https://git.kernel.org/mkp/scsi/c/b496953dd044
[8/9] Revert "scsi: qla2xxx: Fix buffer overrun"
      https://git.kernel.org/mkp/scsi/c/641671d97b91
[9/9] qla2xxx: Update version to 10.02.09.100-k
      https://git.kernel.org/mkp/scsi/c/cc6e67e60fe7

-- 
Martin K. Petersen	Oracle Linux Engineering
