From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: Tue, 12 Oct 2004 13:13:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041012201317.GA14345@beaverton.ibm.com>
References: <20041012000058.GA26569@osdl.org> <eada2a07041012092973d35415@mail.gmail.com> <20041012165919.GA27526@osdl.org> <1097601199.2044.91.camel@mulgrave> <20041012175943.GB27526@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:6589 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S267709AbUJLUNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 16:13:34 -0400
Content-Disposition: inline
In-Reply-To: <20041012175943.GB27526@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Dave Olien <dmo@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Oct 12, 2004 at 10:59:43AM -0700, Dave Olien wrote:
> 
> James,
> 
> On Tue, Oct 12, 2004 at 12:13:13PM -0500, James Bottomley wrote:
> > 
> > Hang on a minute ... if you're ping pong'ing the drives using AVT, those
> > transfers take time to achieve.  The device is probably returning UNIT
> > ATTENTION, NOT_READY while the transfer is in progress.  This is
> > probably the source of the requeue.
> 
> 	OK, This probably makes sense.  I'm going to see if I can
> 	get a theory of operations for this device somewhere.  I'd
> 	like to have a better understanding of how the device
> 	works and how long it takes to do these transfers.

I ran that way (use both controllers for one LUN while in AVT mode) a long
time ago, I don't know the timing, but performance was horrid. I can't
think of any reason to run that way, other than trying to duplicate this
bug ;-)

AFAIR the "transfer" is moving cached data from one controller of the disk
array to the other, but it must have some sort of synchronization method.

But try running with the scsi command completion logging on, it should
dump the full sense data.

You can run at this log level without generating extra IO (won't log the
logging), make sure you have CONFIG_SCSI_LOGGING on, and then use:

	sysctl -w dev.scsi.logging_level=0x1200

Or just use /proc/sys/dev/scsi/logging_level ...

Set back to zero to turn off logging:

	sysctl -w dev.scsi.logging_level=0

And you should get logging for non-zero scmd->result IO completions
(scmd->result is 2 meaning check condition in the below output) like this:

Oct 12 13:00:54 elm3b79 kernel: scsi <0:0:0:0> done SUCCESS        2 scsi0 : destination target 0, lun 0
Oct 12 13:00:54 elm3b79 kernel:         command = Inquiry 01 83 00 fe 00
Oct 12 13:00:54 elm3b79 kernel: Current sda: sense key Illegal Request
Oct 12 13:00:54 elm3b79 kernel: Additional sense: Invalid field in cdb

HTH ...

-- Patrick Mansfield
