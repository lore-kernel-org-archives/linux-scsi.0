Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8169EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 03:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiF1DZ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 23:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbiF1DZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 23:25:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3937324F3D
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 20:25:07 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S19Mmp002132;
        Tue, 28 Jun 2022 03:25:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=PsOaPXJY8y1iVmjiwyDNPWvg6cXLIzhbMAnvNFI/WCI=;
 b=VNCB4PbeXPnIB8o1wV9ntdphuIkARtf6xUHwS0Hkl/O3/ElG1D62MLm4aEIeSa2n6cTy
 wUbbL2GhY6yHzVMH2MxiBNYsN32bUnDNdumdzbUX6W+JajD8LCXsokI5XiCRoKeYqUYt
 a1q1S89EUXs3gyLPacGx5K5wtLHZ3+jx1v1taq/+JHbA8zf2NmeB9GzVuuQOGGBBQEfB
 iL2bl0j4Wi9QesvvG/4BdLeBPzS5Ncr9k+glVJtVUe1umfZj793ULX9BooMbf141doT9
 qT3iHhucUjdlQo3dsR+EBVYYi8CbFhVZL4H8TwAGAX/QWc6xfbXyfN12a3lW5Lp0tt3O gA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gws52cuq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:25:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S3F1LH002385;
        Tue, 28 Jun 2022 03:25:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7jjna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:25:01 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25S3NvqK016584;
        Tue, 28 Jun 2022 03:25:01 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7jjkg-12;
        Tue, 28 Jun 2022 03:25:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Remove flush_scheduled_work() call.
Date:   Mon, 27 Jun 2022 23:24:50 -0400
Message-Id: <165638665787.7726.9538341545727262642.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <f3b97c7c-1094-4e46-20d8-4321716d6f3f@I-love.SAKURA.ne.jp>
References: <f3b97c7c-1094-4e46-20d8-4321716d6f3f@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Nhu6_YNrqU_dcDb02OT_5gpzfTviOLrJ
X-Proofpoint-GUID: Nhu6_YNrqU_dcDb02OT_5gpzfTviOLrJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 9 Jun 2022 22:26:48 +0900, Tetsuo Handa wrote:

> It seems to me that mpt3sas driver is using dedicated workqueues and
> is not calling schedule{,_delayed}_work{,_on}(). Then, there will be
> no work to flush using flush_scheduled_work().
> 
> 

Applied to 5.20/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Remove flush_scheduled_work() call.
      https://git.kernel.org/mkp/scsi/c/90c3ca3f247d

-- 
Martin K. Petersen	Oracle Linux Engineering
