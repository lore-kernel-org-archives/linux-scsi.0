Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8499C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 14:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF00D61157
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 14:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240669AbhHSO7I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 10:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240563AbhHSO7H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Aug 2021 10:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78B7C600CC;
        Thu, 19 Aug 2021 14:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629385111;
        bh=d1ZrYuBgxQrYKEiHUt8gEL89IWjUwToNfik22onXj3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qW9z4aXL8rfteGmaWxKJwkBG5/VnJvjle4qMQkRZw5oVMFmTmhwkA28mUTcJ5czwG
         wbbW4tAaffiaRxgK9KaQW2Nom2GvGqpK0J1AN+FfgUWCCYYGvj7fJ5/UTMTORNOJLO
         xZvg/t5ikzvQExA+EByJlEoY1ofJzTtSfyfI/JgBM8ke5nBx72KEyIZ5dSpWaBiwnx
         R8WyC3wlGnx2rvCppp7/0GVbxlzmQIftrAXdDwExR7e8aQCrRsEeSWZgThVUZ02zbz
         LXrgQVusUoUIu17ZJg/TWvOXlgxJ+RcIbXRekbq6ivD5yXyogeAkkm3dvsrEi5LWyN
         lxUPY6PYmkhlQ==
Date:   Thu, 19 Aug 2021 07:58:28 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/9] nvme: use blk_mq_alloc_disk
Message-ID: <20210819145828.GA227577@dhcp-10-100-145-180.wdc.com>
References: <20210816131910.615153-1-hch@lst.de>
 <20210816131910.615153-2-hch@lst.de>
 <20210819145455.GA227568@dhcp-10-100-145-180.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819145455.GA227568@dhcp-10-100-145-180.wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 19, 2021 at 07:54:55AM -0700, Keith Busch wrote:
> On Mon, Aug 16, 2021 at 03:19:02PM +0200, Christoph Hellwig wrote:
> > @@ -3729,9 +3729,14 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
> >  	if (!ns)
> >  		goto out_free_id;
> >  
> > -	ns->queue = blk_mq_init_queue(ctrl->tagset);
> > -	if (IS_ERR(ns->queue))
> > +	disk = blk_mq_alloc_disk(ctrl->tagset, ns);
> > +	if (IS_ERR(disk))
> >  		goto out_free_ns;
> > +	disk->fops = &nvme_bdev_ops;
> > +	disk->private_data = ns;
> > +
> > +	ns->disk = disk;
> > +	ns->queue = disk->queue;
> >  
> >  	if (ctrl->opts && ctrl->opts->data_digest)
> >  		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, ns->queue);
> > @@ -3740,20 +3745,12 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
> >  	if (ctrl->ops->flags & NVME_F_PCI_P2PDMA)
> >  		blk_queue_flag_set(QUEUE_FLAG_PCI_P2PDMA, ns->queue);
> >  
> > -	ns->queue->queuedata = ns;
> >  	ns->ctrl = ctrl;
> >  	kref_init(&ns->kref);
> 
> With this removal, I don't find queuedata being set anywhere, but
> the driver still uses it in various places expecting 'ns'. Am I missing
> something? Should all nvme's queuedata references be changed to
> q->disk->private_data?

Oops, I see the queuedata is set via blk_mq_alloc_disk().

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>
