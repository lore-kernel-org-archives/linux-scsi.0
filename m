From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] IB/srp: Process REQ_PREEMPT requests correctly
Date: Thu, 29 Jan 2015 13:38:52 -0600
Message-ID: <54CA8C4C.1080508@cs.wisc.edu>
References: <54CA2F48.605@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45699 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbbA2TjL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 14:39:11 -0500
In-Reply-To: <54CA2F48.605@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Roland Dreier <roland@purestorage.com>, Max Gurtuvoy <maxg@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 1/29/15, 7:02 AM, Bart Van Assche wrote:
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
> Reported-by: Max Gurtuvoy <maxg@mellanox.com>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: <stable@vger.kernel.org>
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

What is the case where a driver blocks the device and can handle or 
wants commands? iSCSI and FC also do not want commands, even PREEMPT 
ones, at this time. It looks like they have been hitting internal checks 
to prevent hitting similar issues.
