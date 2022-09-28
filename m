Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19667C32771
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 13:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbiI1NnP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 09:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiI1NnO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 09:43:14 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34466E2F4;
        Wed, 28 Sep 2022 06:43:11 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id m65so12731472vsc.1;
        Wed, 28 Sep 2022 06:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=G93x0tAkTk9UmC3wzfzA+7Kk2FVuT62V0cKnX0qkZ8I=;
        b=ZGdo+Vh9+L7/7qzQqSOlS8GtACFvttGfYOi1bLoJ8qdqMuw23y5JT6ZXQvIeA/Ez1d
         7chK/2pvkfxlrMa61hLQAZZDlZ/H/TlS6az3LOQHNzkJywPz1cOrCWHvCxF2oeik2npq
         9v7a13SkQjYP1npBrkvIRfacsgW6TQFeWHSPNnFGLteWhRPR1o4UfIR4W92Mp5q1fQdc
         adN6d8kxRwBlxd3uVWzI9zQ/EVgQyG/8mrL1Y1Y7d0wN0QL6A/ZL7msBZm/nVejXjM6Z
         tZ42E8GWGSny5i2qv1BpcOCpEaEXeb58e3v38G208yjDgkflU2F0vCJ74kNaQypJSk3a
         Vp1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=G93x0tAkTk9UmC3wzfzA+7Kk2FVuT62V0cKnX0qkZ8I=;
        b=2JepWy7fEIoLqr52XjrNx4e9eWCDH4al04Jr/x6fxbmrzB82RhfjYudqvD5DRkj5hA
         LOGff5NWoEK4w+0UHEla34qAIJ0HusW5rHewEZA9rEh8UMOL4uudn7IzO3+TKJn4M6Q9
         G3pPE+N43IREoshkAoJrxe4YaTwUwM2B9zT2wnqHZaNt8fy159vl71zWAMR4Ujuv1I3Y
         m5Nu3EbVdaaFywFPAA5/7yaXU2+sAHhY8VF+1lwkT1Caibl7sA9GDhKy8TEcmTHma4jG
         TgxupgybWvMcDld3Or3pb6UtEL3cGCceRk+u33qxyOTwqfRy5IbyrzM04QW+oJJ+nyXk
         TdeQ==
X-Gm-Message-State: ACrzQf0y+I2lc3R3LZyCAY21fMrQkssOP/EcNqKhlkSpwY7rwhDAbsXg
        uQQ7irQ5Z6YwK9Kw7ZLgNT8bZ2apSvmIect2WfhbJlQBLaSz
X-Google-Smtp-Source: AMsMyM6VadrsjsdBNjWRG5SUiMTfBCh/45oowIS2fEdSsR6Y3RJ51jov5XiD9vSDYhLa4WCwuFshRYfsMZ5gLw79pkA=
X-Received: by 2002:a67:b74a:0:b0:399:4161:9f94 with SMTP id
 l10-20020a67b74a000000b0039941619f94mr14280163vsh.1.1664372590986; Wed, 28
 Sep 2022 06:43:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220927014420.71141-1-axboe@kernel.dk> <20220927014420.71141-4-axboe@kernel.dk>
In-Reply-To: <20220927014420.71141-4-axboe@kernel.dk>
From:   Anuj gupta <anuj1072538@gmail.com>
Date:   Wed, 28 Sep 2022 19:12:34 +0530
Message-ID: <CACzX3AuMv8SZAnW66RcNHhksB1NBgKR3A5usnSwS1xDGTFzSzQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] block: allow end_io based requests in the completion
 batch handling
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, Stefan Roesch <shr@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 27, 2022 at 7:20 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> With end_io handlers now being able to potentially pass ownership of
> the request upon completion, we can allow requests with end_io handlers
> in the batch completion handling.
>
> Co-developed-by: Stefan Roesch <shr@fb.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-mq.c         | 13 +++++++++++--
>  include/linux/blk-mq.h |  3 ++-
>  2 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index a4e018c82b7c..a7dfe7a898a4 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -823,8 +823,10 @@ static void blk_complete_request(struct request *req)
>          * can find how many bytes remain in the request
>          * later.
>          */
> -       req->bio = NULL;
> -       req->__data_len = 0;
> +       if (!req->end_io) {
> +               req->bio = NULL;
> +               req->__data_len = 0;
> +       }
>  }
>
>  /**
> @@ -1055,6 +1057,13 @@ void blk_mq_end_request_batch(struct io_comp_batch *iob)
>
>                 rq_qos_done(rq->q, rq);
>
> +               /*
> +                * If end_io handler returns NONE, then it still has
> +                * ownership of the request.
> +                */
> +               if (rq->end_io && rq->end_io(rq, 0) == RQ_END_IO_NONE)
> +                       continue;
> +
>                 WRITE_ONCE(rq->state, MQ_RQ_IDLE);
>                 if (!req_ref_put_and_test(rq))
>                         continue;
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index e6fa49dd6196..50811d0fb143 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -853,8 +853,9 @@ static inline bool blk_mq_add_to_batch(struct request *req,
>                                        struct io_comp_batch *iob, int ioerror,
>                                        void (*complete)(struct io_comp_batch *))
>  {
> -       if (!iob || (req->rq_flags & RQF_ELV) || req->end_io || ioerror)
> +       if (!iob || (req->rq_flags & RQF_ELV) || ioerror)
>                 return false;
> +
>         if (!iob->complete)
>                 iob->complete = complete;
>         else if (iob->complete != complete)
> --
> 2.35.1
>
Looks good.
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

--
Anuj Gupta
