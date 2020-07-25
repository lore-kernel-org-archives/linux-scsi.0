Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFACDC433E3
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 09:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9A74206EB
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 09:05:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oi+Pr/Ns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgGYJFl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jul 2020 05:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGYJFl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2020 05:05:41 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBBCC0619D3;
        Sat, 25 Jul 2020 02:05:41 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id b30so6431638lfj.12;
        Sat, 25 Jul 2020 02:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lBqWR5j4t0yuchVZX2lSk3WHc2oz3Eo2sq0evh7hl7I=;
        b=Oi+Pr/NsgYuNWbP43HLNuLGti/JGGwWRHsO8P6vND/72PchlDlR5EeD6nkCGJGhhTl
         HdiG4BFDqivnSaNX7G7B/XUqZKx4JXbATiKDelg34I6vob5e5AK0xeogIy/DnwjCizXE
         UIodbwEg7K/kNEjayUkvOkA2rjInuQjahgIWveRTyPnJrU1Ys8zTE55TZGKCqDoCU64e
         uI+/Rzn9BYQ5gY08JbQdJlPs8lzzpJhhhhKDfjNVxQH3xvp7mTY4QufLmd+8DEvxLG99
         VK0wyPtooM5UgCm1gp5/FqQmnvwcE0TgwO0uu7ihrPyICI2CmDOpTEss70v/+D6Bx/qD
         mySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lBqWR5j4t0yuchVZX2lSk3WHc2oz3Eo2sq0evh7hl7I=;
        b=ih3znZqwTak5VUd4r0epN/Vzz+MMqOAB1bPj6etSUWpkkXBjKqD9nLPT0JEqAMOamr
         aFzHpBN+SiHR4xGBTfzEFkjCh+Y2phtyaiIBedfvpOn2K1CS3gxI1etnaIMsYGAFkX6+
         iUBReOEKzmjiMjKjnCwhShGLBkh5AQMobUaxPSITGMbOS43iP5xsPO9Z2xWJmSUNN/T4
         S5DLusNs9jltN3KoB6HFwRVkhvaRhzKygwa41nnzqjnq6wDonUsEDwIaWTjaLkGXn+66
         AzolBGRINe5BfQ/6QUrhOyvaX48Zz6VjXDY/HIDAUxTWL48WRb6SC74w7VGnH3LKfBlG
         xbEw==
X-Gm-Message-State: AOAM531/OPwUYX5coWgNNwMFQa8PkW7rbQooImFsQpGuigHpGAkU/ULG
        aHoAP04TPiNOCGdEw98t2mHrqb9er1Q=
X-Google-Smtp-Source: ABdhPJy8teDmDB5p/V8ujD+no5KZ9UfsaAhXWKajaWDkDvxb9TDUYcvuV2n4HVmu7De20Up3b9QLFg==
X-Received: by 2002:a05:6512:3317:: with SMTP id k23mr7071486lfe.111.1595667939443;
        Sat, 25 Jul 2020 02:05:39 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:253:4416:cc94:657b:2972:b01d? ([2a00:1fa0:253:4416:cc94:657b:2972:b01d])
        by smtp.gmail.com with ESMTPSA id 20sm554222ljj.51.2020.07.25.02.05.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2020 02:05:38 -0700 (PDT)
Subject: Re: [v4 05/11] nvme: Add durable name for dev_printk
To:     Tony Asleson <tasleson@redhat.com>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        b.zolnierkie@samsung.com, axboe@kernel.dk
References: <20200724171706.1550403-1-tasleson@redhat.com>
 <20200724171706.1550403-6-tasleson@redhat.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <f68275a4-9a83-2d1a-4371-7a8e61e91577@gmail.com>
Date:   Sat, 25 Jul 2020 12:05:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724171706.1550403-6-tasleson@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello!

On 24.07.2020 20:17, Tony Asleson wrote:

> Corrections from Keith Busch review comments.
> 
> Signed-off-by: Tony Asleson <tasleson@redhat.com>
> ---
>   drivers/nvme/host/core.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index f3c037f5a9ba..f2e5b91668a1 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2667,6 +2667,22 @@ static bool nvme_validate_cntlid(struct nvme_subsystem *subsys,
>   	return true;
>   }
>   
> +static ssize_t wwid_show(struct device *dev, struct device_attribute *attr,
> +			char *buf);
> +
> +static int dev_to_nvme_durable_name(const struct device *dev, char *buf, size_t len)
> +{
> +	char serial[144];	/* Max 141 for wwid_show */
> +	ssize_t serial_len = wwid_show((struct device *)dev, NULL, serial);
> +
> +	if (serial_len > 0 && serial_len < len) {
> +		serial_len -= 1;  /* Remove the '\n' from the string */

    serial_len-- instead?

> +		strncpy(buf, serial, serial_len);
> +		return serial_len;
> +	}
> +	return 0;
> +}
> +
>   static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
>   {
>   	struct nvme_sub
[...]

MBR, Sergei
