Return-Path: <SRS0=SrIF=DD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6597BC4741F
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 09:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B53B2389E
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 09:08:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XYDDrAVU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgIZJIJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Sep 2020 05:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgIZJIJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Sep 2020 05:08:09 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D221C0613CE;
        Sat, 26 Sep 2020 02:08:08 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id y2so5451403lfy.10;
        Sat, 26 Sep 2020 02:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h1oWFvI3HjirlY79q40sQwrA8YmVlwg8+gqYYHyCxII=;
        b=XYDDrAVUAvHt0P1Zj54aLUYuc764na0B8HZq0qlyJ/5gMfhEljRnfIoJBpl8CVWqQC
         Im39LLX+SU7Re6STvLuQbKS+h/ptUsv2QhecXnC4vdmnAQAkpVzmd5JthXXd8BUg4hK2
         D6AnIy6g83kwtCGZHXbe5YOXNwxBoC4RuYOJbJMEE7FpfrnvD4DDfmkJI9ve3X2K4RCH
         S1/Wl1P4m1QPrhHAeYe8+aBdDQAqvvS2BJkm/Z63WqndjAO0uaU74W476pi+EJRPPBDe
         DQe6I9V9i/IG0N5JB12perXRMpwdlXCqpIn67YrcrWjc/RcJRnl9NHwhyNRjXstYOWOz
         TRRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=h1oWFvI3HjirlY79q40sQwrA8YmVlwg8+gqYYHyCxII=;
        b=LGAyxxA9V0mUyYqgIL/ehFFkYnZfE8mLP2s3/rtBpEJj/eV9LhBDqQHNDJP+/jD8t4
         X7zYBB9JUibtiuo9hiEMVe+jnIg5fmlqfKqNRJsiI/j1rwcfRxzOmAZjDb3gAIFkDaa/
         g9Gu8rUPcFILbcTP2NvNknkuwv95jUxZtgRZYFCrWBxrp0V5OaiKIAVvULw0AS0TdQrw
         6AGrvgTcF6ESO7BSyo8CT9/QncuulhiMrNscSB2lsoUQjAqOfY+jHGrVBexYV2kzk/ME
         EGcU84B0cnwK1KzQu4ro5Zm2krp0GNvDEo0rQzprP4hVGqUPOyU2sevPV9vGUyOGFydq
         utIw==
X-Gm-Message-State: AOAM531ZjLFb3CljzA1xpqjy/c2TejXQsfBIyVJ2ViZZtm13PWvgtUO9
        POtlkZCVfbQEUYqqpuUTtj0buTCBomw=
X-Google-Smtp-Source: ABdhPJxJ3kbrG3CzkWVFxLbWRg/SZdFJbDUvZtBH6WTrBHnqA7P87TsCDXfFxZOLlVEkMLNQdrLz8w==
X-Received: by 2002:a19:dc06:: with SMTP id t6mr817936lfg.539.1601111286952;
        Sat, 26 Sep 2020 02:08:06 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:4850:6d74:c94:bdc6:ff06:f208? ([2a00:1fa0:4850:6d74:c94:bdc6:ff06:f208])
        by smtp.gmail.com with ESMTPSA id u10sm1257336lfr.33.2020.09.26.02.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2020 02:08:06 -0700 (PDT)
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
To:     Tony Asleson <tasleson@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-2-tasleson@redhat.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <1cfc145b-180a-d906-5d9b-638c483177c7@gmail.com>
Date:   Sat, 26 Sep 2020 12:08:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200925161929.1136806-2-tasleson@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 25.09.2020 19:19, Tony Asleson wrote:

> Function callback and function to be used to write a persistent
> durable name to the supplied character buffer.  This will be used to add
> structured key-value data to log messages for hardware related errors
> which allows end users to correlate message and specific hardware.
> 
> Signed-off-by: Tony Asleson <tasleson@redhat.com>
> ---
>   drivers/base/core.c    | 24 ++++++++++++++++++++++++
>   include/linux/device.h |  4 ++++
>   2 files changed, 28 insertions(+)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 05d414e9e8a4..88696ade8bfc 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -2489,6 +2489,30 @@ int dev_set_name(struct device *dev, const char *fmt, ...)
>   }
>   EXPORT_SYMBOL_GPL(dev_set_name);
>   
> +/**
> + * dev_durable_name - Write "DURABLE_NAME"=<durable name> in buffer
> + * @dev: device
> + * @buffer: character buffer to write results
> + * @len: length of buffer
> + * @return: Number of bytes written to buffer

    This is not how the kernel-doc commenta describe the function result, IIRC...

> + */
> +int dev_durable_name(const struct device *dev, char *buffer, size_t len)
> +{
> +	int tmp, dlen;
> +
> +	if (dev && dev->durable_name) {
> +		tmp = snprintf(buffer, len, "DURABLE_NAME=");
> +		if (tmp < len) {
> +			dlen = dev->durable_name(dev, buffer + tmp,
> +							len - tmp);
> +			if (dlen > 0 && ((dlen + tmp) < len))
> +				return dlen + tmp;
> +		}
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dev_durable_name);
> +
>   /**
>    * device_to_dev_kobj - select a /sys/dev/ directory for the device
>    * @dev: device
[...]

MBR, Sergei
