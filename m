From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] FW: USB 2.0 external hard drive problem
Date: Mon, 9 Feb 2004 16:30:23 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0402091317290.1821-100000@ida.rowland.org>
References: <1076345415.2090.30.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3844 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263448AbUBIVaY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 16:30:24 -0500
In-Reply-To: <1076345415.2090.30.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Joerg Schilling <schilling@fokus.fraunhofer.de>, magliery@csb.yale.edu, appro@fy.chalmers.se, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On 9 Feb 2004, James Bottomley wrote:

> OK, if you want to understand what the mid-layer problem is, look at
> scsi_finish_command().  You see in there we set DRIVER_SENSE if we find
> any valid sense code in the sense buffer (including NO SENSE)
> 
> We will return this to the user as a sense error at various points.

I don't understand the reasoning here.  If DRIVER_SENSE is set it must 
mean the driver had some reason of its own for wanting to get the sense 
data -- presumably to find out whether or not some error occurred.  So why 
should this get passed to the user as a sense error?  Especially if the 
sense code is NO SENSE.  Logically that should indicate the driver needed 
to find out whether or not there was error, and it learned that there 
wasn't.

> The safest course, if you want to send unsolicited request sense
> commands is probably to zero out the sense buffer if you get NO SENSE
> back.

Okay, we can do that.

Alan Stern


