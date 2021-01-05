Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C3BC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E106622581
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbhAEBK3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 20:10:29 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:47393 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbhAEBK2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 20:10:28 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609809008; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=sgPqe4pqEk3ZwVRnrFktXNaNAtez93ZtoXUbpTZWFE4=;
 b=bCsHzS4xoeiDENF0LERMWJPkO9rbSkEjPah+ZER21ulPFf0+2bGnoHxiw5msXocl1oUkQ1l6
 gmyzg+VPSM8hUTlvaNP/cshtVuddUfWMQRWw1I2TkXlv2/alzwjI2zbFFba7y6JDaZs3ZGUB
 q4QqNyo0SKzu4xGDUhfnIXmq4e8=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5ff3bc6f584481b01ba496ce (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 05 Jan 2021 01:10:07
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A72CFC43468; Tue,  5 Jan 2021 01:10:06 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8143FC433C6;
        Tue,  5 Jan 2021 01:10:05 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 Jan 2021 09:10:05 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Subject: Re: [PATCH v2 3/3] scsi: ufs: Let resume callback return -EBUSY after
 ufshcd_shutdown
In-Reply-To: <20201224172010.10701-4-huobean@gmail.com>
References: <20201224172010.10701-1-huobean@gmail.com>
 <20201224172010.10701-4-huobean@gmail.com>
Message-ID: <bf5b8bc409af22f32c4fc5f5de769058@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-25 01:20, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> After ufshcd_shutdown(), both UFS device and UFS LINk are powered off,
> return '0' will mislead the upper PM layer since the device has not 
> been
> successfully resumed yet. This will let pm_runtime_get_sync() caller
> mistakenly believe the device/LINK has been resumed, which leads to
> request processing timeout that was en-queued later.
> 
> To fix this, let ufshcd_system/runtimie_resume() return -EBUSY in case 
> of
> hba->is_powered == false.

This change won't work as you expect...

During/after shutdown, for UFS's case only,
pm_runtime_get_sync(hba->dev) will most likely return 0,
because it is already RUNTIME_ACTIVE, pm_runtime_get_sync()
will directly return 0... meaning your change won't even be
exercised.

Check Stanley's change -
https://lore.kernel.org/patchwork/patch/1341389/

Can Guo.

> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e221add25a7e..e1bcac51c01f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8950,14 +8950,16 @@ int ufshcd_system_resume(struct ufs_hba *hba)
>  		return -EINVAL;
>  	}
> 
> -	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
> +	if (!hba->is_powered || pm_runtime_suspended(hba->dev)) {
>  		/*
>  		 * Let the runtime resume take care of resuming
>  		 * if runtime suspended.
>  		 */
> +		ret = -EBUSY;
>  		goto out;
> -	else
> +	} else {
>  		ret = ufshcd_resume(hba, UFS_SYSTEM_PM);
> +	}
>  out:
>  	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
>  		ktime_to_us(ktime_sub(ktime_get(), start)),
> @@ -9026,10 +9028,12 @@ int ufshcd_runtime_resume(struct ufs_hba *hba)
>  	if (!hba)
>  		return -EINVAL;
> 
> -	if (!hba->is_powered)
> +	if (!hba->is_powered) {
> +		ret = -EBUSY;
>  		goto out;
> -	else
> +	} else {
>  		ret = ufshcd_resume(hba, UFS_RUNTIME_PM);
> +	}
>  out:
>  	trace_ufshcd_runtime_resume(dev_name(hba->dev), ret,
>  		ktime_to_us(ktime_sub(ktime_get(), start)),
