From: Jens Axboe <axboe@suse.de>
Subject: Re: Device flags: use_10_for_rw and use_10_for_ms
Date: Wed, 30 Nov 2005 09:08:54 +0100
Message-ID: <20051130080854.GD15804@suse.de>
References: <20051129200334.GB15804@suse.de> <Pine.LNX.4.44L0.0511291616470.18319-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:42545 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751014AbVK3IHr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 03:07:47 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0511291616470.18319-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Nov 29 2005, Alan Stern wrote:
> On Tue, 29 Nov 2005, Jens Axboe wrote:
> 
> > > The hard problem is that sometimes devices return an ILLEGAL_REQUEST sense
> > > key when they shouldn't.  I posted an example a week or two ago; what
> > > happened was the use_10_for_rw flag got turned off and from then on only
> > > 6-byte commands were used (and of course the device failed to recognize
> > > them).
> > > 
> > > Clearly we need a mechanism for going the other way: when a 6-byte command 
> > > gets ILLEGAL_REQUEST sense, turn the use_10_for_xxx flag back on.  The 
> > > difficulty is that this will cause an infinite retry loop if the device 
> > > doesn't like either form of the command.
> > > 
> > > Is there a standard way to limit the number of retries for these cases in 
> > > scsi_io_completion?  The code pathway involves getting rid of the 
> > > scsi_cmnd and keeping only the struct request, so I don't know where an 
> > > appropriate place would be to store the retry counter.
> > > 
> > > Any ideas?
> > 
> > How about just improving the check for correctly failed 10-byte command,
> > so we only clear the flag for the right reason? I think your problem is
> > likely due to the check being too relaxed right now.
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index ce9d73a..1f27827 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -884,7 +884,8 @@ void scsi_io_completion(struct scsi_cmnd
> >  			* system where READ CAPACITY failed, we may have read
> >  			* past the end of the disk.
> >  		 	*/
> > -			if (cmd->device->use_10_for_rw &&
> > +			if ((cmd->device->use_10_for_rw &&
> > +			    sshdr.asc == 0x20 && sshdr.ascq == 0x00) &&
> >  			    (cmd->cmnd[0] == READ_10 ||
> >  			     cmd->cmnd[0] == WRITE_10)) {
> >  				cmd->device->use_10_for_rw = 0;
> 
> This will not help.  There's a log available at
> 
> http://www.cs.pdx.edu/~cklin/usb-error/0-original-kern.log
> 
> showing an example.  Here's the relevant part:
> 
> Nov 19 00:31:13 rho kernel: usb-storage: Command READ_10 (10 bytes)
> Nov 19 00:31:13 rho kernel: usb-storage:  28 00 02 54 29 78 00 00 08 00
> Nov 19 00:31:13 rho kernel: usb-storage: Bulk Command S 0x43425355 T 0x8 L 4096 F 128 Trg 0 LUN 0 CL 12
> Nov 19 00:31:13 rho kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> Nov 19 00:31:13 rho kernel: usb-storage: Status code 0; transferred 31/31
> Nov 19 00:31:13 rho kernel: usb-storage: -- transfer complete
> Nov 19 00:31:13 rho kernel: usb-storage: Bulk command transfer result=0
> Nov 19 00:31:13 rho kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
> Nov 19 00:31:13 rho kernel: usb-storage: Status code -32; transferred 4032/4096
> Nov 19 00:31:13 rho kernel: usb-storage: clearing endpoint halt for pipe 0xc0020380
> Nov 19 00:31:13 rho kernel: usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=84 len=0
> Nov 19 00:31:13 rho kernel: usb-storage: usb_stor_clear_halt: result = 0
> Nov 19 00:31:13 rho kernel: usb-storage: Bulk data transfer result 0x2
> Nov 19 00:31:13 rho kernel: usb-storage: Attempting to get CSW...
> Nov 19 00:31:13 rho kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> Nov 19 00:31:13 rho kernel: usb-storage: Status code 0; transferred 13/13
> Nov 19 00:31:13 rho kernel: usb-storage: -- transfer complete
> Nov 19 00:31:13 rho kernel: usb-storage: Bulk status result = 0
> Nov 19 00:31:13 rho kernel: usb-storage: Bulk Status S 0x53425355 T 0x8 R 64 Stat 0x1
> Nov 19 00:31:13 rho kernel: usb-storage: -- transport indicates command failure
> Nov 19 00:31:13 rho kernel: usb-storage: -- unexpectedly short transfer
> Nov 19 00:31:13 rho kernel: usb-storage: Issuing auto-REQUEST_SENSE
> Nov 19 00:31:13 rho kernel: usb-storage: Bulk Command S 0x43425355 T 0x9 L 18 F 128 Trg 0 LUN 0 CL 12
> Nov 19 00:31:13 rho kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> Nov 19 00:31:13 rho kernel: usb-storage: Status code 0; transferred 31/31
> Nov 19 00:31:13 rho kernel: usb-storage: -- transfer complete
> Nov 19 00:31:13 rho kernel: usb-storage: Bulk command transfer result=0
> Nov 19 00:31:13 rho kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
> Nov 19 00:31:13 rho kernel: usb-storage: Status code 0; transferred 18/18
> Nov 19 00:31:13 rho kernel: usb-storage: -- transfer complete
> Nov 19 00:31:13 rho kernel: usb-storage: Bulk data transfer result 0x0
> Nov 19 00:31:13 rho kernel: usb-storage: Attempting to get CSW...
> Nov 19 00:31:13 rho kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> Nov 19 00:31:13 rho kernel: usb-storage: Status code 0; transferred 13/13
> Nov 19 00:31:13 rho kernel: usb-storage: -- transfer complete
> Nov 19 00:31:13 rho kernel: usb-storage: Bulk status result = 0
> Nov 19 00:31:13 rho kernel: usb-storage: Bulk Status S 0x53425355 T 0x9 R 0 Stat 0x0
> Nov 19 00:31:13 rho kernel: usb-storage: -- Result from auto-sense is 0
> Nov 19 00:31:13 rho kernel: usb-storage: -- code: 0x70, key: 0x5, ASC: 0x20, ASCQ: 0x0
> 
> In this case the drive transmitted all but the last 64 bytes of a 
> 4096-byte READ(10), and the sense data was exactly what you want to test 
> for.

Oh well, so much for expecting than even the most basic SCSI behaviour
is always implemented correctly. A device must only return
0x05/0x20/0x00 for an illegal opcode. It's a little suspicious I'd say,
are you sure it isn't something else affecting this? Even though there
are crappy devices out there, this seems a little too odd to me.

-- 
Jens Axboe

