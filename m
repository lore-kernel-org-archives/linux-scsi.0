From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] merge scsiiom.c into tmscsim.c
Date: Sun, 17 Jun 2007 19:25:13 +0300
Message-ID: <46756069.5010607@panasas.com>
References: <20041003134714.GA1623@lst.de> <Pine.LNX.4.60.0706171651350.9578@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:50702 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752093AbXFQQZV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jun 2007 12:25:21 -0400
In-Reply-To: <Pine.LNX.4.60.0706171651350.9578@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Guennadi Liakhovetski wrote:
> Hi Christoph,
> 
> On Sun, 3 Oct 2004, Christoph Hellwig wrote:
> 
>> might be a good time to get rid of that clumsy include .c file into
>> another one thing.  (Also please bk rm scsiiom.c afterwards)
> 
> You certainly will have no problem at all remembering this patch, will 
> you?:-) It's only less than 3 years ago... Sure, you'll also have no 
> problem answering a couple of my simple questions to this patch... 
> Specifically, this place in it:
> 
>> --- 1.56/drivers/scsi/tmscsim.c	2004-10-03 15:43:04 +02:00
>> +++ edited/drivers/scsi/tmscsim.c	2004-10-03 15:48:31 +02:00
>> @@ -252,7 +252,7 @@
> 
> [snip]
> 
>> +static int __inline__
>> +dc390_RequestSense(struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
>> +{
>> +	struct scsi_cmnd *pcmd;
>> +
>> +	pcmd = pSRB->pcmd;
>> +
>> +	REMOVABLEDEBUG(printk(KERN_INFO "DC390: RequestSense(Cmd %02x, Id %02x, LUN %02x)\n",\
>> +			      pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));
>> +
>> +	pSRB->SRBFlag |= AUTO_REQSENSE;
>> +	pSRB->SavedSGCount = pcmd->use_sg;
>> +	pSRB->SavedTotXLen = pSRB->TotalXferredLen;
>> +	pSRB->AdaptStatus = 0;
>> +	pSRB->TargetStatus = 0; /* CHECK_CONDITION<<1; */
>> +
>> +	/* We are called from SRBdone, original PCI mapping has been removed
>> +	 * already, new one is set up from StartSCSI */
>> +	pSRB->SGIndex = 0;
>> +
>> +	pSRB->TotalXferredLen = 0;
>> +	pSRB->SGToBeXferLen = 0;
>> +	return dc390_StartSCSI(pACB, pDCB, pSRB);
>> +}
>> +
>> +
>> +static void
>> +dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB )
>> +{
>> +    u8  bval, status;
>> +    struct scsi_cmnd *pcmd;
>> +
>> +    pcmd = pSRB->pcmd;
>> +    /* KG: Moved pci_unmap here */
>> +    dc390_pci_unmap(pSRB);
>> +
>> +    status = pSRB->TargetStatus;
>> +
>> +    DEBUG0(printk (" SRBdone (%02x,%08x), SRB %p, pid %li\n", status, pcmd->result,\
>> +		pSRB, pcmd->pid));
>> +    if(pSRB->SRBFlag & AUTO_REQSENSE)
>> +    {	/* Last command was a Request Sense */
> 
> Here we come in after Request Sense above.
> 
>> +	pSRB->SRBFlag &= ~AUTO_REQSENSE;
>> +	pSRB->AdaptStatus = 0;
>> +	pSRB->TargetStatus = CHECK_CONDITION << 1;
>> +
>> +	//pcmd->result = MK_RES(DRIVER_SENSE,DID_OK,0,status);
>> +	if (status == (CHECK_CONDITION << 1))
>> +	    pcmd->result = MK_RES_LNX(0, DID_BAD_TARGET, 0, /*CHECK_CONDITION*/0);
>> +	else /* Retry */
>> +	{
>> +	    if( pSRB->pcmd->cmnd[0] == TEST_UNIT_READY /* || pSRB->pcmd->cmnd[0] == START_STOP */)
>> +	    {
>> +		/* Don't retry on TEST_UNIT_READY */
>> +		pcmd->result = MK_RES_LNX(DRIVER_SENSE,DID_OK,0,CHECK_CONDITION);
>> +		REMOVABLEDEBUG(printk(KERN_INFO "Cmd=%02x, Result=%08x, XferL=%08x\n",pSRB->pcmd->cmnd[0],\
>> +		       (u32) pcmd->result, (u32) pSRB->TotalXferredLen));
>> +	    } else {
>> +		SET_RES_DRV(pcmd->result, DRIVER_SENSE);
>> +		pcmd->use_sg = pSRB->SavedSGCount;
>> +		//pSRB->ScsiCmdLen	 = (u8) (pSRB->Segment1[0] >> 8);
>> +		DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
>> +		pSRB->TotalXferredLen = 0;
>> +		SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
>> +	    }
>> +	}
>> +	goto cmd_done;
> 
> And here we jump out.
> 
>> +    }
>> +    if( status )
>> +    {
> 
> Therefore here we come only if we didn't request sense before.
> 
>> +	if( status_byte(status) == CHECK_CONDITION )
>> +	{
>> +	    if (dc390_RequestSense(pACB, pDCB, pSRB)) {
>> +		SET_RES_DID(pcmd->result, DID_ERROR);
>> +		goto cmd_done;
>> +	    }
>> +	    return;
>> +	}
>> +	else if( status_byte(status) == QUEUE_FULL )
>> +	{
>> +	    bval = (u8) pDCB->GoingSRBCnt;
>> +	    bval--;
>> +	    pDCB->MaxCommand = bval;
>> +	    pcmd->use_sg = pSRB->SavedSGCount;
> 
> Now, this I don't understand. If we didn't request sense, SavedSGCount is 
> not defined, is it?...
> 
> Thanks and sorry for taking you on a time-travel
> Guennadi
> ---
> Guennadi Liakhovetski
> -
Hi Guennadi.

I think the all thing is no longer relevant. It is leftovers from the time
scsi_error.c specifically scsi_send_eh_cmnd (used by scsi_request_sense) was
stepping all over the scsi_cmnd fields and things needed to be saved, if they
were needed for a retry. But now (since a later cleanup made by Christoph)
scsi_send_eh_cmnd() does not do that any more. In any way pcmd->use_sg is
never touched anywhere in the code and any code called from this driver.
So why save it?

Or am I missing some bigger picture Here?

Boaz

