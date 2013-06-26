From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi_prep_fn() check for empty queue
Date: Wed, 26 Jun 2013 11:20:58 +0200
Message-ID: <51CAB27A.3080805@acm.org>
References: <1372237363-5156-1-git-send-email-maxim.uvarov@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1372237363-5156-1-git-send-email-maxim.uvarov@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maxim Uvarov <maxim.uvarov@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

On 06/26/13 11:02, Maxim Uvarov wrote:
> This fix:
> end_request: I/O error, dev sdc, sector 976576
>   rport-0:0-3: blocked FC remote port time out: removing target and saving
> binding
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000400
> IP: [<ffffffff812f0cc2>] scsi_prep_state_check+0xe/0x99
>   [<ffffffff812f1f9d>] scsi_setup_blk_pc_cmnd+0x1b/0x115
>   [<ffffffff812f20c0>] scsi_prep_fn+0x29/0x3b
>   [<ffffffff8121cfb9>] blk_peek_request+0xe1/0x1b3
>   [<ffffffff812f1400>] scsi_request_fn+0x3a/0x4d2
>   [<ffffffff8121d916>] __generic_unplug_device+0x32/0x36
>   [<ffffffff81220f4b>] blk_execute_rq_nowait+0x77/0x9e
>   [<ffffffff81221018>] blk_execute_rq+0xa6/0xde
>   [<ffffffff8144f24b>] ? printk+0x41/0x46
>   [<ffffffffa00a21c5>] ? get_rdac_req+0x81/0xe8 [scsi_dh_rdac]
>   [<ffffffffa00a273a>] send_mode_select+0x29f/0x489 [scsi_dh_rdac]
>   [<ffffffff810c5d9b>] ? probe_workqueue_execution+0xb1/0xce
>   [<ffffffff81071e38>] worker_thread+0x1a9/0x237
>   [<ffffffffa00a249b>] ? send_mode_select+0x0/0x489 [scsi_dh_rdac]
>   [<ffffffff8107651b>] ? autoremove_wake_function+0x0/0x39
>   [<ffffffff81071c8f>] ? worker_thread+0x0/0x237
>   [<ffffffff81076222>] kthread+0x7f/0x87
>   [<ffffffff81012d2a>] child_rip+0xa/0x20
>   [<ffffffff810761a3>] ? kthread+0x0/0x87
>   [<ffffffff81012d20>] ? child_rip+0x0/0x20
> Signed-off-by: Maxim Uvarov <maxim.uvarov@oracle.com>
> ---
>   drivers/scsi/scsi_lib.c |    3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 86d5220..8e89ed9 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1295,6 +1295,9 @@ int scsi_prep_fn(struct request_queue *q, struct request *req)
>   	struct scsi_device *sdev = q->queuedata;
>   	int ret = BLKPREP_KILL;
>
> +	if (!sdev)
> +		return ret;
> +
>   	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
>   		ret = scsi_setup_blk_pc_cmnd(sdev, req);
>   	return scsi_prep_return(q, req, ret);

Sorry but this patch does not look like a proper fix to me. What you 
probably need is a scsi_device_get() call in scsi_dh_rdac.c somewhere 
before the queue_work(kmpath_rdacd, &ctlr->ms_work) call and a 
scsi_device_put() call once send_mode_select() has finished using the sdev.

Bart.
