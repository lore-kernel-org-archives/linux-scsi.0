Return-Path: <SRS0=SQ1Y=2D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0BCC2D0CB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 21:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A9302465E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 21:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLMVAE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Dec 2019 16:00:04 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32789 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfLMVAE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2019 16:00:04 -0500
Received: by mail-pl1-f195.google.com with SMTP id c13so1746511pls.0;
        Fri, 13 Dec 2019 13:00:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+hqr72PqUIxaNHoI7oLvHLPcCc2ckec5rmVfoIaLp1w=;
        b=V7Qt04xApwcMvSImCrv5Fzm10eoQVu4QY3yPmhD+OqccaDX24rdxlHtGBFI4AS2J84
         fhf5l8Xge3bhynRSUPszZgFeAmDcwU0XJaWFibTDhrHNVEl0oO74w8rQuiyXAbDg98jV
         YqhMJyc30IQtykTb4FHSk8qfIAGAMZvQUicpTGrj+jmtJaLrJuEFQlY6eKSMMAUHbrdi
         bX1HcFXXwwI9O3SUUKj5kpMqI67TETNMqn/o1o9QBCzadMqH6Ey5hRgUrYgO9uk4FxhW
         GaghaJf0o8n4Xdv/AMlFmRRhzX3jLGj2SGNzKozrYVY6gooE4KCGuQreC+g+eXmtI5fP
         eW6Q==
X-Gm-Message-State: APjAAAU23/Jy2tq0ro7nVfp6Zx+vXaSkf3w/pGOIxPZ1Z/ZqlBKM/TOI
        +3lrJjME6CatDHUvq57XHiigUTdKc8U=
X-Google-Smtp-Source: APXvYqwTTBroPHZG57UDlXK8ZOVGzNiM3x+9KlnFXCGmXzrfx8jOtQg/5P1uWsnqIQ38W6V549B1aQ==
X-Received: by 2002:a17:90a:e4f:: with SMTP id p15mr1577202pja.90.1576270802809;
        Fri, 13 Dec 2019 13:00:02 -0800 (PST)
Received: from [172.19.248.113] ([38.98.37.141])
        by smtp.gmail.com with ESMTPSA id i127sm12711144pfc.55.2019.12.13.12.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 13:00:01 -0800 (PST)
Subject: Re: [PATCH v2 2/3] scsi: ufs: Modulize ufs-bsg
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425e749-1808e138-740e-4036-922f-7a49ec02c2b8-000000@us-west-2.amazonses.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9c31a7f5-a39b-02e6-350f-5fe51f1c4275@acm.org>
Date:   Fri, 13 Dec 2019 13:59:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0101016ef425e749-1808e138-740e-4036-922f-7a49ec02c2b8-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/11/19 3:49 AM, Can Guo wrote:
> In order to improve the flexibility of ufs-bsg, modulizing it is a good
> choice. This change introduces tristate to ufs-bsg to allow users compile
> it as an external module.

Did you perhaps mean "modularize" instead of "modulize"? Additionally, 
should "modulizing" perhaps be changed into "modularizing"?

> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index d14c224..72620ce 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -38,6 +38,7 @@ config SCSI_UFSHCD
>   	select PM_DEVFREQ
>   	select DEVFREQ_GOV_SIMPLE_ONDEMAND
>   	select NLS
> +	select BLK_DEV_BSGLIB
>   	---help---
>   	This selects the support for UFS devices in Linux, say Y and make
>   	  sure that you know the name of your UFS host adapter (the card

I do not understand the above change. Doesn't moving the BSG code into a 
separate module remove the dependency of SCSI_UFSHCD on BLK_DEV_BSGLIB?

> +static int __init ufs_bsg_init(void)
> +{
> +	struct list_head *hba_list = NULL;
> +	struct ufs_hba *hba;
> +	int ret = 0;
> +
> +	ufshcd_get_hba_list_lock(&hba_list);
> +	list_for_each_entry(hba, hba_list, list) {
> +		ret = ufs_bsg_probe(hba);
> +		if (ret)
> +			break;
> +	}
> +	ufshcd_put_hba_list_unlock();
> +
> +	return ret;
> +}

What if ufs_bsg_probe() succeeds for some UFS adapters but not for 
others? Shouldn't ufs_bgs_remove() be called in that case for the 
adapters for which ufs_bsg_probe() succeeded?

> +late_initcall_sync(ufs_bsg_init);
> +module_exit(ufs_bsg_exit);

Why late_initcall_sync() instead of module_init()?

> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a86b0fd..7a83a8f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -108,6 +108,22 @@
>   		       16, 4, buf, __len, false);                        \
>   } while (0)
>   
> +static LIST_HEAD(ufs_hba_list);
> +static DEFINE_MUTEX(ufs_hba_list_lock);
> +
> +void ufshcd_get_hba_list_lock(struct list_head **list)
> +{
> +	mutex_lock(&ufs_hba_list_lock);
> +	*list = &ufs_hba_list;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_get_hba_list_lock);

Please make ufshcd_get_hba_list_lock() return the list_head pointer 
instead of the above.

Thanks,

Bart.
