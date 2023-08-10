Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFC2C001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 19:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbjHJTYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 15:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236365AbjHJTYv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 15:24:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF582273C
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 12:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691695436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eNpUhxfG0oagA+OSHR3CBYIVBwq8hSKrFiUJQDT85NI=;
        b=i0pab6E691K57RxUXDi7g1yc3FBLksDMzuDbdwMYdUhVb0zX2uYrzA0zH/TWiCQWii4mia
        I6tpt15y+J4xintXwPIXS1BXazYatt666/2FOFg1sAWR0g3t6UUo49R7w3bkUDYSvATu1e
        5DBNembqdDStphu0ayYS/SVBdYXCkko=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-lj3UVnrsM1-aCO2moVySJA-1; Thu, 10 Aug 2023 15:23:54 -0400
X-MC-Unique: lj3UVnrsM1-aCO2moVySJA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-317a84a3ebeso1076707f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 12:23:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691695433; x=1692300233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eNpUhxfG0oagA+OSHR3CBYIVBwq8hSKrFiUJQDT85NI=;
        b=N0YcyWnePqdqAi2Snh+lXTiUlH5JmmwrN+xmznsdzqkUcr+RMLalSumcxdM5Z2ncyi
         Q+wwmooQy0rmidgPSvdq/BbLHvjHz4Ggnh+hyulYvNznH2w71zbja+b4ukGN3EyZzAxM
         2Sry/t6tqNcGHNXqcB+q0PkAVBL16awTPCyOyfHTgi5XRwM1MuvYo+cPUzu3e6yjFMs5
         jYgIejYkM924aLtBNHhFy4qAt0gLGSk0gab2LHlHAOoN5sy9LLZa0V+HbRymrCEY3euo
         VbcMzjV4XtGvhVesBogYqHYUn1HK4QBScDFRZSta2jhDNX0ONL62Osn7AdXysYdgnZXv
         j2fg==
X-Gm-Message-State: AOJu0YykIaej6IIJF3zZS8hI66X5NAJzW891cZXR8i9Vkw3d5SECnDRK
        chzvhrwYPhtR/Hvmd/U8EoAScNamRxQ2z3KRGjuDoqLx52OM7NxV7o6tYq2VDFhpv8rf0S1wNUr
        g/MrKZvhw3LYfVSaMo3viv/nHeHSzQw==
X-Received: by 2002:a5d:444d:0:b0:317:ce01:fe99 with SMTP id x13-20020a5d444d000000b00317ce01fe99mr2842389wrr.9.1691695433189;
        Thu, 10 Aug 2023 12:23:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHR0CV1UmR4DNEMAn9v2ToSkc3HIbFYdNRmAuQjKcn2GH2b+kNRcs5y/tG7/rWE1x5qPYNz9w==
X-Received: by 2002:a5d:444d:0:b0:317:ce01:fe99 with SMTP id x13-20020a5d444d000000b00317ce01fe99mr2842373wrr.9.1691695432826;
        Thu, 10 Aug 2023 12:23:52 -0700 (PDT)
Received: from redhat.com ([2.55.27.97])
        by smtp.gmail.com with ESMTPSA id h6-20020a5d6886000000b00317f01fa3c4sm3018221wru.112.2023.08.10.12.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 12:23:52 -0700 (PDT)
Date:   Thu, 10 Aug 2023 15:23:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V3 04/14] virtio-blk: limit max allowed submit queues
Message-ID: <20230810152310-mutt-send-email-mst@kernel.org>
References: <20230808104239.146085-1-ming.lei@redhat.com>
 <20230808104239.146085-5-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808104239.146085-5-ming.lei@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 08, 2023 at 06:42:29PM +0800, Ming Lei wrote:
> Take blk-mq's knowledge into account for calculating io queues.
> 
> Fix wrong queue mapping in case of kdump kernel.
> 
> On arm and ppc64, 'maxcpus=1' is passed to kdump command line, see
> `Documentation/admin-guide/kdump/kdump.rst`, so num_possible_cpus()
> still returns all CPUs because 'maxcpus=1' just bring up one single
> cpu core during booting.
> 
> blk-mq sees single queue in kdump kernel, and in driver's viewpoint
> there are still multiple queues, this inconsistency causes driver to apply
> wrong queue mapping for handling IO, and IO timeout is triggered.
> 
> Meantime, single queue makes much less resource utilization, and reduce
> risk of kernel failure.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

superficially:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

but this patch only makes sense if the rest of patchset is merged.
feel free to merge directly.

> ---
>  drivers/block/virtio_blk.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 1fe011676d07..4ba79fe2a1b4 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -1047,7 +1047,8 @@ static int init_vq(struct virtio_blk *vblk)
>  
>  	num_poll_vqs = min_t(unsigned int, poll_queues, num_vqs - 1);
>  
> -	vblk->io_queues[HCTX_TYPE_DEFAULT] = num_vqs - num_poll_vqs;
> +	vblk->io_queues[HCTX_TYPE_DEFAULT] = min_t(unsigned,
> +			num_vqs - num_poll_vqs, blk_mq_max_nr_hw_queues());
>  	vblk->io_queues[HCTX_TYPE_READ] = 0;
>  	vblk->io_queues[HCTX_TYPE_POLL] = num_poll_vqs;
>  
> -- 
> 2.40.1

