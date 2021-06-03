Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B40C47083
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 03:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 754C8613B8
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 03:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhFCDId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 23:08:33 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:34461 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFCDId (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 23:08:33 -0400
Received: by mail-pj1-f46.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso2621704pjx.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Jun 2021 20:06:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5J98ypAdG7TGFDW/Qe5X05lht29wl4JZD+Fti7OtFtQ=;
        b=fayWDgH9R25xTQs4ivQx/jrnSq5uxiN9S5b01eJ/j5I+L7bLXheKsIGsWJJBiByXEe
         508Lgje5dST9PnOzWnpCzhWSWnGbi/IO3FTdfCI2CKheikb5ZuHbvHz1xPFFr9087K5S
         1J8ovAFjw7FwhhzNBzXbr1dl2q1Co4NBHBo6qVfE4Nv2ey5F7cMCXHKS6yeJ2qmAn70L
         +y0Wlw6Y7NTG8sp+Ag5fRgMieITTbdNcKxQOdHjXb9IqhXbjdVdW4DoGtAnGQxUzu/+a
         nMD6zVbWJ1Rzl111uyQN4QuG0nWkTaxsgO7IQXjV8nHeIY4m4F77p32tGShLHpMplWuv
         Hk9Q==
X-Gm-Message-State: AOAM530JsI9z7h8EFmOSzKF/f5wqhwzpMCBIA253ZLdoL4BaX1S+bW7l
        /wET8ha8u8/Hq9xtDYbgnro=
X-Google-Smtp-Source: ABdhPJzDMFE66H45nedLhyOIznCI1vN4Q9p7t4Gm9jz8lmR6pXVV95s5Y3McKUgJx5TmHyicDL9HtA==
X-Received: by 2002:a17:902:7087:b029:104:6133:6d2d with SMTP id z7-20020a1709027087b029010461336d2dmr19874367plk.39.1622689593043;
        Wed, 02 Jun 2021 20:06:33 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n72sm799432pfd.8.2021.06.02.20.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 20:06:32 -0700 (PDT)
Subject: Re: [PATCH 3/4] scsi: core: put .shost_dev in failure path if host
 state becomes running
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-4-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d2ddd0a4-db61-a966-0e27-313e59cfd7e7@acm.org>
Date:   Wed, 2 Jun 2021 20:06:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210602133029.2864069-4-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/2/21 6:30 AM, Ming Lei wrote:
> scsi_host_dev_release() only works around for us by freeing
> dev_name(&shost->shost_dev) when host state is SHOST_CREATED. After host
> state is changed to SHOST_RUNNING, scsi_host_dev_release() doesn't do
> that any more.
> 
> So fix the issue by put .shost_dev in failure path if host state becomes
> running, meantime move get_device(&shost->shost_gendev) before
> device_add(&shost->shost_dev), so that scsi_host_cls_release() can put
> this reference.
> 
> Reported-by: John Garry <john.garry@huawei.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/hosts.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 796736e47764..7049844adb6b 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -257,12 +257,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>  
>  	device_enable_async_suspend(&shost->shost_dev);
>  
> +	get_device(&shost->shost_gendev);
>  	error = device_add(&shost->shost_dev);
>  	if (error)
>  		goto out_del_gendev;
>  
> -	get_device(&shost->shost_gendev);
> -
>  	if (shost->transportt->host_size) {
>  		shost->shost_data = kzalloc(shost->transportt->host_size,
>  					 GFP_KERNEL);
> @@ -300,6 +299,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   out_del_dev:
>  	device_del(&shost->shost_dev);
>   out_del_gendev:
> +	/*
> +	 * host state has become SHOST_RUNNING, so we have to release
> +	 * ->shost_dev explicitly
> +	 */
> +	put_device(&shost->shost_dev);
>  	device_del(&shost->shost_gendev);
>   out_disable_runtime_pm:
>  	device_disable_async_suspend(&shost->shost_gendev);

Shouldn't this change be merged into patch 2/4 since both patches touch
the same function? Anyway, this patch also looks good to me.

Bart.


