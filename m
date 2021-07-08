Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D7BC11F66
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 06:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB9F161CD1
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 06:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhGHGiN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jul 2021 02:38:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230462AbhGHGiL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2021 02:38:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625726129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zPy2uiaqDpvQKzXrMQTnHDaQviTPg5vo1248ee1WfqU=;
        b=RHu2CLoRLG5KfJcCTmrnnqRvASauzbakAjf0y5nfgC4rbeVo4ONIPRqSc8NLnc99b/LTmH
        DiWC3FMRpepa3F861CzU2UDGhFJ3zrdm8lFTp7VwHro5lntnIIZPvzgJJJCdQaQXMppKjY
        cPQ3MCUltpAeAU8v/YEe7g4oiP2Ox1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-eKj7iy7QOOuaFRG8CwjXVQ-1; Thu, 08 Jul 2021 02:35:25 -0400
X-MC-Unique: eKj7iy7QOOuaFRG8CwjXVQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39804100C660;
        Thu,  8 Jul 2021 06:35:23 +0000 (UTC)
Received: from T590 (ovpn-12-112.pek2.redhat.com [10.72.12.112])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A42B5D6A8;
        Thu,  8 Jul 2021 06:35:04 +0000 (UTC)
Date:   Thu, 8 Jul 2021 14:34:59 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
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
Message-ID: <YOack2zlRnGmjWWz@T590>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
 <20210702150555.2401722-6-ming.lei@redhat.com>
 <20210706054203.GC17027@lst.de>
 <87bl7eqyr2.ffs@nanos.tec.linutronix.de>
 <YOV3HgWG6F3geECm@T590>
 <20210707140529.GA24637@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707140529.GA24637@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 07, 2021 at 04:05:29PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 07, 2021 at 05:42:54PM +0800, Ming Lei wrote:
> > The problem is that how blk-mq looks at that flag, since the device
> > representing the controller which allocates irq vectors isn't visible
> > to blk-mq.
> 
> In blk_mq_pci_map_queues and similar helpers.

Firstly it depends if drivers call into these helpers, so this way
is fragile.

Secondly, I think it isn't good to expose specific physical devices
into blk-mq which shouldn't deal with physical device directly, also
all the three helpers just duplicates same logic except for retrieving
each vector's affinity from specific physical device.

I will think about how to cleanup them.


Thanks,
Ming

