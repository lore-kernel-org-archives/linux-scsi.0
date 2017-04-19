From: "hch@lst.de" <hch@lst.de>
Subject: Re: blk-mq: remove the error argument to blk_mq_complete_request
Date: Wed, 19 Apr 2017 19:54:07 +0200
Message-ID: <20170419175407.GB25761@lst.de>
References: <20170418155229.5977-1-hch@bombadil.infradead.org> <20170418155229.5977-16-hch@bombadil.infradead.org> <1492555816.2689.20.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36695 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968698AbdDSRyJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Apr 2017 13:54:09 -0400
Content-Disposition: inline
In-Reply-To: <1492555816.2689.20.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@bombadil.infradead.org" <hch@bombadil.infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Tue, Apr 18, 2017 at 10:50:18PM +0000, Bart Van Assche wrote:
> On Tue, 2017-04-18 at 08:52 -0700, Christoph Hellwig wrote:
> > Now that we always have a ->complete callback we can remove the direct
> > call to blk_mq_end_request, as well as the error argument to
> > blk_mq_complete_request.
> 
> Hello Christoph,
> 
> Please add a runtime check that issues a warning early if a .complete
> callback function is missing.
> 
> Are you sure that all blk-mq drivers have a .complete callback? In the
> request-errors branch of your block git tree I found the following:

I think the problem is that my above changelog was wrong - we only
require the complete_rq method if the driver calls the
blk_mq_complete_request function.  Both rbd and ubiblock don't in
the tree.  They probably should, but that's work for a separate
series.
