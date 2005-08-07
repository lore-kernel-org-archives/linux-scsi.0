From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Sun, 07 Aug 2005 10:36:41 -0500
Message-ID: <1123429001.5020.14.camel@mulgrave>
References: <Pine.LNX.4.44L0.0508071041110.28316-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:60128 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1752171AbVHGPgq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Aug 2005 11:36:46 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508071041110.28316-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 2005-08-07 at 10:59 -0400, Alan Stern wrote:
> What sort of synchronization is there between scsi_remove_host and the 
> error-handler thread?  Offhand I can see two possible problems, depending 
> on how the LLD is written:

There isn't any by design.

I think you're not thinking about how this works correctly.  What remove
host does is loop over the active devices removing them from visibility
and trying to do a final put on the generic devices before removing the
host from visibility and doing a final put on it.

However, any outstanding user will have a reference and will keep all
the bits of the hierarchy in place until that reference is relinquished.

> In general, there needs to be some way for the error handler to prevent
> the LLD from being unloaded.  I don't know what the best answer is.  Has
> anyone thought about this?

I take it the problem is that most LLDs go on to release resources (like
interrupts and memory regions) immediately after calling
scsi_remove_host()?

The solution is probably to trigger the resource cleanup from the host
device release method.

James


