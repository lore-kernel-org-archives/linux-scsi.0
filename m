From: "hch@lst.de" <hch@lst.de>
Subject: Re: scsi: introduce a new result field in struct scsi_request
Date: Wed, 19 Apr 2017 08:14:44 +0200
Message-ID: <20170419061444.GB6257@lst.de>
References: <20170418155229.5977-1-hch@bombadil.infradead.org> <20170418155229.5977-8-hch@bombadil.infradead.org> <1492554858.2689.17.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33597 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759900AbdDSGOp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Apr 2017 02:14:45 -0400
Content-Disposition: inline
In-Reply-To: <1492554858.2689.17.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@bombadil.infradead.org" <hch@bombadil.infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Tue, Apr 18, 2017 at 10:34:20PM +0000, Bart Van Assche wrote:
> Did you perhaps intend "req->result" instead of "rq->result"?

Yes.

> Did you intend "war" or is that perhaps a typo?

I'll fix the comment.

> >  	trace_scsi_dispatch_cmd_done(cmd);
> > -	blk_mq_complete_request(cmd->request, cmd->request->errors);
> > +	blk_mq_complete_request(cmd->request, 0);
> >  }
> 
> Why has cmd->request->errors been changed into 0?

Because the argument is only used to set req->errors, which we won't
look at any more.
