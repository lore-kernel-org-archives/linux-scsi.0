Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F400DC00528
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 18:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbjHASaz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbjHASat (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 14:30:49 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9321716
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 11:30:48 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1bb8a89b975so35859795ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 11:30:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690914648; x=1691519448;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zbkt4UWfB6KemAciSTpvaIjqWNa4nwoDG4PtZX30b7Y=;
        b=QSmcGDR9I5wCkK5j6Ua6FduN0wTuHouOfCOkwquiHyOeu41fAG2NM3vtMgxPsUVtrU
         mIddrDwBewjX4zu3+Z86Zr9HINYlZwV9PrOO5vtbm7g2y35hVULRbGEpOvV57ONI0a9G
         MfvcvLvtapNRPeX+vybyde7JSTkJVk09jj2v3yGN4W56XbJHKYnrfiaojDBNh/gOSvh9
         KzKLasuWeatQS0Nu+fM7Efxtlwe1puQTGFomDieuRwPjooACmSY119HUhavdG6tUFPp7
         GblnbpmwrcHSRXnF/ZxFJou1+M+HqioootZjLMsni4Wn1mmke/pMtaIYj+ySTDn2vz/m
         8CWg==
X-Gm-Message-State: ABy/qLbymj2AuhlHu0FVEMdt0EXDM8Autfwq8zvCCGI4olq+Zrhsty1E
        Icyhs5dkJxqZIzGO0HZHBjc=
X-Google-Smtp-Source: APBJJlFe3CGucFTexNS3PI6dnga7gRw1uIyTk1T2YT2mJRPsEqqoRA/tC5W6XYkEd/I4a1Quuuj1/w==
X-Received: by 2002:a17:902:d88d:b0:1b6:af1a:7dd3 with SMTP id b13-20020a170902d88d00b001b6af1a7dd3mr11652945plz.23.1690914647504;
        Tue, 01 Aug 2023 11:30:47 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id z18-20020a170903019200b001bba7aab838sm10779824plg.162.2023.08.01.11.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 11:30:47 -0700 (PDT)
Message-ID: <b7633585-f41b-80e8-a00d-5fdc2a7c7e3e@acm.org>
Date:   Tue, 1 Aug 2023 11:30:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH -next] scsi: core: fix error handling for dev_set_name
Content-Language: en-US
To:     Zhu Wang <wangzhu9@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, gregkh@suse.de, kay.sievers@vrfy.org,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
References: <20230801091933.31794-1-wangzhu9@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230801091933.31794-1-wangzhu9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 02:19, Zhu Wang wrote:
> The driver do not handle the possible returning error of dev_set_name,
> if it returned fail, some operations should be rollback or there may be
> possible memory leak. We use put_device to free the device and use kfree
> to free the memory in the error handle path.
> 
> Fixes: 71610f55fa4d ("[SCSI] struct device - replace bus_id with dev_name(), dev_set_name()")
> Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
> ---
>   drivers/scsi/scsi_scan.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index aa13feb17c62..36808a52ab09 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -509,7 +509,13 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
>   	device_initialize(dev);
>   	kref_init(&starget->reap_ref);
>   	dev->parent = get_device(parent);
> -	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
> +	error = dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
> +	if (error) {
> +		dev_err(dev, "%s: dev_set_name failed, error %d\n", __func__, error);
> +		put_device(dev);
> +		kfree(starget);
> +		return NULL;
> +	}
>   	dev->bus = &scsi_bus_type;
>   	dev->type = &scsi_target_type;
>   	scsi_enable_async_suspend(dev);

I think that a put_device(parent) call is missing from the error path.

Thanks,

Bart.
