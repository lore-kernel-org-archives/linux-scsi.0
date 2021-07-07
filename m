Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB60DC07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 10:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0AFD61CAC
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 10:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhGGK4J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 06:56:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231220AbhGGK4I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 06:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625655206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K+EWc05GzZnbdXQqGI6q0RxvYbPzZlg3v0dwhXJ+Y2E=;
        b=hazeZi19ktfppxmi3rCFiIU8j452bvu4qJ0v1JIL+n9ihzTgzWp5lf0bf2HmdJgqCvWdlx
        it3CG2rLVbgDyVMTdhBfvrkSKWip8/J9QDNOWXuOAOfuR+psnS9WgUwavY0oN3ro50bUaJ
        mCzuP13wj5HzMVPQ3WbBYAQJEmWteGg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-rXwPL51rMsO23RrVkwLSlA-1; Wed, 07 Jul 2021 06:53:25 -0400
X-MC-Unique: rXwPL51rMsO23RrVkwLSlA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED228802C89;
        Wed,  7 Jul 2021 10:53:23 +0000 (UTC)
Received: from T590 (ovpn-12-84.pek2.redhat.com [10.72.12.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9147069CB8;
        Wed,  7 Jul 2021 10:53:07 +0000 (UTC)
Date:   Wed, 7 Jul 2021 18:53:02 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, John Garry <john.garry@huawei.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V2 3/6] scsi: add flag of .use_managed_irq to 'struct
 Scsi_Host'
Message-ID: <YOWHjn7S4Otbs93U@T590>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
 <20210702150555.2401722-4-ming.lei@redhat.com>
 <47fc5ed1-29e3-9226-a111-26c271cb6d90@huawei.com>
 <YOLXJZF7wo/IiFMU@T590>
 <20210706053719.GA17027@lst.de>
 <YOQJD2dgeb8wobOk@T590>
 <fb71bccf-0d92-68ed-ad42-cac23fede5a8@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb71bccf-0d92-68ed-ad42-cac23fede5a8@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 06, 2021 at 12:32:27PM +0200, Hannes Reinecke wrote:
> On 7/6/21 9:41 AM, Ming Lei wrote:
> > On Tue, Jul 06, 2021 at 07:37:19AM +0200, Christoph Hellwig wrote:
> > > On Mon, Jul 05, 2021 at 05:55:49PM +0800, Ming Lei wrote:
> > > > The thing is that blk_mq_pci_map_queues() is allowed to be called for
> > > > non-managed irqs. Also some managed irq consumers don't use blk_mq_pci_map_queues().
> > > > 
> > > > So this way just provides hint about managed irq uses, but we really
> > > > need to get this flag set if driver uses managed irq.
> > > 
> > > blk_mq_pci_map_queues is absolutely intended to only be used by
> > > managed irqs.  I wonder if we can enforce that somehow?
> > 
> > It may break some scsi drivers.
> > 
> > And blk_mq_pci_map_queues() just calls pci_irq_get_affinity() to
> > retrieve the irq's affinity, and the irq can be one non-managed irq,
> > which affinity is set via either irq_set_affinity_hint() from kernel
> > or /proc/irq/.
> > 
> But that's static, right? IE blk_mq_pci_map_queues() will be called once
> during module init; so what happens if the user changes the mapping later
> on? How will that be transferred to the driver?

Yeah, that may not work well enough, but still works since non-managed
irq supports migration.

And there are several SCSI drivers which provide module parameter to
enable/disable managed irq, meantime blk_mq_pci_map_queues() is always
called for mapping queues.


Thanks,
Ming

