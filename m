From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6.0 aacraid driver update
Date: Sun, 24 Aug 2003 13:33:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030824133312.A16798@infradead.org>
References: <1061567229.2067.15.camel@markh1.pdx.osdl.net> <20030822171600.A19262@infradead.org> <1061573399.2067.65.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:36357 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263417AbTHXMdN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Aug 2003 08:33:13 -0400
Content-Disposition: inline
In-Reply-To: <1061573399.2067.65.camel@markh1.pdx.osdl.net>; from markh@osdl.org on Fri, Aug 22, 2003 at 10:29:59AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Fri, Aug 22, 2003 at 10:29:59AM -0700, Mark Haverkamp wrote:
> > I'm not very happy with exporting this to drivers.  Can you explain the
> > code using it a bit?
> 
> Sorry, I can't explain it,  this code turned up in the 2.4 version.  I
> assume it was added by someone from Adaptec. Although it looks like I
> accidentally lost some comments when I brought the code over.  Here it
> is, I'll add it back into the function.

Maybe you can ping the adaptec folks for this change?

> > 
> > 
> > Also please convert the driver to be hotplug capable while you're
> > at it.
> 
> Is there a how-to posted somewhere for this?

I don't think so.  In short:

Convert it to the 2.4+ pci init scheme (struct pci_driver, etc..),
then kill of ->detect and put the unrolled loop over all HBAs in
the pci ->probe function, there call scsi_host_alloc instead of
scsi_register and call scsi_add_host(host, &pdev->dev) and
scsi_scan_host(host) at the end of the function.  the scsi_host_template
->release gets folded into the pci driver ->release.

