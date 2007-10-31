From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
Date: Wed, 31 Oct 2007 12:44:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0710311238090.6022-100000@iolanthe.rowland.org>
References: <1193848270.3411.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49070 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756600AbXJaQoh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 12:44:37 -0400
In-Reply-To: <1193848270.3411.39.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 31 Oct 2007, James Bottomley wrote:

> OK, light beginning to go on now.
> 
> The problem is that you've fallen into the conceptual trap we tried very
> hard to avoid in the initial go around of joining SCSI upper layer
> drivers to gendisks.  That's why no gendisk references are held by the
> mid-layer, only by the entities that represent the objects created by
> upper layer drivers.
> 
> Doesn't this circularity now exist for everything?  Every device that
> creates a queue has a reference to the queue, every queue has a
> reference to its attached gendisk and now every gendisk has a reference
> to the device creating the queue?  This doesn't look to be a SCSI
> specific problem.

It probably isn't.  I haven't looked at other subsystems but the 
scenario you described could well be the common case.

Dropping a kobject's reference to its parent when the kobject is
removed rather than when it is deleted will solve all these problems.  
The queue's reference to the gendisk and the gendisk's reference to the
device will both be dropped when the device is unregistered, allowing
the device and gendisk to be released.  When the device is released it
can then drop its reference to the queue, allowing the queue to be
released.

In other words, reverting that 4-year-old patch would fix everything.  
I'd still like to get your acknowledgement for my patch, posted here:

	http://marc.info/?l=linux-scsi&m=119368368904151&w=2

Alan Stern

