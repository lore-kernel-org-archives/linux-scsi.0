Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B24C2BB3F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 15:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344424AbjKOPNW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 10:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344416AbjKOPNS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 10:13:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D481C7
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 07:13:15 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AFE3vVF013269;
        Wed, 15 Nov 2023 15:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=cyuJGRFDYjzD+ZrN2+liPjbmoF1YQhE+RHtZnDjbggQ=;
 b=FVyk6lUs90sBIC7rXzifmsTD/myfCaU2rPY1l+5ZgqNRaFrmYdEpNIZCP/zqlxdQR/d4
 gL5VLSE04/eafTYdnXrWTVHx+Le3WNnj6u3sX1OW3Ml3Y8gNfm9e6KiYndv6lFO1dUsM
 T8HDYsHUSWdlruVFt1CXcz50kHAH2NGvIo3DaJbZqrNE+HYHiAkz/EsAy4Grx2/pODNG
 2f9SaKLEVPLdudk1my+tMlbcKNQJ/n73zoVnqqpbunRQSsATD4Zt0D9Poq7ZJN5EeVh+
 Wf42S29/fTC2gQYoIPYBAWefD0Sh6IPEECPaUgQ7zEkjMH36srPZMPM0igL36WF9JCO+ Sw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2qd8qbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Nov 2023 15:13:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AFF5xIt004069;
        Wed, 15 Nov 2023 15:13:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxj4088g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Nov 2023 15:13:10 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AFFD8ST011253;
        Wed, 15 Nov 2023 15:13:10 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uaxj4085x-4;
        Wed, 15 Nov 2023 15:13:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH] qla2xxx: fix system crash due to bad pointer access
Date:   Wed, 15 Nov 2023 10:13:02 -0500
Message-Id: <170006111380.506874.8613208071926506006.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231030064912.37912-1-njavali@marvell.com>
References: <20231030064912.37912-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-15_13,2023-11-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=683 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311150115
X-Proofpoint-ORIG-GUID: TOgxnO5-ISTmF3vd0ZVgYbJX7Rx1wNz8
X-Proofpoint-GUID: TOgxnO5-ISTmF3vd0ZVgYbJX7Rx1wNz8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 30 Oct 2023 12:19:12 +0530, Nilesh Javali wrote:

> User experience system crash when running AER error injection.
> The perturbation cause the abort all IO path to trigger. The driver
> assume all IO in this path are FCP only. Instead, there
> are both NVME & FCP IO's. Due to the false assumption, system
> crash is the result. Add additional check to see if IO is
> FCP or not before access.
> 
> [...]

Applied to 6.7/scsi-fixes, thanks!

[1/1] qla2xxx: fix system crash due to bad pointer access
      https://git.kernel.org/mkp/scsi/c/19597cad64d6

-- 
Martin K. Petersen	Oracle Linux Engineering
