From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] BUG when removing USB flash drive
Date: 14 May 2004 15:04:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1084565070.1841.373.camel@mulgrave>
References: <Pine.LNX.4.44L0.0405141514470.20244-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:30344 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262451AbUENUEz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2004 16:04:55 -0400
In-Reply-To: <Pine.LNX.4.44L0.0405141514470.20244-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Alberto Bertogli <albertogli@telpin.com.ar>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2004-05-14 at 14:33, Alan Stern wrote:
> usb-storage checks the state of its kernel thread after calling
> scsi_remove_host(), while preparing to kill the thread.  This can only
> be done while the thread is idle, not processing any queued commands or
> error handler requests.  The BUG in Alberto's log was triggered because
> the thread was not idle.  Unfortunately the log doesn't say whether it was
> executing a queued command or an error handler request at the time.

The idea behind scsi_remove_host() was that it was going to be called
from the module_exit() routine.  This means that the reference count on
the LLD has already dropped to zero and it's safe for removal.

If you call scsi_remove_host() outside of the module_exit() code then
what it does is remove all hosts from visibility (and makes it
impossible to open or do anything with them), but it cannot revoke
outstanding references (which may continue to use the device).  The
mid-layer takes the devices through CANCEL and then DEL.  When
scsi_remove_host() returns, you are guaranteed (barring any state model
cockups) that the devices on the LLD with outstanding references are all
in the DEL state.  It will also block the device from above (no commands
will be sent down).  Any currently outstanding commands will be errored
from the mid-layer; however, it will do nothing about outstanding
commands in the LLD, you have to deal with them yourself.

The way this is supposed to work is that when you get a disconnection,
you start refusing commands (and you also discard any active ones). 
Then you call scsi_remove_host().  We discard all current commands

So, if the usb storage LLD isn't discarding the commands, then they may
be active.

James


