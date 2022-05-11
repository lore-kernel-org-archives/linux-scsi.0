Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A05EFC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 11 May 2022 02:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiEKCrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 22:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242947AbiEKCit (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 22:38:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6FD20EE3B
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 19:38:48 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ALxZSU010445;
        Wed, 11 May 2022 02:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=s1nMnKToSY7NvSSRyAoUh0vSoNNnOTxnggin+c9aFdE=;
 b=rtPfXj00YYjUFwbzs1Qu0Yv/DmWkTHM0mG2Gzf2hVI0S5gJNWD2ZUZY5cK1Cxjtz99cv
 jJKpQzIcKAE4r0GgC1amb07Aet68C19rm6a+v7zXqf/aSYJj3IYBVJyviT8Mk4oj9KNo
 sTAEHRsLCgKVYLp7Rr9+qaT5bU9dn8/RLCeaojm4RT1bmruoY5G2YO+Tb2dRnFTvsLIx
 xHMS9OHyPJnTpU2CtehpKltxdQIYACYt7yPFFFyJ3iQN70L2Z9glBW4Pk5Myus3xEOik
 8mSkTjZCbMB+V/yivL20WFJ9JrVoPaqYenwGsk1LVExEBjHydIWy7W8jfxIj/m4iiAzj Tg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwf6c8873-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:38:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24B2KM4I022209;
        Wed, 11 May 2022 02:38:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fwf73hks1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:38:38 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24B2cblW026670;
        Wed, 11 May 2022 02:38:37 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fwf73hkrn-1;
        Wed, 11 May 2022 02:38:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kashyap.desai@broadcom.com, prayas.patel@broadcom.com,
        sreekanth.reddy@broadcom.com, hch@lst.de, hare@suse.de,
        sathya.prakash@broadcom.com, bvanassche@acm.org,
        chandrakanth.patil@broadcom.com, himanshu.madhani@oracle.com
Subject: Re: [PATCH v7 0/8] mpi3mr: add BSG interface support for controller management
Date:   Tue, 10 May 2022 22:38:36 -0400
Message-Id: <165223670081.31118.17973833689115824357.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220429211641.642010-1-sumit.saxena@broadcom.com>
References: <20220429211641.642010-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: mgNPDEK8X9TkXUSx4XPKRTZvOFGFRvAK
X-Proofpoint-GUID: mgNPDEK8X9TkXUSx4XPKRTZvOFGFRvAK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 29 Apr 2022 17:16:33 -0400, Sumit Saxena wrote:

> This patchset adds BSG interface support for controller
> management. BSG layer facilitates communication/data exchange
> between application and driver/firmware through BSG device node.
> 
> v7:
> -Fix build errors reported during x86_64 allmodconfig along with
>  some spaces to tabs conversions.
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/8] mpi3mr: Add bsg device support
      https://git.kernel.org/mkp/scsi/c/4268fa751365
[2/8] mpi3mr: Add support for driver commands
      https://git.kernel.org/mkp/scsi/c/f5e6d5a34376
[3/8] mpi3mr: Move data structures/definitions from MPI headers to uapi header
      https://git.kernel.org/mkp/scsi/c/f3de4706c1e0
[4/8] mpi3mr: Add support for MPT commands
      https://git.kernel.org/mkp/scsi/c/506bc1a0d6ba
[5/8] mpi3mr: Add support for PEL commands
      https://git.kernel.org/mkp/scsi/c/43ca11005098
[6/8] mpi3mr: Expose adapter state to sysfs
      https://git.kernel.org/mkp/scsi/c/986d6bad2103
[7/8] mpi3mr: Add support for NVMe passthrough
      https://git.kernel.org/mkp/scsi/c/7dbd0dd8cde3
[8/8] mpi3mr: Update driver version to 8.0.0.69.0
      https://git.kernel.org/mkp/scsi/c/f304d35e5995

-- 
Martin K. Petersen	Oracle Linux Engineering
