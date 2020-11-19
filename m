Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0BD3C388F9
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 07:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EF8F246D4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 07:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Zv4D+rzl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKSHOc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 02:14:32 -0500
Received: from z5.mailgun.us ([104.130.96.5]:41494 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbgKSHOb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Nov 2020 02:14:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605770071; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=XXv1sghWHsOtozF9TjpzQ8BZgyE+fxP4S3fS/+0JJH0=;
 b=Zv4D+rzlwvAbwP4VMMXZVYOjVk3ALudsWb5815CXEa8fmxuFB/TM2PFoAQqGKM4XnbkrDUJT
 /8N/jT7WaiBN9hpyvgG5Je8A3Kk5uNxfwCBo4/JvXVswEwM27pBK/zmnHhbhtftkoAJEPZ+N
 3EFADvwEYqn+GJ0bJdjX1lWyObM=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-east-1.postgun.com with SMTP id
 5fb61b51fa67d9becfd6996c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 19 Nov 2020 07:14:25
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 39411C4346D; Thu, 19 Nov 2020 07:14:24 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 25A96C4346B;
        Thu, 19 Nov 2020 07:14:20 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 19 Nov 2020 15:14:19 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Subject: Re: [PATCH v1] scsi: ufs: Fix race between shutdown and runtime
 resume flow
In-Reply-To: <20201119062916.12931-1-stanley.chu@mediatek.com>
References: <20201119062916.12931-1-stanley.chu@mediatek.com>
Message-ID: <26585f80038d25fc6ee9dddf07e66b93@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-19 14:29, Stanley Chu wrote:
> If UFS host device is in runtime-suspended state while
> UFS shutdown callback is invoked, UFS device shall be
> resumed for register accesses. Currently only UFS local
> runtime resume function will be invoked to wake up the host.
> This is not enough because if someone triggers runtime
> resume from block layer, then race may happen between
> shutdown and runtime resume flow, and finally lead to
> unlocked register access.
> 
> To fix this kind of issues, in ufshcd_shutdown(), use
> pm_runtime_get_sync() instead of resuming UFS device by
> ufshcd_runtime_resume() "internally" to let runtime PM
> framework manage the whole resume flow.
> 
> Fixes: 57d104c153d3 ("ufs: add UFS power management support")
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 80cbce414678..bb16cc04f106 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8941,11 +8941,7 @@ int ufshcd_shutdown(struct ufs_hba *hba)
>  	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
>  		goto out;
> 
> -	if (pm_runtime_suspended(hba->dev)) {
> -		ret = ufshcd_runtime_resume(hba);
> -		if (ret)
> -			goto out;
> -	}
> +	pm_runtime_get_sync(hba->dev);
> 
>  	ret = ufshcd_suspend(hba, UFS_SHUTDOWN_PM);
>  out:
