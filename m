From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/2] Convert megaraid to use pci_driver shutdown metho d
Date: Mon, 17 Oct 2005 10:17:13 -0700
Message-ID: <20051017171713.GE1251@kroah.com>
References: <0E3FA95632D6D047BA649F95DAB60E5707232141@exa-atlanta> <20051017134228.GA31938@infradead.org> <20051017170855.GA1251@kroah.com> <20051017171025.GA9540@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751133AbVJQRRq@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051017171025.GA9540@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, Russell King <rmk+lkml@arm.linux.org.uk>, Linux Kernel List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 17, 2005 at 06:10:25PM +0100, Christoph Hellwig wrote:
> On Mon, Oct 17, 2005 at 10:08:55AM -0700, Greg KH wrote:
> > On Mon, Oct 17, 2005 at 02:42:28PM +0100, Christoph Hellwig wrote:
> > > On Mon, Oct 17, 2005 at 09:26:12AM -0400, Kolli, Neela Syam wrote:
> > > > Patch looks good.  Thanks for the patch.
> > > 
> > > another 2.6.14 candidate, without it we'd easily get corruption
> > > on shutdown when the root filesystem is on megaraid.
> > 
> > No, the megaraid shutdown method will be called, only if that member
> > isn't set will the pci shutdown call be made.  So this should be safe
> > today, right?
> 
> If that actually got fixed it's fine indeed.

The code today is:

        /* FIXME, once all of the existing PCI drivers have been fixed to set
         * the pci shutdown function, this test can go away. */
        if (!drv->driver.shutdown)
                drv->driver.shutdown = pci_device_shutdown;

so we should be fine.

thanks,

greg k-h
