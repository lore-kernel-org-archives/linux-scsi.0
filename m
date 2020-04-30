Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5765C4724C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 19:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8338E20873
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 19:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HC0dLmrb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgD3TSu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 15:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgD3TSu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 15:18:50 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25A9C035495
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2020 12:18:49 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id s30so6061075qth.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2020 12:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=2kNU/govm7Km3O7A0KcN7K8pmPqtqnw9+vrMQQrBk0g=;
        b=HC0dLmrbrnIalIMKKVY7PVbKmj7sWCSJ0kthXjOnBl88jTAI9SPSBPwCJ+06dnIWXs
         BBch5l/Kybx+2N2zeC6DZX+EStZhtfPraj+YZ68a/JTPMQC8VDltD3GpwlI/rXgUOTb5
         eG5qJ8+xCGI+hOr7V8OASb0w1K/S5VZ2402sk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=2kNU/govm7Km3O7A0KcN7K8pmPqtqnw9+vrMQQrBk0g=;
        b=KJZ3xdoAaLXBc01lQLQsgKBGnUZXGeYK2CkDhQqCk77N17Gm0GZaoSWmhQ++ndxfv6
         xOON8zo54THqJmPBnv87gj4yP5u/i3yIuNyvMH6PSHt7vTYeej06gEgdQoJ/lAfQz0Yl
         aDcb3GhKullPenS3TVpvIurDFvmNR2i+quLomRPjWzaYT3Wi3f8FjCzjrmG4VbGoI65z
         t17YyF2w6zX2uTN288SDJH9ZuGd3LQ420KIrqGjn7ZhHShQrCSgU0xq9Pbvt+6EfMNr6
         gdFtF/EScfXk7k81u3Fj0+9k5rNHBdGqGRPw/aX+MzobDqLDpW8W/l8IeKYfRwlRYr8Q
         xbRA==
X-Gm-Message-State: AGi0PubcX6iURitOlKSr16DgK1PsJDGhfS62oomaOLDfJTecf+qpgFAP
        qPDvV/vfh/1jQwWdfvKspWl//fxDH2z1kguL06p95w==
X-Google-Smtp-Source: APiQypKoNUnPcX2MaW1SCM7qMB7NYYpfEyxpyMueEM+BAUSHJd7GNtqHFmBooOlwF+2WWnCYcn1ghPJLQ9RrF01W/tk=
X-Received: by 2002:ac8:6f66:: with SMTP id u6mr5287706qtv.201.1588274328789;
 Thu, 30 Apr 2020 12:18:48 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
 <1583409280-158604-9-git-send-email-john.garry@huawei.com>
 <a1f0399e2e85b2244a9ae40e4a2f1089@mail.gmail.com> <f839f040-8bf4-cf83-7670-dfc208b77326@huawei.com>
 <7cac3eb9fd79b5b988e25da542305b35@mail.gmail.com> <40faaef8-8bfc-639f-747f-cacd4e61464f@huawei.com>
 <7b8c79b0453722023c6c7d53cd24441d@mail.gmail.com> <b759a8ed-09ba-bfe8-8916-c05ab9671cbf@huawei.com>
 <260c5decdb38db9f74994988ce7fcaf1@mail.gmail.com> <380d3bf2-67ee-a09a-3098-51b24b98f912@huawei.com>
 <e0c5a076-9fe5-4401-fd41-97f457888ad3@huawei.com> <d2ae343770a83466b870a33ffae5fa23@mail.gmail.com>
 <8e16d68b-4d71-58f1-ede9-92ffe5d65ba9@huawei.com> <f712fd935562dcff73f0f6cf15f9cce7@mail.gmail.com>
 <538dd70d-7edb-c66c-4205-d91f24a907ea@huawei.com> <ca799ed3-0b18-2aa5-7d75-6eac5b0e6e7b@huawei.com>
 <29f8062c1fccace73c45252073232917@mail.gmail.com> <6bfc5fea-d1ce-7220-0023-af3b34e1fa38@huawei.com>
 <eb8bc395-1e62-3a5a-c1f6-5b1d163bf080@huawei.com>
