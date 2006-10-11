From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] drivers/scsi/dpt_i2o.c: remove dead code
Date: Wed, 11 Oct 2006 16:52:22 +0200
Message-ID: <20061011145222.GL721@stusta.de>
References: <20061008231627.GO6755@stusta.de> <1160578300.16513.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45574 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1030552AbWJKOwZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Oct 2006 10:52:25 -0400
Content-Disposition: inline
In-Reply-To: <1160578300.16513.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Wed, Oct 11, 2006 at 03:51:40PM +0100, Alan Cox wrote:
> Ar Llu, 2006-10-09 am 01:16 +0200, ysgrifennodd Adrian Bunk:
> > The Coverity checker spotted this dead code introduced by
> > commit a07f353701acae77e023f6270e8af353b37af7c4.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> Semi-NAK
> 
> Its not dead jim, its in the wrong location
> 
> >  	while ((pDev = pci_get_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID, pDev))) {
> >  		if(pDev->device == PCI_DPT_DEVICE_ID ||
> >  		   pDev->device == PCI_DPT_RAPTOR_DEVICE_ID){
> >  			if(adpt_install_hba(sht, pDev) ){
> >  				PERROR("Could not Init an I2O RAID device\n");
> >  				PERROR("Will not try to detect others.\n");
> 
> ------------------------> pci_dev_put()
> 
> is needed there instead I think.
>...

The current code is:


        /* search for all Adatpec I2O RAID cards */
        while ((pDev = pci_get_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID, pDev))) {
                if(pDev->device == PCI_DPT_DEVICE_ID ||
                   pDev->device == PCI_DPT_RAPTOR_DEVICE_ID){
                        if(adpt_install_hba(sht, pDev) ){
                                PERROR("Could not Init an I2O RAID device\n");
                                PERROR("Will not try to detect others.\n");
                                return hba_count-1;
                        }
                        pci_dev_get(pDev);
                }
        }
        if (pDev)
                pci_dev_put(pDev);


I don't see the point of the suggested place for the pci_dev_put()
since pci_dev_get() has never been executed in this case, or do I miss 
anything?


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

