From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fusion: streamline ->queuecommand
Date: Thu, 21 Oct 2004 10:21:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041021092144.GB2322@infradead.org>
References: <20041002081355.GA13643@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:59401 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268991AbUJUJVt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 05:21:49 -0400
Content-Disposition: inline
In-Reply-To: <20041002081355.GA13643@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Emoore@lsil.com, linux-scsi@vger.kernel.org

ping?

On Sat, Oct 02, 2004 at 10:13:55AM +0200, Christoph Hellwig wrote:
> 
> --- 1.50/drivers/message/fusion/mptscsih.c	2004-09-29 01:58:39 +02:00
> +++ edited/drivers/message/fusion/mptscsih.c	2004-10-01 12:45:04 +02:00
> @@ -1863,11 +1844,7 @@
>  	u32	 cmd_len;
>  	int	 my_idx;
>  	int	 ii;
> -	int	 rc;
> -	int	 did_errcode;
> -	int	 issueCmd;
>  
> -	did_errcode = 0;
>  	hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
>  	target = SCpnt->device->id;
>  	lun = SCpnt->device->lun;
> @@ -1966,84 +1943,78 @@
>  	/* Now add the SG list
>  	 * Always have a SGE even if null length.
>  	 */
> -	rc = SUCCESS;
>  	if (datalen == 0) {
>  		/* Add a NULL SGE */
>  		mptscsih_add_sge((char *)&pScsiReq->SGL, MPT_SGE_FLAGS_SSIMPLE_READ | 0,
>  			(dma_addr_t) -1);
>  	} else {
>  		/* Add a 32 or 64 bit SGE */
> -		rc = mptscsih_AddSGE(hd->ioc, SCpnt, pScsiReq, my_idx);
> +		if (mptscsih_AddSGE(hd->ioc, SCpnt, pScsiReq, my_idx) != SUCCESS)
> +			goto fail;
>  	}
>  
> -
> -	if (rc == SUCCESS) {
> -		hd->ScsiLookup[my_idx] = SCpnt;
> -		SCpnt->host_scribble = NULL;
> -
> -		/* SCSI specific processing */
> -		issueCmd = 1;
> -		if (hd->is_spi) {
> -			int dvStatus = hd->ioc->spi_data.dvStatus[target];
> -
> -			if (dvStatus || hd->ioc->spi_data.forceDv) {
> +	hd->ScsiLookup[my_idx] = SCpnt;
> +	SCpnt->host_scribble = NULL;
>  
>  #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
> -				if ((dvStatus & MPT_SCSICFG_NEED_DV) ||
> -					(hd->ioc->spi_data.forceDv & MPT_SCSICFG_NEED_DV)) {
> -					unsigned long lflags;
> -					/* Schedule DV if necessary */
> -					spin_lock_irqsave(&dvtaskQ_lock, lflags);
> -					if (!dvtaskQ_active) {
> -						dvtaskQ_active = 1;
> -						spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
> -						INIT_WORK(&mptscsih_dvTask, mptscsih_domainValidation, (void *) hd);
> -
> -						schedule_work(&mptscsih_dvTask);
> -					} else {
> -						spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
> -					}
> -					hd->ioc->spi_data.forceDv &= ~MPT_SCSICFG_NEED_DV;
> -				}
> -
> -				/* Trying to do DV to this target, extend timeout.
> -				 * Wait to issue until flag is clear
> -				 */
> -				if (dvStatus & MPT_SCSICFG_DV_PENDING) {
> -					mod_timer(&SCpnt->eh_timeout, jiffies + 40 * HZ);
> -					issueCmd = 0;
> +	if (hd->is_spi) {
> +		int dvStatus = hd->ioc->spi_data.dvStatus[target];
> +		int issueCmd = 1;
> +
> +		if (dvStatus || hd->ioc->spi_data.forceDv) {
> +
> +			if ((dvStatus & MPT_SCSICFG_NEED_DV) ||
> +				(hd->ioc->spi_data.forceDv & MPT_SCSICFG_NEED_DV)) {
> +				unsigned long lflags;
> +				/* Schedule DV if necessary */
> +				spin_lock_irqsave(&dvtaskQ_lock, lflags);
> +				if (!dvtaskQ_active) {
> +					dvtaskQ_active = 1;
> +					spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
> +					INIT_WORK(&mptscsih_dvTask, mptscsih_domainValidation, (void *) hd);
> +
> +					schedule_work(&mptscsih_dvTask);
> +				} else {
> +					spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
>  				}
> +				hd->ioc->spi_data.forceDv &= ~MPT_SCSICFG_NEED_DV;
> +			}
>  
> -				/* Set the DV flags.
> -				 */
> -				if (dvStatus & MPT_SCSICFG_DV_NOT_DONE)
> -					mptscsih_set_dvflags(hd, pScsiReq);
> -#endif
> +			/* Trying to do DV to this target, extend timeout.
> +			 * Wait to issue until flag is clear
> +			 */
> +			if (dvStatus & MPT_SCSICFG_DV_PENDING) {
> +				mod_timer(&SCpnt->eh_timeout, jiffies + 40 * HZ);
> +				issueCmd = 0;
>  			}
> -		}
>  
> -#ifdef MPTSCSIH_DBG_TIMEOUT
> -		if (hd->ioc->timeout_cnt < hd->ioc->timeout_maxcnt) {
> -			foo_to[hd->ioc->timeout_cnt] = SCpnt;
> -			hd->ioc->timeout_cnt++;
> -			//mod_timer(&SCpnt->eh_timeout, jiffies + hd->ioc->timeout_delta);
> -			issueCmd = 0;
> -			printk(MYIOC_s_WARN_FMT
> -				"to pendingQ: (sc=%p, mf=%p, time=%ld)\n",
> -				hd->ioc->name, SCpnt, mf, jiffies);
> +			/* Set the DV flags.
> +			 */
> +			if (dvStatus & MPT_SCSICFG_DV_NOT_DONE)
> +				mptscsih_set_dvflags(hd, pScsiReq);
> +
> +			if (!issueCmd)
> +				goto fail;
>  		}
> +	}
>  #endif
>  
> -		if (issueCmd) {
> -			mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);
> -			dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=%p idx=%d\n",
> -					hd->ioc->name, SCpnt, mf, my_idx));
> -			DBG_DUMP_REQUEST_FRAME(mf)
> -		} else
> -			goto fail;
> -	} else
> +#ifdef MPTSCSIH_DBG_TIMEOUT
> +	if (hd->ioc->timeout_cnt < hd->ioc->timeout_maxcnt) {
> +		foo_to[hd->ioc->timeout_cnt] = SCpnt;
> +		hd->ioc->timeout_cnt++;
> +		//mod_timer(&SCpnt->eh_timeout, jiffies + hd->ioc->timeout_delta);
> +		printk(MYIOC_s_WARN_FMT
> +			"to pendingQ: (sc=%p, mf=%p, time=%ld)\n",
> +			hd->ioc->name, SCpnt, mf, jiffies);
>  		goto fail;
> +	}
> +#endif
>  
> +	mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);
> +	dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=%p idx=%d\n",
> +			hd->ioc->name, SCpnt, mf, my_idx));
> +	DBG_DUMP_REQUEST_FRAME(mf)
>  	return 0;
>  
>   fail:
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
