Return-Path: <SRS0=Uiav=5Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C004EC2D0E9
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 01:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9495420748
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 01:41:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TJM3QE7O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbgCaBlr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 21:41:47 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:34538 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729089AbgCaBlr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Mar 2020 21:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585618906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uCvHMv98OtDr67jYpVLCMKXxZRhJK7JFA0omwE/cbpc=;
        b=TJM3QE7OR9nIH19HP4Wuk8wQp+Y/oxzxeWmSrjFNRt1F15+7ZOqSXsgRT1BBaHpaJdoKn8
        AIdXkM2aNklmcYL8aER5Eya0uyJk3Nn+YhhhacIxf9zYgzpJTEV2wTt2R0SKutag1Ccbl9
        HvS/rwRla6cHaQzzfomy6LZWkb2Acd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372--8xn2ZqvPZCcT78xtiCDxw-1; Mon, 30 Mar 2020 21:41:42 -0400
X-MC-Unique: -8xn2ZqvPZCcT78xtiCDxw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE73D1005514;
        Tue, 31 Mar 2020 01:41:40 +0000 (UTC)
Received: from ming.t460p (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 91F6850C01;
        Tue, 31 Mar 2020 01:41:31 +0000 (UTC)
Date:   Tue, 31 Mar 2020 09:41:09 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, groeck@chromium.org,
        paolo.valente@linaro.org, linux-scsi@vger.kernel.org,
        sqazi@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: core: Fix stall if two threads request budget
 at the same time
Message-ID: <20200331014109.GA20230@ming.t460p>
References: <20200330144907.13011-1-dianders@chromium.org>
 <20200330074856.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330074856.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 30, 2020 at 07:49:06AM -0700, Douglas Anderson wrote:
> It is possible for two threads to be running
> blk_mq_do_dispatch_sched() at the same time with the same "hctx".
> This is because there can be more than one caller to
> __blk_mq_run_hw_queue() with the same "hctx" and hctx_lock() doesn't
> prevent more than one thread from entering.
> 
> If more than one thread is running blk_mq_do_dispatch_sched() at the
> same time with the same "hctx", they may have contention acquiring
> budget.  The blk_mq_get_dispatch_budget() can eventually translate
> into scsi_mq_get_budget().  If the device's "queue_depth" is 1 (not
> uncommon) then only one of the two threads will be the one to
> increment "device_busy" to 1 and get the budget.
> 
> The losing thread will break out of blk_mq_do_dispatch_sched() and
> will stop dispatching requests.  The assumption is that when more
> budget is available later (when existing transactions finish) the
> queue will be kicked again, perhaps in scsi_end_request().
> 
> The winning thread now has budget and can go on to call
> dispatch_request().  If dispatch_request() returns NULL here then we
> have a potential problem.  Specifically we'll now call

I guess this problem should be BFQ specific. Now there is definitely
requests in BFQ queue wrt. this hctx. However, looks this request is
only available from another loser thread, and it won't be retrieved in
the winning thread via e->type->ops.dispatch_request().

Just wondering why BFQ is implemented in this way?

> blk_mq_put_dispatch_budget() which translates into
> scsi_mq_put_budget().  That will mark the device as no longer busy but
> doesn't do anything to kick the queue.  This violates the assumption
> that the queue would be kicked when more budget was available.
> 
> Pictorially:
> 
> Thread A                          Thread B
> ================================= ==================================
> blk_mq_get_dispatch_budget() => 1
> dispatch_request() => NULL
>                                   blk_mq_get_dispatch_budget() => 0
>                                   // because Thread A marked
>                                   // "device_busy" in scsi_device
> blk_mq_put_dispatch_budget()
> 
> The above case was observed in reboot tests and caused a task to hang
> forever waiting for IO to complete.  Traces showed that in fact two
> tasks were running blk_mq_do_dispatch_sched() at the same time with
> the same "hctx".  The task that got the budget did in fact see
> dispatch_request() return NULL.  Both tasks returned and the system
> went on for several minutes (until the hung task delay kicked in)
> without the given "hctx" showing up again in traces.
> 
> Let's attempt to fix this problem by detecting budget contention.  If
> we're in the SCSI code's put_budget() function and we saw that someone
> else might have wanted the budget we got then we'll kick the queue.
> 
> The mechanism of kicking due to budget contention has the potential to
> overcompensate and kick the queue more than strictly necessary, but it
> shouldn't hurt.
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
> 
>  drivers/scsi/scsi_lib.c    | 27 ++++++++++++++++++++++++---
>  drivers/scsi/scsi_scan.c   |  1 +
>  include/scsi/scsi_device.h |  2 ++
>  3 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 610ee41fa54c..0530da909995 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -344,6 +344,21 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>  	rcu_read_unlock();
>  }
>  
> +static void scsi_device_dec_busy(struct scsi_device *sdev)
> +{
> +	bool was_contention;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sdev->budget_lock, flags);
> +	atomic_dec(&sdev->device_busy);
> +	was_contention = sdev->budget_contention;
> +	sdev->budget_contention = false;
> +	spin_unlock_irqrestore(&sdev->budget_lock, flags);
> +
> +	if (was_contention)
> +		blk_mq_run_hw_queues(sdev->request_queue, true);
> +}
> +
>  void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>  {
>  	struct Scsi_Host *shost = sdev->host;
> @@ -354,7 +369,7 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>  	if (starget->can_queue > 0)
>  		atomic_dec(&starget->target_busy);
>  
> -	atomic_dec(&sdev->device_busy);
> +	scsi_device_dec_busy(sdev);
>  }
>  
>  static void scsi_kick_queue(struct request_queue *q)
> @@ -1624,16 +1639,22 @@ static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx)
>  	struct request_queue *q = hctx->queue;
>  	struct scsi_device *sdev = q->queuedata;
>  
> -	atomic_dec(&sdev->device_busy);
> +	scsi_device_dec_busy(sdev);
>  }
>  
>  static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
>  {
>  	struct request_queue *q = hctx->queue;
>  	struct scsi_device *sdev = q->queuedata;
> +	unsigned long flags;
>  
> -	if (scsi_dev_queue_ready(q, sdev))
> +	spin_lock_irqsave(&sdev->budget_lock, flags);
> +	if (scsi_dev_queue_ready(q, sdev)) {
> +		spin_unlock_irqrestore(&sdev->budget_lock, flags);
>  		return true;
> +	}
> +	sdev->budget_contention = true;
> +	spin_unlock_irqrestore(&sdev->budget_lock, flags);

No, it really hurts performance by adding one per-sdev spinlock in fast path,
and we actually tried to kill the atomic variable of 'sdev->device_busy'
for high performance HBA.

Thanks,
Ming

