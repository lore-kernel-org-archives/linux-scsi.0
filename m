From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH RESEND] scsi: return correct blkprep status code in case
 scsi_init_io() fails.
Date: Wed, 12 Apr 2017 08:54:13 +0200
Message-ID: <20170412065413.GA4988@linux-x5ow.site>
References: <20170411074644.6071-1-jthumshirn@suse.de>
 <1491936200.2654.18.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491936200.2654.18.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 11, 2017 at 06:43:22PM +0000, Bart Van Assche wrote:
> On Tue, 2017-04-11 at 09:46 +0200, Johannes Thumshirn wrote:
> > When instrumenting the SCSI layer to run into the
> > !blk_rq_nr_phys_segments(rq) case the following  warning emitted from the
> > block layer:
> > 
> > blk_peek_request: bad return=-22
> > 
> > This happens because since commit fd3fc0b4d730 ('scsi: don't BUG_ON()
> > empty DMA transfers') we return the wrong error value from iscsi_prep_fn()
>                                                              ^^^^^^^^^^^^^^^
> There is no iscsi_prep_fn() in the kernel tree. Did you perhaps mean
> scsi_prep_fn()?

*doh* Yup, you're right.

> 
> > back to the block layer.
> > 
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > Fixes: fd3fc0b4d730 scsi: don't BUG_ON() empty DMA transfers
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Commit fd3fc0b4d730 has a "Cc: stable" tag. I assume that that means that
> this patch also needs that tag?

Probably yes. I'll include both "fixes" in my resend.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
