From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 21/23] scsi_dh_alua: update all port states
Date: Tue, 22 Sep 2015 16:04:06 -0400
Message-ID: <1442952246.4132.75.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-22-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934302AbbIVUEI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 16:04:08 -0400
In-Reply-To: <1440679281-13234-22-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> When we read in the target port group state we should be
> updating all affected port groups, otherwise we risk
> running out of sync.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 8717fd3..2fa985e 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -477,11 +477,13 @@ static int alua_check_sense(struct scsi_device *sdev,
>  static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  {
>  	struct scsi_sense_hdr sense_hdr;
> +	struct alua_port_group *tmp_pg;
>  	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
>  	unsigned char *ucp, *buff;
>  	unsigned err, retval;
>  	unsigned int tpg_desc_tbl_off;
>  	unsigned char orig_transition_tmo;
> +	unsigned long flags;
>  
>  	if (!pg->expiry) {
>  		if (!pg->transition_tmo)
> @@ -584,17 +586,28 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  	else
>  		tpg_desc_tbl_off = 4;
>  
> +	spin_lock_irqsave(&port_group_lock, flags);
>  	for (k = tpg_desc_tbl_off, ucp = buff + tpg_desc_tbl_off;
>  	     k < len;
>  	     k += off, ucp += off) {

"ucp" is not really a good variable name, it matches nothing in the T10
spec.  The structure is a "Target Port Group Descriptor".  I realize it
was already there, but maybe this is a good opportunity to change it?

>  
> -		if (pg->group_id == get_unaligned_be16(&ucp[2])) {
> -			pg->state = ucp[0] & 0x0f;
> -			pg->pref = ucp[0] >> 7;
> -			valid_states = ucp[1];
> +		list_for_each_entry(tmp_pg, &port_group_list, node) {
> +			u16 group_id = get_unaligned_be16(&ucp[2]);

This is invariant and should be outside the loop.

> +			if (tmp_pg->group_id != group_id)
> +				continue;
> +			if (tmp_pg->device_id_size != pg->device_id_size)
> +				continue;
> +			if (strncmp(tmp_pg->device_id_str, pg->device_id_str,
> +				    tmp_pg->device_id_size))
> +				continue;
> +			tmp_pg->state = ucp[0] & 0x0f;
> +			tmp_pg->pref = ucp[0] >> 7;
> +			if (tmp_pg == pg)
> +				valid_states = ucp[1];
>  		}
>  		off = 8 + (ucp[7] * 4);
>  	}
> +	spin_unlock_irqrestore(&port_group_lock, flags);
>  
>  	sdev_printk(KERN_INFO, sdev,
>  		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


