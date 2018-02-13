From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Reduce number of scsi_test_unit_ready() retries
Date: Tue, 13 Feb 2018 10:26:24 +0100
Message-ID: <d1ef6c60-da61-708b-7d4e-39f43ba9a474@suse.de>
References: <20180212185752.28093-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48888 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933867AbeBMJ00 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Feb 2018 04:26:26 -0500
In-Reply-To: <20180212185752.28093-1-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On 02/12/2018 07:57 PM, Bart Van Assche wrote:
> Make scsi_test_unit_ready() send at most as many TURs as specified
> in the 'retries' argument instead of retries * (retries + 1) / 2.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b03cb2d5b733..9c793090dbf1 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2607,7 +2607,7 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
>  	/* try to eat the UNIT_ATTENTION if there are enough retries */
>  	do {
>  		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
> -					  timeout, retries, NULL);
> +					  timeout, 1, NULL);
>  		if (sdev->removable && scsi_sense_valid(sshdr) &&
>  		    sshdr->sense_key == UNIT_ATTENTION)
>  			sdev->changed = 1;
> 
At one point we _really_ need to clean up BLOCK_PC command handling.
This 'some parts are handled by the core, some parts need to be
evaluated by the caller' magic is driving my nuts :-(
Anyway.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
