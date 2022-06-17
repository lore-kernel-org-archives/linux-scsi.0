Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B1CCCA47E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 02:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379698AbiFQCUi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379692AbiFQCUf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 22:20:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232CD64BE4
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 19:20:34 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25H0Nxcf032726;
        Fri, 17 Jun 2022 02:20:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=BU/H6yrFeCtO/q4QQN5kffcZXGyYzsayIZkuE0LnD58=;
 b=hH9f2pFlDaIO5a2OsQ+ZdPU7AOpv6DShEhaVyMAWlfm5K8aGuTKc+tvK2llu9r0aVoki
 C4SFueecQi6gDmEtg4RC5Up/kAgjLkQ7pLEZwYlf6SpWqLyD/rYrd/235zGlSXpu7vnV
 5LsOz00ry/qUgKZ5BS8v7ugPqSsPFwaqYX8iBceBrfOX2KdJYuKqY/eawTfkLUsoKZu+
 he9AU9cMDvpuvb//xJ5mhDNSaiS+rtyJfVw270VI2y49OMspTx6LvkiEWCx2akSnbD9v
 xkw0JWsd2q3SqUh/NrAzyN9agHxgpKLdGKkZ5qFQgT5fqB3dLkksDeI3rDlhXdJ6j7bx xw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2vv14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 02:20:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25H2GGwx038516;
        Fri, 17 Jun 2022 02:20:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpqq327dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 02:20:22 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25H2KMSa006844;
        Fri, 17 Jun 2022 02:20:22 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpqq327d4-1;
        Fri, 17 Jun 2022 02:20:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v2 0/3] ufs: Fix a race between the interrupt handler and the reset handler
Date:   Thu, 16 Jun 2022 22:20:18 -0400
Message-Id: <165543238453.26073.13111240985908624306.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220613214442.212466-1-bvanassche@acm.org>
References: <20220613214442.212466-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: CbkWeIQGFdDbT6vguuXlKQnD6Gt00lvg
X-Proofpoint-ORIG-GUID: CbkWeIQGFdDbT6vguuXlKQnD6Gt00lvg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Jun 2022 14:44:39 -0700, Bart Van Assche wrote:

> This patch series is version two of a fix between the UFS interrupt handler and
> reset handlers. Please consider this patch series for kernel v5.20.
> 
> Changes compared to v1:
> - Converted a single patch into three patches.
> - Modified patch 3/3 such that only cleared requests are completed.
> 
> [...]

Applied to 5.19/scsi-fixes, thanks!

[1/3] scsi: ufs: Simplify ufshcd_clear_cmd()
      https://git.kernel.org/mkp/scsi/c/da8badd7d358
[2/3] scsi: ufs: Support clearing multiple commands at once
      https://git.kernel.org/mkp/scsi/c/d1a7644648b7
[3/3] scsi: ufs: Fix a race between the interrupt handler and the reset handler
      https://git.kernel.org/mkp/scsi/c/2acd76e7b859

-- 
Martin K. Petersen	Oracle Linux Engineering
