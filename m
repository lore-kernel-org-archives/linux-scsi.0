From: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 1/9] drivers/scsi/atp870u.c: add missing kfree
Date: Mon, 8 Aug 2011 20:37:01 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1108082036451.12465@ask.diku.dk>
References: <1312802283-9107-1-git-send-email-julia@diku.dk>
 <20110808181238.GB7659@shale.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:39105 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab1HHShI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2011 14:37:08 -0400
In-Reply-To: <20110808181238.GB7659@shale.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 8 Aug 2011, Dan Carpenter wrote:

> This one is going to need to be redone.  There are some parenthesis
> missing so the new code will always fail.
> 
> > -1 is probably not the best return value either.
> 
> Nope.  It's not.  You could avoid it most of the time by passing the
> error code from the lower levels, as I show below.

OK, I will look into it.  Thanks.

julia


> >  drivers/scsi/atp870u.c |  113 +++++++++++++++++++++++++++++--------------------
> >  1 file changed, 69 insertions(+), 44 deletions(-)
> > 
> > diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
> > index 7e6eca4..271211c 100644
> > --- a/drivers/scsi/atp870u.c
> > +++ b/drivers/scsi/atp870u.c
> > @@ -2552,7 +2552,7 @@ static int atp870u_init_tables(struct Scsi_Host *host)
> >  	return 0;
> >  }
> >  
> > -/* return non-zero on detection */
> > +/* return zero on detection */
> >  static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >  {
> >  	unsigned char k, m, c;
> > @@ -2563,19 +2563,23 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >  	struct atp_unit *atpdev, *p;
> >  	unsigned char setupdata[2][16];
> >  	int count = 0;
> > +	int ret = 0;
> >  
> >  	atpdev = kzalloc(sizeof(*atpdev), GFP_KERNEL);
> >  	if (!atpdev)
> >  		return -ENOMEM;
> >  
> > -	if (pci_enable_device(pdev))
> > -		goto err_eio;
> > +	if (pci_enable_device(pdev)) {
> 
> 	ret = pci_enable_device();
> 
> > +		ret = -EIO;
> > +		goto out;
> > +	}
> >  
> >          if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
> 	ret = pci_set_dma_mask();
> 
> 
> >                  printk(KERN_INFO "atp870u: use 32bit DMA mask.\n");
> >          } else {
> >                  printk(KERN_ERR "atp870u: DMA mask required but not available.\n");
> > -		goto err_eio;
> > +		ret = -EIO;
> > +		goto out;
> >          }
> >  
> >  	/*
> > @@ -2584,8 +2588,10 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >  	 */
> >  	if (ent->device == PCI_DEVICE_ID_ARTOP_AEC7610) {
> >  		error = pci_read_config_byte(pdev, PCI_CLASS_REVISION, &atpdev->chip_ver);
> > -		if (atpdev->chip_ver < 2)
> > -			goto err_eio;
> > +		if (atpdev->chip_ver < 2) {
> > +			ret = -EIO;
> > +			goto out;
> > +		}
> >  	}
> >  
> >  	switch (ent->device) {
> > @@ -2675,8 +2681,10 @@ flash_ok_880:
> >  		outb(atpdev->global_map[0], base_io + 0x35);
> >   
> >  		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
> > -		if (!shpnt)
> > -			goto err_nomem;
> > +		if (!shpnt) {
> > +			ret = -ENOMEM;
> > +			goto out;
> > +		}
> >  
> >  		p = (struct atp_unit *)&shpnt->hostdata;
> >  
> > @@ -2686,11 +2694,13 @@ flash_ok_880:
> >  		memcpy(p, atpdev, sizeof(*atpdev));
> >  		if (atp870u_init_tables(shpnt) < 0) {
> 
> 		ret = atp870u_init_tables();
> 
> 
> >  			printk(KERN_ERR "Unable to allocate tables for Acard controller\n");
> > +			ret = -1;
> >  			goto unregister;
> >  		}
> >  
> >  		if (request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp880i", shpnt)) {
> 
> 		ret = request_irq();
> 
> 
> >   			printk(KERN_ERR "Unable to allocate IRQ%d for Acard controller.\n", pdev->irq);
> > +			ret = -1;
> >  			goto free_tables;
> >  		}
> >  
> > @@ -2745,8 +2755,10 @@ flash_ok_880:
> >  		atpdev->pciport[1] = base_io + 0x50;
> >  				
> >  		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
> > -		if (!shpnt)
> > -			goto err_nomem;
> > +		if (!shpnt) {
> > +			ret = -ENOMEM;
> > +			goto out;
> > +		}
> >          	
> >  		p = (struct atp_unit *)&shpnt->hostdata;
> >          	
> > @@ -2754,14 +2766,17 @@ flash_ok_880:
> >  		atpdev->pdev = pdev;
> >  		pci_set_drvdata(pdev, p);
> >  		memcpy(p, atpdev, sizeof(struct atp_unit));
> > -		if (atp870u_init_tables(shpnt) < 0)
> > +		if (atp870u_init_tables(shpnt) < 0) {
> 
> 		ret = atp870u_init_tables();
> 
> > +			ret = -1;
> >  			goto unregister;
> > +		}
> >  			
> >  #ifdef ED_DBGP		
> >  	printk("request_irq() shpnt %p hostdata %p\n", shpnt, p);
> >  #endif	        
> >  		if (request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp870u", shpnt)) {
> 
> 		ret = request_irq();
> 
> > -				printk(KERN_ERR "Unable to allocate IRQ for Acard controller.\n");
> > +			printk(KERN_ERR "Unable to allocate IRQ for Acard controller.\n");
> > +			ret = -1;
> >  			goto free_tables;
> >  		}
> >  		
> > @@ -2772,13 +2787,11 @@ flash_ok_880:
> >          	
> >  		n=0x1f80;
> >  next_fblk_885:
> > -		if (n >= 0x2000) {
> > -		   goto flash_ok_885;
> > -		}
> > +		if (n >= 0x2000)
> > +			goto flash_ok_885;
> >  		outw(n,base_io + 0x3c);
> > -		if (inl(base_io + 0x38) == 0xffffffff) {
> > -		   goto flash_ok_885;
> > -		}
> > +		if (inl(base_io + 0x38) == 0xffffffff)
> > +			goto flash_ok_885;
> >  		for (m=0; m < 2; m++) {
> >  		    p->global_map[m]= 0;
> >  		    for (k=0; k < 4; k++) {
> > @@ -2930,8 +2943,10 @@ flash_ok_885:
> >  		}
> >  
> >  		shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
> > -		if (!shpnt)
> > -			goto err_nomem;
> > +		if (!shpnt) {
> > +			ret = -ENOMEM;
> > +			goto out;
> > +		}
> >  
> >  		p = (struct atp_unit *)&shpnt->hostdata;
> >  		
> > @@ -2940,10 +2955,12 @@ flash_ok_885:
> >  		pci_set_drvdata(pdev, p);
> >  		memcpy(p, atpdev, sizeof(*atpdev));
> >  		if (atp870u_init_tables(shpnt) < 0)
> 
> 		ret = atp870u_init_tables()
> 
> > +			ret = -1;
> >  			goto unregister;
> 
> parenthesis needed here.
> 
> >  
> >  		if (request_irq(pdev->irq, atp870u_intr_handle, IRQF_SHARED, "atp870i", shpnt)) {
> 
> 		ret = request_irq();
> 
> >  			printk(KERN_ERR "Unable to allocate IRQ%d for Acard controller.\n", pdev->irq);
> > +			ret = -1;
> >  			goto free_tables;
> >  		}
> >  
> > @@ -2991,26 +3008,38 @@ flash_ok_885:
> >  		shpnt->io_port = base_io;
> >  		shpnt->n_io_port = 0x40;	/* Number of bytes of I/O space used */
> >  		shpnt->irq = pdev->irq;		
> > -	} 
> > -		spin_unlock_irqrestore(shpnt->host_lock, flags);
> > -		if(ent->device==ATP885_DEVID) {
> > -			if(!request_region(base_io, 0xff, "atp870u")) /* Register the IO ports that we use */
> > -				goto request_io_fail;
> > -		} else if((ent->device==ATP880_DEVID1)||(ent->device==ATP880_DEVID2)) {
> > -			if(!request_region(base_io, 0x60, "atp870u")) /* Register the IO ports that we use */
> > -				goto request_io_fail;
> > -		} else {
> > -			if(!request_region(base_io, 0x40, "atp870u")) /* Register the IO ports that we use */
> > -				goto request_io_fail;
> > -		}				
> > -		count++;
> > -		if (scsi_add_host(shpnt, &pdev->dev))
> > -			goto scsi_add_fail;
> > -		scsi_scan_host(shpnt);
> > +	}
> > +	spin_unlock_irqrestore(shpnt->host_lock, flags);
> > +	if (ent->device == ATP885_DEVID) {
> > +		/* Register the IO ports that we use */
> > +		if (!request_region(base_io, 0xff, "atp870u")) {
> > +			ret = -1;
> 
> 	If request_region() fails then the correct return is actually
> 	-EBUSY.
> 
> > +			goto request_io_fail;
> > +		}
> > +	} else if ((ent->device == ATP880_DEVID1) ||
> > +		   (ent->device == ATP880_DEVID2)) {
> > +		/* Register the IO ports that we use */
> > +		if (!request_region(base_io, 0x60, "atp870u")) {
> > +			ret = -1;
> 
> 			ret = -EBUSY;
> 
> > +			goto request_io_fail;
> > +		}
> > +	} else {
> > +		/* Register the IO ports that we use */
> > +		if (!request_region(base_io, 0x40, "atp870u")) {
> > +			ret = -1;
> 
> 			ret = -EBUSY;
> 
> > +			goto request_io_fail;
> > +		}
> > +	}
> > +	count++;
> > +	if (scsi_add_host(shpnt, &pdev->dev)) {
> 	ret = scsi_add_host();
> 
> 
> > +		ret = -1;
> > +		goto scsi_add_fail;
> > +	}
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
