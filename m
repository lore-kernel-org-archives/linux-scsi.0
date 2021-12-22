Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B790EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 09:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239887AbhLVJhN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 04:37:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229987AbhLVJhN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 04:37:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640165832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZnAhI9l0yG82YEc6qpX6FpGYnYS2Hfg91/2R99xF2QA=;
        b=bZ1lOLxmci587ob3Ln3AtaqbeHB5SA4rLnznSoM6ymuxrOPpUT7qgn+GcYuXJuOhSqMEjm
        inNZKZ+X/dY6yi1FtAV4apEVvAiFzW/sNbrAMS6IV9fGUkkEtca6eyOKNk+rIu+akPFvjv
        7VXHurh+a9aNuK+5vQ8oX7L5VJCLo6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-Nl1vhYf1MsK4pRQm3IWRsQ-1; Wed, 22 Dec 2021 04:37:11 -0500
X-MC-Unique: Nl1vhYf1MsK4pRQm3IWRsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 463AF1006AA4;
        Wed, 22 Dec 2021 09:37:10 +0000 (UTC)
Received: from localhost (ovpn-13-187.pek2.redhat.com [10.72.13.187])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B0034101E7E1;
        Wed, 22 Dec 2021 09:37:09 +0000 (UTC)
Date:   Wed, 22 Dec 2021 17:37:07 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] sr: don't use GFP_DMA
Message-ID: <20211222093707.GA23698@MiWiFi-R3L-srv>
References: <20211222090842.920724-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222090842.920724-1-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,

On 12/22/21 at 10:08am, Christoph Hellwig wrote:
> The allocated buffers are used as a command payload, for which the block
> layer and/or DMA API do the proper bounce buffering if needed.
> 
> Reported-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Changes since v1:
>  - also cover the two callsites in sr_vendor.c
> 
> Diffstat:
>  drivers/scsi/sr.c        | 2 +-
>  drivers/scsi/sr_vendor.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
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

Thanks a lot for doing this. When I browsed the code path, I come to
blk_rq_map_kern() but I am not sure if blk_queue_may_bounce() is true in
the sr_probe() case, then it may enter into bio_map_kern().

Next I will post my original patchset to mute the allocation failure if
it's requesting page from DMA zone and DMA zone has no managed page. And
meanwhile, I will try to collect those places of kmalloc(GFP_DMA) into a
RFC mail, see if we can change them one by one. Anyone can pick one
place to fix if interested or knowing it well. Finally, we can remove the
need of dma-kmalloc() as people suggested. Any comment?

For this patch, it's an awesome start, thx.

Reviewed-by: Baoquan He <bhe@redhat.com>


>  	if (!buffer) {
>  		sr_printk(KERN_ERR, cd, "out of memory.\n");
>  		return;
> diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
> index 1f988a1b9166f..a61635326ae0a 100644
> --- a/drivers/scsi/sr_vendor.c
> +++ b/drivers/scsi/sr_vendor.c
> @@ -131,7 +131,7 @@ int sr_set_blocklength(Scsi_CD *cd, int blocklength)
>  	if (cd->vendor == VENDOR_TOSHIBA)
>  		density = (blocklength > 2048) ? 0x81 : 0x83;
>  
> -	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
> +	buffer = kmalloc(512, GFP_KERNEL);
>  	if (!buffer)
>  		return -ENOMEM;
>  
> @@ -179,7 +179,7 @@ int sr_cd_check(struct cdrom_device_info *cdi)
>  	if (cd->cdi.mask & CDC_MULTI_SESSION)
>  		return 0;
>  
> -	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
> +	buffer = kmalloc(512, GFP_KERNEL);
>  	if (!buffer)
>  		return -ENOMEM;
>  
> -- 
> 2.30.2
> 

