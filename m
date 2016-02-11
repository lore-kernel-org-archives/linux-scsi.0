From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 18/23] scsi_dh_alua: Send TEST UNIT READY to poll for
 transitioning
Date: Thu, 11 Feb 2016 15:25:18 -0500
Message-ID: <1455222318.22112.330.camel@localhost.localdomain>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
	 <1454942086-128704-19-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbcBKUZU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2016 15:25:20 -0500
In-Reply-To: <1454942086-128704-19-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Mon, 2016-02-08 at 15:34 +0100, Hannes Reinecke wrote:
> Sending a 'REPORT TARGET PORT GROUP' command is a costly operation,
> as the array has to gather information about all ports.
> So instead of using RTPG to poll for a status update when a port
> is in transitioning we should be sending a TEST UNIT READY, and
> wait for the sense code to report success.

Note that we may need to add a timeout on this somehow, I have
recently seen a bug report where an array stayed in the ALUA
transitioning state for an extremely long period of time.

That problem would occur with either the current or this new
ALUA code, the question is whether we want to handle it better.

-Ewan

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Ewan Milne <emilne@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 38 ++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index de8e79e..a1db82f 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -466,6 +466,30 @@ static int alua_check_sense(struct scsi_device *sdev,
>  }
>  
>  /*
> + * alua_tur - Send a TEST UNIT READY
> + * @sdev: device to which the TEST UNIT READY command should be send
> + *
> + * Send a TEST UNIT READY to @sdev to figure out the device state
> + * Returns SCSI_DH_RETRY if the sense code is NOT READY/ALUA TRANSITIONING,
> + * SCSI_DH_OK if no error occurred, and SCSI_DH_IO otherwise.
> + */
> +static int alua_tur(struct scsi_device *sdev)
> +{
> +	struct scsi_sense_hdr sense_hdr;
> +	int retval;
> +
> +	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
> +				      ALUA_FAILOVER_RETRIES, &sense_hdr);
> +	if (sense_hdr.sense_key == NOT_READY &&
> +	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
> +		return SCSI_DH_RETRY;
> +	else if (retval)
> +		return SCSI_DH_IO;
> +	else
> +		return SCSI_DH_OK;
> +}
> +
> +/*
>   * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
>   * @sdev: the device to be evaluated.
>   *
> @@ -735,8 +759,22 @@ static void alua_rtpg_work(struct work_struct *work)
>  		alua_wq = kaluad_sync_wq;
>  	pg->flags |= ALUA_PG_RUNNING;
>  	if (pg->flags & ALUA_PG_RUN_RTPG) {
> +		int state = pg->state;
> +
>  		pg->flags &= ~ALUA_PG_RUN_RTPG;
>  		spin_unlock_irqrestore(&pg->lock, flags);
> +		if (state == TPGS_STATE_TRANSITIONING) {
> +			if (alua_tur(sdev) == SCSI_DH_RETRY) {
> +				spin_lock_irqsave(&pg->lock, flags);
> +				pg->flags &= ~ALUA_PG_RUNNING;
> +				pg->flags |= ALUA_PG_RUN_RTPG;
> +				spin_unlock_irqrestore(&pg->lock, flags);
> +				queue_delayed_work(alua_wq, &pg->rtpg_work,
> +						   pg->interval * HZ);
> +				return;
> +			}
> +			/* Send RTPG on failure or if TUR indicates SUCCESS */
> +		}
>  		err = alua_rtpg(sdev, pg);
>  		spin_lock_irqsave(&pg->lock, flags);
>  		if (err == SCSI_DH_RETRY || pg->flags & ALUA_PG_RUN_RTPG) {


