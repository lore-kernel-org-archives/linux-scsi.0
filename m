Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8978EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 16:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjGKQcX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 12:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbjGKQcT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 12:32:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3729010D5;
        Tue, 11 Jul 2023 09:32:16 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BF3e7J014126;
        Tue, 11 Jul 2023 16:31:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=7sz3y6Tzr61h75qwIT38tdE+/wEacLrZHIbaOe4JUno=;
 b=omBNfBx3K214Pp7AYMkxBJIhuL3WX/ciBQhhFxsHStvaG9wWjA428LjLlZHO0rgKqSiK
 DxLFj7WrvP27NUvEIJplSvnWYWUKE0qrJ2FLqYOQXjC0oNVdvk28FvdTcWkW/2tVWyv4
 Ysh+mP8giSomtTkBzhzdYNQX+VbzeUHPCAe0vFSpbnQAE5aRbtqgBLRimexg2rM+15sq
 LDODN74w3uICp/QujPJs5tIauFJ4VnqLLwIECn1t23OmLuFCxcwk61qVxoFil507IrkE
 rdB8IVLnZntQN8PXVyWmo7jL+k3IOMbAEM7LjE72fGu2bRl64M2SwcvDf+KDz+71yoET 4Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrea2uaxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 16:31:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BF7dvj007067;
        Tue, 11 Jul 2023 16:31:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx854c8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 16:31:57 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BGQBXL019529;
        Tue, 11 Jul 2023 16:31:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3rpx854c4h-2;
        Tue, 11 Jul 2023 16:31:56 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Dan Carpenter <dan.carpenter@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-scsi@vger.kernel.org,
        llvm@lists.linux.dev, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: qla2xxx: silence a static checker warning
Date:   Tue, 11 Jul 2023 12:31:43 -0400
Message-Id: <168909306191.1197987.9474778545088785387.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <4aa0485e-766f-4b02-8d5d-c6781ea8f511@moroto.mountain>
References: <4aa0485e-766f-4b02-8d5d-c6781ea8f511@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=854
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110148
X-Proofpoint-GUID: Fs-aFYn6RkuLwnQ7jVtfPTGEXPmlZ9z5
X-Proofpoint-ORIG-GUID: Fs-aFYn6RkuLwnQ7jVtfPTGEXPmlZ9z5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 26 Jun 2023 13:58:03 +0300, Dan Carpenter wrote:

> Smatch and Clang both complain that LOGIN_TEMPLATE_SIZE is more than
> sizeof(ha->plogi_els_payld.fl_csp).
> 
> Smatch warning:
>     drivers/scsi/qla2xxx/qla_iocb.c:3075 qla24xx_els_dcmd2_iocb()
>     warn: '&ha->plogi_els_payld.fl_csp' sometimes too small '16' size = 112
> 
> [...]

Applied to 6.5/scsi-fixes, thanks!

[1/2] scsi: qla2xxx: silence a static checker warning
      https://git.kernel.org/mkp/scsi/c/134f66959cd0
[2/2] scsi: qla2xxx: Fix error code in qla2x00_start_sp()
      https://git.kernel.org/mkp/scsi/c/e579b007eff3

-- 
Martin K. Petersen	Oracle Linux Engineering
