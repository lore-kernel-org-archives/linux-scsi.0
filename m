From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fusion: streamline ->slave_alloc/->slave_destroy
Date: Thu, 21 Oct 2004 11:09:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041021090940.GC25645@lst.de>
References: <0E3FA95632D6D047BA649F95DAB60E5705262988@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:1451 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S270513AbUJUJJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 05:09:46 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5705262988@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, Oct 11, 2004 at 02:39:54PM -0400, Moore, Eric Dean wrote:
> > > > -	hd = (MPT_SCSI_HOST *)host->hostdata;
> > > > +	mptscsih_search_running_cmds(hd, target, lun);
> > > >  
> > > > -	if (hd == NULL)
> > > > +	vdev->luns[0] &= ~(1 << lun);
> > > 
> > > Ok - I'm finally getting around to testing this patch.
> > > 
> > > The driver will oops on this line because this routine is 
> > > sometimes called when vdev=NULL.  Your patch had removed the
> > > check for this NULL pointer. We probally should add it back.
> > 
> > Do you have a backtrace of such a case?  It really shouldn't happen
> > as the vdev is allocated in ->slave_alloc, and that one returns an
> > error if it couldn't allocate.
> >
> 
> 
> The problem is mptscsih_slave_destroy is being called twice. The first
> time we free hd->Targets, the second time we hit the oops.  I'm still
> investigating. Here is back trace using source level debugger.   Also
> beyond the back trace is snip of source, having the embedded printks.

the only thing I could imagine that could cause this is a race in
num_luns manipulation.  Care to check whether the oops goes away when
you turn it into an atomic_t?

