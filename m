Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521CAC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 18:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E4FE207F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 18:43:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G4QaABg+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732453AbgG1SnV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 14:43:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38798 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729591AbgG1SnU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2020 14:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595961797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rCxPwUVvYI5o95/fP/7NQlsxudfNHqvls2BKBz4S0eM=;
        b=G4QaABg+TNjWyrAN+vGdMNL9f+FxD4GxLfFpL11nrRux102kI4NZnm7kQGs2St5wFZ+Bkd
        GFh4AsmKk97naE8ItQkAyOeMJRxjEyKmcMlmdPNfEHKMmzZG7jo+XNr8SwX5rwwsEYRyNm
        +rzv2V5gKSQGwEz6qzQYqHiWiGVTsNI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-ekDa02hzNGy8zyHTc4ndJg-1; Tue, 28 Jul 2020 14:43:15 -0400
X-MC-Unique: ekDa02hzNGy8zyHTc4ndJg-1
Received: by mail-qv1-f71.google.com with SMTP id l14so5394049qvz.16
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2020 11:43:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rCxPwUVvYI5o95/fP/7NQlsxudfNHqvls2BKBz4S0eM=;
        b=NXVDihLMb7qBW6M9YHWx2O6ttvcadAKMN5fTYQ6RTbmrlbGJJ9ykO5GLQZAdkwGYCr
         qByy48N4sTr1ml9gEsMU/3hFFgyNNtw0+O6YzC0URSgrPzyt4xXmPpbBhX6LevVCquGq
         A7eSm4oH8SccXJS/mcgUBabSY3QBWIC0oJRNsTp7Cn57cDd9XhTy6S11ba/SlA+BZhiK
         +lknr/1WjZZXMSxdMkdBquMH5DAVlJf0M5NuzKmnWeR9adZXWP0ezMed0cxXdwQsAmHb
         aYuG5bSrkfzFuCH7o9TlVh+8YwStOXGD0TEf2Ht3ICzQ7rpQf+uuvtsXuuevGgO6sDsh
         DFTg==
X-Gm-Message-State: AOAM530S7cfwMmCCewCYWZOlOpmoZnLKITNekG6TkI0RYFrdzGxaiTu9
        SMQrly3lGnWqNGz15pchw5+Qg8W6NSSxvcJkfl1SEND26goGmAXDEcDuMBQp/kDY05ITU5m/p9g
        w4j+GoZJTo+8jzzl1qGaDtA==
X-Received: by 2002:ad4:4c09:: with SMTP id bz9mr27396362qvb.210.1595961795303;
        Tue, 28 Jul 2020 11:43:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGDST4w1ueiDW8RjT0ado54QBAPIjhROzYB8y7zuzxf+hex3sPRKQ2IixZ32VL41l33BnafA==
X-Received: by 2002:ad4:4c09:: with SMTP id bz9mr27396343qvb.210.1595961795053;
        Tue, 28 Jul 2020 11:43:15 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id z17sm20521413qki.95.2020.07.28.11.43.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 11:43:14 -0700 (PDT)
Message-ID: <d8c4f8e27ff77b85588ee237b2b3e408c91839c7.camel@redhat.com>
Subject: Re: [PATCH] scsi_transport_srp: sanitize scsi_target_block/unblock
 sequences
From:   Laurence Oberman <loberman@redhat.com>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Date:   Tue, 28 Jul 2020 14:43:13 -0400
In-Reply-To: <20200728134833.42547-1-hare@suse.de>
References: <20200728134833.42547-1-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-07-28 at 15:48 +0200, Hannes Reinecke wrote:
> The SCSI midlayer does not allow state transitions from SDEV_BLOCK
> to SDEV_BLOCK, so calling scsi_target_block() from
> __rport_fast_io_fail()
> is wrong as the port is already blocked.
> Similarly we don't need to call scsi_target_unblock() afterwards as
> the
> function has already done this.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_transport_srp.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_srp.c
> b/drivers/scsi/scsi_transport_srp.c
> index d4d1104fac99..cba1cf6a1c12 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -395,6 +395,10 @@ static void srp_reconnect_work(struct
> work_struct *work)
>  	}
>  }
>  
> +/*
> + * scsi_target_block() must have been called before this function is
> + * called to guarantee that no .queuecommand() calls are in
> progress.
> + */
>  static void __rport_fail_io_fast(struct srp_rport *rport)
>  {
>  	struct Scsi_Host *shost = rport_to_shost(rport);
> @@ -404,11 +408,7 @@ static void __rport_fail_io_fast(struct
> srp_rport *rport)
>  
>  	if (srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST))
>  		return;
> -	/*
> -	 * Call scsi_target_block() to wait for ongoing shost-
> >queuecommand()
> -	 * calls before invoking i->f->terminate_rport_io().
> -	 */
> -	scsi_target_block(rport->dev.parent);
> +
>  	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
>  
>  	/* Involve the LLD if possible to terminate all I/O on the
> rport. */
> @@ -570,8 +570,6 @@ int srp_reconnect_rport(struct srp_rport *rport)
>  		 * failure timers if these had not yet been started.
>  		 */
>  		__rport_fail_io_fast(rport);
> -		scsi_target_unblock(&shost->shost_gendev,
> -				    SDEV_TRANSPORT_OFFLINE);
>  		__srp_start_tl_fail_timers(rport);
>  	} else if (rport->state != SRP_RPORT_BLOCKED) {
>  		scsi_target_unblock(&shost->shost_gendev,

This looks OK to me but I guess its alwasy worked by just ignoring it
being called or IU would have seenm issues.
I etest that stuff pretty heavily.
Reviewed-by: Laurence Oberman <loberman@redhat.com>

