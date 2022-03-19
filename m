Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD326C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Mar 2022 03:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242024AbiCSD6w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 23:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbiCSD6m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 23:58:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1769A103B80
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2022 20:57:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22J1Va7e017423;
        Sat, 19 Mar 2022 03:57:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=D5buzdYVxveqLmM2t6lRINME42CNDM0L1MzifPcFZM0=;
 b=BGxS7zu2DgmeL0GGT3mMeT+4YC4Xni4+xAwgHBRmemL16w7sNMHZMOOMFU7Do3uuLd73
 DN7lpDtgkuPy/v8tV2V2oKDJtpguTAonS5M9Hf3KrlkCOkTD1b3qXX9jeCU86UPooIE8
 eRtiCFeJ1iPaCS7JHOiXChm7mBmFPJgK6SJXd+cw0RrskOhxM7uRrq4N4iMsPYtBF6NP
 NEHKQeuF+ZGLbN5EWOxxBE8dwTldlhORpT7SUlStK7bVNFCdsd97wuqgxcKUChJPdQdK
 MNXcwlELmDY7MMopree9AboGp6+y8nJ/GOVfn+qY4T+r7ccbzqi25NqA5cYtRaVsFo5c tQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcg2m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22J3uvsn007045;
        Sat, 19 Mar 2022 03:57:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:19 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22J3v5Qw007126;
        Sat, 19 Mar 2022 03:57:18 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshmn-11;
        Sat, 19 Mar 2022 03:57:18 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v2 00/13] qla2xxx driver fixes
Date:   Fri, 18 Mar 2022 23:57:01 -0400
Message-Id: <164766213031.31329.1526925156124972546.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220310092604.22950-1-njavali@marvell.com>
References: <20220310092604.22950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: a9ccqD0K4KvDUvFrRRU41hnND00ER1q5
X-Proofpoint-ORIG-GUID: a9ccqD0K4KvDUvFrRRU41hnND00ER1q5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 10 Mar 2022 01:25:51 -0800, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver misc bug fixes to the scsi tree
> at your earliest convenience.
> 
> v2:
> - Incorporate all minor review comments
> - Add Fixes tag to 11/13
> - Add Reviewed-by tag
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[01/13] qla2xxx: Fix incorrect reporting of task management failure
        https://git.kernel.org/mkp/scsi/c/58ca5999e036
[02/13] qla2xxx: Fix disk failure to rediscover
        https://git.kernel.org/mkp/scsi/c/6a45c8e137d4
[03/13] qla2xxx: Fix loss of NVME namespaces after driver reload test
        https://git.kernel.org/mkp/scsi/c/db212f2eb3fb
[04/13] qla2xxx: Fix missed DMA unmap for NVME ls requests
        https://git.kernel.org/mkp/scsi/c/c85ab7d9e27a
[05/13] qla2xxx: Fix crash during module load unload test
        https://git.kernel.org/mkp/scsi/c/0972252450f9
[06/13] qla2xxx: fix n2n inconsistent plogi
        https://git.kernel.org/mkp/scsi/c/c13ce47c64ea
[07/13] qla2xxx: Fix hang due to session stuck
        https://git.kernel.org/mkp/scsi/c/c02aada06d19
[08/13] qla2xxx: Fix laggy FC remote port session recovery
        https://git.kernel.org/mkp/scsi/c/713b415726f1
[09/13] qla2xxx: reduce false trigger to login
        https://git.kernel.org/mkp/scsi/c/d2646eed7b19
[10/13] qla2xxx: Fix stuck session of prli reject
        https://git.kernel.org/mkp/scsi/c/f3502e2e98a9
[11/13] qla2xxx: Use correct feature type field during rffid processing
        https://git.kernel.org/mkp/scsi/c/a7e05f7a1bcb
[12/13] qla2xxx: Increase max limit of ql2xnvme_queues
        https://git.kernel.org/mkp/scsi/c/3648bcf1c137
[13/13] qla2xxx: Update version to 10.02.07.400-k
        https://git.kernel.org/mkp/scsi/c/811655d005b2

-- 
Martin K. Petersen	Oracle Linux Engineering
