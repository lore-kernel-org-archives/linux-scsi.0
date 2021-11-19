Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CB9C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF24161AD2
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhKSEUH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:20:07 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24086 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233983AbhKSEUG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:20:06 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ1jgjW019269;
        Fri, 19 Nov 2021 04:16:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=AkNrTnsK4Nx5aHqL4a0yL4DcZ5lqLWUiyfR978RpBC4=;
 b=XolRhgkr4oVeO74yqlfPeMHNzcHMeIBGVNce7IB6mw0ol8SaVyy2mLNNiRkB9OTpHu0d
 mjLFSSq9TFSyxizYt2t3tTx/tof3L+YAgEKLbB43BilWMVv07nSxhEayjJTVCDpOdRPw
 9UWqvt4R07p8XALqLyX8VOBBrfLp8Pqvu3B3yr0agHdTg7bWBJqLfRURa+qf9wxmRFSu
 7M555SDcr0G5QFeAtPTkVlgdXoIQ9QwJB83oC+ondicm3jghvfkMKC04IOiPFd6fB0sX
 gHxXE2Bdu2CsfJg6MqdHHsQ84Bbhlynr7iPeH0htimfpV8mZVVTmZlB7C4t3Lh/7f92R Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd2w93kbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FBms020355;
        Fri, 19 Nov 2021 04:16:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7c23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:52 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4GiwU024731;
        Fri, 19 Nov 2021 04:16:51 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-8;
        Fri, 19 Nov 2021 04:16:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        Bean Huo <huobean@gmail.com>, tomas.winkler@intel.com,
        jejb@linux.ibm.com, bvanassche@acm.org, avri.altman@wdc.com,
        cang@codeaurora.org, daejun7.park@samsung.com, beanhuo@micron.com,
        alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: ufs: ufshpb: Fix sparse warning in ufshpb_set_hpb_read_to_upiu()
Date:   Thu, 18 Nov 2021 23:16:37 -0500
Message-Id: <163729506336.21244.4172261199164965765.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211111222452.384089-1-huobean@gmail.com>
References: <20211111222452.384089-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: pdgvvIzyWJs1R2GKjOqHFoYgLqGaqVRZ
X-Proofpoint-ORIG-GUID: pdgvvIzyWJs1R2GKjOqHFoYgLqGaqVRZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 11 Nov 2021 23:24:52 +0100, Bean Huo wrote:

> From: Bean Huo <beanhuo@micron.com>
> 
> This patch is to fix the following sparse warnings in ufshpb_set_hpb_read_to_upiu():
> 
> sparse warnings: (new ones prefixed by >>)
> drivers/scsi/ufs/ufshpb.c:335:27: sparse: sparse: cast from restricted __be64
> drivers/scsi/ufs/ufshpb.c:335:25: sparse: expected restricted __be64 [usertype] ppn_tmp
> drivers/scsi/ufs/ufshpb.c:335:25: sparse: got unsigned long long [usertype]
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: ufs: ufshpb: Fix sparse warning in ufshpb_set_hpb_read_to_upiu()
      https://git.kernel.org/mkp/scsi/c/73185a13773a

-- 
Martin K. Petersen	Oracle Linux Engineering
