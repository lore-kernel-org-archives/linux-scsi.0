From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 02/11] st: add st_scsi_kern_execute helper function
Date: Sun, 30 Nov 2008 14:10:56 +0200
Message-ID: <493282D0.6020006@panasas.com>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1228032485-10328-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:8909 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750714AbYK3MLA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 07:11:00 -0500
In-Reply-To: <1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kai.Makisara@kolumbus.fi, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> st_scsi_kern_execute is a helper function to perform SCSI commands
> synchronously. It supports data transfer with a liner in-kernel buffer
> (not scatter gather). st_scsi_kern_execute internally uses
> blk_get_request, blk_rq_map_kern, and blk_execute_rq.
> 
> The majority of st_do_scsi can be replaced with
> st_scsi_kern_execute. This is a preparation for rewriting st_do_scsi
> to remove obsolete scsi_execute_async().
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/st.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 49 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 878493d..6179940 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -533,6 +533,55 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
>  	return SRpnt;
>  }
>  
> +static int st_scsi_kern_execute(struct st_request *streq,
> +				const unsigned char *cmd, int data_direction,
> +				void *buffer, unsigned bufflen, int timeout,
> +				int retries)
> +{
> +	struct scsi_tape *stp = streq->stp;
> +	struct request *req;
> +	int write = (data_direction == DMA_TO_DEVICE);
> +	int ret = 0;
> +
> +	/* st_do_scsi returns -EBUSY in case of OOM */
> +	req = blk_get_request(stp->device->request_queue, write, GFP_KERNEL);
> +	if (!req)
> +		return -EBUSY;
> +
> +	if (bufflen) {
> +		ret = blk_rq_map_kern(stp->device->request_queue, req,
> +				      buffer, bufflen, GFP_KERNEL);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	req->cmd_type = REQ_TYPE_BLOCK_PC;
> +	req->cmd_flags |= REQ_QUIET;
> +
> +	req->cmd_len = COMMAND_SIZE(cmd[0]);
> +	memcpy(req->cmd, cmd, req->cmd_len);
> +
> +	req->sense = streq->sense;
> +	req->sense_len = 0;
> +
> +	req->timeout = timeout;
> +	req->retries = retries;
> +
> +	stp->buffer->cmdstat.have_sense = 0;
> +	memcpy(streq->cmd, cmd, sizeof(streq->cmd));
> +
> +	blk_execute_rq(req->q, NULL, req, 1);
> +
> +	stp->buffer->cmdstat.midlevel_result = streq->result = req->errors;
> +	stp->buffer->cmdstat.residual = req->data_len;
> +

TOMO Hi.

would you say that the only reason we cannot use scsi_execute inside st_scsi_kern_execute
is because we don't have residual count returned from scsi_execute ?

> +	stp->buffer->syscall_result = st_chk_result(stp, streq);
> +
> +out:
> +	blk_put_request(req);
> +
> +	return ret;
> +}
>  
>  /* Handle the write-behind checking (waits for completion). Returns -ENOSPC if
>     write has been correct but EOM early warning reached, -EIO if write ended in

The reason I'm asking is because I needed the same from scsi_execute in the passed.

Boaz

