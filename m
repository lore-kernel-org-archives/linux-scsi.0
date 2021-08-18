Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A74C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 07:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1D62606A5
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 07:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239056AbhHRHjp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 03:39:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239060AbhHRHjo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Aug 2021 03:39:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629272350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LCsUAX7qCf8kQi+TyECU3+D4leV6a/JZLtzwwZWNnR0=;
        b=At5iLHL3H69PTLlGYHqjTO01qpOhaDTzY8iH8Msq4C6ljDhLZBfQzEbr1IfXgUL7GToDay
        QJ1rRwYopDrzZrFXKZMFNhENhQEt2q4H3UsjLV3QTw4LEJgLdippotYLmzvgnmWdRAdPAt
        WtLqWuA563Vbwal39sHDbtysJtdVML8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-BTz8WkvsMZG-DzqPP69k4w-1; Wed, 18 Aug 2021 03:39:06 -0400
X-MC-Unique: BTz8WkvsMZG-DzqPP69k4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A2DA108BC7B;
        Wed, 18 Aug 2021 07:39:05 +0000 (UTC)
Received: from T590 (ovpn-8-40.pek2.redhat.com [10.72.8.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CB3A5D9C6;
        Wed, 18 Aug 2021 07:38:56 +0000 (UTC)
Date:   Wed, 18 Aug 2021 15:38:51 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        hare@suse.de
Subject: Re: [PATCH v2 08/11] blk-mq: Add blk_mq_ops.init_request_no_hctx()
Message-ID: <YRy5C1s0HetZCHQ1@T590>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
 <1628519378-211232-9-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628519378-211232-9-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 09, 2021 at 10:29:35PM +0800, John Garry wrote:
> Add a variant of the init_request function which does not pass a hctx_idx
> arg.
> 
> This is important for shared sbitmap support, as it needs to be ensured for
> introducing shared static rqs that the LLDD cannot think that requests
> are associated with a specific HW queue.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  block/blk-mq.c         | 15 ++++++++++-----
>  include/linux/blk-mq.h |  7 +++++++
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f14cc2705f9b..4d6723cfa582 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2427,13 +2427,15 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>  static int blk_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
>  			       unsigned int hctx_idx, int node)
>  {
> -	int ret;
> +	int ret = 0;
>  
> -	if (set->ops->init_request) {
> +	if (set->ops->init_request)
>  		ret = set->ops->init_request(set, rq, hctx_idx, node);
> -		if (ret)
> -			return ret;
> -	}
> +	else if (set->ops->init_request_no_hctx)
> +		ret = set->ops->init_request_no_hctx(set, rq, node);

The only shared sbitmap user of SCSI does not use passed hctx_idx, not
sure we need such new callback.

If you really want to do this, just wondering why not pass '-1' as
hctx_idx in case of shared sbitmap?


Thanks,
Ming

