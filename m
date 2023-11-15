Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702F0C072A2
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 16:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjKOQcx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 11:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbjKOQcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 11:32:39 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D5D1BEF
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 08:32:01 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-5a7af20c488so82695797b3.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 08:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700065921; x=1700670721; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oiTtRVRJEHtmuCKQLUAVrGDSnYNUAYgtbuAjBv7EOvc=;
        b=RDMQXJpX5BcZ6YXfZt6OqHPY2PycnrOsPx/VPhqXt1Likik9JT68qNePdNm2uBgjmj
         1uqVd//uwm6Yofx/qrviffajs3sZMBQyhuWpksf3Q2W68zWpX7Ln3S2chRMg7RFDQoJ5
         i6eH176h/QNtE3yNgM2bdnrY8T3kUuFPFy6WZS7DZYkctSjCFsDNqEEwW0AselSxaH8j
         tzfxRb28/NA0Ku5zHI3F3CotInOZ0y/92tpHy7XEoR+RsLa0SWMfv+/gyeq7Bgn3tBh4
         5m5n6Ma5H25xsZSTS9Y6KgRH7kGZWdDKWTPdVAFsg5jQ3UzCNOHwQOyK0jmanDSFeU22
         F5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700065921; x=1700670721;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oiTtRVRJEHtmuCKQLUAVrGDSnYNUAYgtbuAjBv7EOvc=;
        b=hfrCZCbXlORQf4WiTxCIJMSSEhf9JtaLWmc/pwQW6giEVsAxkhpx9axFXZ9XUuY78g
         Bgv9YMTxkP1n8+MAa/osHr2Qt5hP/pO7zm27I1sbu2QdlXrB6/+Colm7tHUtQau5Vl2k
         NyqSob8G+vf5r1uVrwYHeTfjl/5uMiTM8YAPIT1pJL/x3nl9Olp8RDXQ7BooF8eKnJM/
         9Z+0hyul5wGBR4tFQ2J2zkuhCbM5sMOIvVpDVm9kUy+MgBUl8ua14HsCt+9qwixmR7j2
         RfeErgOMEVMEsx6VtsAEQ0gTCbuAGt0pMGGQEQf/diB4IpkHeToXLfF65lKhjKZdxoHn
         gVkQ==
X-Gm-Message-State: AOJu0YxvXWqco6eWmrI1EVsOliuklf15kU9cEy5qI47GgQ6/FnftGp9t
        wRyHx0GLRNTXzbKu0xAdHMHfu0n8eJOb56vW7Uxa+Ilyeps=
X-Google-Smtp-Source: AGHT+IGikz26Cp2qDAJSQCOEThMt/5XLIqiCLT8rW9OHcN5wrnK9/AOolFdKS6rUySObrAd205fHWXeEgqsgCXxxXOQ=
X-Received: by 2002:a81:5d88:0:b0:5a8:62f2:996a with SMTP id
 r130-20020a815d88000000b005a862f2996amr14056375ywb.6.1700065920818; Wed, 15
 Nov 2023 08:32:00 -0800 (PST)
MIME-Version: 1.0
References: <CAGnHSE=pipa-zi-kxWyPoow0wU04-N_eUopOaZWFftTsfLjEQQ@mail.gmail.com>
 <CAGnHSEk3bARZ=ed4D62mv=n-nQRoiPteCLZPdMhrW_O5ntzfCA@mail.gmail.com> <5268cb26-227a-46fa-8200-563da3b02cc3@acm.org>
In-Reply-To: <5268cb26-227a-46fa-8200-563da3b02cc3@acm.org>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Thu, 16 Nov 2023 00:31:49 +0800
Message-ID: <CAGnHSEkq39GStuwmxG+2jCc3W+G45xB4gJ-VdPCbOwbSdZFyTA@mail.gmail.com>
Subject: Re: [BUG] write_cache sysfs file broken for WCE setting
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org, axboe@kernel.dk,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sure. I just wonder if it was just a typo, or, intentional for some
"implicit reason(s)", even though I myself can't see any (that could
possibly make sense).

(To state the obvious, the problem was that for devices that does not
support FUA, 'write back' would become an impossible value to write to
the `write_cache` file (even if it is the current value), because
`blk_queue_write_cache` would clear the QUEUE_FLAG_FUA queue flag in
that case and it is the same bit that `queue_wc_store` would check
(for "hw wc").)

Regards,
Tom

On Tue, 14 Nov 2023 at 02:52, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 11/13/23 10:27, Tom Yan wrote:
> > So I realized that I mixed up the queue write_cache and the sd
> > cache_type sysfs files. cache_type is working fine.
> >
> > But then I noticed that in commit
> > 43c9835b144c7ce29efe142d662529662a9eb376, you define QUEUE_FLAG_HW_WC
> > as 18, which is also the value of QUEUE_FLAG_FUA. Was it intentional?
> > If so, what's the reason behind it?
>
> Does the untested patch below help?
>
> Thanks,
>
> Bart.
>
> [PATCH] block: Make sure that all queue flags have a different value
>
> Queue flags QUEUE_FLAG_HW_WC has the same numerical value as
> QUEUE_FLAG_FUA. Fix this by changing the QUEUE_FLAG_HW_WC definition.
>
> Cc: Christoph Hellwig <hch@lst.de>
> Reported-by: Tom Yan <tom.ty89@gmail.com>
> Fixes: 43c9835b144c ("block: don't allow enabling a cache on devices that don't support it")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   include/linux/blkdev.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index eef450f25982..f59fcd5b499a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -538,7 +538,7 @@ struct request_queue {
>   #define QUEUE_FLAG_ADD_RANDOM 10      /* Contributes to random pool */
>   #define QUEUE_FLAG_SYNCHRONOUS        11      /* always completes in submit context */
>   #define QUEUE_FLAG_SAME_FORCE 12      /* force complete on same CPU */
> -#define QUEUE_FLAG_HW_WC       18      /* Write back caching supported */
> +#define QUEUE_FLAG_HW_WC       13      /* Write back caching supported */
>   #define QUEUE_FLAG_INIT_DONE  14      /* queue is initialized */
>   #define QUEUE_FLAG_STABLE_WRITES 15   /* don't modify blks until WB is done */
>   #define QUEUE_FLAG_POLL               16      /* IO polling enabled if set */
>
