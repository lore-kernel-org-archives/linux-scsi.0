From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH/RFT] check non-scsi part of status in scsi_status_is_good
Date: Thu, 30 Oct 2003 10:11:17 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org>
References: <20031029151627.A21549@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:4356 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262583AbTJ3PLS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 10:11:18 -0500
In-Reply-To: <20031029151627.A21549@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Ronald Kuetemeier <ronald@kuetemeier.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>, James Bottomley <James.Bottomley@steeleye.com>

On Wed, 29 Oct 2003, Patrick Mansfield wrote:

> Ugh. It is behaving worse than before. 
> 
> The patch should be applied, since we are otherwise ignoring non scsi
> errors in multiple places.
> 
> Before, we ignored the failed MODE SENSE and used whatever data was
> returned, and later the TEST UNIT READY failed.
> 
> With the patch, the MODE SENSE page 3f len 4 fails, so we try a MODE SENSE
> page 0 len 4 and it hangs. The error handling should complete and allow us
> to continue (though it would probably just resend the failed command 4
> more times, and you'd have to wait 150 seconds), and then try the MODE
> SENSE page 3f len 255.
> 
> If the first MODE SENSE were 10 bytes your device would probably work OK,
> but per comments in sd.c, we should not increase this. 
> 
> But, the 2.4 code used only a 255 byte MODE SENSE request.
> 
> Any suggestions?
> 
> If we can't workaround this by modifying the code (increasing the length,
> or somehow workaround this in SCSI or USB code), we are back to black
> listing or command filtering.

IMO, this is exactly the sort of thing that has been causing us so much 
pain.  Some device doesn't accept the standard commands, dies when it gets 
them, and will only work with some idiosyncratic combination of 
parameters.

I can't think of any way to deal with this other than special-purpose 
per-device code, the simplest of which is blacklisting.

> Alan or USB gurus - is the following what we expect on a timeout?
> 
> > Oct 29 10:09:53 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
> > Oct 29 10:09:53 ronald kernel: usb-storage:  5a 00 00 00 00 00 00 00 08 00
> > Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
> > Oct 29 10:09:53 ronald kernel: usb-storage: Status code 0; transferred 10/10
> > Oct 29 10:09:53 ronald kernel: usb-storage: -- transfer complete
> > Oct 29 10:09:53 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
> > Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
> 
> Looks like the scsi timeout kicks in here, since we waited 30 seconds.
> 
> > Oct 29 10:10:22 ronald kernel: usb-storage: command_abort called
> > Oct 29 10:10:22 ronald kernel: usb-storage: usb_stor_stop_transport called
> > Oct 29 10:10:22 ronald kernel: usb-storage: -- cancelling URB
> > Oct 29 10:10:22 ronald kernel: usb-storage: Status code -104; transferred 0/8
> > Oct 29 10:10:22 ronald kernel: usb-storage: -- transfer cancelled
> > Oct 29 10:10:22 ronald kernel: usb-storage: CB data stage result is 0x4
> > Oct 29 10:10:22 ronald kernel: usb-storage: -- command was aborted
> > Oct 29 10:10:22 ronald kernel: usb-storage: scsi command aborted
> > Oct 29 10:10:22 ronald kernel: usb-storage: *** thread sleeping.

That is precisely what you see when a command times out and is aborted.

> > Oct 29 10:10:22 ronald kernel: usb-storage: queuecommand called
> > Oct 29 10:10:22 ronald kernel: usb-storage: *** thread awakened.
> 
> And then I assume the scsi error handling:

Just so.

> > Oct 29 10:10:22 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
> > Oct 29 10:10:22 ronald kernel: usb-storage:  00 00 00 00 00 00
> > Oct 29 10:10:22 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
> > Oct 29 10:10:22 ronald kernel: usb-storage: Status code 0; transferred 6/6
> > Oct 29 10:10:22 ronald kernel: usb-storage: -- transfer complete
> > Oct 29 10:10:22 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
> > Oct 29 10:10:22 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
> > Oct 29 10:10:22 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
> > Oct 29 10:10:22 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
> > Oct 29 10:10:22 ronald kernel: usb-storage: Status code 0; transferred 6/6
> > Oct 29 10:10:22 ronald kernel: usb-storage: -- transfer complete
> > Oct 29 10:10:22 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
> > Oct 29 10:10:22 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
> > Oct 29 10:10:32 ronald kernel: usb-storage: command_abort called
> > Oct 29 10:10:32 ronald kernel: usb-storage: usb_stor_stop_transport called
> > Oct 29 10:10:32 ronald kernel: usb-storage: -- cancelling URB
> > Oct 29 10:10:32 ronald kernel: usb-storage: Status code -104; transferred 0/18
> > Oct 29 10:10:32 ronald kernel: usb-storage: -- transfer cancelled
> > Oct 29 10:10:32 ronald kernel: usb-storage: CB data stage result is 0x4
> > Oct 29 10:10:32 ronald kernel: usb-storage: -- auto-sense aborted
> > Oct 29 10:10:32 ronald kernel: usb-storage: scsi command aborted
> > Oct 29 10:10:32 ronald kernel: usb-storage: *** thread sleeping.

TEST-UNIT-READY timed out...

> > Oct 29 10:10:32 ronald kernel: usb-storage: device_reset called
> > Oct 29 10:10:32 ronald kernel: usb-storage: usb_stor_CB_reset called
> > Oct 29 10:10:32 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
> > Oct 29 10:10:32 ronald kernel: usb-storage: Soft reset failed: -32
> > Oct 29 10:10:32 ronald kernel: usb-storage: bus_reset called
> 
> It would be nice if it came back :-(

Yes it would.  The USB bus_reset code is still not up to snuff and won't
get there until after 2.6.0-final.  However that may not matter; I've seen
USB devices that aren't revived even by a proper bus reset.  You actually
have to disconnect them from the USB bus or powercycle them.

Alan Stern

