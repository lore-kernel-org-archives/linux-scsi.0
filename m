From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH/RFT] check non-scsi part of status in scsi_status_is_good
Date: Wed, 29 Oct 2003 15:16:27 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031029151627.A21549@beaverton.ibm.com>
References: <1067313069.1277.17.camel@ronald.kuetemeier.com> <Pine.LNX.4.44L0.0310280959590.793-100000@ida.rowland.org> <20031028071637.B8503@beaverton.ibm.com> <1067355769.1102.17.camel@ronald.kuetemeier.com> <20031029084656.B18130@beaverton.ibm.com> <1067449993.1168.15.camel@ronald.kuetemeier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:3021 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262081AbTJ2XR0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 18:17:26 -0500
Content-Disposition: inline
In-Reply-To: <1067449993.1168.15.camel@ronald.kuetemeier.com>; from ronald@kuetemeier.com on Wed, Oct 29, 2003 at 10:53:13AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Ronald Kuetemeier <ronald@kuetemeier.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>, James Bottomley <James.Bottomley@steeleye.com>

On Wed, Oct 29, 2003 at 10:53:13AM -0700, Ronald Kuetemeier wrote:
> Patrick,
> here is the test (didn't work).

Ugh. It is behaving worse than before. 

The patch should be applied, since we are otherwise ignoring non scsi
errors in multiple places.

Before, we ignored the failed MODE SENSE and used whatever data was
returned, and later the TEST UNIT READY failed.

With the patch, the MODE SENSE page 3f len 4 fails, so we try a MODE SENSE
page 0 len 4 and it hangs. The error handling should complete and allow us
to continue (though it would probably just resend the failed command 4
more times, and you'd have to wait 150 seconds), and then try the MODE
SENSE page 3f len 255.

If the first MODE SENSE were 10 bytes your device would probably work OK,
but per comments in sd.c, we should not increase this. 

But, the 2.4 code used only a 255 byte MODE SENSE request.

Any suggestions?

If we can't workaround this by modifying the code (increasing the length,
or somehow workaround this in SCSI or USB code), we are back to black
listing or command filtering.

> BTW, your scsi.h is different from the test-9 file, I had to patch by
> hand.

Sorry the patch was against current bk.

> 1st. apply the patch (compile ...)
> reboot, no 3f flag
> attach camera
> try to mount
> file: err-pat-scsi.h_messages.txt

Alan or USB gurus - is the following what we expect on a timeout?

> Oct 29 10:09:53 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
> Oct 29 10:09:53 ronald kernel: usb-storage:  5a 00 00 00 00 00 00 00 08 00
> Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
> Oct 29 10:09:53 ronald kernel: usb-storage: Status code 0; transferred 10/10
> Oct 29 10:09:53 ronald kernel: usb-storage: -- transfer complete
> Oct 29 10:09:53 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
> Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes

Looks like the scsi timeout kicks in here, since we waited 30 seconds.

> Oct 29 10:10:22 ronald kernel: usb-storage: command_abort called
> Oct 29 10:10:22 ronald kernel: usb-storage: usb_stor_stop_transport called
> Oct 29 10:10:22 ronald kernel: usb-storage: -- cancelling URB
> Oct 29 10:10:22 ronald kernel: usb-storage: Status code -104; transferred 0/8
> Oct 29 10:10:22 ronald kernel: usb-storage: -- transfer cancelled
> Oct 29 10:10:22 ronald kernel: usb-storage: CB data stage result is 0x4
> Oct 29 10:10:22 ronald kernel: usb-storage: -- command was aborted
> Oct 29 10:10:22 ronald kernel: usb-storage: scsi command aborted
> Oct 29 10:10:22 ronald kernel: usb-storage: *** thread sleeping.
> Oct 29 10:10:22 ronald kernel: usb-storage: queuecommand called
> Oct 29 10:10:22 ronald kernel: usb-storage: *** thread awakened.

And then I assume the scsi error handling:

> Oct 29 10:10:22 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
> Oct 29 10:10:22 ronald kernel: usb-storage:  00 00 00 00 00 00
> Oct 29 10:10:22 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
> Oct 29 10:10:22 ronald kernel: usb-storage: Status code 0; transferred 6/6
> Oct 29 10:10:22 ronald kernel: usb-storage: -- transfer complete
> Oct 29 10:10:22 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
> Oct 29 10:10:22 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
> Oct 29 10:10:22 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
> Oct 29 10:10:22 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
> Oct 29 10:10:22 ronald kernel: usb-storage: Status code 0; transferred 6/6
> Oct 29 10:10:22 ronald kernel: usb-storage: -- transfer complete
> Oct 29 10:10:22 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
> Oct 29 10:10:22 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
> Oct 29 10:10:32 ronald kernel: usb-storage: command_abort called
> Oct 29 10:10:32 ronald kernel: usb-storage: usb_stor_stop_transport called
> Oct 29 10:10:32 ronald kernel: usb-storage: -- cancelling URB
> Oct 29 10:10:32 ronald kernel: usb-storage: Status code -104; transferred 0/18
> Oct 29 10:10:32 ronald kernel: usb-storage: -- transfer cancelled
> Oct 29 10:10:32 ronald kernel: usb-storage: CB data stage result is 0x4
> Oct 29 10:10:32 ronald kernel: usb-storage: -- auto-sense aborted
> Oct 29 10:10:32 ronald kernel: usb-storage: scsi command aborted
> Oct 29 10:10:32 ronald kernel: usb-storage: *** thread sleeping.
> Oct 29 10:10:32 ronald kernel: usb-storage: device_reset called
> Oct 29 10:10:32 ronald kernel: usb-storage: usb_stor_CB_reset called
> Oct 29 10:10:32 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
> Oct 29 10:10:32 ronald kernel: usb-storage: Soft reset failed: -32
> Oct 29 10:10:32 ronald kernel: usb-storage: bus_reset called

It would be nice if it came back :-(

-- Patrick Mansfield
