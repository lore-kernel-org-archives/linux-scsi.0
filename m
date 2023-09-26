Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894F3E7F128
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 20:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbjIZUmj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 16:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbjIZUmh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 16:42:37 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FE9121;
        Tue, 26 Sep 2023 13:42:30 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1c47309a8ccso79454315ad.1;
        Tue, 26 Sep 2023 13:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695760950; x=1696365750;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nFirs3a2dJlXlflKvwTL4w4i69/0aKC6EzTD/RsrBrg=;
        b=KXM0qmKddKIQGQ6QlP3gP/SBxZ/EOXZ2WdbWHOEwC/IZQ0w2P3qmqwiijKMewm730z
         pgmkIq6psmCu61HNQXXKeuHFGYepZX070OGbrf29vPS9QdmlTq7lXSJVPKxHhbd9oaa9
         MSku//lfEed4WoIs9gxlcDyvSIokp03gqvKvU2kugjGiNHZV1tslPwQYxuUF8qwYfrFZ
         RCdUvW2jNotGcuSu3WtTH7GfwA9kWpfXje2ZgX6+IZ62O89mnuroFJ/1v5V4mjHukDhe
         1qNP3wv3ktBbf0+rU2TvQbm+Z0m3Wclt1xSOYUqfgbJkLGc9WXUMw/lYj4SyV5cTHK0m
         1iRQ==
X-Gm-Message-State: AOJu0Yw+qnvcoReWRzavyRdCOjWlFMZi/lJJTYb/WtZb5Z3gSh8segWe
        6gd+ZEQoSOp3J5Dry9N3n/M=
X-Google-Smtp-Source: AGHT+IGvdjkSzAdf4+xtWTo5fRiNaDoKSXjD1Rp6l2jFft8ctuW78khLlQUi68T1isCkISewUidhbQ==
X-Received: by 2002:a17:902:ecca:b0:1c3:432f:9f69 with SMTP id a10-20020a170902ecca00b001c3432f9f69mr26490plh.23.1695760950244;
        Tue, 26 Sep 2023 13:42:30 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a80d:6f65:53d4:d1bf? ([2620:15c:211:201:a80d:6f65:53d4:d1bf])
        by smtp.gmail.com with ESMTPSA id c24-20020a170902d91800b001bf846dd2d0sm11479149plz.13.2023.09.26.13.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 13:42:29 -0700 (PDT)
Message-ID: <2f7f884b-d4ce-4908-a69c-4110d9ee5907@acm.org>
Date:   Tue, 26 Sep 2023 13:42:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/23] scsi: Remove scsi device no_start_on_resume flag
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230923002932.1082348-1-dlemoal@kernel.org>
 <20230923002932.1082348-13-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230923002932.1082348-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/23 17:29, Damien Le Moal wrote:
> The scsi device flag no_start_on_resume is not set by any scsi low
> level driver. Remove it. This reverts the changes introduced by commit
> 0a8589055936 ("ata,scsi: do not issue START STOP UNIT on resume").
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   drivers/scsi/sd.c          | 13 ++++---------
>   include/scsi/scsi_device.h |  1 -
>   2 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index bff8663be7e0..e372834bf56f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3900,20 +3900,15 @@ static int sd_resume(struct device *dev, bool runtime)
>   	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
>   		return 0;
>   
> -	if (!sd_do_start_stop(sdkp->device, runtime)) {
> -		sdkp->suspended = 0;
> -		return 0;
> -	}
> -
> -	if (!sdkp->device->no_start_on_resume) {
> +	if (sd_do_start_stop(sdkp->device, runtime)) {
>   		sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
>   		ret = sd_start_stop_device(sdkp, 1);
> +		if (!ret)
> +			opal_unlock_from_suspend(sdkp->opal_dev);
>   	}
>   
> -	if (!ret) {
> -		opal_unlock_from_suspend(sdkp->opal_dev);
> +	if (!ret)
>   		sdkp->suspended = 0;
> -	}
>   
>   	return ret;
>   }

I'm fine with removing the no_start_on_resume member but it seems to me
that the above patch makes sd_resume() harder to read. I like the
original approach (early return if sd_do_start_stop() returns false)
better than the new approach (set ret inside an if-statement and clear
sdkp->suspended after the sd_start_stop_device() call if ret == 0).

In case others prefer the new flow: shouldn't that new flow have been
introduced in patch 4/23 of this series instead of in this patch?

Thanks,

Bart.
