From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/5] target: Remove useless if statement
Date: Thu, 10 Jan 2013 20:41:44 -0800
Message-ID: <1357879304.20882.16.camel@haakon2.linux-iscsi.org>
References: <1357159681-24477-1-git-send-email-roland@kernel.org>
	 <1357159681-24477-5-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1357159681-24477-5-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-01-02 at 12:48 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> We do the same thing no matter which way the test goes, so just remove
> the test and do what we're going to do.
> 
> The debug messages printed the wrong value of CMD_T_ACTIVE and don't
> seem particularly useful, remove them too.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/target/target_core_tmr.c | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index c6e0293..d0b4dd9 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -331,18 +331,6 @@ static void core_tmr_drain_state_list(
>  
>  		fe_count = atomic_read(&cmd->t_fe_count);
>  
> -		if (!(cmd->transport_state & CMD_T_ACTIVE)) {
> -			pr_debug("LUN_RESET: got CMD_T_ACTIVE for"
> -				" cdb: %p, t_fe_count: %d dev: %p\n", cmd,
> -				fe_count, dev);
> -			cmd->transport_state |= CMD_T_ABORTED;
> -			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> -
> -			core_tmr_handle_tas_abort(tmr_nacl, cmd, tas, fe_count);
> -			continue;
> -		}
> -		pr_debug("LUN_RESET: Got !CMD_T_ACTIVE for cdb: %p,"
> -			" t_fe_count: %d dev: %p\n", cmd, fe_count, dev);
>  		cmd->transport_state |= CMD_T_ABORTED;
>  		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
>  

Looks OK to drop.  Applying to for-next.

--nab
