From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/5] target: Don't let abort handling free pending
 write commands too soon
Date: Thu, 10 Jan 2013 20:21:56 -0800
Message-ID: <1357878116.20882.7.camel@haakon2.linux-iscsi.org>
References: <1357159681-24477-1-git-send-email-roland@kernel.org>
	 <1357159681-24477-2-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36613 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab3AKEWB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2013 23:22:01 -0500
In-Reply-To: <1357159681-24477-2-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

On Wed, 2013-01-02 at 12:47 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> The following sequence happens for write commands (or any other
> commands with a data out phase):
> 
>  - The transport calls target_submit_cmd(), which sets CMD_T_ACTIVE in
>    cmd->transport_state and sets cmd->t_state to TRANSPORT_NEW_CMD.
>  - Things go on transport_generic_new_cmd(), which notices that the
>    command needs to transfer data, so it sets cmd->t_state to
>    TRANSPORT_WRITE_PENDING and calls transport_cmd_check_stop().
>  - transport_cmd_check_stop() clears CMD_T_ACTIVE in cmd->transport_state
>    and returns in the normal case.
>  - Then we continue on to call ->se_tfo->write_pending().
>  - The data comes back from the initiator, and the transport calls
>    target_execute_cmd(), which sets cmd->t_state to TRANSPORT_PROCESSING
>    and calls into the backend to actually write the data.
> 
> At this point, the backend might take a long time to complete the
> command, since it has to do real IO.  If an abort request comes in for
> this command at this point, it will not wait for the command to finish
> since CMD_T_ACTIVE is not set.  Then when the command does finally
> finish, we blow up with use-after-free.
> 
> Avoid this by setting CMD_T_ACTIVE in target_execute_cmd() so that
> transport_wait_for_tasks() waits for the command to finish executing.
> This matches the behavior from before commit 1389533ef944 ("target:
> remove transport_generic_handle_data"), when data was signaled via
> transport_generic_handle_data(), which set CMD_T_ACTIVE because it
> called transport_add_cmd_to_queue().
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---

Applied a CC' to stable with a extra comment wrt to the commit that
introduced this regression.

Thanks again Roland!

--nab

>  drivers/target/target_core_transport.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index c23c76c..1dd9d66 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1688,6 +1688,7 @@ void target_execute_cmd(struct se_cmd *cmd)
>  	}
>  
>  	cmd->t_state = TRANSPORT_PROCESSING;
> +	cmd->transport_state |= CMD_T_ACTIVE;
>  	spin_unlock_irq(&cmd->t_state_lock);
>  
>  	if (!target_handle_task_attr(cmd))


