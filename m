From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] BUG when removing USB flash drive
Date: Fri, 14 May 2004 17:13:38 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0405141710290.20244-100000@ida.rowland.org>
References: <1084565070.1841.373.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:24580 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262873AbUENVNk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2004 17:13:40 -0400
In-Reply-To: <1084565070.1841.373.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Alberto Bertogli <albertogli@telpin.com.ar>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On 14 May 2004, James Bottomley wrote:

> The idea behind scsi_remove_host() was that it was going to be called
> from the module_exit() routine.  This means that the reference count on
> the LLD has already dropped to zero and it's safe for removal.
> 
> If you call scsi_remove_host() outside of the module_exit() code then
> what it does is remove all hosts from visibility (and makes it
> impossible to open or do anything with them), but it cannot revoke
> outstanding references (which may continue to use the device).  The
> mid-layer takes the devices through CANCEL and then DEL.  When
> scsi_remove_host() returns, you are guaranteed (barring any state model
> cockups) that the devices on the LLD with outstanding references are all
> in the DEL state.  It will also block the device from above (no commands
> will be sent down).  Any currently outstanding commands will be errored
> from the mid-layer; however, it will do nothing about outstanding
> commands in the LLD, you have to deal with them yourself.
> 
> The way this is supposed to work is that when you get a disconnection,
> you start refusing commands (and you also discard any active ones). 
> Then you call scsi_remove_host().  We discard all current commands
> 
> So, if the usb storage LLD isn't discarding the commands, then they may
> be active.

Yes, that would explain it.  We do arrange to abort the current command, 
but this is done before calling scsi_remove_host() when it should be done 
after.  And we don't wait for the kernel thread to become idle afterwards.

I'll work on a patch.  Testing it won't be easy, though; it's hard to 
prove that a race _isn't_ happening!

Alan Stern

