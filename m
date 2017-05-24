From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 29/31] scsi: snic: Remove code that zeroes driver-private
 command data
Date: Wed, 24 May 2017 08:14:12 +0200
Message-ID: <cae81103-ea67-06c2-a7fb-32be3c8f5d82@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-30-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-30-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 05/24/2017 02:34 AM, Bart Van Assche wrote:
> Since the SCSI core zeroes driver-private command data, remove
> that code from the snic driver.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Narsimhulu Musini <nmusini@cisco.com>
> Cc: Sesidhar Baddela <sebaddel@cisco.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/snic/snic_scsi.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
> index da979a73baa0..05c3a7282d4a 100644
> --- a/drivers/scsi/snic/snic_scsi.c
> +++ b/drivers/scsi/snic/snic_scsi.c
> @@ -359,8 +359,6 @@ snic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
>  	SNIC_SCSI_DBG(shost, "sc %p Tag %d (sc %0x) lun %lld in snic_qcmd\n",
>  		      sc, snic_cmd_tag(sc), sc->cmnd[0], sc->device->lun);
>  
> -	memset(scsi_cmd_priv(sc), 0, sizeof(struct snic_internal_io_state));
> -
>  	ret = snic_issue_scsi_req(snic, tgt, sc);
>  	if (ret) {
>  		SNIC_HOST_ERR(shost, "Failed to Q, Scsi Req w/ err %d.\n", ret);
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
