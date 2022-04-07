Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49CBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343700AbiDGNiN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343717AbiDGNhj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B0F10BF
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237A6w4b024455;
        Thu, 7 Apr 2022 13:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=fuLbde0Sb2wuM2u0gtD4+O1fImJzR/iUfE2XPORlg2Y=;
 b=F32Na+h24GoOOZ863c/a8f8S8jnYd85QKLOCGzq+SvmPpU54Ga4v9J85tsQORnWMg97p
 E4oJ2tCxk4QCifPSdRq/7qc1bXfamxK6yC+nbq09sifqH3l3H7OpHa0e+A1ST5qyIriU
 FWTHBtze9CaOOEp73pzqP8xPCuKrP5D9Yg29ulBCFwGsdiTKV8qbe+UdS77C0HxdhR0Z
 pv89ETTEUylnVqQWPFv+LY1BpjN5axMDpn0XndK3wJjBM7PmCiZpattlqmTb9aRKIDpk
 IfEeYUcqVEb+nR4fDY0WUHQyZWnjQQDZTssTmvZgDiIDkk50R1Ixb4SQe72ksP3n5nmi 7A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tc3rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 13:35:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVR3036847;
        Thu, 7 Apr 2022 13:35:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 13:35:23 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJLn032479;
        Thu, 7 Apr 2022 13:35:22 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-5;
        Thu, 07 Apr 2022 13:35:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: hisi_sas: remove stray fallthrough annotation
Date:   Thu,  7 Apr 2022 09:35:04 -0400
Message-Id: <164929679000.15424.742139603471401424.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220317075214.GC25237@kili>
References: <20220317075214.GC25237@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: oDGAkKx6zgmcLzcDLohP9xXGJsV6f4At
X-Proofpoint-GUID: oDGAkKx6zgmcLzcDLohP9xXGJsV6f4At
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 17 Mar 2022 10:52:14 +0300, Dan Carpenter wrote:

> This case statement doesn't fall through any more so remove the
> fallthrough annotation.
> 
> 

Applied to 5.18/scsi-fixes, thanks!

[1/1] scsi: hisi_sas: remove stray fallthrough annotation
      https://git.kernel.org/mkp/scsi/c/066f4c31945c

-- 
Martin K. Petersen	Oracle Linux Engineering
