From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 09/23] scsi_dh_alua: use unaligned access macros
Date: Tue, 22 Sep 2015 14:37:56 -0400
Message-ID: <1442947076.4132.11.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-10-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933783AbbIVSh5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 14:37:57 -0400
In-Reply-To: <1440679281-13234-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> Use 'get_unaligned_XX' and 'put_unaligned_XX' instead of
> open-coding it.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 9d8fc53..0636721 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -22,6 +22,7 @@
>  #include <linux/slab.h>
>  #include <linux/delay.h>
>  #include <linux/module.h>
> +#include <asm/unaligned.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_eh.h>
> @@ -153,10 +154,7 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
>  		rq->cmd[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
>  	else
>  		rq->cmd[1] = MI_REPORT_TARGET_PGS;
> -	rq->cmd[6] = (h->bufflen >> 24) & 0xff;
> -	rq->cmd[7] = (h->bufflen >> 16) & 0xff;
> -	rq->cmd[8] = (h->bufflen >>  8) & 0xff;
> -	rq->cmd[9] = h->bufflen & 0xff;
> +	put_unaligned_be32(h->bufflen, &rq->cmd[6]);
>  	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_IN);
>  
>  	rq->sense = h->sense;
> @@ -239,8 +237,7 @@ static unsigned submit_stpg(struct alua_dh_data *h)
>  	/* Prepare the data buffer */
>  	memset(h->buff, 0, stpg_len);
>  	h->buff[4] = TPGS_STATE_OPTIMIZED & 0x0f;
> -	h->buff[6] = (h->group_id >> 8) & 0xff;
> -	h->buff[7] = h->group_id & 0xff;
> +	put_unaligned_be16(h->group_id, &h->buff[6]);
>  
>  	rq = get_alua_req(sdev, h->buff, stpg_len, WRITE);
>  	if (!rq)
> @@ -249,10 +246,7 @@ static unsigned submit_stpg(struct alua_dh_data *h)
>  	/* Prepare the command. */
>  	rq->cmd[0] = MAINTENANCE_OUT;
>  	rq->cmd[1] = MO_SET_TARGET_PGS;
> -	rq->cmd[6] = (stpg_len >> 24) & 0xff;
> -	rq->cmd[7] = (stpg_len >> 16) & 0xff;
> -	rq->cmd[8] = (stpg_len >>  8) & 0xff;
> -	rq->cmd[9] = stpg_len & 0xff;
> +	put_unaligned_be32(stpg_len, &rq->cmd[6]);
>  	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_OUT);
>  
>  	rq->sense = h->sense;
> @@ -341,11 +335,11 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  		switch (d[1] & 0xf) {
>  		case 0x4:
>  			/* Relative target port */
> -			h->rel_port = (d[6] << 8) + d[7];
> +			h->rel_port = get_unaligned_be16(&d[6]);
>  			break;
>  		case 0x5:
>  			/* Target port group */
> -			h->group_id = (d[6] << 8) + d[7];
> +			h->group_id = get_unaligned_be16(&d[6]);
>  			break;
>  		default:
>  			break;
> @@ -540,8 +534,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  		return SCSI_DH_IO;
>  	}
>  
> -	len = (h->buff[0] << 24) + (h->buff[1] << 16) +
> -		(h->buff[2] << 8) + h->buff[3] + 4;
> +	len = get_unaligned_be32(&h->buff[0]) + 4;
>  
>  	if (len > h->bufflen) {
>  		/* Resubmit with the correct length */
> @@ -576,7 +569,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  	     k < len;
>  	     k += off, ucp += off) {
>  
> -		if (h->group_id == (ucp[2] << 8) + ucp[3]) {
> +		if (h->group_id == get_unaligned_be16(&ucp[2])) {
>  			h->state = ucp[0] & 0x0f;
>  			h->pref = ucp[0] >> 7;
>  			valid_states = ucp[1];

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


