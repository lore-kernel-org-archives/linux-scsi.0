From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: error processing + rw 6 byte fix
Date: Sat, 27 Aug 2005 09:17:33 +0200
Message-ID: <20050827071729.GL4018@suse.de>
References: <430994BC.4060102@torque.net> <20050823071338.GA11233@suse.de> <430B1799.1060800@torque.net> <430FDD73.6050200@pobox.com> <430FF537.7010705@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <430FF537.7010705@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 27 2005, Douglas Gilbert wrote:
> Jeff Garzik wrote:
> > Does the attached look OK to everybody?
> > 
> 
> Jeff,
> Yes.
> 
> And after an exchange with Jens, it would probably be
> safer to map transfer_length=0 for READ_10 and READ_16
> (as well as WRITE_10 and WRITE_16) to a nop on the ATA
> side. Otherwise an ATA disk may attempt to transfer 2**16
> sectors. [Only READ_6 and WRITE_6 have the quirky "0 means
> 256" definition, in the larger commands "0 means 0".]

Yes, that part needs to be added as well. Jeff, the below looks good for
the READ/WRITE_6 case.

> >  	if (scsicmd[0] == READ_6 || scsicmd[0] == WRITE_6) {
> >  		qc->nsect = tf->nsect = scsicmd[4];
> > +		if (!qc->nsect) {
> > +			qc->nsect = 256;
> > +			if (lba48)
> > +				tf->hob_nsect = 1;
> > +		}
> > +
> >  		tf->lbal = scsicmd[3];
> >  		tf->lbam = scsicmd[2];
> >  		tf->lbah = scsicmd[1] & 0x1f; /* mask out reserved bits */
> 
> 

-- 
Jens Axboe

