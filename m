From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fusion: streamline ->slave_alloc/->slave_destroy
Date: Sat, 9 Oct 2004 16:51:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041009145102.GB21041@lst.de>
References: <0E3FA95632D6D047BA649F95DAB60E570526244E@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:29076 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266891AbUJIOvH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2004 10:51:07 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570526244E@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 06, 2004 at 02:25:53PM -0400, Moore, Eric Dean wrote:
> On Saturday, October 02, 2004 2:24 AM,  Christoph Hellwig wrote:
> > @@ -2812,59 +2796,33 @@
> >  mptscsih_slave_destroy(struct scsi_device *device)
> >  {
> >  	struct Scsi_Host	*host = device->host;
> > -	MPT_SCSI_HOST		*hd;
> > -	VirtDevice		*vdev;
> > -	int 			raid_volume=0;
> > +	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
> > +	VirtDevice		*vdev =  hd->Targets[device->id];
> > +	uint			target = device->id;
> > +	uint			lun = device->lun;
> >  
> > -	hd = (MPT_SCSI_HOST *)host->hostdata;
> > +	mptscsih_search_running_cmds(hd, target, lun);
> >  
> > -	if (hd == NULL)
> > +	vdev->luns[0] &= ~(1 << lun);
> 
> Ok - I'm finally getting around to testing this patch.
> 
> The driver will oops on this line because this routine is 
> sometimes called when vdev=NULL.  Your patch had removed the
> check for this NULL pointer. We probally should add it back.

Do you have a backtrace of such a case?  It really shouldn't happen
as the vdev is allocated in ->slave_alloc, and that one returns an
error if it couldn't allocate.
