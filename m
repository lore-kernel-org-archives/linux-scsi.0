From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix sd open/remove race
Date: 09 Apr 2004 13:45:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081536338.2203.107.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404091419520.1932-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:7079 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261611AbUDISqb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2004 14:46:31 -0400
In-Reply-To: <Pine.LNX.4.44L0.0404091419520.1932-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2004-04-09 at 13:29, Alan Stern wrote:
> 	I want to prevent anyone from acquiring a reference to the
> 	object after the driver has decided that no more references
> 	should be given out, i.e., after sd_remove has been called.
> 	Hence I use the semaphore around the get and in the remove.

Well, but I think you're going to spend a lot of effort trying to do
this.  I'm not convinced it's worth it.

Think of the CD ROM unplug that started all this.  Supposing the user
opens the CD, waits a minute, disconnects it then tries to use the open
fd.  Both of our schemes are forced to keep the object around giving EIO
until the user gets bored and closes it.

since we have to support the open degraded object anyway, why worry
about mediating open/disconnect races the only result of which would be
to refuse the open if it occurs within the correct window with the
disconnect?

> There's a somewhat similar problem that arises in the relation between the
> SCSI core and the low-level drivers.  Here the data structure in question
> is the host template.  (Yes, LLDs don't normally deallocate their host
> templates, but if they are built as modules they can be unloaded from
> memory, which has the same effect.)  After calling scsi_remove_host() the
> LLD has no way to know when the SCSI core is finished using the template.
> 
> Mike Anderson has suggested that scsi_remove_host could replace the hostt
> pointer with a pointer to a dummy template that will fail every operation.
> There may still be difficulties involving the procfs interface, though.

Yes, well, the host needs a proper lifecycle state model to begin with. 
I'm afraid I've been concentrating on getting the device sorted out
first.

James


