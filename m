From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Problem with an USB Stick and kernel 2.6.1
Date: Fri, 16 Jan 2004 08:55:59 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116165559.GB2686@beaverton.ibm.com>
References: <20040116121824.GB10117@paradigm.rfc822.org> <Pine.LNX.4.44L0.0401161102390.843-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:20889 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261464AbUAPQ5Z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 11:57:25 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0401161102390.843-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Florian Lohoff <flo@rfc822.org>, Alexander Motzkau <a.motzkau@web.de>, USB development list <linux-usb-devel@lists.sourceforge.net>

Alan Stern [stern@rowland.harvard.edu] wrote:
> 
> Seeing no sense key, usb-storage returns 0 indicating the command
> succeeded.  But scsi_finish_command() sees that valid sense data is
> present and sets the driver_byte to DRIVER_SENSE.
> 
> > SCSI error : <1 0 0 0> return code = 0x8000000
> > Current sda: sense key No Sense
> 
> This causes scsi_io_completion() to call scsi_end_request() with uptodate 
> = 0 and results in this error:
> 
> > end_request: I/O error, dev sda, sector 32
> > FAT: unable to read boot sector
> 
> How should we handle this?  Should we zero out sense_buffer[0] when 
> auto-sense shows sense key = NO_SENSE?
> 

I would think the upper level driver should handle this. We decode
RECOVERED_ERROR in sd. sd could just handle NO_SENSE the same with /
without the print_sense. I noticed that st and osst under some
circumstances look at the NO_SENSE case (the tape people will need to
comment as this looks like a EOM workaround) so it would seem incorrect
for the LLDD as a general policy to say it received no sense when it
did.

-andmike
--
Michael Anderson
andmike@us.ibm.com

