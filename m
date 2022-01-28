Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EE5C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 12:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348594AbiA1MjH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 07:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348580AbiA1Mix (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 07:38:53 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD39EC061714
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 04:38:52 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id c15so8781770ljf.11
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 04:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pId8ZZaNDyplhvm8IeLXj7VMIGyfX0CfG316DkhoNyw=;
        b=l5EghrrsPvZGnhWtKRezPuxX70N2h5bmPRh9/1JKg/8c8HzvxUczlNvUijBcEavlh7
         rexgp3R7ZUObC79MqLTDhPjFQTmrcmgAJjhiT+av3GFvlUcX6EdA2/8mTTVNsLJizdwn
         zhyyx3VA7XHaH7Cc9LvlrG94LH7d7GF7Y37vtvO+HxWAezAUUzgXj7KdvWF7zc2OWsJG
         qFlKjjP35uevHrCA/Sjp5Ymo5uwnTWilKp6XxnK+VzRCT0ZVWkjD3rYpcwk179VS86t+
         xqdQQ0OWRkErPaYtQuuwnxu7FQ8S0IxY1yqpIHnu8Nel2h0UlNifTuh/QngOQWbf2UHt
         OTzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pId8ZZaNDyplhvm8IeLXj7VMIGyfX0CfG316DkhoNyw=;
        b=DIjtuY1U+mtmShsJSLYio6h8X0J2HIQjj+7OBiAwsQZ0lzaXdtR9DpUv4dC89TK3er
         Iid6G+/Z8xtEYEg+C7VCQBygpHJ0EnQeJa9VjB91WS4VdVbKEwZXfma0D1/hiigEfHcB
         z4zTV9Z+iWr3m4LnQCL0+pOWt6sOvtwYJ8C+Uw1HBLwOuvIascvq004TPwqEOCe58vMU
         F8rkVBLsHM5ljAV2Zf4DwZqA9NVHd1nRJD1d8kN6uZnIakTHGm9RIVB6Y8oL/3IYEREt
         9qftVqbF5x1C6BhHpi6Qy4ic9Rs9zX2ocfXHOXXw2vD6JYS2CaN/1sJU+kHe+O2L8ItF
         K/CQ==
X-Gm-Message-State: AOAM533Ad3zMXmBtLAQd4cvaZJqjHWf/HopU1txerZMkhPYS616MhWpH
        Yhy+7vYS0/XAqmcvbd+ynhw=
X-Google-Smtp-Source: ABdhPJy9Ylfcbd+gGMBHZ3S0Y1S9hvYmQx08yuit1mSj9qkorZpGDnaQ1NzpUOiazwCzTPmuPuE8Hw==
X-Received: by 2002:a2e:bd15:: with SMTP id n21mr5763051ljq.128.1643373530888;
        Fri, 28 Jan 2022 04:38:50 -0800 (PST)
Received: from [192.168.8.103] (m91-129-103-86.cust.tele2.ee. [91.129.103.86])
        by smtp.gmail.com with ESMTPSA id o8sm2519829lft.135.2022.01.28.04.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 04:38:50 -0800 (PST)
Message-ID: <43430aa9-58fb-bd2a-3f18-18518d2b2396@gmail.com>
Date:   Fri, 28 Jan 2022 14:38:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH] scsi: make "access_state" sysfs attribute always
 visible
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org
References: <20220125162441.2226-1-mwilck@suse.com>
From:   Julian Wiedmann <jwiedmann.dev@gmail.com>
In-Reply-To: <20220125162441.2226-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 25.01.22 18:24, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If a SCSI device handler module is loaded after some SCSI devices
> have already been probed (e.g. via request_module() by dm-multipath),
> the "access_state" and "preferred_path" sysfs attributes remain invisible for
> these devices, although the handler is attached and live. The reason is
> that the visibility is only checked when the sysfs attribute group is
> first created. This results in an inconsistent user experience depending
> on the load order of SCSI low-level drivers vs. device handler modules.
> 

I suppose you looked at sysfs_update_group(), and it's not a good fit?

> This patch changes user space API: attempting to read the "access_state"
> or "preferred_path" attributes will now result in -EINVAL rather than
> -ENODEV for devices that have no device handler, and tests for the existence
> of these attributes will have a different result.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index f1e0c131b77c..226a50944c00 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1228,14 +1228,6 @@ static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
>  	    !sdev->host->hostt->change_queue_depth)
>  		return 0;
>  
> -#ifdef CONFIG_SCSI_DH
> -	if (attr == &dev_attr_access_state.attr &&
> -	    !sdev->handler)
> -		return 0;
> -	if (attr == &dev_attr_preferred_path.attr &&
> -	    !sdev->handler)
> -		return 0;
> -#endif
>  	return attr->mode;
>  }
>  

]
