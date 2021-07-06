Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FCCDC07E96
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 05:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F8BC61977
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 05:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhGFFkC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 01:40:02 -0400
Received: from verein.lst.de ([213.95.11.211]:59146 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230004AbhGFFkC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Jul 2021 01:40:02 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0785068BEB; Tue,  6 Jul 2021 07:37:20 +0200 (CEST)
Date:   Tue, 6 Jul 2021 07:37:19 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     John Garry <john.garry@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20210706053719.GA17027@lst.de>
References: <20210702150555.2401722-1-ming.lei@redhat.com> <20210702150555.2401722-4-ming.lei@redhat.com> <47fc5ed1-29e3-9226-a111-26c271cb6d90@huawei.com> <YOLXJZF7wo/IiFMU@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOLXJZF7wo/IiFMU@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 05, 2021 at 05:55:49PM +0800, Ming Lei wrote:
> The thing is that blk_mq_pci_map_queues() is allowed to be called for
> non-managed irqs. Also some managed irq consumers don't use blk_mq_pci_map_queues().
> 
> So this way just provides hint about managed irq uses, but we really
> need to get this flag set if driver uses managed irq.

blk_mq_pci_map_queues is absolutely intended to only be used by
managed irqs.  I wonder if we can enforce that somehow?
