Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF0EC4338F
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 16:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFA7161037
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 16:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhHCQ0C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Aug 2021 12:26:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233319AbhHCQ0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2021 12:26:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628007950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PX1LzUZWxMbs1Ca7xK69ADGz7p1q7p6YCY63lvBalNw=;
        b=TGF7iGjWGpOnaNs9+7oZfmQdjLqSdQB+x9wI9rwL4egjSccoaw9zi9KV3/54k1FZzyoCms
        CU0ewGurYba/3+8tfPZDo1bgHSQA9s8Px41z4lj39rU1mHzaHMj9nBbJV0/2YOhv9oANIB
        QSW6w4RLP/27dF2+GRfPtnk2Q5mBC7A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-GoR8gfIcNUWJ8wuh4Ryh-g-1; Tue, 03 Aug 2021 12:25:48 -0400
X-MC-Unique: GoR8gfIcNUWJ8wuh4Ryh-g-1
Received: by mail-ed1-f71.google.com with SMTP id dn10-20020a05640222eab02903bd023ea9f6so5882366edb.14
        for <linux-scsi@vger.kernel.org>; Tue, 03 Aug 2021 09:25:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PX1LzUZWxMbs1Ca7xK69ADGz7p1q7p6YCY63lvBalNw=;
        b=kODeswFbwrGtDyYvSFTSWJZVbU4j3DuMS5XSYEdOCFEfBmv08FQZwLPhxG3G6ov8ZA
         kOoWf24Aar/YtB3Hfdi28HCJdUn8768qaTOmZ8BKZ5edn+GleEd4J/lsdyAkDfjw7MU5
         7YbRNIPyXf1DcmKYNXHTyIJIEBay0cSfLYCW3FgQ1EdNGGStV6uJ+N01xAKn1vWR2Hi1
         Jhp7dVr7z6Q3s58LoVdrGq06E/5HEgRdFPW5x/gbT+mUSKTdQcBEP2a4cZurSIRGRtBv
         ASFj1n8ruKXtItIbCJa0z6YYILbxp9kmOzzU36H9jHPuQxcIroFhxccQxuBZI8Fi/uP0
         p8oA==
X-Gm-Message-State: AOAM5325WswnYDPNO3Pa00N2N68orqbc/KwYjLtUueDS7dDzZJkGqXTR
        kqcxDKaa3UcvaJNMy/WgJnxSatAkeNTxIFFTuJN9T7CnCpvHLKp+5ketWYuVaARs+V95ZrkOXOs
        PVzVEZQJG+MmfMybRZLlgra7+S27lhi2sNN5PVw==
X-Received: by 2002:a05:6402:524b:: with SMTP id t11mr11950699edd.330.1628007947721;
        Tue, 03 Aug 2021 09:25:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyg43XLgMPgISftDeQNnxLei4ATAz5KaWzBpvDfDPJzBydSSOnZqBEnNwkMjhKLPahW48KKX+cuEaDMjXh7ZRg=
X-Received: by 2002:a05:6402:524b:: with SMTP id t11mr11950679edd.330.1628007947602;
 Tue, 03 Aug 2021 09:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210803155625.GA22735@kili>
In-Reply-To: <20210803155625.GA22735@kili>
From:   Ewan Milne <emilne@redhat.com>
Date:   Tue, 3 Aug 2021 12:25:36 -0400
Message-ID: <CAGtn9r=cVQ8wM_aLW0hYOkUvDnN9AGkf5wf2ee0YbqLkHjjH4g@mail.gmail.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix use after free in debug code
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Larry Wisneski <Larry.Wisneski@marvell.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

On Tue, Aug 3, 2021 at 11:57 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The sp->free(sp); call frees "sp" and then the debug code dereferences
> it on the next line.  Swap the order.
>
> Fixes: 84318a9f01ce ("scsi: qla2xxx: edif: Add send, receive, and accept for auth_els")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/scsi/qla2xxx/qla_bsg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index 0739f8ad525a..4b5d28d89d69 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -25,12 +25,12 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
>         struct bsg_job *bsg_job = sp->u.bsg_job;
>         struct fc_bsg_reply *bsg_reply = bsg_job->reply;
>
> -       sp->free(sp);
> -
>         ql_dbg(ql_dbg_user, sp->vha, 0x7009,
>             "%s: sp hdl %x, result=%x bsg ptr %p\n",
>             __func__, sp->handle, res, bsg_job);
>
> +       sp->free(sp);
> +
>         bsg_reply->result = res;
>         bsg_job_done(bsg_job, bsg_reply->result,
>                        bsg_reply->reply_payload_rcv_len);
> --
> 2.20.1
>

