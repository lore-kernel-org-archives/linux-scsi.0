From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Sun, 7 Aug 2005 14:43:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0508071408370.32668-100000@netrider.rowland.org>
References: <1123429001.5020.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:43525 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S1752533AbVHGSnl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Aug 2005 14:43:41 -0400
In-Reply-To: <1123429001.5020.14.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 7 Aug 2005, James Bottomley wrote:

> On Sun, 2005-08-07 at 10:59 -0400, Alan Stern wrote:
> > What sort of synchronization is there between scsi_remove_host and the 
> > error-handler thread?  Offhand I can see two possible problems, depending 
> > on how the LLD is written:
> 
> There isn't any by design.
> 
> I think you're not thinking about how this works correctly.  What remove
> host does is loop over the active devices removing them from visibility
> and trying to do a final put on the generic devices before removing the
> host from visibility and doing a final put on it.
> 
> However, any outstanding user will have a reference and will keep all
> the bits of the hierarchy in place until that reference is relinquished.

That's all as it should be.

> I take it the problem is that most LLDs go on to release resources (like
> interrupts and memory regions) immediately after calling
> scsi_remove_host()?
> 
> The solution is probably to trigger the resource cleanup from the host
> device release method.

What host device release method?  scsi_host_template->release is marked 
OBSOLETE and for use only with old-style drivers.  scsi_host_dev_release 
is the only release method for hosts, and it doesn't notify the LLD in any 
way.

Anyhow, I'm not so concerned about releasing resources associated with the
host.  The LLD can handle that easily enough by first flagging the HBA
as not accessible, then waiting for current I/O to terminate, then
calling scsi_remove_host.  The resources can be released any time after
the current I/O is finished; it doesn't matter whether the host is removed
before or after.

The only resource that matters for this discussion is associated with the
LLD itself, not with any of its hosts: the host template.  Once the SCSI
core has released all references to the template, it can't call the LLD
any more.  The problem is that the LLD has no way to know when all the
references have been dropped.  This suggests that the entire problem could
be solved by adding a kref to struct scsi_host_template.

Would you agree to a patch adding such a kref?

Alan Stern

