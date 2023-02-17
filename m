Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2D9C05027
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Feb 2023 17:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjBQROF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Feb 2023 12:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjBQROE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2023 12:14:04 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490E0692B7
        for <linux-scsi@vger.kernel.org>; Fri, 17 Feb 2023 09:14:02 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id q15so2738039plx.13
        for <linux-scsi@vger.kernel.org>; Fri, 17 Feb 2023 09:14:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NyH3nzYhSsBgE6H4irsBSj7NXRz1wUmmYBhCARwdkNQ=;
        b=eZOokUEPF/Fvlw5cf0Gwv5uoVwhGLCemnSryYMgheWD/DcKTLdIT7GS/4wX35C+20G
         f9BPZg7FVSKxdx4fiUEnEod7zYLsOueb26U+4AhoGNZnL2GRaSMtaCzm7ZrF9VDsoJTV
         VTSEwpQbkFiEFrVEXmoOhCELHhcpdi8x4qKezA9TqIKAQrLCE983WYcXf7HpTHnbkpPo
         b30GLf0R/ikfXUAdyQDAgduUoFPGvN/j9S0Rwu4Jl6o+uSkenqxLQhw1CJNvCzm3Mrm4
         nOFFAb4SDG8t0juT6ry70wPYjtQC1dBaUhLtcDBhAQLTQvzb7uzn7D1d3Dq1/Y8xVdj8
         ZJqw==
X-Gm-Message-State: AO0yUKVSFcxrb3PNaI3hjPckt5SApZoWBaLuuBQGgpHfThfVzXN248AC
        jf70JuK2e/TGMFIlfJqvDT8=
X-Google-Smtp-Source: AK7set/QZ9R0zlcQhpOq/H4b7KNw9+/63eOt/GuH0SsXP4pa4KplKzQcMrrnl00PV4/e2FaxolzIwg==
X-Received: by 2002:a17:902:f149:b0:19c:13b1:4d57 with SMTP id d9-20020a170902f14900b0019c13b14d57mr2159293plb.51.1676654041705;
        Fri, 17 Feb 2023 09:14:01 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5a14:bfb5:ba11:2dc4? ([2620:15c:211:201:5a14:bfb5:ba11:2dc4])
        by smtp.gmail.com with ESMTPSA id f9-20020a170902ab8900b00196768692e0sm3428485plr.86.2023.02.17.09.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 09:14:00 -0800 (PST)
Message-ID: <8e6c545c-9ad6-1d97-9e6a-721d8770b40a@acm.org>
Date:   Fri, 17 Feb 2023 09:13:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] scsi: ufs: initialize devfreq synchronously
Content-Language: en-US
To:     Adrien Thierry <athierry@redhat.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20230216210021.59776-1-athierry@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230216210021.59776-1-athierry@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/16/23 13:00, Adrien Thierry wrote:
> During ufs initialization, devfreq initialization is asynchronous:
> ufshcd_async_scan() calls ufshcd_add_lus(), which in turn initializes
> devfreq for ufs. The simple ondemand governor is then loaded. If it is
> build as a module, request_module() is called and throws a warning:

build -> built?

> @@ -9896,12 +9893,30 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   	 */
>   	ufshcd_set_ufs_dev_active(hba);
>   
> +	/* Initialize devfreq */
> +	if (ufshcd_is_clkscaling_supported(hba)) {
> +		memcpy(&hba->clk_scaling.saved_pwr_info.info,
> +			&hba->pwr_info,
> +			sizeof(struct ufs_pa_layer_attr));
> +		hba->clk_scaling.saved_pwr_info.is_valid = true;
> +		hba->clk_scaling.is_allowed = true;
> +
> +		err = ufshcd_devfreq_init(hba);
> +		if (err)
> +			goto out_power_off;
> +
> +		hba->clk_scaling.is_enabled = true;
> +		ufshcd_init_clk_scaling_sysfs(hba);
> +	}
> +
>   	async_schedule(ufshcd_async_scan, hba);
>   	ufs_sysfs_add_nodes(hba->dev);
>   
>   	device_enable_async_suspend(dev);
>   	return 0;
>   
> +out_power_off:
> +	pm_runtime_put_sync(dev);
>   free_tmf_queue:
>   	blk_mq_destroy_queue(hba->tmf_queue);
>   	blk_put_queue(hba->tmf_queue);

Something I should have noticed while reviewing v1 of this patch: the 
label name "out_power_off" is misleading. pm_runtime_put_sync() does not 
power off a device but instead gives the power management core 
permission to apply the power management policy configured via sysfs. 
Runtime power management can be disabled via sysfs. How about renaming 
this label into "rpm_put_sync" (RPM = Runtime Power Management)?

Thanks,

Bart.
