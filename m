From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fusion: streamline ->queuecommand
Date: Thu, 21 Oct 2004 10:58:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57053AEBFA@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62369 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266183AbUJUO7H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 10:59:07 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Christoph - This patch and the other patch "kill FusionInitCalled" are fine.
These two patches are currently incorporated into a driver currently being
tested in the labs.  I anticpate a posting a new release of the mpt driver 
early next week having SAS support.

Eric Moore


> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, October 21, 2004 3:22 AM
> To: Christoph Hellwig
> Cc: Emoore@lsil.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] fusion: streamline ->queuecommand
> 
> 
> ping?
> 
> On Sat, Oct 02, 2004 at 10:13:55AM +0200, Christoph Hellwig wrote:
> > 
> > --- 1.50/drivers/message/fusion/mptscsih.c	2004-09-29 
> 01:58:39 +02:00
> > +++ edited/drivers/message/fusion/mptscsih.c	
> 2004-10-01 12:45:04 +02:00
> > @@ -1863,11 +1844,7 @@
> >  	u32	 cmd_len;
> >  	int	 my_idx;
> >  	int	 ii;
> > -	int	 rc;
> > -	int	 did_errcode;
> > -	int	 issueCmd;
> >  
> > -	did_errcode = 0;
> >  	hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
> >  	target = SCpnt->device->id;
> >  	lun = SCpnt->device->lun;
> > @@ -1966,84 +1943,78 @@
> >  	/* Now add the SG list
> >  	 * Always have a SGE even if null length.
> >  	 */
> > -	rc = SUCCESS;
> >  	if (datalen == 0) {
> >  		/* Add a NULL SGE */
> >  		mptscsih_add_sge((char *)&pScsiReq->SGL, 
> MPT_SGE_FLAGS_SSIMPLE_READ | 0,
> >  			(dma_addr_t) -1);
> >  	} else {
> >  		/* Add a 32 or 64 bit SGE */
> > -		rc = mptscsih_AddSGE(hd->ioc, SCpnt, pScsiReq, my_idx);
> > +		if (mptscsih_AddSGE(hd->ioc, SCpnt, pScsiReq, 
> my_idx) != SUCCESS)
> > +			goto fail;
> >  	}
> >  
> > -
> > -	if (rc == SUCCESS) {
> > -		hd->ScsiLookup[my_idx] = SCpnt;
> > -		SCpnt->host_scribble = NULL;
> > -
> > -		/* SCSI specific processing */
> > -		issueCmd = 1;
> > -		if (hd->is_spi) {
> > -			int dvStatus = 
> hd->ioc->spi_data.dvStatus[target];
> > -
> > -			if (dvStatus || hd->ioc->spi_data.forceDv) {
> > +	hd->ScsiLookup[my_idx] = SCpnt;
> > +	SCpnt->host_scribble = NULL;
> >  
> >  #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
> > -				if ((dvStatus & MPT_SCSICFG_NEED_DV) ||
> > -					
> (hd->ioc->spi_data.forceDv & MPT_SCSICFG_NEED_DV)) {
> > -					unsigned long lflags;
> > -					/* Schedule DV if necessary */
> > -					
> spin_lock_irqsave(&dvtaskQ_lock, lflags);
> > -					if (!dvtaskQ_active) {
> > -						dvtaskQ_active = 1;
> > -						
> spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
> > -						
> INIT_WORK(&mptscsih_dvTask, mptscsih_domainValidation, (void *) hd);
> > -
> > -						
> schedule_work(&mptscsih_dvTask);
> > -					} else {
> > -						
> spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
> > -					}
> > -					
> hd->ioc->spi_data.forceDv &= ~MPT_SCSICFG_NEED_DV;
> > -				}
> > -
> > -				/* Trying to do DV to this 
> target, extend timeout.
> > -				 * Wait to issue until flag is clear
> > -				 */
> > -				if (dvStatus & MPT_SCSICFG_DV_PENDING) {
> > -					
> mod_timer(&SCpnt->eh_timeout, jiffies + 40 * HZ);
> > -					issueCmd = 0;
> > +	if (hd->is_spi) {
> > +		int dvStatus = hd->ioc->spi_data.dvStatus[target];
> > +		int issueCmd = 1;
> > +
> > +		if (dvStatus || hd->ioc->spi_data.forceDv) {
> > +
> > +			if ((dvStatus & MPT_SCSICFG_NEED_DV) ||
> > +				(hd->ioc->spi_data.forceDv & 
> MPT_SCSICFG_NEED_DV)) {
> > +				unsigned long lflags;
> > +				/* Schedule DV if necessary */
> > +				
> spin_lock_irqsave(&dvtaskQ_lock, lflags);
> > +				if (!dvtaskQ_active) {
> > +					dvtaskQ_active = 1;
> > +					
> spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
> > +					
> INIT_WORK(&mptscsih_dvTask, mptscsih_domainValidation, (void *) hd);
> > +
> > +					schedule_work(&mptscsih_dvTask);
> > +				} else {
> > +					
> spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
> >  				}
> > +				hd->ioc->spi_data.forceDv &= 
> ~MPT_SCSICFG_NEED_DV;
> > +			}
> >  
> > -				/* Set the DV flags.
> > -				 */
> > -				if (dvStatus & MPT_SCSICFG_DV_NOT_DONE)
> > -					
> mptscsih_set_dvflags(hd, pScsiReq);
> > -#endif
> > +			/* Trying to do DV to this target, 
> extend timeout.
> > +			 * Wait to issue until flag is clear
> > +			 */
> > +			if (dvStatus & MPT_SCSICFG_DV_PENDING) {
> > +				mod_timer(&SCpnt->eh_timeout, 
> jiffies + 40 * HZ);
> > +				issueCmd = 0;
> >  			}
> > -		}
> >  
> > -#ifdef MPTSCSIH_DBG_TIMEOUT
> > -		if (hd->ioc->timeout_cnt < hd->ioc->timeout_maxcnt) {
> > -			foo_to[hd->ioc->timeout_cnt] = SCpnt;
> > -			hd->ioc->timeout_cnt++;
> > -			//mod_timer(&SCpnt->eh_timeout, jiffies 
> + hd->ioc->timeout_delta);
> > -			issueCmd = 0;
> > -			printk(MYIOC_s_WARN_FMT
> > -				"to pendingQ: (sc=%p, mf=%p, 
> time=%ld)\n",
> > -				hd->ioc->name, SCpnt, mf, jiffies);
> > +			/* Set the DV flags.
> > +			 */
> > +			if (dvStatus & MPT_SCSICFG_DV_NOT_DONE)
> > +				mptscsih_set_dvflags(hd, pScsiReq);
> > +
> > +			if (!issueCmd)
> > +				goto fail;
> >  		}
> > +	}
> >  #endif
> >  
> > -		if (issueCmd) {
> > -			mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);
> > -			dmfprintk((MYIOC_s_INFO_FMT "Issued 
> SCSI cmd (%p) mf=%p idx=%d\n",
> > -					hd->ioc->name, SCpnt, 
> mf, my_idx));
> > -			DBG_DUMP_REQUEST_FRAME(mf)
> > -		} else
> > -			goto fail;
> > -	} else
> > +#ifdef MPTSCSIH_DBG_TIMEOUT
> > +	if (hd->ioc->timeout_cnt < hd->ioc->timeout_maxcnt) {
> > +		foo_to[hd->ioc->timeout_cnt] = SCpnt;
> > +		hd->ioc->timeout_cnt++;
> > +		//mod_timer(&SCpnt->eh_timeout, jiffies + 
> hd->ioc->timeout_delta);
> > +		printk(MYIOC_s_WARN_FMT
> > +			"to pendingQ: (sc=%p, mf=%p, time=%ld)\n",
> > +			hd->ioc->name, SCpnt, mf, jiffies);
> >  		goto fail;
> > +	}
> > +#endif
> >  
> > +	mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);
> > +	dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=%p 
> idx=%d\n",
> > +			hd->ioc->name, SCpnt, mf, my_idx));
> > +	DBG_DUMP_REQUEST_FRAME(mf)
> >  	return 0;
> >  
> >   fail:
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
> 
