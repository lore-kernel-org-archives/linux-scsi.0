Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A313AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 03:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhKWDwW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 22:52:22 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:27162 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229764AbhKWDwV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 22:52:21 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN2P9hK031839;
        Tue, 23 Nov 2021 03:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=TAGONmuU75SBPyXOZJjXKpE/HT60JTTjgZFqGOQWnZg=;
 b=iWlHH5v2g8Dj2GJ3ZUvHuKtTSHEe7VsptxEZBBIEmZ7ElWLbnlrLu3Z9MWlYerDXbJiC
 gTsD/CnSsQiWziV5960/BQnwxswfoV/UohBmSrCcV3I5NSlvvJu/LWD/5g0OjrXMqgi6
 6+HcTxHrzYqfafmDhdfuJhtp9KhIwb/no7pjhqF0v34reJ42GjAaToVjMXDS24KVNQ3n
 C490+K3GNI8L/9v56KRs4Yog/dF3A3cewZnZTCm6vChOUu2ZnWwbhuC6ec1fBoa+J0++
 j1bDIZVyvobSE39iv3JKFz3bvICIw16uyZGdQidIJhvhH/1uP4WJ520mYs1fvSm9rOi1 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg461ebrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:49:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AN3l1P4162313;
        Tue, 23 Nov 2021 03:49:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3ceru4g6jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:49:08 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AN3l19m162141;
        Tue, 23 Nov 2021 03:49:07 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3ceru4g6hc-3;
        Tue, 23 Nov 2021 03:49:07 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Changyuan Lyu <changyuanl@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        kernel test robot <lkp@intel.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] This patchset adds tracepoints to pm80xx
Date:   Mon, 22 Nov 2021 22:49:01 -0500
Message-Id: <163763931254.19362.18182748715113193399.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211115215750.131696-1-changyuanl@google.com>
References: <20211115215750.131696-1-changyuanl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: ELo5dIQZSN1tVXPJNWyJZ-xm_j0iMWWI
X-Proofpoint-ORIG-GUID: ELo5dIQZSN1tVXPJNWyJZ-xm_j0iMWWI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 15 Nov 2021 13:57:48 -0800, Changyuan Lyu wrote:

> v2: added le32_to_cpu() when calling trace_pm80xx_mpi_build_cmd()
> to eliminate the incorrect type error in patch `scsi: pm80xx: Add
> pm80xx_mpi_build_cmd tracepoint`.
> Reported-by: kernel test robot <lkp@intel.com>
> 
> Changyuan Lyu (2):
>   scsi: pm80xx: Add tracepoints
>   scsi: pm80xx: Add pm80xx_mpi_build_cmd tracepoint
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[1/2] scsi: pm80xx: Add tracepoints
      https://git.kernel.org/mkp/scsi/c/8ceddda38d42
[2/2] scsi: pm80xx: Add pm80xx_mpi_build_cmd tracepoint
      https://git.kernel.org/mkp/scsi/c/0137b129f215

-- 
Martin K. Petersen	Oracle Linux Engineering
