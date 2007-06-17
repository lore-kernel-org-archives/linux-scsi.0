From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] merge scsiiom.c into tmscsim.c
Date: Sun, 17 Jun 2007 17:09:23 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0706171651350.9578@poirot.grange>
References: <20041003134714.GA1623@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44421 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751142AbXFQPJW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Jun 2007 11:09:22 -0400
In-Reply-To: <20041003134714.GA1623@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Hi Christoph,

On Sun, 3 Oct 2004, Christoph Hellwig wrote:

> might be a good time to get rid of that clumsy include .c file into
> another one thing.  (Also please bk rm scsiiom.c afterwards)

You certainly will have no problem at all remembering this patch, will 
you?:-) It's only less than 3 years ago... Sure, you'll also have no 
problem answering a couple of my simple questions to this patch... 
Specifically, this place in it:

> --- 1.56/drivers/scsi/tmscsim.c	2004-10-03 15:43:04 +02:00
> +++ edited/drivers/scsi/tmscsim.c	2004-10-03 15:48:31 +02:00
> @@ -252,7 +252,7 @@

[snip]

> +static int __inline__
> +dc390_RequestSense(struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
> +{
> +	struct scsi_cmnd *pcmd;
> +
> +	pcmd = pSRB->pcmd;
> +
> +	REMOVABLEDEBUG(printk(KERN_INFO "DC390: RequestSense(Cmd %02x, Id %02x, LUN %02x)\n",\
> +			      pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));
> +
> +	pSRB->SRBFlag |= AUTO_REQSENSE;
> +	pSRB->SavedSGCount = pcmd->use_sg;
> +	pSRB->SavedTotXLen = pSRB->TotalXferredLen;
> +	pSRB->AdaptStatus = 0;
> +	pSRB->TargetStatus = 0; /* CHECK_CONDITION<<1; */
> +
> +	/* We are called from SRBdone, original PCI mapping has been removed
> +	 * already, new one is set up from StartSCSI */
> +	pSRB->SGIndex = 0;
> +
> +	pSRB->TotalXferredLen = 0;
> +	pSRB->SGToBeXferLen = 0;
> +	return dc390_StartSCSI(pACB, pDCB, pSRB);
> +}
> +
> +
> +static void
> +dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB )
> +{
> +    u8  bval, status;
> +    struct scsi_cmnd *pcmd;
> +
> +    pcmd = pSRB->pcmd;
> +    /* KG: Moved pci_unmap here */
> +    dc390_pci_unmap(pSRB);
> +
> +    status = pSRB->TargetStatus;
> +
> +    DEBUG0(printk (" SRBdone (%02x,%08x), SRB %p, pid %li\n", status, pcmd->result,\
> +		pSRB, pcmd->pid));
> +    if(pSRB->SRBFlag & AUTO_REQSENSE)
> +    {	/* Last command was a Request Sense */

Here we come in after Request Sense above.

> +	pSRB->SRBFlag &= ~AUTO_REQSENSE;
> +	pSRB->AdaptStatus = 0;
> +	pSRB->TargetStatus = CHECK_CONDITION << 1;
> +
> +	//pcmd->result = MK_RES(DRIVER_SENSE,DID_OK,0,status);
> +	if (status == (CHECK_CONDITION << 1))
> +	    pcmd->result = MK_RES_LNX(0, DID_BAD_TARGET, 0, /*CHECK_CONDITION*/0);
> +	else /* Retry */
> +	{
> +	    if( pSRB->pcmd->cmnd[0] == TEST_UNIT_READY /* || pSRB->pcmd->cmnd[0] == START_STOP */)
> +	    {
> +		/* Don't retry on TEST_UNIT_READY */
> +		pcmd->result = MK_RES_LNX(DRIVER_SENSE,DID_OK,0,CHECK_CONDITION);
> +		REMOVABLEDEBUG(printk(KERN_INFO "Cmd=%02x, Result=%08x, XferL=%08x\n",pSRB->pcmd->cmnd[0],\
> +		       (u32) pcmd->result, (u32) pSRB->TotalXferredLen));
> +	    } else {
> +		SET_RES_DRV(pcmd->result, DRIVER_SENSE);
> +		pcmd->use_sg = pSRB->SavedSGCount;
> +		//pSRB->ScsiCmdLen	 = (u8) (pSRB->Segment1[0] >> 8);
> +		DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
> +		pSRB->TotalXferredLen = 0;
> +		SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
> +	    }
> +	}
> +	goto cmd_done;

And here we jump out.

> +    }
> +    if( status )
> +    {

Therefore here we come only if we didn't request sense before.

> +	if( status_byte(status) == CHECK_CONDITION )
> +	{
> +	    if (dc390_RequestSense(pACB, pDCB, pSRB)) {
> +		SET_RES_DID(pcmd->result, DID_ERROR);
> +		goto cmd_done;
> +	    }
> +	    return;
> +	}
> +	else if( status_byte(status) == QUEUE_FULL )
> +	{
> +	    bval = (u8) pDCB->GoingSRBCnt;
> +	    bval--;
> +	    pDCB->MaxCommand = bval;
> +	    pcmd->use_sg = pSRB->SavedSGCount;

Now, this I don't understand. If we didn't request sense, SavedSGCount is 
not defined, is it?...

Thanks and sorry for taking you on a time-travel
Guennadi
---
Guennadi Liakhovetski
