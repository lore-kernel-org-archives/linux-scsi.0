From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
Date: Thu, 13 Dec 2007 13:46:03 -0500
Message-ID: <1197571563.3154.41.camel@localhost.localdomain>
References: <47617B92.6020908@rtr.ca> <47617C07.3020501@rtr.ca>
	 <20071213184221.GP26334@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49766 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763351AbXLMSqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2007 13:46:06 -0500
In-Reply-To: <20071213184221.GP26334@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>


On Thu, 2007-12-13 at 11:42 -0700, Matthew Wilcox wrote:
> On Thu, Dec 13, 2007 at 01:37:59PM -0500, Mark Lord wrote:
> > The problem is, the block layer *never* sends an SG entry larger than 8192 
> > bytes,
> > and even that size is exceptionally rare.  Nearly all I/O segments are 4096 
> > bytes,
> > so I never see a single I/O larger than 512KB (128 * 4096).
> > 
> > If I patch various parts of block and SCSI, this limit doesn't budge,
> > but when I change the hardware PRD limit in libata, it scales by exactly
> > whatever I set the new value to.  This tells me that adjacent I/O segments
> > are not being combined.
> > 
> > I thought that QUEUE_FLAG_CLUSTER (aka. SCSI host .use_clustering=1) should
> > result in adjacent single pages being combined into larger physical 
> > segments?
> 
> I was recently debugging a driver and noticed that consecutive pages in
> an sg list are in the reverse order.  ie first you get page 918, then
> 917, 916, 915, 914, etc.  I vaguely remember James having patches to
> correct this, but maybe they weren't merged?

Yes, they were ... it was actually Bill Irwin's patch.  The old problem
was that we fault allocations in reverse order (because we were taking
from the end of the zone list).  I can't remember when his patches went
in, but it was several years ago.  After they did, I was getting a 33%
chance of physical merging (as opposed to zero before).  Probably
someone redid the vm or the zones without understanding this and we've
gone back to the original position.

James


