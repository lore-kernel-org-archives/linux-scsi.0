From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG: CD driver sends command during host removal
Date: Mon, 11 Oct 2004 16:03:37 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410111558460.21084-100000@netrider.rowland.org>
References: <1097523375.1714.167.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:8979 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S269207AbUJKUDh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 16:03:37 -0400
In-Reply-To: <1097523375.1714.167.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 11 Oct 2004, James Bottomley wrote:

> > But scsi_remove_host isn't synchronized at all with queuecommand, so what
> > about commands that arrive at just about _the same time_ as when
> > scsi_remove_host is called?  The LLD has no way to tell which class such a
> > command belongs to.  What then?
> 
> The host's job is simply to send commands to the device ... if the
> device (or host) still exists in the system, you send them; if it
> doesn't, you error them.
> 
> Even in the notified ejection case, there's no upper bound on the time
> it will take hotplug to clean up ... this can be particularly long if
> the user has things mounted and doesn't let us simply kill everything on
> the filesystem.
> 
> So the only difference as far as the HBA sees it is that for notified
> ejection, when it calls scsi_remove_host() it can still send commands. 
> For surprise ejection, the device is gone and it must error.

The problem arises when a command completes.  In the notified ejection 
case, if the LLD tries to call the scsi_done routine for a completed 
command which was submitted before scsi_remove_host and which the SCSI 
core has already cleaned up, it will cause an oops.  Since the LLD has no 
way to tell whether the core has cleaned up a command or not, its only 
choice is to fail _every_ command starting shortly before it calls 
scsi_remove_host.

Alan Stern

