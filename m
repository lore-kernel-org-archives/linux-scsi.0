Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679BEC4332D
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 19:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2229622510
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 19:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbhADT1J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 14:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbhADT1I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 14:27:08 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A272C061793;
        Mon,  4 Jan 2021 11:26:28 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id i24so28534334edj.8;
        Mon, 04 Jan 2021 11:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eCm0hfQBe7/fXrzS9sno54nypMrLNw0Aq9XOyj8UFeE=;
        b=K7dHwLv7dQrgRPlljPBHm6LKdmnGjw+3C0DyRXHEZ70aa+HO66zVApdI/ZOZZvdlWq
         WceOBx19io7565NS0LZExWcWmBjKizh2V47w/x96lvBFNy36KP8x23ayg93jpCn0DrFM
         vTQIGAtDjuDDzjULMlZoJGCwPywhP5n6oBzkEeLnzhxhtq8csirMB/XsGIUKoxwN8e1z
         yUhN4E8GTqjF0k1B3woaTCEMR10NBtCJPrqzAM/9PVvfJ725T+nebmER+lM+/xKjI+4h
         zlKMNKPDXVAMj+5udXCsX6WDFhpS4FYRJ28l7UZXKLTkVnUqzjbD4OJOGNq/UHmrR6KO
         Ly5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eCm0hfQBe7/fXrzS9sno54nypMrLNw0Aq9XOyj8UFeE=;
        b=saB44azkKEBwAOgk1yTP3JPmdQalXuXFsLkv4XqDvqL2pCS0kFprx5rlN4Nc6g9xGr
         XyrzGNOsL38TkxlK7m+o4Ot/aKF8BqWBNqctpif8waXf20Nr0Moyce6pzsgWJklPCU0p
         PqApNQJqumJeiQn2rZk/gT9PtbAPbjL7FQ6ERsHB1Y0tAEWwWEfQUodD0Ym0HT7rLqLw
         rV+5M5lXNAvQY156RWiQWh0X613r8w96LHjRpAyQyVNyQgQLtSW0q4wctevR9dSFYg+5
         Yo0F50MJ6ghO+je5Ixp375wmbAtNVouMVi3nbSMQT5Q6fkzsVPKSpX8feZyoVResD4yj
         Mo7A==
X-Gm-Message-State: AOAM531+VIPhBbNMH1duIQsGkk8VUdEJqsz/o10BKOrBgFybdU3Eet45
        Wcfc4yPRik+gBTluoeg0iPM=
X-Google-Smtp-Source: ABdhPJz/GRF1lYQDWKCehWb3I9LczXRsd3DjuPhxE0O1y/AhQhqR64mV2c+aO9bF+qcxSHEzPYKf4w==
X-Received: by 2002:a50:b223:: with SMTP id o32mr73091919edd.79.1609788387225;
        Mon, 04 Jan 2021 11:26:27 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id ld2sm23922021ejb.73.2021.01.04.11.26.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Jan 2021 11:26:26 -0800 (PST)
Message-ID: <bcd28a2ff03797bb97f098f709e49d09a042d8dc.camel@gmail.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: Let resume callback return -EBUSY
 after ufshcd_shutdown
From:   Bean Huo <huobean@gmail.com>
To:     rjw@rjwysocki.net
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net, alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Date:   Mon, 04 Jan 2021 20:26:25 +0100
In-Reply-To: <20201224172010.10701-4-huobean@gmail.com>
References: <20201224172010.10701-1-huobean@gmail.com>
         <20201224172010.10701-4-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rafael

Would you please help to review this patch assoociated with PM resume
callback implementation?
 
Original code that ufshcd_system/runtime_resume returns '0' in case
resume failed due to the UFS device and UFS LINk are powered off(hba-
>is_powered == false).

In the patch 2/3 Add handling of the return value of
pm_runtime_get_sync() is to fix race exists between shudown path and
device access through sysfs node.



Thanks,
Bean


On Thu, 2020-12-24 at 18:20 +0100, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> After ufshcd_shutdown(), both UFS device and UFS LINk are powered
> off,
> return '0' will mislead the upper PM layer since the device has not
> been
> successfully resumed yet. This will let pm_runtime_get_sync() caller
> mistakenly believe the device/LINK has been resumed, which leads to
> request processing timeout that was en-queued later.
> 
> To fix this, let ufshcd_system/runtimie_resume() return -EBUSY in
> case of
> hba->is_powered == false.
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
> @@ -9026,10 +9028,12 @@ int ufshcd_runtime_resume(struct ufs_hba
> *hba)
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