In-Reply-To: <eb8bc395-1e62-3a5a-c1f6-5b1d163bf080@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLPD/Iw6Rn2DAIn/TfwmBaZDWGoTwIxkurkAqxUgoEByxhGKAL7c9G/AhAFW6UBYJrDDwOh6RKhA6E3S3MDBK8nrwGGgqJUAkB+JNsCgDRgnAI/0DHrAq7T5W8B9qtJCwI9L+V1AppqUF4B04hP9aVGgpeA
Date:   Fri, 1 May 2020 00:48:46 +0530
Message-ID: <ecaeccf029c6fe377ebd4f30f04df9f1@mail.gmail.com>
Subject: RE: [PATCH RFC v6 08/10] megaraid_sas: switch fusion adapters to MQ
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        ming.lei@redhat.com, bvanassche@acm.org, hare@suse.de,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        hch@infradead.org,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of John Garry
> Sent: Thursday, April 30, 2020 11:11 PM
> To: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: axboe@kernel.dk; jejb@linux.ibm.com; martin.petersen@oracle.com;
> ming.lei@redhat.com; bvanassche@acm.org; hare@suse.de;
> don.brace@microsemi.com; Sumit Saxena <sumit.saxena@broadcom.com>;
> hch@infradead.org; Shivasharan Srikanteshwara
> <shivasharan.srikanteshwara@broadcom.com>; chenxiang (M)
> <chenxiang66@hisilicon.com>; linux-block@vger.kernel.org; linux-
> scsi@vger.kernel.org; esc.storagedev@microsemi.com; Hannes Reinecke
> <hare@suse.com>
> Subject: Re: [PATCH RFC v6 08/10] megaraid_sas: switch fusion adapters to
> MQ
>
> On 29/04/2020 18:55, John Garry wrote:
> >
>
> Hi Kashyap,
>
> > ok, so it's not proper to use active hctx per request queue as
> > "users", but rather that the active request_queue's per host (which is
> > what we effectively have for nr_hw_queues = 1). Just a small comment
> > at the bottom on your change.
> >
> > So I already experimented with reducing shost.can_queue significantly
> > on hisi_sas (by a factor of 8, from 4096->512, and I use 12x SAS SSD),
> > and
> > saw:
> >
> > RFC + shost.can_queue reduced: ~1.2M IOPS With RFC + shost.can_queue
> > unmodified: ~2M IOPS Without RFC + shost.can_queue unmodified: ~2M
> > IOPS
> >
> > And with the change, below, I still get around 1.2M IOPS. But there
> > may be some sweet spot/zone where this makes a difference, which I'm
> > not visiting.
> >
> >>
> >> Combination of your patch and below resolves fairness issues. I see
> >> some better results using " --cpus_allowed_policy=split", but
> >> --cpus_allowed_policy=shared
> >
> > I did not try changing the cpus_allowed_policy policy, and so I would
> > be using default, which I believe is shared.
> >
> > is still having some issue and most likely it
> >> is to do with fairness. If fairness is not managed properly, there is
> >> high contention in wait/wakeup handling of sbitmap.
> >
> > ok, I can investigate.
>
> Could you also try this change:
>
> diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h index
> 0a57e4f041a9..e959971b1cee 100644
> --- a/block/blk-mq-tag.h
> +++ b/block/blk-mq-tag.h
> @@ -46,11 +46,25 @@ extern void blk_mq_tag_wakeup_all(struct
> blk_mq_tags *tags, bool);
>   void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn
> *fn,
>   		void *priv);
>
> +static inline bool blk_mq_is_sbitmap_shared(struct blk_mq_tag_set
> +*tag_set) {
> +	return tag_set->flags & BLK_MQ_F_TAG_HCTX_SHARED; }
> +
>   static inline struct sbq_wait_state *bt_wait_ptr(struct sbitmap_queue
> *bt,
>   						 struct blk_mq_hw_ctx *hctx)
>   {
> +	struct request_queue *queue;
> +	struct blk_mq_tag_set *set;
> +
>   	if (!hctx)
>   		return &bt->ws[0];
> +	queue = hctx->queue;
> +	set = queue->tag_set;
> +
> +	if (blk_mq_is_sbitmap_shared(set))
> +		return sbq_wait_ptr(bt, &set->wait_index);
> +
>   	return sbq_wait_ptr(bt, &hctx->wait_index);
>   }
>
> diff --git a/block/blk-mq.h b/block/blk-mq.h index
> 4f12363d56bf..241607806f77 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -158,11 +158,6 @@ struct blk_mq_alloc_data {
>   	struct blk_mq_hw_ctx *hctx;
>   };
>
> -static inline bool blk_mq_is_sbitmap_shared(struct blk_mq_tag_set
> *tag_set)
> -{
> -	return tag_set->flags & BLK_MQ_F_TAG_HCTX_SHARED;
> -}
> -
>   static inline struct blk_mq_tags *blk_mq_tags_from_data(struct
> blk_mq_alloc_data *data)
>   {
>   	if (data->flags & BLK_MQ_REQ_INTERNAL)
>
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h index
> 957cb43c5de7..427c7934c29d 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -259,6 +259,8 @@ struct blk_mq_tag_set {
>
>   	struct mutex		tag_list_lock;
>   	struct list_head	tag_list;
> +
> +	atomic_t		wait_index;
>   };

John -

I have this patch in my local repo as I was doing similar change. Your above
exact patch is not tested, but similar attempt was done. It is good to
include in next revision.
There is no significant performance up or down using this change.
Currently system is not available for me to test. I will resume testing once
system is available.


>
>   /**
>
>
> Thanks,
> John
