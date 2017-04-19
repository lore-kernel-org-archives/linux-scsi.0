From: "hch@lst.de" <hch@lst.de>
Subject: Re: block: remove the blk_execute_rq return value
Date: Wed, 19 Apr 2017 08:13:23 +0200
Message-ID: <20170419061323.GA6257@lst.de>
References: <20170418155229.5977-1-hch@bombadil.infradead.org> <20170418155229.5977-2-hch@bombadil.infradead.org> <1492554253.2689.15.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33589 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759956AbdDSGNZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Apr 2017 02:13:25 -0400
Content-Disposition: inline
In-Reply-To: <1492554253.2689.15.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@bombadil.infradead.org" <hch@bombadil.infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Tue, Apr 18, 2017 at 10:24:15PM +0000, Bart Van Assche wrote:
> On Tue, 2017-04-18 at 08:52 -0700, Christoph Hellwig wrote:
> > diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
> > index b05e151c9b38..82c6d02193ae 100644
> > --- a/drivers/block/paride/pd.c
> > +++ b/drivers/block/paride/pd.c
> > @@ -747,7 +747,8 @@ static int pd_special_command(struct pd_unit *disk,
> >  
> >  	rq->special = func;
> >  
> > -	err = blk_execute_rq(disk->gd->queue, disk->gd, rq, 0);
> > +	blk_execute_rq(disk->gd->queue, disk->gd, rq, 0);
> > +	err = req->errors ? -EIO : 0;
> >  
> >  	blk_put_request(rq);
> >  	return err;
> 
> Hello Christoph,
> 
> Sorry that I hadn't noticed this before but shouldn't "req" be changed into
> "rq"? Otherwise this patch looks fine to me. If this comment gets addressed
> you can add:

It should.  But it seems this no one caught this because the check gets
removed later in the series by "pd: remove bogus check for req->errors",
so I should just move that patch earlier in the series.
