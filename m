From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Host drivers and conversion of SCSI to the driver model
Date: Fri, 27 Jun 2003 11:03:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030627110259.A3751@infradead.org>
References: <20030620210725.GB18449@beaverton.ibm.com> <Pine.LNX.4.44L0.0306231045060.1043-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:42249 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264104AbTF0Js5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 05:48:57 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0306231045060.1043-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Mon, Jun 23, 2003 at 10:57:22AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Jun 23, 2003 at 10:57:22AM -0400, Alan Stern wrote:
> 	2. More importantly, the current organization of the code has a
> serious problem.  The SCSI core does not modify the host driver when the
> reference count for either shost->class_dev or shost->host_gendev drops to
> 0.

The host driver shouldn't know.

> Without knowing that, it is unsafe for the driver ever to deallocate a
> private host data structure, since a user process may continue to hold a 
> reference to an open attribute file indefinitely, even after 
> scsi_unregister() has returned.

Right,  And this issue has been discussed on netdev for a long time.
The solution that they came up with and I plan to implement in scsi
aswell as soon as their code actually shows up is to have a mark this
device gone function that makes the struct device never call back
into driver code.

If you think a bit about this this is what's really needed - even with
your notification you'd still have module unload races.  With the above
fix you can just free your private data in your ->remove method
(or wherever you want) after you marked the struct device / class_device
gone and be sure it'll never be used again.

Of course for this to fully work with scsi we need a proper
scsi_set_host_offline..
