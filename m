From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi_device refcounting and list lockdown
Date: Fri, 31 Oct 2003 10:11:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031031091140.GA26182@lst.de>
References: <20031027155713.GA28140@lst.de> <1067553662.1839.363.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:62392 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263113AbTJaJMF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 04:12:05 -0500
Content-Disposition: inline
In-Reply-To: <1067553662.1839.363.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Oct 30, 2003 at 04:41:01PM -0600, James Bottomley wrote:
> This is wrong.  The messages are processed in the middle of a SCSI
> transaction, so the host lock is already held.

Ah okay.  Looks like I didn't follow up the callchain enough.

> > ===== drivers/scsi/scsi.h 1.91 vs edited =====
> > --- 1.91/drivers/scsi/scsi.h	Sat Sep 20 13:50:50 2003
> > +++ edited/drivers/scsi/scsi.h	Mon Oct 27 12:01:41 2003
> > @@ -116,12 +116,6 @@
> >  #define scsi_to_pci_dma_dir(scsi_dir)	((int)(scsi_dir))
> >  #define scsi_to_sbus_dma_dir(scsi_dir)	((int)(scsi_dir))
> >  
> > -/*
> > - * This is the crap from the old error handling code.  We have it in a special
> > - * place so that we can more easily delete it later on.
> > - */
> > -#include "scsi_obsolete.h"
> > -
> >  /* obsolete typedef junk. */
> >  #include "scsi_typedefs.h"
> 
> 
> This isn't a bug fix, and removing the obsolete include breaks all of
> the drivers relying on its defines (cpqfc, qlogicisp, qlogicfc,
> ncr53c8xx etc.)

Yes, this slipped through from the other patch and shouldn't be
included.  I disagree though that this shouldn't go in, but it certainly
does not belong into this patch.

> This isn't a bugfix either...it will just break unconverted drivers.

Yes, same as above.

