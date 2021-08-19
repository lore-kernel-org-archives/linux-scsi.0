Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2211EC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 00:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04874610CB
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 00:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbhHSAkU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 20:40:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235017AbhHSAkS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Aug 2021 20:40:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629333582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t7HjgcfyIm369W11HV7x4h2DtrAmkaaUtdzcfD19c1U=;
        b=grmPgSvmuJbRD7ESFIKPlX+vTuVvvDWzFrC/jomwjYarz6lJRF/y9b6TC0ECKcP2oBiigp
        FaHoZsMpv3147OJwmffknfNOT8N0XVUdHdabnx3ovp5ei0nuZvPNpoU09HLtOyEaqKeN5X
        7W8Jsqimht9A3bxbPbL4OLLUcqZO+jI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-oU9l-s0jOB2qcEgggaEdcg-1; Wed, 18 Aug 2021 20:39:39 -0400
X-MC-Unique: oU9l-s0jOB2qcEgggaEdcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1246E107ACF5;
        Thu, 19 Aug 2021 00:39:38 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A58F119D9D;
        Thu, 19 Aug 2021 00:39:27 +0000 (UTC)
Date:   Thu, 19 Aug 2021 08:39:23 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        hare@suse.de
Subject: Re: [PATCH v2 06/11] blk-mq: Pass driver tags to
 blk_mq_clear_rq_mapping()
Message-ID: <YR2oO8hhtDx1Wd+P@T590>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
 <1628519378-211232-7-git-send-email-john.garry@huawei.com>
 <YRyGb/Ay3lvUZs/V@T590>
 <23448833-593c-139f-6051-9b8e7d3deade@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23448833-593c-139f-6051-9b8e7d3deade@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 18, 2021 at 01:00:13PM +0100, John Garry wrote:
> > > @@ -2346,8 +2345,11 @@ static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
> > >   void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
> > >   		     unsigned int hctx_idx)
> > >   {
> > > +	struct blk_mq_tags *drv_tags;
> > >   	struct page *page;
> > > +		drv_tags = set->tags[hctx_idx];
> > 
> 
> Hi Ming,
> 
> > Indent.
> 
> That's intentional, as we have from later patch:
> 
> void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
> unsigned int hctx_idx)
> {
> 	struct blk_mq_tags *drv_tags;
> 	struct page *page;
> 
> +	if (blk_mq_is_sbitmap_shared(set->flags))
> +		drv_tags = set->shared_sbitmap_tags;
> +	else
> 		drv_tags = set->tags[hctx_idx];
> 
> 	...
> 
> 	blk_mq_clear_rq_mapping(drv_tags, tags);
> 
> }
> 
> And it's just nice to not re-indent later.

But this way is weird, and I don't think checkpatch.pl is happy with
it.

-- 
Ming

