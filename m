Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AB7C63684
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jan 2022 08:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbiAZIPK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jan 2022 03:15:10 -0500
Received: from verein.lst.de ([213.95.11.211]:38863 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238246AbiAZIPJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jan 2022 03:15:09 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2D9C368AFE; Wed, 26 Jan 2022 09:15:05 +0100 (CET)
Date:   Wed, 26 Jan 2022 09:15:04 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V2 09/13] scsi: force unfreezing queue into atomic mode
Message-ID: <20220126081504.GB23154@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-10-ming.lei@redhat.com> <20220124131516.GH27269@lst.de> <Ye80kxTBojm6GN8k@T590> <20220125072739.GA27777@lst.de> <Ye+605vZEyx3ofi2@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye+605vZEyx3ofi2@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 04:54:43PM +0800, Ming Lei wrote:
> > So what is the advantage of trying to remove the freeze from where
> > it belongs (common unregister code) while keeping it where it is a bandaid
> > (driver specific unregister code)?
> 
> freeze in common unregister code is actually not good, because it provide
> nothing for bio based driver, so we can't move blk-cgroup shutdown into
> del_gendisk. Also we can't move elevator shutdown to del_gendisk for
> similar reason.
> 
> Secondly freeze is pretty slow in percpu mode, so why slow down removing every
> disk just for scsi's bandaid?

I'd frame this differently:

 - del_gendisk is the right place to freeze the queue, as that is where the
   gendisk is unregistered and all fs I/O needs to stop.  If we don't get
   all aspects right we need to fix.  As mentioned I'm already looking into
   keeping a reference for the bio life time for bio based drivers.
 - SCSI is the only driver that ever submits passthrough I/O without the
   gendisk.  So doing an additional freeze during request_queue teardown
   is only needed for SCSI and we can eventually remove that for everyone
   else.  And most of your series already does really good work towards that
   goal!

> 
> 
> Thanks,
> Ming
---end quoted text---
