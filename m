Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6853FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 03:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhKWDwY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 22:52:24 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29286 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230394AbhKWDwX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 22:52:23 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN2P9hO031839;
        Tue, 23 Nov 2021 03:49:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=/efSYQaMY4nVoxBkjSXUQrmGc5jQLWpWCPVh1SJXt7A=;
 b=TOt12q1SptO8ivMrsF0jmWnyuTieb1llw2V5xeECDzOBs9IDWWwRoxIX5rHAiuVKh7Cq
 cvVWcGV6g7OUa5GZy3X5PPyWlabCKnfGIqngvdwQwhzaL/W1Lk1IFNio8wanAsdGluxg
 Rk5UblMTifFmQaxPe+kXEMG83wQ4zl4VfJKzHgi8tHtObSMOpCfcmDphDLl8vg0/k0nv
 NvKJFLYnnciIytJTKP3A2ZKN2nuyf5W/fisJ1UxtocVlmOQRwnfW0k0YOHUUkRZK/ByA
 mPBN82NzxDyiv5ViSlhgUL7Y5wbBZHwymlIEjMzq4SMfMDJnuLEMuTHCovprBc+oJx34 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg461ebs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:49:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AN3l0B5162096;
        Tue, 23 Nov 2021 03:49:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3ceru4g6mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:49:10 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AN3l19s162141;
        Tue, 23 Nov 2021 03:49:10 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3ceru4g6hc-6;
        Tue, 23 Nov 2021 03:49:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Igor Pylypiv <ipylypiv@google.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>
Subject: Re: [PATCH 0/4] small pm80xx cleanups and fixes
Date:   Mon, 22 Nov 2021 22:49:04 -0500
Message-Id: <163763931253.19362.3916479037466030652.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211101232825.2350233-1-ipylypiv@google.com>
References: <20211101232825.2350233-1-ipylypiv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: AoqGuJ3e5KO8MDx7qVCI4af4a0zZCEjk
X-Proofpoint-ORIG-GUID: AoqGuJ3e5KO8MDx7qVCI4af4a0zZCEjk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 1 Nov 2021 16:28:21 -0700, Igor Pylypiv wrote:

> Igor Pylypiv (4):
>   scsi: pm80xx: Apply byte mask for phy id in mpi_phy_start_resp()
>   scsi: pm80xx: Do not check the address-of value for NULL
>   scsi: pm80xx: Update WARN_ON check in pm8001_mpi_build_cmd()
>   scsi: pm80xx: Use bitmap_zalloc() for tags bitmap allocation
> 
> drivers/scsi/pm8001/pm8001_hwi.c  | 28 +++++++---------------------
>  drivers/scsi/pm8001/pm8001_init.c |  4 ++--
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 31 +++++++++----------------------
>  3 files changed, 18 insertions(+), 45 deletions(-)
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[1/4] scsi: pm80xx: Apply byte mask for phy id in mpi_phy_start_resp()
      https://git.kernel.org/mkp/scsi/c/744798fcd2b3
[2/4] scsi: pm80xx: Do not check the address-of value for NULL
      https://git.kernel.org/mkp/scsi/c/60de1a67d66d
[3/4] scsi: pm80xx: Update WARN_ON check in pm8001_mpi_build_cmd()
      https://git.kernel.org/mkp/scsi/c/606c54ae975a
[4/4] scsi: pm80xx: Use bitmap_zalloc() for tags bitmap allocation
      https://git.kernel.org/mkp/scsi/c/853615582d6f

-- 
Martin K. Petersen	Oracle Linux Engineering
