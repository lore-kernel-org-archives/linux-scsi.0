Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA130C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 May 2022 23:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242132AbiEEXjg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 19:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiEEXjf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 19:39:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1BC2559B
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 16:35:54 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242MuHJr018680;
        Tue, 3 May 2022 00:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=Es/5OD0KUkmr8OM3NehN+pi4X75+/FfXyBubUsa43Sg=;
 b=OBoPzsU7BkWFPx56M+ulimOFZrTLXD/bhtQoLDLNLfBA7XCOu+xAlgNqXifKS7rqWCyH
 Ksz154k1J3QsOHVIZIw8900k8hkXIvg8ObZK4riwq1TsfZzoN4ckVKJGYhnM5TbhLH7Z
 0pu9MoLNXEUEkF98uvHvOGGHOCHh6XxynW6eEHem+Zh3tTEvbExNzicDt/rszhopcGEw
 c7mXA1i0UhN7m+1Jv935W8GPfKQ850D0u8Hs1K3qqlFTFZ9BwjPjgzsbJ8tchXW439V3
 ikSYg4e/VYJmpWeyP2mfRew5m8NinsHG2L5G4wT0UbIvWJ5PMFzc3tnVfIBP/tXs1GGo Tw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwnt4kwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430op5v008954;
        Tue, 3 May 2022 00:51:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:58 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430plja010389;
        Tue, 3 May 2022 00:51:58 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-20;
        Tue, 03 May 2022 00:51:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
Date:   Mon,  2 May 2022 20:51:30 -0400
Message-Id: <165153836358.24053.975124472230809644.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: mBG2qe-xZRwoWmcP2Q0Di08_iO64u2xq
X-Proofpoint-GUID: mBG2qe-xZRwoWmcP2Q0Di08_iO64u2xq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Mar 2022 08:48:49 +0900, Damien Le Moal wrote:

> This series fix (remove) all sparse warnings generated when compiling
> the mpt3sas driver. All warnings are related to __iomem access and
> endianness.
> 
> The series was tested on top of Martin's 5.18/scsi-staging branch with a
> 9400-8i HBA with direct attached iSAS and SATA drives. The fixes need
> careful review by the maintainers as there is no documentation clearly
> explaning the proper endianness of the values touched.
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/5] scsi: mpt3sas: fix _ctl_set_task_mid() TaskMID check
      https://git.kernel.org/mkp/scsi/c/dceaef94a475
[2/5] scsi: mpt3sas: Fix writel() use
      https://git.kernel.org/mkp/scsi/c/b4efbec4c2a7
[3/5] scsi: mpt3sas: fix ioc->base_readl() use
      https://git.kernel.org/mkp/scsi/c/7ab4d2441b95
[4/5] scsi: mpt3sas: fix event callback log_code value handling
      https://git.kernel.org/mkp/scsi/c/82b4420c288c
[5/5] scsi: mpt3sas: fix adapter replyPostRegisterIndex declaration
      https://git.kernel.org/mkp/scsi/c/fe413ab32b24

-- 
Martin K. Petersen	Oracle Linux Engineering
