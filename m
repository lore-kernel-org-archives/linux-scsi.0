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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53526C433E3
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 09:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32AD3206EB
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 09:15:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u7hXMJL2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgGYJP0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jul 2020 05:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGYJP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2020 05:15:26 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA81AC0619D3;
        Sat, 25 Jul 2020 02:15:24 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id i80so6436517lfi.13;
        Sat, 25 Jul 2020 02:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q598yg2m0PUlnILub3Vz8jQxuEisjOi7wdvkLAOFFtk=;
        b=u7hXMJL2rn5tcuPeUfpXEileV3rCUnwOYEeuEvIfutexcbUJOV9o5oBVLDxs8/VEK5
         SxeHl6TwFfg5pJ8SQRgjCc8/wnc9BPKHqzDR1VX6z4DvpNlOUkN84AOgAqGjJPpUwoTb
         OqsIkb7RJ55WRASjz9JC4nKDuhtZCtNK38sz2wok8NtFUyeNQTKgJg/hqwiKM5kvE5G4
         kenjwAuoHuXX3OhIu1pWb6auQkUUulFT/xe6eBE96RVLhAYa6zox3OtoCHo1Lp/Wpijf
         7UC+ZTHHLdRinIfhaVZ0fSi8/7lgwQfRGC58BfhmqBgBpdaypZCxcENlweABmZvuTXuR
         YWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Q598yg2m0PUlnILub3Vz8jQxuEisjOi7wdvkLAOFFtk=;
        b=FSO+ulog95U78l0JyEjj8pLjzHh1iBe9sps1aRfVXK29rX5f4N0ROqrfoW7DkfmKDc
         J5cifyw72aZ7OaMTInviPJ4pp4JQv+pj7a31EPlRgYfpaYVXKRzkOSCjEzmsORIncOub
         xvHSH8coKi7cP38yQYs8mHqCQGOy50s3SyVrYdHcbFIs+UlT8lCDBONSwHxKdLhctNjQ
         QW7UWwhuXrQdyRJ/M8XqbodE0UwLlsb7CeB8GCvD2g/gJuOZR5VTAm19sUNRvWZ/zADd
         gwq8iTQIXhl8mYQt12Y+ldhY5An67oP46aTHqGIcu34yZuiCWru0+IZg+k7LW2brMED/
         GWDQ==
X-Gm-Message-State: AOAM531V4sg6NS1sR4ZE9bmVYvZVdBtdeWgjUrC0HtrfYng9GjyZ6YOL
        ssJkRMh+9CraQLqC5t1IJI8=
X-Google-Smtp-Source: ABdhPJzSI02+zXkdOzdwxAcWJhjfCwCp9rYtujf5W6t7k/cbJLjFAwQkI1LCmU7RPD8NiMC64aRwpg==
X-Received: by 2002:a05:6512:3195:: with SMTP id i21mr7175297lfe.131.1595668523342;
        Sat, 25 Jul 2020 02:15:23 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:253:4416:cc94:657b:2972:b01d? ([2a00:1fa0:253:4416:cc94:657b:2972:b01d])
        by smtp.gmail.com with ESMTPSA id r16sm875637ljn.42.2020.07.25.02.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2020 02:15:22 -0700 (PDT)
Subject: Re: [v4 10/11] print_req_error: Use durable_name_printk_ratelimited
To:     Tony Asleson <tasleson@redhat.com>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        b.zolnierkie@samsung.com, axboe@kernel.dk
References: <20200724171706.1550403-1-tasleson@redhat.com>
 <20200724171706.1550403-11-tasleson@redhat.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <7b9b1f8a-2438-2c15-df93-a1e3a57269ac@gmail.com>
Date:   Sat, 25 Jul 2020 12:15:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724171706.1550403-11-tasleson@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24.07.2020 20:17, Tony Asleson wrote:

> Replace printk_ratelimited with one that adds the key/value
> durable name to log entry.
> 
> Signed-off-by: Tony Asleson <tasleson@redhat.com>
> ---
>   block/blk-core.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 9bfaee050c82..a1f35e3e21d8 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -213,12 +213,15 @@ EXPORT_SYMBOL_GPL(blk_status_to_errno);
>   static void print_req_error(struct request *req, blk_status_t status,
>   		const char *caller)
>   {
> +	struct device *dev;
>   	int idx = (__force int)status;
>   
>   	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(blk_errors)))
>   		return;
>   
> -	printk_ratelimited(KERN_ERR
> +	dev = (req->rq_disk) ? disk_to_dev(req->rq_disk) : NULL;

    The 1st () not necessary, here iand in the next patch...

[...]

MBR, Sergei
