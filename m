Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BF4C5517A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 11:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF1B20756
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 11:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bhW8td9Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgKKLgk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 06:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgKKLga (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2020 06:36:30 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52949C0613D1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2020 03:36:29 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id k3so1791743otp.12
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2020 03:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EMOqAIj0ddsVXtMyEGECeFICuXMsW/guXX4BA4CqByM=;
        b=bhW8td9Q9ob0277HymHvg8ls4NcFHQrCNN+xqTQem62XYOm+csfmqGE3o/lvOrvYdf
         W6ydkWaRGOPvbF/Y89SmSIitX2W5tabVkT1DsXLiSU7JpKqhVBH6tfuknBFbGsMQomCu
         vEMOsIDjOv+gBEOTSbW9hc+32cvn/ivYUWgs0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EMOqAIj0ddsVXtMyEGECeFICuXMsW/guXX4BA4CqByM=;
        b=TNV+69d2yGFxnUaT4GalYlOpklszT0OugpgLttcaqwHV0SC163p86x+bdbhPFG9ZMN
         zTBmJT8GEr44+9FMphUYMBZye++vUoYgVnUxV+SyRRS3wDyYudLMvzrGNod+cPtyuHFf
         540jHWDWgWDFaN7qzc7a80t/5l9D9oAJvc5xVGAFVG4AJjtmXKyLU2h6DkrDFuVts10A
         BjLjPpYb/5W+8RDKbw0Q+fjnq+75vA9ouQaSg4VhB5y3alI+vJZsnuNKXhvqfbuX6WxI
         s5Uuw0oUQcZ1TaNmjVFvNlOsWLxhoFPufOT0qdrQYLohSITd8jhH5XXDecVtBDToMR+n
         ovZw==
X-Gm-Message-State: AOAM533vgW08H4FpoSpVK2dOsqt7RHeVKX7rqALqUV9JmhL861+IXX2n
        BO3KzWn+O0rgG+8HHEmavaDP3k7MDW1aJDm2/MEekA==
X-Google-Smtp-Source: ABdhPJyUhmXhQ+6QEB12K9KtN2u8Kz4JD7ZA9ST4TVkaOw91UuD3ZJt0F5kWbbnGXT70o9TfkwBIBbmUMw1B+VoSP0U=
X-Received: by 2002:a9d:4c92:: with SMTP id m18mr7729528otf.248.1605094588395;
 Wed, 11 Nov 2020 03:36:28 -0800 (PST)
MIME-Version: 1.0
References: <d4f86cccccc3bffccc4eda39500ce1e1fee2109a.camel@redhat.com>
 <7624d3fe1613f19af5c3a77f4ae8fe55@mail.gmail.com> <d1040c06-74ea-7016-d259-195fa52196a9@huawei.com>
 <CAL2rwxoAAGQDud1djb3_LNvBw95YoYUGhe22FwE=hYhy7XOLSw@mail.gmail.com>
 <aaf849d38ca3cdd45151ffae9b6a99fe6f6ea280.camel@redhat.com>
 <0c75b881-3096-12cf-07cc-1119ca6a453e@huawei.com> <06a1a6bde51a66461d7b3135349641856315401d.camel@redhat.com>
 <db92d37c-28fd-4f81-7b59-8f19e9178543@huawei.com> <8043d516-c041-c94b-a7d9-61bdbfef0d7e@huawei.com>
 <CAL2rwxpQt-w2Re8ttu0=6Yzb7ibX3_FB6j-kd_cbtrWxzc7chw@mail.gmail.com> <20201111092743.GC545929@T590>
In-Reply-To: <20201111092743.GC545929@T590>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Wed, 11 Nov 2020 17:06:02 +0530
Message-ID: <CAL2rwxoxJGx24d7B6a0iRXSyX-ryXr38Owj2xd9tiZN1vPEY5w@mail.gmail.com>
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
To:     Ming Lei <ming.lei@redhat.com>
Cc:     John Garry <john.garry@huawei.com>, Qian Cai <cai@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        don.brace@microsemi.com, Bart Van Assche <bvanassche@acm.org>,
        dgilbert@interlog.com, paolo.valente@linaro.org,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        esc.storagedev@microsemi.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        chenxiang66@hisilicon.com, luojiaxing@huawei.com,
        Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>
> Can this issue disappear by applying the following change?
This change fixes the issue for me.

Qian,
Please try after applying changes suggested by Ming.

Thanks,
Sumit
>
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index e32958f0b687..b1fe6176d77f 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -469,9 +469,6 @@ struct blk_flush_queue *blk_alloc_flush_queue(int node, int cmd_size,
>         INIT_LIST_HEAD(&fq->flush_queue[1]);
>         INIT_LIST_HEAD(&fq->flush_data_in_flight);
>
> -       lockdep_register_key(&fq->key);
> -       lockdep_set_class(&fq->mq_flush_lock, &fq->key);
> -
>         return fq;
>
>   fail_rq:
> @@ -486,7 +483,6 @@ void blk_free_flush_queue(struct blk_flush_queue *fq)
>         if (!fq)
>                 return;
>
> -       lockdep_unregister_key(&fq->key);
>         kfree(fq->flush_rq);
>         kfree(fq);
>  }
>
>
> Thanks,
> Ming
>
