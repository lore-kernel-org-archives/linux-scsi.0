Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8129C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 May 2022 11:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358552AbiEEL4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 07:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358561AbiEEL4E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 07:56:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCC554687;
        Thu,  5 May 2022 04:52:25 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242JuuCb019339;
        Tue, 3 May 2022 00:52:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=v3tgsvBwZrwBJL+dPJr1DWVn5Orb7oEWJBwYaqvh1z8=;
 b=G5mgt1cswu9ZpiknMhKqQ5ibIVH64/Zhg3Tp7IWPbpSJhDoI6Sz0AAguLqVpGB2YGRgV
 taCra3o/8TGMwqiug0swEjTitojwicA7m99PV9zkZU9q1eawTkd6uGPz2DtcuDBx9iBj
 rMGX9IFAWhlRQNT6NOSOdj1V2DpdZdnWc6JnJMTKnhY+Tc1teofj6PAzzeCJMtQF4jJD
 N/aiLA5c5pNN1AD+SS082nXPTI1VkZ59GJmledyXaadLB/+mMRRlWekoxPCBmvgJ6R3y
 MIOCSDbMTtsH1ULmLL904dvk2wu+/1GlGzKsU2SSq7P7mpfMg4a5YUjuBx9GR9dXziyo eQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwnt4kxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430oqLi008978;
        Tue, 3 May 2022 00:52:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83xct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:07 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430plk8010389;
        Tue, 3 May 2022 00:52:07 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-36;
        Tue, 03 May 2022 00:52:07 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, bostroesser@gmail.com
Subject: Re: [PATCH v5] scsi: target: tcmu: Fix possible data corruption
Date:   Mon,  2 May 2022 20:51:46 -0400
Message-Id: <165153836364.24053.11408559773889328291.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220421023735.9018-1-xiaoguang.wang@linux.alibaba.com>
References: <20220421023735.9018-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 5DUEGifWKu5CWy7uSv1o1GbzJuI2Zez9
X-Proofpoint-GUID: 5DUEGifWKu5CWy7uSv1o1GbzJuI2Zez9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 21 Apr 2022 10:37:35 +0800, Xiaoguang Wang wrote:

> When tcmu_vma_fault() gets one page successfully, before the current
> context completes page fault procedure, find_free_blocks() may run in
> and call unmap_mapping_range() to unmap this page. Assume when
> find_free_blocks() completes its job firstly, previous page fault
> procedure starts to run again and completes, then one truncated page has
> beed mapped to use space, but note that tcmu_vma_fault() has gotten one
> refcount for this page, so any other subsystem won't use this page,
> unless later the use space addr is unmapped.
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Fix possible data corruption
      https://git.kernel.org/mkp/scsi/c/bb9b9eb0ae2e

-- 
Martin K. Petersen	Oracle Linux Engineering
