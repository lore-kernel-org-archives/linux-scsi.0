Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F48C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 15:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D606101B
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 15:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhILP5J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 11:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhILP5I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Sep 2021 11:57:08 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E150C061574;
        Sun, 12 Sep 2021 08:55:54 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id i3-20020a056830210300b0051af5666070so9863510otc.4;
        Sun, 12 Sep 2021 08:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gkFfv9CT7s4mw1MdJMwa+I2vDXO1SHGa8wxdgOd7jr4=;
        b=lQo8XSTR1G4SyEkWhYczm/pSxyknMAgPLMA7paj4a+TPnjGGtIb8WwZmj6VuZczKND
         rk/0sTiLfARQ0I6raeGfR/HRVTANACWNL7oVeBvyVKrg0934/tNHvQ1WHC7/O0k+VrUR
         OCM7ahRyvSUeWTmLHdMUcqjpfKa+6hWfSpjptom2S9EbAlzjYYmnOLKoTyAlBZbQMPjo
         wVUCydRNiEHtVqJXajo0oHmuWOvuUKBpBadzT7bdspsj/R5F6wd1QOZ0zW4nbpSRly5v
         KX6n9KDENqQIAjpRAMBxr8NiW8GX+8ODEmVK+RjgoBNY8YO4PflXjqEPFXXy2Aw0xRfV
         VqJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gkFfv9CT7s4mw1MdJMwa+I2vDXO1SHGa8wxdgOd7jr4=;
        b=iu1Y8K9Dr6eZgnVGGjsQSWmomllLvQCr+8wVDQc5NGGMhpuewgkWaTFZcaA4eANAuj
         SSlmKAbq/wEHjR6H0WdNN8hGizKX5qX8URi+vrpEptt9harMCbKhjS3f39aeZJ11BT5N
         Hr18wuOzMFbhb8PhpUP8kRK3RnPIm006OzzR8zV14EpS/ZkRbjO6GsB4Z2TZwBRj5BZT
         bq89meuKP6mdlwszW5PegYt86+9+a3nH4gzuy5E9DwDUY7tvgnMfvQ4256d+x0HR70kL
         m4FN+TVY4rJ1VDMdCWanS1Eb7oW3tH4vFmWj/cAmdgYzT+aPtD5udBErLWJXmuxK7jl4
         ZV+A==
X-Gm-Message-State: AOAM530QqbtKlZ0onuW35jM2HfkKvC7ztKQrlolHaMpuMNH5A8Dzf2LS
        Aq+Z7gKrURnRfSPE7yihM4k=
X-Google-Smtp-Source: ABdhPJy6oPJJSPa1/JijRz9TJmBp5EseRGileTXbcWAd3fHu4uWJxdVJutTEC5/ViBnLbh/P9ogwcw==
X-Received: by 2002:a05:6830:1184:: with SMTP id u4mr6536947otq.55.1631462153806;
        Sun, 12 Sep 2021 08:55:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k1sm1238724otr.43.2021.09.12.08.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 08:55:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v3 2/2] scsi: ufs: Add temperature notification exception
 handling
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210912131919.12962-1-avri.altman@wdc.com>
 <20210912131919.12962-3-avri.altman@wdc.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <3dddb2a8-a599-2061-08e6-b4c5ca865cb9@roeck-us.net>
Date:   Sun, 12 Sep 2021 08:55:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210912131919.12962-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/21 6:19 AM, Avri Altman wrote:
> The device may notify the host of an extreme temperature by using the
> exception event mechanism. The exception can be raised when the device’s
> Tcase temperature is either too high or too low.
> 
> It is essentially up to the platform to decide what further actions need
> to be taken. leave a placeholder for a designated vop for that.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   drivers/scsi/ufs/ufs-hwmon.c | 14 ++++++++++++++
>   drivers/scsi/ufs/ufs.h       |  2 ++
>   drivers/scsi/ufs/ufshcd.c    | 21 +++++++++++++++++++++
>   drivers/scsi/ufs/ufshcd.h    |  2 ++
>   4 files changed, 39 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-hwmon.c b/drivers/scsi/ufs/ufs-hwmon.c
> index a50e83f645f4..b466b4649c21 100644
> --- a/drivers/scsi/ufs/ufs-hwmon.c
> +++ b/drivers/scsi/ufs/ufs-hwmon.c
> @@ -177,3 +177,17 @@ void ufs_hwmon_remove(struct ufs_hba *hba)
>   	hba->hwmon_device = NULL;
>   	kfree(data);
>   }
> +
> +void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask)
> +{
> +	if (!hba->hwmon_device)
> +		return;
> +
> +	if (ee_mask & MASK_EE_TOO_HIGH_TEMP)
> +		hwmon_notify_event(hba->hwmon_device, hwmon_temp,
> +				   hwmon_temp_max_alarm, 0);
> +
> +	if (ee_mask & MASK_EE_TOO_LOW_TEMP)
> +		hwmon_notify_event(hba->hwmon_device, hwmon_temp,
> +				   hwmon_temp_min_alarm, 0);
> +}
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 171b27be7b1d..d9bc048c2a71 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -377,6 +377,8 @@ enum {
>   	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
>   };
>   
> +#define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
> +
>   /* Background operation status */
>   enum bkops_status {
>   	BKOPS_STATUS_NO_OP               = 0x0,
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 90c2e9677435..3f4c7124b74b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5642,6 +5642,24 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
>   				__func__, err);
>   }
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
>   static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
>   {
>   	u8 index;
> @@ -5821,6 +5839,9 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
>   	if (status & hba->ee_drv_mask & MASK_EE_URGENT_BKOPS)
>   		ufshcd_bkops_exception_event_handler(hba);
>   
> +	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
> +		ufshcd_temp_exception_event_handler(hba, status);
> +
>   	ufs_debugfs_exception_event(hba, status);
>   out:
>   	ufshcd_scsi_unblock_requests(hba);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 798a408d71e5..e6abce9a8b00 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1063,9 +1063,11 @@ static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
>   #ifdef CONFIG_SCSI_UFS_HWMON
>   void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
>   void ufs_hwmon_remove(struct ufs_hba *hba);
> +void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask);
>   #else
>   static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
>   static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
> +void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask) {}

static

>   #endif
>   
>   #ifdef CONFIG_PM
> 

