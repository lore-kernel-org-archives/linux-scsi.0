Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D18C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 18:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376573AbiEDSJt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 14:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377165AbiEDSJT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 14:09:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB81A6B0B4
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 10:25:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242KU6TI027785;
        Tue, 3 May 2022 00:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=Q1dTKzZD5M5OdfSISxllMHRcvVgQhr7ZoMHap2gCs0g=;
 b=pR24MoyC7mAhKkhi15UkF8asM6kY4ii7hg5l0g5B5WVome6PJBv8KzJG2JuwmJB3xQ0n
 19GcInPHe+DynuJuaS+kXoUCjpcmG2ukpdrHOhdR40+RIgMXpvH3/UKThTvz5RSKPKa2
 v4rMaY4eVJR6YEFtgiAmSE0Q4rrN0/PoOG3/22f9bBmAq/Ca2BMlcS9fAVxAtFMFxkFZ
 y19dGe2cLzXXl0q5NQZYMZFoWz1G8ocksq9pGscIw2gSadTbFAbJE8DQzwijY6g6VaFp
 deCD8RjofR14tR0y7u64cGag/dTiMWcpl1q4vpv4esDGlGuAZ2m5w3beVsw37DNp//pQ yQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruw2cnvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:50:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430fHFX040374;
        Tue, 3 May 2022 00:50:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a493ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:50:29 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430mf4v010456;
        Tue, 3 May 2022 00:50:29 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a493ef-2;
        Tue, 03 May 2022 00:50:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Date:   Mon,  2 May 2022 20:50:26 -0400
Message-Id: <165153834205.24012.4172910984795478484.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <AS8PR10MB4952D545F84B6B1DFD39EC1E9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
References: <AS8PR10MB4952D545F84B6B1DFD39EC1E9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: lFE8H9NA6w5-BEs3s3jzs0zM51FcN8wS
X-Proofpoint-ORIG-GUID: lFE8H9NA6w5-BEs3s3jzs0zM51FcN8wS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 15 Apr 2022 12:42:29 +0000, Chesnokov Gleb wrote:

> Aborting commands that have already been sent to the firmware can
> cause BUG in qlt_free_cmd(): BUG_ON(cmd->sg_mapped)
> 
> For instance:
> - command passes rdx_to_xfer state, maps sgl, sends to the
>   fimware
> - reset occurs, qla2xxx performs ISP error recovery,
>   aborts the command
> - target stack calls qlt_abort_cmd() and then qlt_free_cmd()
> - BUG_ON(cmd->sg_mapped) in qlt_free_cmd() occurs because sgl was not
>   unmapped
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
      https://git.kernel.org/mkp/scsi/c/26f9ce53817a

-- 
Martin K. Petersen	Oracle Linux Engineering
