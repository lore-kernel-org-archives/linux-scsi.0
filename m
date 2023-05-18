Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D8AC77B75
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 01:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjERBRT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 21:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjERBRS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 21:17:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCCC421F
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 18:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684372590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SLTKv03by7JleX69ECwklQDzmkNE1pWXUrDEOGsjgeg=;
        b=cyXUbK5vIl9a7y/Mbbvgfxb7YObr2qGdjD9v+SC+bKRXWYSd6EiXYsaZm+MN37a6FMRv7E
        rorAhLeG9+PgLGhogaClit9O7mtAs1C8iholymzIy4dyB8pYCdJRu2en2xWpvCYTQtmKdv
        XMhehvPr/ZJdOZW4pa9QA9KpJdfVBoc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-JYevXUqGOHSBHznj2sstHQ-1; Wed, 17 May 2023 21:16:27 -0400
X-MC-Unique: JYevXUqGOHSBHznj2sstHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21137185A790;
        Thu, 18 May 2023 01:16:27 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D64140C6EC4;
        Thu, 18 May 2023 01:16:21 +0000 (UTC)
Date:   Thu, 18 May 2023 09:16:17 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH v3 4/4] scsi: core: Delay running the queue if the host
 is blocked
Message-ID: <ZGV8YfsLYIR2H21/@ovpn-8-16.pek2.redhat.com>
References: <20230517230927.1091124-1-bvanassche@acm.org>
 <20230517230927.1091124-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517230927.1091124-5-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 17, 2023 at 04:09:27PM -0700, Bart Van Assche wrote:
> Tell the block layer to rerun the queue after a delay instead of
> immediately if the SCSI LLD decided to block the host.
> 
> Note: neither scsi_run_host_queues() nor scsi_run_queue() are called
> from the fast path.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e4f34217b879..b37718ebbbfc 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1767,7 +1767,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		break;
>  	case BLK_STS_RESOURCE:
>  	case BLK_STS_ZONE_RESOURCE:
> -		if (scsi_device_blocked(sdev))
> +		if (scsi_device_blocked(sdev) || shost->host_self_blocked)
>  			ret = BLK_STS_DEV_RESOURCE;

What if scsi_unblock_requests() is just called after the above check and
before returning to block layer core? Then this request is invisible to
scsi_run_host_queues()<-scsi_unblock_requests(), and io hang happens.


Thanks,
Ming

