Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB78C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 02:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD6E861360
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 02:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhHWDAc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Aug 2021 23:00:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229850AbhHWDAc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 22 Aug 2021 23:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629687589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=axjxrGHttzw0tQcSYIKKPfSOM5He+S2z2F7X2I25OOA=;
        b=KzW8QaCeuHF911KcWMzfEXWb111SItXfdZogtN0w9aucQHePJDw1JVqOyCtbvYS3YUCrJd
        x69AS09qlYPndYyJAkX8ZA1x88ztA4WJXCGjdmaGivyyg2f0CQYPD9vQj9+p1k/WlVR29r
        rjznFStnyBno06yPT6+c3I3UZq89WL8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-zyrgTxl_Mv-ZrqTWbp5LFA-1; Sun, 22 Aug 2021 22:59:48 -0400
X-MC-Unique: zyrgTxl_Mv-ZrqTWbp5LFA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98884802922;
        Mon, 23 Aug 2021 02:59:46 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3967560861;
        Mon, 23 Aug 2021 02:59:33 +0000 (UTC)
Date:   Mon, 23 Aug 2021 10:59:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        hare@suse.de
Subject: Re: [PATCH v2 06/11] blk-mq: Pass driver tags to
 blk_mq_clear_rq_mapping()
Message-ID: <YSMPEGmHP8YljCnV@T590>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
 <1628519378-211232-7-git-send-email-john.garry@huawei.com>
 <YRyGb/Ay3lvUZs/V@T590>
 <23448833-593c-139f-6051-9b8e7d3deade@huawei.com>
 <YR2oO8hhtDx1Wd+P@T590>
 <c957c544-4040-e462-47f6-3514ab3da617@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c957c544-4040-e462-47f6-3514ab3da617@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 19, 2021 at 08:32:20AM +0100, John Garry wrote:
> On 19/08/2021 01:39, Ming Lei wrote:
> > > That's intentional, as we have from later patch:
> > > 
> > > void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
> > > unsigned int hctx_idx)
> > > {
> > > 	struct blk_mq_tags *drv_tags;
> > > 	struct page *page;
> > > 
> > > +	if (blk_mq_is_sbitmap_shared(set->flags))
> > > +		drv_tags = set->shared_sbitmap_tags;
> > > +	else
> > > 		drv_tags = set->tags[hctx_idx];
> > > 
> > > 	...
> > > 
> > > 	blk_mq_clear_rq_mapping(drv_tags, tags);
> > > 
> > > }
> > > 
> > > And it's just nice to not re-indent later.
> > But this way is weird, and I don't think checkpatch.pl is happy with
> > it.
> 
> There is the idea to try to not remove/change code earlier in a series - I
> am taking it to an extreme! I can stop.
> 
> On another related topic, how about this change also:
> 
> ---8<---
> void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
> 			     struct blk_mq_tags *tags)
>  {
> 
> +	/* There is no need to clear a driver tags own mapping */
> +	if (drv_tags == tags)
> +		return;
> --->8---

The change itself is correct, and no need to clear driver tags
->rq[] since all request queues have been cleaned up when freeing
tagset.


Thanks,
Ming

