From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH v3 2/5] arcmsr: fixes not release allocated resource
Date: Thu, 26 Nov 2015 15:32:30 +0800
Message-ID: <1448523150.4724.23.camel@Centos6.3-64>
References: <1448451683.4670.35.camel@Centos6.3-64>
	 <5655BDBD.404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36549 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbbKZHch (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2015 02:32:37 -0500
Received: by pacdm15 with SMTP id dm15so82624990pac.3
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2015 23:32:37 -0800 (PST)
In-Reply-To: <5655BDBD.404@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, jthumshirn@suse.de, hch@lst.de

On Wed, 2015-11-25 at 14:55 +0100, Tomas Henzl wrote:
> On 25.11.2015 12:41, Ching Huang wrote:
> > From: Ching Huang <ching2048@areca.com.tw>
> >
> > Releasing allocated resource if get configuration data failed.
> >
> > Signed-of-by: Ching Huang <ching2048@areca.com.tw>
> >
> > ---
> >
> > diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> > --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-24 11:35:26.000000000 +0800
> > +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 19:04:44.590970000 +0800
> > @@ -2664,7 +2664,7 @@ static bool arcmsr_hbaB_get_config(struc
> >  	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> >  		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
> >  			miscellaneous data' timeout \n", acb->host->host_no);
> > -		return false;
> > +		goto err_free_dma;
> >  	}
> >  	count = 8;
> >  	while (count){
> > @@ -2707,6 +2707,10 @@ static bool arcmsr_hbaB_get_config(struc
> >  	acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);  /*firm_cfg_version,25,100-103*/
> >  	/*firm_ide_channels,4,16-19*/
> >  	return true;
> > +err_free_dma:
> > +	dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
> > +			acb->dma_coherent2, acb->dma_coherent_handle2);
> > +	return false;
> >  }
> >  
> 
> The resource should be released here, that is okay. 
> 
> How works the resource management when the eh_bus_reset_handler
> is called ? It looks to me that you allocate a new 
> acb->dma_coherent2 without releasing it before.
> Btw. is it needed in that handler to re-read the firmware-spec?
> 
> Tomas
> 
You are right. In eh_bus_reset_handler, there may re-allocate a new dma resource if call get_config again.
I will initiate a new patches for this bug after current 5 patches.
Thanks Tomas.
> >  static bool arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


