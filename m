Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85CAC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 15:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99BFE61212
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 15:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhJTPuF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 11:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhJTPuE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 11:50:04 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3496C06161C
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 08:47:49 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id g39so15863015wmp.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 08:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V5dUc3E8xYRjRHxDa64Ps24H2rGkhTRP9vrTdU8yWzE=;
        b=xwh+5HDl11axUbn19OofzzxEzk1oFCc11uAMTDUo4qVWkoZmsVZY1c37pZYXIopGgL
         QwMAXvHTZkID+BJ9WC9HFJqfniPfPx3QJJk7hCQR8GwDhzxyJbSDILmRmpDYb13GsX3s
         dR9RGHRbOZKb2WYuD6+teSL5PegfLkcqpP1RaNMHPKPXiD3TBaBqd+jemi4oFjvWJaFg
         BoAyRw2No68vcC3DfdrS1QPD9BGFtCMglbjd2iTTDJukvwTvUvnbvTGneiStXfQV+ebG
         weUmbkErwHQCUpLhl/xmhzMvktPxQ9ku4IIr965xzFVYLCHJ+8bKLxoxR62g07th7ifq
         JjLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V5dUc3E8xYRjRHxDa64Ps24H2rGkhTRP9vrTdU8yWzE=;
        b=t2bwL3V1r8bwrMXoWYf8veIgu9UJEkq0D8wI9Q8Rp0AEoh9kyNk2ShSaVEvXswEsjo
         VZ+gmh9i3FUcEr7ooy12o7RkmEqB0FbkZyhgw8N6SUVwqSoHhre/NMaLPOKlabCODAtn
         1znEfMdU10JLi3gZ0VuYifJK173Pg69eywHlLrYk5LCoXcMddag8UA2EghQgfneEsQop
         vtaEEovkBl3uMId1cAxeVlycoDNJgETr3MUkcXS9j8lU/OJwYuI26qpRIvpWigFeWulJ
         INks/+MlFIOCZ4n4ARV3lqb0F21woEW++j6wiatDcY/V+Ua79/hWFZmtEAORU7wrIS5Z
         wvhQ==
X-Gm-Message-State: AOAM531nc0p0u3i/i7QwNmPlUwa60nzI4aelIYzQxgFpAvjem4COOXa6
        LFnxuBXbXtz2ZOjsy+EfFyKWusfFnCQCEA==
X-Google-Smtp-Source: ABdhPJytV+zF2EuYHFhOYaHgVY4QzD+WkscPKbYnywhAcDkiX9dN9ETPFpqyMdt7bJyadTVVrtaJQQ==
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr40449wrr.76.1634744868502;
        Wed, 20 Oct 2021 08:47:48 -0700 (PDT)
Received: from [192.168.86.34] (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.googlemail.com with ESMTPSA id e8sm3543288wrg.48.2021.10.20.08.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 08:47:48 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: ufshcd-pltfrm: fix memory leak due to probe
 defer
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     draviv@codeaurora.org, sthumma@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bjorn.andersson@linaro.org
References: <20210914092214.6468-1-srinivas.kandagatla@linaro.org>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <48895dce-8c26-0763-419d-9b53d7f7281b@linaro.org>
Date:   Wed, 20 Oct 2021 16:47:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210914092214.6468-1-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 14/09/2021 10:22, Srinivas Kandagatla wrote:
> UFS drivers that probe defer will endup leaking memory allocated for
> clk and regulator names via kstrdup because the structure that is
> holding this memory is allocated via devm_* variants which will be
> freed during probe defer but the names are never freed.
> 
> Use same devm_* variant of kstrdup to free the memory allocated to
> name when driver probe defers.
> 
> Kmemleak found around 11 leaks on Qualcomm Dragon Board RB5:
> 
> unreferenced object 0xffff66f243fb2c00 (size 128):
>    comm "kworker/u16:0", pid 7, jiffies 4294893319 (age 94.848s)
>    hex dump (first 32 bytes):
>      63 6f 72 65 5f 63 6c 6b 00 76 69 72 74 75 61 6c  core_clk.virtual
>      2f 77 6f 72 6b 71 75 65 75 65 2f 73 63 73 69 5f  /workqueue/scsi_
>    backtrace:
>      [<000000006f788cd1>] slab_post_alloc_hook+0x88/0x410
>      [<00000000cfd1372b>] __kmalloc_track_caller+0x138/0x230
>      [<00000000a92ab17b>] kstrdup+0xb0/0x110
>      [<0000000037263ab6>] ufshcd_pltfrm_init+0x1a8/0x500
>      [<00000000a20a5caa>] ufs_qcom_probe+0x20/0x58
>      [<00000000a5e43067>] platform_probe+0x6c/0x118
>      [<00000000ef686e3f>] really_probe+0xc4/0x330
>      [<000000005b18792c>] __driver_probe_device+0x88/0x118
>      [<00000000a5d295e8>] driver_probe_device+0x44/0x158
>      [<000000007e83f58d>] __device_attach_driver+0xb4/0x128
>      [<000000004bfa4470>] bus_for_each_drv+0x68/0xd0
>      [<00000000b89a83bc>] __device_attach+0xec/0x170
>      [<00000000ada2beea>] device_initial_probe+0x14/0x20
>      [<0000000079921612>] bus_probe_device+0x9c/0xa8
>      [<00000000d268bf7c>] deferred_probe_work_func+0x90/0xd0
>      [<000000009ef64bfa>] process_one_work+0x29c/0x788
> unreferenced object 0xffff66f243fb2c80 (size 128):
>    comm "kworker/u16:0", pid 7, jiffies 4294893319 (age 94.848s)
>    hex dump (first 32 bytes):
>      62 75 73 5f 61 67 67 72 5f 63 6c 6b 00 00 00 00  bus_aggr_clk....
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 
> with this patch no memory leaks are reported.
> Fixes: aa4976130934 ("ufs: Add regulator enable support")
> Fixes: c6e79dacd86f ("ufs: Add clock initialization support")
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---

Gentle Ping ?

This is not a critical issue, but it will be nice to get this fixed 
atleast in 5.16 release.

--srini

>   drivers/scsi/ufs/ufshcd-pltfrm.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index 8859c13f4e09..eaeae83b999f 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -91,7 +91,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
>   
>   		clki->min_freq = clkfreq[i];
>   		clki->max_freq = clkfreq[i+1];
> -		clki->name = kstrdup(name, GFP_KERNEL);
> +		clki->name = devm_kstrdup(dev, name, GFP_KERNEL);
>   		if (!strcmp(name, "ref_clk"))
>   			clki->keep_link_active = true;
>   		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
> @@ -126,7 +126,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
>   	if (!vreg)
>   		return -ENOMEM;
>   
> -	vreg->name = kstrdup(name, GFP_KERNEL);
> +	vreg->name = devm_kstrdup(dev, name, GFP_KERNEL);
>   
>   	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
>   	if (of_property_read_u32(np, prop_name, &vreg->max_uA)) {
> 
