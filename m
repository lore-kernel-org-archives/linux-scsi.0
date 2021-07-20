Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686EBC07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 07:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47DE361165
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 07:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbhGTGza (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 02:55:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232332AbhGTGz2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jul 2021 02:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626766566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bwk3k2wx0IZIOTkk2y1tBpILQ9MBq3XAZ55579Rk21k=;
        b=K8d8fa+x5OazV7G3ywF3D1IVxSKuAu0SL1AYz+/98tVJx3a2s/4DcLN+11hVrsBWjUdBLn
        EimMcJl+cwG0Kfsw4XaKM5X4Df5SMKxhOMttPcSxJWETqqkvXrUrgrAt78rbm76yojB0bA
        pOKnLX3o+IcAo2XjIcshmERBRjmXAjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-sV3iDM7GOQCTVkNVuA9gQw-1; Tue, 20 Jul 2021 03:36:05 -0400
X-MC-Unique: sV3iDM7GOQCTVkNVuA9gQw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75FA6100C662;
        Tue, 20 Jul 2021 07:36:03 +0000 (UTC)
Received: from T590 (ovpn-13-101.pek2.redhat.com [10.72.13.101])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A79E05D9F0;
        Tue, 20 Jul 2021 07:35:53 +0000 (UTC)
Date:   Tue, 20 Jul 2021 15:35:48 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kashyap.desai@broadcom.com, hare@suse.de
Subject: Re: [PATCH 1/9] blk-mq: Change rqs check in blk_mq_free_rqs()
Message-ID: <YPZ81HsYnyxBpQwu@T590>
References: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
 <1626275195-215652-2-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626275195-215652-2-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 14, 2021 at 11:06:27PM +0800, John Garry wrote:
> The original code in commit 24d2f90309b23 ("blk-mq: split out tag
> initialization, support shared tags") would check tags->rqs is non-NULL and
> then dereference tags->rqs[].
> 
> Then in commit 2af8cbe30531 ("blk-mq: split tag ->rqs[] into two"), we
> started to dereference tags->static_rqs[], but continued to check non-NULL
> tags->rqs.
> 
> Check tags->static_rqs as non-NULL instead, which is more logical.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  block/blk-mq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2c4ac51e54eb..ae28f470893c 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2348,7 +2348,7 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>  {
>  	struct page *page;
>  
> -	if (tags->rqs && set->ops->exit_request) {
> +	if (tags->static_rqs && set->ops->exit_request) {

Yeah, it is reasonable to check ->static_rqs since both ->init_request()
and ->exit_request() operate on request from ->static_rqs[]:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

