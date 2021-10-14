Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24055C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 04:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED0A261039
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 04:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhJNEU0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 00:20:26 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:42926 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNEU0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2021 00:20:26 -0400
Received: by mail-pl1-f177.google.com with SMTP id l6so3247728plh.9;
        Wed, 13 Oct 2021 21:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5DmMTOuF52iJ6aDRUaCigoiPrKtXFQa3e6EV0KU79O8=;
        b=cO5MmhgxjFAPOlPT7SI7ZFCbNqR4NtSxnXHo43TAqZWQBQU5A6DZf8/oK52nvHzYSM
         t3g5wY9Cvuy70u/bsfB/6xchkpBhp/aSAGY5Cev7Mnpcm2ZaGPLBENwZzaZYILPOp9Sg
         0K6iniDx1eXtm6kuKd3+RrjwlNDtDJahXM71L178KHwMClmXWCTzdsQk5bSyvvv3siE3
         W/bkT+NKH6fueXvjlRQrya+hWI0MccX+whunAdk2ipMCwzinEX2+ZKp2ImGgGbkpzuK4
         A1ItnYhZXAcjbIMpIg6DP3SPae9VDs4kWlzuxAG5hILtjmp9xj2cDCeQ2VH0MCbiOVSS
         TtXQ==
X-Gm-Message-State: AOAM5330Xje5Ebx9d62jXt/MektSQjiEyV6v/w+vzKCcnMM+hVq6OMzd
        +cBLYe66AS404gBnf4ZLU9Y=
X-Google-Smtp-Source: ABdhPJx1MlSLzM5Go1yaThp3FbHgWcT3bGdbg8Bw49KdPKBgezRfY32LWmPpGPTwcEZTl4PBe3nM9A==
X-Received: by 2002:a17:903:183:b0:13f:1bc:e6bf with SMTP id z3-20020a170903018300b0013f01bce6bfmr2911591plg.47.1634185101491;
        Wed, 13 Oct 2021 21:18:21 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:cb9c:9f45:498e:cfd1? ([2601:647:4000:d7:cb9c:9f45:498e:cfd1])
        by smtp.gmail.com with ESMTPSA id x7sm936422pfj.28.2021.10.13.21.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 21:18:20 -0700 (PDT)
Message-ID: <1fdaef0a-3370-3cf5-5564-99a1c59d2b6a@acm.org>
Date:   Wed, 13 Oct 2021 21:18:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH] scsi: sd: print write through due to no caching mode page
 as warning
Content-Language: en-US
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     dgilbert@interlog.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com
References: <20211013075050.3870354-1-martin.kepplinger@puri.sm>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211013075050.3870354-1-martin.kepplinger@puri.sm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/21 00:50, Martin Kepplinger wrote:
> I only resending the same patch I sent in January before:
> https://lore.kernel.org/linux-scsi/20210122083000.32598-1-martin.kepplinger@puri.sm/

A common way to indicate this is to start the email subject with [PATCH 
RESEND].

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index a646d27df681..33ea36b41136 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2793,7 +2793,8 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>   			}
>   		}
>   
> -		sd_first_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
> +		sd_first_printk(KERN_WARNING, sdkp,
> +				"No Caching mode page found\n");
>   		goto defaults;
>   
>   	Page_found:
> @@ -2848,7 +2849,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>   				"Assuming drive cache: write back\n");
>   		sdkp->WCE = 1;
>   	} else {
> -		sd_first_printk(KERN_ERR, sdkp,
> +		sd_first_printk(KERN_WARNING, sdkp,
>   				"Assuming drive cache: write through\n");
>   		sdkp->WCE = 0;
>   	}

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
