From: "Ely, Paul" <Paul.Ely@Emulex.Com>
Subject: RE: [Emulex] Ready for next round...
Date: Mon, 19 Jul 2004 16:02:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28025AB77B@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60105 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S265263AbUGSUDD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jul 2004 16:03:03 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, "Smart, James" <James.Smart@Emulex.Com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Christoph,

We have applied this patch to our source base and
tested it successfully.
 
Patch accepted for our 8.0.7 release.

Thanks,
 
Paul Ely
Emulex

> -----Original Message-----
> From: 'Christoph Hellwig' [mailto:hch@infradead.org]
> Sent: Saturday, July 17, 2004 4:27 PM
> To: Smart, James
> Cc: 'Christoph Hellwig'; Linux SCSI Reflector
> Subject: Re: [Emulex] Ready for next round...
> 
> 
> On Sat, Jul 17, 2004 at 09:17:35PM +0100, 'Christoph Hellwig' wrote:
> > On Sat, Jul 17, 2004 at 07:26:32AM -0400, Smart, James wrote:
> > > Christoph,
> > > 
> > > We've updated the driver on SourceForge again.  This 
> addresses the rework of
> > > the clk functions. Also rids the driver of Report Lun use.
> > > 
> > > I know this next week will probably be busy due to the 
> OLS, but we would
> > > appreciate comments any time that you can provide them.
> > 
> > Okay, this starts to look better.  There's lots of dead 
> code again, see the
> > patch below to remove it.  Also while the parameter rework 
> in the last drop
> > is already much better it still needs some more work I think.
> 
> Sorry, wrong patch.  The correct one is below.
> 
> 
> diff -uNr -X /home/hch/dontdiff lpfcdriver-2.6-8.0.6/lpfc.h 
> lpfcdriver-2.6-8.0.6-hch/lpfc.h
> --- lpfcdriver-2.6-8.0.6/lpfc.h	2004-07-16 
> 20:59:54.000000000 +0200
> +++ lpfcdriver-2.6-8.0.6-hch/lpfc.h	2004-07-17 
> 21:07:40.000000000 +0200
> @@ -411,9 +411,7 @@
>  	/* pci_mem_pools */
>  	struct pci_pool *lpfc_scsi_dma_ext_pool;
>  	struct pci_pool *lpfc_mbuf_pool;
> -	struct pci_pool *lpfc_page_pool;
>  	struct lpfc_dma_pool lpfc_mbuf_safety_pool;
> -	struct lpfc_dma_pool lpfc_page_safety_pool;
>  	mempool_t *scsibuf_mem_pool;
>  
>  	mempool_t *iocb_mem_pool;
> diff -uNr -X /home/hch/dontdiff 
> lpfcdriver-2.6-8.0.6/lpfc_crtn.h lpfcdriver-2.6-8.0.6-hch/lpfc_crtn.h
> --- lpfcdriver-2.6-8.0.6/lpfc_crtn.h	2004-07-16 
> 20:59:54.000000000 +0200
> +++ lpfcdriver-2.6-8.0.6-hch/lpfc_crtn.h	2004-07-17 
> 20:57:50.000000000 +0200
> @@ -76,13 +76,9 @@
>  void lpfc_disc_start(struct lpfc_hba *);
>  void lpfc_disc_flush_list(struct lpfc_hba *);
>  void lpfc_linkdown_timeout(unsigned long);
> -void lpfc_nodev_timeout(unsigned long);
>  void lpfc_establish_link_tmo(unsigned long);
>  void lpfc_disc_timeout(unsigned long);
>  struct lpfc_lun *lpfc_find_lun(struct lpfc_hba *, uint32_t, 
> uint64_t, int);
> -struct lpfc_scsi_buf *lpfc_build_scsi_cmd(struct lpfc_hba *,
> -					  struct lpfc_nodelist *,
> -					  uint32_t, uint64_t);
>  void lpfc_set_failmask(struct lpfc_hba *, struct 
> lpfc_nodelist *, uint32_t,
>  		       uint32_t);
>  
> @@ -223,7 +219,6 @@
>  			    uint16_t);
>  void lpfc_mbox_timeout(unsigned long);
>  
> -void lpfc_free_scsi_buf(struct lpfc_scsi_buf *);
>  void lpfc_map_fcp_cmnd_to_bpl(struct lpfc_hba *, struct 
> lpfc_scsi_buf *);
>  void lpfc_free_scsi_cmd(struct lpfc_scsi_buf *);
>  uint32_t lpfc_os_timeout_transform(struct lpfc_hba *, uint32_t);
> @@ -242,9 +237,6 @@
>  void lpfc_sli_wake_iocb_high_priority(struct lpfc_hba * phba,
>  				      struct lpfc_iocbq * queue1,
>  				      struct lpfc_iocbq * queue2);
> -void *lpfc_page_alloc(struct lpfc_hba *, int, dma_addr_t *);
> -void lpfc_page_free(struct lpfc_hba *, void *, dma_addr_t);
> -
>  void *lpfc_mbuf_alloc(struct lpfc_hba *, int, dma_addr_t *);
>  void lpfc_mbuf_free(struct lpfc_hba *, void *, dma_addr_t);
>  
> diff -uNr -X /home/hch/dontdiff 
> lpfcdriver-2.6-8.0.6/lpfc_hbadisc.c 
> lpfcdriver-2.6-8.0.6-hch/lpfc_hbadisc.c
> --- lpfcdriver-2.6-8.0.6/lpfc_hbadisc.c	2004-07-16 
> 20:59:54.000000000 +0200
> +++ lpfcdriver-2.6-8.0.6-hch/lpfc_hbadisc.c	2004-07-17 
> 20:57:30.000000000 +0200
> @@ -2450,7 +2450,7 @@
>  	return;
>  }
>  
> -void
> +static void
>  lpfc_nodev_timeout(unsigned long ptr)
>  {
>  	struct lpfc_hba *phba;
> diff -uNr -X /home/hch/dontdiff 
> lpfcdriver-2.6-8.0.6/lpfc_mem.c lpfcdriver-2.6-8.0.6-hch/lpfc_mem.c
> --- lpfcdriver-2.6-8.0.6/lpfc_mem.c	2004-07-16 
> 20:59:54.000000000 +0200
> +++ lpfcdriver-2.6-8.0.6-hch/lpfc_mem.c	2004-07-17 
> 21:08:10.000000000 +0200
> @@ -40,12 +40,8 @@
>  static void lpfc_mem_safety_pool_destroy(struct lpfc_hba *);
>  static void lpfc_mbuf_safety_pool_create(struct lpfc_hba *, 
> uint32_t );
>  static void lpfc_mbuf_safety_pool_destroy(struct lpfc_hba *);
> -static void lpfc_page_safety_pool_create(struct lpfc_hba *, 
> uint32_t );
> -static void lpfc_page_safety_pool_destroy(struct lpfc_hba *);
>  void *lpfc_mbuf_alloc(struct lpfc_hba *, int, dma_addr_t *);
>  void lpfc_mbuf_free(struct lpfc_hba *, void *, dma_addr_t);
> -void *lpfc_page_alloc(struct lpfc_hba *, int, dma_addr_t *);
> -void lpfc_page_free(struct lpfc_hba *, void *, dma_addr_t);
>  static void *lpfc_scsibuf_pool_alloc(int , void *);
>  static void  lpfc_scsibuf_pool_free(void *, void *);
>  
> @@ -66,8 +62,6 @@
>  
>  	phba->lpfc_scsi_dma_ext_pool = 0;
>  	phba->lpfc_mbuf_pool = 0;
> -	phba->lpfc_page_pool = 0;
> -
>  
>  	phba->lpfc_scsi_dma_ext_pool =
>  		pci_pool_create("lpfc_scsi_dma_ext_pool",
> @@ -83,21 +77,12 @@
>  				8,
>  				0);
>  
> -	phba->lpfc_page_pool =
> -		pci_pool_create("lpfc_page_pool",
> -				phba->pcidev,
> -				LPFC_SCSI_PAGE_BUF_SZ,
> -				8,
> -				0);
> -
> -	if ((!phba->lpfc_scsi_dma_ext_pool) || 
> (!phba->lpfc_mbuf_pool) ||
> -	   (!phba->lpfc_page_pool)) {
> +	if (!phba->lpfc_scsi_dma_ext_pool || !phba->lpfc_mbuf_pool) {
>  		lpfc_mem_free(phba);
>  		return (0);
>  	}
>  
>  	lpfc_mbuf_safety_pool_create(phba, LPFC_MBUF_POOL_SIZE);
> -	lpfc_page_safety_pool_create(phba, LPFC_PAGE_POOL_SIZE);
>  	lpfc_mem_safety_pool_create(phba, LPFC_MEM_POOL_SIZE);
>  
>  	return (1);
> @@ -126,7 +111,6 @@
>  	}
>  
>  	lpfc_mbuf_safety_pool_destroy(phba);
> -	lpfc_page_safety_pool_destroy(phba);
>  	lpfc_mem_safety_pool_destroy(phba);
>  
>  	if (phba->lpfc_scsi_dma_ext_pool)
> @@ -134,11 +118,7 @@
>  
>  	if (phba->lpfc_mbuf_pool)
>  		pci_pool_destroy(phba->lpfc_mbuf_pool);
> -
> -	if (phba->lpfc_page_pool)
> -		pci_pool_destroy(phba->lpfc_page_pool);
> -
> -	return (1);
> +	return 1;
>  }
>  
>  void
> @@ -232,51 +212,6 @@
>  	kfree(pool->elements);
>  }
>  
> -
> -static void
> -lpfc_page_safety_pool_create(struct lpfc_hba * phba, uint32_t count)
> -{
> -	int i;
> -
> -	struct lpfc_dma_pool *pool =
> -		&(phba->lpfc_page_safety_pool);
> -
> -	pool->elements = kmalloc(sizeof(struct lpfc_dmabuf) * count,
> -				 GFP_KERNEL);
> -	pool->max_count = 0;
> -	pool->current_count = 0;
> -	for ( i=0; i<count; i++) {
> -		pool->elements[i].virt =
> -			pci_pool_alloc(phba->lpfc_page_pool,
> -				       GFP_KERNEL,
> -				       &(pool->elements[i].phys));
> -
> -		if (!pool->elements[i].virt)
> -			break;
> -		pool->max_count++;
> -		pool->current_count++;
> -	}
> -}
> -
> -static void
> -lpfc_page_safety_pool_destroy(struct lpfc_hba * phba)
> -{
> -	struct lpfc_dma_pool *pool =
> -		&(phba->lpfc_page_safety_pool);
> -	int i;
> -
> -	if ( pool->max_count != pool->current_count)
> -		printk("Memory leaked in page safety pool \n");
> -
> -	for (i=0; i< pool->current_count; i++) {
> -		pci_pool_free(phba->lpfc_page_pool,
> -			      pool->elements[i].virt,
> -			      pool->elements[i].phys);
> -	}
> -
> -	kfree(pool->elements);
> -}
> -
>  void *
>  lpfc_mbuf_alloc(struct lpfc_hba * phba, int mem_flags, 
> dma_addr_t * handle)
>  {
> @@ -315,44 +250,6 @@
>  	return;
>  }
>  
> -void *
> -lpfc_page_alloc(struct lpfc_hba * phba, int mem_flags, 
> dma_addr_t * handle)
> -{
> -	void *ret;
> -	struct lpfc_dma_pool *pool =
> -		&(phba->lpfc_page_safety_pool);
> -
> -	ret = pci_pool_alloc(phba->lpfc_page_pool, GFP_ATOMIC, handle);
> -	/*
> -	   If we are low in memory and is priority memory allocation
> -	   use safety pool
> -	*/
> -	if ((!ret) && ( mem_flags & MEM_PRI)
> -	    && (pool->current_count)) {
> -		pool->current_count--;
> -		ret = pool->elements[pool->current_count].virt;
> -		*handle = pool->elements[pool->current_count].phys;
> -	}
> -	return ret;
> -}
> -
> -void
> -lpfc_page_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
> -{
> -	struct lpfc_dma_pool *pool =
> -		&(phba->lpfc_page_safety_pool);
> -
> -	if ( pool->current_count < pool->max_count) {
> -		pool->elements[pool->current_count].virt = virt;
> -		pool->elements[pool->current_count].phys = dma;
> -		pool->current_count++;
> -		return;
> -	}
> -
> -	pci_pool_free(phba->lpfc_page_pool, virt, dma);
> -	return;
> -}
> -
>  static void *
>  lpfc_scsibuf_pool_alloc(int gfp_flags, void *data) {
>  	void * ret;
> diff -uNr -X /home/hch/dontdiff 
> lpfcdriver-2.6-8.0.6/lpfc_scsiport.c 
> lpfcdriver-2.6-8.0.6-hch/lpfc_scsiport.c
> --- lpfcdriver-2.6-8.0.6/lpfc_scsiport.c	2004-07-16 
> 20:59:54.000000000 +0200
> +++ lpfcdriver-2.6-8.0.6-hch/lpfc_scsiport.c	2004-07-17 
> 20:56:01.000000000 +0200
> @@ -185,7 +185,7 @@
>  }
>  
>  /* This routine frees a scsi buffer, both DMAable and 
> non-DMAable regions */
> -void
> +static void
>  lpfc_free_scsi_buf(struct lpfc_scsi_buf * psb)
>  {
>  	struct lpfc_hba *phba;
> @@ -1127,177 +1127,6 @@
>  	return ret;
>  }
>  
> -struct lpfc_scsi_buf *
> -lpfc_build_scsi_cmd(struct lpfc_hba * phba,
> -		    struct lpfc_nodelist * nlp, uint32_t 
> scsi_cmd, uint64_t lun)
> -{
> -	struct lpfc_sli *psli;
> -	struct lpfc_target *targetp;
> -	struct lpfc_lun *lunp;
> -	struct lpfc_dmabuf *mp;
> -	struct lpfc_scsi_buf *lpfc_cmd;
> -	struct lpfc_iocbq *piocbq;
> -	IOCB_t *piocb;
> -	struct fcp_cmnd *fcpCmnd;
> -	struct ulp_bde64 *bpl;
> -	uint32_t tgt, size;
> -	struct scsi_cmnd *lnx_cmd;
> -	struct scsi_device *scsi_dev;
> -
> -	tgt = nlp->nlp_sid;
> -	lunp = lpfc_find_lun(phba, tgt, lun, 1);
> -	lpfc_cmd = 0;
> -	/* First see if the SCSI ID has an allocated struct 
> lpfc_target */
> -	if (lunp && lunp->pTarget) {
> -		targetp = lunp->pTarget;
> -		psli = &phba->sli;
> -
> -		/* Get a buffer to hold SCSI data */
> -		mp = kmalloc(sizeof (struct lpfc_dmabuf), GFP_ATOMIC);
> -		if (mp == 0) {
> -			return (0);
> -		}
> -
> -		INIT_LIST_HEAD(&mp->list);
> -		/* Get resources to send a SCSI command */
> -		lpfc_cmd = lpfc_get_scsi_buf(phba, GFP_ATOMIC);
> -		if (lpfc_cmd == 0) {
> -			kfree(mp);
> -			return (0);
> -		}
> -		lpfc_cmd->pLun = lunp;
> -		/* Internal-generated cmd, so we need to create 
> a temporary
> -		 * linux scsi_cmnd and scsi_device.
> -		 * Also means when this internal cmd done, we 
> need to free
> -		 * this scsi_cmnd and scsi_device structures.
> -		 */
> -		lnx_cmd = kmalloc(sizeof(struct scsi_cmnd), GFP_ATOMIC);
> -		if (lnx_cmd == 0) {
> -			kfree(mp);
> -			lpfc_free_scsi_buf(lpfc_cmd);
> -			return (0);
> -		}
> -		scsi_dev = kmalloc(sizeof(struct scsi_device), 
> GFP_ATOMIC);
> -		if (scsi_dev == 0) {
> -			kfree(mp);
> -			kfree(lnx_cmd);
> -			lpfc_free_scsi_buf(lpfc_cmd);
> -			return (0);
> -		}
> -		scsi_dev->id = tgt;
> -		scsi_dev->lun = lun;
> -		scsi_dev->hostdata = lunp;
> -		lnx_cmd->device = scsi_dev;
> -		lpfc_cmd->pCmd = lnx_cmd;
> -		lpfc_cmd->timeout = 30 + phba->fcp_timeout_offset;
> -
> -		/* Finish building BPL with the I/O dma ptrs.
> -		 * setup FCP CMND, and setup IOCB.
> -		 */
> -
> -		fcpCmnd = lpfc_cmd->fcp_cmnd;
> -
> -		putLunHigh(fcpCmnd->fcpLunMsl, lun);	/* LUN */
> -		putLunLow(fcpCmnd->fcpLunLsl, lun);	/* LUN */
> -
> -		switch (scsi_cmd) {
> -		case REPORT_LUNS:
> -			size = LPFC_SCSI_PAGE_BUF_SZ;
> -			fcpCmnd->fcpCdb[0] = scsi_cmd;
> -			/* 0x1000 = LPFC_SCSI_PAGE_BUF_SZ */
> -			fcpCmnd->fcpCdb[8] = 0x10;
> -			fcpCmnd->fcpCdb[9] = 0x00;
> -			fcpCmnd->fcpCntl3 = READ_DATA;
> -			fcpCmnd->fcpDl = 
> be32_to_cpu(LPFC_SCSI_PAGE_BUF_SZ);
> -			/* Get a buffer to hold SCSI data */
> -			if ((mp->virt =
> -			     lpfc_page_alloc(phba, 0, 
> &(mp->phys))) == 0) {
> -				if (mp)
> -					kfree(mp);
> -				lpfc_free_scsi_buf(lpfc_cmd);
> -				return (0);
> -			}
> -			break;
> -		case INQUIRY:
> -			fcpCmnd->fcpCdb[0] = scsi_cmd;	/* SCSI Inquiry
> -							   Command */
> -			fcpCmnd->fcpCdb[4] = 0xff;	/* 
> allocation length */
> -			fcpCmnd->fcpCntl3 = READ_DATA;
> -			fcpCmnd->fcpDl = be32_to_cpu(LPFC_SCSI_BUF_SZ);
> -			/* drop thru to get a buffer */
> -		default:
> -			size = LPFC_SCSI_BUF_SZ;
> -			/* Get a buffer to hold SCSI data */
> -			if ((mp->virt =
> -			     lpfc_mbuf_alloc(phba, 0, 
> &(mp->phys))) == 0) {
> -				if (mp)
> -					kfree(mp);
> -				lpfc_free_scsi_buf(lpfc_cmd);
> -				return (0);
> -			}
> -			break;
> -		}
> -
> -		bpl = lpfc_cmd->fcp_bpl;
> -		bpl += 2;	/* Bump past FCP CMND and FCP RSP */
> -
> -		/* no scatter-gather list case */
> -		bpl->addrLow = le32_to_cpu(putPaddrLow(mp->phys));
> -		bpl->addrHigh = le32_to_cpu(putPaddrHigh(mp->phys));
> -		bpl->tus.f.bdeSize = size;
> -		bpl->tus.f.bdeFlags = BUFF_USE_RCV;
> -		bpl->tus.w = le32_to_cpu(bpl->tus.w);
> -		bpl++;
> -		bpl->addrHigh = 0;
> -		bpl->addrLow = 0;
> -		bpl->tus.w = 0;
> -
> -		piocbq = &lpfc_cmd->cur_iocbq;
> -		piocb = &piocbq->iocb;
> -		piocb->ulpCommand = CMD_FCP_IREAD64_CR;
> -		piocb->ulpPU = PARM_READ_CHECK;
> -		piocb->un.fcpi.fcpi_parm = size;
> -		piocb->un.fcpi64.bdl.bdeSize += sizeof (struct 
> ulp_bde64);
> -		piocb->ulpBdeCount = 1;
> -		piocb->ulpLe = 1;	/* Set the LE bit in the iocb */
> -
> -		/* Get an iotag and finish setup of IOCB  */
> -		piocb->ulpIoTag = lpfc_sli_next_iotag(phba,
> -					      
> &phba->sli.ring[psli->fcp_ring]);
> -		piocb->ulpContext = nlp->nlp_rpi;
> -		if (nlp->nlp_fcp_info & NLP_FCP_2_DEVICE) {
> -			piocb->ulpFCP2Rcvy = 1;
> -		}
> -		piocb->ulpClass = (nlp->nlp_fcp_info & 0x0f);
> -
> -		/* ulpTimeout is only one byte */
> -		if (lpfc_cmd->timeout > 0xff) {
> -			/*
> -			 * Do not timeout the command at the 
> firmware level.
> -			 * The driver will provide the timeout 
> mechanism.
> -			 */
> -			piocb->ulpTimeout = 0;
> -		} else {
> -			piocb->ulpTimeout = lpfc_cmd->timeout;
> -		}
> -
> -		/*
> -		 * Setup driver timeout, in case the command 
> does not complete
> -		 * Driver timeout should be greater than ulpTimeout
> -		 */
> -
> -		piocbq->drvrTimeout = lpfc_cmd->timeout + 
> LPFC_DRVR_TIMEOUT;
> -
> -		/* set up iocb return path by setting the context fields
> -		 * and the completion function.
> -		 */
> -		piocbq->context1 = lpfc_cmd;
> -		piocbq->context2 = mp;
> -
> -	}
> -	return (lpfc_cmd);
> -}
> -
>  void
>  lpfc_scsi_timeout_handler(unsigned long ptr)
>  {
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
