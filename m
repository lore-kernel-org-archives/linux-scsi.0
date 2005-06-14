From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [Patch] take 4: Correct issue with midlayer scsi target allocation and transports that create the targets
Date: Tue, 14 Jun 2005 15:54:33 -0700
Message-ID: <20050614225433.GA16140@us.ibm.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC72@xbl3.ad.emulex.com> <20050611153745.GA31943@infradead.org> <20050614221700.GA15695@us.ibm.com> <20050614223535.GA6834@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42411 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261392AbVFNWzU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 18:55:20 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5EMtJNV032740
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2005 18:55:19 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5EMtJhh240496
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2005 18:55:19 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5EMtJpq018312
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2005 18:55:19 -0400
Content-Disposition: inline
In-Reply-To: <20050614223535.GA6834@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Tue, Jun 14, 2005 at 11:35:35PM +0100, Christoph Hellwig wrote:
> On Tue, Jun 14, 2005 at 03:17:00PM -0700, Patrick Mansfield wrote:

> > @@ -1190,10 +1199,15 @@ struct scsi_device *__scsi_add_device(st
> >  				      uint id, uint lun, void *hostdata)
> >  {
> >  	struct scsi_device *sdev;
> > -	struct device *parent = &shost->shost_gendev;
> > +	struct device *parent;
> >  	int res;
> > -	struct scsi_target *starget = scsi_alloc_target(parent, channel, id);
> > +	struct scsi_target *starget;
> >  
> > +	parent = scsi_target_parent(shost, channel, id);
> > +	if (!parent)
> > +		return ERR_PTR(-ENODEV);
> > +
> 
> scsi_add_device is a library function for LLDDs, thus it does not need
> this fix.  If we want LLDDs with objects below the target to use them
> in the future we should probably change the prototype so it takes a parent
> object.

> >  int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
> > @@ -1432,8 +1453,12 @@ struct scsi_device *scsi_get_host_dev(st
> >  {
> >  	struct scsi_device *sdev;
> >  	struct scsi_target *starget;
> > +	struct device *parent;
> >  
> > -	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
> > +	parent = scsi_target_parent(shost, 0, shost->this_id);
> > +	if (!parent)
> > +		return NULL;
> > +	starget = scsi_alloc_target(parent, 0, shost->this_id);
> 
> scsi_get_host_dev is a library function for LLDDs and does not need to
> care about this.

But if the transport is like FC or iSCSI, the eventual calls to
scsi_alloc_sdev() will fail (for qlogic, ->slave_alloc returns ENXIO) or
somehow be incorrect, so why not change these?

> > +	list_for_each_entry(rport, &fc_host_rports(shost), peers)
> > +		if ((rport->channel == channel) &&
> > +		    (rport->scsi_target_id == id)) {
> 
> lots of superflous braces ;-)

OK ))
