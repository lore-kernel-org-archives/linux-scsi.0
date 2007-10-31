From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
Date: Wed, 31 Oct 2007 14:38:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0710311436510.6413-100000@iolanthe.rowland.org>
References: <1193850469.3411.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59648 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754266AbXJaSiF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 14:38:05 -0400
In-Reply-To: <1193850469.3411.66.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 31 Oct 2007, James Bottomley wrote:

> > Dropping a kobject's reference to its parent when the kobject is
> > removed rather than when it is deleted will solve all these problems.  
> > The queue's reference to the gendisk and the gendisk's reference to the
> > device will both be dropped when the device is unregistered, allowing
> > the device and gendisk to be released.  When the device is released it
> > can then drop its reference to the queue, allowing the queue to be
> > released.
> > 
> > In other words, reverting that 4-year-old patch would fix everything.  
> > I'd still like to get your acknowledgement for my patch, posted here:
> > 
> > 	http://marc.info/?l=linux-scsi&m=119368368904151&w=2
> 
> It sounds plausible, but I'm not really up to speed on all the changes
> going on in sysfs at the moment, so it would be dangerous to rely on
> what I think sounds reasonable.

Okay.  It sounds like there's not much SCSI-specific remaining in this 
thread, so anything further should move back to LKML.

Alan Stern

