From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Process REQ_PREEMPT requests correctly
Date: Thu, 29 Jan 2015 15:44:32 +0200
Message-ID: <54CA3940.7040205@dev.mellanox.co.il>
References: <54CA2F48.605@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54CA2F48.605-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 1/29/2015 3:02 PM, Bart Van Assche wrote:
> Delay REQ_PREEMPT requests submitted against a blocked device
> until the device is unblocked by returning SCSI_MLQUEUE_HOST_BUSY
> to the SCSI mid-layer. This avoids that a rescan shortly after a
> cable pull sporadically triggers the following kernel oops:
>
> BUG: unable to handle kernel paging request at ffffc9001a6bc084
> IP: [<ffffffffa04e08f2>] mlx4_ib_post_send+0xd2/0xb30 [mlx4_ib]
> Process rescan-scsi-bus (pid: 9241, threadinfo ffff88053484a000, task ffff880534aae100)
> Call Trace:
>   [<ffffffffa0718135>] srp_post_send+0x65/0x70 [ib_srp]
>   [<ffffffffa071b9df>] srp_queuecommand+0x1cf/0x3e0 [ib_srp]
>   [<ffffffffa0001ff1>] scsi_dispatch_cmd+0x101/0x280 [scsi_mod]
>   [<ffffffffa0009ad1>] scsi_request_fn+0x411/0x4d0 [scsi_mod]
>   [<ffffffff81223b37>] __blk_run_queue+0x27/0x30
>   [<ffffffff8122a8d2>] blk_execute_rq_nowait+0x82/0x110
>   [<ffffffff8122a9c2>] blk_execute_rq+0x62/0xf0
>   [<ffffffffa000b0e8>] scsi_execute+0xe8/0x190 [scsi_mod]
>   [<ffffffffa000b2f3>] scsi_execute_req+0xa3/0x130 [scsi_mod]
>   [<ffffffffa000c1aa>] scsi_probe_lun+0x17a/0x450 [scsi_mod]
>   [<ffffffffa000ce86>] scsi_probe_and_add_lun+0x156/0x480 [scsi_mod]
>   [<ffffffffa000dc2f>] __scsi_scan_target+0xdf/0x1f0 [scsi_mod]
>   [<ffffffffa000dfa3>] scsi_scan_host_selected+0x183/0x1c0 [scsi_mod]
>   [<ffffffffa000edfb>] scsi_scan+0xdb/0xe0 [scsi_mod]
>   [<ffffffffa000ee13>] store_scan+0x13/0x20 [scsi_mod]
>   [<ffffffff811c8d9b>] sysfs_write_file+0xcb/0x160
>   [<ffffffff811589de>] vfs_write+0xce/0x140
>   [<ffffffff81158b53>] sys_write+0x53/0xa0
>   [<ffffffff81464592>] system_call_fastpath+0x16/0x1b
>   [<00007f611c9d9300>] 0x7f611c9d92ff
>
> Reported-by: Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 0747c05..77a7a2f 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2003,8 +2003,13 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>   	if (in_scsi_eh)
>   		mutex_lock(&rport->mutex);
>
> +	/*
> +	 * The "blocked" state of SCSI devices is ignored by the SCSI core for
> +	 * REQ_PREEMPT requests. Hence the explicit check below for the SCSI
> +	 * device state.
> +	 */
>   	scmnd->result = srp_chkready(target->rport);
> -	if (unlikely(scmnd->result))
> +	if (unlikely(scmnd->result != 0 || scsi_device_blocked(scmnd->device)))
>   		goto err;
>
>   	WARN_ON_ONCE(scmnd->request->tag < 0);
>


Yep...

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
