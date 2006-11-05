From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] [SCSI] Print only a single message "rejecting I/O to device being removed"
Date: Sun, 5 Nov 2006 12:36:29 +0100
Message-ID: <20061105113628.GU13555@kernel.dk>
References: <20061103122959.GG13555@kernel.dk> <903051.57293.qm@web31801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:26193 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S932657AbWKELe1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Nov 2006 06:34:27 -0500
Content-Disposition: inline
In-Reply-To: <903051.57293.qm@web31801.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Nov 04 2006, Luben Tuikov wrote:
> --- Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Fri, Nov 03 2006, Luben Tuikov wrote:
> > > ... at device removal.
> > > 
> > > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > > ---
> > >  drivers/scsi/scsi_lib.c    |   10 +++++++---
> > >  drivers/scsi/scsi_scan.c   |    1 +
> > >  include/scsi/scsi_device.h |    3 +++
> > >  3 files changed, 11 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index 7b0f9a3..f0de7ca 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -1302,9 +1302,13 @@ static int scsi_prep_fn(struct request_q
> > >  			if(specials_only == SDEV_QUIESCE ||
> > >  					specials_only == SDEV_BLOCK)
> > >  				goto defer;
> > > -			
> > > -			sdev_printk(KERN_ERR, sdev,
> > > -				    "rejecting I/O to device being removed\n");
> > > +
> > > +			if (sdev->num_rej_messages > 0) {
> > > +				sdev->num_rej_messages--;
> > > +				sdev_printk(KERN_ERR, sdev,
> > > +					    "rejecting I/O to device "
> > > +					    "being removed\n");
> > > +			}
> > 
> > How about using some variant of printk_ratelimit() instead?
> 
> Jens, I didn't think to use such a heavy-weight as printk_ratelimit()
> (grabbing irq spinlocks et al), since the device struct would be
> "freed" shortly.  FWIW, one message is more than enough. I'm being
> liberal with 5, but would gladly revert it back to the original
> of one message.

It's a printk, it doesn't matter how heavy weight it is. Just seems
silly to re-invent some sort of printk limiter, when one already exists.

> Feel free to resubmit using printk_ratelimit().

Sorry no plans to do that, I'll let James decide what he wants to take
or not.

-- 
Jens Axboe

