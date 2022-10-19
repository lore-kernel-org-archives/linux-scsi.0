Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 289A8C43217
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 01:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiJSBRa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 21:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiJSBR0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 21:17:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFECDFC1D
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 18:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666142240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vnNacsVxf3YZ/yiRosb8lJ/iQsw+P4AWbKc0V3i3E7k=;
        b=gLx/t3jxDbav/+w41Tu/D/cL/jtbuGOT7krrFVY/luP7lvsaxNCwmQyuFdb4QrlDHuISl5
        ealokmkUu9XpAVaNAA8Yu0vGVsC2X7M/m//kG5nWOwFcZzXwuuwynBhYjAR54TQTdFWS9a
        dVp8nIvYET8bG/aFXXzfmkdDXbDXpZw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-2wkAFIfOP82X2ckKDvfswQ-1; Tue, 18 Oct 2022 21:17:17 -0400
X-MC-Unique: 2wkAFIfOP82X2ckKDvfswQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05BF38060A0;
        Wed, 19 Oct 2022 01:17:15 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97A922166B41;
        Wed, 19 Oct 2022 01:17:01 +0000 (UTC)
Date:   Wed, 19 Oct 2022 09:16:57 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/4] scsi: remove an extra queue reference
Message-ID: <Y09QCb5A+iL/Igoj@T590>
References: <20221018135720.670094-1-hch@lst.de>
 <20221018135720.670094-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018135720.670094-3-hch@lst.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 18, 2022 at 03:57:18PM +0200, Christoph Hellwig wrote:
> Now that blk_mq_destroy_queue does not release the queue reference, there
> is no need for a second queue reference to be held by the scsi_device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_scan.c  | 1 -
>  drivers/scsi/scsi_sysfs.c | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 5d27f5196de6f..0a95fa787fdf4 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -344,7 +344,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>  	sdev->request_queue = q;
>  	q->queuedata = sdev;
>  	__scsi_init_queue(sdev->host, q);
> -	WARN_ON_ONCE(!blk_get_queue(q));
>  
>  	depth = sdev->host->cmd_per_lun ?: 1;
>  
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 1214c6f07bc64..c95177ca6ed26 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1478,7 +1478,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	mutex_unlock(&sdev->state_mutex);
>  
>  	blk_mq_destroy_queue(sdev->request_queue);
> -	blk_put_queue(sdev->request_queue);

The above put is counter-pair of blk_get_queue() in scsi_alloc_sdev, and
the original blk_put_queue() in blk_mq_destroy_queue() is counter-pair of
the initial get in blk_alloc_queue().

Now blk_put_queue() is moved out of blk_mq_destroy_queue(), I am wondering
how the scsi queue lifetime can work correctly with this patch? Or is there
bug in current scsi code?


Thanks,
Ming

