Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A62C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 16:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3BD36135E
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 16:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhJSQea (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 12:34:30 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:37624 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbhJSQea (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2021 12:34:30 -0400
Received: by mail-pl1-f169.google.com with SMTP id n11so14057567plf.4;
        Tue, 19 Oct 2021 09:32:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hYlVhocQ1aZk9B0/3J3FlQ4trBjPDzNEY9FbqZF5OJk=;
        b=0SpfNYYBdU8Dfz4qZs3ocLpjuc3Zd02bUSHTJEMMoxAwdzWS+cBhpX80cOcvM8NNi+
         PxHFEHSFfVgxxLzdDcb+JeuKhzxiIrqg+P+RS/8k+SPYOrdFbNx7SM4Ji5gTZo598Jpx
         sToTZDKTif+e7LXL8Iehrixpp5ODd60kfnioeFkpdnoh+sNhiFroSQcvLPQv0TSzKBkV
         j7xGTTL5GwVmy73fMVwmg5o83ZCGPJAey3RiI+oxV0Jdx1ZSyiKVPIZVZPmBG+tzsnMj
         GzQ3ZpLc0BNKFQZCBbtEMKacvp5cuab22LvOyyOQfKw+5BerF5h2oWFRu+lA7vTo7jB/
         gRfg==
X-Gm-Message-State: AOAM533dtDtgozZmlstFspAkzpze380mrer8BoLrTVXKYPRovdlFcZi2
        4ZCe5O50AtNp49O4F2Qt0mKF6dCtb9E=
X-Google-Smtp-Source: ABdhPJzToXdhztfjY4CDJmSrMmms3cF1E+As4C9p0FQVj9eMKKePxSK7ds17xvQ0ps/OJhPerjpqYA==
X-Received: by 2002:a17:90b:3ecb:: with SMTP id rm11mr1057190pjb.110.1634661136122;
        Tue, 19 Oct 2021 09:32:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3f60:dc0f:50d7:6a24])
        by smtp.gmail.com with ESMTPSA id q13sm17626995pfj.26.2021.10.19.09.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 09:32:15 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: ufs-pci: hide unused ufshcd_pci_restore
 function
To:     Arnd Bergmann <arnd@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211019153600.380220-1-arnd@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <dedd8a18-c6e2-c60d-96a3-fb8a61e3b14e@acm.org>
Date:   Tue, 19 Oct 2021 09:32:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019153600.380220-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/21 8:35 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When CONFIG_PM_SLEEP is disabled, ufshcd_pci_restore() fails
> to compile but is also unused:
> 
> drivers/scsi/ufs/ufshcd-pci.c: In function 'ufshcd_pci_restore':
> drivers/scsi/ufs/ufshcd-pci.c:459:16: error: implicit declaration of function 'ufshcd_system_resume'; did you mean 'ufshcd_runtime_resume'? [-Werror=implicit-function-declaration]
>    459 |         return ufshcd_system_resume(dev);
>        |                ^~~~~~~~~~~~~~~~~~~~
>        |                ufshcd_runtime_resume
> At top level:
> drivers/scsi/ufs/ufshcd-pci.c:452:12: error: 'ufshcd_pci_restore' defined but not used [-Werror=unused-function]
>    452 | static int ufshcd_pci_restore(struct device *dev)
>        |            ^~~~~~~~~~~~~~~~~~
> 
> Enclose it within the same #ifdef as the related code.
> 
> Fixes: 21431d5bdf15 ("scsi: core: ufs-pci: Force a full restore after suspend-to-disk")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/scsi/ufs/ufshcd-pci.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
> index d65e6cd7a28d..51424557810d 100644
> --- a/drivers/scsi/ufs/ufshcd-pci.c
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -449,6 +449,7 @@ static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
>   	.device_reset		= ufs_intel_device_reset,
>   };
>   
> +#ifdef CONFIG_PM_SLEEP
>   static int ufshcd_pci_restore(struct device *dev)
>   {
>   	struct ufs_hba *hba = dev_get_drvdata(dev);
> @@ -458,6 +459,7 @@ static int ufshcd_pci_restore(struct device *dev)
>   
>   	return ufshcd_system_resume(dev);
>   }
> +#endif
>   
>   /**
>    * ufshcd_pci_shutdown - main function to put the controller in reset state
> 

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
