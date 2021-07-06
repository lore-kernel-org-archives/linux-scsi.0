Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9584C07E9B
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 07:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D7461483
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 07:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhGFH4o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 03:56:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230255AbhGFH4n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 03:56:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625558044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8ux+PSgT2GR6+4EgHNJBMyL9fh1iK5spRQecJIWp478=;
        b=WELGduoosPb8pJqir8wA6lbNdU1S0gd+QiZ2GA5H3Y26IBP0eKU9FPi940YG5xbs/r0jHh
        opFbd4qvRYzUuBJjwXmdvB2B2TlMr3SinIiLKXnzXD6d/L3ubHb7kQvyK0ad2cC/YH45Yt
        T8mlB3clxKfPovXmarWtWhGqGDl1Fco=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-_18DDJ-UNGCsMLIxyYEdRQ-1; Tue, 06 Jul 2021 03:54:01 -0400
X-MC-Unique: _18DDJ-UNGCsMLIxyYEdRQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 756188030B0;
        Tue,  6 Jul 2021 07:53:59 +0000 (UTC)
Received: from T590 (ovpn-12-27.pek2.redhat.com [10.72.12.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F1FCF5D9DE;
        Tue,  6 Jul 2021 07:53:43 +0000 (UTC)
Date:   Tue, 6 Jul 2021 15:53:39 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 5/6] virtio: add one field into virtio_device for
 recording if device uses managed irq
Message-ID: <YOQMAwE0HPh0rzby@T590>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
 <20210702150555.2401722-6-ming.lei@redhat.com>
 <20210706054203.GC17027@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706054203.GC17027@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 06, 2021 at 07:42:03AM +0200, Christoph Hellwig wrote:
> On Fri, Jul 02, 2021 at 11:05:54PM +0800, Ming Lei wrote:
> > blk-mq needs to know if the device uses managed irq, so add one field
> > to virtio_device for recording if device uses managed irq.
> > 
> > If the driver use managed irq, this flag has to be set so it can be
> > passed to blk-mq.
> 
> I don't think all this boilerplate code make a whole lot of sense.
> I think we need to record this information deep down in the irq code by
> setting a flag in struct device only if pci_alloc_irq_vectors_affinity
> atually managed to allocate multiple vectors and the PCI_IRQ_AFFINITY
> flag was set.  Then blk-mq can look at that flag, and also check that
> more than one queue is in used and work based on that.

How can blk-mq look at that flag? Usually blk-mq doesn't play with
physical device(HBA).

So far almost all physically properties(segment, max_hw_sectors, ...)
are not provided to blk-mq directly, instead by queue limits abstract.

Thanks,
Ming

