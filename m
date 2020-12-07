Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5D8C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 07:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 879AF229C6
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 07:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgLGHxF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 02:53:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgLGHxF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 02:53:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607327498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQo1+kN+EmpujiwU31kF5lcdSPI6LmkaXNkP6oAOuM0=;
        b=F/7Trf9GuaLZvedMrb6sN7/m7EAyUzLzrP3B4CIHH23u3F4U9hS4og7jXP1o+qCakORIVt
        u7fb1FZbeUCg12QZcsgAoQoyEANZS2wS85eqFrHlVhkJl1Km8Kb2IFq5C2kFZA1zQ8QtXY
        AMYHbIkoqWhJGDfkY5lYUPNmdZui2RU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-VoV3ckoHNe6LE47WAqNzBQ-1; Mon, 07 Dec 2020 02:51:36 -0500
X-MC-Unique: VoV3ckoHNe6LE47WAqNzBQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE72D10054FF;
        Mon,  7 Dec 2020 07:51:34 +0000 (UTC)
Received: from T590 (ovpn-12-193.pek2.redhat.com [10.72.12.193])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA7BD2B58B;
        Mon,  7 Dec 2020 07:51:26 +0000 (UTC)
Date:   Mon, 7 Dec 2020 15:51:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ewan Milne <emilne@redhat.com>, Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: core: fix race between handling STS_RESOURCE and
 completion
Message-ID: <20201207075121.GE985419@T590>
References: <20201202100419.525144-1-ming.lei@redhat.com>
 <5f17e0b1-2bee-7dd2-6049-58088691204b@acm.org>
 <20201203010336.GC540033@T590>
 <9923f475-a2e4-5dd9-e671-21948969b724@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9923f475-a2e4-5dd9-e671-21948969b724@hisilicon.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 07, 2020 at 11:32:54AM +0800, chenxiang (M) wrote:
> 
> 
> 在 2020/12/3 9:03, Ming Lei 写道:
> > On Wed, Dec 02, 2020 at 10:10:30AM -0800, Bart Van Assche wrote:
> > > On 12/2/20 2:04 AM, Ming Lei wrote:
> > > > When queuing IO request to LLD, STS_RESOURCE may be returned because:
> > > > 
> > > > - host in recovery or blocked
> > > > - target queue throttling or blocked
> > > > - LLD rejection
> > > > 
> > > > Any one of the above doesn't happen frequently enough.
> > > > 
> > > > BLK_STS_DEV_RESOURCE is returned to block layer for avoiding unnecessary
> > > > re-run queue, and it is just one small optimization. However, all
> > > > in-flight requests originated from this scsi device may be completed
> > > > just after reading 'sdev->device_busy', so BLK_STS_DEV_RESOURCE is
> > > > returned to block layer. And the current failed IO won't get chance
> > > > to be queued any more, since it is invisible at that time for either
> > > > scsi_run_queue_async() or blk-mq's RESTART.
> > > > 
> > > > Fix the issue by not returning BLK_STS_DEV_RESOURCE in this situation.
> > > > 
> > > > Cc: Hannes Reinecke <hare@suse.com>
> > > > Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> > > > Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> > > > Cc: Bart Van Assche <bvanassche@acm.org>
> > > > Cc: Ewan Milne <emilne@redhat.com>
> > > > Cc: Long Li <longli@microsoft.com>
> > > > Tested-by: "chenxiang (M)" <chenxiang66@hisilicon.com>
> > > > Reported-by: John Garry <john.garry@huawei.com>
> > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > ---
> > > >    drivers/scsi/scsi_lib.c | 3 +--
> > > >    1 file changed, 1 insertion(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > > index 60c7a7d74852..03c6d0620bfd 100644
> > > > --- a/drivers/scsi/scsi_lib.c
> > > > +++ b/drivers/scsi/scsi_lib.c
> > > > @@ -1703,8 +1703,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
> > > >    		break;
> > > >    	case BLK_STS_RESOURCE:
> > > >    	case BLK_STS_ZONE_RESOURCE:
> > > > -		if (atomic_read(&sdev->device_busy) ||
> > > > -		    scsi_device_blocked(sdev))
> > > > +		if (scsi_device_blocked(sdev))
> > > >    			ret = BLK_STS_DEV_RESOURCE;
> > > >    		break;
> > > >    	default:
> > > Since this patch modifies code introduced in commit 86ff7c2a80cd ("blk-mq:
> > > introduce BLK_STS_DEV_RESOURCE"), does this patch perhaps needs a Fixes:
> > > tag?
> > This same race exists before commit 86ff7c2a80cd, so I think the 'Fixes:' tag
> > is misleading.
> 
> When reverted the patch "scsi: core: Only re-run queue in scsi_end_request()
> if device queue is busy", it also solves the issue.
> Does the issue is brought by the patch? If so, maybe adding fixes("Fixes:
> ed5dd6a67d5e ("scsi: core: Only re-run queue in scsi_end_request() if device
> queue is busy")") is more accuratte.

The debugfs log shows that the issue isn't related with restart or out
of budget because the single request stays in hctx->dispatch, and the flag of
RQF_DONTPREP is set too.

The scsi's restart(scsi_run_queue_async) from request completion is just
for handling requests in scheduler queue.


Thanks,
Ming

