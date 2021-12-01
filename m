Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E88C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 01:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbhLABgS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 20:36:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230044AbhLABgS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Nov 2021 20:36:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638322377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4aXAaWVDgr8KuNAVmnrqeJqdKF9+8NH6TLN6DizOdLs=;
        b=CI0u9OynTeSpDGRfl8Jqbm76S7YgzZ40qdNjTmR6t/9Z3IWA1lOGust+gFdRlriUPFoBeh
        s/ppvgyWQtt7QytdQTszb5g6SlsWySo0X+mkA5M1Ql1kfMDaTo+BHQPVJ42JbWa+9tFvLK
        0RUJPR70HAF4YP6PMcAMOlWyNXOP+Zg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-WbzDDABfMxytlUBll7i5vQ-1; Tue, 30 Nov 2021 20:32:54 -0500
X-MC-Unique: WbzDDABfMxytlUBll7i5vQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 376411B2C983;
        Wed,  1 Dec 2021 01:32:53 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33DD63D75;
        Wed,  1 Dec 2021 01:32:41 +0000 (UTC)
Date:   Wed, 1 Dec 2021 09:32:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v3 01/17] scsi: core: Fix scsi_device_max_queue_depth()
Message-ID: <YabQtdaeu4MOE9qU@T590>
References: <20211130233324.1402448-1-bvanassche@acm.org>
 <20211130233324.1402448-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130233324.1402448-2-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 30, 2021 at 03:33:08PM -0800, Bart Van Assche wrote:
> The comment above scsi_device_max_queue_depth() and also the description
> of commit ca4453213951 ("scsi: core: Make sure sdev->queue_depth is <=
> max(shost->can_queue, 1024)") contradict the implementation of the function
> scsi_device_max_queue_depth(). Additionally, the maximum queue depth of a
> SCSI LUN never exceeds host->can_queue. Fix scsi_device_max_queue_depth()
> by changing max_t() into min_t().
> 
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Fixes: ca4453213951 ("scsi: core: Make sure sdev->queue_depth is <= max(shost->can_queue, 1024)")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index dee4d9c6046d..211aace69c22 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -200,11 +200,11 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>  
>  
>  /*
> - * 1024 is big enough for saturating the fast scsi LUN now
> + * 1024 is big enough for saturating fast SCSI LUNs.
>   */
>  int scsi_device_max_queue_depth(struct scsi_device *sdev)
>  {
> -	return max_t(int, sdev->host->can_queue, 1024);
> +	return min_t(int, sdev->host->can_queue, 1024);
>  }

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

