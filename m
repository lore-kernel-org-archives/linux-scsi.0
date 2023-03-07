Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C2DC6FD1B
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 02:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjCGC5u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 21:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjCGC5q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 21:57:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B99B72003
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 18:57:45 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326Nx15i006448;
        Tue, 7 Mar 2023 02:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=4TrE6g3OWhylCgbvGNmLAU0M9f68d7jJcHX5l6x+UeA=;
 b=kmMTmjnkvwnxQWzFUd4PZzPR8RrNVX8m1gmvqBimHuaM28+31D5n572Xmy9xGlUrl+FT
 GaIsAyoW7ksSngbJX5XOKwUBvQSg0XDz5pgOBYTS0Ixw486UR7A+oJEy0vDiNcTKgIEO
 dK3L9oBdkpeTpc8D3AR6cI9WaA33MzCl3V2npmP8ukmotwDROe3Ot6DoNmthDsLTUqrH
 hJNJPDkxQ3MtLQHmcxMiAN3Z4VsOsqq58WfxbtUZJvvrNbE+s/oX2WYHEPdSUC6GPrlH
 hndtSJkJxaxLePGCoiNUvcic1TlIU/0u/UXvlF/98nm8ju9+jqIZPE+ixKn2KSMx8jTx 5Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4161vfk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3272PvMf036999;
        Tue, 7 Mar 2023 02:57:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4txdvjm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:42 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3272vY2Q009567;
        Tue, 7 Mar 2023 02:57:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p4txdvjhj-9;
        Tue, 07 Mar 2023 02:57:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com
Subject: Re: [PATCH 0/6] This patchset contains critical Bug fixes
Date:   Mon,  6 Mar 2023 21:57:26 -0500
Message-Id: <167815780205.2075334.9513188954583912224.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230228140835.4075-1-ranjan.kumar@broadcom.com>
References: <20230228140835.4075-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070025
X-Proofpoint-GUID: QZl1CIrQ6U44aBlqS7Rpe2_GiSvAer9N
X-Proofpoint-ORIG-GUID: QZl1CIrQ6U44aBlqS7Rpe2_GiSvAer9N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Feb 2023 06:08:29 -0800, Ranjan Kumar wrote:

> This patchset contains critical Bug fixes
> 
> Ranjan Kumar (6):
>   mpi3mr: IOCTL timeout when disable/enable Interpt
>   mpi3mr: Driver unload crash host when enhanced logging is enabled
>   mpi3mr: Wait for diagnostic save during controller init
>   mpi3mr: appropriate return values for failures in firmware init path
>   mpi3mr: NVMe commands size greater than 8K fails
>   mpi3mr: Bad drive in topology results kernel crash
> 
> [...]

Applied to 6.3/scsi-fixes, thanks!

[1/6] mpi3mr: IOCTL timeout when disable/enable Interpt
      https://git.kernel.org/mkp/scsi/c/02ca7da2919a
[2/6] mpi3mr: Driver unload crash host when enhanced logging is enabled
      https://git.kernel.org/mkp/scsi/c/5b06a7169c59
[3/6] mpi3mr: Wait for diagnostic save during controller init
      https://git.kernel.org/mkp/scsi/c/0a319f162949
[4/6] mpi3mr: appropriate return values for failures in firmware init path
      https://git.kernel.org/mkp/scsi/c/ba8a9ba41fbd
[5/6] mpi3mr: NVMe commands size greater than 8K fails
      https://git.kernel.org/mkp/scsi/c/4f297e856a7b
[6/6] mpi3mr: Bad drive in topology results kernel crash
      https://git.kernel.org/mkp/scsi/c/8e45183978d6

-- 
Martin K. Petersen	Oracle Linux Engineering
