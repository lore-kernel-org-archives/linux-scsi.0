Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712DBC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 20:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiBIUJo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 15:09:44 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiBIUJn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 15:09:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46BE8E0565A8
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 12:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644437383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XMZyvn3lF8qS3DySUMK1KNFNjwl3nWwZezAf+dkEAL8=;
        b=eRLSdMlnKjKrwnqhshXusNPcD3WjLQHbLuojaw0YlKo8ExlR+s60WY5VlAMZ+ITidGdUJJ
        t+25F82DeW9c4nUBsV2T++GXCDI0fst/NJLWHqX9z43N9uPIuAabN/0HDqeM1+3Hlijp/t
        aTwu31kJmrIw9UcXyuDa2iLT4NKpOOU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-6gR56-jgNjiwE1kEP1VKAg-1; Wed, 09 Feb 2022 15:09:41 -0500
X-MC-Unique: 6gR56-jgNjiwE1kEP1VKAg-1
Received: by mail-lj1-f197.google.com with SMTP id u4-20020a2e8544000000b0023aeea9107dso1542481ljj.21
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 12:09:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XMZyvn3lF8qS3DySUMK1KNFNjwl3nWwZezAf+dkEAL8=;
        b=ZMuJ1JBpXNtRt4Gv6ltWZELItQ4jEF0Mjg+eIJ0fyWmPh/XTtxF56ESrpA/odUz4Ig
         MCHH5zQjuEok6sXG6wtWBFpRw8h1gluwys++cr3bS9gEKDWfqE56tpPB5HEZwO+2tVcn
         1VUP5TMm8QdP5pVhchrnswKNpTVSTw43fP1+AwwFg9n+NGZ0rVyWHgrEvJgqxoBBGMuK
         Py9/XirUlBecV3B1bsd51YBJO9wvC83b+HQxWJuBdo00g4gr3Ow6+rUdw/8PBO0Yx7w8
         X1UBt1dmVg96RWNBHyPgKKa01LfVtzLTVwAh4C485R2Z5KKEQHblhigQlOy1GrWmoBkU
         KZsA==
X-Gm-Message-State: AOAM533me5w9m6+aC9Dz95nx4OkysX05cReN4xGsiatG0zZvJWAXCNZW
        HBaTPJM/b3MZyoFu+g23HvqSPQSFiNGyjLY9TVPr13TsrtRnBYwnkAsavVMtNXoBKMNrHU5SvxJ
        ET8WVa4V2D9tByo1Bb8t2ZxqbCnQs71IlmHRfhw==
X-Received: by 2002:a2e:a4ce:: with SMTP id p14mr2630731ljm.384.1644437380280;
        Wed, 09 Feb 2022 12:09:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzYGF60Cdr2qkL8tSIqmg9MaO4XSTyIfa3co1sJy34TcGPT43lSTaHjlolkGdtSGHLBNNqwCy5c4CoQV+E99WI=
X-Received: by 2002:a2e:a4ce:: with SMTP id p14mr2630715ljm.384.1644437379981;
 Wed, 09 Feb 2022 12:09:39 -0800 (PST)
MIME-Version: 1.0
References: <20220208093946.4471-1-njavali@marvell.com>
In-Reply-To: <20220208093946.4471-1-njavali@marvell.com>
From:   Ewan Milne <emilne@redhat.com>
Date:   Wed, 9 Feb 2022 15:09:28 -0500
Message-ID: <CAGtn9rnZZy9cENPt0hE4okN20BNTbWK0c0Jj7-RwdaAMmZW3Rw@mail.gmail.com>
Subject: Re: [PATCH] qla2xxx: Add qla2x00_async_done routine for async routines.
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks, that appears to have resolved the crash on boot I was seeing.

Tested-by: Ewan D. Milne <emilne@redhat.com>

On Tue, Feb 8, 2022 at 4:40 AM Nilesh Javali <njavali@marvell.com> wrote:
>
> From: Saurav Kashyap <skashyap@marvell.com>
>
> This done routine will delete the timer and check for it's return
> value and accordingly decrease the reference count.
>
> Fixes: 31e6cdbe0eae ("scsi: qla2xxx: Implement ref count for SRB")
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_iocb.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 7dd82214d59f..5e3ee1f7b43c 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2560,6 +2560,20 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
>         }
>  }
>
> +static void
> +qla2x00_async_done(struct srb *sp, int res)
> +{
> +       if (del_timer(&sp->u.iocb_cmd.timer)) {
> +               /*
> +                * Successfully cancelled the timeout handler
> +                * ref: TMR
> +                */
> +               if (kref_put(&sp->cmd_kref, qla2x00_sp_release))
> +                       return;
> +       }
> +       sp->async_done(sp, res);
> +}
> +
>  void
>  qla2x00_sp_release(struct kref *kref)
>  {
> @@ -2573,7 +2587,8 @@ qla2x00_init_async_sp(srb_t *sp, unsigned long tmo,
>                      void (*done)(struct srb *sp, int res))
>  {
>         timer_setup(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout, 0);
> -       sp->done = done;
> +       sp->done = qla2x00_async_done;
> +       sp->async_done = done;
>         sp->free = qla2x00_sp_free;
>         sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
>         sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
> --
> 2.23.1
>

