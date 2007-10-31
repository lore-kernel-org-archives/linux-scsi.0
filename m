From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices (fwd)
Date: Wed, 31 Oct 2007 12:07:49 -0500
Message-ID: <1193850469.3411.66.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0710311238090.6022-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45129 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756150AbXJaRM1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 13:12:27 -0400
In-Reply-To: <Pine.LNX.4.44L0.0710311238090.6022-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2007-10-31 at 12:44 -0400, Alan Stern wrote:
> On Wed, 31 Oct 2007, James Bottomley wrote:
> 
> > OK, light beginning to go on now.
> > 
> > The problem is that you've fallen into the conceptual trap we tried very
> > hard to avoid in the initial go around of joining SCSI upper layer
> > drivers to gendisks.  That's why no gendisk references are held by the
> > mid-layer, only by the entities that represent the objects created by
> > upper layer drivers.
> > 
> > Doesn't this circularity now exist for everything?  Every device that
> > creates a queue has a reference to the queue, every queue has a
> > reference to its attached gendisk and now every gendisk has a reference
> > to the device creating the queue?  This doesn't look to be a SCSI
> > specific problem.
> 
> It probably isn't.  I haven't looked at other subsystems but the 
> scenario you described could well be the common case.
> 
> Dropping a kobject's reference to its parent when the kobject is
> removed rather than when it is deleted will solve all these problems.  
> The queue's reference to the gendisk and the gendisk's reference to the
> device will both be dropped when the device is unregistered, allowing
> the device and gendisk to be released.  When the device is released it
> can then drop its reference to the queue, allowing the queue to be
> released.
> 
> In other words, reverting that 4-year-old patch would fix everything.  
> I'd still like to get your acknowledgement for my patch, posted here:
> 
> 	http://marc.info/?l=linux-scsi&m=119368368904151&w=2

It sounds plausible, but I'm not really up to speed on all the changes
going on in sysfs at the moment, so it would be dangerous to rely on
what I think sounds reasonable.

James


