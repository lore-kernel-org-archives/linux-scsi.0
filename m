From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 03/17] smartpqi: simplify spanning
Date: Wed, 31 Aug 2016 15:10:49 +0200
Message-ID: <20160831131049.m24oxxz6jsjumxsh@c203.arch.suse.de>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222986403.31214.11170219064850871397.stgit@brunhilda>
 <b620ec4f-9163-7c0f-a85b-7665dd811abc@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934200AbcHaNK5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 09:10:57 -0400
Content-Disposition: inline
In-Reply-To: <b620ec4f-9163-7c0f-a85b-7665dd811abc@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On Wed, Aug 31, 2016 at 02:59:16PM +0200, Tomas Henzl wrote:
> On 26.8.2016 18:44, Don Brace wrote:
> > From: Kevin Barnett <kevin.barnett@microsemi.com>
> >
> > Removed the workaround for the transition to spanning.
> >
> > Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> > Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> > Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> > Signed-off-by: Don Brace <don.brace@microsemi.com>
> > ---
> >  drivers/scsi/smartpqi/smartpqi_init.c |   38 +++++++++++++++++----------------
> >  1 file changed, 20 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> > index 6eab38e..9922e31 100644
> > --- a/drivers/scsi/smartpqi/smartpqi_init.c
> > +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> > @@ -3663,6 +3663,18 @@ static int pqi_validate_device_capability(struct pqi_ctrl_info *ctrl_info)
> >  		return -EINVAL;
> >  	}
> >  
> > +	if (!ctrl_info->inbound_spanning_supported) {
> > +		dev_err(&ctrl_info->pci_dev->dev,
> > +			"the controller does not support inbound spanning\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (ctrl_info->outbound_spanning_supported) {
> > +		dev_err(&ctrl_info->pci_dev->dev,
> > +			"the controller supports outbound spanning but this driver does not\n");
> > +		return -EINVAL;
> > +	}
> > +
> >  	return 0;
> >  }
> 
> This looks like you are dropping support for a probably older firmware devices,
> is that necessary - can't you continue a keep the support with something similar to that
> 'TEMPHACk' below ?

The question is, if any of these older firmware devices ever left the
Microsemi buildings. If not I _think_ it's save to drop it, as no real
users are harmed.

Byte,
      Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
