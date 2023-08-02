Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD129C04A6A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 15:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbjHBP7x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 11:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbjHBP7v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 11:59:51 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787DC1BFD
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 08:59:49 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-686b643df5dso5011515b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2023 08:59:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690991988; x=1691596788;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UsZ7KHjVVDyRFcYwa8tmbUyvNo77tizBsZS1uvyRhUU=;
        b=TMB2pNsyTk7veRCc3EpO2FXFuNULk4bjgURAaITiLndxKMW+239fC07lStzJ1nMFtK
         h4ECW4kTvi0Oewc1MIbvQIfaSu7jtNVVi+IaCBARRfnDZ200lm/mBCRu17I0KWXokN8B
         Ws4rlB0C+ZaWroc156fPyliaYSYBXIGAKU6fh+51Pb7sMRVyrBsBn4kQmjZxQse3Fa1U
         iOJLdfc7eI4T++YhuuGBxVRFQMZkZJHaMRCqspiBa4ztdGsnxGmv4q4xTKDfsHrZSeKF
         fXx6u8Mg9s+itvrj9+m6Oz7CBC4ejj9dkGfvvVaaaUTa5HqeLsaeF/QLS9Wzx3eiABjb
         5yoA==
X-Gm-Message-State: ABy/qLb0qKpVRPcM4Jy3CuQAKS9BFQSZ8nbE/6YlXI7HhIr8yEC1N8wH
        CgigovLoo1J1TO207sIpy2B3SNlh7bU=
X-Google-Smtp-Source: APBJJlEAyQBTTmVYOp42B9ekG+JAsxGf1b5bzNCdwX4Ml1RXGj5gtfMT3rf5aKAXwxDBbEFrbdm8Vw==
X-Received: by 2002:a05:6a20:8e09:b0:137:26b9:f403 with SMTP id y9-20020a056a208e0900b0013726b9f403mr18074720pzj.49.1690991988267;
        Wed, 02 Aug 2023 08:59:48 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:3b5d:5926:23cf:5139? ([2620:15c:211:201:3b5d:5926:23cf:5139])
        by smtp.gmail.com with ESMTPSA id 6-20020aa79246000000b0068758701717sm2674945pfp.160.2023.08.02.08.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Aug 2023 08:59:47 -0700 (PDT)
Message-ID: <89b80ff5-43d2-0d99-5b60-8f32a60fc5b7@acm.org>
Date:   Wed, 2 Aug 2023 08:59:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH -next v2] scsi: core: fix error handling for dev_set_name
Content-Language: en-US
To:     Zhu Wang <wangzhu9@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, kay.sievers@vrfy.org, gregkh@suse.de,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
References: <20230802031010.14340-1-wangzhu9@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230802031010.14340-1-wangzhu9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 20:10, Zhu Wang wrote:
> The driver do not handle the possible returning error of dev_set_name,
> if it returned fail, some operations should be rollback or there may be
> possible memory leak. We use put_device to free the device and use kfree
> to free the memory in the error handle path.
> 
> Fixes: 71610f55fa4d ("[SCSI] struct device - replace bus_id with dev_name(), dev_set_name()")
> Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

I did not post a "Reviewed-by" tag so you were NOT allowed to add this 
tag yet (see also 
https://lore.kernel.org/linux-scsi/b7633585-f41b-80e8-a00d-5fdc2a7c7e3e@acm.org/). 
Anyway, this version of this patch looks fine to me.

> ---
> Changes in v2:
> - Add put_device(parent) in the error path.
> ---
>   drivers/scsi/scsi_scan.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index aa13feb17c62..de7e503bfcab 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -509,7 +509,14 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
>   	device_initialize(dev);
>   	kref_init(&starget->reap_ref);
>   	dev->parent = get_device(parent);
> -	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
> +	error = dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
> +	if (error) {
> +		dev_err(dev, "%s: dev_set_name failed, error %d\n", __func__, error);
> +		put_device(parent);
> +		put_device(dev);
> +		kfree(starget);
> +		return NULL;
> +	}
>   	dev->bus = &scsi_bus_type;
>   	dev->type = &scsi_target_type;
>   	scsi_enable_async_suspend(dev);

