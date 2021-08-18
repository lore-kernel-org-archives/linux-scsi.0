Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24ED3C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 04:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A26A61053
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 04:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhHRED7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 00:03:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54675 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhHRED6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Aug 2021 00:03:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629259404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sios1zxrz+ysJAaUdrtGvf8+wMpJlFQZ/+MolKSHj+c=;
        b=UNaFNBbfsq14w9u11Y8MW36zhYBSEhdCrsZZd5SQ/rKorjWZiyuqe/eHZQ26MH2JQZoILg
        QTFO+59Hm8iIPzota2zA8m0khgKfQR0YYqCsWlpaCM8+3xMOVACV1JBZJpWf9uPLa5nlSq
        bFBQ2fQ9+b3YhL7oaGdQCraPtVrWEsk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-ljmlEhNZO5-5a5PyRCXvkQ-1; Wed, 18 Aug 2021 00:03:09 -0400
X-MC-Unique: ljmlEhNZO5-5a5PyRCXvkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 267041853027;
        Wed, 18 Aug 2021 04:03:08 +0000 (UTC)
Received: from T590 (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BFFC21036D3F;
        Wed, 18 Aug 2021 04:02:59 +0000 (UTC)
Date:   Wed, 18 Aug 2021 12:02:55 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        hare@suse.de
Subject: Re: [PATCH v2 06/11] blk-mq: Pass driver tags to
 blk_mq_clear_rq_mapping()
Message-ID: <YRyGb/Ay3lvUZs/V@T590>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
 <1628519378-211232-7-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628519378-211232-7-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 09, 2021 at 10:29:33PM +0800, John Garry wrote:
> Function blk_mq_clear_rq_mapping() will be used for shared sbitmap tags
> in future, so pass a driver tags pointer instead of the tagset container
> and HW queue index.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  block/blk-mq.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 42c4b8d1a570..0bb596f4d061 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2310,10 +2310,9 @@ static size_t order_to_size(unsigned int order)
>  }
>  
>  /* called before freeing request pool in @tags */
> -static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
> -		struct blk_mq_tags *tags, unsigned int hctx_idx)
> +void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
> +			     struct blk_mq_tags *tags)
>  {
> -	struct blk_mq_tags *drv_tags = set->tags[hctx_idx];
>  	struct page *page;
>  	unsigned long flags;
>  
> @@ -2322,7 +2321,7 @@ static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
>  		unsigned long end = start + order_to_size(page->private);
>  		int i;
>  
> -		for (i = 0; i < set->queue_depth; i++) {
> +		for (i = 0; i < drv_tags->nr_tags; i++) {
>  			struct request *rq = drv_tags->rqs[i];
>  			unsigned long rq_addr = (unsigned long)rq;
>  
> @@ -2346,8 +2345,11 @@ static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
>  void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>  		     unsigned int hctx_idx)
>  {
> +	struct blk_mq_tags *drv_tags;
>  	struct page *page;
>  
> +		drv_tags = set->tags[hctx_idx];

Indent.

> +
>  	if (tags->static_rqs && set->ops->exit_request) {
>  		int i;
>  
> @@ -2361,7 +2363,7 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>  		}
>  	}
>  
> -	blk_mq_clear_rq_mapping(set, tags, hctx_idx);
> +	blk_mq_clear_rq_mapping(drv_tags, tags);

Maybe you can pass set->tags[hctx_idx] directly since there is only one
reference on it.

-- 
Ming

