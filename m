From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 7/7] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Fri, 20 Sep 2013 15:48:37 +0800
Message-ID: <523BFDD5.9080007@cn.fujitsu.com>
References: <1372661455-122384-1-git-send-email-hare@suse.de> <1372661455-122384-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54855 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab3ITHsG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Sep 2013 03:48:06 -0400
In-Reply-To: <1372661455-122384-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>

Hi, Hannes:

On 07/01/2013 02:50 PM, Hannes Reinecke wrote:
> This patchs adds an 'eh_deadline' sysfs attribute to the scsi
> host which limits the overall runtime of the SCSI EH.
> The 'eh_deadline' value is stored in the now obsolete field
> 'resetting'.
> When a command is failed the start time of the EH is stored
> in 'last_reset'. If the overall runtime of the SCSI EH is longer
> than last_reset + eh_deadline, the EH is short-circuited and
> falls through to issue a host reset only.

There is one thing during my test: if I want to stop EH ASAP, I can
only set the 'eh_deadline' as the minimum value: 1 second. But on my
box, since scsi command times out, it takes less than 1 second before
the first check point - comparingthe overall runtime of the SCSI EH
with last_reset + eh_deadline as you said. So, the EH could only be
stopped once it spends more than 1 second before the check point
rather than stopping at the first time.

This problem is also existed in your second patchset "New EH command
timeout handler" - it spends less than 1 second before the check
point in scsi_abort_command().

So, should a special handling be considered for 1 second? E.g., we
just past eh deadline when 1 second is set even if 1 second hasn't
been reached. Or, should 0 second mean stopping EH ASAP rather than
disabling eh_deadline?

> Signed-off-by: Hannes Reinecke<hare@suse.de>
<snip>
> @@ -1059,14 +1107,28 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
>   	struct scsi_cmnd *scmd, *next;
>   	LIST_HEAD(check_list);
>   	int rtn;
> +	struct Scsi_Host *shost;
> +	unsigned long flags;
>
>   	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>   		if (!(scmd->eh_eflags&  SCSI_EH_CANCEL_CMD))
>   			continue;
> +		shost = scmd->device->host;
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		if (scsi_host_eh_past_deadline(shost)) {

Especially speaking: could we remove this check point? In other
words, could we keep aborting? According to my test,
scsi_try_to_abort_cmd() takes so little time that we can ignore it.
So, keeping aborting won't reduce the performance of stopping EH,
and it is worth trying.

Also, I'd like removing the check point in your new added
scmd_eh_abort_handler() in your second patchset.

Thanks,
Ren

>
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			list_splice_init(&check_list, work_q);
> +			SCSI_LOG_ERROR_RECOVERY(3,
> +				shost_printk(KERN_INFO, shost,
> +					    "skip %s, past eh deadline\n",
> +					     __func__));
> +			return list_empty(work_q);
> +		}
> +		spin_unlock_irqrestore(shost->host_lock, flags);
>   		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
>   						  "0x%p\n", current->comm,
>   						  scmd));
> -		rtn = scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd);
> +		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
>   		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
>   			scmd->eh_eflags&= ~SCSI_EH_CANCEL_CMD;
>   			if (rtn == FAST_IO_FAIL)
