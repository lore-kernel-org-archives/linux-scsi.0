Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50FFC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 07:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0A6D61242
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 07:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbhIOHHX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 03:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhIOHHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 03:07:22 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3035AC061574;
        Wed, 15 Sep 2021 00:06:04 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id o66so258112oib.11;
        Wed, 15 Sep 2021 00:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2USaILXqK6MThCl7dEp86E3RAmWG1XHlCkEm3rGpI1o=;
        b=iO8wUk17t3ocaKuDFVV5ohZySGwK0te4wtQGgFjH5ugx40QolhHICUUgYwuWsJDQ2f
         E3E81GwN+Yigm4bGQsOoCrIlS+MvKx3PdK0q6/Dt18Q7M5FTDk9SVdKOcBqZf4BwCY64
         equxnrzJoixjAai8Rp19DNE2TC8dT4UNeLUhuQq1HWxI11VlwGbmCrMo6Sx/NI9CAvpJ
         h1g1Isu+oigk1+6Xmi5KPcnSj6HLftUdVJ1uzu+s/oE+IN2Uyx8WFaoK4Wy0EOyHW5YH
         sZ5AEbXCrC6JHdf2Mb1xgRK0o4L945bQRzpNFjIeHh9tyjIHa4B2Al6l0o3JsrdXvDFR
         l5Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=2USaILXqK6MThCl7dEp86E3RAmWG1XHlCkEm3rGpI1o=;
        b=OwuHorNSVtd519J2zJvfDvLgwjwGLWga2lJRKqqd5MLX21WplR4te+tJLEaYw2lPNy
         UvKd0bKXMw719mUAKLPBre3qGJpRqbXi8rb4C/k4Uv+BNVOHGyW6fFsPMjdT58QOtybC
         tnsS7LCaoZRlnfi0tVpk6SrqpNa3gjTFPMFIJlf8DaOzLoqb3TU2EdJMEnfw5etpYroK
         mUyufWzzDrBxhe7ZhfDGLVHBeOIF1KQi8EtPupLAk9hgFNg0yGI1WUxHNHACeAxZrmh4
         raA6iHMVL9W0OiZCv+LFk86H9Tg5v/ihCpetKFB6IK/mOth5/HbwcwkoyoYvJludCoPE
         zuUw==
X-Gm-Message-State: AOAM530b/06UlGyTwdA3bJ5LXkw2a5V9OILnnCjY+4X2iwE76frJBaVE
        DB9ws+vThBVbyBUJ316tB+r9HfNl8SU=
X-Google-Smtp-Source: ABdhPJwT2uJyH6/RIPf/pbsoI/5hyJSYOYJJj5RhJ57KC1r9+cwqyitOs4T1ZEiWdyDcDWM+/Z07Eg==
X-Received: by 2002:a05:6808:11c3:: with SMTP id p3mr4280329oiv.23.1631689563519;
        Wed, 15 Sep 2021 00:06:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j14sm3069599oor.33.2021.09.15.00.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 00:06:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Sep 2021 00:06:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v7 2/2] scsi: ufs: Add temperature notification exception
 handling
Message-ID: <20210915070601.GB4174921@roeck-us.net>
References: <20210915060407.40-1-avri.altman@wdc.com>
 <20210915060407.40-3-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210915060407.40-3-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 15, 2021 at 09:04:07AM +0300, Avri Altman wrote:
> The device may notify the host of an extreme temperature by using the
> exception event mechanism. The exception can be raised when the device’s
> Tcase temperature is either too high or too low.
> 
> It is essentially up to the platform to decide what further actions need
> to be taken. leave a placeholder for a designated vop for that.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/scsi/ufs/ufs-hwmon.c | 12 ++++++++++++
>  drivers/scsi/ufs/ufshcd.c    | 21 +++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h    |  2 ++
>  3 files changed, 35 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-hwmon.c b/drivers/scsi/ufs/ufs-hwmon.c
> index 33b66736aaa4..74855491dc8f 100644
> --- a/drivers/scsi/ufs/ufs-hwmon.c
> +++ b/drivers/scsi/ufs/ufs-hwmon.c
> @@ -196,3 +196,15 @@ void ufs_hwmon_remove(struct ufs_hba *hba)
>  	hba->hwmon_device = NULL;
>  	kfree(data);
>  }
> +
> +void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask)
> +{
> +	if (!hba->hwmon_device)
> +		return;
> +
> +	if (ee_mask & MASK_EE_TOO_HIGH_TEMP)
> +		hwmon_notify_event(hba->hwmon_device, hwmon_temp, hwmon_temp_max_alarm, 0);
> +
> +	if (ee_mask & MASK_EE_TOO_LOW_TEMP)
> +		hwmon_notify_event(hba->hwmon_device, hwmon_temp, hwmon_temp_min_alarm, 0);
> +}
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ce22340024ce..debef631c89a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5642,6 +5642,24 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
>  				__func__, err);
>  }
>  
> +static void ufshcd_temp_exception_event_handler(struct ufs_hba *hba, u16 status)
> +{
> +	u32 value;
> +
> +	if (ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +				QUERY_ATTR_IDN_CASE_ROUGH_TEMP, 0, 0, &value))
> +		return;
> +
> +	dev_info(hba->dev, "exception Tcase %d\n", value - 80);
> +
> +	ufs_hwmon_notify_event(hba, status & MASK_EE_URGENT_TEMP);
> +
> +	/*
> +	 * A placeholder for the platform vendors to add whatever additional
> +	 * steps required
> +	 */
> +}
> +
>  static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
>  {
>  	u8 index;
> @@ -5821,6 +5839,9 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
>  	if (status & hba->ee_drv_mask & MASK_EE_URGENT_BKOPS)
>  		ufshcd_bkops_exception_event_handler(hba);
>  
> +	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
> +		ufshcd_temp_exception_event_handler(hba, status);
> +
>  	ufs_debugfs_exception_event(hba, status);
>  out:
>  	ufshcd_scsi_unblock_requests(hba);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 021c858955af..92d05329de68 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1062,9 +1062,11 @@ static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
>  #ifdef CONFIG_SCSI_UFS_HWMON
>  void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
>  void ufs_hwmon_remove(struct ufs_hba *hba);
> +void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask);
>  #else
>  static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
>  static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
> +static inline void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask) {}
>  #endif
>  
>  #ifdef CONFIG_PM
> -- 
> 2.17.1
> 
