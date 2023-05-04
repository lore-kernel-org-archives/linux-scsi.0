Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49475C7EE21
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 04:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjEDERE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 00:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjEDERC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 00:17:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740821BDB
        for <linux-scsi@vger.kernel.org>; Wed,  3 May 2023 21:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683173770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ojRi+KkCe+lGNgq5N6eipHnh7i2KiUTOfy9rUX1zuew=;
        b=an1MSuF3ZO97ZCmjiuxG2BPg597Z9AAaYL6fuUiBucc8AKLZKG/XFrr+Oyb/QgtVwLZMgO
        x8GxGUaKPF68y3hZQLMj/joh5Ueii6WTg4qdrR5biczlponGBkL18FsL61kql14zFtBeNR
        XoKgXJWASh3fRqG4R2QyUfNBC4FmaqI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-YX2JEFvJPwSyPlyBP2A1jw-1; Thu, 04 May 2023 00:16:06 -0400
X-MC-Unique: YX2JEFvJPwSyPlyBP2A1jw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA09885A588;
        Thu,  4 May 2023 04:16:05 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B754C40C2064;
        Thu,  4 May 2023 04:16:00 +0000 (UTC)
Date:   Thu, 4 May 2023 12:15:55 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>, ming.lei@redhat.com
Subject: Re: [PATCH v2 4/5] scsi: core: Only kick the requeue list if
 necessary
Message-ID: <ZFMxe20b6RsSYBGP@ovpn-8-16.pek2.redhat.com>
References: <20230503230654.2441121-1-bvanassche@acm.org>
 <20230503230654.2441121-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503230654.2441121-5-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 03, 2023 at 04:06:53PM -0700, Bart Van Assche wrote:
> Instead of running the request queue of each device associated with a
> host every 3 ms (BLK_MQ_RESOURCE_DELAY) while host error handling is in
> progress, run the request queue after error handling has finished.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e59eb0cbfc83..a34390d35f1d 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -122,11 +122,9 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd, unsigned long msecs)
>  		WARN_ON_ONCE(true);
>  	}
>  
> -	if (msecs) {
> -		blk_mq_requeue_request(rq, false);
> +	blk_mq_requeue_request(rq, false);
> +	if (!scsi_host_in_recovery(cmd->device->host))
>  		blk_mq_delay_kick_requeue_list(rq->q, msecs);
> -	} else
> -		blk_mq_requeue_request(rq, true);
>  }
>  
>  /**
> @@ -165,7 +163,8 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
>  	 */
>  	cmd->result = 0;
>  
> -	blk_mq_requeue_request(scsi_cmd_to_rq(cmd), true);
> +	blk_mq_requeue_request(scsi_cmd_to_rq(cmd),
> +			       !scsi_host_in_recovery(cmd->device->host));
>  }
>  
>  /**
> @@ -462,10 +461,16 @@ void scsi_requeue_run_queue(struct work_struct *work)
>  	scsi_run_queue(q);
>  }
>  
> +/*
> + * Transfer requests from the requeue_list to from where these can be dispatched
> + * and run the request queues.
> + */
>  void scsi_run_host_queues(struct Scsi_Host *shost)
>  {
>  	struct scsi_device *sdev;
>  
> +	shost_for_each_device(sdev, shost)
> +		blk_mq_kick_requeue_list(sdev->request_queue);
>  	shost_for_each_device(sdev, shost)
>  		scsi_run_queue(sdev->request_queue);

You may move blk_mq_kick_requeue_list() to the following loop, or even
inside scsi_run_queue(), which isn't called in fast patch.

Thanks,
Ming

