From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/5] target: Fix use-after-free in LUN RESET handling
Date: Thu, 10 Jan 2013 20:33:48 -0800
Message-ID: <1357878828.20882.10.camel@haakon2.linux-iscsi.org>
References: <1357159681-24477-1-git-send-email-roland@kernel.org>
	 <1357159681-24477-3-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56702 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3AKEdx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2013 23:33:53 -0500
In-Reply-To: <1357159681-24477-3-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

On Wed, 2013-01-02 at 12:47 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> If a backend IO takes a really long then an initiator might abort a
> command, and then when it gives up on the abort, send a LUN reset too,
> all before we process any of the original command or the abort.  (The
> abort will wait for the backend IO to complete too)
> 
> When the backend IO final completes (or fails), the abort handling
> will proceed and queue up a "return aborted status" operation.  Then,
> while that's still pending, the LUN reset might find the original
> command still on the LUN's list of commands and try to return aborted
> status again, which leads to a use-after free when the first
> se_tfo->queue_status call frees the command and then the second
> se_tfo->queue_status call runs.
> 
> Fix this by removing a command from the LUN state_list when we first
> are about to queue aborted status; we shouldn't do anything
> LUN-related after we've started returning status, so this seems like
> the correct thing to do.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---

Nice catch on this TMR corner case w/ long out-standing I/O.

Applied to target-pending/master with a CC' to stable.

--nab

>  drivers/target/target_core_transport.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 1dd9d66..49390d8 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -541,9 +541,6 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
>  
>  void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
>  {
> -	if (!(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
> -		transport_lun_remove_cmd(cmd);
> -
>  	if (transport_cmd_check_stop_to_fabric(cmd))
>  		return;
>  	if (remove)
> @@ -2805,6 +2802,8 @@ void transport_send_task_abort(struct se_cmd *cmd)
>  	}
>  	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
>  
> +	transport_lun_remove_cmd(cmd);
> +
>  	pr_debug("Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x,"
>  		" ITT: 0x%08x\n", cmd->t_task_cdb[0],
>  		cmd->se_tfo->get_task_tag(cmd));


