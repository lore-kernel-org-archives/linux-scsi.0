From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 2/4] fusion: remove iopriority handling
Date: Fri, 14 Oct 2016 07:55:09 +0200
Message-ID: <749dbbbb-fe5a-2e75-a672-3d6ea2bdbff8@suse.de>
References: <1476388433-2539-1-git-send-email-adam.manzanares@hgst.com>
 <1476388433-2539-3-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60171 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756560AbcJNFzM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 01:55:12 -0400
In-Reply-To: <1476388433-2539-3-git-send-email-adam.manzanares@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Manzanares <adam.manzanares@hgst.com>, axboe@kernel.dk, tj@kernel.org, dan.j.williams@intel.com, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Adam Manzanares <adam.manzanares@wdc.com>

On 10/13/2016 09:53 PM, Adam Manzanares wrote:
> The request priority is now by default coming from the ioc. It was not
> clear what this code was trying to do based upon the iopriority class or
> data. The driver should check that a device supports priorities and use
> them according to the specificiations of ioprio.
> 
> Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
> ---
>  drivers/message/fusion/mptscsih.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 6c9fc11..4740bb6 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1369,11 +1369,6 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt)
>  	if ((vdevice->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
>  	    && (SCpnt->device->tagged_supported)) {
>  		scsictl = scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;
> -		if (SCpnt->request && SCpnt->request->ioprio) {
> -			if (((SCpnt->request->ioprio & 0x7) == 1) ||
> -				!(SCpnt->request->ioprio & 0x7))
> -				scsictl |= MPI_SCSIIO_CONTROL_HEADOFQ;
> -		}
>  	} else
>  		scsictl = scsidir | MPI_SCSIIO_CONTROL_UNTAGGED;
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
