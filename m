Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FE6C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 17:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjFGRWb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjFGRWa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 13:22:30 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EC61BF1
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 10:22:29 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-652699e72f7so3896306b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jun 2023 10:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686158549; x=1688750549;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lrz5EJwO7kk5VtSoM0FzJhW+f+Z66q4Dy8NMKj/8c2M=;
        b=VcwaTT4E5BOPA8ZYMKc32AjnCcNARbrWT5MWwEiTmFGssuPBJBzo+K34V9BXPzWJ2h
         9X+I+rFWoME4g2nW2zZm+hPQepCTSOZGPKptzrErg25hqgJz4ONTDHkClkdoUav/Ofmc
         bAduDpuDH6RBHCyaEn422ZjsAwB8DRYyNn+33CFuMbMs82Ecu34HUQjQrlaoUNnwiJcy
         26JgS+IJ38bWbeF1tdOkv8SJhvhfAjWeqdmMkBLmtk0XA31ZYvJPhtaq+NTIBr8WrN58
         pnzeX8zDAsQaQTl/PMYkSzl17oZxjLrFRrLH1sGvFnWrAZm4kYl4CLOhEVWFAEcQJieD
         JOkw==
X-Gm-Message-State: AC+VfDyzRznf0BrfEaNpTfpI/jSV9zAGBxDWisXWAJOYFXZkC5pZUKki
        TWVU+HkoRurXWy7d8m2DtXg4k0huvVE=
X-Google-Smtp-Source: ACHHUZ4tmJeCb0yFBfs0h+XeNxC+e2XkEhhWeLO5aOBHUbQTAxuzyvfzOT1NwpIfW7fV3qXe4o6qqQ==
X-Received: by 2002:a05:6a20:1612:b0:118:8854:dd14 with SMTP id l18-20020a056a20161200b001188854dd14mr867200pzj.59.1686158548982;
        Wed, 07 Jun 2023 10:22:28 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j22-20020a17090a7e9600b00259b729eea9sm1631562pjl.8.2023.06.07.10.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 10:22:28 -0700 (PDT)
Message-ID: <17b7c793-5d7d-50ab-8cd8-2f2e7bf3e789@acm.org>
Date:   Wed, 7 Jun 2023 10:22:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH] scsi: qlogic_cs: fix irqf_shared, share same irq with
 pcmcia controller
Content-Language: en-US
To:     =?UTF-8?B?5bCk5pmT5p2w?= <yxj790222@163.com>,
        linux-scsi@vger.kernel.org
References: <57837fce.3209.188665c4d0d.Coremail.yxj790222@163.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <57837fce.3209.188665c4d0d.Coremail.yxj790222@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/29/23 00:15, 尤晓杰 wrote:
>  From 82c1d0f88243f8ed1ffaeea98d775abd58866b1b Mon Sep 17 00:00:00 2001
> From: You Xiaojie <yxj790222@163.com>
> Date: Fri, 21 Apr 2023 19:02:15 +0800
> Subject: [PATCH] qlogic_cs: fix IRQF_SHARED
> 
> Signed-off-by: You Xiaojie <yxj790222@163.com>
> ---
>   drivers/scsi/pcmcia/qlogic_stub.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
> index 310d0b6586a6..4dbb938790c2 100644
> --- a/drivers/scsi/pcmcia/qlogic_stub.c
> +++ b/drivers/scsi/pcmcia/qlogic_stub.c
> @@ -122,7 +122,7 @@ static struct Scsi_Host *qlogic_detect(struct scsi_host_template *host,
>   	priv->shost = shost;
>   	priv->int_type = INT_TYPE;					
>   
> -	if (request_irq(qlirq, qlogicfas408_ihandl, 0, qlogic_name, shost))
> +	if (request_irq(qlirq, qlogicfas408_ihandl, IRQF_SHARED, qlogic_name, shost))
>   		goto free_scsi_host;
>   
>   	sprintf(priv->qinfo,

A patch description is missing. Please explain whether this patch is
the result of reviewing source code and also whether or not this patch
has been tested on a system that has the hardware supported by the
modified driver.

Thanks,

Bart.
