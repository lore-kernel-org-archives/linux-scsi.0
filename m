From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH] Separate target visibility from reaped state
 information
Date: Sun, 31 Jan 2016 18:54:55 +0100
Message-ID: <20160131185455.00000ef7@localhost>
References: <568FE922.9090004@sandisk.com>
	<yq1oachqehs.fsf@sermon.lab.mkp.net>
	<1453251809.2320.56.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58770 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825AbcAaRz0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jan 2016 12:55:26 -0500
In-Reply-To: <1453251809.2320.56.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sebastian Herbszt <herbszt@gmx.de>

James Bottomley wrote:
> On Tue, 2016-01-19 at 19:30 -0500, Martin K. Petersen wrote:
> > > > > > > "Bart" == Bart Van Assche <bart.vanassche@sandisk.com>
> > > > > > > writes:
> > 
> > Bart> Instead of representing the states "visible in sysfs" and "has
> > Bart> been removed from the target list" by a single state variable,
> > use
> > Bart> two variables to represent this information.
> > 
> > James: Are you happy with the latest iteration of this? Should I
> > queue
> > it?
> 
> Well, I'm OK with the patch: it's a simple transformation of the
> enumerated state to a two bit state.  What I can't see is how it fixes
> any soft lockup.
> 
> The only change from the current workflow is that the DEL transition
> (now the reaped flag) is done before the spin lock is dropped which
> would fix a tiny window for two threads both trying to remove the same
> target, but there's nothing that could possibly fix an iterative soft
> lockup caused by restarting the loop, which is what the changelog says.
> 
> James

James, Martin, what's the status of this patch?
I still hit the reported soft lockup on 4.5-rc1.

Sebastian
