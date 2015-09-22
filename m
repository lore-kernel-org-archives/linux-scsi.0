From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 10/23] scsi_dh_alua: Pass buffer as function argument
Date: Tue, 22 Sep 2015 14:43:00 -0400
Message-ID: <1442947380.4132.15.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-11-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934106AbbIVSnC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 14:43:02 -0400
In-Reply-To: <1440679281-13234-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> Pass in the buffer as a function argument for submit_rtpg().
> 
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 0636721..9e2b3af 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -137,12 +137,13 @@ static struct request *get_alua_req(struct scsi_device *sdev,
>   * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
>   * @sdev: sdev the command should be sent to
>   */
> -static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
> +static unsigned submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
> +			    int bufflen, unsigned char *sense, int flags)
>  {
>  	struct request *rq;
>  	int err = 0;
>  
> -	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
> +	rq = get_alua_req(sdev, buff, bufflen, READ);
>  	if (!rq) {
>  		err = DRIVER_BUSY << 24;
>  		goto done;
> @@ -150,22 +151,21 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
>  
>  	/* Prepare the command. */
>  	rq->cmd[0] = MAINTENANCE_IN;
> -	if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP))
> +	if (!(flags & ALUA_RTPG_EXT_HDR_UNSUPP))
>  		rq->cmd[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
>  	else
>  		rq->cmd[1] = MI_REPORT_TARGET_PGS;
> -	put_unaligned_be32(h->bufflen, &rq->cmd[6]);
> +	put_unaligned_be32(bufflen, &rq->cmd[6]);
>  	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_IN);
>  
> -	rq->sense = h->sense;
> +	rq->sense = sense;
>  	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
> -	rq->sense_len = h->senselen = 0;
> +	rq->sense_len = 0;
>  
>  	blk_execute_rq(rq->q, NULL, rq, 1);
> -	if (rq->errors) {
> +	if (rq->errors)
>  		err = rq->errors;
> -		h->senselen = rq->sense_len;
> -	}
> +
>  	blk_put_request(rq);
>  done:
>  	return err;
> @@ -491,7 +491,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
>  
>   retry:
> -	retval = submit_rtpg(sdev, h);
> +	retval = submit_rtpg(sdev, h->buff, h->bufflen, h->sense, h->flags);
>  
>  	if (retval) {
>  		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,

This patch also removes the setting of h->senselen, you should mention
that in the patch description.  Or, perhaps the removal of h->senselen
should have been done as part of patch 12/23, which removed the senselen
field (and the sense buffer field) from the alua_dh_data structure.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


