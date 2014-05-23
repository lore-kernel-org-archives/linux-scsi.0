From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 39/42] qla2xxx: ABTS cause double free of qla_tgt_cmd +.
Date: Thu, 22 May 2014 20:00:12 -0700
Message-ID: <1400814012.9595.37.camel@haakon3.risingtidesystems.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
	 <1397249687-32666-40-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60128 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaEWDA0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2014 23:00:26 -0400
In-Reply-To: <1397249687-32666-40-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: jbottomley@parallels.com, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Hi Saurav + Quinn,

Just curious if this fix needs to be CC'ed to stable as well, or if it's
something that is only triggered with the preceding T10 DIF support
patch in place..?

--nab

On Fri, 2014-04-11 at 16:54 -0400, Saurav Kashyap wrote:
> From: Quinn Tran <quinn.tran@qlogic.com>
> 
> Fix double free problem within qla2xxx driver where
> current code prematurely free qla_tgt_cmd while firmware
> still has the command.  When firmware release the command
> after abort, the code attempt a second free as part of
> command completion processing.
> 
> When TCM start the free process, NULL pointer was hit.
> 
> ------
> WARNING: CPU: 8 PID: 43613 at lib/list_debug.c:62 __list_del_entry+0x82/0xd0()
> list_del corruption. next->prev should be ffff88082b5cfb08, but was 6b6b6b6b6b6b6b6b
> CPU: 8 PID: 43613 Comm: kworker/8:0 Tainted: GF       W  O 3.13.0-rc3-nab_t10dif+ #6
> Hardware name: HP ProLiant DL380p Gen8, BIOS P70 08/20/2012
> Workqueue: events cache_reap
> 000000000000003e ffff88081b2e3c78 ffffffff815a051f 000000000000003e
> ffff88081b2e3cc8 ffff88081b2e3cb8 ffffffff8104fc2c 0000000000000000
> ffff88082b5cfb00 ffff88081c788d00 ffff88082b5d7200 ffff88082b5d3080
> Call Trace:
> [<ffffffff815a051f>] dump_stack+0x49/0x62
> [<ffffffff8104fc2c>] warn_slowpath_common+0x8c/0xc0
> [<ffffffff8104fd16>] warn_slowpath_fmt+0x46/0x50
> [<ffffffff812b6592>] __list_del_entry+0x82/0xd0
> [<ffffffff8106d48c>] process_one_work+0x12c/0x510
> [<ffffffff8106d4d3>] ? process_one_work+0x173/0x510
> [<ffffffff8106ebdf>] worker_thread+0x11f/0x3a0
> [<ffffffff8106eac0>] ? manage_workers+0x170/0x170
> [<ffffffff81074f26>] kthread+0xf6/0x120
> [<ffffffff8109f103>] ? __lock_release+0x133/0x1b0
> [<ffffffff81074e30>] ? __init_kthread_worker+0x70/0x70
> [<ffffffff815aec2c>] ret_from_fork+0x7c/0xb0
> [<ffffffff81074e30>] ? __init_kthread_worker+0x70/0x70
> ---[ end trace dfc05c3f7caf8ebe ]---
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> IP: [<ffffffff8106d391>] process_one_work+0x31/0x510
> -------
> 
> Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c |   29 ++++++++++++++++++++++++++---
>  1 files changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index f24d44c..b1d10f9 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -2681,7 +2681,18 @@ static void qlt_send_term_exchange(struct scsi_qla_host *vha,
>  	rc = __qlt_send_term_exchange(vha, cmd, atio);
>  	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
>  done:
> -	if (rc == 1) {
> +	/*
> +	 * Terminate exchange will tell fw to release any active CTIO
> +	 * that's in FW posession and cleanup the exchange.
> +	 *
> +	 * "cmd->state == QLA_TGT_STATE_ABORTED" means CTIO is still
> +	 * down at FW.  Free the cmd later when CTIO comes back later
> +	 * w/aborted(0x2) status.
> +	 *
> +	 * "cmd->state != QLA_TGT_STATE_ABORTED" means CTIO is already
> +	 * back w/some err.  Free the cmd now.
> +	 */
> +	if ((rc == 1) && (cmd->state != QLA_TGT_STATE_ABORTED)) {
>  		if (!ha_locked && !in_interrupt())
>  			msleep(250); /* just in case */
>  
> @@ -2689,6 +2700,7 @@ done:
>  			qlt_unmap_sg(vha, cmd);
>  		vha->hw->tgt.tgt_ops->free_cmd(cmd);
>  	}
> +	return;
>  }
>  
>  void qlt_free_cmd(struct qla_tgt_cmd *cmd)
> @@ -2906,6 +2918,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
>  		case CTIO_LIP_RESET:
>  		case CTIO_TARGET_RESET:
>  		case CTIO_ABORTED:
> +			/* driver request abort via Terminate exchange */
>  		case CTIO_TIMEOUT:
>  		case CTIO_INVALID_RX_ID:
>  			/* They are OK */
> @@ -2974,9 +2987,18 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
>  			break;
>  		}
>  
> -		if (cmd->state != QLA_TGT_STATE_NEED_DATA)
> +
> +		/* "cmd->state == QLA_TGT_STATE_ABORTED" means
> +		 * cmd is already aborted/terminated, we don't
> +		 * need to terminate again.  The exchange is already
> +		 * cleaned up/freed at FW level.  Just cleanup at driver
> +		 * level.
> +		 */
> +		if ((cmd->state != QLA_TGT_STATE_NEED_DATA) &&
> +			(cmd->state != QLA_TGT_STATE_ABORTED)) {
>  			if (qlt_term_ctio_exchange(vha, ctio, cmd, status))
>  				return;
> +		}
>  	}
>  skip_term:
>  
> @@ -3007,7 +3029,8 @@ skip_term:
>  		    "not return a CTIO complete\n", vha->vp_idx, cmd->state);
>  	}
>  
> -	if (unlikely(status != CTIO_SUCCESS)) {
> +	if (unlikely(status != CTIO_SUCCESS) &&
> +		(cmd->state != QLA_TGT_STATE_ABORTED)) {
>  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01f, "Finishing failed CTIO\n");
>  		dump_stack();
>  	}


