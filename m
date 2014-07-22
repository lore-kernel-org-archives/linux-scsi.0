From: Webb Scales <webbnh@hp.com>
Subject: Re: [PATCH 01/14] scsi: add scsi_setup_cmnd helper
Date: Tue, 22 Jul 2014 13:20:30 -0400
Message-ID: <53CE9D5E.3000607@hp.com>
References: <1405678393-11497-1-git-send-email-hch@lst.de> <1405678393-11497-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:43580 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbaGVRUe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2014 13:20:34 -0400
In-Reply-To: <1405678393-11497-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On 7/18/14 6:13 AM, Christoph Hellwig wrote:
> Factor out command setup code that will be shared with the blk-mq code path.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c | 40 ++++++++++++++++++++++------------------
>   1 file changed, 22 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 85cf0ef..04c3684 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1092,6 +1092,27 @@ static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
>   	return scsi_cmd_to_driver(cmd)->init_command(cmd);
>   }
>   
> +static int scsi_setup_cmnd(struct scsi_device *sdev, struct request *req)
> +{
> +	struct scsi_cmnd *cmd = req->special;
> +
> +	if (!blk_rq_bytes(req))
> +		cmd->sc_data_direction = DMA_NONE;
> +	else if (rq_data_dir(req) == WRITE)
> +		cmd->sc_data_direction = DMA_TO_DEVICE;
> +	else
> +		cmd->sc_data_direction = DMA_FROM_DEVICE;
> +
> +	switch (req->cmd_type) {
> +	case REQ_TYPE_FS:
> +		return scsi_setup_fs_cmnd(sdev, req);
> +	case REQ_TYPE_BLOCK_PC:
> +		return scsi_setup_blk_pc_cmnd(sdev, req);
> +	default:
> +		return BLKPREP_KILL;
> +	}
> +}
> +
>   static int
>   scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
>   {
> @@ -1195,24 +1216,7 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
>   		goto out;
>   	}
>   
> -	if (!blk_rq_bytes(req))
> -		cmd->sc_data_direction = DMA_NONE;
> -	else if (rq_data_dir(req) == WRITE)
> -		cmd->sc_data_direction = DMA_TO_DEVICE;
> -	else
> -		cmd->sc_data_direction = DMA_FROM_DEVICE;
> -
> -	switch (req->cmd_type) {
> -	case REQ_TYPE_FS:
> -		ret = scsi_setup_fs_cmnd(sdev, req);
> -		break;
> -	case REQ_TYPE_BLOCK_PC:
> -		ret = scsi_setup_blk_pc_cmnd(sdev, req);
> -		break;
> -	default:
> -		ret = BLKPREP_KILL;
> -	}
> -
> +	ret = scsi_setup_cmnd(sdev, req);
>   out:
>   	return scsi_prep_return(q, req, ret);
>   }

Reviewed-by: Webb Scales <webbnh@hp.com>

