From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Sun, 07 Aug 2005 16:57:16 -0500
Message-ID: <1123451837.5020.22.camel@mulgrave>
References: <Pine.LNX.4.44L0.0508071408370.32668-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:10723 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1752882AbVHGV5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Aug 2005 17:57:22 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508071408370.32668-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 2005-08-07 at 14:43 -0400, Alan Stern wrote:
> What host device release method?  scsi_host_template->release is marked 
> OBSOLETE and for use only with old-style drivers.  scsi_host_dev_release 
                                                     ^^^^^
This is the one I was thinking of adding to.

> is the only release method for hosts, and it doesn't notify the LLD in any 
> way.
> 
> Anyhow, I'm not so concerned about releasing resources associated with the
> host.  The LLD can handle that easily enough by first flagging the HBA
> as not accessible, then waiting for current I/O to terminate, then
> calling scsi_remove_host.  The resources can be released any time after
> the current I/O is finished; it doesn't matter whether the host is removed
> before or after.
> 
> The only resource that matters for this discussion is associated with the
> LLD itself, not with any of its hosts: the host template.  Once the SCSI
> core has released all references to the template, it can't call the LLD
> any more.  The problem is that the LLD has no way to know when all the
> references have been dropped.  This suggests that the entire problem could
> be solved by adding a kref to struct scsi_host_template.
> 
> Would you agree to a patch adding such a kref?

Well, not really.  The host template usually exists as a variable in the
module, so its lifetime is tied to the lifetime of the module.  Adding a
kref wouldn't help because it will still be freed when the module is
removed.  If there's a case where the template is being freed
prematurely because the module is being removed, then we have the module
refcounting wrong somewhere.  Have you run across such a case?

James


