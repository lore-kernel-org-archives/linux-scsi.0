From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v5 3/3] scsi: async sd resume
Date: Tue, 11 Mar 2014 08:19:49 +0400
Message-ID: <1394511589.2142.5.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1403101658490.5966-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60945 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbaCKETz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Mar 2014 00:19:55 -0400
In-Reply-To: <Pine.LNX.4.44L0.1403101658490.5966-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>, Len Brown <len.brown@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Phillip Susi <psusi@ubuntu.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, Todd Brandt <todd.e.brandt@linux.intel.com>

On Mon, 2014-03-10 at 16:59 -0400, Alan Stern wrote:
> On Mon, 10 Mar 2014, Dan Williams wrote:
> 
> > > The only thing which is a bit concerning is that this doesn't have any
> > > throttling mechanism for simultaneous wakeups.  Would this be able to
> > > blow up the PSU if used on a machine with a lot of spindles?
> > 
> > Good point.  The primary benefit is completing userspace resume
> > without needlessly waiting for the disk.  For now I think it would be
> > enough to have a mutex to maintain one disk at a time.  We can follow
> > on later with something more complex to enable a max simultaneous
> > spin-up tunable.
> 
> Why?  The existing code doesn't have anything like that.

This only becomes a problem if enterprise class systems want to suspend
and resume.  Last I heard, this wasn't on the cards.

We also don't usually need to bother with in-kernel staggered spin ups
because if the device can blow the PSU by doing simultaneous spinups,
staggering is usually hard jumpered in the system.  The main reason for
this is that there's no way for us to work out the PSU topology to do
the stagger in kernel, so the enterprise likes to be sure.

James



