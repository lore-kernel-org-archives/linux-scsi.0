Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B72BC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 04:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhLNElL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Dec 2021 23:41:11 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39472 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229536AbhLNElD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Dec 2021 23:41:03 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE2B8I8004563;
        Tue, 14 Dec 2021 04:40:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=ztXzYuxhrccn9qGmRQ7W/eIYD2fEIFQBQpyj5B9GLuE=;
 b=QwSxVKLLF8m0pC50hf4wFBxdD7YglH7X1bhCGG6vEfQeKZevbCu6tYRL5m+JKSnnmLc1
 jFVieZeM/p9nVMenJ2KY+zJzsgJOTRkf3mEmp4XsZsil6L3FLm97IidhogFb7N8mpmzN
 gNAm2EFBFtkHC2OC8d6sCnOhGoFPEKnHv9yqzhnZOGfFO0p0tlXYGKhSYYsw6OSHEIes
 hP98Va/LprbabL6nuqhHKePX/HockmPOijalrY/9PXrXBhP8qjIrgRARrgni+IcDN0PJ
 uVfj0ClWXzUhnmoBL4v4udkJifXwIPYFcONK+1KHgMmxELadhq0Y4IkaWWKVy2anPR/H xA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3mrtpnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 04:40:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE4ZXMD032347;
        Tue, 14 Dec 2021 04:40:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3cvh3wp5ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 04:40:54 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1BE4aj98034843;
        Tue, 14 Dec 2021 04:40:54 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3cvh3wp5ab-2;
        Tue, 14 Dec 2021 04:40:54 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v4 00/17] UFS patches for kernel v5.17
Date:   Mon, 13 Dec 2021 23:40:48 -0500
Message-Id: <163945683293.11687.10954614360616312364.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: F7oXXJgmAnjGzi-7HF1novqv429IYC-r
X-Proofpoint-GUID: F7oXXJgmAnjGzi-7HF1novqv429IYC-r
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 3 Dec 2021 15:19:33 -0800, Bart Van Assche wrote:

> This patch series includes the following changes:
> - Fix a deadlock in the UFS error handler.
> - Add polling support in the UFS driver.
> - Several smaller fixes for the UFS driver.
> 
> Please consider these UFS driver kernel patches for kernel v5.17.
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[01/17] scsi: core: Fix scsi_device_max_queue_depth()
        https://git.kernel.org/mkp/scsi/c/4bc3bffc1a88
[02/17] scsi: ufs: Rename a function argument
        https://git.kernel.org/mkp/scsi/c/b427609e11ee
[03/17] scsi: ufs: Remove is_rpmb_wlun()
        https://git.kernel.org/mkp/scsi/c/d656dc9b0b79
[04/17] scsi: ufs: Remove the sdev_rpmb member
        https://git.kernel.org/mkp/scsi/c/59830c095cf0
[05/17] scsi: ufs: Remove dead code
        https://git.kernel.org/mkp/scsi/c/d77ea8226b3b
[06/17] scsi: ufs: Fix race conditions related to driver data
        https://git.kernel.org/mkp/scsi/c/21ad0e49085d
[07/17] scsi: ufs: Remove ufshcd_any_tag_in_use()
        https://git.kernel.org/mkp/scsi/c/bd0b35383193
[08/17] scsi: ufs: Rework ufshcd_change_queue_depth()
        https://git.kernel.org/mkp/scsi/c/fc21da8a840a
[09/17] scsi: ufs: Fix a deadlock in the error handler
        https://git.kernel.org/mkp/scsi/c/945c3cca05d7
[10/17] scsi: ufs: Remove hba->cmd_queue
        https://git.kernel.org/mkp/scsi/c/511a083b8b6b
[11/17] scsi: ufs: Remove the 'update_scaling' local variable
        https://git.kernel.org/mkp/scsi/c/3eb9dcc027e2
[12/17] scsi: ufs: Introduce ufshcd_release_scsi_cmd()
        https://git.kernel.org/mkp/scsi/c/6f8dafdee6ae
[13/17] scsi: ufs: Improve SCSI abort handling further
        https://git.kernel.org/mkp/scsi/c/1fbaa02dfd05
[14/17] scsi: ufs: Fix a kernel crash during shutdown
        https://git.kernel.org/mkp/scsi/c/3489c34bd02b
[15/17] scsi: ufs: Stop using the clock scaling lock in the error handler
        https://git.kernel.org/mkp/scsi/c/5675c381ea51
[16/17] scsi: ufs: Optimize the command queueing code
        https://git.kernel.org/mkp/scsi/c/8d077ede48c1
[17/17] scsi: ufs: Implement polling support
        https://git.kernel.org/mkp/scsi/c/eaab9b573054

-- 
Martin K. Petersen	Oracle Linux Engineering
