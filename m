From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 17/23] scsi_dh_alua: use unique device id
Date: Tue, 22 Sep 2015 15:31:47 -0400
Message-ID: <1442950307.4132.53.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-18-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758275AbbIVTbs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 15:31:48 -0400
In-Reply-To: <1440679281-13234-18-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> Use scsi_vpd_lun_id() to assign a unique device identification
> to the alua port group structure.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 70 +++++++++++++++++++++++++++---
>  1 file changed, 65 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index dbe9ff2..c2b2100b 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -70,6 +70,8 @@ static DEFINE_SPINLOCK(port_group_lock);
>  struct alua_port_group {
>  	struct kref		kref;
>  	struct list_head	node;
> +	unsigned char		device_id_str[256];
> +	int			device_id_size;

I prefer _len instead of _size, _size should refer to the size of the buffer,
not the current length of the data in it.

>  	int			group_id;
>  	int			tpgs;
>  	int			state;
> @@ -229,7 +231,9 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  {
>  	unsigned char *d;
>  	int group_id = -1;
> -	struct alua_port_group *pg = NULL;
> +	char device_id_str[256];
> +	int device_id_size;
> +	struct alua_port_group *tmp_pg, *pg = NULL;
>  
>  	if (!sdev->vpd_pg83)
>  		return SCSI_DH_DEV_UNSUPP;
> @@ -266,9 +270,39 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  		h->tpgs = TPGS_MODE_NONE;
>  		return SCSI_DH_DEV_UNSUPP;
>  	}
> +	device_id_size = scsi_vpd_lun_id(sdev, device_id_str, 256);

should be sizeof(device_id_str) not hardcoded 256

> +	if (device_id_size <= 0) {
> +		/*
> +		 * Internal error: TPGS supported by no

"Internal error: TPGS supported by no"  should be "but no"

> +		 * device identifcation found.
> +		 * Disable ALUA support.
> +		 */
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: No device descriptors found\n",
> +			    ALUA_DH_NAME);
> +		h->tpgs = TPGS_MODE_NONE;
> +		return SCSI_DH_DEV_UNSUPP;
> +	}
>  	sdev_printk(KERN_INFO, sdev,
> -		    "%s: port group %02x rel port %02x\n",
> -		    ALUA_DH_NAME, group_id, h->rel_port);
> +		    "%s: device %s port group %02x "
> +		    "rel port %02x\n", ALUA_DH_NAME,
> +		    device_id_str, group_id, h->rel_port);
> +	spin_lock(&port_group_lock);
> +	list_for_each_entry(tmp_pg, &port_group_list, node) {
> +		if (tmp_pg->group_id != group_id)
> +			continue;
> +		if (tmp_pg->device_id_size != device_id_size)
> +			continue;
> +		if (strncmp(tmp_pg->device_id_str, device_id_str,
> +			    device_id_size))
> +			continue;
> +		h->pg = tmp_pg;
> +		kref_get(&tmp_pg->kref);
> +		break;
> +	}
> +	spin_unlock(&port_group_lock);
> +	if (h->pg)
> +		return SCSI_DH_OK;

The lookup checks whether h->pg == NULL but the function never
explicitly sets it to NULL before iterating.

>  
>  	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
>  	if (!pg) {
> @@ -278,13 +312,39 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  		/* Temporary failure, bypass */
>  		return SCSI_DH_DEV_TEMP_BUSY;
>  	}
> +	if (device_id_size)
> +		strncpy(pg->device_id_str, device_id_str, 256);

should be sizeof(device_id_str) not hardcoded 256

> +	else
> +		pg->device_id_str[0] = '\0';
> +
> +	pg->device_id_size = device_id_size;
>  	pg->group_id = group_id;
>  	pg->tpgs = h->tpgs;
>  	pg->state = TPGS_STATE_OPTIMIZED;
>  	kref_init(&pg->kref);
>  	spin_lock(&port_group_lock);
> -	list_add(&pg->node, &port_group_list);
> -	h->pg = pg;
> +	/*
> +	 * Re-check list again to catch
> +	 * concurrent updates
> +	 */
> +	list_for_each_entry(tmp_pg, &port_group_list, node) {
> +		if (tmp_pg->group_id != pg->group_id)
> +			continue;
> +		if (tmp_pg->device_id_size != pg->device_id_size)
> +			continue;
> +		if (strncmp(tmp_pg->device_id_str, pg->device_id_str,
> +			    device_id_size))
> +			continue;
> +		h->pg = tmp_pg;
> +		kref_get(&tmp_pg->kref);
> +		kfree(pg);

With the added check for an existing alua_port_group object, and the kfree() of
the alua_port_group that had been allocated if an existing one is found, the code does not
do a destroy_workqueue() on pg->work_q.  

> +		pg = NULL;
> +		break;
> +	}
> +	if (pg) {
> +		list_add(&pg->node, &port_group_list);
> +		h->pg = pg;
> +	}
>  	spin_unlock(&port_group_lock);
>  
>  	return SCSI_DH_OK;
 
An explanation in the comments about the ALUA topology and what the device_id vs.
the group_id represents might be helpful.  It occurred to me that if someone doesn't
understand that you can have the same device_id behind different port groups they
won't understand this code.

HOST  ---->     STORAGE CTRL PG 1   ---->    LUN X
      ---->                         ---->    LUN X
      ---->     STORAGE CTRL PG 2   ---->    LUN X
      ---->                         ---->    LUN X

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


