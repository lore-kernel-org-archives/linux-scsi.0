From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/4] hpsa: correct lockup detector pci_disable_device
Date: Thu, 27 Oct 2016 11:25:45 +0200
Message-ID: <20161027092545.6i66upinuzqmoziv@linux-x5ow.site>
References: <147752001094.813.10247306839794156732.stgit@brunhilda>
 <147752050626.813.15549750881571218281.stgit@brunhilda>
 <8a97e475-7ed5-d34b-3f5e-1cb60c6a0521@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32850 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030213AbcJ0OFA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 10:05:00 -0400
Content-Disposition: inline
In-Reply-To: <8a97e475-7ed5-d34b-3f5e-1cb60c6a0521@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com, linux-scsi@vger.kernel.org

On Thu, Oct 27, 2016 at 11:01:41AM +0200, Hannes Reinecke wrote:
> On 10/27/2016 12:21 AM, Don Brace wrote:
> > need to check if the device is already disabled first
> > 
> > Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> > Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> > Signed-off-by: Don Brace <don.brace@microsemi.com>
> > ---
> >  drivers/scsi/hpsa.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index d007ec1..798fb20 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -8456,7 +8456,8 @@ static void controller_lockup_detected(struct ctlr_info *h)
> >  	spin_unlock_irqrestore(&h->lock, flags);
> >  	dev_warn(&h->pdev->dev, "Controller lockup detected: 0x%08x after %d\n",
> >  			lockup_detected, h->heartbeat_sample_interval / HZ);
> > -	pci_disable_device(h->pdev);
> > +	if (pci_is_enabled(h->pdev))
> > +		pci_disable_device(h->pdev);
> >  	fail_all_outstanding_cmds(h);
> >  }
> >  
> > 
> Meh.
> Why is pci_disable_device() not checking for it?

It does:
1607 void pci_disable_device(struct pci_dev *dev)
1608 {
[...]
1615         dev_WARN_ONCE(&dev->dev, atomic_read(&dev->enable_cnt) <= 0,
1616                       "disabling already-disabled device");
[...]
1624 }
1625 EXPORT_SYMBOL(pci_disable_device);

Which is the motivation behind this patch I think.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
