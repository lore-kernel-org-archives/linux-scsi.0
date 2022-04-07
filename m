Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC203C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343709AbiDGNhu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343681AbiDGNhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE7C21B0
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:29 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237D6rkg014716
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=XvA23xvxwMVqyTu63ClwgiPuHEPlHrg/BeUG54DSLtg=;
 b=cFweYZvpmG8Yoi2PSI1pAGFli26XwWzNtxPxbn6oSP7oqpII8sLF8dygY9CWLDK8ub/u
 EazzwqSdGnnuqWd4fh4ou36MzZRtDIg5BEWVWtQfQAEcaxsCaWfYvhMBDzSkYyOc5VRH
 CoBGAGoVrFrqkKuYa3umTx2athP4iuGOZr3E/lMp7C9iK6GNYMJ+UErjeKAotE7gU1PZ
 ww9biwgl2wym91GE94cgrrHh78aOn6rtAl2pQmv7TZfNlb/m9mLKJ9D7mOPc7GZmNZVo
 SgzYssnL+4mBIh4ZHq+HZZzyMAuccywW7Tdun9VwES7E8L9dR0iEeVCnbC9QNEewWyqL 3Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9up2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVwc036871
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:25 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJLu032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:25 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-8;
        Thu, 07 Apr 2022 13:35:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: core: Fix sbitmap depth in scsi_realloc_sdev_budget_map()
Date:   Thu,  7 Apr 2022 09:35:07 -0400
Message-Id: <164929678999.15424.13333895557979890772.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1647423870-143867-1-git-send-email-john.garry@huawei.com>
References: <1647423870-143867-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: FCD-j0HvCTUpKIlBGpCgY5dztSyj48BM
X-Proofpoint-ORIG-GUID: FCD-j0HvCTUpKIlBGpCgY5dztSyj48BM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 16 Mar 2022 17:44:30 +0800, John Garry wrote:

> In commit edb854a3680b ("scsi: core: Reallocate device's budget map on
> queue depth change"), the sbitmap for the device budget map may be
> reallocated after the slave device depth is configured.
> 
> When the sbitmap is reallocated we use the result from
> scsi_device_max_queue_depth() for the sbitmap size, but don't resize to
> match the actual device queue depth.
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/1] scsi: core: Fix sbitmap depth in scsi_realloc_sdev_budget_map()
      https://git.kernel.org/mkp/scsi/c/eaba83b5b850

-- 
Martin K. Petersen	Oracle Linux Engineering
