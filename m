From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH 1/3] 2.6.0 aacraid driver update
Date: Tue, 7 Oct 2003 22:39:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007213912.GD10906@parcelfarce.linux.theplanet.co.uk>
References: <1065475266.17021.75.camel@markh1.pdx.osdl.net> <3F81E4D8.20904@pobox.com> <1065561492.29117.46.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:43430 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262913AbTJGVjO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 17:39:14 -0400
Content-Disposition: inline
In-Reply-To: <1065561492.29117.46.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Tue, Oct 07, 2003 at 02:18:12PM -0700, Mark Haverkamp wrote:
> > > -		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
> > > +		pci_unmap_single(dev->pdev, (dma_addr_t)(unsigned long)scsicmd->SCp.ptr,
> > >  				 scsicmd->request_bufflen,
> > >  				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));

> I checked out this casting today.  The function takes a dma_addr_t as
> the argument.  You can't just pass the pointer in as is because:
> 
> drivers/scsi/aacraid/aachba.c:690: warning: passing arg 2 of `pci_unmap_single'
> makes integer from pointer without a cast
> 
> If you just cast the pointer to dma_addr_t you get:
> 
> drivers/scsi/aacraid/aachba.c:688: warning: cast from pointer to integer of different size
> 
> If you just cast to unsigned long, as in the code below, there aren't any warnings, but
> the wrong type is being passed to the function.  So, I think that both the casts are
> needed.

Oops, that's not true.  Try it out yourself.

int foo(short bar);

int baz(void)
{
	return foo(0x12345678);
}

will truncate the argument to foo to 0x5678 before calling it by
implicitly casting to a short.  So we can do just fine with:

-		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
+		pci_unmap_single(dev->pdev, (unsigned long)scsicmd->SCp.ptr,
 				 scsicmd->request_bufflen,
 				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));

Now that all that casting is out of the way, we can see this driver isn't
highmem-safe as it's storing a dma_addr_t in a pointer ... yuck.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
