From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 14/23] scsi_dh_alua: allocate RTPG buffer separately
Date: Tue, 22 Sep 2015 15:04:36 -0400
Message-ID: <1442948676.4132.32.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-15-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934153AbbIVTEh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 15:04:37 -0400
In-Reply-To: <1440679281-13234-15-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> The RTPG buffer will only evaluated within alua_rtpg(),
> so we can allocate it locally there and avoid having to
> put it into the global structure.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 56 +++++++++++-------------------
>  1 file changed, 21 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index d1010dd..4157fe2 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -56,7 +56,7 @@
>  #define TPGS_MODE_IMPLICIT		0x1
>  #define TPGS_MODE_EXPLICIT		0x2
>  
> -#define ALUA_INQUIRY_SIZE		36
> +#define ALUA_RTPG_SIZE			128
>  #define ALUA_FAILOVER_TIMEOUT		60
>  #define ALUA_FAILOVER_RETRIES		5
>  
> @@ -75,9 +75,6 @@ struct alua_port_group {
>  	int			state;
>  	int			pref;
>  	unsigned		flags; /* used for optimizing STPG */
> -	unsigned char		inq[ALUA_INQUIRY_SIZE];
> -	unsigned char		*buff;
> -	int			bufflen;
>  	unsigned char		transition_tmo;
>  };
>  
> @@ -96,21 +93,6 @@ struct alua_dh_data {
>  static char print_alua_state(int);
>  static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
>  
> -static int realloc_buffer(struct alua_port_group *pg, unsigned len)
> -{
> -	if (pg->buff && pg->buff != pg->inq)
> -		kfree(pg->buff);
> -
> -	pg->buff = kmalloc(len, GFP_NOIO);
> -	if (!pg->buff) {
> -		pg->buff = pg->inq;
> -		pg->bufflen = ALUA_INQUIRY_SIZE;
> -		return 1;
> -	}
> -	pg->bufflen = len;
> -	return 0;
> -}
> -
>  static void release_port_group(struct kref *kref)
>  {
>  	struct alua_port_group *pg;
> @@ -120,8 +102,6 @@ static void release_port_group(struct kref *kref)
>  	spin_lock(&port_group_lock);
>  	list_del(&pg->node);
>  	spin_unlock(&port_group_lock);
> -	if (pg->buff && pg->inq != pg->buff)
> -		kfree(pg->buff);
>  	kfree(pg);
>  }
>  
> @@ -300,8 +280,6 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
>  		return SCSI_DH_DEV_TEMP_BUSY;
>  	}
>  	pg->group_id = group_id;
> -	pg->buff = pg->inq;
> -	pg->bufflen = ALUA_INQUIRY_SIZE;
>  	pg->tpgs = h->tpgs;
>  	pg->state = TPGS_STATE_OPTIMIZED;
>  	kref_init(&pg->kref);
> @@ -424,8 +402,8 @@ static int alua_check_sense(struct scsi_device *sdev,
>  static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int wait_for_transition)
>  {
>  	struct scsi_sense_hdr sense_hdr;
> -	int len, k, off, valid_states = 0;
> -	unsigned char *ucp;
> +	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
> +	unsigned char *ucp, *buff;
>  	unsigned err, retval;
>  	unsigned long expiry, interval = 0;
>  	unsigned int tpg_desc_tbl_off;
> @@ -436,9 +414,12 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
>  	else
>  		expiry = round_jiffies_up(jiffies + pg->transition_tmo * HZ);
>  
> +	buff = kzalloc(bufflen, GFP_KERNEL);
> +	if (!buff)
> +		return SCSI_DH_DEV_TEMP_BUSY;
> +
>   retry:
> -	retval = submit_rtpg(sdev, pg->buff, pg->bufflen,
> -			     &sense_hdr, pg->flags);
> +	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
>  
>  	if (retval) {
>  		if (!scsi_sense_valid(&sense_hdr)) {
> @@ -449,6 +430,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
>  				err = SCSI_DH_DEV_TEMP_BUSY;
>  			else
>  				err = SCSI_DH_IO;
> +			kfree(buff);
>  			return err;
>  		}
>  
> @@ -477,14 +459,18 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
>  		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
>  			    ALUA_DH_NAME);
>  		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
> +		kfree(buff);
>  		return SCSI_DH_IO;
>  	}
>  
> -	len = get_unaligned_be32(&pg->buff[0]) + 4;
> +	len = get_unaligned_be32(&buff[0]) + 4;
>  
> -	if (len > pg->bufflen) {
> +	if (len > bufflen) {
>  		/* Resubmit with the correct length */
> -		if (realloc_buffer(pg, len)) {
> +		kfree(buff);
> +		bufflen = len;
> +		buff = kmalloc(bufflen, GFP_KERNEL);
> +		if (!buff) {
>  			sdev_printk(KERN_WARNING, sdev,
>  				    "%s: kmalloc buffer failed\n",__func__);
>  			/* Temporary failure, bypass */
> @@ -494,9 +480,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
>  	}
>  
>  	orig_transition_tmo = pg->transition_tmo;
> -	if ((pg->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR &&
> -	    pg->buff[5] != 0)
> -		pg->transition_tmo = pg->buff[5];
> +	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
> +		pg->transition_tmo = buff[5];
>  	else
>  		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
>  
> @@ -508,12 +493,12 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
>  		expiry = jiffies + pg->transition_tmo * HZ;
>  	}
>  
> -	if ((pg->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
> +	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
>  		tpg_desc_tbl_off = 8;
>  	else
>  		tpg_desc_tbl_off = 4;
>  
> -	for (k = tpg_desc_tbl_off, ucp = pg->buff + tpg_desc_tbl_off;
> +	for (k = tpg_desc_tbl_off, ucp = buff + tpg_desc_tbl_off;
>  	     k < len;
>  	     k += off, ucp += off) {
>  
> @@ -563,6 +548,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
>  		err = SCSI_DH_OK;
>  		break;
>  	}
> +	kfree(buff);
>  	return err;
>  }
>  

I guess.  Are these buffers so big that we don't want to make it part of
a structure that just stays allocated?

We should have some validation on the length of the data returned by RTPG in
the case where the buffer is re-kmalloc'ed, we can't kmalloc 4GB - 1 + 4 bytes.
And if the length is too big, it is not a "temporary" failure.
We should maybe only retry once with a larger buffer, rather than potentially
loop forever if the device keeps returning different information.

(I suppose we have the same potential issue with REPORT LUNS as well.)

Reviewed-by: Ewan D. Milne <emilne@redhat.com>







