From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH 2.6.12-rc4-mm1 4/4] megaraid_sas: updating the driver
Date: Wed, 18 May 2005 14:58:20 +0100
Message-ID: <20050518135820.GB22003@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57060CCE9A@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:3813 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262204AbVERN6V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2005 09:58:21 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CCE9A@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>

On Tue, May 17, 2005 at 10:59:13PM -0400, Bagalkote, Sreenivas wrote:
> >The void * casats are not okay.  Please make sure all your variable
> >holding the I/O address are of type void __iomem * and use 
> >sparse to check
> >it.  I would have sent you sparse output if your mailer didn't mangle
> >the patch so it couldn't be applied..
> >
> 
> I will remove these macros. What is sparse output?

sparse is a tool written by Linus that allows stricter type checking.
We use to verify that drivers don't directly dereference pointers to
userspace or I/O memory and that we always perform byte swapping on
hardware structures that have a defined endianess.

Unfortunately Linus doesn't seem to release tarballs of it, but Al Viro
has a semi-recent version at

    ftp://ftp.linux.org.uk/pub/people/viro/sparse.tar.bz2

To use it on a kernel tree build and install it and then compile your
driver with make C=1.  This doesn't check endianess yet, for that check
you need to edit the toplevel Makefile and add -Wbitwise to the
CHECKFLAGS line.

> >> +#define SCP2HOST(scp)		(scp)->device->host	
> >// to host
> >> +#define SCP2HOSTDATA(scp)	SCP2HOST(scp)->hostdata	// to soft state
> >> +#define SCP2CHANNEL(scp)	(scp)->device->channel	// to channel
> >> +#define SCP2TARGET(scp)		(scp)->device->id	
> >// to target
> >> +#define SCP2LUN(scp)		(scp)->device->lun	
> >// to LUN
> >
> >Please remove all these macros.
> 
> Christoph, I use these macros to have commonality between 2.4 and 2.6
> kernels. Please consider retaining them. 

While Linux 2.4 offers getting the host, id and lun from the scsi_cmnd
directly you can also get them from the scsi_device, so you can use
the above variants directly for both 2.4 and 2.6

