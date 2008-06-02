From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices
Date: Mon, 02 Jun 2008 14:39:12 -0500
Message-ID: <1212435552.3369.62.camel@localhost.localdomain>
References: <12124164141515-patch-mail.ibm.com>
	 <48441AEE.6050605@garzik.org> <48441F82.6060706@linux.vnet.ibm.com>
	 <1212425124.3369.20.camel@localhost.localdomain>
	 <4844312C.7010403@garzik.org>
	 <1212429428.3369.45.camel@localhost.localdomain>
	 <484437C3.8020306@garzik.org> <48444126.8050107@linux.vnet.ibm.com>
	 <484441E6.8020501@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40151 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896AbYFBTjU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2008 15:39:20 -0400
In-Reply-To: <484441E6.8020501@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: brking@linux.vnet.ibm.com, Tejun Heo <htejun@gmail.com>, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, linux-ide@vger.kernel.org, miltonm@bga.com

On Mon, 2008-06-02 at 14:54 -0400, Jeff Garzik wrote:
> Brian King wrote:
> > One thing that having a per-port SCSI host buys us is that it isolates
> > EH to the port rather than the entire SCSI host. The way that the new
> > libata EH is designed, it can end up spending a fair amount of time
> > in EH and may even sleep for seconds at a time, waiting for the device
> > to come ready. Quiescing all devices on a SAS host due to a single
> > SATA device gets *very* painful. The new libata EH does much more than
> > just EH. It wakes up for every ATAPI check condition...
> > 
> > Before we can move to a single SCSI host model, we will
> > have to make some changes regarding how EH is done in libata...
> 
> 
> Good points.  There definitely needs to be a discussion about how to 
> integrate libata EH with libsas model and ipr model (which are distinct, 
> if similar).

Actually, libsas completely hijacks the strategy handler (as I believe
libata does), so it really no longer has a host dependency, except for
the one thread per host thing.  Most of what it does (unless it thinks
the actual host chip is wedged) is port (as in SAS port, not phy) based,
so I think we have the capability for doing this already.

> libata EH was coded to largely be "in the driver's seat", which isn't 
> true in a world where it is a peer to SAS devices.  Also libata EH 
> duplicates some of the link EH stuff that SAS deals with, and must 
> subsume (since libsas knows about both SAS and SATA phys, and an ideal 
> world doesn't have the two as separate as they are now).

Yes ... there's even nastier scenarios.  If we're in a STP (SATA Tunnel
Protocol) situation, the device at the end is SATA, but the pathway to
get to it through the port is SAS via expanders.  In that situation the
two have to co-operate on the recovery ... of course, this isn't
incredibly dissimilar from port multipliers now.

James


