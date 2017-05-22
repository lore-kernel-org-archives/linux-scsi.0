From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 13/25] tcm_qla2xxx: Do not allow aborted cmd to advance.
Date: Sun, 21 May 2017 21:45:02 -0700
Message-ID: <1495428302.27407.31.camel@haakon3.risingtidesystems.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
         <20170519215344.2168-14-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59457 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbdEVEpE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2017 00:45:04 -0400
In-Reply-To: <20170519215344.2168-14-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Fri, 2017-05-19 at 14:53 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> In case of hardware queue full, commands can loop between
> TCM stack and tcm_qla2xx shim layers for retry. While command
> is waiting for retry, task mgmt can get ahead and abort the
> cmmand that encountered queue full condition. Fix this by
> dropping the command, if task mgmt has already started the
> command free process.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 7443e4efa3ae..07f8ad001bcb 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -686,6 +686,20 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
>  				struct qla_tgt_cmd, se_cmd);
>  	int xmit_type = QLA_TGT_XMIT_STATUS;
>  
> +	if (cmd->aborted) {
> +		/*
> +		 * Cmd can loop during Q-full. tcm_qla2xxx_aborted_task
> +		 * can get ahead of this cmd. tcm_qla2xxx_aborted_task
> +		 * already kick start the free.
> +		 */
> +		pr_debug(
> +		    "queue_data_in aborted cmd[%p] refcount %d transport_state %x, t_state %x, se_cmd_flags %x\n",
> +		    cmd, kref_read(&cmd->se_cmd.cmd_kref),
> +		    cmd->se_cmd.transport_state, cmd->se_cmd.t_state,
> +		    cmd->se_cmd.se_cmd_flags);
> +		return 0;
> +	}
> +
>  	cmd->bufflen = se_cmd->data_length;
>  	cmd->sg = NULL;
>  	cmd->sg_cnt = 0;

As your comment above mentions, there is a known issue in target-core
when queue-full occurs repeatably and a se_cmd descriptor is explicitly
stopped via session shutdown, TMR ABORT_TASK / LUN_RESET or otherwise.

We hit this scenario a while back in iser-target with iw_cxgb hw, which
due to a separate bug was constantly triggering queue-full under load to
uncover this same case.

So I'm still considering the different approaches to address this in
target-core proper, but don't have a problem with merging this as-is as
it won't logically conflict with any of those changes.

That said:

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>
