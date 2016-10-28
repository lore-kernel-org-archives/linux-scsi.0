From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] vmw_pvscsi: return SUCCESS for successful command
 aborts
Date: Fri, 28 Oct 2016 13:05:46 -0400 (EDT)
Message-ID: <1520176051.4999962.1477674346240.JavaMail.zimbra@redhat.com>
References: <20161028162726.GA1270@rage>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:49079 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964900AbcJ1RFr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Oct 2016 13:05:47 -0400
In-Reply-To: <20161028162726.GA1270@rage>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Jeffery <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "David Jeffery" <djeffery@redhat.com>
> To: linux-scsi@vger.kernel.org
> Sent: Friday, October 28, 2016 12:27:26 PM
> Subject: [PATCH] vmw_pvscsi: return SUCCESS for successful command aborts
> 
> 
> The vmw_pvscsi driver reports most successful aborts as FAILED to the scsi
> error handler.  This is do to a misunderstanding of how completion_done()
> works
> and its interaction with a successful wait using
> wait_for_completion_timeout().
> The vmw_pvscsi driver is expecting completion_done() to always return true if
> complete() has been called on the completion structure.  But
> completion_done()
> returns true after complete() has been called only if no function like
> wait_for_completion_timeout() has seen the completion and cleared it as part
> of
> successfully waiting for the completion.
> 
> Instead of using completion_done(), vmw_pvscsi should just use the return
> value from wait_for_completion_timeout() to know if the wait timed out or
> not.
> 
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> 
> ---
>  vmw_pvscsi.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -793,6 +793,7 @@ static int pvscsi_abort(struct scsi_cmnd
>  	unsigned long flags;
>  	int result = SUCCESS;
>  	DECLARE_COMPLETION_ONSTACK(abort_cmp);
> +	int done;
>  
>  	scmd_printk(KERN_DEBUG, cmd, "task abort on host %u, %p\n",
>  		    adapter->host->host_no, cmd);
> @@ -824,10 +825,10 @@ static int pvscsi_abort(struct scsi_cmnd
>  	pvscsi_abort_cmd(adapter, ctx);
>  	spin_unlock_irqrestore(&adapter->hw_lock, flags);
>  	/* Wait for 2 secs for the completion. */
> -	wait_for_completion_timeout(&abort_cmp, msecs_to_jiffies(2000));
> +	done = wait_for_completion_timeout(&abort_cmp, msecs_to_jiffies(2000));
>  	spin_lock_irqsave(&adapter->hw_lock, flags);
>  
> -	if (!completion_done(&abort_cmp)) {
> +	if (!done) {
>  		/*
>  		 * Failed to abort the command, unmark the fact that it
>  		 * was requested to be aborted.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Looks correct to me.
Reviewed-by: Laurence Oberman <loberman@redhat.com>
