From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/4] scsi: reintroduce scsi_driver.init_command
Date: Sun, 30 Mar 2014 22:45:04 -0700
Message-ID: <1396244704.22255.46.camel@haakon3.risingtidesystems.com>
References: <1395936862-6938-1-git-send-email-hch@lst.de>
	 <1395936862-6938-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56780 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaCaFpR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2014 01:45:17 -0400
In-Reply-To: <1395936862-6938-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On Thu, 2014-03-27 at 17:14 +0100, Christoph Hellwig wrote:
> Move control of the prep_fn back from the ULDs into the scsi layer.  Besides
> cleaning up the code and removing the only use of the unprep_fn
> requeuest_queue method this also prepares for usinng blk-mq, which doesn't
> have equivalent functionality to the prep_fn method and requires the driver
> to provide just a single I/O submission method.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_lib.c    |   66 ++++++++++++++++++++++++++------------------
>  drivers/scsi/sd.c          |   46 +++++++++++-------------------
>  drivers/scsi/sr.c          |   19 ++++---------
>  include/scsi/scsi_driver.h |    8 ++----
>  4 files changed, 63 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index a73751b..48c5c77 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c

<SNIP>

> @@ -1071,15 +1083,7 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
>  
>  int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
>  {
> -	struct scsi_cmnd *cmd;
> -	int ret = scsi_prep_state_check(sdev, req);
> -
> -	if (ret != BLKPREP_OK)
> -		return ret;
> -
> -	cmd = scsi_get_cmd_from_req(sdev, req);
> -	if (unlikely(!cmd))
> -		return BLKPREP_DEFER;
> +	struct scsi_cmnd *cmd = req->special;
>  

Mmm, I thought that req->special was only holding a pointer to a
pre-allocated scsi_cmnd during mq operation, no..?

>  	/*
>  	 * BLOCK_PC requests may transfer data, in which case they must
> @@ -1123,15 +1127,11 @@ EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
>   */
>  int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
>  {
> -	struct scsi_cmnd *cmd;
> -	int ret = scsi_prep_state_check(sdev, req);
> -
> -	if (ret != BLKPREP_OK)
> -		return ret;
> +	struct scsi_cmnd *cmd = req->special;
>  

Ditto here for REQ_TYPE_FS_CMND

>  	if (unlikely(sdev->scsi_dh_data && sdev->scsi_dh_data->scsi_dh
>  			 && sdev->scsi_dh_data->scsi_dh->prep_fn)) {
> -		ret = sdev->scsi_dh_data->scsi_dh->prep_fn(sdev, req);
> +		int ret = sdev->scsi_dh_data->scsi_dh->prep_fn(sdev, req);
>  		if (ret != BLKPREP_OK)
>  			return ret;
>  	}
> @@ -1141,16 +1141,13 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
>  	 */
>  	BUG_ON(!req->nr_phys_segments);
>  
> -	cmd = scsi_get_cmd_from_req(sdev, req);
> -	if (unlikely(!cmd))
> -		return BLKPREP_DEFER;
> -
>  	memset(cmd->cmnd, 0, BLK_MAX_CDB);
>  	return scsi_init_io(cmd, GFP_ATOMIC);
>  }
>  EXPORT_SYMBOL(scsi_setup_fs_cmnd);
>  
> -int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
> +static int
> +scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
>  {
>  	int ret = BLKPREP_OK;
>  
> @@ -1202,9 +1199,9 @@ int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
>  	}
>  	return ret;
>  }
> -EXPORT_SYMBOL(scsi_prep_state_check);
>  
> -int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
> +static int
> +scsi_prep_return(struct request_queue *q, struct request *req, int ret)
>  {
>  	struct scsi_device *sdev = q->queuedata;
>  
> @@ -1235,18 +1232,33 @@ int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
>  
>  	return ret;
>  }
> -EXPORT_SYMBOL(scsi_prep_return);
>  
> -int scsi_prep_fn(struct request_queue *q, struct request *req)
> +static int scsi_prep_fn(struct request_queue *q, struct request *req)
>  {
>  	struct scsi_device *sdev = q->queuedata;
> -	int ret = BLKPREP_KILL;
> +	struct scsi_cmnd *cmd;
> +	int ret;
>  
> -	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
> +	ret = scsi_prep_state_check(sdev, req);
> +	if (ret != BLKPREP_OK)
> +		goto out;
> +
> +	cmd = scsi_get_cmd_from_req(sdev, req);
> +	if (unlikely(!cmd)) {
> +		ret = BLKPREP_DEFER;
> +		goto out;
> +	}
> +

>From here the req->special pointer may or may not be set depending on mq
operation, no..?

> +	if (req->cmd_type == REQ_TYPE_FS)
> +		ret = scsi_cmd_to_driver(cmd)->init_command(cmd);
> +	else if (req->cmd_type == REQ_TYPE_BLOCK_PC)
>  		ret = scsi_setup_blk_pc_cmnd(sdev, req);
> +	else
> +		ret = BLKPREP_KILL;
> +
> +out:
>  	return scsi_prep_return(q, req, ret);
>  }
> -EXPORT_SYMBOL(scsi_prep_fn);
>  
>  /*
>   * scsi_dev_queue_ready: if we can send requests to sdev, return 1 else
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 89e6c04..d95c4fd 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c

<SNIP>

> @@ -886,12 +882,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
>  	} else if (rq->cmd_flags & REQ_FLUSH) {
>  		ret = scsi_setup_flush_cmnd(sdp, rq);
>  		goto out;
> -	} else if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
> -		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
> -		goto out;
> -	} else if (rq->cmd_type != REQ_TYPE_FS) {
> -		ret = BLKPREP_KILL;
> -		goto out;
>  	}
>  	ret = scsi_setup_fs_cmnd(sdp, rq);
>  	if (ret != BLKPREP_OK)

And this currently assumes req->special is always set when calling
scsi_setup_fs_cmnd()

> @@ -903,11 +893,10 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
>  	 * is used for a killable error condition */
>  	ret = BLKPREP_KILL;
>  
> -	SCSI_LOG_HLQUEUE(1, scmd_printk(KERN_INFO, SCpnt,
> -					"sd_prep_fn: block=%llu, "
> -					"count=%d\n",
> -					(unsigned long long)block,
> -					this_count));
> +	SCSI_LOG_HLQUEUE(1,
> +		scmd_printk(KERN_INFO, SCpnt,
> +			"%s: block=%llu, count=%d\n",
> +			__func__, (unsigned long long)block, this_count));
>  
>  	if (!sdp || !scsi_device_online(sdp) ||
>  	    block + blk_rq_sectors(rq) > get_capacity(disk)) {
> @@ -1127,7 +1116,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
>  	 */
>  	ret = BLKPREP_OK;
>   out:
> -	return scsi_prep_return(q, rq, ret);
> +	return ret;
>  }
>  
>  /**
> @@ -1663,6 +1652,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  	unsigned char op = SCpnt->cmnd[0];
>  	unsigned char unmap = SCpnt->cmnd[1] & 8;
>  
> +	sd_uninit_command(SCpnt);
> +
>  	if (req->cmd_flags & REQ_DISCARD || req->cmd_flags & REQ_WRITE_SAME) {
>  		if (!result) {
>  			good_bytes = blk_rq_bytes(req);
> @@ -2878,9 +2869,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
>  
>  	sd_revalidate_disk(gd);
>  
> -	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
> -	blk_queue_unprep_rq(sdp->request_queue, sd_unprep_fn);
> -
>  	gd->driverfs_dev = &sdp->sdev_gendev;
>  	gd->flags = GENHD_FL_EXT_DEVT;
>  	if (sdp->removable) {
> @@ -3027,8 +3015,6 @@ static int sd_remove(struct device *dev)
>  	scsi_autopm_get_device(sdkp->device);
>  
>  	async_synchronize_full_domain(&scsi_sd_probe_domain);
> -	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
> -	blk_queue_unprep_rq(sdkp->device->request_queue, NULL);
>  	device_del(&sdkp->dev);
>  	del_gendisk(sdkp->disk);
>  	sd_shutdown(dev);
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 40d8592..93cbd36 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c

<SNIP>

> @@ -378,21 +380,14 @@ static int sr_done(struct scsi_cmnd *SCpnt)
>  	return good_bytes;
>  }
>  
> -static int sr_prep_fn(struct request_queue *q, struct request *rq)
> +static int sr_init_command(struct scsi_cmnd *SCpnt)
>  {
>  	int block = 0, this_count, s_size;
>  	struct scsi_cd *cd;
> -	struct scsi_cmnd *SCpnt;
> -	struct scsi_device *sdp = q->queuedata;
> +	struct request *rq = SCpnt->request;
> +	struct scsi_device *sdp = SCpnt->device;
>  	int ret;
>  
> -	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
> -		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
> -		goto out;
> -	} else if (rq->cmd_type != REQ_TYPE_FS) {
> -		ret = BLKPREP_KILL;
> -		goto out;
> -	}
>  	ret = scsi_setup_fs_cmnd(sdp, rq);
>  	if (ret != BLKPREP_OK)
>  		goto out;

Ditto to the scsi_setup_fs_cmnd() call here as well.

--nab

