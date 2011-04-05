From: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
Date: Tue, 5 Apr 2011 20:16:51 +0530
Message-ID: <20110405144651.GA20671@amit-x200.redhat.com>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
 <20110401154327.GA6593@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab1DEOrL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Apr 2011 10:47:11 -0400
Content-Disposition: inline
In-Reply-To: <20110401154327.GA6593@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>

On (Fri) 01 Apr 2011 [17:43:27], Tejun Heo wrote:
> Hello,
> 
> On Thu, Mar 31, 2011 at 11:50:04PM +0530, Amit Shah wrote:
> > After the first GET_EVENT_STATUS_NOTIFICATION command, any new media
> > notification is reset by the device.  The following is then noticed:
> > 
> > 1. insert a CD of a particular size
> > 2. mount it
> > 3. note /sys/block/sr0/size
> > 4. unmount cd
> > 5. replace cd with a size greater than previous one
> > 6. mount it
> > 7. /sys/block/sr0/size isn't updated
> > 8. copy all files from cd to somewhere; IO errors will pop up where the
> >    files lie beyond previous CD's geometry
> > 
> > The cause is:
> > 
> >  cdrom_open()
> >      open_for_data()
> >          cdo->drive_status() = sr_drive_status()
> >              cdrom_get_media_event()
> >              --> GPCMD_GET_EVENT_STATUS_NOTIFICATION
> >          --> med.media_present is true, return CDS_DISK_OK
> >      (success)
> >  check_disk_change()
> >     ... -> 2nd call to GPCMD_GET_EVENT_STATUS_NOTIFICATION
> > 
> > at this point the device has already reset the new media event and the
> > call to revalidate_disk() in check_disk_change() is never made.
> 
> Hmm... I see.  That's something I didn't expect.

...

> But I don't think this is the correct place to do it.  The problem
> happens because block layer consumes the event but doesn't remember it
> when the time for revalidation comes.  It should be done by block
> layer, not sr.

Hm, only the open call at the start of the call sequence is involved
from the block layer.  How to pass on such a pending event back?  Some
kind of an event array with helpers to modify it?

		Amit
