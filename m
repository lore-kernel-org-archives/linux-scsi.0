Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1840AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 03:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D09AD23888
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 03:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbhAVDZe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 22:25:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29973 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726061AbhAVDZa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 22:25:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611285843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x837i8WtC56JUHrtiWSUZKsgyTQICl2obIL24jpFGuI=;
        b=AjcCj2PBAaobMuyQAvc4+a24n4g9mY788RTzEKr1wT7Ra6lkfrW4YuuVBj6kiopVL8mduQ
        O51JJGl7i3RebVWVPtwB4bhz/6mTkGep3l3YhV+RgN28vuveFbu6Bvw7t4fd+HPTIhZx2/
        ztsENuvWZkzRjsdGDWezcgfB+Y7+pbc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-il4KQWyhNBevwuN0Md58gw-1; Thu, 21 Jan 2021 22:23:58 -0500
X-MC-Unique: il4KQWyhNBevwuN0Md58gw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A55BC180A09B;
        Fri, 22 Jan 2021 03:23:56 +0000 (UTC)
Received: from T590 (ovpn-13-11.pek2.redhat.com [10.72.13.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B50E19C59;
        Fri, 22 Jan 2021 03:23:45 +0000 (UTC)
Date:   Fri, 22 Jan 2021 11:23:40 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     mwilck@suse.com
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Don Brace <Don.Brace@microchip.com>,
        Kevin Barnett <Kevin.Barnett@microchip.com>,
        John Garry <john.garry@huawei.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
Message-ID: <20210122032340.GB509982@T590>
References: <20210120184548.20219-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120184548.20219-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 20, 2021 at 07:45:48PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Donald: please give this patch a try.
> 
> Commit 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
> contained this hunk:
> 
> -       busy = atomic_inc_return(&shost->host_busy) - 1;
>         if (atomic_read(&shost->host_blocked) > 0) {
> -               if (busy)
> +               if (scsi_host_busy(shost) > 0)
>                         goto starved;
> 
> The previous code would increase the busy count before checking host_blocked.
> With 6eb045e092ef, the busy count would be increased (by setting the
> SCMD_STATE_INFLIGHT bit) after the if clause for host_blocked above.
> 
> Users have reported a regression with the smartpqi driver [1] which has been
> shown to be caused by this commit [2].
> 
> It seems that by moving the increase of the busy counter further down, it could
> happen that the can_queue limit of the controller could be exceeded if several
> CPUs were executing this code in parallel on different queues.

can_queue limit should never be exceeded because it is respected by
blk-mq since each hw queue's queue depth is .can_queue.

smartpqi's issue is that its .can_queue does not represent each hw
queue's depth, instead the .can_queue represents queue depth of the
whole HBA.

As John mentioned, smartpqi should have switched to hosttags.

BTW, looks the following code has soft lockup risk:

pqi_alloc_io_request():
        while (1) {
                io_request = &ctrl_info->io_request_pool[i];
                if (atomic_inc_return(&io_request->refcount) == 1)
                        break;
                atomic_dec(&io_request->refcount);
                i = (i + 1) % ctrl_info->max_io_slots;
        }

> 
> This patch attempts to fix it by moving setting the SCMD_STATE_INFLIGHT before
> the host_blocked test again. It also inserts barriers to make sure
> scsi_host_busy() on once CPU will notice the increase of the count from another.
> 
> [1]: https://marc.info/?l=linux-scsi&m=160271263114829&w=2
> [2]: https://marc.info/?l=linux-scsi&m=161116163722099&w=2

If the above is true wrt. smartpqi's can_queue usage, your patch may not fix the
issue completely in which you think '.can_queue is exceeded'.

> 
> Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
> 
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Don Brace <Don.Brace@microchip.com>
> Cc: Kevin Barnett <Kevin.Barnett@microchip.com>
> Cc: Donald Buczek <buczek@molgen.mpg.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/hosts.c    | 2 ++
>  drivers/scsi/scsi_lib.c | 8 +++++---
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 2f162603876f..1c452a1c18fd 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -564,6 +564,8 @@ static bool scsi_host_check_in_flight(struct request *rq, void *data,
>  	int *count = data;
>  	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
>  
> +	/* This pairs with set_bit() in scsi_host_queue_ready() */
> +	smp_mb__before_atomic();

So the above barrier orders atomic_read(&shost->host_blocked) and
test_bit()?

>  	if (test_bit(SCMD_STATE_INFLIGHT, &cmd->state))
>  		(*count)++;
>  
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b3f14f05340a..0a9a36c349ee 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1353,8 +1353,12 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>  	if (scsi_host_in_recovery(shost))
>  		return 0;
>  
> +	set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> +	/* This pairs with test_bit() in scsi_host_check_in_flight() */
> +	smp_mb__after_atomic();
> +
>  	if (atomic_read(&shost->host_blocked) > 0) {
> -		if (scsi_host_busy(shost) > 0)
> +		if (scsi_host_busy(shost) > 1)
>  			goto starved;
>  
>  		/*
> @@ -1379,8 +1383,6 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>  		spin_unlock_irq(shost->host_lock);
>  	}
>  
> -	__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> -

Looks this patch fine.

However, I'd suggest to confirm smartpqi's .can_queue usage first, which
looks one big issue.

-- 
Ming

