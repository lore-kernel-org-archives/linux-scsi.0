Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD35C43214
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 07:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8842610CB
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 07:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239913AbhHZHay (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Aug 2021 03:30:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239566AbhHZHax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Aug 2021 03:30:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629963005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Hs25L22wqwohthHMmK/ym33HqLah/+TOh4T1tfSx+o=;
        b=bJgcO442fE1vjwTTdWUBEMd4fxFnIKhj6y7hMYhCn9BmkDKhKtPeBJXZY2XY1vpqHM7qMm
        q04Kc9qkJgwI08RvUaxqimdRuYOB2tf5PtuN/tTrav43BISupDtD+vRT2BdPtJt3ucUWDs
        iwu8e9vcilK+oT2O/a6bvkE/UWpXqjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-slYhu2xuMMux7mEUNOHc8A-1; Thu, 26 Aug 2021 03:30:01 -0400
X-MC-Unique: slYhu2xuMMux7mEUNOHc8A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D4E38015C7;
        Thu, 26 Aug 2021 07:30:00 +0000 (UTC)
Received: from T590 (ovpn-8-40.pek2.redhat.com [10.72.8.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87121179BB;
        Thu, 26 Aug 2021 07:29:51 +0000 (UTC)
Date:   Thu, 26 Aug 2021 15:29:45 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     luojiaxing <luojiaxing@huawei.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        john.garry@huawei.com
Subject: Re: rq pointer in tags->rqs[] is not cleared in time and make SCSI
 error handle can not be triggered
Message-ID: <YSdCfSeEv9s9OUMX@T590>
References: <fe5cf6c4-ce5e-4a0f-f4ab-5c10539492cb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe5cf6c4-ce5e-4a0f-f4ab-5c10539492cb@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 26, 2021 at 11:00:34AM +0800, luojiaxing wrote:
> Dear all:
> 
> 
> I meet some problem when test hisi_sas driver(under SCSI) based on 5.14-rc4
> kernel, it's found that error handle can not be triggered after
> 
> abnormal IO occur in some test with a low probability. For example,
> circularly run disk hardreset or disable all local phy of expander when
> running fio.
> 
> 
> We add some tracepoint and print to see what happen, and we got the
> following information:
> 
> (1).print rq and rq_state at bt_tags_iter() to confirm how many IOs is
> running now.
> 
> <4>[  897.431182] bt_tags_iter: rqs[2808]: 0xffff202007bd3000; rq_state: 1
> <4>[  897.437514] bt_tags_iter: rqs[3185]: 0xffff0020c5261e00; rq_state: 1
> <4>[  897.443841] bt_tags_iter: rqs[3612]: 0xffff00212f242a00; rq_state: 1
> <4>[  897.450167] bt_tags_iter: rqs[2808]: 0xffff00211d208100; rq_state: 1
> <4>[  897.456492] bt_tags_iter: rqs[2921]: 0xffff00211d208100; rq_state: 1
> <4>[  897.462818] bt_tags_iter: rqs[1214]: 0xffff002151d21b00; rq_state: 1
> <4>[  897.469143] bt_tags_iter: rqs[2648]: 0xffff0020c4bfa200; rq_state: 1
> 
> The preceding information show that rq with tag[2808] is found in different
> hctx by bt_tags_iter() and with different pointer saved in tags->rqs[].
> 
> And tag[2808] own the same pointer value saved in rqs[] with tag[2921]. It's
> wrong because our driver share tag between all hctx, so it's not possible

What is your io scheduler? I guess it is deadline, and can you observe
such issue by switching to none?

The tricky thing is that one request dumped may be re-allocated to other tag
after returning from bt_tags_iter().

> 
> to allocate one tag to different rq.
> 
> 
> (2).check tracepoints(temporarily add) in blk_mq_get_driver_tag() and
> blk_mq_put_tag() to see where this tag is come from.
> 
>     Line 1322969:            <...>-20189   [013] .... 893.427707:
> blk_mq_get_driver_tag: rqs[2808]: 0xffff00211d208100
>     Line 1322997:  irq/1161-hisi_s-7602    [012] d..1 893.427814:
> blk_mq_put_tag_in_free_request: rqs[2808]: 0xffff00211d208100
>     Line 1331257:            <...>-20189   [013] .... 893.462663:
> blk_mq_get_driver_tag: rqs[2860]: 0xffff00211d208100
>     Line 1331289:  irq/1161-hisi_s-7602    [012] d..1 893.462785:
> blk_mq_put_tag_in_free_request: rqs[2860]: 0xffff00211d208100
>     Line 1338493:            <...>-20189   [013] .... 893.493519:
> blk_mq_get_driver_tag: rqs[2921]: 0xffff00211d208100
> 
> As we can see this rq is allocated to tag[2808] once, and finially come to
> tag[2921], but rqs[2808] still save the pointer.

Yeah, we know this kind of handling, but not see it as issue.

> 
> There will be no problem until we encounter a rare situation.
> 
> For example, tag[2808] is reassigned to another hctx for execution, then
> some IO meet some error.

I guess the race is triggered when 2808 is just assigned, meantime
->rqs[] isn't updated.

> 
> Before waking up the error handle thread, SCSI compares the values of
> scsi_host_busy() and shost->host_failed.
> 
> If the values are different, SCSI waits for the completion of some I/Os.
> According to the print provided by (1), the return value of scsi_host_busy()
> should be 7 for tag [2808] is calculated twice,
> 
> and the value of shost->host_failed is 6. As a result, this two values are
> never equal, and error handle cannot be triggered.
> 
> 
> A temporary workaround is provided and can solve the problem as:
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 2a37731..e3dc773 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -190,6 +190,7 @@ void blk_mq_put_tag(struct blk_mq_tags *tags, struct
> blk_mq_ctx *ctx,
>                 BUG_ON(tag >= tags->nr_reserved_tags);
>                 sbitmap_queue_clear(tags->breserved_tags, tag, ctx->cpu);
>         }
> +       tags->rqs[tag] = NULL;
>  }
> 
> 
> Since we did not encounter this problem in some previous kernel versions, we
> wondered if the community already knew about the problem or could provide
> some solutions.

Can you try the following patch?

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 86f87346232a..97557ba0737f 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -301,7 +301,7 @@ static bool bt_tags_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
 		return true;
 
 	if (!(iter_data->flags & BT_TAG_ITER_STARTED) ||
-	    blk_mq_request_started(rq))
+	    (blk_mq_request_started(rq) && rq->tag == bitnr))
 		ret = iter_data->fn(rq, iter_data->data, reserved);
 	if (!iter_static_rqs)
 		blk_mq_put_rq_ref(rq);



Thanks,
Ming

