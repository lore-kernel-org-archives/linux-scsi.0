Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2163C2B9F4
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 20:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCEF960C41
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 20:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhFSUIO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Jun 2021 16:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhFSUIN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Jun 2021 16:08:13 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F404C061574
        for <linux-scsi@vger.kernel.org>; Sat, 19 Jun 2021 13:06:02 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id q10so15020866oij.5
        for <linux-scsi@vger.kernel.org>; Sat, 19 Jun 2021 13:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tsq4KAidKpjXCFYbwyu6taW/MJwvHemf/+UCmUWJRoA=;
        b=NFuyM1G5kuHnkw+GCg6jilvdF5j0m0ONaA/3lDjmkfqpNqdavMNPMfjZ/z9offO5N/
         /oSETKqFqOFXmSjotVclBUbrnQmcAiGM3jto6fP/1H0WTV9JEfJEzPSPQn94wxpg8KnA
         fE8Rupm30dw+jZAqI+H9EzjvbXa7l1gba7xn05xuVCkBgWEFoeh5Sk216TEumoHJNSQu
         83oFOaFpnqqKy5u3T6YUJHI+4F2vQfo45QpyictLuRnxGpOHmjQ1O29ZOGVe32msAuqF
         73jXmrohWr/MeWHYulCmJ3sHCXzdwDiwIEvazGzxiSAdUSFQUQhiflea0aMz4hpdYn3/
         9+pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Tsq4KAidKpjXCFYbwyu6taW/MJwvHemf/+UCmUWJRoA=;
        b=MoYc6McKr3zRmbqteYuJkCEHiYTQPBc5liCT5fqiO72jHw/JXofPw4h/helc9z7ug8
         /FDHZKuVDc63EXxJjRm3oIdyKTR57+1V/ZHFJ/oRcjhBMUWHLukFXFCT6hQipL6AyPnE
         dXs2cBvw9rukOpkePmE8yKhcaXbx9ZFw1Qx3qOhYf7m10S7oHm0nyKRY5I/4oz+qRKXB
         k62mN8C6FpIWWAqDEpsPJPfgEsR0WZq0YksmnEMleJfdu7jyK0ZhM5QwDik06pnOyjpT
         Y8HhqF96UKMQEKVe0DCp7h+YMkTipK5P4qwgr0I9P9fIY2HQ6kA9PyQ67+O6CAywabdf
         HLKg==
X-Gm-Message-State: AOAM531g02k+kVSFe+GsfTR9r1JLAizZiK0JbS9++/S6hMHFSTezCf5U
        4E1hCUh6NAttWBlt0ZsFBos=
X-Google-Smtp-Source: ABdhPJwbxv7p9uRklw7euS9r/Svl4wT0OyTTi7r0JVKAWz0OSq53dxerwu0nMV+X8fvgv9D95vVlsQ==
X-Received: by 2002:a54:4612:: with SMTP id p18mr20018427oip.87.1624133162007;
        Sat, 19 Jun 2021 13:06:02 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c21sm2631212ooj.33.2021.06.19.13.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 13:06:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 19 Jun 2021 13:05:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Jiri Slaby <jslaby@suse.com>
Subject: Re: [PATCH 1/2] virtio_scsi: do not overwrite SCSI status
Message-ID: <20210619200559.GA3817313@roeck-us.net>
References: <20210610135833.46663-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610135833.46663-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 10, 2021 at 03:58:33PM +0200, Hannes Reinecke wrote:
> When a sense code is present we should not override the scsi status;
> the driver already sets it based on the response from the hypervisor.
> 
> Fixes:  464a00c9e0ad ("scsi: core: Kill DRIVER_SENSE")
> Signed-off-by: Hannes Reinecke <hare@suse.de>

As may be known by now, scsi-virtio support in linux-next is broken.
The problem bisects to "scsi: core: Kill DRIVER_SENSE", and this patch
fixes the problem.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

> ---
>  drivers/scsi/virtio_scsi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index fd69a03d6137..43177a62916a 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -161,7 +161,6 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  		       min_t(u32,
>  			     virtio32_to_cpu(vscsi->vdev, resp->sense_len),
>  			     VIRTIO_SCSI_SENSE_SIZE));
> -		set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
>  	}
>  
>  	sc->scsi_done(sc);
> -- 
> 2.26.2
> 
