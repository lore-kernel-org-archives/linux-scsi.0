Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17E5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343681AbiDGNiD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343696AbiDGNhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B083426E7
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237BoiKp004892
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=kN/pzRUmMy8Exw2errKBmv2t5PBQvLKa6gn/FZbS7Vk=;
 b=LVoQT8R5r0Ot32i/3eguKTLqsYfBwej+3H0JqA7h6HYxwuQV2/RuvogDZ/mVNtosntAv
 Ez5c6JkbkAVaXj5KZjU9eQt4lLt5iURiRozFfGAJcCZY6WSL5moEcof4IFB3eHUgRTQT
 pRW8yra4UecnyTXpTQBvKC37ndwg/45hFyIrn6FdUpuqVhCxwBORLOf6yDj+l3Khpfbg
 usd0C309jKaMSjIIq5dmOJy4OO3IBdTJP+RIdXEAwT2lN+5ykgPcmnsxj0ztLLDJK/BR
 /k142axOWh/Ka/e0Dcjyjx97b1A2wdSYUSRZqW1+Q6CEWAmoIBo1aZfQqkwmwlIHP4LH rg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d933ynm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVK3036827
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:31 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJME032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:31 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-17;
        Thu, 07 Apr 2022 13:35:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] aic7xxx: use standard pci subsystem, subdevice defines
Date:   Thu,  7 Apr 2022 09:35:16 -0400
Message-Id: <164929679001.15424.5138282384466055076.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220322144648.2467777-1-trix@redhat.com>
References: <20220322144648.2467777-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 25coKRrGiGV4z7ojGJmgjJ-bgl_OWviH
X-Proofpoint-GUID: 25coKRrGiGV4z7ojGJmgjJ-bgl_OWviH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Mar 2022 07:46:48 -0700, trix@redhat.com wrote:

> From: Tom Rix <trix@redhat.com>
> 
> Common defines should be used over custom defines.
> 
> Change and remove these defines
> PCIR_SUBVEND_0 to PCI_SUBSYSTEM_VENDOR_ID
> PCIR_SUBDEV_0 to PCI_SUBSYSTEM_ID
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/1] aic7xxx: use standard pci subsystem, subdevice defines
      https://git.kernel.org/mkp/scsi/c/37a9bd7090cd

-- 
Martin K. Petersen	Oracle Linux Engineering
