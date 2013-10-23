From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 8/8] scsi_error: Escalate to LUN reset if abort fails
Date: Wed, 23 Oct 2013 09:53:55 -0400
Message-ID: <1382536435.3812.156.camel@localhost.localdomain>
References: <1382518282-107606-1-git-send-email-hare@suse.de>
	 <1382518282-107606-9-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab3JWNyl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Oct 2013 09:54:41 -0400
In-Reply-To: <1382518282-107606-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>

On Wed, 2013-10-23 at 10:51 +0200, Hannes Reinecke wrote:
> If a command abort fails there is a fair chance that all other
> aborts will be failing, too.
> So we should be calling LUN reset directly after the first failed
> abort and skip aborting the remaining commands.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index edae9e2..e8bee9f 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1192,18 +1192,20 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
>  						  "0x%p\n", current->comm,
>  						  scmd));
>  		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
> -		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
> -			scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
> -			if (rtn == FAST_IO_FAIL)
> -				scsi_eh_finish_cmd(scmd, done_q);
> -			else
> -				list_move_tail(&scmd->eh_entry, &check_list);
> -		} else
> +		if (rtn == FAILED) {
>  			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting"
>  							  " cmd failed:"
>  							  "0x%p\n",
>  							  current->comm,
>  							  scmd));
> +			list_splice_init(&check_list, work_q);
> +			return list_empty(work_q);
> +		}
> +		scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
> +		if (rtn == FAST_IO_FAIL)
> +			scsi_eh_finish_cmd(scmd, done_q);
> +		else
> +			list_move_tail(&scmd->eh_entry, &check_list);
>  	}
>  
>  	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);

This looks like it should be OK, assuming that we do in fact want to
stop issuing aborts once a call to ->eh_abort_handler() returns FAILED.
I guess it depends upon whether drivers might occasionally return FAILED
due to some temporary condition as opposed to e.g. loss of link.

(I've been having a discussion with the vmw_pvscsi driver maintainer
regarding their implementation of ->eh_abort_handler(), which might
have to change to return FAILED if the hypervisor side doesn't respond
to the abort request fast enough, instead of returning SUCCESS and then
later completing the request when the abort actually completes.  So I
think that a temporary condition that results in returning FAILED is
possible...)

Note that this portion of the patch set would change the behavior
regardless of whether eh_deadline was enabled.

-Ewan



