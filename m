From: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Subject: RE: [PATCH] cciss: handler scsi_add_host failure
Date: Wed, 5 Jan 2005 14:16:15 -0600
Message-ID: <D4CFB69C345C394284E4B78B876C1CF107DC016A@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ztxmail04.ztx.compaq.com ([161.114.1.208]:42502 "EHLO
	ztxmail04.ztx.compaq.com") by vger.kernel.org with ESMTP
	id S262634AbVAEUQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2005 15:16:19 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, ISS StorageDev <iss_storagedev@hp.com>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

> From: Christoph Hellwig [mailto:hch@lst.de]
> 
> Mike, is this patch okay?
> 

Yes, this looks OK. It's something that was on my todo list that kept getting pushed down.

Signed-off-by: Mike Miller <mike.miller@hp.com>

> On Mon, Jan 03, 2005 at 02:24:31PM +0100, Christoph Hellwig wrote:
> > --- 1.23/drivers/block/cciss_scsi.c	2004-10-14 16:15:25 +02:00
> > +++ edited/drivers/block/cciss_scsi.c	2004-12-31 
> 14:42:51 +01:00
> > @@ -691,14 +691,13 @@ static int
> >  cciss_scsi_detect(int ctlr)
> >  {
> >  	struct Scsi_Host *sh;
> > +	int error;
> >  
> >  	sh = scsi_host_alloc(&cciss_driver_template, 
> sizeof(struct ctlr_info *));
> >  	if (sh == NULL)
> > -		return 0;
> > -
> > +		goto fail;
> >  	sh->io_port = 0;	// good enough?  FIXME, 
> >  	sh->n_io_port = 0;	// I don't think we use these two...
> > -
> >  	sh->this_id = SELF_SCSI_ID;  
> >  
> >  	((struct cciss_scsi_adapter_data_t *) 
> > @@ -706,10 +705,16 @@ cciss_scsi_detect(int ctlr)
> >  	sh->hostdata[0] = (unsigned long) hba[ctlr];
> >  	sh->irq = hba[ctlr]->intr;
> >  	sh->unique_id = sh->irq;
> > -	scsi_add_host(sh, &hba[ctlr]->pdev->dev); /* XXX handle 
> failure */
> > +	error = scsi_add_host(sh, &hba[ctlr]->pdev->dev);
> > +	if (error)
> > +		goto fail_host_put;
> >  	scsi_scan_host(sh);
> > -
> >  	return 1;
> > +
> > + fail_host_put:
> > +	scsi_host_put(sh);
> > + fail:
> > +	return 0;
> >  }
> >  
> >  static void __exit cleanup_cciss_module(void);
> ---end quoted text---
> 
