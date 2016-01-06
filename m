From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v2, RESEND] Separate target visibility from reaped state
 information
Date: Wed, 6 Jan 2016 22:34:30 +0100
Message-ID: <20160106223430.000027d7@localhost>
References: <568CCF4F.2000108@sandisk.com>
	<1452095926.2312.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53539 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbcAFVe7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jan 2016 16:34:59 -0500
In-Reply-To: <1452095926.2312.2.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sebastian Herbszt <herbszt@gmx.de>

James Bottomley wrote:
> On Wed, 2016-01-06 at 09:24 +0100, Bart Van Assche wrote:
> > Instead of representing the states "visible in sysfs" and
> > "has been removed from the target list" by a single state
> > variable, use two variables to represent this information.
> > 
> > This patch avoids that SCSI device removal can trigger a
> > soft lockup.
> 
> It does?  When I asked you this the last time, you said the soft lockup
> was fixed by a prior patch:
> 
> http://thread.gmane.org/gmane.linux.scsi/107248
> 
> If you've actually caught a problem, can we have details because the
> distro people will want to know what gets fixed by this.
> 
> Thanks,
> 
> James

Which details do you need?
 
> > See also:
> > * "scsi: restart list search after unlock in scsi_remove_target"
> >   (commit 40998193560d).
> > * "scsi_remove_target: fix softlockup regression on hot remove"
> >   (commit bc3f02a795d3).
> > 
> > Reported-by: Sebastian Herbszt <herbszt@gmx.de>
> > Tested-by: Sebastian Herbszt <herbszt@gmx.de>
> > Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Johannes Thumshirn <jthumshirn@suse.de>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: stable <stable@vger.kernel.org>
> > ---
> >  drivers/scsi/scsi_scan.c   | 31 +++----------------------------
> >  drivers/scsi/scsi_sysfs.c  |  7 ++++---
> >  include/scsi/scsi_device.h |  9 ++-------
> >  3 files changed, 9 insertions(+), 38 deletions(-)
> > 
> > See also:
> > - http://thread.gmane.org/gmane.linux.scsi/107245.

I was able to hit a soft lockup and reported it here:

> > - http://thread.gmane.org/gmane.linux.scsi/108614.

Sebastian
