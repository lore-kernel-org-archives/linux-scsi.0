From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 1/1] scsi: Fix WARN message for FC passthru failure paths
Date: Mon, 19 Oct 2009 12:51:33 -0400
Message-ID: <4ADC9915.4040004@emulex.com>
References: <200910191152.n9JBqvxJ009698@d01av02.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53690 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbZJSQve (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2009 12:51:34 -0400
In-Reply-To: <200910191152.n9JBqvxJ009698@d01av02.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Thanks Brian.

Acked-By: James Smart <james.smart@emulex.com>

-- james

fyi: If I remember right, the passthru interface still has a problem returning 
the receive residual properly via bsg.


Brian King wrote:
> There are three error paths in the FC passthru code where
> job->reply->reply_payload_rcv_len does not get initialized,
> resulting in the WARN_ON in fc_bsg_jobdone going off. This patch
> fixes this. An example of one of the WARN_ON messages seen:
> 
> Badness at drivers/scsi/scsi_transport_fc.c:3424
> NIP: d000000000bf21ac LR: d000000000bf2684 CTR: c0000000003f753c
> REGS: c00000004eb03430 TRAP: 0700   Not tainted  (2.6.32-rc4-git)
> MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24008444  XER: 00000012
> TASK = c00000004c3fc9c0[3243] 'fcping' THREAD: c00000004eb00000 CPU: 0
> GPR00: 0000000000000001 c00000004eb036b0 d000000000c01da0 000000004bf17fc0
> GPR04: c00000004cd256a0 c00000007e011ce0 c00000007e011d00 c00000004e718000
> GPR08: c00000004cd256a0 c00000004eb03ad0 c00000004cd25a90 0000000000000020
> GPR12: d000000000bf7848 c000000000b62600 0000000000000060 fffffffffffffff4
> GPR16: ffffffffffffffd6 c00000004c7a3060 ffffffff80000003 c00000004b0f0310
> GPR20: c00000004e71b180 c00000004c7a3060 0000000000000004 0000000000000000
> GPR24: c00000004e71b000 c00000004c7a3000 c00000004b0f0000 c00000004e718000
> GPR28: c00000004cd256a0 c00000004cd25a90 d000000000c01db0 c00000004e01d680
> NIP [d000000000bf21ac] .fc_bsg_jobdone+0x64/0x9c [scsi_transport_fc]
> LR [d000000000bf2684] .fc_bsg_request_handler+0x4a0/0x564 [scsi_transport_fc]
> Call Trace:
> [c00000004eb036b0] [c0000000003f755c] .get_device+0x20/0x38 (unreliable)
> [c00000004eb03720] [d000000000bf2684] .fc_bsg_request_handler+0x4a0/0x564 [scsi_transport_fc]
> [c00000004eb03820] [c0000000002c9b5c] .__generic_unplug_device+0x58/0x70
> [c00000004eb038a0] [c0000000002ce9fc] .blk_execute_rq_nowait+0x70/0xf4
> [c00000004eb03930] [c0000000002ceb2c] .blk_execute_rq+0xac/0x100
> [c00000004eb03a60] [c0000000002d51b4] .bsg_ioctl+0x1fc/0x264
> [c00000004eb03c10] [c00000000018a89c] .vfs_ioctl+0x54/0xec
> [c00000004eb03ca0] [c00000000018b01c] .do_vfs_ioctl+0x640/0x6a8
> [c00000004eb03d80] [c00000000018b0fc] .SyS_ioctl+0x78/0xbc
> [c00000004eb03e30] [c0000000000085b4] syscall_exit+0x0/0x40
> Instruction dump:
> 8003004c 2fa80000 90090104 38000000 900a0108 419e0038 e9230040 81680108
> 80690004 7f835840 7c101026 5400f7fe <0b000000> 7d605b78 7f8b1840 409d0008
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/scsi_transport_fc.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff -puN drivers/scsi/scsi_transport_fc.c~scsi_fc_bsg_fix_warn drivers/scsi/scsi_transport_fc.c
> --- linux-2.6/drivers/scsi/scsi_transport_fc.c~scsi_fc_bsg_fix_warn	2009-10-16 17:06:47.000000000 -0500
> +++ linux-2.6-bjking1/drivers/scsi/scsi_transport_fc.c	2009-10-16 17:06:47.000000000 -0500
> @@ -3656,6 +3656,7 @@ fc_bsg_host_dispatch(struct request_queu
>  fail_host_msg:
>  	/* return the errno failure code as the only status */
>  	BUG_ON(job->reply_len < sizeof(uint32_t));
> +	job->reply->reply_payload_rcv_len = 0;
>  	job->reply->result = ret;
>  	job->reply_len = sizeof(uint32_t);
>  	fc_bsg_jobdone(job);
> @@ -3741,6 +3742,7 @@ check_bidi:
>  fail_rport_msg:
>  	/* return the errno failure code as the only status */
>  	BUG_ON(job->reply_len < sizeof(uint32_t));
> +	job->reply->reply_payload_rcv_len = 0;
>  	job->reply->result = ret;
>  	job->reply_len = sizeof(uint32_t);
>  	fc_bsg_jobdone(job);
> @@ -3797,6 +3799,7 @@ fc_bsg_request_handler(struct request_qu
>  		/* check if we have the msgcode value at least */
>  		if (job->request_len < sizeof(uint32_t)) {
>  			BUG_ON(job->reply_len < sizeof(uint32_t));
> +			job->reply->reply_payload_rcv_len = 0;
>  			job->reply->result = -ENOMSG;
>  			job->reply_len = sizeof(uint32_t);
>  			fc_bsg_jobdone(job);
> _
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
