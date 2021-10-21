Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7CBC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00F1A60FED
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhJUDpr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:45:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46730 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230385AbhJUDpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:17 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L2DQr6019148;
        Thu, 21 Oct 2021 03:42:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=fjNmhOg8qZQSFuLEA/RFnSzsPz2Vr1nz1A8TUEHcZIY=;
 b=ED1rQRxh1JXpDxXtUTEdW/7oGtT5WdJg7KV9U9IczzRJ/kYsXcxRUSNDrpy61+Ss5rYv
 0bAUzbmPUYS2NuYe0Br3LRSXRIv4hNLb0+sVFSPfjbsQ0kvvxUsgtBz77J2NNqjDLvI1
 1O8hHB0MfZsuinkiN+R/AtADkaC7Aw2rv9/K5gevH3PsmzQ3oxXyTo+d9cTmrr4MAwvW
 6OLArQ+xF75J11W9Lt41DKPdky7YkeDKjcOAiVIRjXjJboM3PYMced5fffAOBiQheu2W
 RoZwJAxAyvxbojeMZq9tZjzCMcbNf9nJ9L1uw/1u87r4xokSLHWWZ9dEOdMRQgcHIvnX OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqypjhth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:42:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esj0078017;
        Thu, 21 Oct 2021 03:42:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:42:57 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu7o082116;
        Thu, 21 Oct 2021 03:42:57 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-3;
        Thu, 21 Oct 2021 03:42:57 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/3] Rework SCSI runtime power management support
Date:   Wed, 20 Oct 2021 23:42:34 -0400
Message-Id: <163478764102.7011.16371251494754061812.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006215453.3318929-1-bvanassche@acm.org>
References: <20211006215453.3318929-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: c8ZkQjj32Xo_aWR0zhnYWbYBqQ8joDB3
X-Proofpoint-GUID: c8ZkQjj32Xo_aWR0zhnYWbYBqQ8joDB3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 6 Oct 2021 14:54:50 -0700, Bart Van Assche wrote:

> For the UFS driver it is undesired that the SCSI power management core
> activates runtime suspended devices during system resume. This patch
> series leaves SCSI devices runtime suspended during system resume if
> these were runtime suspended before the system was suspended. Please
> consider this patch series for Linux kernel v5.16.
> 
> Thanks,
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/3] scsi: pm: Rely on the device driver core for async power management
      https://git.kernel.org/mkp/scsi/c/a19a93e4c6a9
[2/3] scsi: sd: Rename sd_resume() into sd_resume_system()
      https://git.kernel.org/mkp/scsi/c/1c9575326a4a
[3/3] scsi: pm: Only runtime resume if necessary
      https://git.kernel.org/mkp/scsi/c/9131bff6a9f1

-- 
Martin K. Petersen	Oracle Linux Engineering
