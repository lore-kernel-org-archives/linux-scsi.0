Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ABA5C76196
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 18:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbjDCSsC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Apr 2023 14:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjDCSsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2023 14:48:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE70B3AB5
        for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2023 11:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680547612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZyURPSYaGS9UkAXaLqQTILaCEaMJc/cqTSOtFprZ5YM=;
        b=NxMIKtu7J+qBmR4NubSoSEO0hUFc4Tc4IJJ2tC7EarEz3Bz05xTcZGW7ukzJ2UB72SNoyn
        cVpHGko92BtuaPU/29El76xDCQWpnDzbVXbjThU0isRYNFudIgtSpR7INLB9xV+v3L3jWO
        fivIuJEr8ZL1/da/U8PHx6MSfPlBnx0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-kpmXrAnDO_qn6K3UOaShqA-1; Mon, 03 Apr 2023 14:46:50 -0400
X-MC-Unique: kpmXrAnDO_qn6K3UOaShqA-1
Received: by mail-ed1-f70.google.com with SMTP id u30-20020a50c05e000000b0050299de3f82so6682327edd.10
        for <linux-scsi@vger.kernel.org>; Mon, 03 Apr 2023 11:46:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680547609;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZyURPSYaGS9UkAXaLqQTILaCEaMJc/cqTSOtFprZ5YM=;
        b=6Dm8S8ydXRJ3y0G9jmBo7H8KEM0Vo8LL1P4WYBLF8+32rwd7VljvWHtGHJzovd5Xs1
         expHG1tyHJazoFcFRrC95Tvl0uqPh7ZFuzAubE7fM/apnCR9tQoxaVOSK2+Q/bgPvI8M
         wRK6zNVqE/W52+g7HlATyjHzdBuX9RZj+39GuUry82aOh7fGb4OlroBgueWi1eKQ/BY0
         vYyCyu1Qi82N8eB+pR4bVkhpfqoEguuUPGW9x6Kgbdb9k2F0oCJGhnpxTICa0sjKdQuE
         QP//IzyrxFXY9twqytnOHOjrz6z/TX1AOfvI7ORuodOu1XsFr91OOtibwo5Q6+UNCqTm
         pm0g==
X-Gm-Message-State: AAQBX9c0HEooXP+sCE1VROZfhWuPsZUUv4vGjfTeTDqJxHib7lw6svmN
        GIjhuWnYXUYbeXNXXftVy4nylamaFtngv/XHb7YlMuuua9LXSGAMFGYleMFn9XB6lTs1t0trEjQ
        NIBzv/0AXFrYDFGG6dA0s5dkUz5mE+PDrESJX2Zj+ixe7L1qto819K9Lymme/o81aT0HbJKZA/H
        kDvJA=
X-Received: by 2002:a17:906:d207:b0:92b:b4d9:3f07 with SMTP id w7-20020a170906d20700b0092bb4d93f07mr34158308ejz.14.1680547608916;
        Mon, 03 Apr 2023 11:46:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350YiNEzOVuy49aTp+ALIIoDtKOokTuFQggMVhiuwMc4O4z5VlHPWWIwHIhQQjzfkL+q0XNOr4Q==
X-Received: by 2002:a17:906:d207:b0:92b:b4d9:3f07 with SMTP id w7-20020a170906d20700b0092bb4d93f07mr34158287ejz.14.1680547608551;
        Mon, 03 Apr 2023 11:46:48 -0700 (PDT)
Received: from [192.168.0.107] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id ri10-20020a1709076a8a00b00932ab7699ffsm4902388ejc.148.2023.04.03.11.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 11:46:48 -0700 (PDT)
Message-ID: <18650793-e065-c923-aa2d-1a13fdbcf5c4@redhat.com>
Date:   Mon, 3 Apr 2023 20:46:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, ranjan.kumar@broadcom.com,
        sathya.prakash@broadcom.com
References: <20230403183910.5485-1-thenzl@redhat.com>
Content-Language: en-US
In-Reply-To: <20230403183910.5485-1-thenzl@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Please drop this one, I've sent it by mistake.

tomash

On 4/3/23 20:39, Tomas Henzl wrote:
> Set the state to deleted in sd_shutdown so that the attached LLD
> doesn't receive new I/O (can happen when in kexec) later after
> LLD's shutdown function has been called.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/sd.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4f28dd617eca..8095f0302e66 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3694,10 +3694,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>  static void sd_shutdown(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	struct scsi_device *sdp;
>  
>  	if (!sdkp)
>  		return;         /* this can happen */
>  
> +	sdp = sdkp->device;
> +
>  	if (pm_runtime_suspended(dev))
>  		return;
>  
> @@ -3710,6 +3713,10 @@ static void sd_shutdown(struct device *dev)
>  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>  		sd_start_stop_device(sdkp, 0);
>  	}
> +
> +	mutex_lock(&sdp->state_mutex);
> +	scsi_device_set_state(sdp, SDEV_DEL);
> +	mutex_unlock(&sdp->state_mutex);
>  }
>  
>  static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)

