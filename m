Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E8CC432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 16:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 974E261059
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 16:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344545AbhIAQxx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 12:53:53 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:46897 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344563AbhIAQxr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 12:53:47 -0400
Received: by mail-pg1-f177.google.com with SMTP id w7so4662pgk.13;
        Wed, 01 Sep 2021 09:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ftQGABx0xufp8pThD84BAjAZBtnCC/TxEXzAl+Vzi9Q=;
        b=shAMK2u16f4hcOJhYDI0awv1NERXJtXNYmyzL+arz5x2r4curs+dZMIQyIHf1owcqZ
         J4tqRxqpBHu3fRtQv8FzH4leMwiw+qoITCCxl+b19occSuw3dv4ifZ5TtNloxOd33Y80
         fHkKx8lqFvXriCaEAd9CAZVTDb6PDhuOyqzI7DE5QYuV2MW0VUZv+rY5tjTa2VVV0wtJ
         jjXmtovz4k44IICwi9IpUpw4H0opyvwX8HgtahQU4eyPV6BjatcT7o2o9rfrvAGYqyha
         X35TxK6bK56bIJj/zewBILRNwepVgXnWFP9NHPQTNnHIIg0hZ89CJwOR/xhdDICzy8pR
         ayMg==
X-Gm-Message-State: AOAM530iQwchUX3PihpLPXy3HNfxtEi7FYhGhyYCpe8/Sh+ApjWr/oa3
        VNETwfbpyQd6IBVe8wy0BVFtduUZIfc=
X-Google-Smtp-Source: ABdhPJzTfATfDDP/9qrgWEdZJ+lfSK8CaykloWTE7YOyjPj+JC9x6ZVGc334DH4bP9a+JEH7pcihkQ==
X-Received: by 2002:a63:2047:: with SMTP id r7mr59288pgm.398.1630515170171;
        Wed, 01 Sep 2021 09:52:50 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8a3b:44ab:b62:3ce2])
        by smtp.gmail.com with ESMTPSA id z17sm54375pfa.125.2021.09.01.09.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 09:52:49 -0700 (PDT)
Subject: Re: [PATCH 3/3] scsi: ufs-sysfs: Add sysfs entries for temperature
 notification
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210901123707.5014-1-avri.altman@wdc.com>
 <20210901123707.5014-4-avri.altman@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <0c547d74-481f-0c5e-9f7a-8c29218a0d3a@acm.org>
Date:   Wed, 1 Sep 2021 09:52:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210901123707.5014-4-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/1/21 5:37 AM, Avri Altman wrote:
> +What:		/sys/bus/platform/drivers/ufshcd/*/attributes/case_rough_temp
> +Date:		September 2021
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:	The device case rough temperature (bDeviceCaseRoughTemperature
> +		attribute). It is termed "rough" due to the inherent inaccuracy
> +		of the temperature sensor inside a semiconductor device,
> +		e.g. +- 10 degrees centigrade error range.

My understanding is that the word Celsius is more common than centigrade 
so please use Celsius instead of centigrade. See also 
https://www.brannan.co.uk/celsius-centigrade-and-fahrenheit/

> +		allowable range is [-79..170].
> +		The temperature readings are in decimal degrees Celsius.
> +
> +		Please note that the Tcase validity depends on the state of the
> +		wExceptionEventControl attribute: it is up to the user to
> +		verify that the applicable mask (TOO_HIGH_TEMP_EN, and / or
> +		TOO_LOW_TEMP_EN) is set for the exception handling control.
> +		This can be either done by ufs-bsg or ufs-debugfs.

Instead of making the user verify whether case_rough_temp is valid, 
please modify the kernel code such that case_rough_temp only reports a 
value if that value is valid. One possible approach is to make the show 
method return an error code if case_rough_temp is not valid. Another and 
probably better approach is to define a sysfs attribute group and to 
make case_rough_temp visible only if it is valid.

> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index 5c405ff7b6ea..a9abe33c40e4 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -1047,6 +1047,86 @@ static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
>   		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
>   }
>   
> +static inline bool ufshcd_is_temp_attrs(enum attr_idn idn)
> +{
> +	return idn >= QUERY_ATTR_IDN_CASE_ROUGH_TEMP &&
> +	       idn <= QUERY_ATTR_IDN_LOW_TEMP_BOUND;
> +}

Modern compilers are good at deciding when to inline a function so 
please leave out the 'inline' keyword from the above function.

> +static bool ufshcd_case_temp_legal(struct ufs_hba *hba)\

Please use another word than "legal" since the primary meaning of 
"legal" is "of or relating to law".

> +	ufshcd_rpm_get_sync(hba);
> +	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +				QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &ee_mask);
> +	ufshcd_rpm_put_sync(hba);

Are there any ufshcd_query_attr() calls that are not surrounded by 
ufshcd_rpm_{get,put}_sync()? If not, please move the 
ufshcd_rpm_{get,put}_sync() calls into ufshcd_query_attr().

Thanks,

Bart.
