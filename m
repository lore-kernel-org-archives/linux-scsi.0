Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD1CC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 02:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjEQCMu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 May 2023 22:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjEQCMt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2023 22:12:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A5310CA
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 19:12:49 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GK02pp032006;
        Wed, 17 May 2023 02:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=AlpA60/jgJt1SA/YFZfAmkBW0HIh5/b/H6M9DDkkdqM=;
 b=RZYd6QRWXAV1hoC8TeYmajlqdAETX5YhV4ScemAMXIwuJ2OZIg8Z7NSrwcwxswPvs4j8
 hO5S/S/5KVvZFA6+EWcClehPvBUHRmqqvShVAKdq2WrEw4yRc9AiRc5R28jbTAVPGV9t
 LiPzYcaB3HtJeIZVg+Ape+/oqRcgPIKnxRJt++FD89ZdZCaIe1xQ7ZI5M/1YD3NNnCPW
 O0A7hEvY1sxFN/7PBZ0VRwY9rR6lxLddF5NOtD/G27zYOP4PiNnTUEdmfSu1KvlvVFuE
 KIpDXnUuddtGguhtkuMb++jin3C+lvXj/f0dYsGzEiYV3mdrFzxNuzIaEdunSun1o+pF vQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj2eb48hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 02:12:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34GN8PGN025063;
        Wed, 17 May 2023 02:12:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj104tw20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 02:12:46 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34H2CdOI016064;
        Wed, 17 May 2023 02:12:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qj104tw04-5;
        Wed, 17 May 2023 02:12:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        bhazarika@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com
Subject: Re: [PATCH v2 0/7] qla2xxx driver update
Date:   Tue, 16 May 2023 22:12:28 -0400
Message-Id: <168428950412.722180.4435038312856626946.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230428075339.32551-1-njavali@marvell.com>
References: <20230428075339.32551-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_14,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=750 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170016
X-Proofpoint-GUID: bxpqIr2pG3db7MN88n0Cb6kW0g9KKEoV
X-Proofpoint-ORIG-GUID: bxpqIr2pG3db7MN88n0Cb6kW0g9KKEoV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 Apr 2023 00:53:32 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver enhancement and bug fixes to
> the scsi tree at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/7] qla2xxx: Multi-que support for TMF
      https://git.kernel.org/mkp/scsi/c/d90171dd0da5
[2/7] qla2xxx: Fix task management cmd failure
      https://git.kernel.org/mkp/scsi/c/9803fb5d2759
[3/7] qla2xxx: Fix task management cmd fail due to unavailable resource
      https://git.kernel.org/mkp/scsi/c/6a87679626b5
[4/7] qla2xxx: Fix hang in task management
      https://git.kernel.org/mkp/scsi/c/9ae615c5bfd3
[5/7] qla2xxx: Fix mem access after free
      https://git.kernel.org/mkp/scsi/c/b843adde8d49
[6/7] qla2xxx: Wait for io return on terminate rport
      https://git.kernel.org/mkp/scsi/c/fc0cba0c7be8
[7/7] qla2xxx: Update version to 10.02.08.300-k
      https://git.kernel.org/mkp/scsi/c/eb91eb809c8d

-- 
Martin K. Petersen	Oracle Linux Engineering
