From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] some tmscsim consolidation
Date: Thu, 24 Jun 2004 00:16:13 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0406240014540.5464@poirot.grange>
References: <20040606124156.GA30931@lst.de> <20040623155948.GA27083@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:10959 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263117AbUFWWU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 18:20:29 -0400
In-Reply-To: <20040623155948.GA27083@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Hi

On Wed, 23 Jun 2004, Christoph Hellwig wrote:

> On Sun, Jun 06, 2004 at 02:41:56PM +0200, Christoph Hellwig wrote:
>> I've looked through my old tmscsim patch queue and found this one:
>>
>>  - merge dc390_initDCB into dc390_slave_alloc
>>  - merge DC390_release and dc390_shutdown into dc390_remove_one,
>>    use del_timer_sync to make sure the timer is really deleted on
>>    removal, adjust locking accordingly
>>  - some tiny related cleanups
>
> Okay, here's a resend vs current scsi-misc-2.6 that has your three
> outstanding merged.  Additionally I've also killed dc390_freeDCBs()
> as all dcbs are removed in ->slave_destroy.

Thanks, Christoph!

James, I need not to say - no objections, please, apply.

Thanks
Guennadi

>
>
> --- 1.14/drivers/scsi/scsiiom.c	2004-06-19 01:03:38 +02:00
> +++ edited/drivers/scsi/scsiiom.c	2004-06-23 16:40:08 +02:00
> @@ -1283,46 +1283,6 @@
>     DC390_write8 (ScsiCmd, MSG_ACCEPTED_CMD);	/* ;to release the /ACK signal */
> }
>
> -
> -static void
> -dc390_remove_dev (PACB pACB, PDCB pDCB)
> -{
> -   PDCB pPrevDCB = pACB->pLinkDCB;
> -
> -   if (pDCB->GoingSRBCnt > 1)
> -     {
> -	DCBDEBUG(printk (KERN_INFO "DC390: Driver won't free DCB (ID %i, LUN %i): 0x%08x because of SRBCnt %i\n",\
> -		pDCB->TargetID, pDCB->TargetLUN, (int)pDCB, pDCB->GoingSRBCnt));
> -	return;
> -     }
> -   pACB->DCBmap[pDCB->TargetID] &= ~(1 << pDCB->TargetLUN);
> -
> -   // The first one
> -   if (pDCB == pACB->pLinkDCB)
> -   {
> -	// The last one
> -	if (pACB->pLastDCB == pDCB) {
> -		pDCB->pNextDCB = 0; pACB->pLastDCB = 0;
> -	}
> -	pACB->pLinkDCB = pDCB->pNextDCB;
> -   }
> -   else
> -   {
> -	while (pPrevDCB->pNextDCB != pDCB) pPrevDCB = pPrevDCB->pNextDCB;
> -	pPrevDCB->pNextDCB = pDCB->pNextDCB;
> -	if (pDCB == pACB->pLastDCB) pACB->pLastDCB = pPrevDCB;
> -   }
> -
> -   DCBDEBUG(printk (KERN_INFO "DC390: Driver about to free DCB (ID %i, LUN %i): %p\n",\
> -	   pDCB->TargetID, pDCB->TargetLUN, pDCB));
> -   if (pDCB == pACB->pActiveDCB) pACB->pActiveDCB = 0;
> -   if (pDCB == pACB->pLinkDCB) pACB->pLinkDCB = pDCB->pNextDCB;
> -   if (pDCB == pACB->pDCBRunRobin) pACB->pDCBRunRobin = pDCB->pNextDCB;
> -   kfree (pDCB);
> -   pACB->DCBCnt--;
> -}
> -
> -
> static UCHAR __inline__
> dc390_tagq_blacklist (char* name)
> {
> --- 1.41/drivers/scsi/tmscsim.c	2004-06-19 01:02:20 +02:00
> +++ edited/drivers/scsi/tmscsim.c	2004-06-23 17:48:00 +02:00
> @@ -326,11 +326,9 @@
> static void __inline__ dc390_RequestSense( PACB pACB, PDCB pDCB, PSRB pSRB );
> static void __inline__ dc390_InvalidCmd( PACB pACB );
> static void __inline__ dc390_EnableMsgOut_Abort (PACB, PSRB);
> -static void dc390_remove_dev (PACB pACB, PDCB pDCB);
> static irqreturn_t do_DC390_Interrupt( int, void *, struct pt_regs *);
>
> static int    dc390_initAdapter( PSH psh, ULONG io_port, UCHAR Irq, UCHAR index );
> -static void   dc390_initDCB( PACB pACB, PDCB *ppDCB, UCHAR id, UCHAR lun);
> static void   dc390_updateDCB (PACB pACB, PDCB pDCB);
>
> static int DC390_proc_info (struct Scsi_Host *shpnt, char *buffer, char **start,
> @@ -1522,95 +1520,6 @@
>
> #include "scsiiom.c"
>
> -
> -/***********************************************************************
> - * Function : static void dc390_initDCB()
> - *
> - * Purpose :  initialize the internal structures for a DCB (to be malloced)
> - *
> - * Inputs : SCSI id and lun
> - ***********************************************************************/
> -
> -static void dc390_initDCB( PACB pACB, PDCB *ppDCB, UCHAR id, UCHAR lun )
> -{
> -    PEEprom	prom;
> -    UCHAR	index;
> -    PDCB	pDCB, pDCB2 = 0;
> -
> -    pDCB = kmalloc (sizeof(DC390_DCB), GFP_ATOMIC);
> -    DCBDEBUG(printk (KERN_INFO "DC390: alloc mem for DCB (ID %i, LUN %i): %p\n",	\
> -		     id, lun, pDCB));
> -
> -    *ppDCB = pDCB;
> -    if (!pDCB)
> -	return;
> -
> -    if( pACB->DCBCnt == 0 )
> -    {
> -	pACB->pLinkDCB = pDCB;
> -	pACB->pDCBRunRobin = pDCB;
> -    }
> -    else
> -    {
> -	pACB->pLastDCB->pNextDCB = pDCB;
> -    }
> -
> -    pACB->DCBCnt++;
> -
> -    pDCB->pNextDCB = pACB->pLinkDCB;
> -    pACB->pLastDCB = pDCB;
> -
> -    pDCB->pDCBACB = pACB;
> -    pDCB->TargetID = id;
> -    pDCB->TargetLUN = lun;
> -    pDCB->pWaitingSRB = NULL;
> -    pDCB->pGoingSRB = NULL;
> -    pDCB->GoingSRBCnt = 0;
> -    pDCB->WaitSRBCnt = 0;
> -    pDCB->pActiveSRB = NULL;
> -    pDCB->TagMask = 0;
> -    pDCB->MaxCommand = 1;
> -    index = pACB->AdapterIndex;
> -    pDCB->DCBFlag = 0;
> -
> -    /* Is there a corresp. LUN==0 device ? */
> -    if (lun != 0)
> -	pDCB2 = dc390_findDCB (pACB, id, 0);
> -    prom = (PEEprom) &dc390_eepromBuf[index][id << 2];
> -    /* Some values are for all LUNs: Copy them */
> -    /* In a clean way: We would have an own structure for a SCSI-ID */
> -    if (pDCB2)
> -    {
> -      pDCB->DevMode = pDCB2->DevMode;
> -      pDCB->SyncMode = pDCB2->SyncMode;
> -      pDCB->SyncPeriod = pDCB2->SyncPeriod;
> -      pDCB->SyncOffset = pDCB2->SyncOffset;
> -      pDCB->NegoPeriod = pDCB2->NegoPeriod;
> -
> -      pDCB->CtrlR3 = pDCB2->CtrlR3;
> -      pDCB->CtrlR4 = pDCB2->CtrlR4;
> -      pDCB->Inquiry7 = pDCB2->Inquiry7;
> -    }
> -    else
> -    {
> -      pDCB->DevMode = prom->EE_MODE1;
> -      pDCB->SyncMode = 0;
> -      pDCB->SyncPeriod = 0;
> -      pDCB->SyncOffset = 0;
> -      pDCB->NegoPeriod = (dc390_clock_period1[prom->EE_SPEED] * 25) >> 2;
> -
> -      pDCB->CtrlR3 = FAST_CLK;
> -
> -      pDCB->CtrlR4 = pACB->glitch_cfg | CTRL4_RESERVED;
> -      if( dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION)
> -	pDCB->CtrlR4 |= NEGATE_REQACKDATA | NEGATE_REQACK;
> -      pDCB->Inquiry7 = 0;
> -    }
> -
> -    pACB->DCBmap[id] |= (1 << lun);
> -    dc390_updateDCB(pACB, pDCB);
> -}
> -
> /***********************************************************************
>  * Function : static void dc390_updateDCB()
>  *
> @@ -1839,15 +1748,64 @@
>  */
> static int dc390_slave_alloc(struct scsi_device *scsi_device)
> {
> -	PDCB pDCB;
> 	PACB pACB = (PACB) scsi_device->host->hostdata;
> -	dc390_initDCB(pACB, &pDCB, scsi_device->id, scsi_device->lun);
> -	if (pDCB != NULL) {
> -		scsi_device->hostdata = pDCB;
> -		pACB->scan_devices = 1;
> -		return 0;
> +	PDCB pDCB, pDCB2 = 0;
> +	uint id = scsi_device->id;
> +	uint lun = scsi_device->lun;
> +
> +	pDCB = kmalloc(sizeof(DC390_DCB), GFP_KERNEL);
> +	if (!pDCB)
> +		return -ENOMEM;
> +	memset(pDCB, 0, sizeof(DC390_DCB));
> +
> +	if (!pACB->DCBCnt++) {
> +		pACB->pLinkDCB = pDCB;
> +		pACB->pDCBRunRobin = pDCB;
> +	} else {
> +		pACB->pLastDCB->pNextDCB = pDCB;
> +	}
> +
> +	pDCB->pNextDCB = pACB->pLinkDCB;
> +	pACB->pLastDCB = pDCB;
> +
> +	pDCB->pDCBACB = pACB;
> +	pDCB->TargetID = id;
> +	pDCB->TargetLUN = lun;
> +	pDCB->MaxCommand = 1;
> +
> +	/*
> +	 * Some values are for all LUNs: Copy them
> +	 * In a clean way: We would have an own structure for a SCSI-ID
> +	 */
> +	if (lun && (pDCB2 = dc390_findDCB(pACB, id, 0))) {
> +		pDCB->DevMode = pDCB2->DevMode;
> +		pDCB->SyncMode = pDCB2->SyncMode;
> +		pDCB->SyncPeriod = pDCB2->SyncPeriod;
> +		pDCB->SyncOffset = pDCB2->SyncOffset;
> +		pDCB->NegoPeriod = pDCB2->NegoPeriod;
> +
> +		pDCB->CtrlR3 = pDCB2->CtrlR3;
> +		pDCB->CtrlR4 = pDCB2->CtrlR4;
> +		pDCB->Inquiry7 = pDCB2->Inquiry7;
> +	} else {
> +		u8 index = pACB->AdapterIndex;
> +		PEEprom prom = (PEEprom) &dc390_eepromBuf[index][id << 2];
> +
> +		pDCB->DevMode = prom->EE_MODE1;
> +		pDCB->NegoPeriod =
> +			(dc390_clock_period1[prom->EE_SPEED] * 25) >> 2;
> +		pDCB->CtrlR3 = FAST_CLK;
> +		pDCB->CtrlR4 = pACB->glitch_cfg | CTRL4_RESERVED;
> +		if (dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION)
> +			pDCB->CtrlR4 |= NEGATE_REQACKDATA | NEGATE_REQACK;
> 	}
> -	return -ENOMEM;
> +
> +	pACB->DCBmap[id] |= (1 << lun);
> +	dc390_updateDCB(pACB, pDCB);
> +
> +	pACB->scan_devices = 1;
> +	scsi_device->hostdata = pDCB;
> +	return 0;
> }
>
> /**
> @@ -1860,11 +1818,37 @@
> {
> 	PACB pACB = (PACB) scsi_device->host->hostdata;
> 	PDCB pDCB = (PDCB) scsi_device->hostdata;
> +	PDCB pPrevDCB = pACB->pLinkDCB;
> +
> 	pACB->scan_devices = 0;
> -	if (pDCB != NULL)
> -		dc390_remove_dev(pACB, pDCB);
> -	else
> -		printk(KERN_ERR"%s() called for non-existing device!\n", __FUNCTION__);
> +
> +	BUG_ON(pDCB->GoingSRBCnt > 1);
> +
> +	pACB->DCBmap[pDCB->TargetID] &= ~(1 << pDCB->TargetLUN);
> +
> +	if (pDCB == pACB->pLinkDCB) {
> +		if (pACB->pLastDCB == pDCB) {
> +			pDCB->pNextDCB = NULL;
> +			pACB->pLastDCB = NULL;
> +		}
> +		pACB->pLinkDCB = pDCB->pNextDCB;
> +	} else {
> +		while (pPrevDCB->pNextDCB != pDCB)
> +			pPrevDCB = pPrevDCB->pNextDCB;
> +		pPrevDCB->pNextDCB = pDCB->pNextDCB;
> +		if (pDCB == pACB->pLastDCB)
> +			pACB->pLastDCB = pPrevDCB;
> +	}
> +
> +	if (pDCB == pACB->pActiveDCB)
> +		pACB->pActiveDCB = NULL;
> +	if (pDCB == pACB->pLinkDCB)
> +		pACB->pLinkDCB = pDCB->pNextDCB;
> +	if (pDCB == pACB->pDCBRunRobin)
> +		pACB->pDCBRunRobin = pDCB->pNextDCB;
> +	kfree(pDCB);
> +
> +	pACB->DCBCnt--;
> }
>
> static int dc390_slave_configure(struct scsi_device *scsi_device)
> @@ -1966,52 +1950,6 @@
> 	return ret;
> }
>
> -static void __devexit dc390_freeDCBs (struct Scsi_Host *host)
> -{
> -    PDCB pDCB, nDCB;
> -    PACB pACB = (PACB) host->hostdata;
> -
> -    pDCB = pACB->pLinkDCB;
> -    if (!pDCB) return;
> -    do
> -    {
> -	nDCB = pDCB->pNextDCB;
> -	DCBDEBUG(printk (KERN_INFO "DC390: Free DCB (ID %i, LUN %i): %p\n",\
> -			 pDCB->TargetID, pDCB->TargetLUN, pDCB));
> -	//kfree (pDCB);
> -	dc390_remove_dev (pACB, pDCB);
> -	pDCB = nDCB;
> -    } while (pDCB && pACB->pLinkDCB);
> -}
> -
> -/***********************************************************************
> - * Function : static int dc390_shutdown (struct Scsi_Host *host)
> - *
> - * Purpose : does a clean (we hope) shutdown of the SCSI chip.
> - *	     Use prior to dumping core, unloading the driver, etc.
> - *
> - * Returns : 0 on success
> - ***********************************************************************/
> -static int __devexit dc390_shutdown (struct Scsi_Host *host)
> -{
> -    UCHAR    bval;
> -    PACB pACB = (PACB) host->hostdata;
> -
> -/*  pACB->soft_reset(host); */
> -
> -    printk(KERN_INFO "DC390: shutdown\n");
> -
> -    pACB->ACBFlag = RESET_DEV;
> -    bval = DC390_read8 (CtrlReg1);
> -    bval |= DIS_INT_ON_SCSI_RST;
> -    DC390_write8 (CtrlReg1, bval);	/* disable interrupt */
> -    if (pACB->Gmode2 & RST_SCSI_BUS)
> -		dc390_ResetSCSIBus (pACB);
> -
> -    if (timer_pending (&pACB->Waiting_Timer)) del_timer (&pACB->Waiting_Timer);
> -    return( 0 );
> -}
> -
> /**
>  * dc390_remove_one - Called to remove a single instance of the adapter.
>  *
> @@ -2022,22 +1960,22 @@
> 	struct Scsi_Host *scsi_host = pci_get_drvdata(dev);
> 	unsigned long iflags;
> 	PACB pACB = (PACB) scsi_host->hostdata;
> +	u8 bval;
>
> 	scsi_remove_host(scsi_host);
>
> 	spin_lock_irqsave(scsi_host->host_lock, iflags);
> +	pACB->ACBFlag = RESET_DEV;
> +	bval = DC390_read8(CtrlReg1) | DIS_INT_ON_SCSI_RST;
> +	DC390_write8 (CtrlReg1, bval);	/* disable interrupt */
> +	if (pACB->Gmode2 & RST_SCSI_BUS)
> +		dc390_ResetSCSIBus(pACB);
> +	spin_unlock_irqrestore(scsi_host->host_lock, iflags);
>
> -	/* TO DO: We should check for outstanding commands first. */
> -	dc390_shutdown(scsi_host);
> -
> -	if (scsi_host->irq != SCSI_IRQ_NONE) {
> -		DEBUG0(printk(KERN_INFO "DC390: Free IRQ %i\n", scsi_host->irq));
> -		free_irq(scsi_host->irq, pACB);
> -	}
> +	del_timer_sync(&pACB->Waiting_Timer);
>
> +	free_irq(scsi_host->irq, pACB);
> 	release_region(scsi_host->io_port, scsi_host->n_io_port);
> -	dc390_freeDCBs(scsi_host);
> -	spin_unlock_irqrestore(scsi_host->host_lock, iflags);
>
> 	pci_disable_device(dev);
> 	scsi_host_put(scsi_host);
>
>

---
Guennadi Liakhovetski

