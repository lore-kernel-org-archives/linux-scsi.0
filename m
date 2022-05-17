Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27087C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 02:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiEQCQu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 22:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiEQCQt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 22:16:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CB33B556
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2022 19:16:48 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKrCWp027282;
        Tue, 17 May 2022 02:16:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=i0HgM0+QBPGuKMUMqibwzHq4KLlNGVNG0LOwR9AHo4w=;
 b=k695PJbI5o6zm4d+OJNlzcCaNEffbOSlLaHkNkjoz6EMOq76oSdLlmMH8+jtnaBq++AG
 4xN+UGx+QQPpAv9wXKdYH9Ifea4CEMHn2+GwULSlKXcOKTJZ7bISDIeqO+Bg4vJOpCBt
 5yU+ylgzQgajt7SKB+HVUqnrJsUpCucYTa56d+z6/fNNhjTpiyP9vcd0jsU983Eu55IB
 g13QWVbMpK6PmsiuHNFa1JS7QrE3fxpXKumsB8mdjw6owXYSvnHhlMDO4K3A+tTJPYLD
 qG6MuY8BNfJDcsf5WygRHtAg22h6+xkNlap7ZcxUAoADEhvKii6KswYS0evp/d+sVMwD BQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2371vy1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 02:16:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24H2G8nZ019235;
        Tue, 17 May 2022 02:16:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v83hmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 02:16:46 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24H2Ghw5019875;
        Tue, 17 May 2022 02:16:46 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v83hkf-6;
        Tue, 17 May 2022 02:16:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpi3mr: Hidden drives not removed during soft reset
Date:   Mon, 16 May 2022 22:16:41 -0400
Message-Id: <165275376861.24722.16126558314300804095.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220505184808.24049-2-sreekanth.reddy@broadcom.com>
References: <20220505184808.24049-1-sreekanth.reddy@broadcom.com> <20220505184808.24049-2-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 0_9WlxaSp_Aw0erhTQLtMWTRpyWHQQVm
X-Proofpoint-ORIG-GUID: 0_9WlxaSp_Aw0erhTQLtMWTRpyWHQQVm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 6 May 2022 00:18:07 +0530, Sreekanth Reddy wrote:

> If any drive is missing during the reset, the driver
> checks whether the device is exposed to the OS and if it is,
> then only it removes the device from the OS and
> its own internal list. For hidden devices even if they are found
> as missing during reset the driver is not removing them from
> its internal list. Modified driver to remove hidden devices
> from the driver's target device list if they are missing
> during soft reset.
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/1] mpi3mr: Hidden drives not removed during soft reset
      https://git.kernel.org/mkp/scsi/c/2dd8389f96d6

-- 
Martin K. Petersen	Oracle Linux Engineering
