From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Subject: Re: [PATCH] block: set rq->cmd_flags with bio->opf instead of
 data->cmd_flags when bio is not Null
Date: Fri, 25 Jan 2019 08:57:24 +0800
Message-ID: <1c34d6f9-8c3c-a7ff-a956-46e9dc3c2298@hisilicon.com>
References: <1548337430-66690-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548337430-66690-1-git-send-email-chenxiang66@hisilicon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, axboe@kernel.dk, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

+cc Jens + linux-block

ÔÚ 2019/1/24 21:43, chenxiang Ð´µÀ:
> In function blk_mq_make_request(), though data->cmd_flags will be
> initialized with bio->opf, later bio->opf may be set as REQ_INTEGRITY
> if enabled DIX. So need to use bio->opf instead of data->cmd_flags in
> function blk_mq_rq_ctx_init(), or  flags REQ_INTEGRITY will not be set
> for rq->cmd_flags. It will cause dix=0 in function
> sd_setup_read_write_cmnd() when enabled DIX, which will cause IO
> exception when enabled DIX.
>
> For some IOs such as internal IO from SCSI layer, the parameter bio of
> function blk_mq_get_request() is Null, so need to check bio to
> decise rq->cmd_flags.
>
> Fixes: f9afca4d367b ("blk-mq: pass in request/bio flags to queue mapping")
>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Reviewed-by: John Garry <john.garry@huawei.com>
> ---
>   block/blk-mq.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 3ba37b9..c4a1c63 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -394,7 +394,7 @@ static struct request *blk_mq_get_request(struct request_queue *q,
>   		return NULL;
>   	}
>   
> -	rq = blk_mq_rq_ctx_init(data, tag, data->cmd_flags);
> +	rq = blk_mq_rq_ctx_init(data, tag, bio ? bio->bi_opf : data->cmd_flags);
>   	if (!op_is_flush(data->cmd_flags)) {
>   		rq->elv.icq = NULL;
>   		if (e && e->type->ops.prepare_request) {
