From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Mon, 5 May 2003 02:48:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505094818.GH8416@beaverton.ibm.com>
References: <20030505083315.GB8416@beaverton.ibm.com> <20030505093833.A13506@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:63377 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262121AbTEEJd7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 05:33:59 -0400
Content-Disposition: inline
In-Reply-To: <20030505093833.A13506@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

Christoph Hellwig [hch@infradead.org] wrote:
> On Mon, May 05, 2003 at 01:33:15AM -0700, Mike Anderson wrote:
> > Current Known Issues:
> > 	- Current users of scsi_remove_host will need to have there
> > 	  cleanup reordered to support the restoration of the call to the
> > 	  Scsi_Host_Template release.
> 
> That's not going to fly.  Most ->remove calls are surprise removals
> and thus scsi_remove_host must implcy a scsi_set_host_offline and never
> call into the LLDD again.  It can thusly free it's resources nicely
> after it called scsi_remove_host.  struct Scsi_Host itself needs
> refcounting, but as soon as scsi_remove_host is called it must be gone
> as far as the driver is concerned.  Your approch would imply we could
> imply we could get a scsi release callback long after the pci/whatever
> ->remove is called which is a very bad thing.

While scsi_remove_host cannot imply a scsi_set_host_offline unless we
change the previous definition. We indicated that scsi_set_host_offline
may cancel commands in flight which implys some sync point.

Ok I will look at the change you suggest in the morning after I have
some sleep. I guess the first step would be moving the kfree(shost) out
of scsi_unregister. This would then stay around until ref counts go to
zero.

-andmike
--
Michael Anderson
andmike@us.ibm.com

