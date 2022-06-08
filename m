Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42EDCCA482
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 06:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbiFHGBe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 02:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348202AbiFHF6R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 01:58:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631F4118017;
        Tue,  7 Jun 2022 21:26:13 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257MZh7N005922;
        Wed, 8 Jun 2022 02:28:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=QBjJtZDyQQ6rNwQp7qY4zqa8tWoq3Mz0Tas3Bu6mWX0=;
 b=DQxqLz1zBIuj9CaEet8lCMXARi/FwOx9iCFPhZq9iBJ6xramQ5ImnisPbHCFyZ21sy6g
 eiA4r96buaZ7yVm5c5BjO5+nwhm2yQ2+AAYqdI7oYws7h99FY9+lQ/qD+wpG/uEHy+IC
 0q1FOBkCgRL7vOCeWvyUgT6nOc83+op6sj6v0XOPfsrARf5Agds1DBOwqWqGcBhr8ovM
 dEeGTYDOd7DaA8gfZF96IC9RwNbctpCi2B1lCgE+USyKteN/E+6KRJRBWiN+2avaW2mM
 A4FJ96AV0Nh17HkWHVYXqojUJ0HMEr34W61Lj5OH9Ts+y10yithaeoe3Lx9S/svmWaK1 NA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghexecnmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 02:28:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2582ATvA037921;
        Wed, 8 Jun 2022 02:28:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu3349u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 02:28:01 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2582RxlR032073;
        Wed, 8 Jun 2022 02:28:00 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu33499-2;
        Wed, 08 Jun 2022 02:28:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     MPT-FusionLinux.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Helge Deller <deller@gmx.de>, linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Fix out-of-bounds compiler warning
Date:   Tue,  7 Jun 2022 22:27:54 -0400
Message-Id: <165465514542.8982.4564879161445933533.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <YpZ197iZdDZSCzrT@p100>
References: <YpZ197iZdDZSCzrT@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Jb78EwI-coNPdm8MnWruaK3PiCHKJlC5
X-Proofpoint-ORIG-GUID: Jb78EwI-coNPdm8MnWruaK3PiCHKJlC5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 31 May 2022 22:09:27 +0200, Helge Deller wrote:

> I'm facing this warning when building for the parisc64 architecture:
> 
> drivers/scsi/mpt3sas/mpt3sas_base.c: In function ‘_base_make_ioc_operational’:
> drivers/scsi/mpt3sas/mpt3sas_base.c:5396:40: warning: array subscript ‘Mpi2SasIOUnitPage1_t {aka struct _MPI2_CONFIG_PAGE_SASIOUNIT_1}[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds]
>  5396 |             (le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth)) ?
> drivers/scsi/mpt3sas/mpt3sas_base.c:5382:26: note: referencing an object of size 20 allocated by ‘kzalloc’
>  5382 |         sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
>       |                          ^~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Applied to 5.19/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: Fix out-of-bounds compiler warning
      https://git.kernel.org/mkp/scsi/c/120f1d95efb1

-- 
Martin K. Petersen	Oracle Linux Engineering
