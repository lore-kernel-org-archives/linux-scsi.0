Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF15C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 09:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46AD161CBE
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 09:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhGGJqG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 05:46:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230460AbhGGJqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 05:46:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625651005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oaIwLpusiYwyhpLzYUMthLrmVzW4gUqXL4P+58at9uw=;
        b=X+bBKWtnS2Vk7Sya6gHUR4OrHlv6l6mzPLxs78oaEItXjba+2RROpVMHJTMVWdSLCbGbcA
        uGCPzLkrIUsvJnGP+RhWsrQS0QSJ9TBJsZQCSbfm2u2W1Drymif2qwhEXEOTWuZX3YZ7+R
        6kVzGLj1tz3BsY/skW25MXyyZmF/QSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-NfrNQFSeMuibJaNzREP50w-1; Wed, 07 Jul 2021 05:43:24 -0400
X-MC-Unique: NfrNQFSeMuibJaNzREP50w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1516B804143;
        Wed,  7 Jul 2021 09:43:21 +0000 (UTC)
Received: from T590 (ovpn-12-27.pek2.redhat.com [10.72.12.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 977AC60BD9;
        Wed,  7 Jul 2021 09:43:02 +0000 (UTC)
Date:   Wed, 7 Jul 2021 17:42:54 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
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
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V2 5/6] virtio: add one field into virtio_device for
 recording if device uses managed irq
Message-ID: <YOV3HgWG6F3geECm@T590>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
 <20210702150555.2401722-6-ming.lei@redhat.com>
 <20210706054203.GC17027@lst.de>
 <87bl7eqyr2.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bl7eqyr2.ffs@nanos.tec.linutronix.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 07, 2021 at 11:06:25AM +0200, Thomas Gleixner wrote:
> On Tue, Jul 06 2021 at 07:42, Christoph Hellwig wrote:
> > On Fri, Jul 02, 2021 at 11:05:54PM +0800, Ming Lei wrote:
> >> blk-mq needs to know if the device uses managed irq, so add one field
> >> to virtio_device for recording if device uses managed irq.
> >> 
> >> If the driver use managed irq, this flag has to be set so it can be
> >> passed to blk-mq.
> >
> > I don't think all this boilerplate code make a whole lot of sense.
> > I think we need to record this information deep down in the irq code by
> > setting a flag in struct device only if pci_alloc_irq_vectors_affinity
> > atually managed to allocate multiple vectors and the PCI_IRQ_AFFINITY
> > flag was set.  Then blk-mq can look at that flag, and also check that
> > more than one queue is in used and work based on that.
> 
> Ack.

The problem is that how blk-mq looks at that flag, since the device
representing the controller which allocates irq vectors isn't visible
to blk-mq.

Usually blk-mq(block layer) provides queue limits abstract for drivers
to tell any physical property(dma segment, max sectors, ...) to block
layer, that is why this patch takes this very similar usage to check if
HBA uses managed irq or not.


Thanks, 
Ming

