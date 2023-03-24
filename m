Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6B7C6FD1C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 21:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjCXVHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 17:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCXVHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 17:07:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37740166D6
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 14:07:11 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OKxxIY005351;
        Fri, 24 Mar 2023 21:07:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=MHndsvBkgllT4mowPFb1EyF2Zsr8d9B7wFsNQhiRdxk=;
 b=v0npZ4GM8TthCsKYRUYfh1sZfgkVqYjy6ROUUk6BFNoxpa04awNUeE317rlTBepOKDuQ
 4XND65EXisllGBzuNc5VYynfKz0zQfwM4KXmvtr6c2ZZQ25rUNOW3DvLF67WBscHJnCY
 PiH9t8txb/hi6uMdbqvMzZj3jpOK/aUDNnuhi06DeqdbrIOqtcqkJsQ9SkBOg85q9JVH
 COhUAdyIEuDgiem9XsE0rXqbZZcpUhg433Ik7mgpUz+6CuDzlRTMnwyC+qFeW9mf5f8T
 ehaSht5ePxsayruh9Vsjit05yYZhJVU8wqRsJo7wu9T/kSJ49DRjxoh2kwZxOBuCDncK gg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phkcn00mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 21:07:09 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OJFEjR027893;
        Fri, 24 Mar 2023 21:07:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4se4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 21:07:09 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OL76fC017159;
        Fri, 24 Mar 2023 21:07:08 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pgxk4se2p-6;
        Fri, 24 Mar 2023 21:07:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com
Subject: Re: [PATCH 0/8] mpi3mr: Few Enhancements and minor fixes
Date:   Fri, 24 Mar 2023 17:06:57 -0400
Message-Id: <167969123976.59527.1359892780884791876.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230316110209.60145-1-ranjan.kumar@broadcom.com>
References: <20230316110209.60145-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240160
X-Proofpoint-GUID: vxkcU1UhSdAm3zq-BJwrrcvPH2YS-sQF
X-Proofpoint-ORIG-GUID: vxkcU1UhSdAm3zq-BJwrrcvPH2YS-sQF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 16 Mar 2023 16:32:01 +0530, Ranjan Kumar wrote:

> V2:
> Few Enhancements and minor fixes of mpi3mr driver.
> 
> Ranjan Kumar (8):
>   mpi3mr: Successive VD delete and add causes FW Fault
>   mpi3mr: fix admin queues memory leak upon soft reset
>   mpi3mr: Modified MUR timeout value to 120 seconds
>   mpi3mr: Avoid escalating to higher level reset when target is removed
>   mpi3mr: Updated MPI Headers to revision 27
>   mpi3mr: Fixed the W=1 compilation warnings
>   mpi3mr: updated copyright year
>   mpi3mr: Update driver version to 8.4.1.0.0
> 
> [...]

Applied to 6.4/scsi-queue, thanks!

[1/8] mpi3mr: Successive VD delete and add causes FW Fault
      https://git.kernel.org/mkp/scsi/c/3f1254ed01d0
[2/8] mpi3mr: fix admin queues memory leak upon soft reset
      https://git.kernel.org/mkp/scsi/c/23b3d1cf1572
[3/8] mpi3mr: Modified MUR timeout value to 120 seconds
      https://git.kernel.org/mkp/scsi/c/22beef38e52c
[4/8] mpi3mr: Avoid escalating to higher level reset when target is removed
      https://git.kernel.org/mkp/scsi/c/f1dec6b1e25e
[5/8] mpi3mr: Updated MPI Headers to revision 27
      https://git.kernel.org/mkp/scsi/c/e5f596bc2592
[6/8] mpi3mr: Fixed the W=1 compilation warnings
      https://git.kernel.org/mkp/scsi/c/80b8fd0231d5
[7/8] mpi3mr: updated copyright year
      https://git.kernel.org/mkp/scsi/c/e74f2fbd8b06
[8/8] mpi3mr: Update driver version to 8.4.1.0.0
      https://git.kernel.org/mkp/scsi/c/1ea41edd88f2

-- 
Martin K. Petersen	Oracle Linux Engineering
