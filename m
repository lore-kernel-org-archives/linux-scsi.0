Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8972DC07E97
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Jul 2021 18:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FEEB6162C
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Jul 2021 18:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhGCSht (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Jul 2021 14:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhGCShs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jul 2021 14:37:48 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269FCC061762
        for <linux-scsi@vger.kernel.org>; Sat,  3 Jul 2021 11:35:13 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id t3so15701668oic.5
        for <linux-scsi@vger.kernel.org>; Sat, 03 Jul 2021 11:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tc0/pGGKwBGL9SIqQXWBhP+/joras6oQZMJB7EMDN1w=;
        b=ST/5ARkMuzUDRnjQwbS6A0NVXhNSseAIzVkmxqWmyBu54epMO7RFS5nxUdW9ZdCku8
         i6y1DCHx0HiF2Nf8GByBC0uGqIuHyrI1H51rPjlWMmR+XMkSeRb3CAn/QpKX9vZYzFTW
         J0goIXOBvgaT8Ugs44XChIN0AJ2MY9REmlivW6/ndAVQcmlcXwvYpJW3OBrTJlf2mBF7
         zbSRn1vPGUMpTvw2sRqURmCVkGmpiAkGrqntd1zIGxGJqdkLMXOFEaAWtEFA38NdDJFA
         ngigEMgPpKaPkLIAF1pZAj4Vr6W/qlll39R+3gOprtIW7JzjLR0eaKOyqS+/rdhxrplt
         JC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=tc0/pGGKwBGL9SIqQXWBhP+/joras6oQZMJB7EMDN1w=;
        b=aD3TU6IgZ9YE0XBD0Fb1PqN91broHNeCzrEpijLWW/5oumW3eltTO/ESevHW/xKAJx
         ln7CHtcgWc32ixjdzmdne32Qo+Wmx56t3yOPA7CsJRnCt7DECUraOoRAUpbYEmIytKBb
         eOlHgtu/nnYcYvXzzRwsQ8Mk6U7/U8iy0Kn/TvPHcUdB86qyaeo8V0Eop6k1tMeiDrTb
         fcLR/2kkvw1XGYEHZr1HwAD454HbdpL5c4cuaCNZqTrr3y5X7itW7d5LeugQqczJBD9T
         PFFmiPug52mxpOVz6RJSvP+ab+0fNps9SYP6lMKjniPQlQqjiTqg8RLLIY79nXqCUUBx
         4oyw==
X-Gm-Message-State: AOAM5324kNUjHaB/OCefitON0rsvtKdM8tBEkKsDsMnWH8KT9OuOI9B1
        gqN6gkjzLkK/DPYdaIn+0sc=
X-Google-Smtp-Source: ABdhPJzTBS8r+dVTVt2g8/KRVCU8grsc3VmjSiDH1PjQZbBwegJjr5kfkfVo1jlHP7eiG7RburW3LQ==
X-Received: by 2002:aca:f254:: with SMTP id q81mr4573312oih.29.1625337312534;
        Sat, 03 Jul 2021 11:35:12 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bb34sm1323804oob.39.2021.07.03.11.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jul 2021 11:35:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 3 Jul 2021 11:35:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCHv2] virtio_scsi: do not overwrite SCSI status
Message-ID: <20210703183510.GA1235060@roeck-us.net>
References: <20210622091153.29231-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622091153.29231-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Tue, Jun 22, 2021 at 11:11:53AM +0200, Hannes Reinecke wrote:
> When a sense code is present we should not override the scsi status;
> the driver already sets it based on the response from the hypervisor.
> 
> Fixes:  464a00c9e0ad ("scsi: core: Kill DRIVER_SENSE")
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Tested-by: Jiri Slaby <jirislaby@kernel.org>
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>

This patch didn't make it into mainline, but commit 464a00c9e0ad is
there. This means that virtio_scsi is now broken in mainline (as of
v5.13-9356-g4b820e167bf6). Did it get lost, or is it still queued
somewhere ?

Thanks,
Guenter

> ---
>  drivers/scsi/virtio_scsi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index fd69a03d6137..ad78bf631900 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -156,12 +156,11 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  
>  	WARN_ON(virtio32_to_cpu(vscsi->vdev, resp->sense_len) >
>  		VIRTIO_SCSI_SENSE_SIZE);
> -	if (sc->sense_buffer) {
> +	if (resp->sense_len) {
>  		memcpy(sc->sense_buffer, resp->sense,
>  		       min_t(u32,
>  			     virtio32_to_cpu(vscsi->vdev, resp->sense_len),
>  			     VIRTIO_SCSI_SENSE_SIZE));
> -		set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
>  	}
>  
>  	sc->scsi_done(sc);
