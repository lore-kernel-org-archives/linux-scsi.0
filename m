From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Fix SATA ATAPI error handling
Date: Thu, 26 May 2005 23:58:00 -0400
Message-ID: <42969AC8.6070904@pobox.com>
References: <42418B10.6090009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:48604 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261407AbVE0D6D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 23:58:03 -0400
In-Reply-To: <42418B10.6090009@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, Jens Axboe <axboe@suse.de>, Kurt Garloff <garloff@suse.de>

Hannes Reinecke wrote:
> +static void scsi_invoke_strategy_handler(struct Scsi_Host *shost)
> +{
> +	int rtn;
> +	struct list_head *lh, *lh_sf;
> +	struct scsi_cmnd *scmd;
> +	unsigned long flags;
> +	LIST_HEAD(eh_work_q);
> +	LIST_HEAD(eh_done_q);
> +
> +	rtn = shost->hostt->eh_strategy_handler(shost);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +	SCSI_LOG_ERROR_RECOVERY(1, scsi_eh_prt_fail_stats(shost, &eh_work_q));
> +
> +	list_for_each_safe(lh, lh_sf, &eh_work_q) {
> +		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
> +
> +		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD) ||
> +		    !SCSI_SENSE_VALID(scmd))
> +			continue;
> +		scmd->retries = scmd->allowed;
> +		scsi_eh_finish_cmd(scmd, &eh_done_q);
> +	}
> +
> +	if (!list_empty(&eh_work_q))
> +		if (!scsi_eh_abort_cmds(&eh_work_q, &eh_done_q))
> +			scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);


The scsi_eh_abort_cmds() call doesn't do much, since all calls to 
scsi_try_to_abort_cmd() will fail due to libata's lack of EH abort handler.

The latter code will print "aborting cmd failed" for the command, and 
not much else.

	Jeff


