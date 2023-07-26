Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34CFC001DE
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 02:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjGZCFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 22:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGZCFW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 22:05:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1AA121
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 19:05:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJIsmG014615;
        Wed, 26 Jul 2023 02:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=uCaLaLHMoFaeJBrZqkIDQONj+SJEIaE99dTypOAALa8=;
 b=A7AVZs+0cwEnhKCK6EonTdpn4H99oEmfmyX94waTvRODqPxkFNHb5IzrYbvzvPIDtLtL
 9Z6ukzygTYPgwz/srVmhM9iCE1eZUA2DbDWg1sCutQD2SK8MYjcDwJ4lGsN+zNk89UaQ
 pcvGKt/IpJk8q4HCGbZBYo2pnfkwvZrwVt0fPYS/cdK2B2WXvvnZTuB6+fEqNo554Zls
 afDi5Ttaf/ii/bmw4c7tjOlRUcCj2HIctnp/05zXxbU61RxJ9/jZnrpFy4UDoxgcnBla
 uq5wH8l8Q6dfPIKnDclMnHTz2tYLewu+Dl+On+9DwZx7ctHPOtYh/bGLNWudpiEpXr4w CQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05w3peb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q0MMnG023407;
        Wed, 26 Jul 2023 02:05:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5jd2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:12 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36Q253Nd038905;
        Wed, 26 Jul 2023 02:05:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s05j5jcwf-7;
        Wed, 26 Jul 2023 02:05:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH v2 00/10] qla2xxx driver bug fixes
Date:   Tue, 25 Jul 2023 22:04:52 -0400
Message-Id: <169033702314.2256288.8616396834195939509.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230714070104.40052-1-njavali@marvell.com>
References: <20230714070104.40052-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=862
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260016
X-Proofpoint-GUID: Z0x2W20KAgsPfSEhEYhUm0C1krLVfynx
X-Proofpoint-ORIG-GUID: Z0x2W20KAgsPfSEhEYhUm0C1krLVfynx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 14 Jul 2023 12:30:54 +0530, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver bug fixes to
> the scsi tree at your earliest convenience.
> 
> v2:
> - Remove extra line from qla_gbl.h in 02/10
> - Add Reviewed-by tag
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[01/10] qla2xxx: Fix deletion race condition
        https://git.kernel.org/mkp/scsi/c/6dfe4344c168
[02/10] qla2xxx: Adjust iocb resource on qpair create
        https://git.kernel.org/mkp/scsi/c/efa74a62aaa2
[03/10] qla2xxx: Limit TMF to 8 per function
        https://git.kernel.org/mkp/scsi/c/a8ec192427e0
[04/10] qla2xxx: Fix command flush during TMF
        https://git.kernel.org/mkp/scsi/c/da7c21b72aa8
[05/10] qla2xxx: Fix erroneous link up failure
        https://git.kernel.org/mkp/scsi/c/5b51f35d127e
[06/10] qla2xxx: Fix session hang in gnl
        https://git.kernel.org/mkp/scsi/c/39d22740712c
[07/10] qla2xxx: Turn off noisy message log
        https://git.kernel.org/mkp/scsi/c/8ebaa45163a3
[08/10] qla2xxx: Fix TMF leak through
        https://git.kernel.org/mkp/scsi/c/5d3148d8e8b0
[09/10] qla2xxx: fix inconsistent TMF timeout
        https://git.kernel.org/mkp/scsi/c/009e7fe4a1ed
[10/10] qla2xxx: Update version to 10.02.08.500-k
        https://git.kernel.org/mkp/scsi/c/a31a596a4265

-- 
Martin K. Petersen	Oracle Linux Engineering
