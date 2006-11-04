From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 1/2] [SCSI] Print only a single message "rejecting I/O to device being removed"
Date: Sat, 4 Nov 2006 11:51:34 -0800 (PST)
Message-ID: <903051.57293.qm@web31801.mail.mud.yahoo.com>
References: <20061103122959.GG13555@kernel.dk>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:3943 "HELO
	web31801.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S965354AbWKDTvg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 14:51:36 -0500
In-Reply-To: <20061103122959.GG13555@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--- Jens Axboe <jens.axboe@oracle.com> wrote:
> On Fri, Nov 03 2006, Luben Tuikov wrote:
> > ... at device removal.
> > 
> > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > ---
> >  drivers/scsi/scsi_lib.c    |   10 +++++++---
> >  drivers/scsi/scsi_scan.c   |    1 +
> >  include/scsi/scsi_device.h |    3 +++
> >  3 files changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 7b0f9a3..f0de7ca 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1302,9 +1302,13 @@ static int scsi_prep_fn(struct request_q
> >  			if(specials_only == SDEV_QUIESCE ||
> >  					specials_only == SDEV_BLOCK)
> >  				goto defer;
> > -			
> > -			sdev_printk(KERN_ERR, sdev,
> > -				    "rejecting I/O to device being removed\n");
> > +
> > +			if (sdev->num_rej_messages > 0) {
> > +				sdev->num_rej_messages--;
> > +				sdev_printk(KERN_ERR, sdev,
> > +					    "rejecting I/O to device "
> > +					    "being removed\n");
> > +			}
> 
> How about using some variant of printk_ratelimit() instead?

Jens, I didn't think to use such a heavy-weight as printk_ratelimit()
(grabbing irq spinlocks et al), since the device struct would be
"freed" shortly.  FWIW, one message is more than enough. I'm being
liberal with 5, but would gladly revert it back to the original
of one message.

Feel free to resubmit using printk_ratelimit().

     Luben

