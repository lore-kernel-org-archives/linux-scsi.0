From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] vmw_pvscsi: return SUCCESS for successful command
 aborts
Date: Fri, 28 Oct 2016 13:24:44 -0400
Message-ID: <1477675484.17595.47.camel@localhost.localdomain>
References: <20161028162726.GA1270@rage>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761275AbcJ1RYp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Oct 2016 13:24:45 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 14C5561B98
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2016 17:24:45 +0000 (UTC)
In-Reply-To: <20161028162726.GA1270@rage>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Jeffery <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2016-10-28 at 12:27 -0400, David Jeffery wrote:
> The vmw_pvscsi driver reports most successful aborts as FAILED to the scsi
> error handler.  This is do to a misunderstanding of how completion_done() works
> and its interaction with a successful wait using wait_for_completion_timeout().
> The vmw_pvscsi driver is expecting completion_done() to always return true if
> complete() has been called on the completion structure.  But completion_done()
> returns true after complete() has been called only if no function like
> wait_for_completion_timeout() has seen the completion and cleared it as part of
> successfully waiting for the completion.
> 
> Instead of using completion_done(), vmw_pvscsi should just use the return
> value from wait_for_completion_timeout() to know if the wait timed out or not.
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

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


