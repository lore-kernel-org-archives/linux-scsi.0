Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF0AC07E99
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 09:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 953BA613C1
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 09:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhGEJ6r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 05:58:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230291AbhGEJ6q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 05:58:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625478969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PeaDOEsW8hmBgMT8bkDyX/sakYJ1dxNWFoVs9+ntx2c=;
        b=jI2HqPk3mNcS9DAeCi0p0cTPEw8+sK2E9Cib0IEipAXo/9oYYpllyhTU5kB1cESLIaFme3
        ZbSGvkqP2Z8psiPyHVBS1s3WdtRtLmYwQ9ps8s1LIbkI4El1fU9YA4gdPKeujFVhIDHZkd
        23nOcGNPIoWAkNYzjEAUcp2ZbLxBR1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-L6ETD3HBN4mQzsy7WT4bmg-1; Mon, 05 Jul 2021 05:56:06 -0400
X-MC-Unique: L6ETD3HBN4mQzsy7WT4bmg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0BA5802E29;
        Mon,  5 Jul 2021 09:56:03 +0000 (UTC)
Received: from T590 (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D32B42EB04;
        Mon,  5 Jul 2021 09:55:54 +0000 (UTC)
Date:   Mon, 5 Jul 2021 17:55:49 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V2 3/6] scsi: add flag of .use_managed_irq to 'struct
 Scsi_Host'
Message-ID: <YOLXJZF7wo/IiFMU@T590>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
 <20210702150555.2401722-4-ming.lei@redhat.com>
 <47fc5ed1-29e3-9226-a111-26c271cb6d90@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47fc5ed1-29e3-9226-a111-26c271cb6d90@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 05, 2021 at 10:25:38AM +0100, John Garry wrote:
> On 02/07/2021 16:05, Ming Lei wrote:
> > blk-mq needs this information of using managed irq for improving
> > deactivating hctx, so add such flag to 'struct Scsi_Host', then
> > drivers can pass such flag to blk-mq via scsi_mq_setup_tags().
> > 
> > The rule is that driver has to tell blk-mq if managed irq is used.
> > 
> > Signed-off-by: Ming Lei<ming.lei@redhat.com>
> 
> As was said before, can we have something like this instead of relying on
> the LLDs to do the setting:
> 
> --------->8------------
> 
> diff --git a/block/blk-mq-pci.c b/block/blk-mq-pci.c
> index b595a94c4d16..2037a5b69fe1 100644
> --- a/block/blk-mq-pci.c
> +++ b/block/blk-mq-pci.c
> @@ -37,7 +37,7 @@ int blk_mq_pci_map_queues(struct blk_mq_queue_map *qmap,
> struct pci_dev *pdev,
>  		for_each_cpu(cpu, mask)
>  			qmap->mq_map[cpu] = qmap->queue_offset + queue;
>  	}
> -
> +	qmap->drain_hwq = 1;

The thing is that blk_mq_pci_map_queues() is allowed to be called for
non-managed irqs. Also some managed irq consumers don't use blk_mq_pci_map_queues().

So this way just provides hint about managed irq uses, but we really
need to get this flag set if driver uses managed irq.


Thanks,
Ming

