From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] add spi attributes to qla1280
Date: Wed, 11 Aug 2004 14:56:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040811215651.GA30821@sgi.com>
References: <20040810230552.GA26569@sgi.com> <20040811081118.A26256@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:62599 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S268254AbUHKV5G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 17:57:06 -0400
Content-Disposition: inline
In-Reply-To: <20040811081118.A26256@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Aug 11, 2004 at 08:11:18AM +0100, Christoph Hellwig wrote:
> > +	if (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160 ||
> > +	    ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160)
> > +		is1x160 = 1;
> > +	else
> > +		is1x160 = 0;
> 
> The driver in James' tree has most of my 1040-support patches merged,
> sp please use the apporpinquate IS_ISP* macros like the rest of the drivers
> does, and please handle the 1040 aswell in that code.

The above is consistent with the rest of the driver in 2.6.8-rc2.
So are you asking that I submit a patch to the driver in James's
tree instead of to 2.6.8-rc2?

To avoid possibility of error, can you give me the URL for James's
tree?  Is it a bk tree or a kernel.org tree?

> > +static struct scsi_transport_template *qla1280_transport_template = NULL;
> 
> No need to initialize to NULL here.

I thought about that.  What I did was take a patch that Martin Hicks
submitted on March 10th and then make changes based on what I saw that
James had done for the 53c700 driver, which has:

drivers/scsi/53c700.c:STATIC struct scsi_transport_template *NCR_700_transport_template = NULL;

I will remove the initializer if I don't need it.

> >  static int __devinit
> >  qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
> >  {
> > @@ -4758,6 +4778,7 @@
> >  	host->max_id = MAX_TARGETS;
> >  	host->max_sectors = 1024;
> >  	host->unique_id = host->host_no;
> > +	host->transportt = qla1280_transport_template;
> >  
> >  #if LINUX_VERSION_CODE < 0x020545
> >  	host->select_queue_depths = qla1280_select_queue_depth;
> > @@ -4890,6 +4911,12 @@
> >  	.remove		= __devexit_p(qla1280_remove_one),
> >  };
> >  
> > +static struct spi_function_template qla1280_transport_functions = {
> > +	.show_period = 1,
> > +	.show_offset = 1,
> > +};
> 
> Any chance you could declare this just below the host template?  that keeps
> the code better organized.

Sure.

jeremy
