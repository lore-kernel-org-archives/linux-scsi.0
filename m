From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Host drivers and conversion of SCSI to the driver model
Date: Fri, 27 Jun 2003 13:56:59 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0306271347250.774-100000@ida.rowland.org>
References: <20030627110259.A3751@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2308 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264544AbTF0Rmo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 13:42:44 -0400
In-Reply-To: <20030627110259.A3751@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 27 Jun 2003, Christoph Hellwig wrote:

> On Mon, Jun 23, 2003 at 10:57:22AM -0400, Alan Stern wrote:
> > 	2. More importantly, the current organization of the code has a
> > serious problem.  The SCSI core does not modify the host driver when the
> > reference count for either shost->class_dev or shost->host_gendev drops to
> > 0.
> 
> The host driver shouldn't know.
> 
> > Without knowing that, it is unsafe for the driver ever to deallocate a
> > private host data structure, since a user process may continue to hold a 
> > reference to an open attribute file indefinitely, even after 
> > scsi_unregister() has returned.
> 
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
> 
> Of course for this to fully work with scsi we need a proper
> scsi_set_host_offline..

I don't see how you can make that work without modifying parts of the 
driver model core.  After all, calls to a class_device attribute's show() 
and store() methods don't go through the device driver or the bus driver; 
they are demultiplexed within drivers/base/class.c.

I do agree that something like your proposal would solve the problem.  I
made a similar proposal to Pat Mochel a couple of weeks ago.  My
suggestion was to arrange some sort of mutex on the sysfs file's dentry,
so that calling the show() and store() methods would be atomic with
respect to unlinking the file.  That way the driver could be certain that
after class_device_remove_file() had returned, no one would ever call the
show() or store() functions.  My feeling is that this would be more
generally useful, not just within the SCSI realm.

Alan Stern

