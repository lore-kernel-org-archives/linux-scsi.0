From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Further clean-up of tmscsim driver
Date: Thu, 5 Jul 2007 00:54:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0707050048250.5952@poirot.grange>
References: <468BE48F.7070106@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40766 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753503AbXGDWyW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jul 2007 18:54:22 -0400
In-Reply-To: <468BE48F.7070106@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 4 Jul 2007, Boaz Harrosh wrote:

> 
>  - The saved sg_count was a leftover from the time the driver was doing
>    dma mapping by himself. But now that scsi-ml is called for the mapping
>    it is not the drivers responsibility.
> 
>  Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>

> ---
>  drivers/scsi/tmscsim.c |    3 ---
>  drivers/scsi/tmscsim.h |    1 -
>  2 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index e8260f2..14cba1c 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -1681,7 +1681,6 @@ dc390_RequestSense(struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_
>  			      pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));
> 
>  	pSRB->SRBFlag |= AUTO_REQSENSE;
> -	pSRB->SavedSGCount = scsi_sg_count(pcmd);
>  	pSRB->SavedTotXLen = pSRB->TotalXferredLen;
>  	pSRB->AdaptStatus = 0;
>  	pSRB->TargetStatus = 0; /* CHECK_CONDITION<<1; */
> @@ -1729,7 +1728,6 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
>  		       (u32) pcmd->result, (u32) pSRB->TotalXferredLen));
>  	    } else {
>  		SET_RES_DRV(pcmd->result, DRIVER_SENSE);
> -		scsi_sg_count(pcmd) = pSRB->SavedSGCount;
>  		//pSRB->ScsiCmdLen	 = (u8) (pSRB->Segment1[0] >> 8);
>  		DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
>  		pSRB->TotalXferredLen = 0;
> @@ -1751,7 +1749,6 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
>  	else if (status == SAM_STAT_TASK_SET_FULL)
>  	{
>  	    scsi_track_queue_full(pcmd->device, pDCB->GoingSRBCnt - 1);
> -	    scsi_sg_count(pcmd) = pSRB->SavedSGCount;
>  	    DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
>  	    pSRB->TotalXferredLen = 0;
>  	    SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
> diff --git a/drivers/scsi/tmscsim.h b/drivers/scsi/tmscsim.h
> index c74c72a..77adc54 100644
> --- a/drivers/scsi/tmscsim.h
> +++ b/drivers/scsi/tmscsim.h
> @@ -57,7 +57,6 @@ u8		SGcount;
> 
>  u8		MsgCnt;
>  u8		EndMessage;
> -u8		SavedSGCount;			
> 
>  u8		MsgInBuf[6];
>  u8		MsgOutBuf[6];
> -- 
> 1.5.2.2.249.g45fd
> 

---
Guennadi Liakhovetski
