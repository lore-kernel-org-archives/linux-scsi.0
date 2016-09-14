From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 26/29] be2iscsi: Fix queue and connection parameters
Date: Wed, 14 Sep 2016 15:26:51 +0200
Message-ID: <6af0d324-47ef-ce23-f0f4-ecf1b1b4b9c7@suse.de>
References: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1471600226-22055-27-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59397 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753254AbcINN0z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Sep 2016 09:26:55 -0400
In-Reply-To: <1471600226-22055-27-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com

On 08/19/2016 11:50 AM, Jitendra Bhivare wrote:
> Current EQ delay is set to 0 to receive very high max interrupt per sec.
> Set EQ delay to 32 - reducing max interrupt rate from 65K to 20K per sec.
> 
> Set TCP connection window size to 64K with scale shift count 2.
> 
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 2 +-
>  drivers/scsi/be2iscsi/be_mgmt.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 50d865e..7c372b8 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -3729,7 +3729,7 @@ static int hwi_init_port(struct beiscsi_hba *phba)
>  	phwi_context = phwi_ctrlr->phwi_ctxt;
>  	phwi_context->max_eqd = 128;
>  	phwi_context->min_eqd = 0;
> -	phwi_context->cur_eqd = 0;
> +	phwi_context->cur_eqd = 32;
>  	/* set port optic state to unknown */
>  	phba->optic_state = 0xff;
>  
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
> index 736eca3..adc827b 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -338,7 +338,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
>  
>  	if (!is_chip_be2_be3r(phba)) {
>  		req->hdr.version = MBX_CMD_VER1;
> -		req->tcp_window_size = 0;
> +		req->tcp_window_size = 0x8000;
>  		req->tcp_window_scale_count = 2;
>  	}
>  
> 
Wouldn't it make sense to allow modifications here, eg via a module
parameters? From the description this should help reducing the latency
if required, no?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
