From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi host/scsi device ref count cleanup 3/4
Date: Sun, 13 Jul 2003 14:39:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030713143932.B24729@infradead.org>
References: <20030708222447.GA2232@beaverton.ibm.com> <20030708222541.GB2232@beaverton.ibm.com> <20030708222622.GC2232@beaverton.ibm.com> <20030708222706.GD2232@beaverton.ibm.com> <20030709085322.B21371@infradead.org> <20030710140340.GA3336@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:63759 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266169AbTGMNYs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jul 2003 09:24:48 -0400
Content-Disposition: inline
In-Reply-To: <20030710140340.GA3336@beaverton.ibm.com>; from andmike@us.ibm.com on Thu, Jul 10, 2003 at 07:03:40AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Thu, Jul 10, 2003 at 07:03:40AM -0700, Mike Anderson wrote:
> > Can you explain why we don't need that anymore?  /me wants to learn a bit
> > more about deep LDM magic..
> > 
> 
> I do not know if I can reveal the magic as some of this is bread crumbs
> created by previous bad paths taken :-).

Hehe.

> I think SCSI core has unique issues stuck between the bus layer struct
> device LDM registration and the block layer pure kobjects.
> 
> I removed the class get/puts to simplify the scsi_host_get code and
> reduce ordering problems between the class and device release methods.
> We could have chosen either the structure device or the class device to
> ref count on. The struct device appears to be a better object to ref
> count against as it is the child of the adapter struct device and the
> parent of the scsi device struct device.

Agreed.  What do we need the classdev for at all?

> ok I created a wrapper function called scsi_device_cancel_cb (seems like
> others where using callback but that seemed to long).

or just name it cancel_callback (I assume it's static)

> > Shouldn't these better be printed in ascii instead of the binary
> > presentation that might aswell change form one kernelrelease to
> > another?
> > 
> 
> Yes, I was lazy and did this initially for debug. Do have a suggested
> format (i.e., comma separated or colon separated or ??).

coma separated looks fine to me.

> 
> Yes it should. I made this a separate patch in the series
> in case Matthew / Alan see other changes needed with usb storage
> shutdown.

Ok.

