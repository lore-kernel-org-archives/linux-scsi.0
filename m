From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Host drivers and conversion of SCSI to the driver model
Date: Thu, 3 Jul 2003 11:15:32 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307031110400.4852-100000@ida.rowland.org>
References: <20030627110259.A3751@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:20228 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264085AbTGCPBG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2003 11:01:06 -0400
In-Reply-To: <20030627110259.A3751@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 27 Jun 2003, Christoph Hellwig wrote:

> Right,  And this issue has been discussed on netdev for a long time.
> The solution that they came up with and I plan to implement in scsi
> aswell as soon as their code actually shows up is to have a mark this
> device gone function that makes the struct device never call back
> into driver code.
> 
> If you think a bit about this this is what's really needed - even with
> your notification you'd still have module unload races.  With the above
> fix you can just free your private data in your ->remove method
> (or wherever you want) after you marked the struct device / class_device
> gone and be sure it'll never be used again.

How will this interact with the module reference-counting just added to 
sysfs by Greg K-H?  Maybe with that new feature, none of this will be 
needed.

Alan Stern

