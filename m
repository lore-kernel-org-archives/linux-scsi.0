Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3907C07E96
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 05:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF46D6198F
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 05:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhGFFoq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 01:44:46 -0400
Received: from verein.lst.de ([213.95.11.211]:59181 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230004AbhGFFop (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Jul 2021 01:44:45 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AE7AF68BEB; Tue,  6 Jul 2021 07:42:03 +0200 (CEST)
Date:   Tue, 6 Jul 2021 07:42:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20210706054203.GC17027@lst.de>
References: <20210702150555.2401722-1-ming.lei@redhat.com> <20210702150555.2401722-6-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702150555.2401722-6-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 02, 2021 at 11:05:54PM +0800, Ming Lei wrote:
> blk-mq needs to know if the device uses managed irq, so add one field
> to virtio_device for recording if device uses managed irq.
> 
> If the driver use managed irq, this flag has to be set so it can be
> passed to blk-mq.

I don't think all this boilerplate code make a whole lot of sense.
I think we need to record this information deep down in the irq code by
setting a flag in struct device only if pci_alloc_irq_vectors_affinity
atually managed to allocate multiple vectors and the PCI_IRQ_AFFINITY
flag was set.  Then blk-mq can look at that flag, and also check that
more than one queue is in used and work based on that.
