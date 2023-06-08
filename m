Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E155C7EE23
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 01:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbjFHBmv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 21:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbjFHBmq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 21:42:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4377C26A9
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 18:42:41 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357Mv4vU026210;
        Thu, 8 Jun 2023 01:42:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=yJzcKtgi/FAJzpLIE6ETXoc+95zdAQQSfbwJT3aPcjg=;
 b=BRhkkFX/EXtzDdB6GGfkUpnsKI8hDC4Y7a07/USlOpBj2YSALtPdQ6Mep86wm+dAKZor
 uWIV4sL5JtbQHfZEifiOY8FeoWEKaTxqyVjOpkft7ldzP+gE9fzHugrBC/Jx3GxCDJbu
 eq8dPXGIwK3h3KauKNZWwZyD5LOg2/1OaCDQdPCUznQoGM0+QJXjKWtYhLrZvRQJBNBf
 9agVHmkiC9Je49kjHVeudUNBSo4pbNWzPO5pHwuExMa/X8sfv2ajwrlxxBO34/d6Qx17
 ewetg/t3jboNk3rV6dbpICxGTABlu8FEUQNB9AR1FZnqP3USnw2hNm18zeY/zQ2ZLgjd fw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6rb4xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:37 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 357NxY2I037188;
        Thu, 8 Jun 2023 01:42:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6hyt7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:36 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3581gQUr031871;
        Thu, 8 Jun 2023 01:42:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3r2a6hyt3a-8;
        Thu, 08 Jun 2023 01:42:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/3] SCSI core patches
Date:   Wed,  7 Jun 2023 21:42:12 -0400
Message-Id: <168618844253.2636448.15585018574185355591.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518193159.1166304-1-bvanassche@acm.org>
References: <20230518193159.1166304-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_13,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=702 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306080011
X-Proofpoint-ORIG-GUID: ba6lzxpRmY47CcZiFXmYSARUjliFP0IJ
X-Proofpoint-GUID: ba6lzxpRmY47CcZiFXmYSARUjliFP0IJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 May 2023 12:31:56 -0700, Bart Van Assche wrote:

> Please consider these SCSI core patches for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> Changes compared to v3:
> - Changed the SCSI tracing format to make it less likely to break existing
>   user space software that parses SCSI trace information.
> - Dropped patch "Delay running the queue if the host is blocked".
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/3] scsi: core: Use min() instead of open-coding it
      https://git.kernel.org/mkp/scsi/c/416dace649c4
[2/3] scsi: core: Trace SCSI sense data
      https://git.kernel.org/mkp/scsi/c/8bb1c6243c4b
[3/3] scsi: core: Only kick the requeue list if necessary
      https://git.kernel.org/mkp/scsi/c/8b566edbdbfb

-- 
Martin K. Petersen	Oracle Linux Engineering
