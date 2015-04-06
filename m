From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH, resend] Defer processing of REQ_PREEMPT requests for
 blocked devices
Date: Mon, 06 Apr 2015 10:37:58 -0500
Message-ID: <5522A856.5000105@cs.wisc.edu>
References: <54F6D103.9040709@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44991 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbbDFPiU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Apr 2015 11:38:20 -0400
In-Reply-To: <54F6D103.9040709@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@parallels.com>
Cc: Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/04/2015 03:31 AM, Bart Van Assche wrote:
> SCSI transport drivers and SCSI LLDs block a SCSI device if the
> transport layer is not operational. This means that in this state
> no requests should be processed, even if the REQ_PREEMPT flag has
> been set. This patch avoids that a rescan shortly after a cable
> pull sporadically triggers the following kernel oops:
> 
> BUG: unable to handle kernel paging request at ffffc9001a6bc084
> IP: [<ffffffffa04e08f2>] mlx4_ib_post_send+0xd2/0xb30 [mlx4_ib]
> Process rescan-scsi-bus (pid: 9241, threadinfo ffff88053484a000, task ffff880534aae100)
> Call Trace:
>  [<ffffffffa0718135>] srp_post_send+0x65/0x70 [ib_srp]
>  [<ffffffffa071b9df>] srp_queuecommand+0x1cf/0x3e0 [ib_srp]
>  [<ffffffffa0001ff1>] scsi_dispatch_cmd+0x101/0x280 [scsi_mod]
>  [<ffffffffa0009ad1>] scsi_request_fn+0x411/0x4d0 [scsi_mod]
>  [<ffffffff81223b37>] __blk_run_queue+0x27/0x30
>  [<ffffffff8122a8d2>] blk_execute_rq_nowait+0x82/0x110
>  [<ffffffff8122a9c2>] blk_execute_rq+0x62/0xf0
>  [<ffffffffa000b0e8>] scsi_execute+0xe8/0x190 [scsi_mod]
>  [<ffffffffa000b2f3>] scsi_execute_req+0xa3/0x130 [scsi_mod]
>  [<ffffffffa000c1aa>] scsi_probe_lun+0x17a/0x450 [scsi_mod]
>  [<ffffffffa000ce86>] scsi_probe_and_add_lun+0x156/0x480 [scsi_mod]
>  [<ffffffffa000dc2f>] __scsi_scan_target+0xdf/0x1f0 [scsi_mod]
>  [<ffffffffa000dfa3>] scsi_scan_host_selected+0x183/0x1c0 [scsi_mod]
>  [<ffffffffa000edfb>] scsi_scan+0xdb/0xe0 [scsi_mod]
>  [<ffffffffa000ee13>] store_scan+0x13/0x20 [scsi_mod]
>  [<ffffffff811c8d9b>] sysfs_write_file+0xcb/0x160
>  [<ffffffff811589de>] vfs_write+0xce/0x140
>  [<ffffffff81158b53>] sys_write+0x53/0xa0
>  [<ffffffff81464592>] system_call_fastpath+0x16/0x1b
>  [<00007f611c9d9300>] 0x7f611c9d92ff
> 
> Reported-by: Max Gurtuvoy <maxg@mellanox.com>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/scsi_lib.c   | 4 +++-
>  include/linux/blk_types.h | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 54d7a6c..b1a2631 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1311,9 +1311,11 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
>  				    "rejecting I/O to dead device\n");
>  			ret = BLKPREP_KILL;
>  			break;
> -		case SDEV_QUIESCE:
>  		case SDEV_BLOCK:
>  		case SDEV_CREATED_BLOCK:
> +			ret = BLKPREP_DEFER;
> +			break;
> +		case SDEV_QUIESCE:
>  			/*
>  			 * If the devices is blocked we defer normal commands.
>  			 */
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index c294e3e..a1b25e3 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -181,7 +181,9 @@ enum rq_flag_bits {
>  	__REQ_ELVPRIV,		/* elevator private data attached */
>  	__REQ_FAILED,		/* set if the request failed */
>  	__REQ_QUIET,		/* don't worry about errors */
> -	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
> +	__REQ_PREEMPT,		/* set for "ide_preempt" requests and also
> +				   for requests for which the SCSI "quiesce"
> +				   state must be ignored. */
>  	__REQ_ALLOCED,		/* request came from our alloc pool */
>  	__REQ_COPY_USER,	/* contains copies of user pages */
>  	__REQ_FLUSH_SEQ,	/* request for flush sequence */
> 

Look ok to me. Also tested here with iscsi and FC.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
