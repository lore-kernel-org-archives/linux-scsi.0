Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F77CDB47E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 18:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjJRSUL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 14:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbjJRSUK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 14:20:10 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F25113
        for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2023 11:20:08 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1c9fa869a63so35510385ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2023 11:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697653208; x=1698258008;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4xNPVnS1H+sOd5GzKVyNEKL6+yzMbdZqmAvBfEfYmsg=;
        b=thnSXs/8zUII7AINrw14BsBEf6Fz2F4v4dkImSsY0nmIG0/Kvhb1pAuhUhJxE4+stR
         tF+aqyeteqVB+jPNd9tWZ2DPkkUo02w29qJpR/MCohcLgwgdfRBK57uKH0txkWtFGa3F
         wWtf7vuXzaIxST7ELToq707qxiAwYtZJ+HS0ImyzHUGtSSrjn07SEDKqtS1yVEdlQ/7+
         ZmYWXKs4dQQz69yo34jDIYi+kitr4WNdnrL3d1YGnKDdJ2IZ2lYOGQ5AO7gwu+SBNTuz
         hyZAxun3DHQF40DWfC0F0GlsJ09hXZd/Yo8kbS2y51uITb7wpmdNeeh5/Xb0LMrxhF3s
         mtOQ==
X-Gm-Message-State: AOJu0YzPoB1KJv6sRJm0d6KYcu15Td1/BNV/5NBkRoTbgQZG0C47G/ku
        68xDlXcDCVvlPIXcBKGLvsA=
X-Google-Smtp-Source: AGHT+IFc81Rbb8yKYv26HOV7OfqkvarCSKeEM9oP+cO3zz3wYVafh7JhsDHaKlCh89YUNnbhchiITA==
X-Received: by 2002:a17:903:6c4:b0:1c9:ca02:6451 with SMTP id kj4-20020a17090306c400b001c9ca026451mr138237plb.39.1697653207665;
        Wed, 18 Oct 2023 11:20:07 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:66c1:dd00:1e1e:add3? ([2620:15c:211:201:66c1:dd00:1e1e:add3])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902ea8200b001a80ad9c599sm216596plb.294.2023.10.18.11.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Oct 2023 11:20:07 -0700 (PDT)
Message-ID: <1ca312b6-c14c-42c3-9bec-5fc11ef8a642@acm.org>
Date:   Wed, 18 Oct 2023 11:20:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20231016121542.111501-1-hare@suse.de>
 <20231016121542.111501-2-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231016121542.111501-2-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/23 05:15, Hannes Reinecke wrote:
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 022198c51350..85b1384ba4fd 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> @@ -777,7 +777,7 @@ Details::
>   
>       /**
>       *      eh_host_reset_handler - reset host (host bus adapter)
> -    *      @scp: SCSI host that contains this device should be reset
> +    *      @shp: SCSI host that contains this device should be reset

Please change this into "@shp: SCSI host that should be reset".

>   	/*  If we can't locate the host to reset, then we failed. */
> -	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
> -		printk(KERN_ERR MYNAM ": host reset: "
> -		    "Can't locate host! (sc=%p)\n", SCpnt);
> +	if ((hd = shost_priv(sh)) == NULL){
> +		printk(KERN_ERR MYNAM ": host reset: Can't locate host!\n");
>   		return FAILED;
>   	}

Please move the assignment out of the if-statement since the 
if-statement has to be modified anyway.

> -	printk(MYIOC_s_INFO_FMT "host reset: %s (sc=%p)\n",
> -	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
> +	printk(MYIOC_s_INFO_FMT "host reset: %s\n",
> +	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ));

Please consider removing the superfluous parentheses from the modified code.

>   	hostdata->eh_complete = NULL;
> -	/* Revalidate the transport parameters of the failing device */
> -	if(hostdata->fast)
> -		spi_schedule_dv_device(SCp->device);
> -
> -	spin_unlock_irq(SCp->device->host->host_lock);
> +	/* Revalidate the transport parameters for attached devices */
> +	if(hostdata->fast) {
> +		struct scsi_device *sdev;
> +		__shost_for_each_device(sdev, host)
> +			spi_schedule_dv_device(sdev);
> +	}
> +	spin_unlock_irq(host->host_lock);
>   	return SUCCESS;

Since the above changes behavior of the SPI transport, shouldn't this be 
mentioned in the patch description?

> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 72ceaf650b0d..9be45b7a2571 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -2852,21 +2852,14 @@ static bool blogic_write_outbox(struct blogic_adapter *adapter,
>   
>   /* Error Handling (EH) support */
>   
> -static int blogic_hostreset(struct scsi_cmnd *SCpnt)
> +static int blogic_hostreset(struct Scsi_Host *shost)
>   {
> -	struct blogic_adapter *adapter =
> -		(struct blogic_adapter *) SCpnt->device->host->hostdata;
> -
> -	unsigned int id = SCpnt->device->id;
> -	struct blogic_tgt_stats *stats = &adapter->tgt_stats[id];
> +	struct blogic_adapter *adapter = shost_priv(shost);
>   	int rc;
>   
> -	spin_lock_irq(SCpnt->device->host->host_lock);
> -
> -	blogic_inc_count(&stats->adapter_reset_req);
> -
> +	spin_lock_irq(shost->host_lock);
>   	rc = blogic_resetadapter(adapter, false);
> -	spin_unlock_irq(SCpnt->device->host->host_lock);
> +	spin_unlock_irq(shost->host_lock);
>   	return rc;
>   }

Why has the blogic_inc_count() call been left out?

Thanks,

Bart.
