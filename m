From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
Date: Fri, 16 May 2003 15:29:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030516222900.GA3236@beaverton.ibm.com>
References: <20030516190414.GD11884@iucha.net> <Pine.LNX.4.44L0.0305161715250.1555-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:7302 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262294AbTEPWNu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 18:13:50 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0305161715250.1555-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Florin Iucha <florin@iucha.net>, David Brownell <david-b@pacbell.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

Alan Stern [stern@rowland.harvard.edu] wrote:
> Good.  This clearly shows the problem.  It's an error in the SCSI driver.  
> It has shown up before and been discussed at length a few weeks ago.  The
> problem is that a MODE-SENSE(6) command is requesting a transfer of 3
> bytes, which is smaller than the minimum of 4 bytes for that command.  
> The device doesn't like it and crashes.
> 
> The SCSI people are supposed to be working on this.  First, we should be 
> using MODE-SENSE(10) by default rather than MODE-SENSE(6).  Second, we 
> should never request a transfer smaller than the minimum allowed size.  
> When these changes are ready you shouldn't have any more trouble.
> 
> The OOPS you got originally was caused by the lack of proper 
> hot-unplugging cooperation between usb-storage and the SCSI driver.

I remember the previous conversation on the MODE-SENSE, but I think
there might be more here.

I do not believe the oops is related to the lack of proper hot-plugging
support (unless this is another way it will manifest itself). The issue
is more the interaction of the error handler and the usb storage driver.

The sequence:
"drivers/usb/core/message.c: usb_control/bulk_msg: timeout
Error handler scsi_eh_1 waking up
scsi_eh_prt_fail_stats: 1:0:0:0 cmds failed: 0, cancel: 1"

would lead one two believe that a timeout was detected both in the usb
core and in the mid layer. This would not be a good thing to have two
timeout recovery actions happening. I am not familiar with the usb
storage code so this may be incorrect. 

-andmike
--
Michael Anderson
andmike@us.ibm.com

