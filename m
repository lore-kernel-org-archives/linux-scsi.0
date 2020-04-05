Return-Path: <SRS0=3U4t=5V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4A2C2BA17
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 16:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E88F20659
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 16:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XGTA92Uo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgDEQ0y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Apr 2020 12:26:54 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:39172 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgDEQ0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Apr 2020 12:26:54 -0400
Received: by mail-ua1-f65.google.com with SMTP id i22so287996uak.6
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2020 09:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z6T7ksURYXKLZGeHSyOCL3A1tNfq7XKqIZYcBs2Q8Mk=;
        b=XGTA92UoUx+18PteLh/M5XPPWiyGCoyO0TpycRQaJ3yy9na9WoTpAYQue98Z8XHztd
         ET7qSbFaFeY/zA4KtjO5TB6cx2P/T9AyqQJqpHPESPxTj4MlpRKi3vjyvLj9v26XSoFY
         uGj4taDxve29elSJ4bx++oVHe6bWOUdOYWaWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z6T7ksURYXKLZGeHSyOCL3A1tNfq7XKqIZYcBs2Q8Mk=;
        b=Fc2XXOODJknBKO+9FC7M4rm2Mahp4/hj6lt5XQTSe+uC6c2qRlCqWaHZ1jrldfjFGG
         jrGESzzg/88HVL81a39LS65khW8M6lbsNZrq57vlYvKfFGcCJblTWJWoA6eS2MyDzPta
         4dTIFrKyVQaxQ1iLD3CAHjZdSc0RELl9/Q4sA9U7uPYSdk1jGBEXot3hV/yzRKcu/86q
         BfXm8EZe5ZzcbL9qocCeQT+bioF8ONTHBdpU+IPJ7i410UZP575ZqH1WxyakmEsJ5RG0
         mMgG1lciuCUMCx11Z9WJi9Rb2RnLEBKv9Pl6dJp/bjMRU2rwgvwEMqZr3oBw2iBKZ0TA
         9/Sw==
X-Gm-Message-State: AGi0PuZSun05qikmvGlWlWppq9Rz2CHAZXTOHRSIwZ+OWFK1QhK4hE08
        T0pK77333T2A2zr9xaqrzLLkfTQrC1g=
X-Google-Smtp-Source: APiQypJ74Ry1Wviv/FTx1YFI/rSCHMkHuirdMenx3YuUZ1QKN2kE9a7IwJLFT6KikxGM/iR09fcFIA==
X-Received: by 2002:ab0:911:: with SMTP id w17mr12114404uag.60.1586104012622;
        Sun, 05 Apr 2020 09:26:52 -0700 (PDT)
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com. [209.85.217.52])
        by smtp.gmail.com with ESMTPSA id i26sm3394550uak.17.2020.04.05.09.26.51
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Apr 2020 09:26:52 -0700 (PDT)
Received: by mail-vs1-f52.google.com with SMTP id x206so8212182vsx.5
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2020 09:26:51 -0700 (PDT)
X-Received: by 2002:a67:2b07:: with SMTP id r7mr13151546vsr.169.1586104010954;
 Sun, 05 Apr 2020 09:26:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200402155130.8264-1-dianders@chromium.org> <20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200403013356.GA6987@ming.t460p> <CAD=FV=Ub6zhVvTj79SWPUv19RDvD0gt5EjJV-FZSbYxUy_T1OA@mail.gmail.com>
 <CAD=FV=Vsk0SjkA+DbUwJxvO6NFcr0CO9=H1FD7okJ2PxMt5pYA@mail.gmail.com> <20200405091446.GA3421@localhost.localdomain>
In-Reply-To: <20200405091446.GA3421@localhost.localdomain>
From:   Doug Anderson <dianders@chromium.org>
Date:   Sun, 5 Apr 2020 09:26:39 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WQZA7PGEbv_fKikGOEijP+qEEZgYXWifgjDzV6BVOUMQ@mail.gmail.com>
Message-ID: <CAD=FV=WQZA7PGEbv_fKikGOEijP+qEEZgYXWifgjDzV6BVOUMQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] blk-mq: Rerun dispatching in the case of budget contention
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Salman Qazi <sqazi@google.com>,
        linux-block <linux-block@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Guenter Roeck <groeck@chromium.org>,
        Ajay Joshi <ajay.joshi@wdc.com>, Arnd Bergmann <arnd@arndb.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hou Tao <houtao1@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Sun, Apr 5, 2020 at 2:15 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> @@ -103,6 +104,9 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
>                 rq = e->type->ops.dispatch_request(hctx);
>                 if (!rq) {
>                         blk_mq_put_dispatch_budget(hctx);
> +
> +                       if (e->type->ops.has_work && e->type->ops.has_work(hctx))
> +                               blk_mq_delay_run_hw_queue(hctx, BLK_MQ_BUDGET_DELAY);

To really close the race, don't we need to run all the queues
associated with the hctx?  I haven't traced it through, but I've been
assuming that the multiple "hctx"s associated with the same queue will
have the same budget associated with them and thus they can block each
other out.

-Doug
