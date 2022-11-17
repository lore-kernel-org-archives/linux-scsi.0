Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94602C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240656AbiKQSaJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240542AbiKQS3r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:29:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1087DEC6
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:29:47 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHIPXR9014158;
        Thu, 17 Nov 2022 18:29:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=nV8YLMtNYeuQcGRnGhERAgBEzEsObginrIzQfWMdTvM=;
 b=IluykHUBRHzZymLL+kIrJwcyr1D79xXKd5Mw85BRga7uUqepUosJqC3GAkW66yyjCgtw
 Eq30vxvElXFQbVSYXvG+Uq9BBHEfqSyfuZc8uVE+Rh5mi1V1hji7qTKkYgsw9pgwNiAu
 /UHEh0lwy9U+++oEi5rZiHil9GjV65QJGyk6WkxZUQmu/03D1RX8U/W1VThyNTnuFs7/
 3VG64xoCYMM+Q4pJpGForIu4yT8MCDlAAjcRTPYhjQrM4hK7pCcBEkATACoGIUE3qaPV
 4UodJuUvSvWLsrydde4YxA/7copqeoh2DmrQ/crn5taRMtFq38JF+nqO93OLcxRs0w8l ZA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3jst0sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:29:41 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AHHHUEV010994;
        Thu, 17 Nov 2022 18:29:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ku3kab0h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:29:37 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AHITap3022894;
        Thu, 17 Nov 2022 18:29:36 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ku3kab0gb-2;
        Thu, 17 Nov 2022 18:29:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Arun Easi <arun.easi@qlogic.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix set-but-not-used variable warnings
Date:   Thu, 17 Nov 2022 13:29:24 -0500
Message-Id: <166870943120.1584889.4901952216384811281.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221031224818.2607882-1-bvanassche@acm.org>
References: <20221031224818.2607882-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=891 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211170133
X-Proofpoint-ORIG-GUID: yzKoDVml0emG_Yvcz6XBAcPN7g6QumDY
X-Proofpoint-GUID: yzKoDVml0emG_Yvcz6XBAcPN7g6QumDY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 31 Oct 2022 15:48:18 -0700, Bart Van Assche wrote:

> Fix the following two compiler warnings:
> 
> drivers/scsi/qla2xxx/qla_init.c: In function ‘qla24xx_async_abort_cmd’:
> drivers/scsi/qla2xxx/qla_init.c:171:17: warning: variable ‘bail’ set but not used [-Wunused-but-set-variable]
>   171 |         uint8_t bail;
>       |                 ^~~~
> drivers/scsi/qla2xxx/qla_init.c: In function ‘qla2x00_async_tm_cmd’:
> drivers/scsi/qla2xxx/qla_init.c:2023:17: warning: variable ‘bail’ set but not used [-Wunused-but-set-variable]
>  2023 |         uint8_t bail;
>       |                 ^~~~
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Fix set-but-not-used variable warnings
      https://git.kernel.org/mkp/scsi/c/4fb2169d66b8

-- 
Martin K. Petersen	Oracle Linux Engineering
