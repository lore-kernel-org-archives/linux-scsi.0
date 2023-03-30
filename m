Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EF5C6FD1D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Mar 2023 17:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjC3RIR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Mar 2023 13:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbjC3RIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2023 13:08:16 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C70CCDF6
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2023 10:08:16 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id iw3so18700898plb.6
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2023 10:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680196095;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nhUUOvHfX/xheS1Nhf2TbM5dBDN6wIag+/elVYJvwUg=;
        b=XJXaub9tSz45ASdca7idxiD0csfadV4o6FPD5FjEgEPfFikXk1CUqCklYZqC4b5cOu
         Kg7rfArYI8O6JO1u5hcn43nih31LK0lM/oFr1q92QxdFkDWYnhaTg1gXjfXCd1i4Q7zN
         r5RbGUVhWAV+7AZTcdzcGwDrbHPefvul8w3pACI9IF0kqE6FhmzVIgKDP4ebEn0tMG67
         Nt22dW8XE8kxz/oHbWjGWDA9T4DN3YPeyBLN/bWgrW4akNx1aCy92FedE4xrRDBoQ51F
         CCCm9twIohCKRCMtfEN7HtGLchKYU2JfQNsUCJRAcIjBfy0nlm+K2xYBgJP+SPGvfB9R
         BmIQ==
X-Gm-Message-State: AAQBX9elciQOL1z6XP+ZOOM5eR/1ZaJ7s0BAkcnI2imS7U9b0f6OszO6
        Rs1CPMeSkh08eykN1OfArxZBoG8CUaw=
X-Google-Smtp-Source: AKy350ZgU3XVMCxFHSE6i0wf501a+sgrAcGji9ZtWIRokq2N/dLFozcx7UqhpEdeBq6zWqDmRRYwaw==
X-Received: by 2002:a17:903:41cb:b0:1a1:d215:ef0c with SMTP id u11-20020a17090341cb00b001a1d215ef0cmr27624923ple.16.1680196095446;
        Thu, 30 Mar 2023 10:08:15 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:6b0e:992b:d535:b656? ([2620:15c:211:201:6b0e:992b:d535:b656])
        by smtp.gmail.com with ESMTPSA id k20-20020a63ff14000000b0050a0227a4bcsm61832pgi.57.2023.03.30.10.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 10:08:14 -0700 (PDT)
Message-ID: <f4ad668a-5b22-734d-0491-4ed6e065ade9@acm.org>
Date:   Thu, 30 Mar 2023 10:08:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
Content-Language: en-US
To:     Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
References: <20230330164943.11607-1-thenzl@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230330164943.11607-1-thenzl@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/30/23 09:49, Tomas Henzl wrote:
> Set the state to deleted in sd_shutdown so that the attached LLD
> doesn't receive new I/O (can happen when in kexec) later after
> LLD's shutdown function has been called.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>   drivers/scsi/sd.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4f28dd617eca..8095f0302e66 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3694,10 +3694,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>   static void sd_shutdown(struct device *dev)
>   {
>   	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	struct scsi_device *sdp;
>   
>   	if (!sdkp)
>   		return;         /* this can happen */
>   
> +	sdp = sdkp->device;
> +
>   	if (pm_runtime_suspended(dev))
>   		return;
>   
> @@ -3710,6 +3713,10 @@ static void sd_shutdown(struct device *dev)
>   		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>   		sd_start_stop_device(sdkp, 0);
>   	}
> +
> +	mutex_lock(&sdp->state_mutex);
> +	scsi_device_set_state(sdp, SDEV_DEL);
> +	mutex_unlock(&sdp->state_mutex);
>   }

Shouldn't new I/O to the SCSI disk be prevented whether or not the SCSI 
disk has been runtime suspended?

Thanks,

Bart.

