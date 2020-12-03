Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D9AC6369E
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 01:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CD51221FB
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 01:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgLCBFY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 20:05:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbgLCBFW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 20:05:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606957436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D7JV1y8c0cDE1Jy7cOhPsXlkTwqCO6sPQjmpwXoD/uY=;
        b=C8NZTNAia2hZygZBa9X2WYkp21d4cWMzIH6RnKEGq5plsUnfuSPjj9AXrZ23ppGukANu49
        sUzCdN6o8jkMrhmyVOdd5sPqi5pJ19TjMpnuVeNNAACjSLdbr79z74epJNXx8ITSv1FtGc
        JpbyuJkK3DmBKftRS4yItTntllWzIho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-L9yb-BLqNU-TkfUKrgrM9Q-1; Wed, 02 Dec 2020 20:03:52 -0500
X-MC-Unique: L9yb-BLqNU-TkfUKrgrM9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4FD91081B2D;
        Thu,  3 Dec 2020 01:03:50 +0000 (UTC)
Received: from T590 (ovpn-12-87.pek2.redhat.com [10.72.12.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5CAF5C1B4;
        Thu,  3 Dec 2020 01:03:41 +0000 (UTC)
Date:   Thu, 3 Dec 2020 09:03:36 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ewan Milne <emilne@redhat.com>, Long Li <longli@microsoft.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: core: fix race between handling STS_RESOURCE and
 completion
Message-ID: <20201203010336.GC540033@T590>
References: <20201202100419.525144-1-ming.lei@redhat.com>
 <5f17e0b1-2bee-7dd2-6049-58088691204b@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f17e0b1-2bee-7dd2-6049-58088691204b@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 02, 2020 at 10:10:30AM -0800, Bart Van Assche wrote:
> On 12/2/20 2:04 AM, Ming Lei wrote:
> > When queuing IO request to LLD, STS_RESOURCE may be returned because:
> > 
> > - host in recovery or blocked
> > - target queue throttling or blocked
> > - LLD rejection
> > 
> > Any one of the above doesn't happen frequently enough.
> > 
> > BLK_STS_DEV_RESOURCE is returned to block layer for avoiding unnecessary
> > re-run queue, and it is just one small optimization. However, all
> > in-flight requests originated from this scsi device may be completed
> > just after reading 'sdev->device_busy', so BLK_STS_DEV_RESOURCE is
> > returned to block layer. And the current failed IO won't get chance
> > to be queued any more, since it is invisible at that time for either
> > scsi_run_queue_async() or blk-mq's RESTART.
> > 
> > Fix the issue by not returning BLK_STS_DEV_RESOURCE in this situation.
> > 
> > Cc: Hannes Reinecke <hare@suse.com>
> > Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> > Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> > Cc: Bart Van Assche <bvanassche@acm.org>
> > Cc: Ewan Milne <emilne@redhat.com>
> > Cc: Long Li <longli@microsoft.com>
> > Tested-by: "chenxiang (M)" <chenxiang66@hisilicon.com>
> > Reported-by: John Garry <john.garry@huawei.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   drivers/scsi/scsi_lib.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 60c7a7d74852..03c6d0620bfd 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1703,8 +1703,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
> >   		break;
> >   	case BLK_STS_RESOURCE:
> >   	case BLK_STS_ZONE_RESOURCE:
> > -		if (atomic_read(&sdev->device_busy) ||
> > -		    scsi_device_blocked(sdev))
> > +		if (scsi_device_blocked(sdev))
> >   			ret = BLK_STS_DEV_RESOURCE;
> >   		break;
> >   	default:
> 
> Since this patch modifies code introduced in commit 86ff7c2a80cd ("blk-mq:
> introduce BLK_STS_DEV_RESOURCE"), does this patch perhaps needs a Fixes:
> tag?

This same race exists before commit 86ff7c2a80cd, so I think the 'Fixes:' tag
is misleading.



Thanks,
Ming

