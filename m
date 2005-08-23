From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: error processing + rw 6 byte fix
Date: Tue, 23 Aug 2005 14:44:02 +0200
Message-ID: <20050823124401.GH16461@suse.de>
References: <430994BC.4060102@torque.net> <20050823071338.GA11233@suse.de> <430B1799.1060800@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <430B1799.1060800@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 23 2005, Douglas Gilbert wrote:
> Jens Axboe wrote:
> > On Mon, Aug 22 2005, Douglas Gilbert wrote:
> > 
> >> 	if (scsicmd[0] == READ_6 || scsicmd[0] == WRITE_6) {
> >>-		qc->nsect = tf->nsect = scsicmd[4];
> >>+		if (scsicmd[4] == 0) {
> >>+			/*
> >>+			 * For READ_6 and WRITE_6 (only)
> >>+			 * transfer_len==0 -> 256 blocks !!
> >>+			 */
> >>+			if (lba48) {
> >>+				tf->hob_nsect = 1;
> >>+				qc->nsect = 256;
> >>+			} else
> >>+				return 1;
> > 
> > 
> > This isn't quite right, for 28-bit lba a 0 sector value means 256
> > sectors to transfer as well. So just make that:
> > 
> >         if (lba48) {
> >                 tf->hob_nsect = 1;
> >                 qc->nsect = 256;
> >         }
> > 
> >         /* continue */
> > 
> > and it should work fine. Similarly for 48-bit lba, 0 means 16^2 sectors.
> 
> Jens,
> Since for 28-bit lba a 0 sector value means 256 sectors
> do I need to check for the lba48 case at all? As proposed
> to Jeff is this ok (for READ_6 and WRITE_6):
> 
>        if (scsicmd[4] == 0) {
>            /*
>             * For READ_6 and WRITE_6 (only)
>             * transfer_len==0 -> 256 blocks !!
>             */
>            qc->nsect = 256;
>        } else
>            qc->nsect = scsicmd[4];
>        tf->nsect = scsicmd[4];

This will break for lba48 devices, since if you have scsicmd[4] == 0, a
lba48 read/write will want to transfer 65536 sectors instead of the
intended 256.

Your qc->nsect logic is correct, but you need to set tf->hob_nsect 1
for lba48 if scsicmd[4] == 0 to correctly tell that command to transfer
256 sectors.

> Also I noticed while testing the original code with READ_6
> (sectors=0) that the device locked up (power cycle required).
> So given the point you make for 48-bit lba, 0 means 16^2
> sectors, then the READ_10 (sectors=0) and READ_16 (sectors=0)
> which are valid nops according to SBC-2 may also lock up
> in libata.

Try with the corrected sector counts, should work. I didn't check the
other READ_X/WRITE_X, so you should probably audit them as well :)

-- 
Jens Axboe

