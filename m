From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] 2.5.51 SCSI_IOCTL_GET_IDLUN + _GET_BUS_NUMBER
Date: Thu, 12 Dec 2002 21:40:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021212204026.GB11892@suse.de>
References: <3DF83E4F.8000704@torque.net> <200212121427.gBCERG502453@localhost.localdomain> <20021212174241.GB6481@suse.de> <20021212203903.A8484@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021212203903.A8484@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, dougg@torque.net, linux-scsi@vger.kernel.org

On Thu, Dec 12 2002, Christoph Hellwig wrote:
> On Thu, Dec 12, 2002 at 06:42:41PM +0100, Jens Axboe wrote:
> > Hmm, I _may_ be wrong but I think the main reason for GET_IDLUN and
> > GET_BUS_NUMBER in the generic block layer is to stop them from failing
> > in libscg and thus fooling it into believing we are scsi. You would need
> > to check libscg/scsi-linux-sg.c to be sure.
> > 
> > For one thing, we need to maintain the behaviour we have now of _not_
> > failing them for ata devices. If you want to pass them down to SCSI as
> > well and get the right id/lun and bus, fine, but don't break the ata
> > one.
> 
> I disagree.  USerspace needs changes to support SG_IO on block device anyway
> so we should do it properly.  There is no harm in changing interface during

How do you figure? Some of them probably, but most should just work
(provided they use SG_IO ioctl, of course).

> 2.5.  IMHO most of the silly sg ioctl stubs in drivers/block/scsi_ioctl.c
> should just die.

Feel free, I don't have time to do it right now.

-- 
Jens Axboe

