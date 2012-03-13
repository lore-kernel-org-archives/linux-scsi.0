From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
Date: Tue, 13 Mar 2012 18:10:10 +0000
Message-ID: <4F5F8D82.2040704@acm.org>
References: <4EE8E419.8010000@pre-sense.de> <CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com> <20111225215804.03ef9402@stein> <4F3A46DD.8030305@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03ant.iops.be ([212.53.5.218]:44640 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759233Ab2CMSKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 14:10:23 -0400
In-Reply-To: <4F3A46DD.8030305@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, jbottomley@parallels.com, linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>, Axel Theilmann <theilmann@pre-sense.de>, linux-kernel@vger.kernel.org

On 02/14/12 11:34, Jun'ichi Nomura wrote:
> While scsi_device is propery refcounted object,
> q->queuedata is set to NULL by scsi_remove_device() asynchronously.
> So every reader of scsi_device's q->queuedata should always check it.
>
> Though I don't have a machine to actually test it,
> the following patch should remove such places.
>
> Index: linux-3.3/drivers/scsi/scsi_lib.c
> ===================================================================
> --- linux-3.3.orig/drivers/scsi/scsi_lib.c	2012-02-01 06:31:54.000000000 +0900
> +++ linux-3.3/drivers/scsi/scsi_lib.c	2012-02-14 19:12:57.641216402 +0900
> @@ -1214,10 +1214,8 @@ int scsi_prep_state_check(struct scsi_de
>  }
>  EXPORT_SYMBOL(scsi_prep_state_check);
>  
> -int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
> +int scsi_prep_return(struct request_queue *q, struct scsi_device *sdev, struct request *req, int ret)
>  {
> -	struct scsi_device *sdev = q->queuedata;
> -
>  	switch (ret) {
>  	case BLKPREP_KILL:
>  		req->errors = DID_NO_CONNECT << 16;
> @@ -1251,9 +1249,11 @@ int scsi_prep_fn(struct request_queue *q
>  	struct scsi_device *sdev = q->queuedata;
>  	int ret = BLKPREP_KILL;
>  
> +	if (!sdev)
> +		return ret;
>  	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
>  		ret = scsi_setup_blk_pc_cmnd(sdev, req);
> -	return scsi_prep_return(q, req, ret);
> +	return scsi_prep_return(q, sdev, req, ret);
>  }
>  EXPORT_SYMBOL(scsi_prep_fn);
>  
> Index: linux-3.3/drivers/scsi/sd.c
> ===================================================================
> --- linux-3.3.orig/drivers/scsi/sd.c	2012-02-13 13:02:14.000000000 +0900
> +++ linux-3.3/drivers/scsi/sd.c	2012-02-14 19:15:18.224212107 +0900
> @@ -653,6 +653,9 @@ static int sd_prep_fn(struct request_que
>  	int ret, host_dif;
>  	unsigned char protect;
>  
> +	if (!sdp)
> +		return BLKPREP_KILL;
> +
>  	/*
>  	 * Discard request come in as REQ_TYPE_FS but we turn them into
>  	 * block PC requests to make life easier.
> @@ -905,7 +908,7 @@ static int sd_prep_fn(struct request_que
>  	 */
>  	ret = BLKPREP_OK;
>   out:
> -	return scsi_prep_return(q, rq, ret);
> +	return scsi_prep_return(q, sdp, rq, ret);
>  }
>  
>  /**
> Index: linux-3.3/drivers/scsi/sr.c
> ===================================================================
> --- linux-3.3.orig/drivers/scsi/sr.c	2012-02-01 06:31:54.000000000 +0900
> +++ linux-3.3/drivers/scsi/sr.c	2012-02-14 19:15:59.001211143 +0900
> @@ -372,6 +372,9 @@ static int sr_prep_fn(struct request_que
>  	struct scsi_device *sdp = q->queuedata;
>  	int ret;
>  
> +	if (!sdp)
> +		return BLKPREP_KILL;
> +
>  	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
>  		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
>  		goto out;
> @@ -503,7 +506,7 @@ static int sr_prep_fn(struct request_que
>  	 */
>  	ret = BLKPREP_OK;
>   out:
> -	return scsi_prep_return(q, rq, ret);
> +	return scsi_prep_return(q, sdp, rq, ret);
>  }
>  
>  static int sr_block_open(struct block_device *bdev, fmode_t mode)
> Index: linux-3.3/include/scsi/scsi_driver.h
> ===================================================================
> --- linux-3.3.orig/include/scsi/scsi_driver.h	2012-02-01 06:31:54.000000000 +0900
> +++ linux-3.3/include/scsi/scsi_driver.h	2012-02-14 19:16:47.478209843 +0900
> @@ -31,7 +31,7 @@ extern int scsi_register_interface(struc
>  int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req);
>  int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req);
>  int scsi_prep_state_check(struct scsi_device *sdev, struct request *req);
> -int scsi_prep_return(struct request_queue *q, struct request *req, int ret);
> +int scsi_prep_return(struct request_queue *q, struct scsi_device *sdev, struct request *req, int ret);
>  int scsi_prep_fn(struct request_queue *, struct request *);
>  
>  #endif /* _SCSI_SCSI_DRIVER_H */

Now that I've had some more time to think about this: has anyone
considered to hold a reference on the SCSI host instead of the SCSI
device as long as sd_probe_async() is active ? If sd_prep_fn() can ever
see a NULL queuedata pointer then that means that
scsi_host_dev_release() can get invoked while sd_prep_fn() is running.
That doesn't look correct to me.

Bart.
