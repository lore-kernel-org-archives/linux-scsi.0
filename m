From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Xen-devel] [PATCH V4 2/4] Introduce xen-scsifront module
Date: Mon, 11 Aug 2014 10:50:42 -0700
Message-ID: <20140811175042.GA6078@infradead.org>
References: <1407484194-31876-1-git-send-email-jgross@suse.com>
 <1407484194-31876-3-git-send-email-jgross@suse.com>
 <20140811095424.GB5952@infradead.org>
 <53E89A91.20203@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbaHKRun (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Aug 2014 13:50:43 -0400
Content-Disposition: inline
In-Reply-To: <53E89A91.20203@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com

On Mon, Aug 11, 2014 at 12:27:29PM +0200, Juergen Gross wrote:
> What do you mean with "unusual"? You mean transferring the EH action to
> Dom0?

Yes.  Note that hyperv tries something similar and they've run into
timeout issues, you might want to read up the recent thread on that.

> >>+				} else {
> >>+					xenbus_printf(XBT_NIL, dev->nodename,
> >>+						      state_str, "%d",
> >>+						      XenbusStateConnected);
> >>+				}
> >
> >Just print this message in ->slave_configure.
> 
> This is calling for problems, I think. xenbus_printf() is not just a
> printing function, but it changes an entry in the xenstore. And this
> requires locking, switching threads, ...
> 
> I doubt doing this while holding SCSI-internal locks is a good idea.

Oh, I thought xenbus_printf was just a logging wrapper.

Doing major work in the slave_* callouts is not a problem, that's what
they were designed for.

For the successful case the xenbus_printf should be done in
->slave_configure.  For the failure case you probably want to do it
from ->slave_destroy based on the absence of a flag set in ->slave_configure,
e.g. in slave_configure:

	sdev->hostdata = (void *)1UL;

and in ->slave_destroy:

	if (!sdev->hostdata)
		...

although you might see something like this based on external scanning
through procfs/sysfs as mentioned earlier, so please take a look at
how all these corner cases could effect you.
