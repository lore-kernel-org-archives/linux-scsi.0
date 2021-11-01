Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BCBC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 16:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5F83611F2
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 16:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhKAQ7F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 12:59:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231303AbhKAQ7E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 12:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635785791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mfuVTEKtPZu4oGKU5CQj62mdS9UTfznANVeOzt6yo5M=;
        b=XwQhINaMF8PJN8POI9CYIsIOKv0cQcdjPmMVnVNU9ZTfX4r2Y6axXWJWbDI4MbLVzlgAHv
        +nd7NGuPhGiiSBRj+jyrt0XJPXDFQpDQnWExW4m2P68zLtHoDol+qdV/9b9cgf9pBDnwbw
        rbImXNe9rqUBUqtn9DP96HEE6fe0NkA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-qpy2G2MWMVC6bDJky6GPug-1; Mon, 01 Nov 2021 12:56:29 -0400
X-MC-Unique: qpy2G2MWMVC6bDJky6GPug-1
Received: by mail-qt1-f198.google.com with SMTP id k1-20020ac80201000000b002a7200b449eso12499536qtg.18
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2021 09:56:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mfuVTEKtPZu4oGKU5CQj62mdS9UTfznANVeOzt6yo5M=;
        b=DqI5mgYCqL/SWmmXV8duXwgSRS3/sdo6T719XHhvds7E/iBDCTfuj7Tqybc2dHbyZB
         jeufeXook9K5TdrqkIGLj3SxC70sJVfh42pVshvsBts2oEqeM49C54NkQoziGkXYvjIf
         PvZ+x4sn005d3Cy9Go0vhxcv/MKqyBOPJWkfwU6wK/ubE9L9WeqaHNBt51nP3O5XGufW
         fImFwfGY0TSFX2ADOqg8gBVCn93y+hK9er6Ycv3j2Jp4qpAsBS+XKyoImJBjgCZ1D+eL
         W7kN6ke/7ctSkaIDKiPh781JlEIHsCyKgagUBOelW5GvVKXpWoktGfkpwRll9UXz9gr7
         s6cw==
X-Gm-Message-State: AOAM530PHqiRmd+qIuBJH0MIsYgoWPyi0uBtgxN/Cv5rkRbj94eGKxW3
        M+nHj/qqNnjl3nyJzlwUP+BPPR05o3mqKkVZsNwa14XE5pWHI8iHjDBHzGKFtrAB0aWeDkVyItO
        rYK8H6YmEdeHDL7dFZAiK
X-Received: by 2002:a0c:fa07:: with SMTP id q7mr29081302qvn.18.1635785789550;
        Mon, 01 Nov 2021 09:56:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxh4wJKFaHJKXShFvRsJDDiN/gGiV8SeRubZYTL3eGqZM/PtHnVS+1hVdsIppxoO3JwPYaACw==
X-Received: by 2002:a0c:fa07:: with SMTP id q7mr29081280qvn.18.1635785789312;
        Mon, 01 Nov 2021 09:56:29 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id i1sm114002qkn.67.2021.11.01.09.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:56:28 -0700 (PDT)
Date:   Mon, 1 Nov 2021 12:56:27 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Yi Zhang <yi.zhang@redhat.com>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCH 3/3] dm: don't stop request queue after the dm device is
 suspended
Message-ID: <YYAcO1GAEGK7f3XI@redhat.com>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
 <20211021145918.2691762-4-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021145918.2691762-4-ming.lei@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 21 2021 at 10:59P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> For fixing queue quiesce race between driver and block layer(elevator
> switch, update nr_requests, ...), we need to support concurrent quiesce
> and unquiesce, which requires the two call to be balanced.
> 
> __bind() is only called from dm_swap_table() in which dm device has been
> suspended already, so not necessary to stop queue again. With this way,
> request queue quiesce and unquiesce can be balanced.
> 
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue quiesce/unquiesce")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/dm.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 7870e6460633..727282d79b26 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1927,16 +1927,6 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
>  
>  	dm_table_event_callback(t, event_callback, md);
>  
> -	/*
> -	 * The queue hasn't been stopped yet, if the old table type wasn't
> -	 * for request-based during suspension.  So stop it to prevent
> -	 * I/O mapping before resume.
> -	 * This must be done before setting the queue restrictions,
> -	 * because request-based dm may be run just after the setting.
> -	 */
> -	if (request_based)
> -		dm_stop_queue(q);
> -
>  	if (request_based) {
>  		/*
>  		 * Leverage the fact that request-based DM targets are
> -- 
> 2.31.1
> 

I think this is fine given your previous commit (b4459b11e8f dm rq:
don't queue request to blk-mq during DM suspend).

Acked-by: Mike Snitzer <snitzer@redhat.com>

Jens: given this series fixes a 5.16 regression in srp test, please
pick it up for 5.16-rc

Thanks,
Mike

