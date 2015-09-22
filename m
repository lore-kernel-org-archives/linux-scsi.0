From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 18/23] revert "scsi_dh_alua: ALUA hander attach should
 succeed while TPG is transitioning"
Date: Tue, 22 Sep 2015 15:34:26 -0400
Message-ID: <1442950466.4132.55.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-19-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934306AbbIVTe2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 15:34:28 -0400
In-Reply-To: <1440679281-13234-19-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> This reverts commit a8e5a2d593cbfccf530c3382c2c328d2edaa7b66
> 
> Obsoleted by the next patch.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 29 +++++++++++------------------
>  1 file changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index c2b2100b..b52db8b 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -418,13 +418,12 @@ static int alua_check_sense(struct scsi_device *sdev,
>  /*
>   * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
>   * @sdev: the device to be evaluated.
> - * @wait_for_transition: if nonzero, wait ALUA_FAILOVER_TIMEOUT seconds for device to exit transitioning state
>   *
>   * Evaluate the Target Port Group State.
>   * Returns SCSI_DH_DEV_OFFLINED if the path is
>   * found to be unusable.
>   */
> -static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int wait_for_transition)
> +static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  {
>  	struct scsi_sense_hdr sense_hdr;
>  	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
> @@ -517,8 +516,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
>  	else
>  		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
>  
> -	if (wait_for_transition &&
> -	    (orig_transition_tmo != pg->transition_tmo)) {
> +	if (orig_transition_tmo != pg->transition_tmo) {
>  		sdev_printk(KERN_INFO, sdev,
>  			    "%s: transition timeout set to %d seconds\n",
>  			    ALUA_DH_NAME, pg->transition_tmo);
> @@ -556,19 +554,14 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
>  
>  	switch (pg->state) {
>  	case TPGS_STATE_TRANSITIONING:
> -		if (wait_for_transition) {
> -			if (time_before(jiffies, expiry)) {
> -				/* State transition, retry */
> -				interval += 2000;
> -				msleep(interval);
> -				goto retry;
> -			}
> -			err = SCSI_DH_RETRY;
> -		} else {
> -			err = SCSI_DH_OK;
> +		if (time_before(jiffies, expiry)) {
> +			/* State transition, retry */
> +			interval += 2000;
> +			msleep(interval);
> +			goto retry;
>  		}
> -
>  		/* Transitioning time exceeded, set port to standby */
> +		err = SCSI_DH_RETRY;
>  		pg->state = TPGS_STATE_STANDBY;
>  		break;
>  	case TPGS_STATE_OFFLINE:
> @@ -665,7 +658,7 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
>  		goto out;
>  
>  	kref_get(&h->pg->kref);
> -	err = alua_rtpg(sdev, h->pg, 0);
> +	err = alua_rtpg(sdev, h->pg);
>  	kref_put(&h->pg->kref, release_port_group);
>  out:
>  	return err;
> @@ -739,14 +732,14 @@ static int alua_activate(struct scsi_device *sdev,
>  	if (optimize_stpg)
>  		h->pg->flags |= ALUA_OPTIMIZE_STPG;
>  
> -	err = alua_rtpg(sdev, h->pg, 1);
> +	err = alua_rtpg(sdev, h->pg);
>  	if (err != SCSI_DH_OK) {
>  		kref_put(&h->pg->kref, release_port_group);
>  		goto out;
>  	}
>  	err = alua_stpg(sdev, h->pg);
>  	if (err == SCSI_DH_RETRY)
> -		err = alua_rtpg(sdev, h->pg, 1);
> +		err = alua_rtpg(sdev, h->pg);
>  	kref_put(&h->pg->kref, release_port_group);
>  out:
>  	if (fn)

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


