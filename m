From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] mptscsih: remove bogus interpretation of request->ioprio
Date: Thu, 13 Oct 2016 10:53:15 +0200
Message-ID: <235e99f6-12fb-f2ac-0a85-7680a39916d1@suse.de>
References: <1476348401-22724-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43075 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752777AbcJMIyo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 04:54:44 -0400
In-Reply-To: <1476348401-22724-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 10/13/2016 10:46 AM, Christoph Hellwig wrote:
> Having an I/O priority does not mean we should send all requests as
> HEAD OF QUEUE tags.
> 
> Reported-by: Adam Manzanares <adam.manzanares@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/message/fusion/mptscsih.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 6c9fc11..08a807d 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1366,15 +1366,10 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt)
>  	/* Default to untagged. Once a target structure has been allocated,
>  	 * use the Inquiry data to determine if device supports tagged.
>  	 */
> -	if ((vdevice->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
> -	    && (SCpnt->device->tagged_supported)) {
> +	if ((vdevice->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES) &&
> +	    SCpnt->device->tagged_supported)
>  		scsictl = scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;
> -		if (SCpnt->request && SCpnt->request->ioprio) {
> -			if (((SCpnt->request->ioprio & 0x7) == 1) ||
> -				!(SCpnt->request->ioprio & 0x7))
> -				scsictl |= MPI_SCSIIO_CONTROL_HEADOFQ;
> -		}
> -	} else
> +	else
>  		scsictl = scsidir | MPI_SCSIIO_CONTROL_UNTAGGED;
>  
>  
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
