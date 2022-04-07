Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0012C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343686AbiDGNiH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343678AbiDGNhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9D82187
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:27 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237D7m7d024505
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=Pz2OpM75yCUdehgEcxEvef+Q3t4B+XAv6YvLtx9PtIU=;
 b=vZH4b7G2QtHpj/JQKJimAiSO2Pf2AeonFBAxX7rt9ZNNbK38DeTs4lxIrK2r/v02Gx8m
 A1l088o3sJQ6egRYlPigg/b9xgxiBJBtqG/Nkn226iSntCCqxuwDvusRLGfsjucja8ly
 08xxE1/I64eWXVmBGRALfH2sgC7DFHCDPdJXnzJJ1cLW6Ejeq76/LwPtBN3Pktt9SLLn
 mIgJ7wKIpuNDqXLhpfxFtCcGJHnWcaIzHmQt46MJOGsUgz5l0NX/ZYwIkkFvXg9MGVDd
 dkDcJNB2Sxgsh4pt1k0u73hcG8BuDxJGiZ2D9XYYi80rq67OJh7+yGvewPKX3QsJfL+M 5Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tc3rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLV6e036872
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:26 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJLw032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:26 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-9;
        Thu, 07 Apr 2022 13:35:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] lpfc: Fix regressions in 14.2.0.0 refactoring
Date:   Thu,  7 Apr 2022 09:35:08 -0400
Message-Id: <164929678998.15424.15683001536446888702.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220323205545.81814-1-jsmart2021@gmail.com>
References: <20220323205545.81814-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: BnorocGY2eyvmL2FsO-QT9APqAsnt1As
X-Proofpoint-GUID: BnorocGY2eyvmL2FsO-QT9APqAsnt1As
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 23 Mar 2022 13:55:43 -0700, James Smart wrote:

> Two regressions were found in further testing of the refactoring
> work done for the 14.2.0.0 driver rev.
> 
> These 2 patches correct the regressions
> 
> James Smart (2):
>   lpfc: Fix broken sli4 abort path
>   lpfc: Fix locking for lpfc_sli_iocbq_lookup
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/2] lpfc: Fix broken sli4 abort path
      https://git.kernel.org/mkp/scsi/c/7294a9bcaa7e
[2/2] lpfc: Fix locking for lpfc_sli_iocbq_lookup
      https://git.kernel.org/mkp/scsi/c/c26bd6602e1d

-- 
Martin K. Petersen	Oracle Linux Engineering
