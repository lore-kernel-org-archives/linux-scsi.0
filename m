Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A549C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 07:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445718AbiAYHai (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 02:30:38 -0500
Received: from verein.lst.de ([213.95.11.211]:34304 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1445283AbiAYH1s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 02:27:48 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 308C868BEB; Tue, 25 Jan 2022 08:27:40 +0100 (CET)
Date:   Tue, 25 Jan 2022 08:27:39 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V2 09/13] scsi: force unfreezing queue into atomic mode
Message-ID: <20220125072739.GA27777@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-10-ming.lei@redhat.com> <20220124131516.GH27269@lst.de> <Ye80kxTBojm6GN8k@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye80kxTBojm6GN8k@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 07:21:55AM +0800, Ming Lei wrote:
> > > @@ -3670,7 +3670,7 @@ static void scsi_disk_release(struct device *dev)
> > >  	 * in case multiple processes open a /dev/sd... node concurrently.
> > >  	 */
> > >  	blk_mq_freeze_queue(q);
> > > -	blk_mq_unfreeze_queue(q);
> > > +	__blk_mq_unfreeze_queue(q, true);
> > 
> > I think the right thing here is to drop the freeze/unfreeze pair.
> > Now that del_gendisk properly freezes the queue, we don't need this
> > protection as the issue that Bart fixed with it can't happen any more.
> 
> As you see, the last patch removes freeze/unfreeze pair in del_gendisk(),
> which looks not very useful: it can't drain IO on bio based driver, and
> del_gendisk() is supposed to provide consistent behavior for both request
> and bio based driver.

So what is the advantage of trying to remove the freeze from where
it belongs (common unregister code) while keeping it where it is a bandaid
(driver specific unregister code)?
