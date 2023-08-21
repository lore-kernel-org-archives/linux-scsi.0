Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84905EE49A8
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 22:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbjHUW1v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 18:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjHUW1u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 18:27:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED580DB
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 15:27:48 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxJ0d031476;
        Mon, 21 Aug 2023 22:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=cfeHstRRlScLQHQfokaNC9d65WU823QKOm6GypERw0g=;
 b=n+sKTwOeQZwEb70jxq9P2SVMaTWrbqrQSDNqSTUwc+Kk5AAUm7aMtT+NbheuQaY1Er3F
 LJgajmZCNXwM+UJ95tg5Zl1uKPmVIJzjhRImhaqDyIdFj7Xx+J4llHAIzq031EdtjTcZ
 oorozBR8mUxcy569hhsHAD0go5XELcqFD0RGIHSLHNjsV9gyvLK7NQACuJLZ9+74bnTZ
 rD3yDYAGoG2l5COIa28YexMyeIcbY+mNfpjN97frz6oqyLcqHiizVLOG9mIqGqnVChzD
 MV3bcaZZ3wFKVPGOxjIUFoFgfppd63Thy/vADekIOmeHbdyqkC670577UKLDPCrMkrKg oA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjnscc1w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 22:27:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LMCG3w029823;
        Mon, 21 Aug 2023 22:27:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm6ajb6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 22:27:46 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37LMRiS5021660;
        Mon, 21 Aug 2023 22:27:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3sjm6ajb5m-4;
        Mon, 21 Aug 2023 22:27:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com
Subject: Re: [PATCH v3 0/6] mpi3mr: Few Enhancements and minor fixes
Date:   Mon, 21 Aug 2023 18:27:39 -0400
Message-Id: <169265683484.715970.13779089999835664802.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230804104248.118924-1-ranjan.kumar@broadcom.com>
References: <20230804104248.118924-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=909
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308210206
X-Proofpoint-GUID: 2xNGovzCVfDsUw2oyVYoA8BvOAofgECK
X-Proofpoint-ORIG-GUID: 2xNGovzCVfDsUw2oyVYoA8BvOAofgECK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 04 Aug 2023 16:12:42 +0530, Ranjan Kumar wrote:

> Few Enhancements and minor fixes of mpi3mr driver.
> 
> v1->v2: Fix space indentation in mpi3mr_target_alloc
> 
> v2->v3: Fix indentation for warning reported by smatch
> 
> Ranjan Kumar (6):
>   mpi3mr: Invokes soft reset upon TSU or event ack time out
>   mpi3mr: Update MPI Headers to version 3.00.28
>   mpi3mr: Add support for more than 1MB I/O
>   mpi3mr: WriteSame implementation
>   mpi3mr: Enhance handling of devices removed after controller reset
>   mpi3mr: Update driver version to 8.5.0.0.0
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/6] mpi3mr: Invokes soft reset upon TSU or event ack time out
      https://git.kernel.org/mkp/scsi/c/9134211f7bed
[2/6] mpi3mr: Update MPI Headers to version 3.00.28
      https://git.kernel.org/mkp/scsi/c/6f81b1cfdf33
[3/6] mpi3mr: Add support for more than 1MB I/O
      https://git.kernel.org/mkp/scsi/c/d9adb81e67e9
[4/6] mpi3mr: WriteSame implementation
      https://git.kernel.org/mkp/scsi/c/e7a8648e1ce2
[5/6] mpi3mr: Enhance handling of devices removed after controller reset
      https://git.kernel.org/mkp/scsi/c/d9a5ab0ea98f
[6/6] mpi3mr: Update driver version to 8.5.0.0.0
      https://git.kernel.org/mkp/scsi/c/9a9068b2afa0

-- 
Martin K. Petersen	Oracle Linux Engineering
