From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: 11 Oct 2004 14:36:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097523375.1714.167.camel@mulgrave>
References: <Pine.LNX.4.44L0.0410111513400.21084-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:45220 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269198AbUJKTgV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 15:36:21 -0400
In-Reply-To: <Pine.LNX.4.44L0.0410111513400.21084-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2004-10-11 at 14:20, Alan Stern wrote:
> James Bottomley [James.Bottomley@SteelEye.com] wrote:
> > That's why LLD's are responsible for erroring all commands issued at
> > this time if the removal is a surprise ejection.  The commands have to
> > be errored in a way (like DID_NO_CONNECT) that won't excite the error
> > handler.
> 
> This raises a question for the case where the host removal is not a
> surprise ejection.  The LLD knows to clean up commands from _before_ doing
> scsi_remove_host, and it knows that it should handle commands from _after_
> calling scsi_remove_host.
> 
> But scsi_remove_host isn't synchronized at all with queuecommand, so what
> about commands that arrive at just about _the same time_ as when
> scsi_remove_host is called?  The LLD has no way to tell which class such a
> command belongs to.  What then?

The host's job is simply to send commands to the device ... if the
device (or host) still exists in the system, you send them; if it
doesn't, you error them.

Even in the notified ejection case, there's no upper bound on the time
it will take hotplug to clean up ... this can be particularly long if
the user has things mounted and doesn't let us simply kill everything on
the filesystem.

So the only difference as far as the HBA sees it is that for notified
ejection, when it calls scsi_remove_host() it can still send commands. 
For surprise ejection, the device is gone and it must error.

James


