Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07212C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 01:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjG0BHt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 21:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjG0BHs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 21:07:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675561BC1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 18:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690420025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ep/tgo1JF7kq+mSuQqf46nxDpvZxtSkMn2UHXJJVSFE=;
        b=SFYWEsTyk8Syaqg4IeV0C/YhFAYAdtBE+Wx3ESviKJol7BUY9W34WE0bUtEZn1Pxr2KXMg
        dstOOWLEU6cK7YB/OIzSwodVbTiL+Re4VlPMYDrFRw/jDxAN8nLDMnHgKySycjQ2E0dUhO
        8R+B17a+TjLbxAvpjBQspSxPG/0KA3M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-HTE6F5RpM4i9E-KzSY3P5w-1; Wed, 26 Jul 2023 21:07:02 -0400
X-MC-Unique: HTE6F5RpM4i9E-KzSY3P5w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 874D7185A78F;
        Thu, 27 Jul 2023 01:07:01 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 008CFC2C7D3;
        Thu, 27 Jul 2023 01:06:55 +0000 (UTC)
Date:   Thu, 27 Jul 2023 09:06:50 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.g.garry@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, ming.lei@redhat.com
Subject: Re: [PATCH V2 1/9] blk-mq: add blk_mq_max_nr_hw_queues()
Message-ID: <ZMHDKkFDISWAJrdC@ovpn-8-16.pek2.redhat.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
 <20230726094027.535126-2-ming.lei@redhat.com>
 <b7818133-6d1e-457d-a62f-360523e936c8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7818133-6d1e-457d-a62f-360523e936c8@oracle.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 26, 2023 at 05:36:34PM +0100, John Garry wrote:
> On 26/07/2023 10:40, Ming Lei wrote:
> 
> Hi Ming,
> 
> > blk_mq_alloc_tag_set() may override set->nr_hw_queues as 1 in case of kdump
> > kernel. This way causes trouble for driver, because blk-mq and driver see
> > different queue mapping. Especially the only online CPU may not be 1 for
> > kdump kernel, in which 'maxcpus=1' is passed from kernel command line,
> 
> "the only online CPU may not be 1 for kdump kernel, in which 'maxcpus=1'
> ..." - this seems inconsistent with the cover letter, where we have
> "'maxcpus=1' just bring up one single cpu core during booting."

OK, looks I should have mentioned "the only online CPU may not be 1 for
maxcpus=1" in cover letter.

> > then driver may map hctx0 into one inactive real hw queue which cpu
> > affinity is 0(offline).
> > 
> > The issue exists on all drivers which use managed irq and support
> > multiple hw queue.
> > 
> > Prepare for fixing this kind of issue by applying the added helper, so
> > driver can take blk-mq max nr_hw_queues knowledge into account when
> > calculating io queues.
> 
> Could you alternatively solve in blk_mq_pci_map_queues() by fixing the
> mappings in case of kdump to have all per-CPU mappings point at the HW queue
> associated with cpu0 (which I assume would be active)? It ain't pretty ...

cpu0 mapping isn't correct, as I mentioned that 'maxcpus=1' doesn't
mean the only online cpu is cpu0, such as, on ppc64, the only online
cpu could be selected at random during booting.

> 
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   block/blk-mq.c         | 16 ++++++++++++++++
> >   include/linux/blk-mq.h |  1 +
> >   2 files changed, 17 insertions(+)
> > 
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index b04ff6f56926..617d6f849a7b 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -140,6 +140,22 @@ void blk_mq_freeze_queue_wait(struct request_queue *q)
> >   }
> >   EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait);
> > +/*
> > + * Return the max supported nr_hw_queues for each hw queue type
> > + *
> > + * blk_mq_alloc_tag_set() may change nr_hw_queues for kdump kernel, so
> > + * driver has to take blk-mq max supported nr_hw_queues into account
> > + * when figuring out nr_hw_queues from hardware info, for avoiding
> > + * inconsistency between driver and blk-mq.
> > + */
> > +unsigned int blk_mq_max_nr_hw_queues(void)
> > +{
> > +	if (is_kdump_kernel())
> > +		return 1;
> > +	return nr_cpu_ids;
> > +}
> 
> We rely on the driver having set->nr_hw_queues == 1 for kdump, right?
> 
> If so, how about enforcing it then, like:
> 
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -4426,7 +4426,8 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
>         * 64 tags to prevent using too much memory.
>         */
>        if (is_kdump_kernel()) {
> -               set->nr_hw_queues = 1;
> +               if (set->nr_hw_queues != 1)
> +                       return -EINVAL;
>                set->nr_maps = 1;
>                set->queue_depth = min(64U, set->queue_depth);
>        }

In theory, this way should be ideal approach, but it needs all MQ drivers
to get converted with blk_mq_max_nr_hw_queues().

However, it shouldn't be one issue for non-managed irq given non-managed
irq can be migrated to the only online cpu.


Thanks,
Ming

