From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] FW: USB 2.0 external hard drive problem
Date: 09 Feb 2004 11:50:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076345415.2090.30.camel@mulgrave>
References: <Pine.LNX.4.44L0.0402091132000.1650-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:11409 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265269AbUBIQup (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 11:50:45 -0500
In-Reply-To: <Pine.LNX.4.44L0.0402091132000.1650-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Joerg Schilling <schilling@fokus.fraunhofer.de>, magliery@csb.yale.edu, appro@fy.chalmers.se, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2004-02-09 at 11:40, Alan Stern wrote:
> In the absence of anything better, we're forced to assume "bad" status 
> corresponds to Check Condition...
> 
> What do you think, Matt?  Should we remove the auto-sense for short 
> transfers when we get "good" status?  Bearing in mind that it's 
> technically legal, but other drivers or programs may not expect it?  Also 
> bearing in mind that we have no choice but to auto-sense for non-IN 
> transfers with the CB transport.

OK, if you want to understand what the mid-layer problem is, look at
scsi_finish_command().  You see in there we set DRIVER_SENSE if we find
any valid sense code in the sense buffer (including NO SENSE)

We will return this to the user as a sense error at various points.

The safest course, if you want to send unsolicited request sense
commands is probably to zero out the sense buffer if you get NO SENSE
back.

James


