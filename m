Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0D6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Dec 2021 00:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbhL1AeK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Dec 2021 19:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbhL1AeK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2021 19:34:10 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7DAC06173E
        for <linux-scsi@vger.kernel.org>; Mon, 27 Dec 2021 16:34:10 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id a1so14826358qtx.11
        for <linux-scsi@vger.kernel.org>; Mon, 27 Dec 2021 16:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jPjkEqGp5XuQYZEfLNQHPR01/l5pdWTL62Z1KwvFYaw=;
        b=dwkWkuXhdMoMt8oUNUr1f+b8G6Lrhg5RGuOWZU7Nhjxju7vVYtJdiTCLdUdA7yuUWe
         5yn5GuCd9jg5iQGUW4vCQnvr3X8xvy5H4Wp+7VOSjMt4G1vTFmWCtR1ZnMxB1y08Z75x
         kDz0pij4ROroGBm+y9lrazU1jdsfM2zI9INPOqv3K3QrqFfuvoiBNPFbllSo0KF1u+26
         WQeaLnyHqBTNBEtHxdZnSdWWsqK3pYkaTrsQUm70JoSCLtkibtYq/4jnNg91TDQUP69J
         Da8ophTXGplaSkoG5cpdgNLsYFBcBozHvrD+5PBEhIPhICRt+qVfUpTs1noK9SbdMod+
         NJmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jPjkEqGp5XuQYZEfLNQHPR01/l5pdWTL62Z1KwvFYaw=;
        b=uq9myiLJwBt2oyausMv7QJiHzZjTjmLezhlCtX3pNqyoPWFmu3UnK55YMwNo/OxVs5
         VeY1WbwO7pfG7nCNqom2GxnwInKraZ+WPIgWNHquOHcafvKGJ82rOPM4zCg/YNIHD0hv
         CpSoStSdyL/oM7+Mh4Y+avs65VneWcunC08watus4bCTZyQb+qip21Fi0fDKVSLhpv7B
         iNxIo+MODYBNYwSqDd82zxI22A4PkQ/MAbKSl8J/G/g9pDO8/M0k8xTl/42YLhiK4No5
         GBiMxD4HbV2VAPHAZ+KoseVFDeiQKny0isojabJNh4LQzOQQWr/R/2+1LG1x3hCn8YEF
         +Bug==
X-Gm-Message-State: AOAM5324+mI6G+BOX3NLUxzX1cTDa4ITO/Gz9Yo0Dt38FmAhUQzd/z2M
        Cx1xC5z9B8rDgdFmdS/6ZMq9MWYpzPE=
X-Google-Smtp-Source: ABdhPJxDd2/PspvZvYgSy/dSff71XLXVs/63PFO2ju+k8G72iQQ9sO+IxVdwMMa9FinA0EOYJoYr5A==
X-Received: by 2002:ac8:7d08:: with SMTP id g8mr16181581qtb.573.1640651649330;
        Mon, 27 Dec 2021 16:34:09 -0800 (PST)
Received: from oc6857751186.ibm.com (c-24-20-51-242.hsd1.or.comcast.net. [24.20.51.242])
        by smtp.gmail.com with ESMTPSA id j20sm15491645qko.117.2021.12.27.16.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Dec 2021 16:34:09 -0800 (PST)
Subject: Re: [PATCH] sr: don't use GFP_DMA in get_capabilities
To:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, bhe@redhat.com
References: <20211222090159.916428-1-hch@lst.de>
From:   Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Message-ID: <9e512d2b-8467-9a6f-734c-eb6df37d5d69@gmail.com>
Date:   Mon, 27 Dec 2021 16:34:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211222090159.916428-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/21 1:01 AM, Christoph Hellwig wrote:
> The allocated buffer is used as a command payload, for which the block
> layer and/or DMA API do the proper bounce buffering if needed.
> 
> Reported-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 14c122839c409..f925b1f1f9ada 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -855,7 +855,7 @@ static void get_capabilities(struct scsi_cd *cd)
>  
>  
>  	/* allocate transfer buffer */
> -	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
> +	buffer = kmalloc(512, GFP_KERNEL);
>  	if (!buffer) {
>  		sr_printk(KERN_ERR, cd, "out of memory.\n");

A separate trivial cleanup is the unnecessary memory allocation failure message
here since the mm layer will already report such things.

-Tyrel

>  		return;
> 

