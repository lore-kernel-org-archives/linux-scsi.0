From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fusion: streamline ->slave_alloc/->slave_destroy
Date: Tue, 26 Oct 2004 18:12:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041026161212.GA28795@lst.de>
References: <0E3FA95632D6D047BA649F95DAB60E57053AF0AF@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:10727 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261303AbUJZQMV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 12:12:21 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57053AF0AF@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, Matt_Domsch@Dell.com, linux-scsi@vger.kernel.org

On Tue, Oct 26, 2004 at 12:02:13PM -0400, Moore, Eric Dean wrote:
> On Tuesday, October 26, 2004 6:55 AM, Christoph Hellwig wrote:
> > That was not just with my patch but with your new monster 
> > update, right?
> > 
> > It contains this totally bogus line:
> > 
> > +                       
> > +                       /* remove the device from our 
> > internal data structures */
> > +                       if(hd->Targets[pScsiReq->TargetID] != NULL) {
> > +                               mptscsih_slave_destroy(sc->device);
> > +                       }
> > +                   
> > 
> > in mptscsih_io_done
> >
> 
> This code was added by request of the megalib team, and Matt Domsch.
> This was added for support of hot swap in non-raid environment.  
> The IOCSTATUS=MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE will be received 
> when drive has been removed, and this code was added to automatically
> remove the instance of the device.  Thus an application such as megalib
> would
> know real time that devices have been removed, instead of waiting on a scsi
> bus scan.

but this is buggy.  You must tell the scsi midlayer to perform a removal
with scsi_remove_device, which will call back into ->slave_destroy.  If
you just call mptscsih_slave_destroy there's still a midlayer
scsi_device object, but your internal datastructures are dangling.

