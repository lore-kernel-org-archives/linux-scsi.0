From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/5] target: Release se_cmd when LUN lookup fails for
 TMR
Date: Thu, 10 Jan 2013 20:39:45 -0800
Message-ID: <1357879185.20882.15.camel@haakon2.linux-iscsi.org>
References: <1357159681-24477-1-git-send-email-roland@kernel.org>
	 <1357159681-24477-4-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1357159681-24477-4-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-01-02 at 12:47 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> When transport_lookup_tmr_lun() fails and we return a task management
> response from target_complete_tmr_failure(), we need to call
> transport_cmd_check_stop_to_fabric() to release the last ref to the
> cmd after calling se_tfo->queue_tm_rsp(), or else we will never remove
> the failed TMR from the session command list (and we'll end up waiting
> forever when trying to tear down the session).
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/target/target_core_transport.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 49390d8..fe6208f 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1393,6 +1393,8 @@ static void target_complete_tmr_failure(struct work_struct *work)
>  
>  	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
>  	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
> +
> +	transport_cmd_check_stop_to_fabric(cmd);
>  }
>  
>  /**

Looks good.  CC'ing to stable as well.

--nab
