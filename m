Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5804C83F15
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345650AbjHaBtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345634AbjHaBtH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:49:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB986CC5
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:49:04 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0E6u5009601;
        Thu, 31 Aug 2023 01:49:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=KV1hp1Btap39Jr1KpNXNAnCzSxcyhvvUewHb7T1cGzo=;
 b=l6IelrjlSkv1S93MBDNwTpWMSujuG3eX3/J1opicZPgyZYHD1992mpyue0HVMvHW9x8H
 /Cl/wz5QDc55bTaa0FzHj4kRojlIdJ77yWP1k/viHQT3ojBCU1703dGZk1oFCw6v6hJ0
 Y8jGx18VmtznWlC5yasMTT48b7kpln9zGirmDMx1PLLmw334uhUSFHmC1SEFoxXMTxgY
 yUB/VUywcTVUCVl9rjEFdEJKFnKqnNyAgQLEI0YTm3JvJrAtikKPh/W6dNe0ORcAT7I9
 RIB/97C7NuGCxT0Jx2k7Qg8guaeLrnhrULEJ8wHjudVHzOxzY35I1hdwJDOkn0aKW7Qi Fw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9j4gtbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:49:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37V1A1Mm032832;
        Thu, 31 Aug 2023 01:49:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6dqtxnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:49:02 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37V1mnL1000352;
        Thu, 31 Aug 2023 01:49:02 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3sr6dqtxfw-9;
        Thu, 31 Aug 2023 01:49:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH] qla2xxx: fix sparse warning in func qla24xx_build_scsi_type_6_iocbs
Date:   Wed, 30 Aug 2023 21:48:36 -0400
Message-Id: <169344363908.1300208.15581283206250400392.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230824151626.35334-1-njavali@marvell.com>
References: <20230824151626.35334-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_01,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=776 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308310014
X-Proofpoint-GUID: QNfx3h67haPJSadNl0FKFId-rcT2nWs9
X-Proofpoint-ORIG-GUID: QNfx3h67haPJSadNl0FKFId-rcT2nWs9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 24 Aug 2023 20:46:26 +0530, Nilesh Javali wrote:

> Sparse warning reported,
> 
> drivers/scsi/qla2xxx/qla_iocb.c: In function 'qla24xx_build_scsi_type_6_iocbs':
> >> drivers/scsi/qla2xxx/qla_iocb.c:594:29: warning: variable 'ha' set but not used [-Wunused-but-set-variable]
>      594 |         struct qla_hw_data *ha;
>          |                             ^~
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Remove unused variables in qla24xx_build_scsi_type_6_iocbs()
      https://git.kernel.org/mkp/scsi/c/659d36cc732a

-- 
Martin K. Petersen	Oracle Linux Engineering
