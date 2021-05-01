Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54873C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  1 May 2021 00:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2823B61405
	for <linux-scsi@archiver.kernel.org>; Sat,  1 May 2021 00:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhEAA14 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Apr 2021 20:27:56 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:36110 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbhEAA1z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2021 20:27:55 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 6428229809;
        Fri, 30 Apr 2021 20:27:03 -0400 (EDT)
Date:   Sat, 1 May 2021 10:27:16 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
cc:     willy@infradead.org, hare@suse.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] advansys: Remove redundant assignment to err and
 n_q_required
In-Reply-To: <1619774728-120808-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Message-ID: <516aeebe-f93-52e3-c554-bcb725bcf4dd@nippy.intranet>
References: <1619774728-120808-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 30 Apr 2021, Jiapeng Chong wrote:

> Variable err and n_q_required is set to '-ENOMEM' and '1', but they are
> either overwritten or unused later on, so these are redundant assignments
> that can be removed.
> 
> Clean up the following clang-analyzer warning:
> 
> drivers/scsi/advansys.c:11235:2: warning: Value stored to 'err' is never
> read [clang-analyzer-deadcode.DeadStores].
> 
> drivers/scsi/advansys.c:8091:2: warning: Value stored to 'n_q_required'
> is never read [clang-analyzer-deadcode.DeadStores].
> 
> drivers/scsi/advansys.c:11484:2: warning: Value stored to 'err' is never
> read [clang-analyzer-deadcode.DeadStores].
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/scsi/advansys.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 800052f..f9969d4 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -8088,7 +8088,6 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
>  	sta = 0;
>  	target_ix = scsiq->q2.target_ix;
>  	tid_no = ASC_TIX_TO_TID(target_ix);
> -	n_q_required = 1;
>  	if (scsiq->cdbptr[0] == REQUEST_SENSE) {
>  		if ((asc_dvc->init_sdtr & scsiq->q1.target_id) != 0) {
>  			asc_dvc->sdtr_done &= ~scsiq->q1.target_id;
> @@ -11232,7 +11231,6 @@ static int advansys_vlb_probe(struct device *dev, unsigned int id)
>  	if (AscGetChipVersion(iop_base, ASC_IS_VL) > ASC_CHIP_MAX_VER_VL)
>  		goto release_region;
>  
> -	err = -ENOMEM;
>  	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
>  	if (!shost)
>  		goto release_region;

No, the correct way to resolve that particular clang warning is,

  free_host:
         scsi_host_put(shost);
  release_region:
         release_region(iop_base, ASC_IOADR_GAP);
-        return -ENODEV;
+        return err;
 }

> @@ -11457,7 +11455,6 @@ static int advansys_pci_probe(struct pci_dev *pdev,
>  
>  	ioport = pci_resource_start(pdev, 0);
>  
> -	err = -ENOMEM;
>  	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
>  	if (!shost)
>  		goto release_region;
> 

No, that would be a behavioural change for the error path.

Moreover, the clang warning you claimed for line 11484 appears to be bogus 
with regard to mainline code. You may want to check your checker.
