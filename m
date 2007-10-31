From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
Date: Wed, 31 Oct 2007 14:36:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0710311420500.6413-100000@iolanthe.rowland.org>
References: <1193849183.3411.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59642 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751852AbXJaSgm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 14:36:42 -0400
In-Reply-To: <1193849183.3411.45.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 31 Oct 2007, James Bottomley wrote:

> But you're assuming the relationship gendisk->queue exists when we
> delete the scsi device.  What should happen is that the gendisk should
> be released first in the ULD detach.  Queues are allowed to exist
> without gendisks (when a SCSI queue is first created, that's what it
> should look like), so I think we're perhaps simply missing an API that
> would detach the queue and the gendisk (and get the gendisk to delete
> itself and give up its device link) ... doesn't del_gendisk() do this?

It tries to, but it fails.  What happens is del_gendisk() calls
unlink_gendisk(), which calls blk_unregister_queue().  If the kobject
core worked rationally, this would cause the queue to drop its
reference to the gendisk and allow the gendisk to be released.

But it doesn't.  The kobject core doesn't drop the reference from a
child to a parent when the child is unregistered; it waits until the
child is released.  This means that the gendisk can't be released until
the queue is released.  Similarly, the scsi_device can't be released 
until the gendisk is released.  And obviously this constitutes a deadly 
cycle.

The proposed patch will make the kobject core behave as it should, 
dropping references during unregister instead of waiting until release.

Alan Stern


